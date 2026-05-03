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

#include <libswscale/swscale.h>
#include <libswresample/swresample.h>
#include <libavutil/audio_fifo.h>
#include <libavutil/opt.h>
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

static uint8_t* ffm_get_thumbnail_internal(const unsigned char* data, size_t size, int* out_w, int* out_h, int* out_stride, const char* force_format) {
    if (!data || size == 0 || !out_w || !out_h || !out_stride) {
        return NULL;
    }

    struct BufCtx { const unsigned char* data; size_t size; size_t pos; };
    BufCtx bc = { data, size, 0 };

    auto read_fn = [](void* opaque, uint8_t* buf, int buf_size) -> int {
        BufCtx* bc = (BufCtx*)opaque;
        if (bc->pos >= bc->size) return AVERROR_EOF;
        int remaining = (int)(bc->size - bc->pos);
        int to_read   = buf_size < remaining ? buf_size : remaining;
        memcpy(buf, bc->data + bc->pos, to_read);
        bc->pos += (size_t)to_read;
        return to_read;
    };

    auto seek_fn = [](void* opaque, int64_t offset, int whence) -> int64_t {
        BufCtx* bc = (BufCtx*)opaque;
        int64_t new_pos = 0;
        switch (whence) {
            case SEEK_SET: new_pos = offset; break;
            case SEEK_CUR: new_pos = (int64_t)bc->pos + offset; break;
            case SEEK_END: new_pos = (int64_t)bc->size + offset; break;
            case AVSEEK_SIZE: return (int64_t)bc->size;
            default: return -1;
        }
        if (new_pos < 0) return -1;
        if (new_pos > (int64_t)bc->size) {
            new_pos = (int64_t)bc->size;
        }
        bc->pos = (size_t)new_pos;
        return new_pos;
    };

    uint8_t* avio_buf = (uint8_t*)av_malloc(8192);
    if (!avio_buf) {
        return NULL;
    }
    AVIOContext* avio_ctx = avio_alloc_context(avio_buf, 8192, 0, &bc, read_fn, NULL, seek_fn);
    if (!avio_ctx) {
        av_free(avio_buf);
        return NULL;
    }

    AVFormatContext* ifmt_ctx = avformat_alloc_context();
    if (!ifmt_ctx) {
        av_free(avio_ctx->buffer);
        avio_context_free(&avio_ctx);
        return NULL;
    }
    ifmt_ctx->pb = avio_ctx;
    ifmt_ctx->flags |= AVFMT_FLAG_CUSTOM_IO;
    ifmt_ctx->flags |= AVFMT_FLAG_IGNIDX;

    const AVInputFormat* ifmt = force_format? av_find_input_format(force_format) : NULL;
    AVCodecContext* codec_ctx = NULL;
    const AVCodec* codec = NULL;
    AVFrame* frame = NULL;
    AVFrame* frame_rgb = NULL;
    AVPacket* pkt = NULL;
    struct SwsContext* sws_ctx = NULL;
    uint8_t* out_buffer = NULL;
    int video_idx = -1;
    bool frame_finished = false;
    bool sws_ok = false;
    bool fmt_opened = false;

    pkt = av_packet_alloc();
    if (!pkt) {
        goto fail;
    }
    {
        AVDictionary* opts = NULL;
        av_dict_set(&opts, "fflags", "fastseek", 0);
        if (avformat_open_input(&ifmt_ctx, NULL, ifmt, &opts) < 0) {
            av_dict_free(&opts);
            goto fail;
        }
        av_dict_free(&opts);
    }
    fmt_opened = true;

    if (avformat_find_stream_info(ifmt_ctx, NULL) < 0) {
        goto fail;
    }
    for (unsigned int i = 0; i < ifmt_ctx->nb_streams; i++) {
        if (ifmt_ctx->streams[i]->codecpar->codec_type == AVMEDIA_TYPE_VIDEO) {
            video_idx = (int)i;
            break;
        }
    }
    if (video_idx == -1) {
        goto fail;
    }
    codec = avcodec_find_decoder(ifmt_ctx->streams[video_idx]->codecpar->codec_id);
    if (!codec) {
        goto fail;
    }
    codec_ctx = avcodec_alloc_context3(codec);
    if (!codec_ctx) {
        goto fail;
    }
    if (avcodec_parameters_to_context(codec_ctx, ifmt_ctx->streams[video_idx]->codecpar) < 0) {
        goto fail;
    }
    codec_ctx->thread_count = 1;
    codec_ctx->thread_type = 0;
    codec_ctx->err_recognition = AV_EF_IGNORE_ERR | AV_EF_CAREFUL;
    codec_ctx->flags2 |= AV_CODEC_FLAG2_FAST;

    if (avcodec_open2(codec_ctx, codec, NULL) < 0) {
        goto fail;
    }
    frame = av_frame_alloc();
    frame_rgb = av_frame_alloc();
    if (!frame || !frame_rgb) {
        goto fail;
    }

    {
        int64_t seek_target = 0;
        int64_t bitrate = ifmt_ctx->bit_rate;

        if (bitrate > 0) {
            int64_t readable_duration = ((int64_t)size * 8LL * AV_TIME_BASE) / bitrate;
            seek_target = readable_duration / 2;
            int64_t total_duration = ifmt_ctx->duration;
            if (total_duration > 0 && seek_target > total_duration) {
                seek_target = total_duration / 2;
            }
            if (seek_target < 1LL * AV_TIME_BASE) {
                seek_target = 1LL * AV_TIME_BASE;
            }
            if (seek_target > 60LL * AV_TIME_BASE) {
                seek_target = 60LL * AV_TIME_BASE;
            }
        } else {
            seek_target = 10LL * AV_TIME_BASE;
        }

        av_seek_frame(ifmt_ctx, -1, seek_target, AVSEEK_FLAG_BACKWARD);
        avcodec_flush_buffers(codec_ctx);
    }

    {
        int consecutive_errors = 0;
        while (av_read_frame(ifmt_ctx, pkt) >= 0) {
            if (pkt->stream_index != video_idx) {
                av_packet_unref(pkt);
                continue;
            }

            int ret = avcodec_send_packet(codec_ctx, pkt);
            av_packet_unref(pkt);

            if (ret < 0) {
                if (++consecutive_errors > 100) {
                    break;
                }
                continue;
            }

            ret = avcodec_receive_frame(codec_ctx, frame);
            if (ret == 0) {
                if (frame->width  > 0 && frame->height > 0 && frame->format != AV_PIX_FMT_NONE && frame->format >= 0) {
                    frame_finished = true;
                    break;
                }
                av_frame_unref(frame);
            }
            consecutive_errors = 0;
        }
    }

    if (!frame_finished) {
        avcodec_send_packet(codec_ctx, NULL);
        if (avcodec_receive_frame(codec_ctx, frame) == 0 && frame->width  > 0 && frame->height > 0 && frame->format != AV_PIX_FMT_NONE && frame->format >= 0) {
            frame_finished = true;
        }
    }
    if (!frame_finished) {
        goto fail;
    }

    frame_rgb->format = AV_PIX_FMT_RGB24;
    frame_rgb->width  = frame->width;
    frame_rgb->height = frame->height;
    if (av_frame_get_buffer(frame_rgb, 1) < 0) {
        goto fail;
    }
    if (av_frame_make_writable(frame_rgb) < 0) {
        goto fail;
    }
    sws_ctx = sws_getContext(frame->width, frame->height, (AVPixelFormat)frame->format, frame->width, frame->height, AV_PIX_FMT_RGB24, SWS_BILINEAR, NULL, NULL, NULL);
    if (!sws_ctx) {
        goto fail;
    }
    if (sws_scale(sws_ctx, (const uint8_t* const*)frame->data, frame->linesize, 0, frame->height, frame_rgb->data, frame_rgb->linesize) <= 0) {
        goto fail;
    }
    *out_w = frame_rgb->width;
    *out_h = frame_rgb->height;
    *out_stride = frame_rgb->linesize[0];

    {
        size_t total = (size_t)(*out_stride) * (size_t)(*out_h);
        out_buffer = (uint8_t*)malloc(total);
        if (!out_buffer) {
            goto fail;
        }
        memcpy(out_buffer, frame_rgb->data[0], total);
    }
    sws_ok = true;

fail:
    if (sws_ctx) {
        sws_freeContext(sws_ctx);
    }
    if (frame) {
        av_frame_free(&frame);
    }
    if (frame_rgb) {
        av_frame_free(&frame_rgb);
    }
    if (codec_ctx) {
        avcodec_free_context(&codec_ctx);
    }
    if (pkt) {
        av_packet_free(&pkt);
    }
    if (fmt_opened) {
        avformat_close_input(&ifmt_ctx);
    } else if (ifmt_ctx) {
        avformat_free_context(ifmt_ctx);
        ifmt_ctx = NULL;
    }
    if (avio_ctx) {
        av_free(avio_ctx->buffer);
        avio_ctx->buffer = NULL;
        avio_context_free(&avio_ctx);
    }
    if (!sws_ok && out_buffer) {
        free(out_buffer);
        out_buffer = NULL;
        *out_w = *out_h = *out_stride = 0;
    }
    return out_buffer;
}

FFM_EXPORT uint8_t* ffm_reader_ts_thumbnail_from_buffer(FfmpegReader* r, const unsigned char* data, size_t size, int* out_w, int* out_h, int* out_stride) {
    (void)r;
    return ffm_get_thumbnail_internal(data, size, out_w, out_h, out_stride, "mpegts");
}

FFM_EXPORT uint8_t* ffm_reader_auto_thumbnail_from_buffer(FfmpegReader* r, const unsigned char* data, size_t size, int* out_w, int* out_h, int* out_stride) {
    (void)r;
    return ffm_get_thumbnail_internal(data, size, out_w, out_h, out_stride, "");
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

FFM_EXPORT int ffm_combine_file(FfmpegMerger* m, const char* video_path, const char* audio_path, const char* output_path) {
    if (!m || !video_path || !audio_path || !output_path) {
        return -1;
    }
    av_log_set_level(AV_LOG_QUIET);

    AVFormatContext *ifmt_ctx_v = NULL, *ifmt_ctx_a = NULL, *ofmt_ctx = NULL;
    AVDictionary *opts = NULL;
    AVPacket pkt;
    int video_stream_idx = -1, audio_stream_idx = -1;
    int out_v_idx = -1, out_a_idx = -1;
    int ret = 0;
    int64_t total_duration = 0;
    int64_t last_dts[2] = { AV_NOPTS_VALUE, AV_NOPTS_VALUE };

#ifdef __cplusplus
    m->total_pieces.store(2);
    m->progress.store(0.0f);
#else
    m->total_pieces = 2;
    m->progress = 0.0f;
#endif

    if (m->bitfield) {
        free(m->bitfield);
    }
    m->bitfield = (uint8_t*)calloc(2, 1);

    if (avformat_open_input(&ifmt_ctx_v, video_path, NULL, NULL) < 0) {
        return -2;
    }
    if (avformat_find_stream_info(ifmt_ctx_v, NULL) < 0) {
        ret = -3;
        goto cleanup;
    }
    if (avformat_open_input(&ifmt_ctx_a, audio_path, NULL, NULL) < 0) {
        ret = -4;
        goto cleanup;
    }
    if (avformat_find_stream_info(ifmt_ctx_a, NULL) < 0) {
        ret = -5;
        goto cleanup;
    }
    total_duration = ifmt_ctx_v->duration;
    if (ifmt_ctx_a->duration > total_duration) {
        total_duration = ifmt_ctx_a->duration;
    }
    avformat_alloc_output_context2(&ofmt_ctx, NULL, "mp4", output_path);
    if (!ofmt_ctx) {
        ret = -6;
        goto cleanup;
    }

    for (unsigned int i = 0; i < ifmt_ctx_v->nb_streams; i++) {
        if (ifmt_ctx_v->streams[i]->codecpar->codec_type == AVMEDIA_TYPE_VIDEO) {
            video_stream_idx = i;
            AVStream *out_s = avformat_new_stream(ofmt_ctx, NULL);
            avcodec_parameters_copy(out_s->codecpar, ifmt_ctx_v->streams[i]->codecpar);
            out_s->codecpar->codec_tag = 0;
            out_v_idx = out_s->index;
            break;
        }
    }

    for (unsigned int i = 0; i < ifmt_ctx_a->nb_streams; i++) {
        if (ifmt_ctx_a->streams[i]->codecpar->codec_type == AVMEDIA_TYPE_AUDIO) {
            audio_stream_idx = i;
            AVStream *out_s = avformat_new_stream(ofmt_ctx, NULL);
            avcodec_parameters_copy(out_s->codecpar, ifmt_ctx_a->streams[i]->codecpar);
            out_s->codecpar->codec_tag = 0;
            out_a_idx = out_s->index;
            break;
        }
    }

    if (out_v_idx < 0) {
        ret = -7;
        goto cleanup;
    }
    if (out_a_idx < 0) {
        av_log(NULL, AV_LOG_WARNING, "ffm_combine_file: no audio stream found in '%s', output will be video-only\n", audio_path);
    }

    if (!(ofmt_ctx->oformat->flags & AVFMT_NOFILE)) {
        if (avio_open(&ofmt_ctx->pb, output_path, AVIO_FLAG_WRITE) < 0) {
            ret = -8;
            goto cleanup;
        }
    }
    av_dict_set(&opts, "movflags", "faststart", 0);
    ret = avformat_write_header(ofmt_ctx, &opts);
    if (opts) {
        av_dict_free(&opts);
    }
    if (ret < 0) {
        goto cleanup;
    }
    while (av_read_frame(ifmt_ctx_v, &pkt) >= 0) {
        if (pkt.stream_index == video_stream_idx) {
            if (total_duration > 0 && pkt.pts != AV_NOPTS_VALUE) {
                int64_t cur = av_rescale_q(pkt.pts, ifmt_ctx_v->streams[video_stream_idx]->time_base, AV_TIME_BASE_Q);
                float p = ((float)cur / (float)total_duration) * 0.5f;
#ifdef __cplusplus
                m->progress.store(p);
#else
                m->progress = p;
#endif
            }
            pkt.stream_index = out_v_idx;
            av_packet_rescale_ts(&pkt, ifmt_ctx_v->streams[video_stream_idx]->time_base, ofmt_ctx->streams[out_v_idx]->time_base);
            pkt.pos = -1;

            if (last_dts[0] != AV_NOPTS_VALUE && pkt.dts != AV_NOPTS_VALUE &&
                pkt.dts <= last_dts[0]) {
                pkt.dts = last_dts[0] + 1;
            }
            if (pkt.pts != AV_NOPTS_VALUE && pkt.dts != AV_NOPTS_VALUE &&
                pkt.pts < pkt.dts) {
                pkt.pts = pkt.dts;
            }
            if (pkt.dts != AV_NOPTS_VALUE) {
                last_dts[0] = pkt.dts;
            }
            av_interleaved_write_frame(ofmt_ctx, &pkt);
        }
        av_packet_unref(&pkt);
    }
    m->bitfield[0] = 1;
    if (out_a_idx >= 0 && audio_stream_idx >= 0) {
        while (av_read_frame(ifmt_ctx_a, &pkt) >= 0) {
            if (pkt.stream_index == audio_stream_idx) {
                if (total_duration > 0 && pkt.pts != AV_NOPTS_VALUE) {
                    int64_t cur = av_rescale_q(pkt.pts, ifmt_ctx_a->streams[audio_stream_idx]->time_base, AV_TIME_BASE_Q);
                    float p = 0.5f + (((float)cur / (float)total_duration) * 0.5f);
                    if (p > 0.99f) {
                        p = 0.99f;
                    }
#ifdef __cplusplus
                    m->progress.store(p);
#else
                    m->progress = p;
#endif
                }

                pkt.stream_index = out_a_idx;
                av_packet_rescale_ts(&pkt, ifmt_ctx_a->streams[audio_stream_idx]->time_base, ofmt_ctx->streams[out_a_idx]->time_base);
                pkt.pos = -1;

                if (last_dts[1] != AV_NOPTS_VALUE && pkt.dts != AV_NOPTS_VALUE &&
                    pkt.dts <= last_dts[1]) {
                    pkt.dts = last_dts[1] + 1;
                }
                if (pkt.pts != AV_NOPTS_VALUE && pkt.dts != AV_NOPTS_VALUE &&
                    pkt.pts < pkt.dts) {
                    pkt.pts = pkt.dts;
                }
                if (pkt.dts != AV_NOPTS_VALUE) {
                    last_dts[1] = pkt.dts;
                }
                av_interleaved_write_frame(ofmt_ctx, &pkt);
            }
            av_packet_unref(&pkt);
        }
    }
    m->bitfield[1] = 1;

#ifdef __cplusplus
    m->progress.store(1.0f);
#else
    m->progress = 1.0f;
#endif
    av_write_trailer(ofmt_ctx);

cleanup:
    if (ifmt_ctx_v) {
        avformat_close_input(&ifmt_ctx_v);
    }
    if (ifmt_ctx_a) {
        avformat_close_input(&ifmt_ctx_a);
    }
    if (ofmt_ctx) {
        if (!(ofmt_ctx->oformat->flags & AVFMT_NOFILE)) {
            avio_closep(&ofmt_ctx->pb);
        }
        avformat_free_context(ofmt_ctx);
    }
    return (ret < 0) ? ret : 0;
}

static int encode_from_fifo(AVAudioFifo *fifo, AVCodecContext *enc_ctx, AVFormatContext *ofmt_ctx, int out_idx, int64_t *pts_counter, bool flush) {
    int frame_size = enc_ctx->frame_size > 0 ? enc_ctx->frame_size : 1024;

    while (av_audio_fifo_size(fifo) >= frame_size || (flush && av_audio_fifo_size(fifo) > 0)) {
        int read_size = (av_audio_fifo_size(fifo) < frame_size) ? av_audio_fifo_size(fifo) : frame_size;

        AVFrame *enc_frame = av_frame_alloc();
        enc_frame->nb_samples = read_size;
        enc_frame->format = enc_ctx->sample_fmt;
        enc_frame->sample_rate = enc_ctx->sample_rate;
        av_channel_layout_copy(&enc_frame->ch_layout, &enc_ctx->ch_layout);
        av_frame_get_buffer(enc_frame, 0);

        av_audio_fifo_read(fifo, (void**)enc_frame->data, read_size);
        enc_frame->pts = *pts_counter;
        *pts_counter += read_size;

        int ret = avcodec_send_frame(enc_ctx, enc_frame);
        av_frame_free(&enc_frame);
        if (ret < 0) {
            return ret;
        }
        AVPacket *enc_pkt = av_packet_alloc();
        while (avcodec_receive_packet(enc_ctx, enc_pkt) >= 0) {
            enc_pkt->stream_index = out_idx;
            av_packet_rescale_ts(enc_pkt, enc_ctx->time_base, ofmt_ctx->streams[out_idx]->time_base);
            enc_pkt->pos = -1;
            av_interleaved_write_frame(ofmt_ctx, enc_pkt);
        }
        av_packet_free(&enc_pkt);
    }

    if (flush) {
        avcodec_send_frame(enc_ctx, NULL);
        AVPacket *enc_pkt = av_packet_alloc();
        while (avcodec_receive_packet(enc_ctx, enc_pkt) >= 0) {
            enc_pkt->stream_index = out_idx;
            av_packet_rescale_ts(enc_pkt, enc_ctx->time_base, ofmt_ctx->streams[out_idx]->time_base);
            enc_pkt->pos = -1;
            av_interleaved_write_frame(ofmt_ctx, enc_pkt);
        }
        av_packet_free(&enc_pkt);
    }
    return 0;
}

FFM_EXPORT int ffm_to_audio(FfmpegMerger* m, const char* input_path, const char* output_path) {
    if (!m || !input_path || !output_path) {
        return -1;
    }
    av_log_set_level(AV_LOG_ERROR);

    AVFormatContext *ifmt_ctx = NULL, *ofmt_ctx  = NULL;
    AVCodecContext *dec_ctx = NULL, *enc_ctx = NULL;
    const AVCodec *decoder = NULL, *encoder = NULL;
    SwrContext *swr_ctx = NULL;
    AVAudioFifo *fifo = NULL;
    AVPacket *pkt = NULL;
    AVFrame *dec_frame = NULL;
    AVFrame *swr_frame = NULL;
    int audio_idx = -1, out_idx = -1;
    int ret = 0;
    int64_t pts_counter = 0;
    bool need_transcode = false;

#ifdef __cplusplus
    m->total_pieces.store(1);
    m->progress.store(0.0f);
#else
    m->total_pieces = 1;
    m->progress = 0.0f;
#endif
    if (m->bitfield) {
        free(m->bitfield);
    }
    m->bitfield = (uint8_t*)calloc(1, 1);

    pkt = av_packet_alloc();
    if (!pkt) {
        return -10;
    }
    if ((ret = avformat_open_input(&ifmt_ctx, input_path, NULL, NULL)) < 0) {
        av_packet_free(&pkt); return -2;
    }
    if ((ret = avformat_find_stream_info(ifmt_ctx, NULL)) < 0) {
        ret = -3;
        goto cleanup;
    }

    for (unsigned int i = 0; i < ifmt_ctx->nb_streams; i++) {
        if (ifmt_ctx->streams[i]->codecpar->codec_type == AVMEDIA_TYPE_AUDIO) {
            audio_idx = (int)i; break;
        }
    }
    if (audio_idx < 0) {
        ret = -7;
        goto cleanup;
    }
    avformat_alloc_output_context2(&ofmt_ctx, NULL, NULL, output_path);
    if (!ofmt_ctx) {
        ret = -6;
        goto cleanup;
    }

    {
        AVCodecID in_id  = ifmt_ctx->streams[audio_idx]->codecpar->codec_id;
        AVCodecID out_id = ofmt_ctx->oformat->audio_codec;
        need_transcode = (out_id == AV_CODEC_ID_NONE) || (in_id != out_id);
    }

    if (need_transcode) {
        decoder = avcodec_find_decoder(ifmt_ctx->streams[audio_idx]->codecpar->codec_id);
        if (!decoder) {
            ret = -13;
            goto cleanup;
        }
        dec_ctx = avcodec_alloc_context3(decoder);
        if (!dec_ctx) {
            ret = -14;goto cleanup;
        }
        avcodec_parameters_to_context(dec_ctx, ifmt_ctx->streams[audio_idx]->codecpar);
        if (avcodec_open2(dec_ctx, decoder, NULL) < 0) {
            ret = -15;
            goto cleanup;
        }
        AVCodecID enc_codec_id = ofmt_ctx->oformat->audio_codec;
        if (enc_codec_id == AV_CODEC_ID_NONE) {
            enc_codec_id = AV_CODEC_ID_MP3;
        }
        encoder = avcodec_find_encoder(enc_codec_id);
        if (!encoder) {
            ret = -16;
            goto cleanup;
        }
        enc_ctx = avcodec_alloc_context3(encoder);
        if (!enc_ctx) {
            ret = -17;
            goto cleanup;
        }

        AVSampleFormat target_fmt = AV_SAMPLE_FMT_S16;
        if (encoder->sample_fmts && encoder->sample_fmts[0] != AV_SAMPLE_FMT_NONE) {
            target_fmt = encoder->sample_fmts[0];
        }
        int target_rate = dec_ctx->sample_rate;
        if (encoder->supported_samplerates) {
            int best = 0, diff = INT32_MAX;
            for (int i = 0; encoder->supported_samplerates[i]; i++) {
                int d = abs(encoder->supported_samplerates[i] - dec_ctx->sample_rate);
                if (d < diff) {
                    diff = d;
                    best = encoder->supported_samplerates[i];
                }
            }
            if (best) {
                target_rate = best;
            }
        }

        enc_ctx->sample_fmt = target_fmt;
        enc_ctx->sample_rate = target_rate;
        enc_ctx->bit_rate = 128000;
        av_channel_layout_copy(&enc_ctx->ch_layout, &dec_ctx->ch_layout);
        if (ofmt_ctx->oformat->flags & AVFMT_GLOBALHEADER) {
            enc_ctx->flags |= AV_CODEC_FLAG_GLOBAL_HEADER;
        }
        if (avcodec_open2(enc_ctx, encoder, NULL) < 0) {
            ret = -18;
            goto cleanup;
        }

        swr_ctx = swr_alloc();
        if (!swr_ctx) {
            ret = -20;
            goto cleanup;
        }
        av_opt_set_chlayout (swr_ctx, "in_chlayout", &dec_ctx->ch_layout,  0);
        av_opt_set_int (swr_ctx, "in_sample_rate", dec_ctx->sample_rate, 0);
        av_opt_set_sample_fmt (swr_ctx, "in_sample_fmt", dec_ctx->sample_fmt,  0);
        av_opt_set_chlayout (swr_ctx, "out_chlayout", &enc_ctx->ch_layout,  0);
        av_opt_set_int (swr_ctx, "out_sample_rate", enc_ctx->sample_rate, 0);
        av_opt_set_sample_fmt (swr_ctx, "out_sample_fmt", enc_ctx->sample_fmt,  0);
        if (swr_init(swr_ctx) < 0) {
            ret = -21; goto cleanup;
        }
        fifo = av_audio_fifo_alloc(enc_ctx->sample_fmt, enc_ctx->ch_layout.nb_channels, enc_ctx->frame_size > 0 ? enc_ctx->frame_size * 4 : 4096);
        if (!fifo) {
            ret = -22;
            goto cleanup;
        }
        dec_frame = av_frame_alloc();
        swr_frame = av_frame_alloc();
        if (!dec_frame || !swr_frame) {
            ret = -19;
            goto cleanup;
        }

        AVStream *out_s = avformat_new_stream(ofmt_ctx, NULL);
        if (!out_s) {
            ret = -11;
            goto cleanup;
        }
        avcodec_parameters_from_context(out_s->codecpar, enc_ctx);
        out_s->codecpar->codec_tag = 0;
        out_idx = out_s->index;
    } else {
        AVStream *out_s = avformat_new_stream(ofmt_ctx, NULL);
        if (!out_s) {
            ret = -11;
            goto cleanup;
        }
        avcodec_parameters_copy(out_s->codecpar, ifmt_ctx->streams[audio_idx]->codecpar);
        out_s->codecpar->codec_tag = 0;
        out_idx = out_s->index;
    }
    if (!(ofmt_ctx->oformat->flags & AVFMT_NOFILE)) {
        if (avio_open(&ofmt_ctx->pb, output_path, AVIO_FLAG_WRITE) < 0) {
            ret = -8;
            goto cleanup;
        }
    }
    ret = avformat_write_header(ofmt_ctx, NULL);
    if (ret < 0) {
        goto cleanup;
    }

    while (av_read_frame(ifmt_ctx, pkt) >= 0) {
        if (pkt->stream_index != audio_idx) {
            av_packet_unref(pkt);
            continue;
        }
        if (ifmt_ctx->duration > 0 && pkt->pts != AV_NOPTS_VALUE) {
            int64_t cur = av_rescale_q(pkt->pts, ifmt_ctx->streams[audio_idx]->time_base, AV_TIME_BASE_Q);
            float p = (float)cur / (float)ifmt_ctx->duration;
            if (p > 0.99f) {
                p = 0.99f;
            }
#ifdef __cplusplus
            m->progress.store(p);
#else
            m->progress = p;
#endif
        }

        if (need_transcode) {
            ret = avcodec_send_packet(dec_ctx, pkt);
            av_packet_unref(pkt);
            if (ret < 0 && ret != AVERROR(EAGAIN)) {
                continue;
            }
            while (avcodec_receive_frame(dec_ctx, dec_frame) >= 0) {
                int out_samples = (int)av_rescale_rnd( swr_get_delay(swr_ctx, dec_ctx->sample_rate) + dec_frame->nb_samples, enc_ctx->sample_rate, dec_ctx->sample_rate, AV_ROUND_UP);
                if (out_samples < 1) {
                    out_samples = 1;
                }
                av_frame_unref(swr_frame);
                swr_frame->format = enc_ctx->sample_fmt;
                swr_frame->sample_rate = enc_ctx->sample_rate;
                swr_frame->nb_samples = out_samples;
                av_channel_layout_copy(&swr_frame->ch_layout, &enc_ctx->ch_layout);
                av_frame_get_buffer(swr_frame, 0);
                int converted = swr_convert(swr_ctx, swr_frame->data, out_samples, (const uint8_t**)dec_frame->data, dec_frame->nb_samples);
                av_frame_unref(dec_frame);
                if (converted <= 0) continue;
                swr_frame->nb_samples = converted;

                av_audio_fifo_write(fifo, (void**)swr_frame->data, converted);
                encode_from_fifo(fifo, enc_ctx, ofmt_ctx, out_idx, &pts_counter, false);
            }
        } else {
            pkt->stream_index = out_idx;
            av_packet_rescale_ts(pkt, ifmt_ctx->streams[audio_idx]->time_base, ofmt_ctx->streams[out_idx]->time_base);
            pkt->pos = -1;
            ret = av_interleaved_write_frame(ofmt_ctx, pkt);
            av_packet_unref(pkt);
            if (ret < 0) {
                break;
            }
        }
    }
    if (need_transcode) {
        {
            int delay = (int)swr_get_delay(swr_ctx, dec_ctx->sample_rate);
            if (delay > 0) {
                int out_samples = (int)av_rescale_rnd(delay, enc_ctx->sample_rate, dec_ctx->sample_rate, AV_ROUND_UP);
                av_frame_unref(swr_frame);
                swr_frame->format = enc_ctx->sample_fmt;
                swr_frame->sample_rate = enc_ctx->sample_rate;
                swr_frame->nb_samples = out_samples;
                av_channel_layout_copy(&swr_frame->ch_layout, &enc_ctx->ch_layout);
                av_frame_get_buffer(swr_frame, 0);
                int converted = swr_convert(swr_ctx, swr_frame->data, out_samples, NULL, 0);
                if (converted > 0) {
                    swr_frame->nb_samples = converted;
                    av_audio_fifo_write(fifo, (void**)swr_frame->data, converted);
                }
            }
        }
        encode_from_fifo(fifo, enc_ctx, ofmt_ctx, out_idx, &pts_counter, true);
    }

    av_write_trailer(ofmt_ctx);
    m->bitfield[0] = 1;
#ifdef __cplusplus
    m->progress.store(1.0f);
#else
    m->progress = 1.0f;
#endif
    ret = 0;

cleanup:
    if (fifo) {
        av_audio_fifo_free(fifo);
    }
    if (swr_ctx) {
        swr_free(&swr_ctx);
    }
    if (dec_frame) {
        av_frame_free(&dec_frame);
    }
    if (swr_frame) {
        av_frame_free(&swr_frame);
    }
    if (pkt) {
        av_packet_free(&pkt);
    }
    if (dec_ctx) {
        avcodec_free_context(&dec_ctx);
    }
    if (enc_ctx) {
        avcodec_free_context(&enc_ctx);
    }
    if (ifmt_ctx) {
        avformat_close_input(&ifmt_ctx);
    }
    if (ofmt_ctx) {
        if (!(ofmt_ctx->oformat->flags & AVFMT_NOFILE)) {
            avio_closep(&ofmt_ctx->pb);
        }
        avformat_free_context(ofmt_ctx);
    }
    return (ret < 0) ? ret : 0;
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