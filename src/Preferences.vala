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
    public class Preferences : Gtk.Dialog {
        public signal void restart_server ();
        public signal void restart_process ();
        public signal void max_active ();
        public signal void global_opt ();
        private Gtk.MenuButton allocate_button;
        private Gtk.MenuButton piecesel_button;
        private Gtk.MenuButton urisel_button;
        private Gtk.Button folder_location;
        private Gtk.Button folder_sharing;

        FileAllocation _fileallocation = null;
        FileAllocation fileallocation {
            get {
                return _fileallocation;
            }
            set {
                _fileallocation = value;
                allocate_button.label = _fileallocation.fileallocation.to_string ();
            }
        }

        PieceSelector _pieceselector = null;
        PieceSelector pieceselector {
            get {
                return _pieceselector;
            }
            set {
                _pieceselector = value;
                piecesel_button.label = _pieceselector.selector.to_string ();
            }
        }

        UriSelector _uriselector = null;
        UriSelector uriselector {
            get {
                return _uriselector;
            }
            set {
                _uriselector = value;
                urisel_button.label = _uriselector.selector.to_string ();
            }
        }

        GLib.File _selectfd = null;
        GLib.File selectfd {
            get {
                return _selectfd;
            }
            set {
                _selectfd = value;
                if (selectfd != null) {
                    folder_location.child = button_chooser (selectfd);
                }
            }
        }

        GLib.File _selectfs = null;
        GLib.File selectfs {
            get {
                return _selectfs;
            }
            set {
                _selectfs = value;
                if (selectfs != null) {
                    folder_sharing.child = button_chooser (selectfs);
                }
            }
        }

        construct {
            resizable = false;
            use_header_bar = 1;
            var view_mode = new ModeButton () {
                hexpand = false,
                homogeneous = true,
                width_request = 300
            };
            view_mode.append_text (_("Default"));
            view_mode.append_text (_("BitTorrent"));
            view_mode.append_text (_("Sharing"));
            view_mode.append_text (_("Option"));
            view_mode.append_text (_("System"));
            view_mode.selected = 0;

            var header = get_header_bar ();
            header.decoration_layout = "none";
            header.title_widget = view_mode;

            var pack_data = aria_v2_globalops ();
            var numbtries = new Gtk.SpinButton.with_range (0, 100, 1) {
                width_request = 300,
                hexpand = true,
                tooltip_text = _("Number of tries"),
                value = double.parse (pharse_options (pack_data, AriaOptions.MAX_TRIES))
            };

            var numbconn = new Gtk.SpinButton.with_range (0, 16, 1) {
                width_request = 300,
                hexpand = true,
                tooltip_text = _("The maximum number of connections to one server for each download"),
                value = double.parse (pharse_options (pack_data, AriaOptions.MAX_CONNECTION_PER_SERVER))
            };

            var maxcurrent = new Gtk.SpinButton.with_range (1, 50, 1) {
                width_request = 300,
                hexpand = true,
                tooltip_text = _("The maximum number of parallel downloads for every queue item"),
                value = double.parse (pharse_options (pack_data, AriaOptions.MAX_CONCURRENT_DOWNLOADS))
            };

            var timeout = new Gtk.SpinButton.with_range (0, 600, 1) {
                width_request = 300,
                hexpand = true,
                tooltip_text = _("Timeout"),
                value = double.parse (pharse_options (pack_data, AriaOptions.TIMEOUT))
            };

            var retry = new Gtk.SpinButton.with_range (0, 600, 1) {
                width_request = 300,
                hexpand = true,
                tooltip_text = _("The seconds to wait between retries"),
                value = double.parse (pharse_options (pack_data, AriaOptions.RETRY_WAIT))
            };

            var split = new Gtk.SpinButton.with_range (0, 6000, 1) {
                width_request = 300,
                hexpand = true,
                tooltip_text = _("Download a file using N connections.  If more than N URIs are given, first N URIs are used and remaining URIs are used for backup.  If less than N URIs are given, those URIs are used more than once so that N connections total are made simultaneously."),
                value = double.parse (pharse_options (pack_data, AriaOptions.SPLIT))
            };

            var splitsize = new Gtk.SpinButton.with_range (0, 9999999, 1) {
                width_request = 300,
                hexpand = true,
                tooltip_text = _("Split"),
                value = double.parse (pharse_options (pack_data, AriaOptions.MIN_SPLIT_SIZE)) / 1024
            };

            var lowestspd = new Gtk.SpinButton.with_range (0, 9999999, 1) {
                width_request = 300,
                hexpand = true,
                tooltip_text = _("Close connection if download speed is lower than or equal to this value(bytes per sec)"),
                value = double.parse (pharse_options (pack_data, AriaOptions.LOWEST_SPEED_LIMIT)) / 1024
            };

            var stream_flow = new Gtk.FlowBox ();
            var stream_popover = new Gtk.Popover () {
                child = stream_flow
            };

            piecesel_button = new Gtk.MenuButton () {
                direction = Gtk.ArrowType.UP,
                tooltip_text = _("Specify piece selection algorithm used in HTTP/FTP download"),
                popover = stream_popover
            };
            foreach (var piecesel in PieceSelectors.get_all ()) {
                stream_flow.append (new PieceSelector (piecesel));
            }
            stream_flow.show ();
            stream_flow.child_activated.connect ((piecesel)=> {
                ((Gtk.Label)((PieceSelector) pieceselector).get_last_child ()).attributes = set_attribute (Pango.Weight.BOLD);
                pieceselector = piecesel as PieceSelector;
                ((Gtk.Label)pieceselector.get_last_child ()).attributes = color_attribute (0, 60000, 0);
                stream_popover.hide ();
            });
            foreach (var a in PieceSelectors.get_all ()) {
                var piecesel = stream_flow.get_child_at_index (a);
                if (((PieceSelector) piecesel).selector.to_string ().down () == pharse_options (pack_data, AriaOptions.STREAM_PIECE_SELECTOR)) {
                    pieceselector = piecesel as PieceSelector;
                    ((Gtk.Label)pieceselector.get_last_child ()).attributes = color_attribute (0, 60000, 0);
                }
            }
            stream_popover.show.connect (() => {
                stream_flow.unselect_all ();
            });
            var urisel_flow = new Gtk.FlowBox ();
            var urisel_popover = new Gtk.Popover () {
                child = urisel_flow
            };

            urisel_button = new Gtk.MenuButton () {
                direction = Gtk.ArrowType.UP,
                tooltip_text = _("Specify URI selection algorithm"),
                popover = urisel_popover
            };
            foreach (var urisel in UriSelectors.get_all ()) {
                urisel_flow.append (new UriSelector (urisel));
            }
            urisel_flow.show ();
            urisel_flow.child_activated.connect ((urisel)=> {
                ((Gtk.Label)((UriSelector) uriselector).get_last_child ()).attributes = set_attribute (Pango.Weight.BOLD);
                uriselector = urisel as UriSelector;
                ((Gtk.Label)uriselector.get_last_child ()).attributes = color_attribute (0, 60000, 0);
                urisel_popover.hide ();
            });
            foreach (var a in UriSelectors.get_all ()) {
                var urisel = urisel_flow.get_child_at_index (a);
                if (((UriSelector) urisel).selector.to_string ().down () == pharse_options (pack_data, AriaOptions.URI_SELECTOR)) {
                    uriselector = urisel as UriSelector;
                    ((Gtk.Label)uriselector.get_last_child ()).attributes = color_attribute (0, 60000, 0);
                }
            }
            urisel_popover.show.connect (() => {
                urisel_flow.unselect_all ();
            });
            var settings = new Gtk.Grid () {
                column_homogeneous = true,
                height_request = 150,
                margin_bottom = 5,
                column_spacing = 10,
                margin_start = 2,
                margin_end = 2,
                halign = Gtk.Align.START
            };
            settings.attach (headerlabel (_("Number of Tries:"), 300), 1, 0, 1, 1);
            settings.attach (numbtries, 1, 1, 1, 1);
            settings.attach (headerlabel (_("Connection:"), 300), 0, 0, 1, 1);
            settings.attach (numbconn, 0, 1, 1, 1);
            settings.attach (headerlabel (_("Active Download:"), 300), 1, 2, 1, 1);
            settings.attach (maxcurrent, 1, 3, 1, 1);
            settings.attach (headerlabel (_("Time out (in Secconds):"), 300), 0, 2, 1, 1);
            settings.attach (timeout, 0, 3, 1, 1);
            settings.attach (headerlabel (_("Retry Wait (in Secconds):"), 300), 1, 4, 1, 1);
            settings.attach (retry, 1, 5, 1, 1);
            settings.attach (headerlabel (_("Split:"), 300), 0, 4, 1, 1);
            settings.attach (split, 0, 5, 1, 1);
            settings.attach (headerlabel (_("Lowest Speed (in Kb):"), 300), 1, 6, 1, 1);
            settings.attach (lowestspd, 1, 7, 1, 1);
            settings.attach (headerlabel (_("Split Size (in Kb):"), 300), 0, 6, 1, 1);
            settings.attach (splitsize, 0, 7, 1, 1);
            settings.attach (headerlabel (_("Piece Selector:"), 300), 1, 8, 1, 1);
            settings.attach (piecesel_button, 1, 9, 1, 1);
            settings.attach (headerlabel (_("Uri Selector:"), 300), 0, 8, 1, 1);
            settings.attach (urisel_button, 0, 9, 1, 1);

            var maxopfile = new Gtk.SpinButton.with_range (0, 200, 1) {
                width_request = 300,
                hexpand = true,
                tooltip_text = _("Specify maximum number of files to open in multi-file BitTorrent/Metalink download globally"),
                value = double.parse (pharse_options (pack_data, AriaOptions.BT_MAX_OPEN_FILES))
            };

            var maxpeers = new Gtk.SpinButton.with_range (0, 200, 1) {
                width_request = 300,
                hexpand = true,
                tooltip_text = _("Specify the maximum number of peers per torrent"),
                value = double.parse (pharse_options (pack_data, AriaOptions.BT_MAX_PEERS))
            };

            var bt_timeout = new Gtk.SpinButton.with_range (0, 240, 1) {
                width_request = 300,
                hexpand = true,
                tooltip_text = _("Timeout"),
                value = double.parse (pharse_options (pack_data, AriaOptions.BT_TRACKER_TIMEOUT))
            };

            var bt_seedtime = new Gtk.SpinButton.with_range (0, 240, 1) {
                width_request = 300,
                hexpand = true,
                tooltip_text = _("Specify seeding time in (fractional) minutes"),
                value = double.parse (pharse_options (pack_data, AriaOptions.SEED_TIME))
            };

            var bt_upload = new Gtk.SpinButton.with_range (0, 999999, 1) {
                width_request = 300,
                hexpand = true,
                tooltip_text = _("Max overall upload speed"),
                value = double.parse (pharse_options (pack_data, AriaOptions.MAX_OVERALL_UPLOAD_LIMIT)) / 1024
            };

            var bt_download = new Gtk.SpinButton.with_range (0, 999999, 1) {
                width_request = 300,
                hexpand = true,
                tooltip_text = _("Max overall download speed "),
                value = double.parse (pharse_options (pack_data, AriaOptions.MAX_OVERALL_DOWNLOAD_LIMIT)) / 1024
            };
            var trackertext = new Gtk.TextView () {
                wrap_mode = Gtk.WrapMode.WORD_CHAR,
                tooltip_text = _("Comma separated list of additional BitTorrent tracker's announce URI")
            };
            trackertext.buffer.text = pharse_options (pack_data, AriaOptions.BT_TRACKER).replace ("\\/", "/");

            var trackerscr = new Gtk.ScrolledWindow () {
                width_request = 300,
                height_request = 100,
                child = trackertext
            };

            var load_tr = new Gtk.Button.from_icon_name ("document-open") {
                has_frame = false,
                tooltip_text = _("Open Text Tracker")
            };
            load_tr.clicked.connect (() => {
                run_open_text.begin (this, OpenFiles.OPENTEXTONE, (obj, res)=> {
                    try {
                        GLib.File file;
                        run_open_text.end (res, out file);
                        if (file != null) {
                            try {
                                trackertext.buffer.text = (string) file.load_bytes ().get_data ();
                            } catch (Error e) {
                                GLib.warning (e.message);
                            }
                        }
                    } catch (GLib.Error e) {
                        critical (e.message);
                    }
                });
            });

            var fformat_tr = new Gtk.Button.from_icon_name ("view-refresh") {
                has_frame = false,
                tooltip_text = _("Fix to Tracker")
            };
            fformat_tr.clicked.connect (() => {
                var formatclr = fixtoformat (trackertext.buffer.text);
                trackertext.buffer.text = formatclr;
            });

            var clear_tr = new Gtk.Button.from_icon_name ("com.github.gabutakut.gabutdm.clear") {
                has_frame = false,
                tooltip_text = _("Clear Text Tracker")
            };
            clear_tr.clicked.connect (() => {
                trackertext.buffer.text = "";
            });

            var action_track = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                hexpand = true
            };
            action_track.append (load_tr);
            action_track.append (fformat_tr);
            action_track.append (clear_tr);

            var layout_track = new Gtk.Grid () {
                orientation = Gtk.Orientation.VERTICAL
            };
            layout_track.attach (trackerscr, 0, 0);
            layout_track.attach (action_track, 0, 1);

            var etrackertext = new Gtk.TextView () {
                wrap_mode = Gtk.WrapMode.WORD_CHAR,
                tooltip_text = _("Comma separated list of BitTorrent tracker's announce URI to remove")
            };
            etrackertext.buffer.text = pharse_options (pack_data, AriaOptions.BT_EXCLUDE_TRACKER).replace ("\\/", "/");

            var etrackerscr = new Gtk.ScrolledWindow () {
                width_request = 300,
                height_request = 100,
                child = etrackertext
            };

            var load_etr = new Gtk.Button.from_icon_name ("document-open") {
                has_frame = false,
                tooltip_text = _("Open Text Tracker")
            };
            load_etr.clicked.connect (() => {
                run_open_text.begin (this, OpenFiles.OPENTEXTTWO, (obj, res)=> {
                    try {
                        GLib.File file;
                        run_open_text.end (res, out file);
                        if (file != null) {
                            try {
                                etrackertext.buffer.text = (string) file.load_bytes ().get_data ();
                            } catch (Error e) {
                                GLib.warning (e.message);
                            }
                        }
                    } catch (GLib.Error e) {
                        critical (e.message);
                    }
                });
            });
            var fformat_etr = new Gtk.Button.from_icon_name ("view-refresh") {
                has_frame = false,
                tooltip_text = _("Fix to Tracker")
            };
            fformat_etr.clicked.connect (() => {
                var formatclr = fixtoformat (etrackertext.buffer.text);
                etrackertext.buffer.text = formatclr;
            });
            var clear_etr = new Gtk.Button.from_icon_name ("com.github.gabutakut.gabutdm.clear") {
                has_frame = false,
                tooltip_text = _("Clear Text Tracker")
            };
            clear_etr.clicked.connect (() => {
                etrackertext.buffer.text = "";
            });
            var actionetr = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                hexpand = true
            };
            actionetr.append (load_etr);
            actionetr.append (fformat_etr);
            actionetr.append (clear_etr);

            var layout_etrack = new Gtk.Grid () {
                orientation = Gtk.Orientation.VERTICAL
            };
            layout_etrack.attach (etrackerscr, 0, 0);
            layout_etrack.attach (actionetr, 0, 1);

            var bittorrent = new Gtk.Grid () {
                column_homogeneous = true,
                height_request = 150,
                margin_bottom = 5,
                column_spacing = 10,
                margin_start = 2,
                margin_end = 2,
                halign = Gtk.Align.START
            };
            bittorrent.attach (headerlabel (_("Max Open File:"), 300), 1, 0, 1, 1);
            bittorrent.attach (maxopfile, 1, 1, 1, 1);
            bittorrent.attach (headerlabel (_("Bittorent Max Peers:"), 300), 0, 0, 1, 1);
            bittorrent.attach (maxpeers, 0, 1, 1, 1);
            bittorrent.attach (headerlabel (_("Tracker Time out (in Secconds):"), 300), 1, 2, 1, 1);
            bittorrent.attach (bt_timeout, 1, 3, 1, 1);
            bittorrent.attach (headerlabel (_("Seed Time (in Minutes):"), 300), 0, 2, 1, 1);
            bittorrent.attach (bt_seedtime, 0, 3, 1, 1);
            bittorrent.attach (headerlabel (_("Upload Limit (in Kb):"), 300), 1, 4, 1, 1);
            bittorrent.attach (bt_upload, 1, 5, 1, 1);
            bittorrent.attach (headerlabel (_("Download Limit (in Kb):"), 300), 0, 4, 1, 1);
            bittorrent.attach (bt_download, 0, 5, 1, 1);
            bittorrent.attach (headerlabel (_("BitTorrent Tracker Exclude:"), 300), 1, 6, 1, 1);
            bittorrent.attach (layout_etrack, 1, 7, 1, 1);
            bittorrent.attach (headerlabel (_("BitTorrent Tracker:"), 300), 0, 6, 1, 1);
            bittorrent.attach (layout_track, 0, 7, 1, 1);

            folder_location = new Gtk.Button () {
                tooltip_text = _("The directory to store the downloaded file")
            };
            folder_location.clicked.connect (()=> {
                run_open_fd.begin (this, OpenFiles.OPENGLOBALFOLDER, (obj, res)=> {
                    try {
                        GLib.File file;
                        run_open_fd.end (res, out file);
                        if (file != null) {
                            selectfd = file;
                        }
                    } catch (GLib.Error e) {
                        critical (e.message);
                    }
                });
            });
            selectfd = File.new_for_path (pharse_options (pack_data, AriaOptions.DIR).replace ("\\/", "/"));

            folder_sharing = new Gtk.Button () {
                tooltip_text = _("The directory is Shared for connected the same Network")
            };
            folder_sharing.clicked.connect (()=> {
                run_open_fd.begin (this, OpenFiles.OPENFOLDERSHARING, (obj, res)=> {
                    try {
                        GLib.File file;
                        run_open_fd.end (res, out file);
                        if (file != null) {
                            selectfs = file;
                        }
                    } catch (GLib.Error e) {
                        critical (e.message);
                    }
                });
            });
            selectfs = File.new_for_path (get_dbsetting (DBSettings.SHAREDIR));

            var add_auth = new Gtk.Button.from_icon_name ("list-add") {
                tooltip_text = _("Add Authenty local server")
            };

            var usergrid = new Gtk.Grid () {
                column_spacing = 10,
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            int rowpos = 0;
            get_users ().foreach ((user)=> {
                rowpos++;
                set_account (usergrid, user, rowpos);
            });

            add_auth.clicked.connect (()=> {
                rowpos++;
                var users = UsersID ();
                users.id = add_db_user (get_real_time ());;
                users.activate = false;
                users.user = "";
                users.passwd = "";
                set_account (usergrid, users, rowpos);
            });

            var sharebutton = new Gtk.CheckButton.with_label (_("Folder Sharing:")) {
                margin_top = 5,
                margin_bottom = 5,
                active = bool.parse (get_dbsetting (DBSettings.SWITCHDIR))
            };
            ((Gtk.Label) sharebutton.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            sharebutton.toggled.connect (()=> {
                folder_sharing.sensitive = sharebutton.active;
            });
            folder_sharing.sensitive = sharebutton.active;
            var boxuser = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            boxuser.append (usergrid);
            boxuser.append (add_auth);
            var userscr = new Gtk.ScrolledWindow () {
                width_request = 610,
                vexpand = true,
                child = boxuser
            };
            var folderopt = new Gtk.Grid () {
                height_request = 150,
                margin_bottom = 5,
                margin_start = 2,
                margin_end = 2,
                halign = Gtk.Align.START
            };
            folderopt.attach (headerlabel (_("Save to Folder:"), 500), 1, 0, 1, 1);
            folderopt.attach (folder_location, 1, 1, 1, 1);
            folderopt.attach (sharebutton, 1, 2, 1, 1);
            folderopt.attach (folder_sharing, 1, 3, 1, 1);
            folderopt.attach (headerlabel (_("Authentication:"), 500), 1, 4, 1, 1);
            folderopt.attach (userscr, 1, 5, 1, 1);

            var rpc_port = new Gtk.SpinButton.with_range (0, 9999, 1) {
                width_request = 300,
                hexpand = true,
                tooltip_text = _("Specify a port number for JSON-RPC/XML-RPC server to listen to"),
                value = double.parse (pharse_options (pack_data, AriaOptions.RPC_LISTEN_PORT))
            };

            var local_port = new Gtk.SpinButton.with_range (0, 9999, 1) {
                width_request = 300,
                hexpand = true,
                tooltip_text = _("pecify a port number for local server to listen to"),
                value = double.parse (get_dbsetting (DBSettings.PORTLOCAL))
            };

            var bt_listenport = new Gtk.SpinButton.with_range (0, 99999, 1) {
                width_request = 300,
                hexpand = true,
                tooltip_text = _("TCP port number for BitTorrent downloads"),
                value = double.parse (pharse_options (pack_data, AriaOptions.LISTEN_PORT))
            };

            var dht_listenport = new Gtk.SpinButton.with_range (0, 99999, 1) {
                width_request = 300,
                hexpand = true,
                tooltip_text = _("UDP listening port used by DHT(IPv4, IPv6) and UDP tracker"),
                value = double.parse (pharse_options (pack_data, AriaOptions.DHT_LISTEN_PORT))
            };

            var maxrequest = new Gtk.SpinButton.with_range (0, 9000000000, 1) {
                width_request = 300,
                hexpand = true,
                tooltip_text = _("Max size of JSON-RPC/XML-RPC request"),
                value = double.parse (pharse_options (pack_data, AriaOptions.RPC_MAX_REQUEST_SIZE))
            };

            var diskcache = new Gtk.SpinButton.with_range (0, 9000000000, 1) {
                width_request = 300,
                hexpand = true,
                tooltip_text = _("Enable disk cache. If SIZE is 0, the disk cache is disabled"),
                value = double.parse (pharse_options (pack_data, AriaOptions.DISK_CACHE))
            };

            var allocate_flow = new Gtk.FlowBox ();
            var allocate_popover = new Gtk.Popover () {
                child = allocate_flow
            };

            allocate_button = new Gtk.MenuButton () {
                tooltip_text = _("Specify file allocation method"),
                popover = allocate_popover
            };
            foreach (var allocate in FileAllocations.get_all ()) {
                allocate_flow.append (new FileAllocation (allocate));
            }
            allocate_flow.show ();
            allocate_flow.child_activated.connect ((allocate)=> {
                ((Gtk.Label)((FileAllocation) fileallocation).get_last_child ()).attributes = set_attribute (Pango.Weight.BOLD);
                fileallocation = allocate as FileAllocation;
                ((Gtk.Label)fileallocation.get_last_child ()).attributes = color_attribute (0, 60000, 0);
                allocate_popover.hide ();
            });
            foreach (var a in FileAllocations.get_all ()) {
                var allocate = allocate_flow.get_child_at_index (a);
                if (((FileAllocation) allocate).fileallocation.to_string ().down () == pharse_options (pack_data, AriaOptions.FILE_ALLOCATION)) {
                    fileallocation = allocate as FileAllocation;
                    ((Gtk.Label)fileallocation.get_last_child ()).attributes = color_attribute (0, 60000, 0);
                }
            }
            allocate_popover.show.connect (() => {
                allocate_flow.unselect_all ();
            });
            var moreoptions = new Gtk.Grid () {
                column_homogeneous = true,
                height_request = 150,
                margin_bottom = 5,
                column_spacing = 10,
                margin_start = 2,
                margin_end = 2,
                halign = Gtk.Align.START
            };
            moreoptions.attach (headerlabel (_("RPC Port:"), 300), 0, 0, 1, 1);
            moreoptions.attach (rpc_port, 0, 1, 1, 1);
            moreoptions.attach (headerlabel (_("Local Port:"), 300), 0, 2, 1, 1);
            moreoptions.attach (local_port, 0, 3, 1, 1);
            moreoptions.attach (headerlabel (_("BT Listen Port:"), 300), 0, 4, 1, 1);
            moreoptions.attach (bt_listenport, 0, 5, 1, 1);
            moreoptions.attach (headerlabel (_("File Allocation:"), 300), 0, 6, 1, 1);
            moreoptions.attach (allocate_button, 0, 7, 2, 1);
            moreoptions.attach (headerlabel (_("RPC Max Request Size (in Byte):"), 300), 1, 0, 1, 1);
            moreoptions.attach (maxrequest, 1, 1, 1, 1);
            moreoptions.attach (headerlabel (_("Disk Cache (in Byte):"), 300), 1, 2, 1, 1);
            moreoptions.attach (diskcache, 1, 3, 1, 1);
            moreoptions.attach (headerlabel (_("DHT Listen Port:"), 300), 1, 4, 1, 1);
            moreoptions.attach (dht_listenport, 1, 5, 1, 1);

            var dialognotify = new Gtk.CheckButton.with_label (_("Open dialog succes when download complete")) {
                margin_top = 5,
                width_request = 610,
                active = bool.parse (get_dbsetting (DBSettings.DIALOGNOTIF))
            };

            var systemnotif = new Gtk.CheckButton.with_label (_("Send notification system")) {
                margin_top = 5,
                width_request = 610,
                active = bool.parse (get_dbsetting (DBSettings.SYSTEMNOTIF))
            };

            var soundnotif = new Gtk.CheckButton.with_label (_("Send notification sound")) {
                margin_top = 5,
                width_request = 610,
                active = bool.parse (get_dbsetting (DBSettings.NOTIFSOUND))
            };

            var retonhide = new Gtk.CheckButton.with_label (_("Running on background")) {
                margin_top = 5,
                width_request = 610,
                active = bool.parse (get_dbsetting (DBSettings.ONBACKGROUND))
            };

            var appstartup = new Gtk.CheckButton.with_label (_("Launch App on Startup")) {
                margin_top = 5,
                width_request = 610,
                active = bool.parse (get_dbsetting (DBSettings.STARTUP))
            };

            var appclipboard = new Gtk.CheckButton.with_label (_("Add Url From Clipboard")) {
                margin_top = 5,
                width_request = 610,
                active = bool.parse (get_dbsetting (DBSettings.CLIPBOARD))
            };

            var dbusmenu = new Gtk.CheckButton.with_label (_("Dbus Menu")) {
                margin_top = 5,
                width_request = 610,
                active = bool.parse (get_dbsetting (DBSettings.DBUSMENU))
            };

            var menuindicator = new Gtk.CheckButton.with_label (_("Indicator Menu")) {
                margin_top = 5,
                width_request = 610,
                active = bool.parse (get_dbsetting (DBSettings.MENUINDICATOR)),
                sensitive = dbusmenu.active
            };
            var label_mode = new ModeTogle ();
            label_mode.add_item (new ModeTogle.with_label (_("None")));
            label_mode.add_item (new ModeTogle.with_label (_("App Name")));
            label_mode.add_item (new ModeTogle.with_label (_("Total Speed")));
            label_mode.id = int.parse (get_dbsetting (DBSettings.LABELMODE));
            var label_rev = new Gtk.Revealer () {
                child = label_mode
            };
            label_rev.reveal_child = menuindicator.active;
            menuindicator.toggled.connect (()=> {
                label_rev.reveal_child = menuindicator.active;
                label_mode.sensitive = dbusmenu.active && menuindicator.active;
            });
            dbusmenu.toggled.connect (()=> {
                menuindicator.sensitive = dbusmenu.active;
                label_mode.sensitive = dbusmenu.active && menuindicator.active;
            });
            var tdefault = new Gtk.CheckButton.with_label (_("Theme")) {
                margin_top = 5,
                width_request = 610,
                active = bool.parse (get_dbsetting (DBSettings.TDEFAULT))
            };
            var theme_entry = new MediaEntry.activable ("com.github.gabutakut.gabutdm.complete", "com.github.gabutakut.gabutdm.theme") {
                width_request = 610,
                margin_bottom = 4,
                text = get_dbsetting (DBSettings.THEMECUSTOM),
                placeholder_text = _("Enter the theme name here"),
                secondary_icon_tooltip_text = _("Theme")
            };

            var theme_mode = new ModeTogle ();
            theme_mode.add_item (new ModeTogle.with_label (_("Default")));
            theme_mode.add_item (new ModeTogle.with_label (_("Custom")));
            theme_mode.id = int.parse (get_dbsetting (DBSettings.THEMESELECT));
            var gridtheme = new Gtk.Box (Gtk.Orientation.VERTICAL, 1);
            gridtheme.append (theme_mode);
            gridtheme.append (theme_entry);
            var theme_rev = new Gtk.Revealer () {
                child = gridtheme
            };
            theme_rev.reveal_child = tdefault.active;
            tdefault.toggled.connect (()=> {
                theme_rev.reveal_child = tdefault.active;
            });
            theme_mode.notify ["id"].connect ((id)=> {
                theme_entry.sensitive = theme_mode.id == 1;
            });
            theme_entry.sensitive = theme_mode.id == 1;
            var allowrepl = new Gtk.CheckButton.with_label (_("Replace File")) {
                margin_top = 5,
                width_request = 610,
                active = bool.parse (pharse_options (pack_data, AriaOptions.ALLOW_OVERWRITE))
            };

            var autorename = new Gtk.CheckButton.with_label (_("Auto Rename")) {
                margin_top = 5,
                width_request = 610,
                active = bool.parse (pharse_options (pack_data, AriaOptions.AUTO_FILE_RENAMING))
            };

            var optimdw = new Gtk.CheckButton.with_label (_("Optimizes the number of concurrent downloads")) {
                margin_top = 5,
                width_request = 610,
                active = bool.parse (pharse_options (pack_data, AriaOptions.OPTIMIZE_CONCURRENT_DOWNLOADS)),
                tooltip_text = _("Optimizes the number of concurrent downloads according to the bandwidth available")
            };

            var style_mode = new ModeTogle ();
            style_mode.add_item (new ModeTogle.with_label (_("System Default")));
            style_mode.add_item (new ModeTogle.with_label (_("Light")));
            style_mode.add_item (new ModeTogle.with_label (_("Dark")));
            style_mode.id = int.parse (get_dbsetting (DBSettings.STYLE));

            var notifyopt = new Gtk.Grid () {
                margin_start = 2,
                margin_end = 2,
                height_request = 190
            };
            notifyopt.attach (headerlabel (_("Style:"), 500), 0, 0, 1, 1);
            notifyopt.attach (style_mode, 0, 1, 1, 1);
            notifyopt.attach (tdefault, 0, 2, 1, 1);
            notifyopt.attach (theme_rev, 0, 3, 1, 1);
            notifyopt.attach (headerlabel (_("Settings:"), 500), 0, 4, 1, 1);
            notifyopt.attach (retonhide, 0, 5, 1, 1);
            notifyopt.attach (appstartup, 0, 6, 1, 1);
            notifyopt.attach (appclipboard, 0, 7, 1, 1);
            notifyopt.attach (headerlabel (_("Dbus Settings:"), 500), 0, 8, 1, 1);
            notifyopt.attach (dbusmenu, 0, 9, 1, 1);
            notifyopt.attach (menuindicator, 0, 10, 1, 1);
            notifyopt.attach (label_rev, 0, 11, 1, 1);
            notifyopt.attach (headerlabel (_("Notify:"), 500), 0, 12, 1, 1);
            notifyopt.attach (systemnotif, 0, 13, 1, 1);
            notifyopt.attach (dialognotify, 0, 14, 1, 1);
            notifyopt.attach (soundnotif, 0, 15, 1, 1);
            notifyopt.attach (headerlabel (_("File Download:"), 500), 0, 16, 1, 1);
            notifyopt.attach (allowrepl, 0, 17, 1, 1);
            notifyopt.attach (autorename, 0, 18, 1, 1);
            notifyopt.attach (optimdw, 0, 19, 1, 1);
            label_mode.sensitive = dbusmenu.active && menuindicator.active;

            var notyscr = new Gtk.ScrolledWindow () {
                width_request = 614,
                vexpand = true,
                child = notifyopt
            };
            var stack = new Gtk.Stack () {
                transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT,
                transition_duration = 500,
                hhomogeneous = false
            };
            stack.add_child (settings);
            stack.add_child (bittorrent);
            stack.add_child (folderopt);
            stack.add_child (moreoptions);
            stack.add_child (notyscr);
            stack.visible_child = settings;
            stack.show ();

            var close_button = new Gtk.Button.with_label (_("Close"));
            ((Gtk.Label) close_button.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            close_button.clicked.connect (()=> {
                close ();
            });

            var save_button = new Gtk.Button.with_label (_("Save"));
            ((Gtk.Label) save_button.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            save_button.clicked.connect (()=> {
                set_dbsetting (DBSettings.ONBACKGROUND, retonhide.active.to_string ());
                set_dbsetting (DBSettings.CLIPBOARD, appclipboard.active.to_string ());
                set_dbsetting (DBSettings.MENUINDICATOR, menuindicator.active.to_string ());
                set_dbsetting (DBSettings.DIALOGNOTIF, dialognotify.active.to_string ());
                set_dbsetting (DBSettings.STARTUP, appstartup.active.to_string ());
                set_dbsetting (DBSettings.SHAREDIR, selectfs.get_path ());
                set_dbsetting (DBSettings.SWITCHDIR, sharebutton.active.to_string ());
                set_dbsetting (DBSettings.SYSTEMNOTIF, systemnotif.active.to_string ());
                set_dbsetting (DBSettings.DBUSMENU, dbusmenu.active.to_string ());
                set_dbsetting (DBSettings.NOTIFSOUND, soundnotif.active.to_string ());
                if (style_mode.id != int.parse (get_dbsetting (DBSettings.STYLE))
                || tdefault.active != bool.parse (get_dbsetting (DBSettings.TDEFAULT))
                || theme_mode.id.to_string () != get_dbsetting (DBSettings.THEMESELECT)
                || theme_entry.text != get_dbsetting (DBSettings.THEMECUSTOM)) {
                    set_dbsetting (DBSettings.STYLE, style_mode.id.to_string ());
                    set_dbsetting (DBSettings.TDEFAULT, tdefault.active.to_string ());
                    set_dbsetting (DBSettings.THEMESELECT, theme_mode.id.to_string ());
                    set_dbsetting (DBSettings.THEMECUSTOM, theme_entry.text);
                }
                gdm_theme.begin ();
                if (label_mode.id != int.parse (get_dbsetting (DBSettings.LABELMODE))) {
                    set_dbsetting (DBSettings.LABELMODE, label_mode.id.to_string ());
                }
                if (aria_get_ready ()) {
                    aria_set_globalops (AriaOptions.MAX_TRIES, set_dbsetting (DBSettings.MAXTRIES, numbtries.value.to_string ()));
                    aria_set_globalops (AriaOptions.MAX_CONNECTION_PER_SERVER, set_dbsetting (DBSettings.CONNSERVER, numbconn.value.to_string ()));
                    aria_set_globalops (AriaOptions.TIMEOUT, set_dbsetting (DBSettings.TIMEOUT, timeout.value.to_string ()));
                    aria_set_globalops (AriaOptions.RETRY_WAIT, set_dbsetting (DBSettings.RETRY, retry.value.to_string ()));
                    aria_set_globalops (AriaOptions.DIR, set_dbsetting (DBSettings.DIR, selectfd.get_path ().replace ("/", "\\/")));
                    aria_set_globalops (AriaOptions.BT_MAX_PEERS, set_dbsetting (DBSettings.BTMAXPEERS, maxpeers.value.to_string ()));
                    aria_set_globalops (AriaOptions.SPLIT, set_dbsetting (DBSettings.SPLIT, split.value.to_string ()));
                    aria_set_globalops (AriaOptions.BT_TRACKER_TIMEOUT, set_dbsetting (DBSettings.BTTIMEOUTTRACK, bt_timeout.value.to_string ()));
                    aria_set_globalops (AriaOptions.BT_MAX_OPEN_FILES, set_dbsetting (DBSettings.MAXOPENFILE, maxopfile.value.to_string ()));
                    aria_set_globalops (AriaOptions.SEED_TIME, set_dbsetting (DBSettings.SEEDTIME, bt_seedtime.value.to_string ()));
                    aria_set_globalops (AriaOptions.ALLOW_OVERWRITE, set_dbsetting (DBSettings.OVERWRITE, allowrepl.active.to_string ()));
                    aria_set_globalops (AriaOptions.AUTO_FILE_RENAMING, set_dbsetting (DBSettings.AUTORENAMING, autorename.active.to_string ()));
                    aria_set_globalops (AriaOptions.MAX_OVERALL_UPLOAD_LIMIT, set_dbsetting (DBSettings.UPLOADLIMIT, (bt_upload.value * 1024).to_string ()));
                    aria_set_globalops (AriaOptions.MAX_OVERALL_DOWNLOAD_LIMIT, set_dbsetting (DBSettings.DOWNLOADLIMIT, (bt_download.value * 1024).to_string ()));
                    aria_set_globalops (AriaOptions.BT_TRACKER, set_dbsetting (DBSettings.BTTRACKER, trackertext.buffer.text.replace ("/", "\\/")));
                    aria_set_globalops (AriaOptions.BT_EXCLUDE_TRACKER, set_dbsetting (DBSettings.BTTRACKEREXC, etrackertext.buffer.text.replace ("/", "\\/")));
                    aria_set_globalops (AriaOptions.MIN_SPLIT_SIZE, set_dbsetting (DBSettings.SPLITSIZE, (splitsize.value * 1024).to_string ()));
                    aria_set_globalops (AriaOptions.LOWEST_SPEED_LIMIT, set_dbsetting (DBSettings.LOWESTSPEED, (lowestspd.value * 1024).to_string ()));
                    aria_set_globalops (AriaOptions.URI_SELECTOR, set_dbsetting (DBSettings.URISELECTOR, uriselector.selector.to_string ().down ()));
                    aria_set_globalops (AriaOptions.STREAM_PIECE_SELECTOR, set_dbsetting (DBSettings.PIECESELECTOR, pieceselector.selector.to_string ().down ()));
                    aria_set_globalops (AriaOptions.OPTIMIZE_CONCURRENT_DOWNLOADS, set_dbsetting (DBSettings.OPTIMIZEDOW, optimdw.active.to_string ()));
                    set_dbsetting (DBSettings.RPCPORT, rpc_port.value.to_string ());
                    set_dbsetting (DBSettings.RPCSIZE, maxrequest.value.to_string ());
                    set_dbsetting (DBSettings.DISKCACHE, diskcache.value.to_string ());
                    set_dbsetting (DBSettings.BTLISTENPORT, bt_listenport.value.to_string ());
                    set_dbsetting (DBSettings.DHTLISTENPORT, dht_listenport.value.to_string ());
                    set_dbsetting (DBSettings.FILEALLOCATION, fileallocation.fileallocation.to_string ());
                    if (maxcurrent.value != double.parse (aria_get_globalops (AriaOptions.MAX_CONCURRENT_DOWNLOADS))) {
                        aria_set_globalops (AriaOptions.MAX_CONCURRENT_DOWNLOADS, set_dbsetting (DBSettings.MAXACTIVE, maxcurrent.value.to_string ()));
                        max_active ();
                    }
                    if (diskcache.value != double.parse (aria_get_globalops (AriaOptions.DISK_CACHE))
                    || maxrequest.value != double.parse (aria_get_globalops (AriaOptions.RPC_MAX_REQUEST_SIZE))
                    || rpc_port.value != double.parse (aria_get_globalops (AriaOptions.RPC_LISTEN_PORT))
                    || bt_listenport.value != double.parse (aria_get_globalops (AriaOptions.LISTEN_PORT))
                    || dht_listenport.value != double.parse (aria_get_globalops (AriaOptions.DHT_LISTEN_PORT))
                    || fileallocation.fileallocation.to_string ().down () != aria_get_globalops (AriaOptions.FILE_ALLOCATION)) {
                        aria_shutdown ();
                        do {
                        } while (aria_get_ready ());
                        exec_aria ();
                        restart_process ();
                        close ();
                    } else if (local_port.value.to_string () != get_dbsetting (DBSettings.PORTLOCAL)) {
                        set_dbsetting (DBSettings.PORTLOCAL, local_port.value.to_string ());
                        restart_server ();
                        close ();
                    } else {
                        global_opt ();
                        close ();
                    }
                }
            });

            var box_action = new Gtk.Grid () {
                width_request = 300,
                margin_top = 10,
                margin_bottom = 10,
                column_spacing = 10,
                column_homogeneous = true,
                halign = Gtk.Align.CENTER
            };
            box_action.attach (save_button, 0, 0);
            box_action.attach (close_button, 1, 0);

            var boxarea = get_content_area ();
            boxarea.margin_start = 10;
            boxarea.margin_end = 10;
            boxarea.halign = Gtk.Align.CENTER;
            boxarea.append (stack);
            boxarea.append (box_action);
            view_mode.notify["selected"].connect (() => {
                switch (view_mode.selected) {
                    case 1:
                        stack.visible_child = bittorrent;
                        break;
                    case 2:
                        stack.visible_child = folderopt;
                        break;
                    case 3:
                        stack.visible_child = moreoptions;
                        break;
                    case 4:
                        stack.visible_child = notyscr;
                        break;
                    default:
                        stack.visible_child = settings;
                        break;
                }
            });
        }
    }
}