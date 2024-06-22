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
    public class DbusmenuItem : GLib.Object {
        public signal void item_activated ();

        private int _id = 0;
        public int id {
            get {
                return _id;
            }
            set {
                _id = value;
            }
        }

        public GLib.List<DbusmenuItem> menuchildren = null;
        public GLib.HashTable<string, Variant> properties;

        public DbusmenuItem () {
            properties = new GLib.HashTable <string, Variant> (GLib.str_hash, GLib.str_equal);
            properties["label"] = new Variant.string ("Label Empty");
            properties["enabled"] = new Variant.boolean (true);
            properties["visible"] = new Variant.boolean (true);
        }

        public string? property_get (string property) {
            Variant variant = property_get_variant (property);
            if (variant == null) {
                return "";
            }
            return variant.print (true);
        }

        private Variant property_get_variant (string property) {
            return properties.lookup (property);
        }

        public void property_set (string property, string value) {
            Variant variant = null;
            if (value != null) {
                variant = new GLib.Variant.string (value);
            }
            property_set_variant (property, variant);
        }

        public void property_set_bool (string property, bool value) {
            Variant variant = new Variant.boolean (value);
            property_set_variant (property, variant);
        }

        public void child_reorder (DbusmenuItem child, int position) {
            child_delete (child);
            child.id = position;
            menuchildren.insert (child, position - 1);
            menuchildren.foreach ((item)=> {
                item.id = menuchildren.index (item) + 1;
            });
        }

        public void property_set_variant (string property, Variant value) {
            if (value != null) {
                if (properties.contains (property)) {
                    properties.replace (property.dup (), value);
                } else {
                    properties[property.dup ()] = value;
                }
            }
        }

        public bool get_exist (DbusmenuItem children) {
            if (menuchildren == null) {
                return false;
            }
            for (int count = 0; count < menuchildren.length (); count++) {
                if (menuchildren.nth_data (count) == children) {
                    return true;
                }
            }
            return false;
        }

        public void child_append (DbusmenuItem child) {
            if (menuchildren == null) {
                menuchildren = new GLib.List<DbusmenuItem> ();
                properties["children-display"] = new Variant.string ("submenu");
            }
            if (!get_exist (child)) {
                menuchildren.foreach ((item)=> {
                    item.id = menuchildren.index (item) + 1;
                });
                child.id = (int) menuchildren.length () + 1;
                menuchildren.append (child);
            }
        }

        public void child_delete (DbusmenuItem child) {
            if (get_exist (child)) {
                menuchildren.delete_link (menuchildren.find (child));
                menuchildren.foreach ((item)=> {
                    item.id = menuchildren.index (item) + 1;
                });
            }
        }

        public void signal_send (int mid, Variant name) {
            menuchildren.foreach ((item)=> {
                if (mid == item.id && name == item.properties.@get ("label")) {
                    item.item_activated ();
                }
            });
        }
    }
}