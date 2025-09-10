/*
* Copyright (c) {2025} torikulhabib (https://github.com/gabutakut)
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
    public class DeleteDialog : Gtk.Dialog {
        public signal void excuterd ();
        private Gtk.Image icon_badge;
        private Gtk.Label item_file;
        public Gee.ArrayList<DownloadRow> datarow;
        private Gtk.ListBox lisbox_trash;
        private Gtk.Image icon_image;
        private Gtk.Label primarylabel;
        public string topikname;

        private string _primmelb;
        public string primmelb {
            get {
                return _primmelb;
            }
            set {
                _primmelb = value;
                primarylabel.label = _primmelb;
            }
        }

        private string _icimg;
        public string icimg {
            get {
                return _icimg;
            }
            set {
                _icimg = value;
                icon_image.icon_name = _icimg;
            }
        }

        construct {
            lisbox_trash = new Gtk.ListBox ();
            var scr_trash = new Gtk.ScrolledWindow () {
                hexpand = true,
                width_request = 450,
                height_request = 140,
                margin_bottom = 5,
                margin_top = 5,
                child = lisbox_trash
            };
            var revtrash = new Gtk.Revealer () {
                transition_type = Gtk.RevealerTransitionType.SLIDE_DOWN,
                child = scr_trash
            };
            resizable = false;
            use_header_bar = 1;
            icon_image = new Gtk.Image () {
                valign = Gtk.Align.START,
                halign = Gtk.Align.END,
                icon_size = Gtk.IconSize.LARGE,
                pixel_size = 64
            };

            icon_badge = new Gtk.Image () {
                halign = Gtk.Align.END,
                valign = Gtk.Align.END,
                gicon = new ThemedIcon ("com.github.gabutakut.gabutdm.error"),
                icon_size = Gtk.IconSize.LARGE
            };

            var overlay = new Gtk.Overlay () {
                child = icon_image
            };
            overlay.add_overlay (icon_badge);

            primarylabel = new Gtk.Label ("") {
                ellipsize = Pango.EllipsizeMode.END,
                max_width_chars = 45,
                use_markup = true,
                wrap = true,
                xalign = 0,
                margin_start = 10,
                attributes = set_attribute (Pango.Weight.ULTRABOLD, 1.6)
            };

            item_file = new Gtk.Label ("") {
                ellipsize = Pango.EllipsizeMode.END,
                max_width_chars = 58,
                use_markup = true,
                wrap = true,
                xalign = 0,
                attributes = set_attribute (Pango.Weight.SEMIBOLD, 1.1)
            };
            var filebtn = new Gtk.Button () {
                child = item_file,
                focus_on_click = false,
                has_frame = false
            };
            filebtn.clicked.connect (()=> {
                revtrash.reveal_child = !revtrash.reveal_child;
                lisbox_trash.remove_all ();
                datarow.foreach ((dlrw)=> {
                    var dlrws = new DeleteRow () {
                        filepath = dlrw.filepath,
                        filebasename = dlrw.filename,
                        totalsize = dlrw.totalsize
                    };
                    lisbox_trash.append (dlrws);
                    return  true;
                });
            });

            var header_grid = new Gtk.Grid () {
                column_spacing = 0,
                hexpand = true,
                halign = Gtk.Align.START,
                valign = Gtk.Align.CENTER
            };
            header_grid.attach (overlay, 0, 0, 1, 2);
            header_grid.attach (primarylabel, 1, 0, 1, 1);
            header_grid.attach (filebtn, 1, 1, 1, 1);

            var header = get_header_bar ();
            header.title_widget = header_grid;
            header.decoration_layout = "none";

            var move_file = new Gtk.Button.with_label (_("Trash")) {
                width_request = 120,
                height_request = 25
            };
            ((Gtk.Label) move_file.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            move_file.clicked.connect (()=> {
                excuterd ();
            });
            var close_button = new Gtk.Button.with_label (_("Cancel")) {
                width_request = 120,
                height_request = 25
            };
            ((Gtk.Label) close_button.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            close_button.clicked.connect (()=> {
                close ();
            });

            var box_action = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
            box_action.append (move_file);
            box_action.append (close_button);

            var centerbox = new Gtk.CenterBox () {
                margin_top = 10,
                margin_bottom = 10
            };
            centerbox.set_end_widget (box_action);
            var area = get_content_area ();
            area.margin_start = 10;
            area.margin_end = 10;
            area.halign = Gtk.Align.CENTER;
            area.append (revtrash);
            area.append (centerbox);
        }

        public override void show () {
            base.show ();
            if (datarow.size < 2) {
                item_file.label = _("%s").printf (datarow.get (0).filename);
                icon_badge.gicon = GLib.ContentType.get_icon (datarow.get (0).fileordir); 
            } else {
                item_file.label = _("%s %i item").printf (topikname,datarow.size);
            }
        }
    }
}