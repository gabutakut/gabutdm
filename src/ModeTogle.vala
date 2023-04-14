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
    public class ModeTogle : GLib.Object {
        public signal void item_activated (int id);

        private int _id = 0;
        public int id {
            get {
                return _id;
            }
            set {
                _id = value;
                if (menuchildren != null) {
                    menuchildren.foreach ((menu)=> {
                        if (menu.id == _id) {
                            menu.menucheckbox.active = true;
                        }
                    });
                }
            }
        }

        public GLib.List<ModeTogle> menuchildren = null;
        public Gtk.CheckButton menucheckbox;

        public ModeTogle.with_label (string value) {
            menucheckbox.set_label (value);
        }

        construct {
            menucheckbox = new Gtk.CheckButton () {
                margin_top = 5
            };
        }

        private Gtk.CheckButton get_checkbox () {
            return menucheckbox;
        }

        public void set_label (string value) {
            menucheckbox.set_label (value);
        }

        private bool get_exist (ModeTogle children) {
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

        public void add_item (ModeTogle child) {
            if (menuchildren == null) {
                menuchildren = new GLib.List<ModeTogle> ();
            }
            if (!get_exist (child)) {
                menuchildren.append (child);
                menuchildren.foreach ((item)=> {
                    item.id = menuchildren.index (item);
                    if (item.id > 0) {
                        item.menucheckbox.set_group (menuchildren.nth_data ((uint) item.id - 1).menucheckbox);
                    }
                });
            }
        }

        public Gtk.Box get_box () {
            var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
            menuchildren.foreach ((menu)=> {
                menu.menucheckbox.toggled.connect (()=> {
                    if (menu.menucheckbox.active) {
                        id = menu.id;
                        item_activated (id);
                    }
                });
                box.append (menu.get_checkbox ());
            });
            return box;
        }

        public void sensitive_box (bool sensitivebox) {
            menuchildren.foreach ((menu)=> {
                menu.menucheckbox.sensitive = sensitivebox;
            });
        }
    }
}
