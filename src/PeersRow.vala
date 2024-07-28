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
    public class PeersRow : Gtk.ListBoxRow {
        private Gtk.Label download_rate;
        private Gtk.Label host_label;
        private Gtk.Label client_id;
        private Gtk.Label upload_rate;
        private Gtk.Image seeder_img;
        private Gtk.Image imgamchok;
        private Gtk.Image imgpeerchok;

        private string _host;
        public string host {
            get {
                return _host;
            }
            set {
                _host = value;
                host_label.label = _("%s").printf (_host);
            }
        }

        private string _peerschoking;
        public string peerschoking {
            get {
                return _peerschoking;
            }
            set {
                _peerschoking = value;
                imgpeerchok.icon_name = _peerschoking;
            }
        }

        private string _peerid;
        public string peerid {
            get {
                return _peerid;
            }
            set {
                _peerid = value;
                client_id.label = _("%s").printf (_peerid);
            }
        }

        private string _downloadspeed;
        public string downloadspeed {
            get {
                return _downloadspeed;
            }
            set {
                _downloadspeed = value;
                download_rate.label = _("%s").printf (_downloadspeed);
            }
        }

        private string _uploadspeed;
        public string uploadspeed {
            get {
                return _uploadspeed;
            }
            set {
                _uploadspeed = value;
                upload_rate.label = _("%s").printf (_uploadspeed);
            }
        }

        private string _seeder;
        public string seeder {
            get {
                return _seeder;
            }
            set {
                _seeder = value;
                seeder_img.icon_name =_seeder;
            }
        }

        private string _amchoking;
        public string amchoking {
            get {
                return _amchoking;
            }
            set {
                _amchoking = value;
                imgamchok.icon_name = _amchoking;
            }
        }
        private string _bitfield;
        public string bitfield {
            get {
                return _bitfield;
            }
            set {
                _bitfield = value;
            }
        }
        construct {
            seeder_img = new Gtk.Image () {
                valign = Gtk.Align.CENTER,
                tooltip_text = _("Seeder")
            };
            var host_id = new Gtk.Image () {
                valign = Gtk.Align.CENTER,
                icon_name = "com.github.gabutakut.gabutdm.gohome",
                tooltip_text = _("Host")
            };

            host_label = new Gtk.Label (null) {
                xalign = 0,
                use_markup = true,
                width_request = 180,
                valign = Gtk.Align.CENTER,
                attributes = color_attribute (0, 30000, 50000)
            };
            var peer_id = new Gtk.Image () {
                valign = Gtk.Align.CENTER,
                icon_name = "com.github.gabutakut.gabutdm.client",
                tooltip_text = _("Client")
            };

            client_id = new Gtk.Label (null) {
                xalign = 0,
                use_markup = true,
                width_request = 150,
                valign = Gtk.Align.CENTER,
                attributes = color_attribute (50000, 30000, 0)
            };
            var label_download = new Gtk.Image () {
                valign = Gtk.Align.CENTER,
                icon_name = "com.github.gabutakut.gabutdm.down",
                tooltip_text = _("Download Speed")
            };
            download_rate = new Gtk.Label (null) {
                xalign = 0,
                use_markup = true,
                width_request = 70,
                valign = Gtk.Align.CENTER,
                attributes = color_attribute (0, 60000, 0)
            };
            var label_upload = new Gtk.Image () {
                valign = Gtk.Align.CENTER,
                icon_name = "com.github.gabutakut.gabutdm.up",
                tooltip_text = _("Upload Speed")
            };
            upload_rate = new Gtk.Label (null) {
                xalign = 0,
                use_markup = true,
                width_request = 70,
                valign = Gtk.Align.CENTER,
                attributes = color_attribute (60000, 0, 0)
            };

            imgamchok = new Gtk.Image () {
                valign = Gtk.Align.CENTER,
                tooltip_text = _("GDM Choking")
            };

            imgpeerchok = new Gtk.Image () {
                valign = Gtk.Align.CENTER,
                tooltip_text = _("Peer Choking")
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
            grid.attach (seeder_img, 0, 0);
            grid.attach (host_id, 1, 0);
            grid.attach (host_label, 2, 0);
            grid.attach (peer_id, 3, 0);
            grid.attach (client_id, 4, 0);
            grid.attach (label_download, 5, 0);
            grid.attach (download_rate, 6, 0);
            grid.attach (label_upload, 7, 0);
            grid.attach (upload_rate, 8, 0);
            grid.attach (imgpeerchok, 9, 0);
            grid.attach (imgamchok, 10, 0);
            child = grid;
        }
    }
}