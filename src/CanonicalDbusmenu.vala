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
    [DBus (name = "com.canonical.dbusmenu")]
    public class CanonicalDbusmenu : GLib.Object {
        public signal void item_activation_requested(int id, uint timestamp);
        public signal void items_properties_updated(DBusMenu.DbusmenuMenuitem[] updated_props, DBusMenu.MenuItemPropertyDescriptor[] removed_props);
        public signal void layout_updated(uint revision, int parent);
        public signal void item_activated(int id);

        private string[] _icon_theme_path = {};
        public string[] icon_theme_path { 
            owned get { return _icon_theme_path; }
        }

        public string status {
            owned get { return "normal"; }
        }

        public string text_direction {
            owned get { return "ltr"; }
        }

        public uint version {
            get { return 3; }
        }

        private DBusMenu.DbusmenuItem? root = null;
        private Variant[] children = {};
        private DBusMenu.DbusmenuMenuitem[] dbusmenumenuitem = {};
        private uint revision = 1;

        internal void set_root(DBusMenu.DbusmenuItem? root_item) throws GLib.Error {
            this.root = root_item;
            this.root.children.sort((a, b)=> {
                return a.id - b.id;
            });
            update_layout();
        }

        private void update_layout() throws GLib.Error {
            if (root == null) {
                return;
            }
            revision++;
            var children_list = new Variant[0];
            var items_list = new DBusMenu.DbusmenuMenuitem[0];

            foreach (var child in root.children) {
                children_list += create_layout(child.id, child.properties, {});
                items_list += create_menuitem(child.id, child.properties);
            }

            children = children_list;
            dbusmenumenuitem = items_list;

            var updated_props = new DBusMenu.DbusmenuMenuitem[1];
            var root_props = new GLib.HashTable<string, Variant>(GLib.str_hash, GLib.str_equal);
            root_props["children-display"] = new Variant.string("submenu");
            updated_props[0] = create_menuitem(root.id, root_props);

            items_properties_updated(updated_props, {});
            layout_updated(revision, root.id);
        }

        private DBusMenu.MenuItemLayout create_layout(int id, GLib.HashTable<string, Variant> props, Variant[] child_variants) {
            return DBusMenu.MenuItemLayout() {
                id = id,
                properties = props,
                children = child_variants
            };
        }

        private DBusMenu.DbusmenuMenuitem create_menuitem(int id, GLib.HashTable<string, Variant> props) {
            return DBusMenu.DbusmenuMenuitem() {
                id = id,
                properties = props
            };
        }

        public void Event(int id, string event_id, Variant data, uint timestamp) throws GLib.Error {
            if (event_id == "clicked" || event_id == "activated") {
                item_activation_requested(id, timestamp);
                item_activated(id);
            }
        }
        
        public void EventGroup(DBusMenu.MenuEvent[] events, out int[] id_errors) throws GLib.Error {
            id_errors = {};
            foreach (var ev in events) {
                Event(ev.id, ev.eventid, ev.data, ev.timestamp);
            }
        }
        
        public void GetProperty(int id, string name, out Variant value) throws GLib.Error {
            foreach (var item in dbusmenumenuitem) {
                if (item.id == id && item.properties.contains(name)) {
                    value = item.properties.get(name);
                    return;
                }
            }
            value = new Variant.string("");
        }
        
        public void GetLayout(int parent_id, int recursion_depth, string[] property_names, out uint rev, out DBusMenu.MenuItemLayout layout) throws GLib.Error {
            rev = revision;
            
            if (parent_id == 0 && root != null) {
                layout = create_layout(root.id, root.properties, children);
            } else {
                var props = new GLib.HashTable<string, Variant>(GLib.str_hash, GLib.str_equal);
                layout = create_layout(parent_id, props, {});
            }
        }
        
        public void GetGroupProperties(int[] ids, string[] property_names, out DBusMenu.DbusmenuMenuitem[] props) throws GLib.Error {
            props = dbusmenumenuitem;
        }
        
        public void AboutToShow(int id, out bool need_update) throws GLib.Error {
            need_update = false;
        }
        
        public void AboutToShowGroup(int[] ids, out int[] updates_needed, out int[] id_errors) throws GLib.Error {
            updates_needed = {};
            id_errors = {};
        }
    }
}