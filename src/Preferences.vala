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

        public Preferences (Gtk.Application application) {
            Object (application: application,
                    resizable: false,
                    use_header_bar: 1
            );
        }

        construct {
            var view_mode = new ModeButton () {
                hexpand = false,
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
                width_request = 220,
                hexpand = true,
                value = double.parse (pharse_options (pack_data, AriaOptions.MAX_TRIES))
            };

            var numbconn = new Gtk.SpinButton.with_range (0, 16, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (pharse_options (pack_data, AriaOptions.MAX_CONNECTION_PER_SERVER))
            };

            var maxcurrent = new Gtk.SpinButton.with_range (1, 50, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (pharse_options (pack_data, AriaOptions.MAX_CONCURRENT_DOWNLOADS))
            };

            var timeout = new Gtk.SpinButton.with_range (0, 600, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (pharse_options (pack_data, AriaOptions.TIMEOUT))
            };

            var retry = new Gtk.SpinButton.with_range (0, 600, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (pharse_options (pack_data, AriaOptions.RETRY_WAIT))
            };

            var split = new Gtk.SpinButton.with_range (0, 6000, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (pharse_options (pack_data, AriaOptions.SPLIT))
            };

            var splitsize = new Gtk.SpinButton.with_range (0, 9999999, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (pharse_options (pack_data, AriaOptions.MIN_SPLIT_SIZE)) / 1024
            };

            var lowestspd = new Gtk.SpinButton.with_range (0, 9999999, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (pharse_options (pack_data, AriaOptions.LOWEST_SPEED_LIMIT)) / 1024
            };

            var stream_flow = new Gtk.FlowBox () {
                orientation = Gtk.Orientation.HORIZONTAL,
                width_request = 70
            };
            var stream_popover = new Gtk.Popover () {
                width_request = 70,
                child = stream_flow
            };
            stream_popover.show.connect (() => {
                if (pieceselector != null) {
                    stream_flow.select_child (pieceselector);
                    pieceselector.grab_focus ();
                }
            });
            piecesel_button = new Gtk.MenuButton () {
                direction = Gtk.ArrowType.UP,
                popover = stream_popover
            };
            foreach (var piecesel in PieceSelectors.get_all ()) {
                stream_flow.append (new PieceSelector (piecesel));
            }
            stream_flow.show ();
            stream_flow.child_activated.connect ((piecesel)=> {
                pieceselector = piecesel as PieceSelector;
                stream_popover.hide ();
            });
            for (int a = 0; a <= PieceSelectors.GEOM; a++) {
                var piecesel = stream_flow.get_child_at_index (a);
                if (((PieceSelector) piecesel).selector.to_string ().down () == pharse_options (pack_data, AriaOptions.STREAM_PIECE_SELECTOR)) {
                    pieceselector = piecesel as PieceSelector;
                }
            }

            var urisel_flow = new Gtk.FlowBox () {
                orientation = Gtk.Orientation.HORIZONTAL,
                width_request = 70
            };
            var urisel_popover = new Gtk.Popover () {
                width_request = 70,
                child = urisel_flow
            };
            urisel_popover.show.connect (() => {
                if (uriselector != null) {
                    urisel_flow.select_child (uriselector);
                    uriselector.grab_focus ();
                }
            });
            urisel_button = new Gtk.MenuButton () {
                direction = Gtk.ArrowType.UP,
                popover = urisel_popover
            };
            foreach (var urisel in UriSelectors.get_all ()) {
                urisel_flow.append (new UriSelector (urisel));
            }
            urisel_flow.show ();
            urisel_flow.child_activated.connect ((urisel)=> {
                uriselector = urisel as UriSelector;
                urisel_popover.hide ();
            });
            for (int a = 0; a <= UriSelectors.ADAPTIVE; a++) {
                var urisel = urisel_flow.get_child_at_index (a);
                if (((UriSelector) urisel).selector.to_string ().down () == pharse_options (pack_data, AriaOptions.URI_SELECTOR)) {
                    uriselector = urisel as UriSelector;
                }
            }

            var settings = new Gtk.Grid () {
                column_homogeneous = true,
                height_request = 150,
                margin_bottom = 5,
                column_spacing = 10,
                margin_start = 2,
                margin_end = 2,
                halign = Gtk.Align.START
            };
            settings.attach (headerlabel (_("Number of Tries:"), 220), 1, 0, 1, 1);
            settings.attach (numbtries, 1, 1, 1, 1);
            settings.attach (headerlabel (_("Connection:"), 220), 0, 0, 1, 1);
            settings.attach (numbconn, 0, 1, 1, 1);
            settings.attach (headerlabel (_("Active Download:"), 220), 1, 2, 1, 1);
            settings.attach (maxcurrent, 1, 3, 1, 1);
            settings.attach (headerlabel (_("Time out (in Secconds):"), 220), 0, 2, 1, 1);
            settings.attach (timeout, 0, 3, 1, 1);
            settings.attach (headerlabel (_("Retry Wait (in Secconds):"), 220), 1, 4, 1, 1);
            settings.attach (retry, 1, 5, 1, 1);
            settings.attach (headerlabel (_("Split:"), 220), 0, 4, 1, 1);
            settings.attach (split, 0, 5, 1, 1);
            settings.attach (headerlabel (_("Lowest Speed (in Kb):"), 220), 1, 6, 1, 1);
            settings.attach (lowestspd, 1, 7, 1, 1);
            settings.attach (headerlabel (_("Split Size (in Kb):"), 220), 0, 6, 1, 1);
            settings.attach (splitsize, 0, 7, 1, 1);
            settings.attach (headerlabel (_("Piece Selector:"), 220), 1, 8, 1, 1);
            settings.attach (piecesel_button, 1, 9, 1, 1);
            settings.attach (headerlabel (_("Uri Selector:"), 220), 0, 8, 1, 1);
            settings.attach (urisel_button, 0, 9, 1, 1);

            var maxopfile = new Gtk.SpinButton.with_range (0, 200, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (pharse_options (pack_data, AriaOptions.BT_MAX_OPEN_FILES))
            };

            var maxpeers = new Gtk.SpinButton.with_range (0, 200, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (pharse_options (pack_data, AriaOptions.BT_MAX_PEERS))
            };

            var bt_timeout = new Gtk.SpinButton.with_range (0, 240, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (pharse_options (pack_data, AriaOptions.BT_TRACKER_TIMEOUT))
            };

            var bt_seedtime = new Gtk.SpinButton.with_range (0, 240, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (pharse_options (pack_data, AriaOptions.SEED_TIME))
            };

            var bt_upload = new Gtk.SpinButton.with_range (0, 999999, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (pharse_options (pack_data, AriaOptions.MAX_OVERALL_UPLOAD_LIMIT)) / 1024
            };

            var bt_download = new Gtk.SpinButton.with_range (0, 999999, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (pharse_options (pack_data, AriaOptions.MAX_OVERALL_DOWNLOAD_LIMIT)) / 1024
            };
            var trackertext = new Gtk.TextView () {
                wrap_mode = Gtk.WrapMode.WORD_CHAR
            };
            trackertext.buffer.text = pharse_options (pack_data, AriaOptions.BT_TRACKER).replace ("\\/", "/");

            var trackerscr = new Gtk.ScrolledWindow () {
                width_request = 220,
                height_request = 100,
                child = trackertext
            };

            var load_tr = new Gtk.Button.from_icon_name ("document-open") {
                tooltip_text = _("Open Text Tracker")
            };
            load_tr.clicked.connect (() => {
                var file = run_open_text (this);
                if (file != null) {
                    try {
                        trackertext.buffer.text = (string) file.load_bytes ().get_data ();
                    } catch (Error e) {
                        GLib.warning (e.message);
                    }
                }
            });

            var fformat_tr = new Gtk.Button.from_icon_name ("view-refresh") {
                tooltip_text = _("Fix to Tracker")
            };
            fformat_tr.clicked.connect (() => {
                var formatclr = fixtoformat (trackertext.buffer.text);
                trackertext.buffer.text = formatclr;
            });

            var clear_tr = new Gtk.Button.from_icon_name ("edit-clear") {
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
                wrap_mode = Gtk.WrapMode.WORD_CHAR
            };
            etrackertext.buffer.text = pharse_options (pack_data, AriaOptions.BT_EXCLUDE_TRACKER).replace ("\\/", "/");

            var etrackerscr = new Gtk.ScrolledWindow () {
                width_request = 220,
                height_request = 100,
                child = etrackertext
            };

            var load_etr = new Gtk.Button.from_icon_name ("document-open") {
                tooltip_text = _("Open Text Tracker")
            };
            load_etr.clicked.connect (() => {
                var file = run_open_text (this);
                if (file != null) {
                    try {
                        etrackertext.buffer.text = (string) file.load_bytes ().get_data ();
                    } catch (Error e) {
                        GLib.warning (e.message);
                    }
                }
            });
            var fformat_etr = new Gtk.Button.from_icon_name ("view-refresh") {
                tooltip_text = _("Fix to Tracker")
            };
            fformat_etr.clicked.connect (() => {
                var formatclr = fixtoformat (etrackertext.buffer.text);
                etrackertext.buffer.text = formatclr;
            });
            var clear_etr = new Gtk.Button.from_icon_name ("edit-clear") {
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
            bittorrent.attach (headerlabel (_("Max Open File:"), 220), 1, 0, 1, 1);
            bittorrent.attach (maxopfile, 1, 1, 1, 1);
            bittorrent.attach (headerlabel (_("Bittorent Max Peers:"), 220), 0, 0, 1, 1);
            bittorrent.attach (maxpeers, 0, 1, 1, 1);
            bittorrent.attach (headerlabel (_("Tracker Time out (in Secconds):"), 220), 1, 2, 1, 1);
            bittorrent.attach (bt_timeout, 1, 3, 1, 1);
            bittorrent.attach (headerlabel (_("Seed Time (in Minutes):"), 220), 0, 2, 1, 1);
            bittorrent.attach (bt_seedtime, 0, 3, 1, 1);
            bittorrent.attach (headerlabel (_("Upload Limit (in Kb):"), 220), 1, 4, 1, 1);
            bittorrent.attach (bt_upload, 1, 5, 1, 1);
            bittorrent.attach (headerlabel (_("Download Limit (in Kb):"), 220), 0, 4, 1, 1);
            bittorrent.attach (bt_download, 0, 5, 1, 1);
            bittorrent.attach (headerlabel (_("BitTorrent Tracker Exclude:"), 220), 1, 6, 1, 1);
            bittorrent.attach (layout_etrack, 1, 7, 1, 1);
            bittorrent.attach (headerlabel (_("BitTorrent Tracker:"), 220), 0, 6, 1, 1);
            bittorrent.attach (layout_track, 0, 7, 1, 1);

            folder_location = new Gtk.Button ();
            folder_location.clicked.connect (()=> {
                var file = run_open_fd (this, selectfd);
                if (file != null) {
                    selectfd = file;
                }
            });
            selectfd = File.new_for_path (pharse_options (pack_data, AriaOptions.DIR).replace ("\\/", "/"));

            folder_sharing = new Gtk.Button ();
            folder_sharing.clicked.connect (()=> {
                var file = run_open_fd (this, selectfs);
                if (file != null) {
                    selectfs = file;
                }
            });
            selectfs = File.new_for_path (get_dbsetting (DBSettings.SHAREDIR));

            var add_auth = new Gtk.Button.from_icon_name ("list-add") {
                tooltip_text = _("Add Authenty")
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
                width_request = 455,
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
            folderopt.attach (headerlabel (_("Save to Folder:"), 450), 1, 0, 1, 1);
            folderopt.attach (folder_location, 1, 1, 1, 1);
            folderopt.attach (sharebutton, 1, 2, 1, 1);
            folderopt.attach (folder_sharing, 1, 3, 1, 1);
            folderopt.attach (headerlabel (_("Authentication:"), 450), 1, 4, 1, 1);
            folderopt.attach (userscr, 1, 5, 1, 1);

            var rpc_port = new Gtk.SpinButton.with_range (0, 9999, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (pharse_options (pack_data, AriaOptions.RPC_LISTEN_PORT))
            };

            var local_port = new Gtk.SpinButton.with_range (0, 9999, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (get_dbsetting (DBSettings.PORTLOCAL))
            };

            var bt_listenport = new Gtk.SpinButton.with_range (0, 99999, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (pharse_options (pack_data, AriaOptions.LISTEN_PORT))
            };

            var dht_listenport = new Gtk.SpinButton.with_range (0, 99999, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (pharse_options (pack_data, AriaOptions.DHT_LISTEN_PORT))
            };

            var maxrequest = new Gtk.SpinButton.with_range (0, 9000000000, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (pharse_options (pack_data, AriaOptions.RPC_MAX_REQUEST_SIZE))
            };

            var diskcache = new Gtk.SpinButton.with_range (0, 9000000000, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (pharse_options (pack_data, AriaOptions.DISK_CACHE))
            };

            var allocate_flow = new Gtk.FlowBox () {
                orientation = Gtk.Orientation.HORIZONTAL,
                width_request = 70
            };
            var allocate_popover = new Gtk.Popover () {
                position = Gtk.PositionType.TOP,
                width_request = 70,
                child = allocate_flow
            };
            allocate_popover.show.connect (() => {
                if (fileallocation != null) {
                    allocate_flow.select_child (fileallocation);
                    fileallocation.grab_focus ();
                }
            });
            allocate_button = new Gtk.MenuButton () {
                popover = allocate_popover
            };
            foreach (var allocate in FileAllocations.get_all ()) {
                allocate_flow.append (new FileAllocation (allocate));
            }
            allocate_flow.show ();
            allocate_flow.child_activated.connect ((allocate)=> {
                fileallocation = allocate as FileAllocation;
                allocate_popover.hide ();
            });
            for (int a = 0; a <= FileAllocations.FALLOC; a++) {
                var allocate = allocate_flow.get_child_at_index (a);
                if (((FileAllocation) allocate).fileallocation.to_string ().down () == pharse_options (pack_data, AriaOptions.FILE_ALLOCATION)) {
                    fileallocation = allocate as FileAllocation;
                }
            }

            var moreoptions = new Gtk.Grid () {
                column_homogeneous = true,
                height_request = 150,
                margin_bottom = 5,
                column_spacing = 10,
                margin_start = 2,
                margin_end = 2,
                halign = Gtk.Align.START
            };
            moreoptions.attach (headerlabel (_("RPC Port:"), 220), 0, 0, 1, 1);
            moreoptions.attach (rpc_port, 0, 1, 1, 1);
            moreoptions.attach (headerlabel (_("Local Port:"), 220), 0, 2, 1, 1);
            moreoptions.attach (local_port, 0, 3, 1, 1);
            moreoptions.attach (headerlabel (_("BT Listen Port:"), 220), 0, 4, 1, 1);
            moreoptions.attach (bt_listenport, 0, 5, 1, 1);
            moreoptions.attach (headerlabel (_("DHT Listen Port:"), 220), 0, 6, 1, 1);
            moreoptions.attach (dht_listenport, 0, 7, 1, 1);
            moreoptions.attach (headerlabel (_("RPC Max Request Size (in Byte):"), 220), 1, 0, 1, 1);
            moreoptions.attach (maxrequest, 1, 1, 1, 1);
            moreoptions.attach (headerlabel (_("Disk Cache (in Byte):"), 220), 1, 2, 1, 1);
            moreoptions.attach (diskcache, 1, 3, 1, 1);
            moreoptions.attach (headerlabel (_("File Allocation:"), 220), 1, 4, 1, 1);
            moreoptions.attach (allocate_button, 1, 5, 1, 1);

            var dialognotify = new Gtk.CheckButton.with_label (_("Open dialog succes when download complete")) {
                margin_top = 5,
                width_request = 450,
                active = bool.parse (get_dbsetting (DBSettings.DIALOGNOTIF))
            };

            var systemnotif = new Gtk.CheckButton.with_label (_("Send notification system")) {
                margin_top = 5,
                width_request = 450,
                active = bool.parse (get_dbsetting (DBSettings.SYSTEMNOTIF))
            };

            var retonhide = new Gtk.CheckButton.with_label (_("Running on background")) {
                margin_top = 5,
                width_request = 450,
                active = bool.parse (get_dbsetting (DBSettings.ONBACKGROUND))
            };

            var appstartup = new Gtk.CheckButton.with_label (_("Launch App on Startup")) {
                margin_top = 5,
                width_request = 450,
                active = bool.parse (get_dbsetting (DBSettings.STARTUP))
            };

            var appclipboard = new Gtk.CheckButton.with_label (_("Add Url From Clipboard")) {
                margin_top = 5,
                width_request = 450,
                active = bool.parse (get_dbsetting (DBSettings.CLIPBOARD))
            };

            var dbusmenu = new Gtk.CheckButton.with_label (_("Dbus Menu")) {
                margin_top = 5,
                width_request = 450,
                active = bool.parse (get_dbsetting (DBSettings.DBUSMENU))
            };

            var allowrepl = new Gtk.CheckButton.with_label (_("Replace File")) {
                margin_top = 5,
                width_request = 450,
                active = bool.parse (pharse_options (pack_data, AriaOptions.ALLOW_OVERWRITE))
            };

            var autorename = new Gtk.CheckButton.with_label (_("Auto Rename")) {
                margin_top = 5,
                width_request = 450,
                active = bool.parse (pharse_options (pack_data, AriaOptions.AUTO_FILE_RENAMING))
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
            notifyopt.attach (headerlabel (_("Style:"), 450), 0, 0, 1, 1);
            notifyopt.attach (style_mode.get_box (), 0, 1, 1, 1);
            notifyopt.attach (headerlabel (_("Settings:"), 450), 0, 2, 1, 1);
            notifyopt.attach (retonhide, 0, 3, 1, 1);
            notifyopt.attach (appstartup, 0, 4, 1, 1);
            notifyopt.attach (appclipboard, 0, 5, 1, 1);
            notifyopt.attach (dbusmenu, 0, 6, 1, 1);
            notifyopt.attach (headerlabel (_("Notify:"), 450), 0, 7, 1, 1);
            notifyopt.attach (systemnotif, 0, 8, 1, 1);
            notifyopt.attach (dialognotify, 0, 9, 1, 1);
            notifyopt.attach (headerlabel (_("File Download:"), 450), 0, 10, 1, 1);
            notifyopt.attach (allowrepl, 0, 11, 1, 1);
            notifyopt.attach (autorename, 0, 12, 1, 1);

            var notyscr = new Gtk.ScrolledWindow () {
                width_request = 455,
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
                set_dbsetting (DBSettings.DIALOGNOTIF, dialognotify.active.to_string ());
                set_dbsetting (DBSettings.STARTUP, appstartup.active.to_string ());
                set_dbsetting (DBSettings.SHAREDIR, selectfs.get_path ());
                set_dbsetting (DBSettings.SWITCHDIR, sharebutton.active.to_string ());
                set_dbsetting (DBSettings.SYSTEMNOTIF, systemnotif.active.to_string ());
                set_dbsetting (DBSettings.DBUSMENU, dbusmenu.active.to_string ());
                if (style_mode.id != int.parse (get_dbsetting (DBSettings.STYLE))) {
                    set_dbsetting (DBSettings.STYLE, style_mode.id.to_string ());
                    pantheon_theme.begin (get_display ());
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
                width_request = 250,
                margin_top = 10,
                margin_bottom = 10,
                column_spacing = 10,
                column_homogeneous = true,
                halign = Gtk.Align.CENTER,
                orientation = Gtk.Orientation.HORIZONTAL
            };
            box_action.attach (save_button, 0, 0);
            box_action.attach (close_button, 1, 0);

            var maingrid = new Gtk.Grid () {
                orientation = Gtk.Orientation.VERTICAL,
                halign = Gtk.Align.CENTER,
                margin_start = 10,
                margin_end = 10
            };
            maingrid.attach (stack, 0, 0);
            maingrid.attach (box_action, 0, 1);

            child = maingrid;
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
