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

namespace Gabut {
    public class TrFileInfo : GLib.Object {
        public string full_path  = "";
        public string path = "";
        public string status = "";
        public int64 size { get; set; default = 0; }
        public bool selected { get; set; default = true; }
        public string[] bencode_path_parts { get; set; default = {}; }
        public BencodeValue? bencode_file_data { get; set; }
        public int index { get; set; default = -1; }
        public bool is_folder { get; set; default = false; }
        public Gee.ArrayList<TrFileInfo> children { get; set; }
        public weak TrFileInfo? parent { get; set; }

        private int64 _completed_length = 0;
        public int64 completed_length {
            get { return _completed_length; }
            set {
                if (_completed_length == value) {
                    return;
                }
                _completed_length = value;
                notify_property("completed-length");
                notify_property("progress");
            }
        }

        public double progress {
            get {
                if (is_folder || size == 0) {
                    return 0.0;
                }
                return (double)completed_length / (double)size * 100.0;
            }
        }

        construct {
            children = new Gee.ArrayList<TrFileInfo>();
        }
    }
}