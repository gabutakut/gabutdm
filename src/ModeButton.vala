/*
 * Copyright 2019 elementary, Inc. (https://elementary.io)
 * Copyright 2008–2013 Christian Hergert <chris@dronelabs.com>,
 * Copyright 2008–2013 Giulio Collura <random.cpp@gmail.com>,
 * Copyright 2008–2013 Victor Eduardo <victoreduardm@gmail.com>,
 * Copyright 2008–2013 ammonkey <am.monkeyd@gmail.com>
 * SPDX-License-Identifier: LGPL-3.0-or-later
 */

namespace Gabut {
    public class ModeButton : Gtk.Box {
        private class Item : Gtk.CheckButton {
            public int index { get; construct; }
            public Item (int index) {
                Object (index: index);
            }
        }

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

        private Gee.HashMap<int, Item> item_map;

        construct {
            spacing = 0;
            item_map = new Gee.HashMap<int, Item> ();
        }

        public int append_text (string text) {
            var label = new Gtk.Label (text) {
                valign = Gtk.Align.CENTER,
                attributes = set_attribute (Pango.Weight.ULTRABOLD)
            };
            return appends (label);
        }

        public int append_icon_text (string icon_name, string name_label) {
            var label = new Gtk.Label (name_label) {
                valign = Gtk.Align.CENTER,
                attributes = set_attribute (Pango.Weight.ULTRABOLD)
            };
            var gridn = new Gtk.Grid () {
                column_spacing = 4,
                valign = Gtk.Align.CENTER
            };
            gridn.attach (new Gtk.Image.from_icon_name (icon_name), 0, 0);
            gridn.attach (label, 1, 0);
            return appends (gridn);
        }

        public int appends (Gtk.Widget w) {
            int index;
            for (index = item_map.size; item_map.has_key (index); index++);
            var item = new Item (index) {
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
            item.show ();
            return index;
        }

        public void set_active (int new_active_index) {
            if (new_active_index <= -1) {
                _selected = -1;
                return;
            }
            var new_item = item_map[new_active_index] as Item;
            if (new_item != null) {
                new_item.set_active (true);
                if (new_item.child.name == "GtkLabel") {
                    ((Gtk.Label) new_item.child).attributes = color_attribute (0, 60000, 0);
                } else {
                    ((Gtk.Label) new_item.child.get_last_child ()).attributes = color_attribute (0, 60000, 0);
                }
                if (_selected == new_active_index) {
                    return;
                }
                var old_item = item_map[_selected] as Item;
                _selected = new_active_index;
                if (old_item != null) {
                    if (old_item.child.name == "GtkLabel") {
                        ((Gtk.Label) old_item.child).attributes = set_attribute (Pango.Weight.ULTRABOLD);
                    } else {
                        ((Gtk.Label) old_item.child.get_last_child ()).attributes = set_attribute (Pango.Weight.ULTRABOLD);
                    }
                    old_item.set_active (false);
                }
            }
        }
    }
}