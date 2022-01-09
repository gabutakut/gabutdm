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
    public class QrCode : Gtk.Dialog {
        public signal string get_host (bool reboot);
        private Gtk.Image imageqr;
        private Gtk.LinkButton linkbutton;
        private Gtk.Button host_button;
        private bool local_server;

        public QrCode (Gtk.Application application) {
            Object (application: application,
                    resizable: false,
                    use_header_bar: 1
            );
        }

        construct {
            var icon_image = new Gtk.Image () {
                valign = Gtk.Align.START,
                halign = Gtk.Align.END,
                pixel_size = 64,
                gicon = new ThemedIcon ("go-home")
            };

            var icon_badge = new Gtk.Image () {
                halign = Gtk.Align.END,
                valign = Gtk.Align.END,
                gicon = new ThemedIcon ("emblem-favorite"),
                icon_size = Gtk.IconSize.LARGE_TOOLBAR
            };

            var overlay = new Gtk.Overlay ();
            overlay.add (icon_image);
            overlay.add_overlay (icon_badge);

            var primary = new Gtk.Label ("Scan QR Code") {
                ellipsize = Pango.EllipsizeMode.END,
                max_width_chars = 35,
                use_markup = true,
                wrap = true,
                xalign = 0,
                attributes = set_attribute (Pango.Weight.ULTRABOLD, 1.6)
            };

            var secondary = new Gtk.Label ("Address Gabut Server") {
                ellipsize = Pango.EllipsizeMode.END,
                max_width_chars = 35,
                use_markup = true,
                wrap = true,
                xalign = 0,
                attributes = set_attribute (Pango.Weight.SEMIBOLD, 1.1)
            };

            var header_grid = new Gtk.Grid () {
                column_spacing = 0,
                width_request = 150,
                margin_start = 4,
                margin_top = 4
            };
            header_grid.attach (overlay, 0, 0, 1, 2);
            header_grid.attach (primary, 1, 0, 1, 1);
            header_grid.attach (secondary, 1, 1, 1, 1);

            var header = get_header_bar ();
            header.has_subtitle = false;
            header.show_close_button = false;
            header.pack_start (header_grid);

            imageqr = new Gtk.Image () {
                margin_top = 10,
                margin_bottom = 5
            };

            linkbutton = new Gtk.LinkButton ("");
            var link_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                margin_top = 5,
                margin_bottom = 5
            };
            link_box.set_center_widget (linkbutton);

            var close_button = new Gtk.Button.with_label (_("Close"));
            close_button.clicked.connect (()=> {
                destroy ();
            });

            host_button = new Gtk.Button.with_label (_("Share Host"));
            host_button.clicked.connect (share_server);

            var box_action = new Gtk.Grid () {
                width_request = 210,
                margin_top = 10,
                margin_bottom = 10,
                column_spacing = 10,
                column_homogeneous = true,
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER,
                orientation = Gtk.Orientation.HORIZONTAL
            };
            box_action.add (host_button);
            box_action.add (close_button);

            var maingrid = new Gtk.Grid () {
                orientation = Gtk.Orientation.VERTICAL,
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER,
                margin_start = 10,
                margin_end = 10,
                width_request = 210,
                height_request = 200
            };
            maingrid.add (imageqr);
            maingrid.add (link_box);
            maingrid.add (box_action);

            get_content_area ().add (maingrid);
            move_widget (this);
        }

        public override void show () {
            base.show ();
            local_server = bool.parse (get_dbsetting (DBSettings.IPLOCAL));
            Idle.add (()=> {
                return load_host (false);
            });
        }

        private void share_server () {
            local_server = !local_server;
            set_dbsetting (DBSettings.IPLOCAL, local_server.to_string ());
            load_host (true);
        }

        private bool load_host (bool reboot) {
            if (local_server) {
                host_button.label =_("Share Address");
            } else {
                host_button.label = _("Stop Share");
            }
            string host = get_host (reboot);
            create_qrcode (host);
            linkbutton.uri = host;
            linkbutton.label = host;
            return false;
        }

        private void create_qrcode (string strinput) {
            var qrencode = new Qrencode.QRcode.encodeData (strinput.length, strinput.data, 1, Qrencode.EcLevel.M);
            int qrenwidth = qrencode.width;
            int sizeqrcode = 20 + qrenwidth * 4;
            Cairo.ImageSurface surface = new Cairo.ImageSurface (Cairo.Format.RGB30, sizeqrcode, sizeqrcode);
            Cairo.Context context = new Cairo.Context (surface);
            context.set_source_rgb (1.0, 1.0, 1.0);
            context.rectangle (0, 0, sizeqrcode, sizeqrcode);
            context.fill ();
            char* qrentdata = qrencode.data;
            for (int y = 0; y < qrenwidth; y++) {
                for (int x = 0; x < qrenwidth; x++) {
                    int rectx = 10 + x * 4;
                    int recty = 10 + y * 4;
                    int digit_ornot = 0;
                    digit_ornot += (*qrentdata & 1);
                    if (digit_ornot == 1) {
                        context.set_source_rgb (0.0, 0.0, 0.0);
                    } else {
                        context.set_source_rgb (1.0, 1.0, 1.0);
                    }
                    context.rectangle (rectx, recty, 4, 4);
                    context.fill ();
                    qrentdata++;
                }
            }
            imageqr.set_from_surface (surface);
        }
    }
}
