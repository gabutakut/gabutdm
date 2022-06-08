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
                icon_size = Gtk.IconSize.LARGE
            };

            var overlay = new Gtk.Overlay () {
                child = icon_image
            };
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
                halign = Gtk.Align.START,
                valign = Gtk.Align.CENTER,
                column_spacing = 0,
                hexpand = true
            };
            header_grid.attach (overlay, 0, 0, 1, 2);
            header_grid.attach (primary, 1, 0, 1, 1);
            header_grid.attach (secondary, 1, 1, 1, 1);

            var header = get_header_bar ();
            header.title_widget = header_grid;
            header.decoration_layout = "none";

            imageqr = new Gtk.Image () {
                halign = Gtk.Align.START,
                width_request = 250,
                margin_bottom = 5,
                pixel_size = 128
            };

            linkbutton = new Gtk.LinkButton ("");
            var link_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER,
                margin_top = 5,
                margin_bottom = 5
            };
            link_box.append (linkbutton);

            var close_button = new Gtk.Button.with_label (_("Close")) {
                width_request = 120,
                height_request = 25
            };
            close_button.clicked.connect (()=> {
                close ();
            });

            host_button = new Gtk.Button.with_label (_("Share Host")) {
                width_request = 120,
                height_request = 25
            };
            host_button.clicked.connect (share_server);

            var box_action = new Gtk.Grid () {
                margin_top = 10,
                margin_bottom = 10,
                column_spacing = 10,
                column_homogeneous = true,
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            box_action.attach (host_button, 0, 0);
            box_action.attach (close_button, 1, 0);

            var maingrid = new Gtk.Grid () {
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER,
                hexpand = true,
                margin_top = 15,
                margin_start = 10,
                margin_end = 10
            };
            maingrid.attach (imageqr, 0, 0);
            maingrid.attach (link_box, 0, 1);
            maingrid.attach (box_action, 0, 2);

            child = maingrid;
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
                ((Gtk.Label) linkbutton.get_last_child ()).attributes = color_attribute (60000, 0, 0);
            } else {
                host_button.label = _("Stop Share");
                ((Gtk.Label) linkbutton.get_last_child ()).attributes = color_attribute (60000, 37000, 0);
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
            int sizeqrcode = 200 + qrenwidth * 40;
            Cairo.ImageSurface surface = new Cairo.ImageSurface (Cairo.Format.RGB30, sizeqrcode, sizeqrcode);
            Cairo.Context context = new Cairo.Context (surface);
            context.set_source_rgb (1.0, 1.0, 1.0);
            context.rectangle (0, 0, sizeqrcode, sizeqrcode);
            context.fill ();
            char* qrentdata = qrencode.data;
            for (int y = 0; y < qrenwidth; y++) {
                for (int x = 0; x < qrenwidth; x++) {
                    int rectx = 100 + x * 40;
                    int recty = 100 + y * 40;
                    int digit_ornot = 0;
                    digit_ornot += (*qrentdata & 1);
                    if (digit_ornot == 1) {
                        context.set_source_rgb (0.0, 0.0, 0.0);
                    } else {
                        context.set_source_rgb (1.0, 1.0, 1.0);
                    }
                    context.rectangle (rectx, recty, 40, 40);
                    context.fill ();
                    qrentdata++;
                }
            }
            imageqr.set_from_pixbuf (Gdk.pixbuf_get_from_surface (surface, 0, 0, sizeqrcode, sizeqrcode));
        }
    }
}
