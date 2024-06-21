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
    public class ServerRow : Gtk.ListBoxRow {
        private Gtk.Label download_rate;
        private Gtk.Label currenturi_label;

        private int _index;
        public int index {
            get {
                return _index;
            }
            set {
                _index = value;
            }
        }

        private string _currenturi;
        public string currenturi {
            get {
                return _currenturi;
            }
            set {
                _currenturi = value;
                currenturi_label.tooltip_text = currenturi_label.label = _currenturi;
            }
        }

        private string _downloadspeed;
        public string downloadspeed {
            get {
                return _downloadspeed;
            }
            set {
                _downloadspeed = value;
                download_rate.label = _downloadspeed;
            }
        }

        private string _uriserver;
        public string uriserver {
            get {
                return _uriserver;
            }
            set {
                _uriserver = value;
            }
        }

        construct {
            var gdm_id = new Gtk.Image () {
                valign = Gtk.Align.CENTER,
                gicon = new ThemedIcon ("com.github.gabutakut.gabutdm")
            };

            var label_download = new Gtk.Image () {
                valign = Gtk.Align.CENTER,
                gicon = new ThemedIcon ("com.github.gabutakut.gabutdm.down")
            };
            download_rate = new Gtk.Label (null) {
                xalign = 0,
                use_markup = true,
                width_request = 60,
                valign = Gtk.Align.CENTER,
                attributes = color_attribute (0, 60000, 0)
            };
            var label_uri = new Gtk.Image () {
                valign = Gtk.Align.CENTER,
                gicon = new ThemedIcon ("com.github.gabutakut.gabutdm.uri")
            };
            currenturi_label = new Gtk.Label (null) {
                xalign = 0,
                use_markup = true,
                valign = Gtk.Align.CENTER,
                max_width_chars = 100,
                ellipsize = Pango.EllipsizeMode.END,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };

            var grid = new Gtk.Grid () {
                hexpand = true,
                margin_start = 4,
                margin_end = 4,
                margin_top = 2,
                margin_bottom = 2,
                column_spacing = 4,
                row_spacing = 2,
                valign = Gtk.Align.CENTER
            };
            grid.attach (gdm_id, 0, 0);
            grid.attach (label_download, 1, 0);
            grid.attach (download_rate, 2, 0);
            grid.attach (label_uri, 3, 0);
            grid.attach (currenturi_label, 4, 0);
            child = grid;
        }
    }
}