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
    public class DeleteRow : Gtk.ListBoxRow {
        private Gtk.Image fileimg;
        private Gtk.Label filesizelabel;
        private Gtk.Label file_label;

        private string _fileordir;
        public string fileordir {
            get {
                return _fileordir;
            }
            set {
                _fileordir = value;
                fileimg.gicon =  GLib.ContentType.get_icon (_fileordir);
            }
        }

        private string _filebasename;
        public string filebasename {
            get {
                return _filebasename;
            }
            set {
                _filebasename = value;
                file_label.label = _filebasename;
            }
        }

        private int64 _totalsize;
        public int64 totalsize {
            get {
                return _totalsize;
            }
            set {
                _totalsize = value.abs ();
                filesizelabel.label = GLib.format_size (_totalsize);
            }
        }

        construct {
            fileimg = new Gtk.Image () {
                valign = Gtk.Align.CENTER
            };

            file_label = new Gtk.Label (null) {
                xalign = 0,
                use_markup = true,
                width_request = 395,
                max_width_chars = 36,
                ellipsize = Pango.EllipsizeMode.MIDDLE,
                valign = Gtk.Align.CENTER,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };

            filesizelabel = new Gtk.Label (null) {
                xalign = 0,
                use_markup = true,
                width_request = 55,
                halign = Gtk.Align.END,
                attributes = color_attribute (0, 60000, 0)
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
            grid.attach (fileimg, 1, 0);
            grid.attach (file_label, 2, 0);
            grid.attach (filesizelabel, 3, 0);
            child = grid;
        }
    }
}