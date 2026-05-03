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
    public class FormatItem : GLib.Object {
        private string _id;
        public string id {
            get {
                return _id;
            }
            construct {
                _id = value;
            }
        }
        private string _url;
        public string url {
            get {
                return _url;
            }
            construct {
                _url = value;
            }
        }
        private string _label;
        public string label {
            get {
                return _label;
            }
            construct {
                _label = value;
            }
        }
        private string _ext;
        public string ext {
            get {
                return _ext;
            }
            construct {
                _ext = value;
            }
        }
        public int64 size { get; construct; }
        public bool is_video { get; construct; }
        public bool has_audio { get; construct; } 

        public FormatItem (string id, string label, string url, int64 size, string ext, bool is_vid, bool has_aud) {
            GLib.Object (id: id, label: label, url: url, size: size, ext: ext, is_video: is_vid, has_audio: has_aud);
        }
    }
}