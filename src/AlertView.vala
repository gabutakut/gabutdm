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
    public class AlertView : Gtk.Grid {
        public string title {
            get {
                return title_label.label;
            }
            set {
                title_label.label = value;
            }
        }

        public string description {
            get {
                return description_label.label;
            }
            set {
                description_label.label = value;
            }
        }

        public string icon_name {
            owned get {
                return image.icon_name ?? "";
            }
            set {
                if (value != null && value != "") {
                    image.set_from_icon_name (value);
                    image.set_visible (true);
                } else {
                    image.set_visible (false);
                }
            }
        }

        private Gtk.Label title_label;
        private Gtk.Label description_label;
        private Gtk.Image image;

        public AlertView (string title, string description, string icon_name) {
            Object (title: title, description: description, icon_name: icon_name, column_spacing: 12, row_spacing: 6, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER,vexpand: true);
        }

        construct {
            title_label = new Gtk.Label (null) {
                max_width_chars = 75,
                wrap = true,
                hexpand = true,
                wrap_mode = Pango.WrapMode.WORD_CHAR,
                xalign = 0,
                attributes = set_attribute (Pango.Weight.BOLD, 2)
            };

            description_label = new Gtk.Label (null) {
                hexpand = true,
                max_width_chars = 75,
                wrap = true,
                use_markup = true,
                xalign = 0,
                valign = Gtk.Align.START,
                attributes = set_attribute (Pango.Weight.SEMIBOLD, 1.1)
            };

            image = new Gtk.Image () {
                margin_top = 6,
                valign = Gtk.Align.START,
                icon_size = Gtk.IconSize.LARGE,
                pixel_size = 64
            };
            attach (image, 1, 1, 1, 2);
            attach (title_label, 2, 1, 1, 1);
            attach (description_label, 2, 2, 1, 1);
        }
    }
}
