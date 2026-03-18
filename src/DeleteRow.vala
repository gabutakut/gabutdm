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
    public class DeleteRow : Gtk.ListBoxRow {
        private Gtk.Image fileimg;
        private Gtk.Image rmdlimg;
        private Gtk.Label filesizelabel;
        private Gtk.Label file_label;

        private string _iconrmdl;
        public string iconrmdl {
            get {
                return _iconrmdl;
            }
            set {
                _iconrmdl = value;
                rmdlimg.icon_name = _iconrmdl;
            }
        }

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
                file_label.label = GLib.Markup.escape_text (_filebasename);
                if (fileordir == "") {
                    fileordir = GLib.ContentType.guess(filebasename, null, null);
                }
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
            Gtk.Box row = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5) {
                margin_start = 2,
                margin_end = 5,
                hexpand = true
            };

            fileimg = new Gtk.Image () {
                valign = Gtk.Align.CENTER,
                halign = Gtk.Align.START
            };
            row.append (fileimg);

            file_label = new Gtk.Label (null) {
                xalign = 0,
                use_markup = true,
                width_request = 385,
                max_width_chars = 36,
                ellipsize = Pango.EllipsizeMode.MIDDLE,
                valign = Gtk.Align.CENTER,
                halign = Gtk.Align.START,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };
            row.append (file_label);

            filesizelabel = new Gtk.Label (null) {
                halign = Gtk.Align.END,
                attributes = color_attribute (0, 60000, 0)
            };
            row.append (filesizelabel);
            rmdlimg = new Gtk.Image () {
                valign = Gtk.Align.CENTER
            };
            row.append (rmdlimg);
            child = row;
        }
    }
}