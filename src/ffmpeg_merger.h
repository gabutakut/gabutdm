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

#ifndef FFMPEG_MERGER_H
#define FFMPEG_MERGER_H

#include <stddef.h>
#include <stdint.h>

#define FFM_EXPORT __attribute__((visibility("default")))
#define MAX_STREAMS 32

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
    uint8_t* buffer;
    int width;
    int height;
    int rowstride;
} FfmThumbnail;

struct FfmpegReader {
    int width;
    int height;
    int success;
};

typedef struct FfmpegReader FfmpegReader;

FFM_EXPORT FfmpegReader* ffm_reader_create();
FFM_EXPORT void ffmpeg_reader_unref(FfmpegReader* r);
FFM_EXPORT int ffm_reader_open_path(FfmpegReader* r, const char* path);
FFM_EXPORT int ffm_reader_open_buffer(FfmpegReader* r, const unsigned char* data, size_t size);
FFM_EXPORT int ffm_reader_get_width(FfmpegReader* r);
FFM_EXPORT int ffm_reader_get_height(FfmpegReader* r);
FFM_EXPORT int ffm_reader_get_success(FfmpegReader* r);
FFM_EXPORT int ffm_reader_validate_path(FfmpegReader* r, const char* path);
FFM_EXPORT uint8_t* ffm_reader_ts_thumbnail_from_buffer(FfmpegReader* r, const unsigned char* data, size_t size, int* out_w, int* out_h, int* out_stride);
FFM_EXPORT uint8_t* ffm_reader_auto_thumbnail_from_buffer( FfmpegReader* r, const unsigned char* data, size_t size, int* out_w, int* out_h, int* out_stride);

typedef struct FfmpegMerger FfmpegMerger;
FFM_EXPORT FfmpegMerger* ffm_merger_create();
FFM_EXPORT void ffmpeg_merger_unref(FfmpegMerger* m);
FFM_EXPORT float ffm_get_last_progress(FfmpegMerger* m);
FFM_EXPORT const char* ffm_get_bitfield_hex(FfmpegMerger* m);
FFM_EXPORT int ffm_combine_file(FfmpegMerger* m, const char* video_path, const char* audio_path, const char* output_path);
FFM_EXPORT int ffm_to_audio(FfmpegMerger* m, const char* input_path, const char* output_path);
FFM_EXPORT int ffm_merge_files(FfmpegMerger* m, const char **paths, int count, const char *output_path);
#ifdef __cplusplus
}
#endif

#endif
