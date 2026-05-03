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
    public class DownloaderHls : Gtk.Dialog {
        public HLSLBox hlslbox {get; construct;}
        public Gtk.ScrolledWindow scrolled {get; construct;}
        public Gtk.Box boxarea;
        public Gtk.Button start_btn;
        public int status { get; set; default = StatusMode.WAIT;} 
        private string _filename;
        public string filename {
            get {
                return _filename;
            }
            construct {
                _filename = value;
            }
        }
        private BitfieldWidget bitfield_widget;

        public DownloaderHls (HLSLBox hlslbox, Gtk.ScrolledWindow scrolled, string filename) {
            Object (resizable: false, use_header_bar: 1, hlslbox: hlslbox, scrolled: scrolled, filename: filename);
        }

        construct {
            var view_mode = new ModeButton () {
                hexpand = true,
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            view_mode.append_icon_text ("com.github.gabutakut.gabutdm.progress", "All");
            view_mode.append_icon_text ("com.github.gabutakut.gabutdm.active","Active");
            view_mode.append_icon_text ("com.github.gabutakut.gabutdm.pause", "Paused");
            view_mode.append_icon_text ("com.github.gabutakut.gabutdm.complete", "Complete");
            view_mode.append_icon_text ("com.github.gabutakut.gabutdm.waiting", "Waiting");
            view_mode.append_icon_text ("com.github.gabutakut.gabutdm.error", "Error");
            view_mode.notify["selected"].connect (()=> {
                hlslbox.selected = view_mode.selected;
            });
            view_mode.selected = 0;

            var header = new Gtk.HeaderBar () {
                hexpand = true,
                decoration_layout = "none",
                title_widget = view_mode
            };
            set_titlebar (header);

            bitfield_widget = new BitfieldWidget (true, 1) {
                filename = filename,
                width_request = 680
            };
            move_window (this, bitfield_widget);
            hlslbox.full_progress.connect ((progres)=> {
                if (bitfield_widget != null) {
                    bitfield_widget.labeltransfer = progres;
                }
            });
            hlslbox.update_conn.connect ((act)=> {
                if (bitfield_widget != null) {
                    bitfield_widget.connectionsdl = act;
                }
            });

            hlslbox.bitfield_update.connect ((bitf, piece)=> {
                if (bitfield_widget != null) {
                    bitfield_widget.set_bitfield_data (bitf, piece);
                }
            });
            var close_button = new Gtk.Button.with_label (_("Close")) {
                width_request = 120,
                height_request = 25,
                halign = Gtk.Align.END
            };
            ((Gtk.Label) close_button.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            close_button.clicked.connect (()=> {
                if (boxarea.get_first_child ().name == "GtkScrolledWindow") {
                    boxarea.remove (scrolled);
                }
                close ();
            });

            start_btn = new Gtk.Button.with_label (_("Start")) {
                width_request = 120,
                height_request = 25,
            };
            ((Gtk.Label) start_btn.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);

            var box_action = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5) {
                halign = Gtk.Align.END
            };
            box_action.append (start_btn);
            box_action.append (close_button);
            var merged_btn = new Gtk.Button.with_label (_("Merge")) {
                width_request = 120,
                height_request = 25
            };
            ((Gtk.Label) merged_btn.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            merged_btn.clicked.connect (()=> {
                hlslbox.merge_files ();
            });
            hlslbox.notify["status"].connect (()=> {
                if (start_btn != null && merged_btn != null) {
                    bool statusb = (hlslbox.status == StatusMode.WAIT || hlslbox.status == StatusMode.ACTIVE);
                    merged_btn.sensitive = !statusb;
                    if (statusb) {
                        start_btn.set_label (_("Pause"));
                    } else {
                        start_btn.set_label (_("Start"));
                    }
                }
            });
            bool statusb = (hlslbox.status == StatusMode.WAIT || hlslbox.status == StatusMode.ACTIVE);
            merged_btn.sensitive = !statusb;
            if (statusb) {
                start_btn.set_label (_("Pause"));
            } else {
                start_btn.set_label (_("Start"));
            }
            hlslbox.notify["merged-ts"].connect (()=> {
                if (merged_btn != null) {
                    merged_btn.sensitive = !hlslbox.merged_ts;
                }
            });
            var centerbox = new Gtk.CenterBox () {
                margin_top = 10,
                margin_bottom = 10,
                start_widget = merged_btn,
                end_widget = box_action
            };

            boxarea = new Gtk.Box (Gtk.Orientation.VERTICAL, 0) {
                margin_start = 10,
                margin_end = 10
            };
            boxarea.append (scrolled);
            boxarea.append (bitfield_widget);
            boxarea.append (centerbox);
            set_child (boxarea);
        }

        public override void show () {
            base.show ();
        }

        public override bool close_request () {
            if (boxarea.get_first_child ().name == "GtkScrolledWindow") {
                boxarea.remove (scrolled);
            }
            return base.close_request ();
        }

        public override void close () {
            if (boxarea.get_first_child ().name == "GtkScrolledWindow") {
                boxarea.remove (scrolled);
            }
            base.close ();
        }
    }
}