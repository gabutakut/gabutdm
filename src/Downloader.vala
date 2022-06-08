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
    public class Downloader : Gtk.Dialog {
        public signal string sendselected (string ariagid, string selected);
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
        private Gtk.ListStore torrstore;
        private Gtk.ListStore infostore;
        private Gtk.ListStore peerstore;
        private Gtk.TreeView torrenttree;
        private Gtk.TreeView infotorrent;
        private Gtk.TreeView peerstree;
        private Gtk.TextView commenttext;
        private Gtk.Revealer download_rev;
        private bool stoptimer;

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
                switch (value) {
                    case StatusMode.PAUSED:
                        start_button.set_label (_("Start"));
                        statuslabel.label = _("Paused");
                        statuslabel.attributes = color_attribute (60000, 37000, 0);
                        remove_timeout ();
                        break;
                    case StatusMode.COMPLETE:
                        statuslabel.label = _("Complete");
                        start_button.set_label (_("Complete"));
                        statuslabel.attributes = color_attribute (60000, 30000, 19764);
                        remove_timeout ();
                        if (aria_str_files (AriaGetfiles.PATH, ariagid).contains ("[METADATA]")) {
                            close ();
                        }
                        break;
                    case StatusMode.WAIT:
                        start_button.set_label (_("Wait"));
                        statuslabel.label = _("Waiting");
                        statuslabel.attributes = color_attribute (0, 0, 42588);
                        remove_timeout ();
                        break;
                    case StatusMode.ERROR:
                        statuslabel.label = _("Error");
                        statuslabel.attributes = color_attribute (60000, 0, 0);
                        remove_timeout ();
                        close ();
                        break;
                    case StatusMode.NOTHING:
                        statuslabel.label = _("Nothing Process!, Press Download for continue");
                        statuslabel.attributes = color_attribute (28705, 4000, 9882);
                        download_rev.reveal_child = true;
                        remove_timeout ();
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
                double fraction = (double) transferred / (double) totalsize;
                if (fraction > 0.0) {
                    progressbar.fraction = fraction;
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

        public Downloader (Gtk.Application application) {
            Object (application: application,
                    resizable: false,
                    use_header_bar: 1
            );
        }

        construct {
            var view_mode = new ModeButton () {
                hexpand = false
            };
            view_mode.append_text (_("Download Status"));
            view_mode.append_text (_("Torrent Info"));
            view_mode.append_text (_("Torrent Peers"));
            view_mode.append_text (_("Files"));
            view_mode.append_text (_("Speed Limiter"));
            view_mode.selected = 0;
            var header = get_header_bar ();
            header.decoration_layout = "none";
            header.title_widget = view_mode;

            progressbar = new Gtk.ProgressBar () {
                hexpand = true,
                width_request = 600
            };

            linklabel = new Gtk.Label (null) {
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
                height_request = 150,
                margin_bottom = 5
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

            infostore = new Gtk.ListStore (1, typeof (string));
            infotorrent = new Gtk.TreeView () {
                model = infostore,
                headers_visible = false,
                margin_bottom = 10
            };

            infotorrent.append_column (text_column (_("Name"), 0));
            var infoscr = new Gtk.ScrolledWindow () {
                height_request = 120,
                child = infotorrent
            };

            commenttext = new Gtk.TextView () {
                wrap_mode = Gtk.WrapMode.WORD_CHAR
            };

            var comment = new Gtk.ScrolledWindow () {
                width_request = 250,
                height_request = 120,
                margin_bottom = 10,
                child = commenttext
            };

            var torrentinfo = new Gtk.Grid () {
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

            peerstore = new Gtk.ListStore (TorrentPeers.N_COLUMNS, typeof (string), typeof (string), typeof (string), typeof (string), typeof (string), typeof (string), typeof (string), typeof (string));
            peerstree = new Gtk.TreeView () {
                model = peerstore,
                margin_bottom = 10
            };
            peerstree.append_column (text_column (_("Host"), TorrentPeers.HOST));
            peerstree.append_column (text_column (_("Client"), TorrentPeers.PEERID));
            peerstree.append_column (text_column (_("Choking"), TorrentPeers.PEERCHOKING));
            peerstree.append_column (text_column (_("D"), TorrentPeers.DOWNLOADSPEED));
            peerstree.append_column (text_column (_("U"), TorrentPeers.UPLOADSPEED));

            var peerscrolled = new Gtk.ScrolledWindow () {
                width_request = 550,
                height_request = 140,
                margin_bottom = 5,
                margin_top = 5,
                child = peerstree
            };

            torrstore = new Gtk.ListStore (FileCol.N_COLUMNS, typeof (bool), typeof (string), typeof (string), typeof (string), typeof (string), typeof (string), typeof (int), typeof (string));
            torrenttree = new Gtk.TreeView () {
                model = torrstore,
                margin_bottom = 10
            };
            torrenttree.append_column (toggle_column (_("#"), FileCol.SELECTED));
            torrenttree.append_column (text_column (_("Row"), FileCol.ROW));
            torrenttree.append_column (text_column (_("Name"), FileCol.NAME));
            torrenttree.append_column (text_column (_("Downloaded"), FileCol.DOWNLOADED));
            torrenttree.append_column (text_column (_("Size"), FileCol.SIZE));
            torrenttree.append_column (progress_column (_("%"), FileCol.PERCEN));
            torrenttree.append_column (text_column (_("Uris"), FileCol.URIS));
            torrenttree.set_tooltip_column (FileCol.FILEPATH);

            var torrscrolled = new Gtk.ScrolledWindow () {
                width_request = 550,
                height_request = 140,
                margin_bottom = 5,
                margin_top = 5,
                child = torrenttree
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
                transition_duration = 500,
                hhomogeneous = false,
                margin_bottom = 2
            };
            stack.add_named (downstatusgrid, "downstatusgrid");
            stack.add_named (torrentinfo, "torrentinfo");
            stack.add_named (peerscrolled, "peerscrolled");
            stack.add_named (torrscrolled, "torrscrolled");
            stack.add_named (limitergrid, "limitergrid");
            stack.visible_child = downstatusgrid;
            stack.show ();

            var boxstatus = new Gtk.Grid () {
                halign = Gtk.Align.CENTER,
                orientation = Gtk.Orientation.VERTICAL
            };
            boxstatus.attach (linklabel, 0, 0);
            boxstatus.attach (stack, 0, 1);
            boxstatus.attach (progressbar, 0, 2);

            var download = new Gtk.Button.with_label (_("Redownload")) {
                width_request = 120,
                height_request = 25,
                halign = Gtk.Align.START
            };
            download.clicked.connect (()=> {
                sendselected (ariagid, "");
                remove_timeout ();
                close ();
            });
            download_rev = new Gtk.Revealer () {
                transition_type = Gtk.RevealerTransitionType.CROSSFADE,
                child = download
            };
            var close_button = new Gtk.Button.with_label (_("Close")) {
                width_request = 120,
                height_request = 25,
                halign = Gtk.Align.END
            };
            close_button.clicked.connect (()=> {
                remove_timeout ();
                close ();
            });

            start_button = new Gtk.Button.with_label (_("Pause")) {
                width_request = 120,
                height_request = 25,
                halign = Gtk.Align.END
            };
            start_button.clicked.connect (action_status);

            var box_action = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5) {
                halign = Gtk.Align.END,
                margin_top = 10,
                margin_bottom = 10
            };
            box_action.append (download_rev);
            box_action.append (start_button);
            box_action.append (close_button);

            var maingrid = new Gtk.Grid () {
                halign = Gtk.Align.CENTER,
                hexpand = true,
                margin_start = 10,
                margin_end = 10
            };
            maingrid.attach (boxstatus, 0, 0);
            maingrid.attach (box_action, 0, 1);
            child = maingrid;

            view_mode.notify["selected"].connect (() => {
                switch (view_mode.selected) {
                    case 1:
                        stack.visible_child = torrentinfo;
                        break;
                    case 2:
                        stack.visible_child = peerscrolled;
                        break;
                    case 3:
                        stack.visible_child = torrscrolled;
                        break;
                    case 4:
                        stack.visible_child = limitergrid;
                        break;
                    default:
                        stack.visible_child = downstatusgrid;
                        break;
                }
            });
        }

        public override void show () {
            base.show ();
            set_badge.begin (int64.parse (aria_globalstat (GlobalStat.NUMACTIVE)));
            Idle.add (()=> {
                update_progress ();
                add_timeout ();
                return false;
            });
        }

        private Gtk.TreeViewColumn text_column (string title, int column) {
            var server_coll = new Gtk.TreeViewColumn.with_attributes (title, new Gtk.CellRendererText (), "markup", column) {
                resizable = true,
                clickable = true,
                expand = true,
                sort_indicator = true,
                sort_column_id = column,
                min_width = 15
            };
            return server_coll;
        }

        private Gtk.TreeViewColumn toggle_column (string title, int column) {
            var selected = new Gtk.CellRendererToggle ();
            selected.toggled.connect (()=> {
                Idle.add (()=> {
                    Gtk.TreeIter iter;
                    torrenttree.get_selection ().get_selected (null, out iter);
                    if (!torrstore.iter_is_valid (iter)) {
                        return false;
                    }
                    bool active;
                    torrstore.get (iter, 0, out active);
                    torrstore.set (iter, 0, !active);
                    var builder = new StringBuilder ();
                    uint hashb = builder.str.hash ();
                    torrstore.foreach ((model, path, ite) => {
                        string index;
                        bool activaated;
                        model.get (ite, 0, out activaated, 1, out index);
                        if (activaated) {
                            if (hashb == builder.str.hash ()) {
                                builder.append (index);
                            } else {
                                builder.append (",");
                                builder.append (index);
                            }
                        }
                        return false;
                    });
                    if (hashb == builder.str.hash ()) {
                        return false;
                    }
                    string aria_gid = sendselected (ariagid, builder.str);
                    this.ariagid = aria_gid;
                    update_progress ();
                    return false;
                });
            });
            var server_coll = new Gtk.TreeViewColumn.with_attributes (title, selected, "active", column) {
                resizable = true,
                clickable = true,
                expand = true,
                sort_indicator = true,
                sort_column_id = column
            };
            return server_coll;
        }

        private Gtk.TreeViewColumn progress_column (string title, int column) {
            var server_coll = new Gtk.TreeViewColumn.with_attributes (title, new Gtk.CellRendererProgress (), "value", column) {
                resizable = true,
                clickable = true,
                expand = true,
                sort_column_id = column
            };
            return server_coll;
        }

        public void get_active_status () {
            status = status_aria (aria_tell_status (ariagid, TellStatus.STATUS));
        }

        private void action_status () {
            status = status_aria (aria_tell_status (ariagid, TellStatus.STATUS));
            if (status == StatusMode.ACTIVE) {
                aria_pause (ariagid);
                remove_timeout ();
            } else if (status == StatusMode.PAUSED) {
                aria_unpause (ariagid);
                add_timeout ();
            } else if (status == StatusMode.COMPLETE) {
                remove_timeout ();
            } else if (status == StatusMode.WAIT) {
                add_timeout ();
            } else {
                remove_timeout ();
                close ();
            }
            status = status_aria (aria_tell_status (ariagid, TellStatus.STATUS));
            if (status != StatusMode.COMPLETE) {
                application.activate_action ("status", new Variant.string (ariagid));
            }
        }

        public void aria_gid (string ariagid) {
            this.ariagid = ariagid;
            down_limit.value = double.parse (aria_get_option (ariagid, AriaOptions.MAX_DOWNLOAD_LIMIT)) / 1024;
            up_limit.value = double.parse (aria_get_option (ariagid, AriaOptions.MAX_UPLOAD_LIMIT)) / 1024;
            bt_req_limit.value = double.parse (aria_get_option (ariagid, AriaOptions.BT_REQUEST_PEER_SPEED_LIMIT)) / 1024;
            torrentmode.label = _("<b>Mode: </b> %s").printf (aria_tell_bittorent (ariagid, TellBittorrent.MODE));
            var timesn = new GLib.DateTime.from_unix_local (int64.parse (aria_tell_bittorent (ariagid, TellBittorrent.CREATIONDATE)));
            timecreation.label = _("<b>Time Creation: </b> %s").printf (timesn.to_string ());

            foreach (string announce in aria_tell_bittorent (ariagid, TellBittorrent.ANNOUNCELIST).split ("+")) {
                if (announce != "") {
                    Gtk.TreeIter iters;
                    infostore.append (out iters);
                    infostore.set (iters, 0, announce);
                }
            }
            var commenttorrent = aria_tell_bittorent (ariagid, TellBittorrent.COMMENT);
            commenttext.buffer.text = commenttorrent.contains ("\\/")? GLib.Uri.unescape_string (commenttorrent.replace ("\\/", "/")) : commenttorrent;
        }

        private uint timeout_id = 0;
        public void add_timeout () {
            if (timeout_id == 0) {
                stoptimer = true;
                timeout_id = Timeout.add (500, update_progress);
            }
        }

        public void remove_timeout () {
            if (timeout_id != 0) {
                Source.remove (timeout_id);
                timeout_id = 0;
            }
            stoptimer = false;
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
                        int statustorr = 0;
                        if (aria_tell_bittorent (ariagid, TellBittorrent.NAME) != "") {
                            if (bool.parse (aria_tell_status (ariagid, TellStatus.SEEDER))) {
                                statustorr = StatusMode.COMPLETE;
                            } else {
                                statustorr = StatusMode.ACTIVE;
                            }
                        }
                        return statustorr;
                    } else {
                        return StatusMode.ACTIVE;
                    }
            }
        }

        private bool update_progress () {
            totalsize = int64.parse (aria_tell_status (ariagid, TellStatus.TOTALLENGTH));
            transferred = int64.parse (aria_tell_status (ariagid, TellStatus.COMPELETEDLENGTH));
            transferrate = int.parse (aria_tell_status (ariagid, TellStatus.DOWNLOADSPEED));
            aconnection = int.parse (aria_tell_status (ariagid, TellStatus.CONNECTIONS));
            status = status_aria (aria_tell_status (ariagid, TellStatus.STATUS));
            peerstore.clear ();
            aria_get_peers (ariagid).foreach ((model, path, iter) => {
                string host, peerid, downloadspeed, uploadspeed, seeder, bitfield, amchoking, peerchoking;
                model.get (iter, TorrentPeers.HOST, out host, TorrentPeers.PEERID, out peerid, TorrentPeers.DOWNLOADSPEED, out downloadspeed, TorrentPeers.UPLOADSPEED, out uploadspeed, TorrentPeers.SEEDER, out seeder, TorrentPeers.BITFIELD, out bitfield, TorrentPeers.AMCHOKING, out amchoking, TorrentPeers.PEERCHOKING, out peerchoking);
                Gtk.TreeIter iters;
                peerstore.append (out iters);
                peerstore.set (iters, TorrentPeers.HOST, host, TorrentPeers.PEERID, peerid, TorrentPeers.DOWNLOADSPEED, downloadspeed, TorrentPeers.UPLOADSPEED, uploadspeed, TorrentPeers.SEEDER, seeder, TorrentPeers.BITFIELD, bitfield, TorrentPeers.AMCHOKING, amchoking, TorrentPeers.PEERCHOKING, peerchoking);
                return false;
            });
            url = aria_geturis (ariagid);
            if (url == "") {
                url = aria_tell_status (ariagid, TellStatus.INFOHASH);
            }
            aria_files_store (ariagid).foreach ((model, path, iter) => {
                bool select;
                string index, name, download, size, uris, pathname;
                int persen;
                model.get (iter, FileCol.FILEPATH, out pathname);
                if  (pathname == "" || pathname == null) {
                    return false;
                }
                if (pathname.contains ("[METADATA]")) {
                    return false;
                }
                model.get (iter, FileCol.SELECTED, out select, FileCol.ROW, out index, FileCol.NAME, out name, FileCol.DOWNLOADED, out download, FileCol.SIZE, out size, FileCol.PERCEN, out persen, FileCol.URIS, out uris);
                if (name == null || download == null || size == null) {
                    return false;
                }
                if (!liststore_exist (select, index, Markup.escape_text (name), Markup.escape_text (pathname), download, size, persen.abs (), Markup.escape_text (uris))) {
                    Gtk.TreeIter iters;
                    torrstore.append (out iters);
                    torrstore.set (iters, FileCol.SELECTED, select, FileCol.ROW, index, FileCol.NAME, Markup.escape_text (name), FileCol.FILEPATH, Markup.escape_text (pathname), FileCol.DOWNLOADED, download, FileCol.SIZE, size, FileCol.PERCEN, persen.abs (), FileCol.URIS, Markup.escape_text (uris));
                }
                return false;
            });
            aria_files_store (ariagid);
            if (totalsize > 0 && transferrate > 0) {
                uint64 remaining_time = (totalsize - transferred) / transferrate;
                timeleft.label = format_time ((int) remaining_time);
            }
            return stoptimer;
        }

        private bool liststore_exist (bool select, string index, string name, string pathname, string download, string size, int persen, string uris) {
            bool exist = false;
            torrstore.foreach ((model, path, iter) => {
                string filename;
                model.get (iter, FileCol.FILEPATH, out filename);
                if (filename == pathname) {
                    exist = true;
                    torrstore.set (iter, FileCol.SELECTED, select, FileCol.ROW, index, FileCol.NAME, name, FileCol.DOWNLOADED, download, FileCol.SIZE, size, FileCol.PERCEN, persen, FileCol.URIS, uris);
                }
                return false;
            });
            return exist;
        }
    }
}
