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
    public class ModeButton : Gtk.Box {
        private int _selected = -1;
        public int selected {
            get {
                return _selected;
            }
            set {
                set_active (value);
            }
        }

        public uint n_items {
            get {
                return item_map.size;
            }
        }

        private Gee.HashMap<int, ModeItem> item_map;

        construct {
            spacing = 0;
            item_map = new Gee.HashMap<int, ModeItem> ();
        }

        public int append_text (string text) {
            var label = new Gtk.Label (text) {
                valign = Gtk.Align.CENTER,
                attributes = set_attribute (Pango.Weight.ULTRABOLD)
            };
            return appends (label);
        }

        public int append_icon_text (string icon_name, string name_label) {
            var gridn = new Gtk.Grid () {
                column_spacing = 4,
                valign = Gtk.Align.CENTER
            };
            var label = new Gtk.Label (name_label) {
                valign = Gtk.Align.CENTER,
                attributes = set_attribute (Pango.Weight.ULTRABOLD)
            };

            var badge_img = new Gtk.Image () {
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER,
                pixel_size = 18,
                icon_name = icon_name
            };
            gridn.attach (badge_img, 0, 0);
            gridn.attach (label, 1, 0);
            return appends (gridn);
        }

        public int append_icon (string icon_name, int pixle) {
            var gridn = new Gtk.Grid () {
                column_spacing = 4,
                valign = Gtk.Align.CENTER
            };
            var badge_img = new Gtk.Image () {
                halign = Gtk.Align.END,
                valign = Gtk.Align.END,
                pixel_size = pixle,
                icon_name = icon_name
            };
            gridn.attach (badge_img, 0, 0);
            return appends (gridn);
        }

        public int appends (Gtk.Widget w) {
            int index;
            for (index = item_map.size; item_map.has_key (index); index++);
            var item = new ModeItem (index) {
                child = w
            };
            item.toggled.connect (() => {
                if (item.active) {
                    selected = item.index;
                } else if (selected == item.index) {
                    item.active = true;
                }
            });
            item_map[index] = item;
            append (item);
            item.set_visible (true);
            return index;
        }

        public string get_icon_name (int index) {
            var new_item = item_map[index] as ModeItem;
            if (new_item != null) {
                return ((Gtk.Image) new_item.get_last_child ().get_first_child ()).icon_name;
            }
            return "com.github.gabutakut.gabutdm.progress";
        }

        public void set_active (int new_active_index) {
            if (new_active_index <= -1) {
                _selected = -1;
                return;
            }
            var new_item = item_map[new_active_index] as ModeItem;
            if (new_item != null) {
                new_item.set_active (true);
                if (new_item.child.name == "GtkLabel") {
                    ((Gtk.Label) new_item.child).attributes = color_attribute (0, 60000, 0);
                } else if (new_item.child.get_last_child ().name == "GtkLabel") {
                    ((Gtk.Label) new_item.child.get_last_child ()).attributes = color_attribute (0, 60000, 0);
                }
                if (_selected == new_active_index) {
                    return;
                }
                var old_item = item_map[_selected] as ModeItem;
                _selected = new_active_index;
                if (old_item != null) {
                    if (old_item.child.name == "GtkLabel") {
                        ((Gtk.Label) old_item.child).attributes = set_attribute (Pango.Weight.ULTRABOLD);
                    } else if (new_item.child.get_last_child ().name == "GtkLabel") {
                        ((Gtk.Label) old_item.child.get_last_child ()).attributes = set_attribute (Pango.Weight.ULTRABOLD);
                    }
                    old_item.set_active (false);
                }
            }
        }
    }
}