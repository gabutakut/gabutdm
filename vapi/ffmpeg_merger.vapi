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

[CCode (cheader_filename = "ffmpeg_merger.h")]
namespace Ffmpeg {
    [CCode (cname = "FfmpegReader", free_function = "ffm_reader_unref")]
    public class Reader {
        [CCode (cname = "ffm_reader_create")]
        public Reader();
        [CCode (cname = "ffm_reader_open_path")]
        public int open_path(string path);
        [CCode (cname = "ffm_reader_open_buffer")]
        public int open_buffer([CCode (array_length = true, array_length_pos = 1)] uint8[] data);
        [CCode (cname = "ffm_reader_get_width")]
        public int get_width();
        [CCode (cname = "ffm_reader_get_height")]
        public int get_height();
        [CCode (cname = "ffm_reader_get_success")]
        public int get_success();
        [CCode (cname="ffm_reader_validate_path")]
        public int validate_path (string path);
    }

    [CCode (cname = "FfmpegMerger", free_function = "ffmpeg_merger_unref")]
    public class Merger {
        [CCode (cname = "ffm_merger_create")]
        public Merger();
        [CCode (cname = "ffm_merge_files")]
        public int merge_files([CCode (array_length = false, array_null_terminated = true)]string[] paths, int count, string output_path);
        [CCode (cname = "ffm_get_last_progress")]
        public float get_last_progress();
        [CCode (cname = "ffm_get_bitfield_hex")]
        public unowned string hex_bitfield();
    }
}
