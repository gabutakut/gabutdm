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
    public class Downloader : Gtk.Dialog {
        public signal string sendselected (string ariagid, string selected);
        public signal string actions_button (string ariagid, int status);
        private Gtk.Button start_button;
        private BitfieldWidget bitfield_widget;
        private Gtk.Label transfer_rate;
        private Gtk.Label statuslabel;
        private Gtk.Label timeleft;
        private Gtk.Label downloaded;
        private Gtk.Label linklabel;
        private Gtk.Label filesize;
        private Gtk.Label connectlabel;
        private Gtk.Label current_path_label;
        private Gtk.SpinButton down_limit;
        private Gtk.SpinButton up_limit;
        private Gtk.SpinButton bt_req_limit;
        private Gtk.ListBox lisboxserver;
        private Gtk.ListBox listboxpeers;
        private Gtk.ListBox current_folder_list;
        private Gee.ArrayList<PeersRow> listpeers;
        private Gee.ArrayList<RowServer> listserver;
        private Gee.ArrayList<TrFileInfo> folder_history;
        private Gee.ArrayList<TrFileInfo> all_files;
        private Gtk.Button server_button;
        private Gtk.Button back_button;
        private Gtk.Button up_button;
        private Gtk.Stack connpeers;
        private Gtk.Stack file_stack;
        private ModeButton view_mode;
        private Gtk.ListView file_list_view;
        private GLib.ListStore file_store;
        private Gtk.Box folder_view_box;
        private Gtk.ScrolledWindow folder_scroll;
        private TrFileInfo? current_folder = null;
        private string pack_data;
        private int64 total_size = 0;
        private int64 total_completed = 0;
        private bool has_user_interacted = false;
        private bool structure_ready = false;
        private bool stoptimer;
        private int loadfile = 0;
        private int total_files = 0;
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
                bitfield_widget.status = _status;
                switch (_status) {
                    case StatusMode.PAUSED:
                        start_button.set_label (_("Start"));
                        statuslabel.label = _("Paused");
                        statuslabel.attributes = color_attribute (60000, 37000, 0);
                        remove_timeout ();
                        break;
                    case StatusMode.COMPLETE:
                        start_button.set_label (_("Complete"));
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

        private string _selectedtr;
        public string selectedtr {
            get {
                return _selectedtr;
            }
            set {
                _selectedtr = value;
            }
        }

        public Downloader () {
            Object (resizable: false, use_header_bar: 1);
        }

        construct {
            folder_history = new Gee.ArrayList<TrFileInfo>();
            all_files = new Gee.ArrayList<TrFileInfo>();

            view_mode = new ModeButton () {
                hexpand = true,
                homogeneous = true,
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            view_mode.append_text (_("Download Status"));
            view_mode.append_text (_("Download Files"));
            view_mode.append_text (_("Speed Limiter"));
            view_mode.selected = 0;
            view_mode.notify["selected"].connect (() => {
                switch (view_mode.selected) {
                    case 1:
                        string? json_str = aria_files_store (ariagid);
                        if (json_str == null) {
                            return;
                        }
                        try {
                            var parser = new Json.Parser();
                            parser.load_from_data(json_str, -1);
                            Json.Node? root = parser.get_root();
                            if (root == null) {
                                return;
                            }
                            if (!structure_ready) {
                                new Thread<void?> ("openfiles-%s".printf(ariagid), () => {
                                    parse_aria2_response(root);
                                });
                            }
                        } catch (Error e) {
                            GLib.warning (e.message);
                        }
                        break;
                    case 2:
                        down_limit.value = double.parse (aria_get_option (ariagid, AriaOptions.MAX_DOWNLOAD_LIMIT)) / 1024;
                        up_limit.value = double.parse (aria_get_option (ariagid, AriaOptions.MAX_UPLOAD_LIMIT)) / 1024;
                        bt_req_limit.value = double.parse (aria_get_option (ariagid, AriaOptions.BT_REQUEST_PEER_SPEED_LIMIT)) / 1024;
                        break;
                    default:
                        break;
                }
            });
            unowned Gtk.HeaderBar header = this.get_header_bar ();
            header.decoration_layout = "none";
            header.title_widget = view_mode;

            bitfield_widget = new BitfieldWidget (false, 1) {
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
            downstatusgrid.attach (linklabel, 0, 0, 2, 1);
            downstatusgrid.attach (headerlabel (_("Status"), 100), 0, 1, 1, 1);
            downstatusgrid.attach (statuslabel, 1, 1, 1, 1);
            downstatusgrid.attach (headerlabel (_("File Size"), 100), 0, 2, 1, 1);
            downstatusgrid.attach (filesize, 1, 2, 1, 1);
            downstatusgrid.attach (headerlabel (_("Downloaded"), 100), 0, 3, 1, 1);
            downstatusgrid.attach (downloaded, 1, 3, 1, 1);
            downstatusgrid.attach (headerlabel (_("Transferate"), 100), 0, 4, 1, 1);
            downstatusgrid.attach (transfer_rate, 1, 4, 1, 1);
            downstatusgrid.attach (headerlabel (_("Time Left"), 100), 0, 5, 1, 1);
            downstatusgrid.attach (timeleft, 1, 5, 1, 1);
            downstatusgrid.attach (headerlabel (_("Connection"), 100), 0, 6, 1, 1);
            downstatusgrid.attach (connectlabel, 1, 6, 1, 1);
            move_window (this, downstatusgrid);

            var peers_alert = new AlertView (
               _("Peers"),
                _("Client and Peer here"),
                "com.github.gabutakut.gabutdm"
            );
            listboxpeers = new Gtk.ListBox ();
            listboxpeers.set_placeholder (peers_alert);
            listpeers = new Gee.ArrayList<PeersRow> ();

            var peerscrolled = new Gtk.ScrolledWindow () {
                hexpand = true,
                width_request = 550,
                height_request = 160,
                margin_bottom = 10,
                valign = Gtk.Align.FILL,
                child = listboxpeers
            };
            var file_alert = new AlertView (
               _("List File Download"),
                _("File Apprear here."),
                "com.github.gabutakut.gabutdm"
            );

            file_stack = new Gtk.Stack() {
                transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT,
                vexpand = true,
                hexpand = true
            };
            folder_view_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 2);
            Gtk.Box nav_header = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5);            
            back_button = new Gtk.Button.from_icon_name("com.github.gabutakut.gabutdm.back") {
                has_frame = false,
                sensitive = false
            };
            back_button.clicked.connect(on_back_clicked);
            nav_header.append(back_button);
            up_button = new Gtk.Button.from_icon_name("com.github.gabutakut.gabutdm.up") {
                has_frame = false,
                sensitive = false
            };
            up_button.clicked.connect(on_up_clicked);
            nav_header.append(up_button);
            var home_button = new Gtk.Button.from_icon_name("com.github.gabutakut.gabutdm.gohome") {
                has_frame = false,
                sensitive = false
            };
            home_button.clicked.connect(() => {
                file_stack.set_visible_child_name("list");
            });

            nav_header.append(home_button);
            current_path_label = new Gtk.Label("") {
                halign = Gtk.Align.START,
                hexpand = true,
                xalign = 0,
                ellipsize = Pango.EllipsizeMode.START,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };
            nav_header.append(current_path_label);

            folder_view_box.append(nav_header);
            folder_scroll = new Gtk.ScrolledWindow() {
                vexpand = true
            };
            folder_view_box.append(folder_scroll);
            file_stack.add_titled(folder_view_box, "folder", "Folder");
            Gtk.Box list_page = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            Gtk.ScrolledWindow list_scroll = new Gtk.ScrolledWindow() {
                vexpand = true,
                hexpand = true
            };
            file_store = new GLib.ListStore(typeof(TrFileInfo));
            file_store.items_changed(0, 0, 0);

            Gtk.SignalListItemFactory factory = new Gtk.SignalListItemFactory();
            factory.setup.connect(on_setup_list_item);
            factory.bind.connect(on_bind_list_item);
            Gtk.SingleSelection selection = new Gtk.SingleSelection(file_store);
            file_list_view = new Gtk.ListView(selection, factory) {
                height_request = 100
            };
            file_list_view.activate.connect(on_file_activated);
            list_scroll.child = file_list_view;
            list_page.append(list_scroll);
            file_stack.add_titled(list_page, "list", "Daftar File");

            file_stack.set_visible_child_name("list");
            file_stack.notify["visible-child-name"].connect(() => {
                if (file_stack.get_visible_child_name() == "list") {
                    file_store.sort(folder_first_compare);
                }
            });

            var torrscrolled = new Gtk.ScrolledWindow () {
                hexpand = true,
                width_request = 550,
                height_request = 140,
                margin_bottom = 5,
                margin_top = 5,
                child = file_stack
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
                margin_bottom = 2,
                width_request = 680,
                height_request = 200
            };
            stack.add_named (downstatusgrid, "downstatusgrid");
            stack.add_named (torrscrolled, "torrscrolled");
            stack.add_named (limitergrid, "limitergrid");
            stack.visible_child = downstatusgrid;
            stack.set_visible (true);

            var boxstatus = new Gtk.Grid () {
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER,
                hexpand = true,
                orientation = Gtk.Orientation.VERTICAL
            };
            boxstatus.attach (stack, 0, 0);
            boxstatus.attach (bitfield_widget, 0, 1);

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
            var serv_alert = new AlertView (
               _("Server"),
                _("Speed and Connection Downloads"),
                "com.github.gabutakut.gabutdm"
            );
            lisboxserver = new Gtk.ListBox ();
            lisboxserver.set_placeholder (serv_alert);
            listserver = new Gee.ArrayList<RowServer> ();

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
            unowned Gtk.Box boxarea = this.get_content_area ();
            boxarea.margin_start = 10;
            boxarea.margin_end = 10;
            boxarea.append (boxstatus);
            boxarea.append (centerbox);
            boxarea.append (revcon);

            notify["switch-rev"].connect (()=> {
                if (switch_rev) {
                    lisboxserver.set_visible (true);
                    listboxpeers.set_visible (true);
                    revcon.reveal_child = true;
                } else {
                    lisboxserver.set_visible (false);
                    listboxpeers.set_visible (false);
                    revcon.reveal_child = false;
                }
            });

            view_mode.notify["selected"].connect (() => {
                switch (view_mode.selected) {
                    case 1:
                        stack.visible_child = torrscrolled;
                        break;
                    case 2:
                        stack.visible_child = limitergrid;
                        break;
                    default:
                        stack.visible_child = downstatusgrid;
                        break;
                }
            });
        }

        public override void show () {
            update_progress ();
            base.show ();
        }

        public override bool close_request () {
            remove_timeout ();
            return base.close_request ();
        }

        public override void close () {
            remove_timeout ();
            base.close ();
        }

        public void get_active_status () {
            status = status_aria (aria_tell_status (ariagid, TellStatus.STATUS));
        }

        private void add_timeout () {
            if (timeout_id == 0) {
                stoptimer = GLib.Source.CONTINUE;
                timeout_id = Timeout.add (500, update_progress, GLib.Priority.HIGH);
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
            pack_data = aria_v2_status (ariagid);
            totalsize = int64.parse (pharse_tells (pack_data, TellStatus.TOTALLENGTH));
            transferred = int64.parse (pharse_tells (pack_data, TellStatus.COMPELETEDLENGTH));
            var bitfield = aria_tell_status (ariagid, TellStatus.BITFIELD);
            var piececount = int.parse (pharse_tells (pack_data, TellStatus.NUMPIECES));
            bitfield_widget.set_bitfield_data(bitfield, piececount);
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
            } else if (view_mode.selected == 1) {
                if (loadfile > 1) {
                    show_files ();
                    loadfile = 0;
                }
                loadfile++;
            }
            if (switch_rev) {
                if (connpeers.get_visible_child_name () == "serverconn") {
                    var arrayserv = aria_servers_store (ariagid);
                    foreach (var serverrow in arrayserv) {
                        bool servext = false;
                        for (int b = 0; b < listserver.size ; b++) {
                            var serverrow2 = (RowServer) lisboxserver.get_row_at_index (b);
                            if (serverrow.key == serverrow2.index) {
                                servext = true;
                                serverrow2.currenturi = serverrow.value.currenturi;
                                serverrow2.downloadspeed = serverrow.value.downloadspeed;
                                serverrow2.uriserver = serverrow.value.uriserver;
                            }
                        }
                        if (!servext) {
                            if (!server_exist (serverrow.key)) {
                                lisboxserver.append (serverrow.value);
                                listserver.add (serverrow.value);
                                serverrow.value.set_visible (true);
                            }
                        }
                    }
                    for (int b = 0; b < listserver.size ; b++) {
                        var servrow2 = (RowServer) lisboxserver.get_row_at_index (b);
                        if (!arrayserv.has_key (servrow2.index)) {
                            listserver.remove (servrow2);
                            lisboxserver.remove (servrow2);
                        }
                    }
                    arrayserv.clear ();
                } else {
                    var arraypeers = aria_get_peers (ariagid);
                    foreach (var peersrow in arraypeers) {
                        bool peerext = false;
                        for (int b = 0; b < listpeers.size ; b++) {
                            var peersrow2 = (PeersRow) listboxpeers.get_row_at_index (b);
                            if (peersrow2.host == peersrow.key) {
                                peerext = true;
                                peersrow2.downloadspeed = peersrow.value.downloadspeed;
                                peersrow2.uploadspeed = peersrow.value.uploadspeed;
                                peersrow2.peerschoking = peersrow.value.peerschoking;
                                peersrow2.seeder = peersrow.value.seeder;
                                peersrow2.amchoking = peersrow.value.amchoking;
                                peersrow2.bitfield = peersrow.value.bitfield;
                            }
                        }
                        if (!peerext) {
                            if (!peer_exist (peersrow.key)) {
                                listboxpeers.append (peersrow.value);
                                listpeers.add (peersrow.value);
                                peersrow.value.set_visible (true);
                            }
                        }
                    }
                    for (int b = 0; b < listpeers.size ; b++) {
                        var peersrow2 = (PeersRow) listboxpeers.get_row_at_index (b);
                        if (!arraypeers.has_key (peersrow2.host)) {
                            listpeers.remove (peersrow2);
                            listboxpeers.remove (peersrow2);
                        }
                    }
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
            for (int b = 0; b < listserver.size ; b++) {
                var servrow2 = (RowServer) lisboxserver.get_row_at_index (b);
                if (servrow2.index == index) {
                    exist = true;
                }
            }
            return exist;
        }

        private bool peer_exist (string host) {
            bool exist = false;
            for (int b = 0; b < listpeers.size ; b++) {
                var peersrow2 = (PeersRow) listboxpeers.get_row_at_index (b);
                if (peersrow2.host == host) {
                    exist = true;
                }
            }
            return exist;
        }

        private void on_setup_list_item(Gtk.SignalListItemFactory factory, GLib.Object object) {
            Gtk.ListItem item = object as Gtk.ListItem;
            if (item == null) {
                return;
            }
            Gtk.Box row = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5) {
                margin_start = 2,
                margin_end = 5
            };
            
            Gtk.CheckButton check_button = new Gtk.CheckButton() {
                valign = Gtk.Align.CENTER
            };
            row.append(check_button);
            
            Gtk.Image icon = new Gtk.Image() {
                pixel_size = 16
            };
            row.append(icon);
            
            Gtk.Label name_label = new Gtk.Label("") {
                halign = Gtk.Align.START,
                hexpand = true,
                xalign = 0,
                use_markup = true,
                width_request = 260,
                max_width_chars = 55,
                ellipsize = Pango.EllipsizeMode.MIDDLE,
                valign = Gtk.Align.CENTER,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };
            row.append(name_label);
            
            Gtk.Label size_label = new Gtk.Label("") {
                halign = Gtk.Align.END,
                attributes = color_attribute (0, 60000, 0)
            };
            row.append(size_label);
            
            Gtk.Label progress_label = new Gtk.Label("") {
                halign = Gtk.Align.END,
                width_chars = 8,
                attributes = color_attribute (60000, 30000, 0)
            };
            row.append(progress_label);

            var progresimg = new Gtk.Image () {
                valign = Gtk.Align.CENTER,
                width_request = 20
            };
            var open_button = new Gtk.Button () {
                focus_on_click = false,
                has_frame = false,
                valign = Gtk.Align.CENTER,
                child = progresimg,
                tooltip_text = _("Path")
            };
            row.append(open_button);
            var imgstatus = new Gtk.Image () {
                valign = Gtk.Align.CENTER
            };
            row.append(imgstatus);
            item.child = row;
        }
        
        private void on_bind_list_item(Gtk.SignalListItemFactory factory, GLib.Object object) {
            Gtk.ListItem item = object as Gtk.ListItem;
            if (item == null) {
                return;
            }
            TrFileInfo? file_info = item.item as TrFileInfo;
            if (file_info == null) {
                return;
            }
            Gtk.Box row = item.child as Gtk.Box;
            if (row == null) {
                return;
            }
            Gtk.CheckButton check_button = row.get_first_child() as Gtk.CheckButton;
            Gtk.Image icon = check_button.get_next_sibling() as Gtk.Image;
            Gtk.Label name_label = icon.get_next_sibling() as Gtk.Label;
            Gtk.Label size_label = name_label.get_next_sibling() as Gtk.Label;
            Gtk.Label progress_text_label = size_label.get_next_sibling() as Gtk.Label;
            Gtk.Button open_button = progress_text_label.get_next_sibling() as Gtk.Button;
            Gtk.Image imageprog = open_button.get_last_child() as Gtk.Image;
            Gtk.Image stsicon = open_button.get_next_sibling() as Gtk.Image;

            if (check_button != null) {
                check_button.active = file_info.selected;
                if (file_info.is_folder) {
                    int64 total_select = 0;
                    int64 all_select = 0;
                    selected_in_folder (file_info, ref total_select, ref all_select);
                    if (total_select >= all_select) {
                        check_button.inconsistent = false;
                        check_button.active = true;
                    } else if (total_select > 0 && total_select < all_select) {
                        check_button.inconsistent = true;
                    } else if (total_select == 0) {
                        check_button.active = false;
                    } else {
                        check_button.inconsistent = false;
                    }
                }
                ulong handler_id = check_button.get_data<ulong>("toggle-handler");
                if (handler_id != 0) {
                    check_button.disconnect(handler_id);
                }
                handler_id = check_button.toggled.connect(() => {
                    has_user_interacted = true;
                    file_info.selected = check_button.active;
                    if (file_info.is_folder) {
                        if (check_button.inconsistent) {
                            check_button.inconsistent = false;
                        }
                        update_folder_selection(file_info, check_button.active);
                    }
                    if (file_stack.get_visible_child_name() == "folder" && current_folder != null) {
                        show_folder_contents(current_folder);
                    }
                    auto_send_selected_indexes();
                });
                check_button.set_data<ulong>("toggle-handler", handler_id);
            }
            if (icon != null) {
                if (file_info.is_folder) {
                    icon.icon_name = "folder";
                } else {
                    icon.gicon = get_icon_for_filename(file_info.full_path);
                }
            }
            if (name_label != null) {
                name_label.label = file_info.path;
            }
            if (size_label != null) {
                size_label.label = GLib.format_size(file_info.size);
            }
            if (open_button != null) {
                ulong hid = open_button.get_data<ulong>("open-handler");
                if (hid != 0) {
                    open_button.disconnect(hid);
                }
                hid = open_button.clicked.connect(() => {
                    if (file_info.full_path == "") {
                        return;
                    }
                    string folder = file_info.full_path;
                    var file = File.new_for_path (folder);
                    if (file == null) {
                        return;
                    }
                    if (file.query_exists()) {
                        open_fileman.begin (file.get_parent ().get_uri ());
                    }
                });
                open_button.set_data<ulong>("open-handler", hid);
            }

            if (imageprog != null && progress_text_label != null && stsicon != null) {
                ProgressPaintable progrespaint = new ProgressPaintable ();
                imageprog.paintable = progrespaint;
                progrespaint.queue_draw.connect (imageprog.queue_draw);
                if (file_info.is_folder) {
                    int64 folder_completed = 0;
                    int64 folder_size = 0;
                    calculate_folder_progress(file_info, ref folder_completed, ref folder_size);
                    double progress = 0.0;
                    if (folder_size > 0) {
                        progress = (double)folder_completed / (double)folder_size;
                    }
                    progrespaint.progress = progress;
                    progress_text_label.label = "%.1f%%".printf(progress * 100);
                    if ((progress * 100) >= 100) {
                        stsicon.icon_name = "com.github.gabutakut.gabutdm.complete";
                        return;
                    }
                    int64 f_status = 0;
                    int64 f_allsts = 0;
                    status_in_folder(file_info, ref f_status, ref f_allsts);
                    if (f_status >= f_allsts) {
                        stsicon.icon_name = "com.github.gabutakut.gabutdm.waiting";
                    } else {
                        stsicon.icon_name = "com.github.gabutakut.gabutdm.active";
                    }
                } else {
                    progrespaint.progress = file_info.progress / 100;
                    progress_text_label.label = "%.1f%%".printf(file_info.progress);
                    if (file_info.progress >= 100) {
                        stsicon.icon_name = "com.github.gabutakut.gabutdm.complete";
                    } else if (file_info.progress < 100 && file_info.status == "waiting") {
                        stsicon.icon_name = "com.github.gabutakut.gabutdm.waiting";
                    } else {
                        stsicon.icon_name = "com.github.gabutakut.gabutdm.active";
                    }
                }
                file_info.notify.connect((pspec) => {
                    if (pspec.name == "completed-length" || pspec.name == "progress" || pspec.name == "status") {
                        if (file_info.is_folder) {
                            int64 ffolder_completed = 0;
                            int64 ffolder_size = 0;
                            calculate_folder_progress(file_info, ref ffolder_completed, ref ffolder_size);
                            double progres = 0.0;
                            if (ffolder_size > 0) {
                                progres = (double)ffolder_completed / (double)ffolder_size;
                            }
                            progrespaint.progress = progres;
                            progress_text_label.label = "%.1f%%".printf(progres * 100);
                            if ((progres * 100) >= 100) {
                                stsicon.icon_name = "com.github.gabutakut.gabutdm.complete";
                                return;
                            }
                            int64 f_status = 0;
                            int64 f_allsts = 0;
                            status_in_folder(file_info, ref f_status, ref f_allsts);
                            if (f_status >= f_allsts) {
                                stsicon.icon_name = "com.github.gabutakut.gabutdm.waiting";
                            } else {
                                stsicon.icon_name = "com.github.gabutakut.gabutdm.active";
                            }
                        } else {
                            progress_text_label.label = "%.1f%%".printf(file_info.progress);
                            if (file_info.progress >= 100) {
                                stsicon.icon_name = "com.github.gabutakut.gabutdm.complete";
                            } else if (file_info.progress < 100 && file_info.status == "waiting") {
                                stsicon.icon_name = "com.github.gabutakut.gabutdm.waiting";
                            } else {
                                stsicon.icon_name = "com.github.gabutakut.gabutdm.active";
                            }
                            progrespaint.progress = file_info.progress / 100;
                        }
                    }
                });
            }
        }

        private void on_file_activated(uint position) {
            TrFileInfo? file_info = file_store.get_item (position) as TrFileInfo;
            if (file_info == null || !file_info.is_folder) {
                return;
            }
            navigate_to_folder(file_info);
        }

        private void on_back_clicked() {
            if (folder_history.size > 0) {
                folder_history.remove_at(folder_history.size - 1);
                if (folder_history.size > 0) {
                    navigate_to_folder(folder_history[folder_history.size - 1], false);
                } else {
                    current_folder = null;
                    update_navigation_buttons();
                    file_stack.set_visible_child_name("list");
                }
            }
        }

        private void on_up_clicked() {
            if (current_folder != null && current_folder.parent != null) {
                navigate_to_folder(current_folder.parent);
            }
        }

        private void auto_send_selected_indexes() {
            if (!has_user_interacted) {
                return;
            }
            Gee.ArrayList<int> selected_indexes = new Gee.ArrayList<int>();
            foreach (TrFileInfo file_info in all_files) {
                if (file_info.selected && !file_info.is_folder && file_info.index != -1) {
                    selected_indexes.add(file_info.index);
                }
            }
            selected_indexes.sort((a, b) => {
                return a - b;
            });
            if (selected_indexes.size > 0) {
                selectedtr = "";
                string[] index_array = new string[selected_indexes.size];
                for (int i = 0; i < selected_indexes.size; i++) {
                    index_array[i] = selected_indexes.get(i).to_string();
                }
                selectedtr = string.joinv (",", index_array);
                var statusdl = status;
                string aria_gid = sendselected (ariagid, selectedtr);
                this.ariagid = aria_gid;
                update_progress ();
                if (statusdl == StatusMode.PAUSED) {
                    aria_pause (this.ariagid);
                }
            }
        }

        private void navigate_to_folder (TrFileInfo folder, bool add_to_history = true) {
            if (add_to_history && current_folder != null) {
                folder_history.add (current_folder);
            }
            current_folder = folder;
            update_navigation_buttons ();
            show_folder_contents (folder);
            file_stack.set_visible_child_name ("folder");
        }

        private void update_navigation_buttons () {
            back_button.sensitive = (folder_history.size > 0);
            up_button.sensitive = (current_folder != null && current_folder.parent != null);
            if (current_folder != null) {
                Gee.ArrayList<string> path_parts = new Gee.ArrayList<string>();
                TrFileInfo? current = current_folder;
                while (current != null) {
                    path_parts.insert(0, current.path);
                    current = current.parent;
                }
                string[] path_array = new string[path_parts.size];
                for (int i = 0; i < path_parts.size; i++) {
                    path_array[i] = path_parts.get (i);
                }
                string path_str = string.joinv(" / ", path_array);
                current_path_label.label = path_str;
            } else {
                current_path_label.label = "";
            }
        }

        private void show_folder_contents (TrFileInfo folder) {
            Gtk.Widget? child = folder_scroll.child;
            if (child != null) {
                folder_scroll.child = null;
            }
            current_folder_list = new Gtk.ListBox () {
                selection_mode = Gtk.SelectionMode.BROWSE
            };
            current_folder_list.set_header_func(folder_header_func);

            Gtk.GestureClick gesture = new Gtk.GestureClick() {
                button = Gdk.BUTTON_PRIMARY
            };
            gesture.pressed.connect((n_press, x, y) => {
                if (n_press == 2) {
                    Gtk.ListBoxRow? row = current_folder_list.get_row_at_y((int)y);
                    if (row != null) {
                        Gtk.Widget? row_widget = row.get_child();
                        if (row_widget != null) {
                            Gtk.Box? row_box = row_widget as Gtk.Box;
                            if (row_box != null) {
                                Gtk.CheckButton? check_button = row_box.get_first_child() as Gtk.CheckButton;
                                if (check_button != null ) {
                                    Gtk.Image? icon = check_button.get_next_sibling() as Gtk.Image;
                                    if (icon != null && icon.icon_name == "folder") {
                                        Gtk.Label? name_label = icon.get_next_sibling() as Gtk.Label;
                                        if (name_label != null) {
                                            string folder_name = name_label.label.replace(" (folder)", "");
                                            foreach (TrFileInfo item in folder.children) {
                                                if (item.is_folder && item.path == folder_name) {
                                                    navigate_to_folder(item);
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            });
            current_folder_list.add_controller(gesture);

            if (folder.children.size > 0) {
                bool has_folders = false;
                foreach (TrFileInfo item in folder.children) {
                    if (item.is_folder) {
                        has_folders = true;
                        break;
                    }
                }
                if (has_folders) {
                    foreach (TrFileInfo item in folder.children) {
                        if (item.is_folder) {
                            current_folder_list.append(create_folder_row(item));
                        }
                    }
                }
            }
            if (folder.children.size > 0) {
                bool has_files = false;
                foreach (TrFileInfo item in folder.children) {
                    if (!item.is_folder) {
                        has_files = true;
                        break;
                    }
                }
                if (has_files) {
                    foreach (TrFileInfo item in folder.children) {
                        if (!item.is_folder) {
                            current_folder_list.append(create_file_row(item));
                        }
                    }
                }
            }
            folder_scroll.child = current_folder_list;
            update_navigation_buttons();
        }
        
        private Gtk.Widget create_folder_row(TrFileInfo folder) {
            Gtk.Box row = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5) {
                margin_start = 2,
                margin_end = 5
            };
            Gtk.CheckButton check_button = new Gtk.CheckButton() {
                valign = Gtk.Align.CENTER,
                active = folder.selected
            };
            int64 total_select = 0;
            int64 all_select = 0;
            selected_in_folder (folder, ref total_select, ref all_select);
            if (total_select >= all_select) {
                check_button.inconsistent = false;
                check_button.active = true;
            } else if (total_select > 0 && total_select < all_select) {
                check_button.inconsistent = true;
                check_button.active = false;
            } else {
                check_button.inconsistent = false;
                check_button.active = false;
            }
            check_button.toggled.connect(() => {
                has_user_interacted = true;
                if (check_button.inconsistent) {
                    check_button.inconsistent = false;
                }
                folder.selected = check_button.active;
                update_folder_selection(folder, check_button.active);
                if (file_stack.get_visible_child_name() == "folder" && current_folder != null) {
                    show_folder_contents(current_folder);
                }
                auto_send_selected_indexes();
            });
            row.append(check_button);
            
            Gtk.Image icon = new Gtk.Image() {
                icon_name = "folder",
                pixel_size = 16
            };
            row.append(icon);
            
            Gtk.Label name_label = new Gtk.Label(folder.path) {
                halign = Gtk.Align.START,
                hexpand = true,
                xalign = 0,
                width_request = 260,
                max_width_chars = 55,
                ellipsize = Pango.EllipsizeMode.MIDDLE,
                valign = Gtk.Align.CENTER,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };
            row.append(name_label);

            Gtk.Label size_label = new Gtk.Label(GLib.format_size(folder.size)) {
                halign = Gtk.Align.END,
                attributes = color_attribute (0, 60000, 0)
            };
            row.append(size_label);

            Gtk.Label progress_label = new Gtk.Label("") {
                halign = Gtk.Align.END,
                width_chars = 8,
                attributes = color_attribute (60000, 30000, 0)
            };
            row.append(progress_label);

            ProgressPaintable progrespaint = new ProgressPaintable ();
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

            row.append(open_button);

            var imgstatus = new Gtk.Image () {
                valign = Gtk.Align.CENTER
            };
            row.set_data<string>("kind", "folder");
            row.append(imgstatus);
            int64 folder_completed = 0;
            int64 folder_size = 0;
            calculate_folder_progress(folder, ref folder_completed, ref folder_size);
            double progress = 0.0;
            if (folder_size > 0) {
                progress = (double)folder_completed / (double)folder_size;
            }
            progrespaint.progress = progress;
            progress_label.label = "%.1f%%".printf(progress * 100);
            int64 f_status = 0;
            int64 f_allsts = 0;
            status_in_folder(folder, ref f_status, ref f_allsts);
            if ((progress * 100) >= 100) {
                imgstatus.icon_name = "com.github.gabutakut.gabutdm.complete";
            } else {
                if (f_status >= f_allsts) {
                    imgstatus.icon_name = "com.github.gabutakut.gabutdm.waiting";
                } else {
                    imgstatus.icon_name = "com.github.gabutakut.gabutdm.active";
                }
            }
            folder.notify.connect((pspec) => {
                if (pspec.name == "completed-length" || pspec.name == "progress" || pspec.name == "status") {
                    int64 f_completed = 0;
                    int64 f_size = 0;
                    calculate_folder_progress(folder, ref f_completed, ref f_size);
                    double prgress = 0.0;
                    if (f_size > 0) {
                        prgress = (double)f_completed / (double)f_size;
                    }
                    progrespaint.progress = prgress;
                    progress_label.label = "%.1f%%".printf(prgress * 100);
                    int64 ff_status = 0;
                    int64 ff_allsts = 0;
                    status_in_folder(folder, ref ff_status, ref ff_allsts);
                    if ((prgress * 100) >= 100) {
                        imgstatus.icon_name = "com.github.gabutakut.gabutdm.complete";
                    } else {
                        if (ff_status >= ff_allsts) {
                            imgstatus.icon_name = "com.github.gabutakut.gabutdm.waiting";
                        } else {
                            imgstatus.icon_name = "com.github.gabutakut.gabutdm.active";
                        }
                    }
                }
            });
            return row;
        }
        
        private Gtk.Widget create_file_row(TrFileInfo file) {
            Gtk.Box row = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5) {
                margin_end = 5,
                margin_top = 2
            };
            Gtk.CheckButton check_button = new Gtk.CheckButton() {
                valign = Gtk.Align.CENTER,
                active = file.selected
            };
            check_button.toggled.connect(() => {
                has_user_interacted = true;
                file.selected = check_button.active;
                if (file_stack.get_visible_child_name() == "folder" && current_folder != null) {
                    show_folder_contents(current_folder);
                }
                auto_send_selected_indexes();
            });
            row.append(check_button);
            
            Gtk.Image icon = new Gtk.Image() {
                gicon = get_icon_for_filename (file.full_path),
                pixel_size = 16
            };
            row.append(icon);
            
            Gtk.Label name_label = new Gtk.Label(file.path) {
                halign = Gtk.Align.START,
                hexpand = true,
                xalign = 0,
                ellipsize = Pango.EllipsizeMode.MIDDLE,
                width_request = 260,
                max_width_chars = 55,
                valign = Gtk.Align.CENTER,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };
            row.append(name_label);
            
            Gtk.Label size_label = new Gtk.Label(GLib.format_size(file.size)) {
                halign = Gtk.Align.END,
                attributes = color_attribute (0, 60000, 0)
            };
            row.append(size_label);
            
            Gtk.Label progress_label = new Gtk.Label("") {
                halign = Gtk.Align.END,
                width_chars = 8,
                attributes = color_attribute (60000, 30000, 0)
            };

            row.append(progress_label);            

            ProgressPaintable progrespaint = new ProgressPaintable ();
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
                if (file.full_path == "") {
                    return;
                }
                var ffile = File.new_for_path (file.full_path);
                open_fileman.begin (ffile.get_parent ().get_uri ());
            });

            row.append(open_button);

            var imgstatus = new Gtk.Image () {
                valign = Gtk.Align.CENTER
            };
            row.set_data<string>("kind", "file");
            row.append(imgstatus);
            if (file.size > 0) {
                double progress = file.progress;
                progrespaint.progress = progress / 100;
                progress_label.label = "%.1f%%".printf(progress);
            }
            if (file.progress >= 100) {
                imgstatus.icon_name = "com.github.gabutakut.gabutdm.complete";
            } else if (file.progress < 100 && file.status == "waiting") {
                imgstatus.icon_name = "com.github.gabutakut.gabutdm.waiting";
            } else {
                imgstatus.icon_name = "com.github.gabutakut.gabutdm.active";
            }
            file.notify.connect((pspec) => {
                if (pspec.name == "completed-length" || pspec.name == "progress" || pspec.name == "status") {
                    progrespaint.progress = file.progress / 100;
                    progress_label.label = "%.1f%%".printf(file.progress);
                    if (file.progress >= 100) {
                        imgstatus.icon_name = "com.github.gabutakut.gabutdm.complete";
                    } else if (file.progress < 100 && file.status == "waiting") {
                        imgstatus.icon_name = "com.github.gabutakut.gabutdm.waiting";
                    } else {
                        imgstatus.icon_name = "com.github.gabutakut.gabutdm.active";
                    }
                }
            });
            return row;
        }

        private Gtk.Widget create_summary_header(TrFileInfo folder) {
            int total_items = folder.children.size;
            int selected = 0;
            int64 folder_total_size = 0;
            int64 folder_total_completed = 0;
            foreach (TrFileInfo f in folder.children) {
                folder_total_size += f.size;
                folder_total_completed += f.completed_length;
                if (f.selected) {
                    selected++;
                }
            }
            Gtk.Box folder_summary = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5) {
                margin_start = 2,
                margin_end = 5
            };
            double folder_progress = 0.0;
            if (folder_total_size > 0) {
                folder_progress = (double)folder_total_completed / (double)folder_total_size * 100.0;
            }
            Gtk.Label folder_stats = new Gtk.Label(_("Item: %d | Terpilih: %d | Progress: %.1f%%").printf(total_items, selected, folder_progress)) {
                halign = Gtk.Align.START,
                valign = Gtk.Align.CENTER,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };
            folder_summary.append(folder_stats);
            Gtk.LevelBar folder_progress_bar = new Gtk.LevelBar() {
                min_value = 0.0,
                max_value = 1.0,
                valign = Gtk.Align.CENTER,
                hexpand = true,
                value = folder_progress / 100.0,
                tooltip_text = "%s / %s".printf(GLib.format_size(folder_total_completed), GLib.format_size(folder_total_size))
            };
            folder.notify.connect((pspec) => {
                if (pspec.name == "completed-length" || pspec.name == "progress") {
                    int64 folder_completed = 0;
                    int64 folder_size = 0;
                    calculate_folder_progress(folder, ref folder_completed, ref folder_size);
                    double progress = 0.0;
                    if (folder_size > 0) {
                        progress = (double)folder_completed / (double)folder_size;
                    }
                    folder_progress_bar.value = progress;
                    folder_stats.label = _("Item: %d | Terpilih: %d | Progress: %.1f%%").printf(total_items, selected, progress * 100);
                }
            });
            folder_summary.append(folder_progress_bar);
            folder_summary.set_data<string>("kind", "summary");
            return folder_summary;
        }

        [CCode (instance_pos = -1)]
        private void folder_header_func(Gtk.ListBoxRow row, Gtk.ListBoxRow? before) {
            Gtk.Widget child = row.get_child();
            string kind = child.get_data<string>("kind");
            string prev_kind = "";
            if (before != null) {
                Gtk.Widget prev = before.get_child();
                prev_kind = prev.get_data<string>("kind");
            }
            if (before == null && kind == "folder") {
                row.set_header(create_summary_header(current_folder));
                return;
            }
            if (kind != prev_kind && kind == "folder") {
                row.set_header(create_summary_header(current_folder));
            }
        }

        private void calculate_folder_progress(TrFileInfo folder, ref int64 completed, ref int64 size) {
            foreach (TrFileInfo child in folder.children) {
                size += child.size;
                completed += child.completed_length;
                if (child.is_folder) {
                    calculate_folder_progress(child, ref completed, ref size);
                }
            }
        }

        private void selected_in_folder(TrFileInfo folder, ref int64 totalselect, ref int64 allselect) {
            foreach (TrFileInfo child in folder.children) {
                if (!child.is_folder) {
                    if (child.selected) {
                        totalselect++;
                    }
                    allselect++;
                } else {
                    selected_in_folder(child, ref totalselect, ref allselect);
                }
            }
        }

        private void status_in_folder(TrFileInfo folder, ref int64 totalstatus, ref int64 allstatus) {
            foreach (TrFileInfo child in folder.children) {
                if (!child.is_folder) {
                    if (child.selected) {
                        if (child.status.down() == "waiting") {
                            totalstatus++;
                        }
                        allstatus++;
                    }
                } else {
                    status_in_folder(child, ref totalstatus, ref allstatus);
                }
            }
        }

        private void update_folder_selection(TrFileInfo folder, bool selected) {
            folder.selected = selected;
            foreach (TrFileInfo child in folder.children) {
                child.selected = selected;
                if (child.is_folder) {
                    update_folder_selection(child, selected);
                }
            }
        }

        private void show_files () {
            string json_str = aria_files_store (ariagid);
            if (json_str == "") {
                return;
            }
            try {
                var parser = new Json.Parser();
                parser.load_from_data(json_str, -1);
                Json.Node? root = parser.get_root();
                if (root == null) {
                    return;
                }
                if (structure_ready) {
                    update_progress_only(root);
                }
            } catch (Error e) {
                GLib.warning (e.message);
            }
        }

        private void parse_aria2_response(Json.Node root_node) {
            TrFileInfo? previous_current_folder = current_folder;
            string? previous_folder_path = null;
            if (previous_current_folder != null) {
                previous_folder_path = get_folder_path(previous_current_folder);
            }
            file_store.remove_all();
            folder_history.clear();
            all_files.clear();
            total_size = 0;
            total_completed = 0;
            total_files = 0;
            Json.Object? root_obj = root_node.get_object();
            if (root_obj == null) {
                return;
            }
            if (root_obj.has_member("error")) {
                Json.Node? error_node = root_obj.get_member("error");
                if (error_node != null) {
                    return;
                }
            }
            Json.Node? result_node = root_obj.get_member("result");
            if (result_node == null) {
                return;
            }
            Json.Array? result_array = result_node.get_array();
            if (result_array == null) {
                return;
            }
            bool is_single_file = true;
            Gee.HashSet<string> base_folders = new Gee.HashSet<string>();
            string longest_common_prefix = "";
            for (uint i = 0; i < result_array.get_length(); i++) {
                Json.Object? file_obj = result_array.get_object_element(i);
                if (file_obj == null) {
                    continue;
                }
                Json.Node? path_node = file_obj.get_member("path");
                if (path_node == null) {
                    continue;
                }
                string path = path_node.get_string();
                if (path == "") {
                    continue;
                }
                string clean_path = path;
                if (clean_path.has_prefix("/")) {
                    clean_path = clean_path.substring(1);
                }
                string[] path_parts = clean_path.split("/");
                if (path_parts.length > 1) {
                    is_single_file = false;
                    if (path_parts.length > 0) {
                        base_folders.add(path_parts[0]);
                    }
                }
                if (longest_common_prefix == "") {
                    longest_common_prefix = path;
                } else {
                    int min_len = int.min(longest_common_prefix.length, path.length);
                    int common_len = 0;
                    for (int j = 0; j < min_len; j++) {
                        if (longest_common_prefix[j] == path[j]) {
                            common_len++;
                        } else {
                            break;
                        }
                    }
                    longest_common_prefix = longest_common_prefix.substring(0, common_len);
                }
            }
            Gee.ArrayList<TrFileInfo> root_files = new Gee.ArrayList<TrFileInfo>();
            for (uint i = 0; i < result_array.get_length(); i++) {
                Json.Object? file_obj = result_array.get_object_element(i);
                if (file_obj == null) {
                    continue;
                }
                string? path = null;
                int64 length = 0;
                int64 completed_length = 0;
                bool selected = true;
                int index = -1;
                Json.Node? path_node = file_obj.get_member("path");
                if (path_node != null) {
                    path = path_node.get_string().strip();
                }
                Json.Node? length_node = file_obj.get_member("length");
                if (length_node != null) {
                    if (length_node.get_value_type() == typeof(string)) {
                        string length_str = length_node.get_string();
                        length = int64.parse(length_str);
                    } else {
                        length = length_node.get_int();
                    }
                }
                Json.Node? completed_node = file_obj.get_member("completedLength");
                if (completed_node != null) {
                    if (completed_node.get_value_type() == typeof(string)) {
                        string completed_str = completed_node.get_string();
                        completed_length = int64.parse(completed_str);
                    } else {
                        completed_length = completed_node.get_int();
                    }
                }
                Json.Node? selected_node = file_obj.get_member("selected");
                if (selected_node != null) {
                    if (selected_node.get_value_type() == typeof(string)) {
                        string selected_str = selected_node.get_string();
                        selected = selected_str.down() == "true";
                    } else {
                        selected = selected_node.get_boolean();
                    }
                }
                Json.Node? index_node = file_obj.get_member("index");
                if (index_node != null) {
                    if (index_node.get_value_type() == typeof(string)) {
                        string index_str = index_node.get_string();
                        index = int.parse(index_str);
                    } else {
                        index = (int)index_node.get_int();
                    }
                }
                string statusurs = status_uris (file_obj);
                if (path == null || path == "") {
                    continue;
                }
                string original_path = path.replace("\\/", "/");
                string[] path_parts = normalize_aria2_path(path, result_array);
                TrFileInfo file_info = new TrFileInfo();
                file_info.size = length;
                file_info.completed_length = completed_length;
                file_info.selected = selected;
                file_info.index = index;
                file_info.is_folder = false;
                file_info.full_path = original_path;
                file_info.status = statusurs;
                total_size += length;
                total_completed += completed_length;
                total_files++;
                all_files.add(file_info);
                if (is_single_file) {
                    file_info.path = path_parts[path_parts.length - 1];
                    root_files.add(file_info);
                } else {
                    if (path_parts.length == 0) {
                        continue;
                    }
                    file_info.path = path_parts[path_parts.length - 1];
                    Gee.ArrayList<TrFileInfo> current_level = root_files;
                    TrFileInfo? current_parent = null;
                    for (int j = 0; j < path_parts.length - 1; j++) {
                        string folder_name = path_parts[j];
                        TrFileInfo? existing_folder = null;
                        foreach (TrFileInfo item in current_level) {
                            if (item.is_folder && item.path == folder_name) {
                                existing_folder = item;
                                break;
                            }
                        }
                        if (existing_folder == null) {
                            TrFileInfo new_folder = new TrFileInfo();
                            new_folder.path = folder_name;
                            new_folder.is_folder = true;
                            new_folder.size = 0;
                            new_folder.selected = true;
                            new_folder.parent = current_parent;
                            current_level.add(new_folder);
                            existing_folder = new_folder;
                        }
                        current_parent = existing_folder;
                        current_level = existing_folder.children;
                    }
                    file_info.parent = current_parent;
                    current_level.add(file_info);
                }
            }

            if (root_files.size == 0 && result_array.get_length() > 0) {
                Json.Object? first_file = result_array.get_object_element(0);
                if (first_file != null) {
                    Json.Node? path_node = first_file.get_member("path");
                    Json.Node? length_node = first_file.get_member("length");
                    Json.Node? completed_node = first_file.get_member("completedLength");
                    if (path_node != null && length_node != null) {
                        TrFileInfo file_info = new TrFileInfo();
                        string path = path_node.get_string();
                        if (path == "") {
                            return;
                        }
                        if (path.has_prefix("/")) {
                            path = path.substring(1);
                        }
                        string[] clean_parts = path.split("/");
                        if (clean_parts.length == 1) {
                            file_info.path = clean_parts[clean_parts.length - 1];
                        } else {
                            file_info.path = clean_parts[clean_parts.length - 1];
                            Gee.ArrayList<TrFileInfo> current_level = root_files;
                            TrFileInfo? current_parent = null;
                            for (int j = 0; j < clean_parts.length - 1; j++) {
                                string folder_name = clean_parts[j];
                                TrFileInfo? existing_folder = null;
                                foreach (TrFileInfo item in current_level) {
                                    if (item.is_folder && item.path == folder_name) {
                                        existing_folder = item;
                                        break;
                                    }
                                }
                                if (existing_folder == null) {
                                    TrFileInfo new_folder = new TrFileInfo();
                                    new_folder.path = folder_name;
                                    new_folder.is_folder = true;
                                    new_folder.size = 0;
                                    new_folder.selected = true;
                                    new_folder.parent = current_parent;
                                    current_level.add(new_folder);
                                    existing_folder = new_folder;
                                }
                                current_parent = existing_folder;
                                current_level = existing_folder.children;
                            }
                            file_info.parent = current_parent;
                            current_level.add(file_info);
                        }
                        
                        if (length_node.get_value_type() == typeof(string)) {
                            string length_str = length_node.get_string();
                            file_info.size = int64.parse(length_str);
                        } else {
                            file_info.size = length_node.get_int();
                        }
                        if (completed_node != null) {
                            if (completed_node.get_value_type() == typeof(string)) {
                                string completed_str = completed_node.get_string();
                                file_info.completed_length = int64.parse(completed_str);
                            } else {
                                file_info.completed_length = completed_node.get_int();
                            }
                        }
                        file_info.selected = true;
                        file_info.is_folder = false;
                        all_files.add(file_info);
                        total_files = 1;
                        total_size = file_info.size;
                        total_completed = file_info.completed_length;
                    }
                }
            }
            GLib.MainContext.default ().invoke (() => {
                calculate_folder_sizes_and_progress(root_files);
                double total_progress = 0.0;
                if (total_size > 0) {
                    total_progress = (double)total_completed / (double)total_size * 100.0;
                }
                foreach (TrFileInfo file in root_files) {
                    file_store.append(file);
                }
                file_store.sort(folder_first_compare);
                if (previous_folder_path != null && file_stack.get_visible_child_name() == "folder") {
                    TrFileInfo? found_folder = find_folder_by_path(root_files, previous_folder_path);
                    if (found_folder != null) {
                        current_folder = found_folder;
                        show_folder_contents(found_folder);
                    } else {
                        current_folder = null;
                        file_stack.set_visible_child_name("list");
                    }
                } else {
                    current_folder = null;
                }
                Gtk.Box nav_header = folder_view_box.get_first_child() as Gtk.Box;
                if (nav_header != null) {
                    Gtk.Widget? home_button = nav_header.get_first_child();
                    home_button = home_button.get_next_sibling().get_next_sibling();
                    if (home_button != null) {
                        home_button.sensitive = true;
                    }
                }
                update_navigation_buttons();
                structure_ready = true;
                return GLib.Source.REMOVE;
            });
        }

        private string status_uris (Json.Object file_obj) {
            string status_urs = "";
            Json.Node? uris_node = file_obj.get_member("uris");
            if (uris_node == null) {
                return status_urs;
            }
            if (file_obj.has_member("uris")) {
                var uris = file_obj.get_array_member("uris");
                for (uint i = 0; i < uris.get_length(); i++) {
                    var u = uris.get_object_element(i);
                    status_urs = u.has_member("status")? u.get_string_member("status"): "";
                }
            }
            return status_urs;
        }

        private void update_progress_only(Json.Node root_node) {
            Json.Object root = root_node.get_object();
            Json.Array arr = root.get_member("result").get_array();
            for (uint i = 0; i < arr.get_length(); i++) {
                Json.Object f = arr.get_object_element(i);
                int idx = int.parse(f.get_member("index").get_string());
                int64 completed = int64.parse(f.get_member("completedLength").get_string());
                bool selected_node = bool.parse(f.get_member("selected").get_string());
                string statusurs = status_uris (f);
                foreach (TrFileInfo fi in all_files) {
                    if (fi.index == idx) {
                        fi.completed_length = completed;
                        fi.selected = selected_node;
                        fi.status = statusurs;
                        propagate_folder_progress(fi.parent);
                        break;
                    }
                }
            }
        }

        private void propagate_folder_progress(TrFileInfo? folder) {
            if (folder == null || !folder.is_folder) {
                return;
            }
            int64 total = 0;
            int64 done = 0;
            calculate_folder_progress(folder, ref done, ref total);
            folder.size = total;
            folder.completed_length = done;
            propagate_folder_progress(folder.parent);
        }

        private static int folder_first_compare(GLib.Object a, GLib.Object b) {
            TrFileInfo fa = a as TrFileInfo;
            TrFileInfo fb = b as TrFileInfo;
            if (fa == null || fb == null) {
                return 0;
            }
            if (fa.is_folder && !fb.is_folder) {
                return -1;
            }
            if (!fa.is_folder && fb.is_folder) {
                return 1;
            }
            return fa.path.collate(fb.path);
        }

        private string get_folder_path(TrFileInfo folder) {
            Gee.ArrayList<string> path_parts = new Gee.ArrayList<string>();
            TrFileInfo? current = folder;
            while (current != null) {
                path_parts.insert(0, current.path);
                current = current.parent;
            }
            string[] path_array = new string[path_parts.size];
            for (int i = 0; i < path_parts.size; i++) {
                path_array[i] = path_parts.get(i);
            }
            return string.joinv("/", path_array);
        }

        private TrFileInfo? find_folder_by_path(Gee.ArrayList<TrFileInfo> root_files, string path) {
            string[] path_parts = path.split("/");
            Gee.ArrayList<TrFileInfo> current_level = root_files;
            TrFileInfo? found_folder = null;
            for (int i = 0; i < path_parts.length; i++) {
                string folder_name = path_parts[i];
                TrFileInfo? existing_folder = null;
                foreach (TrFileInfo item in current_level) {
                    if (item.is_folder && item.path == folder_name) {
                        existing_folder = item;
                        break;
                    }
                }
                if (existing_folder == null) {
                    return null;
                }
                found_folder = existing_folder;
                current_level = existing_folder.children;
            }
            return found_folder;
        }

        private void calculate_folder_sizes_and_progress(Gee.ArrayList<TrFileInfo> files) {
            foreach (TrFileInfo file in files) {
                if (file.is_folder) {
                    calculate_folder_sizes_and_progress(file.children);
                    int64 folder_size = 0;
                    int64 folder_completed = 0;
                    bool all_selected = true;
                    foreach (TrFileInfo child in file.children) {
                        folder_size += child.size;
                        folder_completed += child.completed_length;
                        if (!child.selected) {
                            all_selected = false;
                        }
                    }
                    file.size = folder_size;
                    file.completed_length = folder_completed;
                    file.selected = all_selected;
                }
            }
        }
    }
}