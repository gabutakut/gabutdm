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
    [DBus (name = "org.kde.StatusNotifierItem")]
    public class DbusIndicator : GLib.Object {
        public signal void new_icon ();
        public signal void new_icon_theme_path (string icon_theme_path);
        public signal void new_attention_icon ();
        public signal void new_status (string status);
        public signal void x_ayatana_new_label (string label, string guide);
        public signal void new_title ();

        private string _id = "";
        public string id {
            get {
                return _id;
            }
        }

        public string category {
            get {
                return "ApplicationStatus";
            }
        }

        public string _status ="Active";
        public string status {
            get {
                return _status;
            }
        }

        private string _icon_name = "com.github.gabutakut.gabutdm";
        public string icon_name {
            get {
                return _icon_name;
            }
        }

        public string icon_accessible_desc {
            get {
                return "";
            }
        }

        public string attention_icon_name {
            get {
                return "";
            }
        }

        public string attention_accessible_desc {
            get {
                return "";
            }
        }

        public string title {
            get {
                return "Gabut Download Manager";
            }
        }

        public string icon_theme_path {
            get {
                return "";
            }
        }

        public ObjectPath _menu;
        public ObjectPath menu {
            get {
                return _menu;
            }
        }

        public string _x_ayatana_label = "";
        public string x_ayatana_label {
            get {
                return _x_ayatana_label;
            }
        }

        public string x_ayatana_label_guide {
            get {
                return "";
            }
        }

        public uint x_ayatana_ordering_index {
            get {
                return 5;
            }
        }

        private static DbusStatusWhacher dbusstatuswatcher = null;
        private static GLib.HashTable<string, DbusIndicator> _instances;
        private static GLib.HashTable<string, uint> _registration_ids;
        private static GLib.HashTable<string, uint> _dbus_registration_ids;
        private string _app_uri;

        static construct {
            _instances = new GLib.HashTable<string, DbusIndicator>(GLib.str_hash, GLib.str_equal);
            _registration_ids = new GLib.HashTable<string, uint>(GLib.str_hash, GLib.str_equal);
            _dbus_registration_ids = new GLib.HashTable<string, uint>(GLib.str_hash, GLib.str_equal);
        }

        private DbusIndicator (string desktop_file) {
            this._app_uri = "application://%s.desktop".printf(desktop_file);
            _menu = new GLib.ObjectPath("/com/canonical/unity/launcherentry/%u".printf(_app_uri.hash ()));
        }

        public static async DbusIndicator get_instance(string desktop_file) throws GLib.Error {
            string app_uri = "application://%s.desktop".printf(desktop_file);
            if (_instances != null) {
                if (_instances.contains(app_uri)) {
                    return _instances[app_uri];
                }
            }
            var instance = new DbusIndicator(desktop_file);
            _instances[app_uri] = instance;
            yield instance.register_dbus();
            return instance;
        }

        [DBus (visible = false)]
        private async void register_dbus () throws Error {
            var session_connection = yield GLib.Bus.@get (GLib.BusType.SESSION);
            if (_registration_ids.contains(_app_uri) && _registration_ids[_app_uri] != 0) {
                session_connection.unregister_object(_registration_ids[_app_uri]);
                _registration_ids[_app_uri] = 0;
            }
            uint registration_id = session_connection.register_object (_menu, this);
            _registration_ids[_app_uri] = registration_id;
            yield start_buswach ();
        }

        [DBus (visible = false)]
        private async void start_buswach () throws Error {
            dbusstatuswatcher = yield Bus.get_proxy <DbusStatusWhacher> (BusType.SESSION, "org.kde.StatusNotifierWatcher", "/StatusNotifierWatcher", GLib.DBusProxyFlags.NONE, null);
            if (dbusstatuswatcher != null) {
                ((GLib.DBusProxy) dbusstatuswatcher).g_connection.signal_subscribe (null, "org.kde.StatusNotifierWatcher", null, "/StatusNotifierWatcher", null, GLib.DBusSignalFlags.NONE, ()=> {});
                dbusstatuswatcher.register_status_notifier_item (_menu);
                _id = Environment.get_application_name ();
            }
        }

        [DBus (visible = false)]
        public static async void unregister_instance(string desktop_file) throws GLib.Error {
            string app_uri = "application://%s.desktop".printf(desktop_file);
            if (_instances.contains(app_uri)) {
                if (_registration_ids.contains(app_uri) && _registration_ids[app_uri] != 0) {
                    var session_connection = yield GLib.Bus.@get(GLib.BusType.SESSION);
                    session_connection.unregister_object(_registration_ids[app_uri]);
                    _registration_ids[app_uri] = 0;
                }
                _instances.remove(app_uri);
            }
        }

        [DBus (visible = false)]
        public static async bool is_registered(string desktop_file) {
            string app_uri = "application://%s.desktop".printf(desktop_file);
            return _registration_ids.contains(app_uri) && _registration_ids[app_uri] != 0;
        }

        [DBus (visible = false)]
        public void set_label(string label) {
            _x_ayatana_label = label;
            x_ayatana_new_label(label, "");
        }

        [DBus (visible = false)]
        public void set_icon_name(string icon_name) {
            _icon_name = icon_name;
            new_icon();
        }

        [DBus (visible = false)]
        public void set_status(string status) {
            _status = status;
            new_status(status);
        }

        public void scroll (int delta, int orientation) throws GLib.Error {}
        public void secondary_activate (int x, int y) throws GLib.Error {}
        public void x_ayatana_secondary_activate (uint timestamp) throws GLib.Error {}
    }
}