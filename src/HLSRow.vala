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
    public class HLSRow : Gtk.ListBoxRow {
        public int index { get; construct; }
        private string _output_file;
        public string output_file {
            get {
                return _output_file;
            }
            construct {
                _output_file = value;
            }
        }
        private string _filename;
        public string filename {
            get {
                return _filename;
            }
            construct {
                _filename = value;
            }
        }
        public Gtk.Button start_button;
        private Gtk.Label filename_label { get; set; }
        private Gtk.Label progress_label { get; set; }
        private Gtk.Label name_label { get; set; }
        private Gtk.Label size_label { get; set; }
        private ProgressPaintable progrespaint { get; set; }

        private int _status;
        public int status {
            get {
                return _status;
            }
            set {
                _status = value;
                switch (value) {
                    case StatusMode.PAUSED:
                        start_button.icon_name = "com.github.gabutakut.gabutdm.pause";
                        start_button.tooltip_text = _("Paused");
                        break;
                    case StatusMode.COMPLETE:
                        start_button.icon_name = "com.github.gabutakut.gabutdm.complete";
                        start_button.tooltip_text = _("Complete");
                        break;
                    case StatusMode.ERROR:
                        start_button.icon_name = "com.github.gabutakut.gabutdm.error";
                        start_button.tooltip_text = _("Error");
                        break;
                    case StatusMode.ACTIVE:
                        start_button.icon_name = "com.github.gabutakut.gabutdm.active";
                        start_button.tooltip_text = _("Downloading");
                        break;
                    default:
                        start_button.icon_name = "com.github.gabutakut.gabutdm.waiting";
                        start_button.tooltip_text = _("Waiting");
                        break;
                }
            }
        }

        public HLSRow(int index, string filename, string output_file) {
            Object(index: index, filename: filename, output_file: output_file);
        }

        construct {
            var box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 2) {
                margin_start = 2,
                margin_end = 2
            };
            var icon = new Gtk.Image.from_icon_name ("applications-multimedia") {
                pixel_size = 18
            };
            box.append(icon);

            var tabs = new Pango.TabArray (1, true);
            tabs.set_tab(0, Pango.TabAlign.RIGHT, 450);

            name_label = new Gtk.Label(filename) {
                halign = Gtk.Align.START,
                hexpand = true,
                xalign = 0,
                valign = Gtk.Align.CENTER,
                tabs = tabs,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };
            box.append(name_label);

            size_label = new Gtk.Label(null) {
                halign = Gtk.Align.END,
                valign = Gtk.Align.CENTER,
                attributes = color_attribute (0, 60000, 0)
            };
            box.append(size_label);

            progress_label = new Gtk.Label("") {
                halign = Gtk.Align.END,
                width_chars = 8,
                attributes = color_attribute (60000, 30000, 0)
            };
            box.append(progress_label);            

            progrespaint = new ProgressPaintable ();
            var progresimg = new Gtk.Image () {
                paintable = progrespaint,
                valign = Gtk.Align.CENTER,
                width_request = 20
            };
            progrespaint.queue_draw.connect (progresimg.queue_draw);
            var open_button = new Gtk.Button () {
                focus_on_click = false,
                has_frame = false,
                valign = Gtk.Align.CENTER,
                child = progresimg,
                tooltip_text = _("Path")
            };
            open_button.clicked.connect (()=> {
                var file = File.new_for_path (output_file);
                if (file.query_exists ()) {
                    open_fileman.begin (file.get_uri());
                }
            });
            box.append(open_button);

            start_button = new Gtk.Button.from_icon_name ("com.github.gabutakut.gabutdm.waiting") {
                valign = Gtk.Align.CENTER,
                has_frame = false
            };
            ((Gtk.Image) start_button.get_first_child ()).pixel_size = 18;
            box.append(start_button);
            child = box;
        }

        public void update_status(int status, int64 filesize, string info, double progress = 0) {
            if (this.status != StatusMode.COMPLETE) {
                this.status = status;
                progress_label.label = _("%d%s").printf((int)(progress * 100),"%");
                name_label.label = _("%s\t%s").printf(filename, info);
                progrespaint.progress = progress;
                size_label.label = GLib.format_size(filesize);
            }
        }
    }
}