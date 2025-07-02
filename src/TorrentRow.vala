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
    public class TorrentRow : Gtk.ListBoxRow {
        public signal void selecting (int index, bool selected);
        private Gtk.CheckButton checkbtn;
        private Gtk.Image fileimg;
        private Gtk.Image imgstatus;
        private Gtk.Label file_label;
        private Gtk.Label coplatelabel;
        private Gtk.Label filesizelabel;
        private Gtk.Label persenlabel;
        private Gtk.Label incompletelbl;
        private ProgressPaintable progrespaint;
        private Gtk.Popover popname;
        private Gtk.Popover popcomplete;
        private Gtk.Popover poppath;

        private int _index;
        public int index {
            get {
                return _index;
            }
            set {
                _index = value;
            }
        }

        private bool _selected;
        public bool selected {
            get {
                return _selected;
            }
            set {
                _selected = value;
                checkbtn.active = _selected;
            }
        }

        private string _filepath;
        public string filepath {
            get {
                return _filepath;
            }
            set {
                _filepath = value;
                fileimg.gicon = GLib.ContentType.get_icon (get_mime_type (GLib.File.new_for_path (_filepath)));
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
                var indexlbl = new Gtk.Label (_("No. %s").printf(index.to_string ())) {
                    attributes = color_attribute (60000, 0, 0)
                };
                popname.child = indexlbl;
                var filenm = new Gtk.Label (filebasename) {
                    attributes = set_attribute (Pango.Weight.SEMIBOLD)
                };
                poppath.child = filenm;
            }
        }

        private string _sizetransfered;
        public string sizetransfered {
            get {
                return _sizetransfered;
            }
            set {
                _sizetransfered = value;
                filesizelabel.label = GLib.format_size (int64.parse (_sizetransfered));
                if (completesize != null) {
                    incompletelbl.label = GLib.format_size (int64.parse (completesize) - int64.parse (_sizetransfered));
                }
            }
        }

        private string _completesize;
        public string completesize {
            get {
                return _completesize;
            }
            set {
                _completesize = value;
                coplatelabel.label = GLib.format_size (int64.parse (_completesize));
                if (sizetransfered != null) {
                    incompletelbl.label = GLib.format_size (int64.parse (completesize) - int64.parse (_sizetransfered));
                }
            }
        }

        private double _fraction;
        public double fraction {
            get {
                return _fraction;
            }
            set {
                _fraction = value;
                progrespaint.progress = _fraction;
            }
        }

        private int _persen;
        public int persen {
            get {
                return _persen;
            }
            set {
                _persen = value;
                persenlabel.label = _("%s%s").printf (_persen.to_string (), "%");
            }
        }

        private string _status;
        public string status {
            get {
                return _status;
            }
            set {
                _status = value;
                imgstatus.tooltip_text = _status;
                imgstatus.gicon = new ThemedIcon (_status.down () == "waiting"? "com.github.gabutakut.gabutdm.waiting" : "com.github.gabutakut.gabutdm.active");
            }
        }

        construct {
            checkbtn = new Gtk.CheckButton ();
            checkbtn.toggled.connect (()=> {
                selecting (index, !selected);
            });

            fileimg = new Gtk.Image () {
                valign = Gtk.Align.CENTER
            };
            popname = new Gtk.Popover ();
            var openname = new Gtk.MenuButton () {
                focus_on_click = false,
                has_frame = false,
                child = fileimg,
                popover = popname,
                tooltip_text = _("Details")
            };

            file_label = new Gtk.Label (null) {
                xalign = 0,
                use_markup = true,
                width_request = 250,
                max_width_chars = 36,
                ellipsize = Pango.EllipsizeMode.MIDDLE,
                valign = Gtk.Align.CENTER,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };

            poppath = new Gtk.Popover ();
            var openpath = new Gtk.MenuButton () {
                focus_on_click = false,
                has_frame = false,
                child = file_label,
                popover = poppath,
                tooltip_text = _("Path")
            };
            var downloadingimg = new Gtk.Image () {
                valign = Gtk.Align.CENTER,
                gicon = new ThemedIcon ("com.github.gabutakut.gabutdm.down")
            };
            incompletelbl = new Gtk.Label (null) {
                attributes = color_attribute (60000, 30000, 0)
            };
            popcomplete = new Gtk.Popover ();
            popcomplete.child = incompletelbl;
            var getfilebtn = new Gtk.MenuButton () {
                focus_on_click = false,
                has_frame = false,
                child = downloadingimg,
                popover = popcomplete,
                tooltip_text = _("Info")
            };
            filesizelabel = new Gtk.Label (null) {
                xalign = 0,
                use_markup = true,
                width_request = 55,
                valign = Gtk.Align.CENTER,
                attributes = color_attribute (0, 60000, 0)
            };

            coplatelabel = new Gtk.Label (null) {
                xalign = 0,
                use_markup = true,
                width_request = 55,
                valign = Gtk.Align.CENTER,
                attributes = color_attribute (60000, 30000, 0)
            };

            progrespaint = new ProgressPaintable ();
            var progresimg = new Gtk.Image () {
                paintable = progrespaint,
                valign = Gtk.Align.CENTER,
                width_request = 20
            };
            progrespaint.queue_draw.connect (progresimg.queue_draw);
            var openilocation = new Gtk.Button () {
                focus_on_click = false,
                has_frame = false,
                child = progresimg,
                tooltip_text = _("Location")
            };
            openilocation.clicked.connect (()=> {
                var file = File.new_for_path (filepath);
                if (file == null) {
                    return;
                }
                if (get_finfo (file).get_content_type () == "inode/directory") {
                    open_fileman.begin (file.get_uri ());
                } else {
                    open_fileman.begin (file.get_parent ().get_uri ());
                }
            });
            persenlabel = new Gtk.Label (null) {
                xalign = 0,
                use_markup = true,
                valign = Gtk.Align.CENTER,
                halign = Gtk.Align.CENTER,
                attributes = set_attribute (Pango.Weight.BOLD)
            };

            imgstatus = new Gtk.Image () {
                valign = Gtk.Align.CENTER,
                gicon = new ThemedIcon ("com.github.gabutakut.gabutdm.active"),
                tooltip_text = _("Status")
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
            grid.attach (checkbtn, 0, 0);
            grid.attach (openname, 1, 0);
            grid.attach (openpath, 2, 0);
            grid.attach (getfilebtn, 3, 0);
            grid.attach (filesizelabel, 4, 0);
            grid.attach (openilocation, 5, 0);
            grid.attach (coplatelabel, 6, 0);
            grid.attach (imgstatus, 7, 0);
            grid.attach (persenlabel, 8, 0);
            child = grid;
        }
    }
}