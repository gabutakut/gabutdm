/*
* Copyright (c) {2024} torikulhabib (https://github.com/gabutakut)
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

        public string id {
            get {
                return updatesnewid;
            }
        }
        public string category {
            get {
                return "ApplicationStatus";
            }
        }
        public string status {
            get {
                return updatestatus;
            }
        }
        public string icon_name {
            get {
                return updateiconame;
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
        public ObjectPath menu {
            get {
                return objectpat;
            }
        }
        public string x_ayatana_label {
            get {
                return updateLabel;
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
        internal ObjectPath objectpat = null;
        internal static DbusStatusWhacher dbusstatuswatcher = null;
        internal string updateLabel = "";
        internal string updateiconame = "com.github.gabutakut.gabutdm";
        internal string updatestatus = "Active";
        internal string updatesnewid = "";
        public DbusIndicator (string path) {
            objectpat = new ObjectPath (path);
        }

        internal async void register_dbus () throws Error {
            var session_connection = yield GLib.Bus.@get (GLib.BusType.SESSION);
            session_connection.register_object (objectpat, this);
            Bus.get_proxy.begin<DbusStatusWhacher> (BusType.SESSION, "org.kde.StatusNotifierWatcher", "/StatusNotifierWatcher", GLib.DBusProxyFlags.NONE, null, (obj, res) => {
                try {
                    dbusstatuswatcher = Bus.get_proxy.end (res);
                    ((GLib.DBusProxy) dbusstatuswatcher).g_connection.signal_subscribe (null, "org.kde.StatusNotifierWatcher", null, "/StatusNotifierWatcher", null, GLib.DBusSignalFlags.NONE, (GLib.DBusSignalCallback)subscription_callback);
                    if (dbusstatuswatcher != null) {
                        dbusstatuswatcher.register_status_notifier_item (objectpat);
                        updatesnewid = Environment.get_application_name ();
                    }
                } catch (GLib.Error e) {
                    critical (e.message);
                }
            });
        }
        private void subscription_callback (DBusConnection connection, string? sender_name, string object_path, string interface_name, string signal_name, Variant parameters) {}
        public void scroll (int delta, int orientation) throws GLib.Error {}
        public void secondary_activate (int x, int y) throws GLib.Error {}
        public void x_ayatana_secondary_activate (uint timestamp) throws GLib.Error {}
    }
}