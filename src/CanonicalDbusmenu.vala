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
    [DBus (name = "com.canonical.dbusmenu")]
    private class CanonicalDbusmenu : GLib.Object {
        public signal void item_activation_requested (int id, uint timestamp);
        public signal void items_properties_updated (DbusmenuMenuitem[] updated_props, MenuItemPropertyDescriptor[] removed_props);
        public signal void layout_updated (uint revision, int parent);

        internal Variant[] children;
        internal DbusmenuMenuitem[] dbusmenumenuitem;
        internal uint revision;
        public string[] icon_theme_path {get;}
        public string status {
            get {
                return "normal";
            }
        }
        public string text_direction {
            get {
                return "ltr";
            }
        }
        public uint version {
            get {
                return 2;
            }
        }

        internal GLib.ObjectPath dbus_object = new GLib.ObjectPath ("/com/canonical/unity/launcherentry/%u".printf (get_app_id ().hash ()));
        public CanonicalDbusmenu () {
            register_dbus.begin ();
        }
        private async void register_dbus () throws Error {
            var session_connection = yield GLib.Bus.@get (GLib.BusType.SESSION);
            session_connection.register_object (dbus_object, this);
        }

        internal DbusmenuItem root;
        internal void set_root (DbusmenuItem root) {
            this.root = root;
            children = {};
            dbusmenumenuitem = {};
            this.revision = this.revision + root.menuchildren.length ();
            layout_updated (revision, root.id);
            root.menuchildren.foreach ((menuitem)=> {
                children += set_layouts (menuitem.id, menuitem.properties, {});
                dbusmenumenuitem += set_item (menuitem.id, menuitem.properties);
            });
            items_properties_updated ({set_item (root.id, set_item_prop ({"children-display"}, {new Variant.string ("submenu")}))}, {});
        }

        internal MenuItemLayout set_layouts (int id, GLib.HashTable<string, GLib.Variant> menu, Variant[] variant) {
            var menuitemlayout = MenuItemLayout ();
            menuitemlayout.id = id;
            menuitemlayout.properties = menu;
            menuitemlayout.children = variant;
            return menuitemlayout;
        }

        internal DbusmenuMenuitem set_item (int id, GLib.HashTable<string, Variant> make) {
            var dbusitem = DbusmenuMenuitem ();
            dbusitem.id = id;
            dbusitem.properties = make;
            return dbusitem;
        }

        internal GLib.HashTable<string, GLib.Variant> set_item_prop (string[] prop, Variant[] variant) {
            var properties = new GLib.HashTable<string, GLib.Variant> (str_hash, str_equal);
            for (int i = 0; i < prop.length; i++) {
                properties[prop[i]] = variant[i];
            }
            return properties;
        }

        public void event (int id, string event_id, Variant data, uint timestamp) throws GLib.Error {
            if (event_id == "clicked") {
                if (root != null) {
                    Variant name;
                    _get_property (id, "label", out name);
                    root.signal_send (id, name);
                }
            }
        }
        public void event_group (MenuEvent events, out int[] id_errors) throws GLib.Error {
            event (events.id, events.eventid, events.data, events.timestamp);
            id_errors = {};
        }

        public void _get_property (int id, string name, out Variant value) throws GLib.Error {
            foreach (var menumenuitem in dbusmenumenuitem) {
                if (menumenuitem.properties.contains (name) && menumenuitem.id == id) {
                    value = menumenuitem.properties.get (name);
                    return;
                }
            }
            value = new Variant.string ("");
        }
        public void get_layout (int parent_id, int recursion_depth, string[] property_names, out uint revision, out MenuItemLayout layout) throws GLib.Error {
            revision = this.revision;
            layout = set_layouts (root.id, root.properties, children);
        }
        public void get_group_properties (int[] ids, string[] property_names, out DbusmenuMenuitem[] properties) throws GLib.Error {
            properties = dbusmenumenuitem;
        }
        public void about_to_show (int id, out bool need_update) throws GLib.Error {
            need_update = false;
        }
        public void about_to_show_group (int[] ids, out int[] updates_needed, out int[] id_errors) throws GLib.Error {
            updates_needed = {};
            id_errors = {};
        }
    }
}