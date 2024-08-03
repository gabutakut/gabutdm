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
    public class Downloader : Gtk.Dialog {
        public signal string sendselected (string ariagid, string selected);
        public signal string actions_button (string ariagid, int status);
        private Gtk.Button start_button;
        private Gtk.ProgressBar progressbar;
        private Gtk.Label transfer_rate;
        private Gtk.Label statuslabel;
        private Gtk.Label timeleft;
        private Gtk.Label downloaded;
        private Gtk.Label linklabel;
        private Gtk.Label filesize;
        private Gtk.Label connectlabel;
        private Gtk.Label torrentmode;
        private Gtk.Label timecreation;
        private Gtk.SpinButton down_limit;
        private Gtk.SpinButton up_limit;
        private Gtk.SpinButton bt_req_limit;
        private Gtk.ListBox listboxtorrent;
        private Gee.ArrayList<TorrentRow> listtorrent;
        private Gtk.ListBox lisboxserver;
        private Gee.ArrayList<ServerRow> listserver;
        private Gtk.ListBox listboxpeers;
        private Gee.ArrayList<PeersRow> listpeers;
        private Gtk.TextView infotorrent;
        private Gtk.TextView commenttext;
        private Gtk.Button server_button;
        private Gtk.Stack connpeers;
        private ModeButton view_mode;
        private bool stoptimer;
        private int loadfile = 0;
        private int totalfile = 0;
        private uint timeout_id = 0;

        private bool _switch_rev;
        public bool switch_rev {
            get {
                return _switch_rev;
            }
            set {
                _switch_rev = value;
            }
        }

        private string _url;
        public string url {
            get {
                return _url;
            }
            set {
                _url = value;
                linklabel.label = _url;
            }
        }

        private int _status;
        public int status {
            get {
                return _status;
            }
            set {
                _status = value;
                switch (_status) {
                    case StatusMode.PAUSED:
                        start_button.set_label (_("Start"));
                        statuslabel.label = _("Paused");
                        statuslabel.attributes = color_attribute (60000, 37000, 0);
                        remove_timeout ();
                        break;
                    case StatusMode.COMPLETE:
                        start_button.set_label (_("Open"));
                        statuslabel.label = _("Complete");
                        statuslabel.attributes = color_attribute (60000, 30000, 19764);
                        remove_timeout ();
                        break;
                    case StatusMode.WAIT:
                        start_button.set_label (_("Pause"));
                        statuslabel.label = _("Waiting");
                        statuslabel.attributes = color_attribute (0, 0, 42588);
                        remove_timeout ();
                        break;
                    case StatusMode.ERROR:
                        start_button.set_label (_("Resume"));
                        statuslabel.label = _("Error");
                        statuslabel.attributes = color_attribute (60000, 0, 0);
                        remove_timeout ();
                        break;
                    case StatusMode.NOTHING:
                        start_button.set_label (_("New Process"));
                        statuslabel.label = _("Nothing Process!");
                        statuslabel.attributes = color_attribute (49647, 22352, 44235);
                        remove_timeout ();
                        break;
                    case StatusMode.SEED:
                        start_button.set_label (_("Pause"));
                        statuslabel.label = _("Seeding");
                        statuslabel.attributes = color_attribute (29647, 22352, 44235);
                        add_timeout ();
                        break;
                    default:
                        start_button.set_label (_("Pause"));
                        statuslabel.label = _("Downloading");
                        statuslabel.attributes = color_attribute (0, 60000, 0);
                        add_timeout ();
                        break;
                }
            }
        }

        private string _ariagid;
        public string ariagid {
            get {
                return _ariagid;
            }
            set {
                _ariagid = value;
            }
        }

        private int _transferrate;
        public int transferrate {
            get {
                return _transferrate;
            }
            set {
                _transferrate = value;
                transfer_rate.label = GLib.format_size ((uint64) transferrate);
            }
        }

        private int64 _totalsize;
        public int64 totalsize {
            get {
                return _totalsize;
            }
            set {
                _totalsize = value;
                filesize.label = GLib.format_size (_totalsize, GLib.FormatSizeFlags.LONG_FORMAT);
            }
        }

        private int64 _transferred;
        public int64 transferred {
            get {
                return _transferred;
            }
            set {
                _transferred = value;
                downloaded.label = GLib.format_size (_transferred, GLib.FormatSizeFlags.LONG_FORMAT);
                if (totalsize > 0) {
                    double fraction = (double) transferred / (double) totalsize;
                    if (fraction > 0.0) {
                        progressbar.fraction = fraction;
                    }
                } else {
                    progressbar.pulse ();
                }
            }
        }

        private int _aconnection;
        public int aconnection {
            get {
                return _aconnection;
            }
            set {
                _aconnection = value;
                connectlabel.label = _aconnection.to_string ();
            }
        }

        construct {
            resizable = false;
            use_header_bar = 1;
            view_mode = new ModeButton () {
                hexpand = true,
                homogeneous = true,
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            view_mode.append_text (_("Download Status"));
            view_mode.append_text (_("Torrent Info"));
            view_mode.append_text (_("Download Files"));
            view_mode.append_text (_("Speed Limiter"));
            view_mode.selected = 0;
            view_mode.notify["selected"].connect (() => {
                switch (view_mode.selected) {
                    case 1:
                        torrentmode.label = _("Mode: %s").printf (aria_tell_bittorent (ariagid, TellBittorrent.MODE));
                        var datetime = aria_tell_bittorent (ariagid, TellBittorrent.CREATIONDATE);
                        timecreation.label = _("Time Creation: %s").printf (datetime.strip () != ""? new GLib.DateTime.from_unix_local (int64.parse (datetime)).format ("%a, %I:%M %p %x") : "");
                        infotorrent.buffer.text = aria_tell_bittorent (ariagid, TellBittorrent.ANNOUNCELIST).strip ();
                        var commenttorrent = aria_tell_bittorent (ariagid, TellBittorrent.COMMENT);
                        commenttext.buffer.text = commenttorrent.contains ("\\/")? GLib.Uri.unescape_string (commenttorrent.replace ("\\/", "/")) : commenttorrent;
                        break;
                    case 2:
                        if (status != StatusMode.ACTIVE) {
                            show_files ();
                        }
                        break;
                    case 3:
                        down_limit.value = double.parse (aria_get_option (ariagid, AriaOptions.MAX_DOWNLOAD_LIMIT)) / 1024;
                        up_limit.value = double.parse (aria_get_option (ariagid, AriaOptions.MAX_UPLOAD_LIMIT)) / 1024;
                        bt_req_limit.value = double.parse (aria_get_option (ariagid, AriaOptions.BT_REQUEST_PEER_SPEED_LIMIT)) / 1024;
                        break;
                    default:
                        break;
                }
            });
            var header = get_header_bar ();
            header.decoration_layout = "none";
            header.title_widget = view_mode;

            progressbar = new Gtk.ProgressBar () {
                hexpand = true,
                pulse_step = 0.2,
                width_request = 650
            };

            linklabel = new Gtk.Label (null) {
                margin_top = 5,
                ellipsize = Pango.EllipsizeMode.END,
                hexpand = true,
                xalign = 0,
                max_width_chars = 50,
                width_request = 450
            };

            statuslabel = new Gtk.Label (null) {
                ellipsize = Pango.EllipsizeMode.END,
                hexpand = true,
                xalign = 0,
                max_width_chars = 50,
                width_request = 450
            };

            filesize = new Gtk.Label (null) {
                ellipsize = Pango.EllipsizeMode.END,
                hexpand = true,
                xalign = 0,
                max_width_chars = 50,
                width_request = 450
            };

            transfer_rate = new Gtk.Label (null) {
                ellipsize = Pango.EllipsizeMode.END,
                hexpand = true,
                xalign = 0,
                max_width_chars = 50,
                width_request = 450
            };
            timeleft = new Gtk.Label (null) {
                ellipsize = Pango.EllipsizeMode.END,
                hexpand = true,
                xalign = 0,
                max_width_chars = 50,
                width_request = 450
            };
            downloaded = new Gtk.Label (null) {
                ellipsize = Pango.EllipsizeMode.END,
                hexpand = true,
                xalign = 0,
                max_width_chars = 50,
                width_request = 450
            };
            connectlabel = new Gtk.Label (null) {
                ellipsize = Pango.EllipsizeMode.END,
                hexpand = true,
                xalign = 0,
                max_width_chars = 50,
                width_request = 450
            };
            var downstatusgrid = new Gtk.Grid () {
                hexpand = true,
                height_request = 150,
                margin_bottom = 4,
                valign = Gtk.Align.CENTER
            };
            downstatusgrid.attach (headerlabel (_("Status"), 100), 0, 0, 1, 1);
            downstatusgrid.attach (statuslabel, 1, 0, 1, 1);
            downstatusgrid.attach (headerlabel (_("File Size"), 100), 0, 1, 1, 1);
            downstatusgrid.attach (filesize, 1, 1, 1, 1);
            downstatusgrid.attach (headerlabel (_("Downloaded"), 100), 0, 2, 1, 1);
            downstatusgrid.attach (downloaded, 1, 2, 1, 1);
            downstatusgrid.attach (headerlabel (_("Transferate"), 100), 0, 3, 1, 1);
            downstatusgrid.attach (transfer_rate, 1, 3, 1, 1);
            downstatusgrid.attach (headerlabel (_("Time Left"), 100), 0, 4, 1, 1);
            downstatusgrid.attach (timeleft, 1, 4, 1, 1);
            downstatusgrid.attach (headerlabel (_("Connection"), 100), 0, 5, 1, 1);
            downstatusgrid.attach (connectlabel, 1, 5, 1, 1);

            torrentmode = new Gtk.Label (null) {
                ellipsize = Pango.EllipsizeMode.END,
                hexpand = true,
                use_markup = true,
                xalign = 0,
                max_width_chars = 30,
                width_request = 200,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };

            timecreation = new Gtk.Label (null) {
                ellipsize = Pango.EllipsizeMode.END,
                hexpand = true,
                use_markup = true,
                xalign = 0,
                max_width_chars = 30,
                width_request = 200,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };

            infotorrent = new Gtk.TextView () {
                hexpand = true,
                editable = false,
                wrap_mode = Gtk.WrapMode.WORD_CHAR
            };

            var infoscr = new Gtk.ScrolledWindow () {
                hexpand = true,
                width_request = 250,
                height_request = 140,
                child = infotorrent
            };

            commenttext = new Gtk.TextView () {
                hexpand = true,
                editable = false,
                wrap_mode = Gtk.WrapMode.WORD_CHAR
            };

            var comment = new Gtk.ScrolledWindow () {
                hexpand = true,
                width_request = 250,
                height_request = 140,
                child = commenttext
            };

            var torrentinfo = new Gtk.Grid () {
                hexpand = true,
                column_homogeneous = true,
                height_request = 140,
                column_spacing = 10,
                margin_bottom = 5,
                width_request = 550
            };
            torrentinfo.attach (torrentmode, 0, 0, 1, 1);
            torrentinfo.attach (headerlabel (_("Announce:"), 250), 0, 1, 1, 1);
            torrentinfo.attach (infoscr, 0, 2, 1, 1);
            torrentinfo.attach (timecreation, 1, 0, 1, 1);
            torrentinfo.attach (headerlabel (_("Comment:"), 250), 1, 1, 1, 1);
            torrentinfo.attach (comment, 1, 2, 1, 1);

            listboxpeers = new Gtk.ListBox ();
            listpeers = new Gee.ArrayList<PeersRow> ();

            var peerscrolled = new Gtk.ScrolledWindow () {
                hexpand = true,
                width_request = 550,
                height_request = 160,
                margin_bottom = 10,
                valign = Gtk.Align.FILL,
                child = listboxpeers
            };
            listboxtorrent = new Gtk.ListBox ();
            listtorrent = new Gee.ArrayList<TorrentRow> ();
            listboxtorrent.set_sort_func ((Gtk.ListBoxSortFunc) sort_index);

            var torrscrolled = new Gtk.ScrolledWindow () {
                hexpand = true,
                width_request = 550,
                height_request = 140,
                margin_bottom = 5,
                margin_top = 5,
                child = listboxtorrent
            };

            down_limit = new Gtk.SpinButton.with_range (0, 999999, 1) {
                width_request = 550,
                hexpand = true
            };

            up_limit = new Gtk.SpinButton.with_range (0, 999999, 1) {
                width_request = 550,
                hexpand = true
            };

            bt_req_limit = new Gtk.SpinButton.with_range (0, 99999, 1) {
                width_request = 550,
                hexpand = true
            };

            var limitergrid = new Gtk.Grid () {
                hexpand = true,
                valign = Gtk.Align.CENTER,
                height_request = 150
            };
            limitergrid.attach (headerlabel (_("Max Download Limit (in Kb):"), 550), 0, 0, 1, 1);
            limitergrid.attach (down_limit, 0, 1, 1, 1);
            limitergrid.attach (headerlabel (_("Max Upload Limit (in Kb):"), 550), 0, 2, 1, 1);
            limitergrid.attach (up_limit, 0, 3, 1, 1);
            limitergrid.attach (headerlabel (_("BitTorrent Request Peer Speed Limit (in Kb):"), 550), 0, 4, 1, 1);
            limitergrid.attach (bt_req_limit, 0, 5, 1, 1);

            down_limit.value_changed.connect (()=> {
                aria_set_option (ariagid, AriaOptions.MAX_DOWNLOAD_LIMIT, @"$(down_limit.value)K");
            });
            up_limit.value_changed.connect (()=> {
                aria_set_option (ariagid, AriaOptions.MAX_UPLOAD_LIMIT, @"$(up_limit.value)K");
            });
            bt_req_limit.value_changed.connect (()=> {
                aria_set_option (ariagid, AriaOptions.BT_REQUEST_PEER_SPEED_LIMIT, @"$(bt_req_limit.value)K");
            });

            var stack = new Gtk.Stack () {
                transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT,
                hexpand = true,
                hhomogeneous = false,
                margin_bottom = 2
            };
            stack.add_named (downstatusgrid, "downstatusgrid");
            stack.add_named (torrentinfo, "torrentinfo");
            stack.add_named (torrscrolled, "torrscrolled");
            stack.add_named (limitergrid, "limitergrid");
            stack.visible_child = downstatusgrid;
            stack.show ();

            var boxstatus = new Gtk.Grid () {
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER,
                hexpand = true,
                orientation = Gtk.Orientation.VERTICAL
            };
            boxstatus.attach (linklabel, 0, 0);
            boxstatus.attach (stack, 0, 1);
            boxstatus.attach (progressbar, 0, 2);

            var close_button = new Gtk.Button.with_label (_("Close")) {
                width_request = 120,
                height_request = 25,
                halign = Gtk.Align.END
            };
            ((Gtk.Label) close_button.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            close_button.clicked.connect (()=> {
                remove_timeout ();
                close ();
            });

            start_button = new Gtk.Button.with_label (_("Pause")) {
                width_request = 120,
                height_request = 25,
                halign = Gtk.Align.END
            };
            ((Gtk.Label) start_button.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            start_button.clicked.connect (()=> {
                string agid = actions_button (ariagid, status);
                ariagid = agid;
                get_active_status ();
            });

            var box_action = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5) {
                halign = Gtk.Align.END
            };
            box_action.append (start_button);
            box_action.append (close_button);

            server_button = new Gtk.Button.with_label (_("Servers")) {
                width_request = 120,
                height_request = 25
            };
            ((Gtk.Label) server_button.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            server_button.clicked.connect (()=> {
                switch_rev = !switch_rev;
            });
            var centerbox = new Gtk.CenterBox () {
                margin_top = 10,
                margin_bottom = 10,
                start_widget = server_button,
                end_widget = box_action
            };

            lisboxserver = new Gtk.ListBox ();
            listserver = new Gee.ArrayList<ServerRow> ();

            var servscrolled = new Gtk.ScrolledWindow () {
                hexpand = true,
                width_request = 550,
                height_request = 160,
                margin_bottom = 10,
                valign = Gtk.Align.FILL,
                child = lisboxserver
            };
            connpeers = new Gtk.Stack () {
                hexpand = true,
                valign = Gtk.Align.FILL
            };
            connpeers.add_named (servscrolled, "serverconn");
            connpeers.add_named (peerscrolled, "peersconn");

            var revcon = new Gtk.Revealer () {
                hexpand = true,
                valign = Gtk.Align.FILL,
                transition_type = Gtk.RevealerTransitionType.SWING_DOWN,
                child = connpeers
            };
            var boxarea = get_content_area ();
            boxarea.margin_start = 10;
            boxarea.margin_end = 10;
            boxarea.append (boxstatus);
            boxarea.append (centerbox);
            boxarea.append (revcon);

            notify["switch-rev"].connect (()=> {
                if (switch_rev) {
                    lisboxserver.show ();
                    listboxpeers.show ();
                    revcon.reveal_child = true;
                } else {
                    lisboxserver.hide ();
                    listboxpeers.hide ();
                    revcon.reveal_child = false;
                }
            });

            view_mode.notify["selected"].connect (() => {
                switch (view_mode.selected) {
                    case 1:
                        stack.visible_child = torrentinfo;
                        break;
                    case 2:
                        stack.visible_child = torrscrolled;
                        break;
                    case 3:
                        stack.visible_child = limitergrid;
                        break;
                    default:
                        stack.visible_child = downstatusgrid;
                        break;
                }
            });
        }

        [CCode (instance_pos = -1)]
        private int sort_index (TorrentRow row1, TorrentRow row2) {
            var total1 = row1.index;
            var total2 = row2.index;
            if (total1 > total2) {
                return 1;
            }
            if (total1 < total2) {
                return -1;
            }
            return 0;
        }

        public override void show () {
            update_progress ();
            base.show ();
        }

        public void get_active_status () {
            status = status_aria (aria_tell_status (ariagid, TellStatus.STATUS));
        }

        private void add_timeout () {
            if (timeout_id == 0) {
                stoptimer = GLib.Source.CONTINUE;
                timeout_id = Timeout.add (500, update_progress);
            }
        }

        public void remove_timeout () {
            if (timeout_id != 0) {
                Source.remove (timeout_id);
                timeout_id = 0;
            }
            stoptimer = GLib.Source.REMOVE;
        }

        private int status_aria (string input) {
            switch (input) {
                case "paused":
                    return StatusMode.PAUSED;
                case "complete":
                    return StatusMode.COMPLETE;
                case "waiting":
                    return StatusMode.WAIT;
                case "error":
                    return StatusMode.ERROR;
                case "":
                    return StatusMode.NOTHING;
                default:
                    if (ariagid != null) {
                        if (aria_tell_bittorent (ariagid, TellBittorrent.NAME) != "") {
                            if (bool.parse (aria_tell_status (ariagid, TellStatus.SEEDER))) {
                                return StatusMode.SEED;
                            } else {
                                return StatusMode.ACTIVE;
                            }
                        }
                        return StatusMode.ACTIVE;
                    } else {
                        return StatusMode.ACTIVE;
                    }
            }
        }

        private bool update_progress () {
            var pack_data = aria_v2_status (ariagid);
            totalsize = int64.parse (pharse_tells (pack_data, TellStatus.TOTALLENGTH));
            transferred = int64.parse (pharse_tells (pack_data, TellStatus.COMPELETEDLENGTH));
            if (view_mode.selected == 0) {
                transferrate = int.parse (pharse_tells (pack_data, TellStatus.DOWNLOADSPEED));
                aconnection = int.parse (pharse_tells (pack_data, TellStatus.CONNECTIONS));
                if (totalsize > 0 && transferrate > 0) {
                    uint64 remaining_time = (totalsize - transferred) / transferrate;
                    timeleft.label = format_time ((int) remaining_time);
                }
                url = pharse_files (pack_data, AriaGetfiles.URI);
                if (url == "") {
                    url = pharse_tells (pack_data, TellStatus.INFOHASH);
                    server_button.label = _("Peers");
                    connpeers.visible_child_name = "peersconn";
                } else {
                    if (pharse_tells (pack_data, TellStatus.INFOHASH) == "") {
                        server_button.label = _("Servers");
                        connpeers.visible_child_name = "serverconn";
                    } else {
                        server_button.label = _("Peers");
                        connpeers.visible_child_name = "peersconn";
                    }
                }
            } else if (view_mode.selected == 2) {
                show_files ();
                loadfile++;
            }
            if (switch_rev) {
                if (connpeers.get_visible_child_name () == "serverconn") {
                    var arrayserv = aria_servers_store (ariagid);
                    arrayserv.foreach ((serverrow) => {
                        bool servext = false;
                        listserver.foreach ((serverrow2) => {
                            if (serverrow.key == serverrow2.index) {
                                servext = true;
                                serverrow2.currenturi = serverrow.value.currenturi;
                                serverrow2.downloadspeed = serverrow.value.downloadspeed;
                                serverrow2.uriserver = serverrow.value.uriserver;
                            }
                            return true;
                        });
                        if (!servext) {
                            if (!server_exist (serverrow.key)) {
                                lisboxserver.append (serverrow.value);
                                listserver.add (serverrow.value);
                                serverrow.value.show ();
                            }
                        }
                        return true;
                    });
                    listserver.foreach ((servrow2) => {
                        if (!arrayserv.has_key (servrow2.index)) {
                            listserver.remove (servrow2);
                            lisboxserver.remove (servrow2);
                        }
                        return true;
                    });
                    arrayserv.clear ();
                } else {
                    var arraypeers = aria_get_peers (ariagid);
                    arraypeers.foreach ((peersrow) => {
                        bool peerext = false;
                        listpeers.foreach ((peersrow2) => {
                            if (peersrow2.host == peersrow.key) {
                                peerext = true;
                                peersrow2.peerid = peersrow.value.peerid;
                                peersrow2.downloadspeed = peersrow.value.downloadspeed;
                                peersrow2.uploadspeed = peersrow.value.uploadspeed;
                                peersrow2.peerschoking = peersrow.value.peerschoking;
                                peersrow2.seeder = peersrow.value.seeder;
                                peersrow2.amchoking = peersrow.value.amchoking;
                                peersrow2.bitfield = peersrow.value.bitfield;
                            }
                            return true;
                        });
                        if (!peerext) {
                            if (!peer_exist (peersrow.key)) {
                                listboxpeers.append (peersrow.value);
                                listpeers.add (peersrow.value);
                                peersrow.value.show ();
                            }
                        }
                        return true;
                    });
                    listpeers.foreach ((peersrow2) => {
                        if (!arraypeers.has_key (peersrow2.host)) {
                            listpeers.remove (peersrow2);
                            listboxpeers.remove (peersrow2);
                        }
                        return true;
                    });
                    arraypeers.clear ();
                }
            }
            status = status_aria (aria_tell_status (ariagid, TellStatus.STATUS));
            if (status == StatusMode.ERROR) {
                url = get_aria_error (int.parse (pharse_tells (pack_data, TellStatus.ERRORCODE)));
            }
            return stoptimer;
        }

        private bool server_exist (int index) {
            bool exist = false;
            listserver.foreach ((servrow2) => {
                if (servrow2.index == index) {
                    exist = true;
                }
                return true;
            });
            return exist;
        }

        private bool peer_exist (string host) {
            bool exist = false;
            listpeers.foreach ((peersrow2) => {
                if (peersrow2.host == host) {
                    exist = true;
                }
                return true;
            });
            return exist;
        }

        private void show_files () {
            if (loadfile >= totalfile) {
                var fileshow = aria_files_store (ariagid);
                totalfile = fileshow.size > 100? 6 : 2;
                fileshow.foreach ((torrentstore) => {
                    if (torrentstore.value.filepath == "" || torrentstore.value.filepath == null) {
                        return true;
                    }
                    if (torrentstore.value.filepath.contains ("[METADATA]")) {
                        return true;
                    }
                    if (torrentstore.value.filebasename == null || torrentstore.value.sizetransfered == null || torrentstore.value.completesize == null) {
                        return true;
                    }
                    if (!files_exist (torrentstore.key, torrentstore.value)) {
                        listtorrent.add (torrentstore.value);
                        listboxtorrent.append (torrentstore.value);
                        torrentstore.value.show ();
                        torrentstore.value.selecting.connect ((index, selected)=> {
                            var builder = new StringBuilder ();
                            uint hashb = builder.str.hash ();
                            listtorrent.foreach ((torrentrow)=> {
                                var selectfile = torrentrow.selected;
                                if (torrentrow.index == index) {
                                    selectfile = selected;
                                }
                                if (selectfile) {
                                    if (hashb == builder.str.hash ()) {
                                        builder.append (torrentrow.index.to_string ());
                                    } else {
                                        builder.append (",");
                                        builder.append (torrentrow.index.to_string ());
                                    }
                                }
                                return true;
                            });
                            if (hashb == builder.str.hash ()) {
                                return;
                            }
                            string aria_gid = sendselected (ariagid, builder.str);
                            this.ariagid = aria_gid;
                            update_progress ();
                        });
                    }
                    return true;
                });
                loadfile = 0;
            }
        }

        private bool files_exist (string path, TorrentRow torrentrw) {
            bool exist = false;
            listtorrent.foreach ((torrentrow)=> {
                if (torrentrow.filepath == path) {
                    exist = true;
                    torrentrow.selected = torrentrw.selected;
                    torrentrow.sizetransfered = torrentrw.sizetransfered;
                    torrentrow.fraction = torrentrw.fraction;
                    torrentrow.status = torrentrw.status;
                    torrentrow.persen = torrentrw.persen;
                }
                return true;
            });
            return exist;
        }
    }
}