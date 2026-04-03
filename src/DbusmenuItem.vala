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
    public class DBusMenu : GLib.Object {
        public struct DbusmenuMenuitem {
            public int id;
            public GLib.HashTable<string, Variant> properties;
        }

        public struct MenuItemLayout {
            public int id;
            public GLib.HashTable<string, Variant> properties;
            public Variant[] children;
        }

        public struct MenuEvent {
            public int id;
            public string eventid;
            public Variant data;
            public uint timestamp;
        }

        public struct MenuItemPropertyDescriptor {
            public int id;
            public string property;
        }

        public class DbusmenuItem : GLib.Object {
            public signal void item_activated();
            private int _id = 0;
            public int id {
                get { return _id; }
                set { _id = value; }
            }
            public Gee.ArrayList<DbusmenuItem> children;
            public GLib.HashTable<string, Variant> properties;
            private static int GLOBAL_ID = 1;

            public DbusmenuItem() {
                children = new Gee.ArrayList<DbusmenuItem>();
                properties = new GLib.HashTable<string, Variant>(GLib.str_hash, GLib.str_equal);
                properties["label"] = new Variant.string("Label Empty");
                properties["enabled"] = new Variant.boolean(true);
                properties["visible"] = new Variant.boolean(true);
                properties["type"] = new Variant.string("standard");
            }

            public void property_set(string property, string value) {
                properties[property] = new Variant.string(value);
            }

            public void property_set_bool(string property, bool value) {
                properties[property] = new Variant.boolean(value);
            }

            public void property_set_int(string property, int value) {
                properties[property] = new Variant.int32(value);
            }

            private bool has_child_id(int search_id) {
                foreach (var c in children) {
                    if (c.id == search_id) {
                        return true;
                    }
                }
                return false;
            }

            public void child_append(DbusmenuItem child) {
                if (child == null) {
                    return;
                }
                if (child.id == 0) {
                    child.id = GLOBAL_ID++;
                }
                if (has_child_id(child.id)) {
                    return;
                }
                children.add(child);
                if (children.size > 0) {
                    properties["children-display"] = new Variant.string("");
                }
            }

            public void child_insert(DbusmenuItem child, int position) {
                if (child == null) {
                    return;
                }
                if (child.id == 0) {
                    child.id = GLOBAL_ID++;
                }
                if (has_child_id(child.id)) {
                    return;
                }
                if (position < 0) {
                    position = 0;
                }
                if (position > children.size) {
                    position = children.size;
                }
                children.insert(position, child);
                if (children.size > 0) {
                    properties["children-display"] = new Variant.string("");
                }
            }
        }

        private GLib.DBusConnection? session_connection = null;
        private uint registration_id = 0;
        private CanonicalDbusmenu dbusmenu_server;
        private GLib.ObjectPath dbus_path;
        private DbusmenuItem root;
        private string app_uri;
        private bool is_started = false;

        public DBusMenu(string desktop_file) {
            this.app_uri = "application://%s.desktop".printf(desktop_file);
            uint app_hash = app_uri.hash();
            dbus_path = new GLib.ObjectPath("/com/canonical/unity/launcherentry/%u".printf(app_hash));
            root = new DbusmenuItem();
            root.id = 0;
            root.properties["children-display"] = new Variant.string("");
            dbusmenu_server = new CanonicalDbusmenu();
            dbusmenu_server.item_activated.connect(on_item_activated);
        }

        private void on_item_activated(int id) {
            foreach (var item in root.children) {
                if (item.id == id) {
                    item.item_activated();
                    break;
                }
            }
        }

        public async void start() throws GLib.Error {
            if (is_started) {
                return;
            }
            session_connection = yield GLib.Bus.@get(GLib.BusType.SESSION);
            registration_id = session_connection.register_object(dbus_path, dbusmenu_server);
            dbusmenu_server.set_root(root);
            is_started = true;
        }

        public async void stop() throws GLib.Error {
            if (!is_started) {
                return;
            }
            if (registration_id != 0 && session_connection != null) {
                session_connection.unregister_object(registration_id);
                registration_id = 0;
            }
            is_started = false;
        }

        public void append_dbus(DbusmenuItem item) {
            if (item == null) {
                return;
            }
            foreach (var child in root.children) {
                if (child == item || child.id == item.id) return;
            }
            root.child_append(item);
            if (is_started) {
                try {
                    dbusmenu_server.set_root(root);
                } catch (GLib.Error e) {
                    GLib.warning("Failed to update menu on server: %s", e.message);
                }
            }
        }

        public bool delete_dbus(DbusmenuItem item) {
            for (int i = 0; i < root.children.size; i++) {
                if (root.children[i].id == item.id) {
                    root.children.remove_at(i);
                    if (is_started) {
                        try {
                            dbusmenu_server.set_root(root);
                        } catch (GLib.Error e) {
                            GLib.warning("Failed to update menu on server: %s", e.message);
                        }
                    }
                    return true;
                }
            }
            return false;
        }

        public void insert_dbus(DbusmenuItem item, int position) {
            if (item == null) {
                return;
            }
            root.child_insert(item, position);
            if (is_started) {
                try {
                    dbusmenu_server.set_root(root);
                } catch (GLib.Error e) {
                    GLib.warning("Failed to update menu on server: %s", e.message);
                }
            }
        }

        public bool dbus_contains(DbusmenuItem item) {
            return root.children.contains(item);
        }

        public void clear() {
            root.children.clear();
            if (is_started) {
                try {
                    dbusmenu_server.set_root(root);
                } catch (GLib.Error e) {
                    GLib.warning("Failed to update menu on server: %s", e.message);
                }
            }
        }

        public GLib.ObjectPath get_dbus_path() {
            return dbus_path;
        }

        public DbusmenuItem get_root() {
            return root;
        }

        public CanonicalDbusmenu get_server() {
            return dbusmenu_server;
        }

        public bool get_is_started() {
            return is_started;
        }

        public int get_item_count() {
            return root.children.size;
        }

        public string get_app_uri() {
            return app_uri;
        }
    }
}