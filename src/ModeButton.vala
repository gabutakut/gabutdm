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
        private class Item : Gtk.ToggleButton {
            public int index { get; construct; }
            public Item (int index) {
                Object (index: index);
            }
        }

        public signal void mode_added (int index, Gtk.Widget widget);
        public signal void mode_changed (Gtk.Widget widget);

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
            homogeneous = true;
            spacing = 0;
            item_map = new Gee.HashMap<int, Item> ();
        }

        public int append_pixbuf (Gdk.Pixbuf pixbuf) {
            return appends (new Gtk.Image.from_pixbuf (pixbuf));
        }

        public int append_text (string text) {
            var label = new Gtk.Label (text) {
                attributes = set_attribute (Pango.Weight.MEDIUM)
            };
            return appends (label);
        }

        public int append_icon (string icon_name, Gtk.IconSize size) {
            var img = new Gtk.Image.from_icon_name (icon_name) {
                icon_size = size,
                pixel_size = 32
            };
            return appends (img);
        }

        public int appends (Gtk.Widget w) {
            int index;
            for (index = item_map.size; item_map.has_key (index); index++);
            assert (item_map[index] == null);

            var item = new Item (index);
            item.set_child (w);

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
            mode_added (index, w);
            return index;
        }

        private void clear_selected () {
            _selected = -1;

            foreach (var item in item_map.values) {
                if (item != null && item.active) {
                    item.set_active (false);
                }
            }
        }

        public void set_active (int new_active_index) {
            if (new_active_index <= -1) {
                clear_selected ();
                return;
            }

            return_if_fail (item_map.has_key (new_active_index));
            var new_item = item_map[new_active_index] as Item;

            if (new_item != null) {
                assert (new_item.index == new_active_index);
                new_item.set_active (true);

                if (_selected == new_active_index) {
                    return;
                }
                var old_item = item_map[_selected] as Item;
                _selected = new_active_index;

                if (old_item != null) {
                    old_item.set_active (false);
                }
                mode_changed (new_item.get_child ());
            }
        }
    }
}
