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

[CCode (cheader_filename = "aria2_wrapper.h")]
namespace Aria2 {
    [CCode (cname = "Aria2NotifyCallback", has_target = true)]
    public delegate void NotifyCallback(string gid);

    [CCode (cname = "Aria2Engine", free_function = "aria2_engine_unref")]
    public class Engine {
        [CCode (cname = "aria2_engine_create")]
        public Engine();
        [CCode (cname = "aria2_engine_add_option")]
        public void add_option(string key, string value);
        [CCode (cname = "aria2_engine_start")]
        public int start();
        [CCode (cname = "aria2_engine_stop")]
        public void stop();

        [CCode (cname = "aria2_engine_add_uri")]
        public string? add_uri(string uri);
        [CCode (cname = "aria2_engine_add_torrent")]
        public string? add_torrent(string path);
        [CCode (cname = "aria2_engine_remove")]
        public int remove(string gid);
        [CCode (cname = "aria2_engine_pause")]
        public int pause(string gid);
        [CCode (cname = "aria2_engine_unpause")]
        public int unpause(string gid);
        [CCode (cname = "aria2_engine_change_position")]
        public int change_position(string gid, int pos, string how);
        [CCode (cname = "aria2_engine_change_option")]
        public int change_option(string gid, string key, string value);

        [CCode (cname = "aria2_engine_tell_status")]
        public string? tell_status(string gid);
        [CCode (cname = "aria2_engine_tell_active")]
        public string? tell_active();
        [CCode (cname = "aria2_engine_get_files")]
        public string? get_files(string gid);
        [CCode (cname = "aria2_engine_get_peers")]
        public string? get_peers(string gid);
        [CCode (cname = "aria2_engine_get_out")]
        public string? get_out(string gid);
        [CCode (cname = "aria2_engine_get_dir")]
        public string? get_dir(string gid);
        [CCode (cname = "aria2_engine_is_running")]
        public bool is_running();
        [CCode (cname = "aria2_engine_set_on_complete")]
        public void set_on_complete(NotifyCallback cb);
        [CCode (cname = "aria2_engine_set_on_error")]
        public void set_on_error(NotifyCallback cb);
    }
}