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
    public class TorrentInfo : GLib.Object {
        public string name { get; set; default = ""; }
        public int64 total_size { get; set; default = 0; }
        public int file_count { get; set; default = 0; }
        public Gee.ArrayList<TrFileInfo> files { get; set; }
        public Gee.ArrayList<string> announce_list { get; set; }
        public string comment { get; set; default = ""; }
        public int64 creation_date { get; set; default = 0; }
        public string created_by { get; set; default = ""; }
        public BencodeValue? bencode_data { get; set; }
        public string original_filepath { get; set; default = ""; }

        construct {
            files = new Gee.ArrayList<TrFileInfo>();
            announce_list = new Gee.ArrayList<string>();
        }
    }
}