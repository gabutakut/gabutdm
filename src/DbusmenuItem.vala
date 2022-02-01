/*
* Copyright (c) {2021} torikulhabib (https://github.com/gabutakut)
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
            properties = new GLib.HashTable <string, Variant> (str_hash, str_equal);
            properties["label"] = v_s ("Label Empty");
            properties["enabled"] = v_b (true);
            properties["visible"] = v_b (true);
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
            var childrens = new List<DbusmenuItem> ();
            menuchildren.foreach ((item)=> {
                childrens.append (item);
                child_delete (item);
            });
            int count = 1;
            childrens.foreach ((item)=> {
                if (child == item && position != item.id) {
                    child.id = position;
                    menuchildren.insert (child, position - 1);
                } else {
                    item.id = count;
                    menuchildren.insert (item, count);
                }
                count++;
            });
            menuchildren.foreach ((item)=> {
                if (child != item && position == item.id) {
                    item.id = (int) childrens.length ();
                    menuchildren.insert (item, (int) childrens.length ());
                }
            });
        }

        public void property_set_variant (string property, Variant value) {
            string hash_key;
            Variant hash_variant;
            bool inhash = properties.lookup_extended (property, out hash_key, out hash_variant);
            if (value != null) {
                if (!inhash || (hash_variant != null && !hash_variant.equal (value))) {
                    properties.replace (property.dup (), value);
                }
            } else {
                if (inhash) {
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
                properties["children-display"] = v_s ("submenu");
            }
            if (!get_exist (child)) {
                child.id = (int) menuchildren.length () + 1;
                menuchildren.append (child);
            }
        }

        public void child_delete (DbusmenuItem child) {
            if (get_exist (child)) {
                menuchildren.remove_link (menuchildren.find (child));
            }
        }

        public void signal_send (int mid) {
            menuchildren.foreach ((item)=> {
                if (mid == item.id) {
                    item.item_activated ();
                }
            });
        }
    }
}
