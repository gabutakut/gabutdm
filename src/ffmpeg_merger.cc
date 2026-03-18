/*
* Copyright (c) {2026} torikulhabib (https://github.com/gabutakut)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: torikulhabib <torik.habib@Gmail.com>
*/

#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef __cplusplus
#include <atomic>
extern "C" {
#endif

#include <libavformat/avformat.h>
#include <libavcodec/avcodec.h>
#include <libavutil/avutil.h>
#include <libavutil/log.h>
#include <libavutil/dict.h>
#include <libavutil/mathematics.h>
#include "ffmpeg_merger.h"

#define FFM_EXPORT __attribute__((visibility("default")))
#define MAX_STREAMS 32

FFM_EXPORT FfmpegReader* ffm_reader_create() {
    return (FfmpegReader*)calloc(1, sizeof(FfmpegReader));
}

FFM_EXPORT int ffm_reader_open_path(FfmpegReader* r, const char* path) {
    if (!r || !path) {
        return -1;
    }
    r->width = 0;
    r->height = 0;
    r->success = 0;

    AVFormatContext* fmt_ctx = NULL;
    av_log_set_level(AV_LOG_QUIET);

    const AVInputFormat* ifmt = av_find_input_format("mpegts");

    AVDictionary *opts = NULL;
    av_dict_set(&opts, "probesize", "20000000", 0);
    av_dict_set(&opts, "analyzeduration", "20000000", 0);
    av_dict_set(&opts, "scan_all_pmts", "1", 0);

    if (avformat_open_input(&fmt_ctx, path, ifmt, &opts) < 0) {
        if (opts) {
            av_dict_free(&opts);
        }
        return -2;
    }

    if (avformat_find_stream_info(fmt_ctx, NULL) >= 0) {
        for (int i = 0; i < (int)fmt_ctx->nb_streams; i++) {
            AVCodecParameters *p = fmt_ctx->streams[i]->codecpar;
            if (p->codec_type == AVMEDIA_TYPE_VIDEO) {
                r->width = p->width;
                r->height = p->height;
                if (r->width > 1 && r->height > 1) {
                    r->success = 1;
                    break;
                }
            }
        }
    }

    if (opts) {
        av_dict_free(&opts);
    }
    avformat_close_input(&fmt_ctx);
    return r->success ? 0 : -3;
}

FFM_EXPORT int ffm_reader_open_buffer(FfmpegReader* r, const unsigned char* data, size_t size) {
    if (!r || !data || size == 0) {
        return -1;
    }
    r->width = 0;
    r->height = 0;
    r->success = 0;

    AVFormatContext* fmt_ctx = avformat_alloc_context();
    if (!fmt_ctx) {
        return -2;
    }
    struct BufferData {
        const unsigned char* data;
        size_t size;
        size_t pos;
    };

    BufferData bd = { data, size, 0 };

    auto read_packet = [](void* opaque, uint8_t* buf, int buf_size) -> int {
        BufferData* bd = (BufferData*)opaque;

        if (bd->pos >= bd->size) {
            return AVERROR_EOF;
        }
        int remaining = bd->size - bd->pos;
        int to_read = buf_size < remaining ? buf_size : remaining;

        memcpy(buf, bd->data + bd->pos, to_read);
        bd->pos += to_read;

        return to_read;
    };

    uint8_t* avio_buffer = (uint8_t*)av_malloc(4096);
    AVIOContext* avio_ctx = avio_alloc_context(avio_buffer, 4096, 0, &bd, read_packet, NULL, NULL);

    fmt_ctx->pb = avio_ctx;
    fmt_ctx->flags |= AVFMT_FLAG_CUSTOM_IO;

    const AVInputFormat* ifmt = av_find_input_format("mpegts");

    if (avformat_open_input(&fmt_ctx, NULL, ifmt, NULL) < 0) {
        av_free(avio_ctx->buffer);
        avio_context_free(&avio_ctx);
        avformat_free_context(fmt_ctx);
        return -3;
    }

    if (avformat_find_stream_info(fmt_ctx, NULL) >= 0) {
        for (int i = 0; i < (int)fmt_ctx->nb_streams; i++) {
            AVCodecParameters *p = fmt_ctx->streams[i]->codecpar;
            if (p->codec_type == AVMEDIA_TYPE_VIDEO) {
                r->width = p->width;
                r->height = p->height;
                if (r->width > 1 && r->height > 1) {
                    r->success = 1;
                    break;
                }
            }
        }
    }

    avformat_close_input(&fmt_ctx);
    av_free(avio_ctx->buffer);
    avio_context_free(&avio_ctx);
    return r->success ? 0 : -4;
}

FFM_EXPORT int ffm_reader_validate_path(FfmpegReader* r, const char* path) {
    if (!r || !path) {
        return -1;
    }
    AVFormatContext* fmt_ctx = NULL;
    AVPacket pkt;
    av_log_set_level(AV_LOG_QUIET);
    const AVInputFormat* ifmt = av_find_input_format("mpegts");
    if (avformat_open_input(&fmt_ctx, path, ifmt, NULL) < 0) {
        return -2;
    }
    if (avformat_find_stream_info(fmt_ctx, NULL) < 0) {
        avformat_close_input(&fmt_ctx);
        return -3;
    }

    int video_stream = -1;
    int audio_stream = -1;
    for (unsigned int i = 0; i < fmt_ctx->nb_streams; i++) {
        AVCodecParameters *p = fmt_ctx->streams[i]->codecpar;
        if (p->codec_type == AVMEDIA_TYPE_VIDEO && video_stream < 0) {
            video_stream = i;
        }
        if (p->codec_type == AVMEDIA_TYPE_AUDIO && audio_stream < 0) {
            audio_stream = i;
        }
    }

    if (video_stream < 0 && audio_stream < 0) {
        avformat_close_input(&fmt_ctx);
        return -4;
    }

    int valid_packets = 0;
    while (av_read_frame(fmt_ctx, &pkt) >= 0) {
        if (pkt.stream_index == video_stream || pkt.stream_index == audio_stream) {
            if (pkt.size > 0) {
                valid_packets++;
            }
        }
        av_packet_unref(&pkt);
        if (valid_packets >= 10) {
            break;
        }
    }
    avformat_close_input(&fmt_ctx);
    if (valid_packets == 0) {
        return -5;
    }
    return 0;
}

FFM_EXPORT int ffm_reader_get_width(FfmpegReader* r) {
    return r ? r->width : 0;
}

FFM_EXPORT int ffm_reader_get_height(FfmpegReader* r){
    return r ? r->height : 0;
}

FFM_EXPORT int ffm_reader_get_success(FfmpegReader* r){
    return r ? r->success : 0;
}

FFM_EXPORT void ffmpeg_reader_unref(FfmpegReader* r){
    if (r) {
        free(r);
    }
}

struct FfmpegMerger {
#ifdef __cplusplus
    std::atomic<float> progress{0.0f};
    std::atomic<int> total_pieces{0};
#else
    float progress;
    int total_pieces;
#endif
    uint8_t* bitfield;
    char hex_output[8192];
    int stream_map[MAX_STREAMS];
};

FFM_EXPORT FfmpegMerger* ffm_merger_create() { 
    FfmpegMerger* m = (FfmpegMerger*)calloc(1, sizeof(FfmpegMerger));
#ifdef __cplusplus
    m->progress.store(0.0f);
    m->total_pieces.store(0);
#else
    m->progress = 0.0f;
    m->total_pieces = 0;
#endif
    return m; 
}

FFM_EXPORT void ffmpeg_merger_unref(FfmpegMerger* m) { 
    if (m) { 
        if (m->bitfield) {
            free(m->bitfield); 
        }
        free(m); 
    } 
}

FFM_EXPORT float ffm_get_last_progress(FfmpegMerger* m) { 
#ifdef __cplusplus
    return m ? m->progress.load() : 0.0f; 
#else
    return m ? m->progress : 0.0f;
#endif
}

FFM_EXPORT const char* ffm_get_bitfield_hex(FfmpegMerger* m) {
    if (!m || !m->bitfield) {
        return "00";
    }
#ifdef __cplusplus
    int total = m->total_pieces.load();
#else
    int total = m->total_pieces;
#endif
    int bytes = (total + 7) / 8;
    for (int i = 0; i < bytes && i < 4095; i++) {
        uint8_t v = 0;
        for (int b = 0; b < 8; b++) {
            int idx = i * 8 + b;
            if (idx < total && m->bitfield[idx]) {
                v |= (1 << (7 - b));
            }
        }
        sprintf(m->hex_output + i * 2, "%02x", v);
    }
    return m->hex_output;
}

FFM_EXPORT int ffm_merge_files(FfmpegMerger* m, const char **paths, int count, const char *output_path) {
    if (!m || count < 1 || !paths || !output_path) {
        return -1;
    }
    av_log_set_level(AV_LOG_QUIET);
    
#ifdef __cplusplus
    m->total_pieces.store(count);
    m->progress.store(0.0f);
#else
    m->total_pieces = count;
    m->progress = 0.0f;
#endif

    if (m->bitfield) {
        free(m->bitfield);
    }
    m->bitfield = (uint8_t*)calloc(count, 1);

    AVFormatContext *out_ctx = NULL;
    AVFormatContext *probe_ctx = NULL;
    const AVInputFormat *ifmt = av_find_input_format("mpegts");

    if (avformat_open_input(&probe_ctx, paths[0], ifmt, NULL) < 0) {
        return -3;
    }
    avformat_find_stream_info(probe_ctx, NULL);
    avformat_alloc_output_context2(&out_ctx, NULL, "mp4", output_path);

    memset(m->stream_map, -1, sizeof(m->stream_map));
    int out_index = 0;
    for (unsigned int i = 0; i < (unsigned int)probe_ctx->nb_streams; i++) {
        AVStream *in_s = probe_ctx->streams[i];
        if (in_s->codecpar->codec_type == AVMEDIA_TYPE_VIDEO || in_s->codecpar->codec_type == AVMEDIA_TYPE_AUDIO) {
            AVStream *out_s = avformat_new_stream(out_ctx, NULL);
            avcodec_parameters_copy(out_s->codecpar, in_s->codecpar);
            out_s->codecpar->codec_tag = 0;
            m->stream_map[i] = out_index++;
        }
    }
    avformat_close_input(&probe_ctx);

    if (avio_open(&out_ctx->pb, output_path, AVIO_FLAG_WRITE) < 0) {
        return -8;
    }
    AVDictionary *out_opts = NULL;
    av_dict_set(&out_opts, "movflags", "faststart", 0);
    
    int dummy_ret = avformat_write_header(out_ctx, &out_opts);
    (void)dummy_ret; 
    
    if (out_opts) {
        av_dict_free(&out_opts);
    }
    int64_t master_offset_us = 0;
    int64_t last_mux_dts[MAX_STREAMS];
    for (int j = 0; j < MAX_STREAMS; j++) {
        last_mux_dts[j] = AV_NOPTS_VALUE;
    }
    for (int file_index = 0; file_index < count; file_index++) {
        AVFormatContext *in_ctx = NULL;
        AVDictionary *in_opts = NULL;
        AVPacket pkt;
        int64_t file_start_pts[MAX_STREAMS], file_start_dts[MAX_STREAMS];
        int64_t current_file_max_dur_us = 0;

        av_dict_set(&in_opts, "fflags", "+genpts+igndts+discardcorrupt", 0);
        av_dict_set(&in_opts, "probesize", "32000000", 0);

        if (avformat_open_input(&in_ctx, paths[file_index], ifmt, &in_opts) < 0) {
            if (in_opts) {
                av_dict_free(&in_opts);
            }
            goto next_file;
        }
        
        avformat_find_stream_info(in_ctx, NULL);
        for (int j = 0; j < MAX_STREAMS; j++) {
            file_start_pts[j] = file_start_dts[j] = AV_NOPTS_VALUE;
        }
        while (av_read_frame(in_ctx, &pkt) >= 0) {
            int in_idx = pkt.stream_index;
            if (in_idx >= MAX_STREAMS || m->stream_map[in_idx] < 0) { 
                av_packet_unref(&pkt); 
                continue; 
            }
            int out_idx = m->stream_map[in_idx];
            AVStream *in_s = in_ctx->streams[in_idx], *out_s = out_ctx->streams[out_idx];

            if (file_start_pts[in_idx] == AV_NOPTS_VALUE) {
                file_start_pts[in_idx] = pkt.pts;
            }
            if (file_start_dts[in_idx] == AV_NOPTS_VALUE) {
                file_start_dts[in_idx] = pkt.dts;
            }
            int64_t rel_pts = pkt.pts - file_start_pts[in_idx];
            int64_t rel_dts = (pkt.dts == AV_NOPTS_VALUE) ? rel_pts : (pkt.dts - file_start_dts[in_idx]);
            int64_t global_off = av_rescale_q(master_offset_us, AV_TIME_BASE_Q, out_s->time_base);
            
            pkt.pts = av_rescale_q(rel_pts, in_s->time_base, out_s->time_base) + global_off;
            pkt.dts = av_rescale_q(rel_dts, in_s->time_base, out_s->time_base) + global_off;

            int64_t dur = (pkt.duration > 0) ? pkt.duration : av_rescale_q(1, av_inv_q(in_s->r_frame_rate), in_s->time_base);
            pkt.duration = av_rescale_q(dur, in_s->time_base, out_s->time_base);

            if (last_mux_dts[out_idx] != AV_NOPTS_VALUE && pkt.dts <= last_mux_dts[out_idx]) {
                pkt.dts = last_mux_dts[out_idx] + 1;
            }
            if (pkt.pts < pkt.dts) {
                pkt.pts = pkt.dts;
            }
            last_mux_dts[out_idx] = pkt.dts;

            int64_t pkt_end_us = av_rescale_q(rel_pts + dur, in_s->time_base, AV_TIME_BASE_Q);
            if (in_s->codecpar->codec_type == AVMEDIA_TYPE_VIDEO) {
                if (pkt_end_us > current_file_max_dur_us) {
                    current_file_max_dur_us = pkt_end_us;
                }
            } else if (current_file_max_dur_us == 0) {
                if (pkt_end_us > current_file_max_dur_us) {
                    current_file_max_dur_us = pkt_end_us;
                }
            }
            pkt.stream_index = out_idx;
            av_interleaved_write_frame(out_ctx, &pkt);
            av_packet_unref(&pkt);
        }
        if (current_file_max_dur_us > 0 ) {
            master_offset_us += current_file_max_dur_us;
        }
        avformat_close_input(&in_ctx);
        m->bitfield[file_index] = 1;

    next_file:
        if (in_opts) {
            av_dict_free(&in_opts);
        }
#ifdef __cplusplus
        m->progress.store((float)(file_index + 1) / (float)count);
#else
        m->progress = (float)(file_index + 1) / (float)count;
#endif
    }
    av_write_trailer(out_ctx);
    avio_closep(&out_ctx->pb);
    avformat_free_context(out_ctx);
    return 0;
}
#ifdef __cplusplus
}
#endif