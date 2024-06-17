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
    public class ModeTogle : Gtk.Box {
        private int _id = 0;
        public int id {
            get {
                return _id;
            }
            set {
                _id = value;
                if (menuchildren != null) {
                    menuchildren.nth_data (id).checkbtn.active = true;
                }
            }
        }

        private GLib.List<ModeTogle> menuchildren = null;
        public Gtk.CheckButton checkbtn;

        public ModeTogle.with_label (string value) {
            checkbtn.set_label (value);
        }

        public ModeTogle.with_icon_label (string value, string nameico) {
            var title = new Gtk.Label (value) {
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER,
                wrap_mode = Pango.WrapMode.WORD_CHAR,
                attributes = set_attribute (Pango.Weight.BOLD),
                width_request = 110
            };
            var dateimg = new Gtk.Image () {
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER,
                gicon = new ThemedIcon (nameico)
            };
            var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            box.append (title);
            box.append (dateimg);
            checkbtn.child = box;
        }

        construct {
            orientation = Gtk.Orientation.VERTICAL;
            checkbtn = new Gtk.CheckButton () {
                margin_top = 5
            };
        }

        public void set_label (string value) {
            checkbtn.set_label (value);
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
                child.id = (int) menuchildren.length () - 1;
                if (child.id > 0) {
                    child.checkbtn.set_group (menuchildren.nth_data ((uint) child.id - 1).checkbtn);
                }
                child.checkbtn.toggled.connect (()=> {
                    if (child.checkbtn.active) {
                        if (child.checkbtn.get_last_child ().name == "GtkBox") {
                            ((Gtk.Label)menuchildren.nth_data (id).checkbtn.get_last_child ().get_first_child ()).attributes = set_attribute (Pango.Weight.BOLD);
                            ((Gtk.Label)child.checkbtn.get_last_child ().get_first_child ()).attributes = color_attribute (0, 60000, 0);
                        }
                        id = child.id;
                    }
                });
                append (child.checkbtn);
            }
        }
    }
}