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
    [DBus (name = "com.canonical.Unity.LauncherEntry")]
    public class GdmUnityLauncherEntry : GLib.Object {
        public signal void update(string app_uri, GLib.HashTable<string, GLib.Variant> properties);
        private GLib.HashTable<string, GLib.Variant> _properties;
        private string _app_uri;
        private string _desktop_file;
        private uint _registration_id = 0;

        public GdmUnityLauncherEntry(string desktop_file) {
            this._desktop_file = desktop_file;
            this._app_uri = "application://%s.desktop".printf(desktop_file);
            _properties = new GLib.HashTable<string, GLib.Variant>(GLib.str_hash, GLib.str_equal);
            _properties["urgent"] = new GLib.Variant.boolean(false);
            _properties["count"] = new GLib.Variant.int64(0);
            _properties["count-visible"] = new GLib.Variant.boolean(false);
            _properties["progress"] = new GLib.Variant.double(0.0);
            _properties["progress-visible"] = new GLib.Variant.boolean(false);
            _properties["quicklist"] = new GLib.Variant.string("");
        }

        [DBus (visible = false)]
        public async bool register() throws GLib.Error {
            if (_registration_id != 0) {
                return true;
            }
            var session_connection = yield GLib.Bus.@get(GLib.BusType.SESSION);
            uint app_hash = _app_uri.hash();
            string object_path = "/com/canonical/unity/launcherentry/%u".printf(app_hash);
            _registration_id = session_connection.register_object(object_path, this);
            return _registration_id != 0;
        }

        [DBus (visible = false)]
        public async void unregister() throws GLib.Error {
            if (_registration_id == 0) {
                return;
            }
            var session_connection = yield GLib.Bus.@get(GLib.BusType.SESSION);
            session_connection.unregister_object(_registration_id);
            _registration_id = 0;
        }

        [DBus (visible = false)]
        public bool is_registered() throws Error{
            return _registration_id != 0;
        }

        public void Update(string desktop_file, GLib.HashTable<string, GLib.Variant> properties) throws GLib.Error {
            var keys = properties.get_keys();
            foreach (string key in keys) {
                GLib.Variant value = properties[key];
                _properties[key] = value;
            }
            update(_app_uri, properties);
        }

        public GLib.HashTable<string, GLib.Variant> query() throws GLib.Error {
            return _properties;
        }

        [DBus (visible = false)]
        public async void set_progress_visible(bool visible) throws GLib.Error {
            var props = new GLib.HashTable<string, GLib.Variant>(GLib.str_hash, GLib.str_equal);
            props["progress-visible"] = new GLib.Variant.boolean(visible);
            Update(_desktop_file, props);
        }

        [DBus (visible = false)]
        public async void set_progress(double progress) throws GLib.Error {
            var props = new GLib.HashTable<string, GLib.Variant>(GLib.str_hash, GLib.str_equal);
            props["progress"] = new GLib.Variant.double(progress.clamp(0.0, 1.0));
            props["progress-visible"] = new GLib.Variant.boolean(true);
            Update(_desktop_file, props);
        }

        [DBus (visible = false)]
        public async void set_count(int64 count) throws GLib.Error {
            var props = new GLib.HashTable<string, GLib.Variant>(GLib.str_hash, GLib.str_equal);
            props["count"] = new GLib.Variant.int64(count);
            Update(_desktop_file, props);
        }

        [DBus (visible = false)]
        public async void set_count_visible(bool visible) throws GLib.Error {
            var props = new GLib.HashTable<string, GLib.Variant>(GLib.str_hash, GLib.str_equal);
            props["count-visible"] = new GLib.Variant.boolean(visible);
            Update(_desktop_file, props);
        }

        [DBus (visible = false)]
        public async void set_urgent(bool urgent) throws GLib.Error {
            var props = new GLib.HashTable<string, GLib.Variant>(GLib.str_hash, GLib.str_equal);
            props["urgent"] = new GLib.Variant.boolean(urgent);
            Update(_desktop_file, props);
        }

        [DBus (visible = false)]
        public async void set_quicklist(GLib.ObjectPath? dbus_path = null) throws GLib.Error {
            var props = new GLib.HashTable<string, GLib.Variant>(GLib.str_hash, GLib.str_equal);
            props["quicklist"] = new GLib.Variant.string(dbus_path);
            Update(_desktop_file, props);
        }
    }
}