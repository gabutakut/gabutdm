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
    public class DownloadRow : Gtk.ListBoxRow {
        public signal void update_agid (string ariagid, string newgid);
        public signal void update_url (Gee.HashMap<string, string> hashoption, string filname, string urln);
        public signal void downloader_hls ();
        public Gtk.Button start_button;
        public Gtk.Button openimage;
        public Gtk.Image imagefile;
        public Gtk.Image badge_img;
        private BitfieldWidget bitfield_widget;
        public DBusMenu.DbusmenuItem rowbus;
        public Gee.HashMap<string, string> hashoption = new Gee.HashMap<string, string> ();
        private bool stoptimer;
        private uint timeout_id = 0;

        private int _linkmode;
        public int linkmode {
            get {
                return _linkmode;
            }
            set {
                _linkmode = value;
                imagefile.gicon = new ThemedIcon ("com.github.gabutakut.gabutdm.progress");
                if (linkmode == LinkMode.METALINK) {
                    badge_img.gicon = new ThemedIcon ("com.github.gabutakut.gabutdm.metalink");
                } else if (linkmode == LinkMode.MAGNETLINK) {
                    badge_img.gicon = new ThemedIcon ("com.github.gabutakut.gabutdm.magnet");
                } else if (linkmode == LinkMode.TORRENT) {
                    badge_img.gicon = new ThemedIcon ("com.github.gabutakut.gabutdm.torrent");
                } else if (linkmode == LinkMode.HLS) {
                    badge_img.gicon = new ThemedIcon ("applications-multimedia");
                } else {
                    badge_img.gicon = new ThemedIcon ("com.github.gabutakut.gabutdm.insertlink");
                }
            }
        }

        private string _fileordir;
        public string fileordir {
            get {
                return _fileordir;
            }
            set {
                _fileordir = value;
                if (value != null && value != "") {
                    imagefile.gicon = GLib.ContentType.get_icon (value);
                    var genricico = GLib.ContentType.get_generic_icon_name (value);
                    if (genricico != null) {
                        rowbus.property_set (MenuItem.ICON_NAME.to_string (), genricico);
                    }
                }
            }
        }

        private string _url;
        public string url {
            get {
                return _url;
            }
            set {
                _url = value;
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
                        start_button.icon_name = "com.github.gabutakut.gabutdm.pause";
                        start_button.tooltip_text = _("Paused\nCTRL + V");
                        if (linkmode != LinkMode.HLS) {
                            remove_timeout ();
                            labeltransfer = @"$(GLib.format_size (transferred)) of $(GLib.format_size (totalsize))";
                            if (url != null && db_download_exist (url)) {
                                update_download (this);
                            }
                        }
                        break;
                    case StatusMode.COMPLETE:
                        if (ariagid != null || linkmode == LinkMode.HLS) {
                            start_button.icon_name = "com.github.gabutakut.gabutdm.complete";
                            start_button.tooltip_text = _("Complete\nCTRL + V");
                        }
                        if (linkmode != LinkMode.MAGNETLINK) {
                            if (filename != null) {
                                GLib.Application.get_default ().lookup_action ("destroy").activate (new Variant.string (ariagid));
                                notify_app (_("Download Complete"), filename, imagefile.gicon);
                                play_sound ("complete");
                                if (bool.parse (get_dbsetting (DBSettings.DIALOGNOTIF))) {
                                    if (pathname != null && pathname != "" && fileordir != "" && fileordir != null) {
                                        send_dialog ();
                                    }
                                }
                            }
                        } else {
                            bool foundgid = false;
                            aria_tell_active ().foreach ((strgid)=> {
                                if (ariagid == aria_tell_status (strgid, TellStatus.FOLLOWING)) {
                                    status = status_aria (aria_tell_status (strgid, TellStatus.STATUS));
                                    filename = aria_tell_bittorent (strgid, TellBittorrent.NAME);
                                    var dir_dm = "";
                                    if (hashoption.has_key (AriaOptions.DIR.to_string ())) {
                                        dir_dm = hashoption.@get (AriaOptions.DIR.to_string ());
                                    } else {
                                        dir_dm = Environment.get_user_special_dir (GLib.UserDirectory.DOWNLOAD);
                                    }
                                    try {
                                        uint8[] contents;
                                        GLib.FileUtils.get_data(GLib.File.new_build_filename (dir_dm, aria_tell_status (strgid, TellStatus.INFOHASH) + ".torrent").get_path (), out contents);
                                        remove_download (url);
                                        remove_dboptions (url);
                                        url = GLib.Base64.encode (contents);
                                        aria_remove (strgid);
                                        var ariagd = aria_torrent (url, hashoption, actwaiting ());
                                        update_agid (ariagid, ariagd);
                                        linkmode = LinkMode.TORRENT;
                                        foundgid = true;
                                        ariagid = ariagd;
                                    } catch (Error e) {
                                        warning (e.message);
                                    } finally {
                                        add_db_download (this);
                                        set_dboptions (url, hashoption);
                                    }
                                }
                                return true;
                            });
                            if (foundgid) {
                                break;
                            }
                        }
                        remove_timeout ();
                        if (url != null && db_download_exist (url)) {
                            update_download (this);
                        }
                        break;
                    case StatusMode.WAIT:
                        start_button.icon_name = "com.github.gabutakut.gabutdm.waiting";
                        start_button.tooltip_text = _("Waiting\nCTRL + V");
                        if (linkmode != LinkMode.HLS) {
                            remove_timeout ();
                            labeltransfer = @"$(GLib.format_size (transferred)) of $(GLib.format_size (totalsize))";
                        }
                        if (url != null && db_download_exist (url)) {
                            update_download (this);
                        }
                        break;
                    case StatusMode.ERROR:
                        start_button.icon_name = "com.github.gabutakut.gabutdm.error";
                        start_button.tooltip_text = _("Error\nCTRL + V");
                        if (linkmode != LinkMode.HLS) {
                            if (ariagid != null && url != null) {
                                errorcode = get_aria_error (int.parse (aria_tell_status (ariagid, TellStatus.ERRORCODE)));
                                labeltransfer = _("-");
                                if (filename != null) {
                                    notify_app (_("Download Error"), filename, imagefile.gicon);
                                    play_sound ("dialog-error");
                                }
                                aria_remove (ariagid);
                            }
                            remove_timeout ();
                        }
                        if (url != null && db_download_exist (url)) {
                            update_download (this);
                        }
                        break;
                    case StatusMode.SEED:
                        start_button.icon_name = "com.github.gabutakut.gabutdm.seed";
                        start_button.tooltip_text = _("Seeding\nCTRL + V");
                        if (linkmode != LinkMode.HLS) {
                            add_timeout ();
                        }
                        break;
                    case StatusMode.VERIFY:
                        start_button.icon_name = "com.github.gabutakut.gabutdm.verify";
                        start_button.tooltip_text = _("Verify");
                        break;
                    case StatusMode.MERGE:
                        start_button.icon_name = "applications-multimedia";
                        start_button.tooltip_text = _("Merge\nCTRL + V");
                        break;
                    default:
                        start_button.icon_name = "com.github.gabutakut.gabutdm.active";
                        start_button.tooltip_text = _("Downloading\nCTRL + V");
                        if (linkmode != LinkMode.HLS) {
                            add_timeout ();
                        }
                        break;
                }
            }
        }

        private string _errorcode;
        public string errorcode {
            get {
                return _errorcode;
            }
            set {
                _errorcode = value;
                bitfield_widget.errorcode = errorcode;
                if (linkmode != LinkMode.HLS) {
                    bitfield_widget.status = status;
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

        private string _filepath;
        public string filepath {
            get {
                return _filepath;
            }
            set {
                _filepath = value;
                if (linkmode == LinkMode.HLS) {
                    return;
                }
                if (filepath != null && filepath != "") {
                    var file = File.new_for_path (filepath);
                    if (linkmode == LinkMode.URL) {
                        if (_filepath != null) {
                            filename = file.get_basename ();
                            pathname = file.get_path ();
                        }
                    } else if (linkmode == LinkMode.MAGNETLINK) {
                        filename = filepath;
                    } else {
                        filename = aria_tell_bittorent (ariagid, TellBittorrent.NAME);
                        if (filename == file.get_basename ()) {
                            pathname = file.get_path ();
                        } else {
                            if (filename != "") {
                                pathname = GLib.File.new_build_filename (file.get_path ().split (filename)[0], filename).get_path ();
                            }
                        }
                    }
                }
            }
        }

        private string _pathname;
        public string pathname {
            get {
                return _pathname;
            }
            set {
                _pathname = value;
                fileordir = get_mime_type (GLib.File.new_for_path (value));
            }
        }

        private string _filename;
        public string filename {
            get {
                return _filename;
            }
            set {
                _filename = value;
                bitfield_widget.filename = _filename != null? _filename : url;
                rowbus.property_set (MenuItem.LABEL.to_string (), _filename != null? _filename : url);
                if (fileordir == null) {
                    fileordir = GLib.ContentType.guess(filename, null, null);
                }
            }
        }

        private int _transferrate;
        public int transferrate {
            get {
                return _transferrate;
            }
            set {
                _transferrate = value;
            }
        }

        private int _uprate;
        public int uprate {
            get {
                return _uprate;
            }
            set {
                _uprate = value;
            }
        }

        private int64 _totalsize;
        public int64 totalsize {
            get {
                return _totalsize;
            }
            set {
                _totalsize = value.abs ();
            }
        }

        private int64 _transferred;
        public int64 transferred {
            get {
                return _transferred;
            }
            set {
                _transferred = value.abs ();
            }
        }

        private string _labeltransfer;
        public string labeltransfer {
            get {
                return _labeltransfer;
            }
            set {
                _labeltransfer = value;
                bitfield_widget.labeltransfer = _labeltransfer;
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

        private int64 _timeadded;
        public int64 timeadded {
            get {
                return _timeadded;
            }
            set {
                _timeadded = value;
            }
        }

        private string _bitfield;
        public string bitfield {
            get {
                return _bitfield;
            }
            set {
                _bitfield = value;
                bitfield_widget.set_bitfield_data(bitfield, piececount);
            }
        }

        private int _piececount;
        public int piececount {
            get {
                return _piececount;
            }
            set {
                _piececount = value;
                if (bitfield != null) {
                    bitfield_widget.set_bitfield_data(bitfield, piececount);
                }           
            }
        }

        private string _connectionsdl;
        public string connectionsdl {
            get {
                return _connectionsdl;
            }
            set {
                _connectionsdl = value;
                bitfield_widget.connectionsdl = _connectionsdl;
                bitfield_widget.queue_draw ();
            }
        }

        private double _fraction = 0.0;
        public double fraction {
            get {
                return _fraction;
            }
            set {
                _fraction = value;       
            }
        }

        public DownloadRow.Hls (string url, Gee.HashMap<string, string> options, int linkmode) {
            this.hashoption = options;
            this.linkmode = linkmode;
            this.url = url;
            errorcode = _("HLS waiting data...");
            bitfield_widget.set_bitfield_data("", 0);
            bitfield_widget.connectionsdl= "0";
            labeltransfer = "-";
            ariagid = "";
            add_db_download (this);
            set_dboptions (url, hashoption);
        }

        public DownloadRow.Smt (Sqlite.Statement stmt) {
            linkmode = stmt.column_int (DBDownload.LINKMODE);
            ariagid = stmt.column_text (DBDownload.ARIAGID);
            status = stmt.column_int (DBDownload.STATUS);
            transferrate = stmt.column_int (DBDownload.TRANSFERRATE);
            totalsize = stmt.column_int64 (DBDownload.TOTALSIZE);
            transferred = stmt.column_int64 (DBDownload.TRANSFERRED);
            fileordir = stmt.column_text (DBDownload.FILEORDIR);
            filepath = stmt.column_text (DBDownload.FILEPATH);
            url = stmt.column_text (DBDownload.URL);
            filename = stmt.column_text (DBDownload.FILENAME);
            labeltransfer = stmt.column_text (DBDownload.LABELTRANSFER);
            timeadded = stmt.column_int64 (DBDownload.TIMEADDED);
            bitfield = stmt.column_text (DBDownload.BITFIELD);
            piececount = stmt.column_int (DBDownload.PIECECOUNT);
            bitfield_widget.set_bitfield_data(bitfield, piececount);
            bitfield_widget.connectionsdl= "0";
            errorcode = stmt.column_text (DBDownload.ERRORCODE);
            hashoption = get_dboptions (url);
            selectedtr = hashoption.@get (AriaOptions.SELECT_FILE.to_string ());
            if (linkmode != LinkMode.HLS) {
                if_not_exist (ariagid, linkmode, status);
            }
        }

        public DownloadRow.Url (string url, Gee.HashMap<string, string> options, int linkmode) {
            this.hashoption = options;
            this.linkmode = linkmode;
            if (linkmode == LinkMode.TORRENT) {
                ariagid = aria_torrent (url, hashoption, actwaiting ());
            } else if (linkmode == LinkMode.METALINK) {
                ariagid = aria_metalink (url, hashoption, actwaiting ());
            } else {
                ariagid = aria_url (url, hashoption, actwaiting ());
            }
            this.url = url;
            errorcode = _("Waiting download data...");
            if (options.has_key (AriaOptions.SELECT_FILE.to_string ())) {
                selectedtr = options.@get (AriaOptions.SELECT_FILE.to_string ());
            }
            add_db_download (this);
            set_dboptions (url, hashoption);
        }

        construct {
            bitfield_widget = new BitfieldWidget(true, 3) {
                valign = Gtk.Align.CENTER
            };
            rowbus = new DBusMenu.DbusmenuItem ();
            rowbus.item_activated.connect (download);
            imagefile = new Gtk.Image () {
                pixel_size = 38
            };

            badge_img = new Gtk.Image () {
                halign = Gtk.Align.END,
                valign = Gtk.Align.END,
                pixel_size = 18
            };

            var overlay = new Gtk.Overlay () {
                child = imagefile
            };
            overlay.add_overlay (badge_img);

            openimage = new Gtk.Button () {
                valign = Gtk.Align.CENTER,
                focus_on_click = false,
                has_frame = false,
                child = overlay,
                height_request = 60,
                tooltip_text = _("Progress\nCTRL + W")
            };
            openimage.clicked.connect (download);

            start_button = new Gtk.Button.from_icon_name ("com.github.gabutakut.gabutdm.pause") {
                valign = Gtk.Align.CENTER,
                has_frame = false,
                height_request = 60
            };
            ((Gtk.Image) start_button.get_first_child ()).pixel_size = 18;
            start_button.clicked.connect (()=> {
                action_btn ();
            });
            var grid = new Gtk.Grid () {
                hexpand = true,
                valign = Gtk.Align.CENTER,
                margin_end = 2
            };
            grid.attach (openimage, 0, 0, 1, 4);
            grid.attach (bitfield_widget, 1, 0, 1, 1);
            grid.attach (start_button, 6, 0, 1, 4);
            child = grid;
        }

        public string action_btn (int stats = 2) {
            if (stats != StatusMode.NOTHING && status == StatusMode.COMPLETE) {
                send_dialog ();
                return ariagid;
            }
            if (linkmode == LinkMode.HLS) {
                return ariagid;
            }
            action_dowload ();
            return ariagid;
        }

        public void if_not_exist (string ariag, int linkm, int stats) {
            if (stats == StatusMode.COMPLETE || stats == StatusMode.ERROR) {
                return;
            }
            if (status_aria (aria_tell_status (ariag, TellStatus.STATUS)) == StatusMode.NOTHING) {
                load_agid ();
            }
            if (stats == StatusMode.PAUSED) {
                aria_pause (ariagid);
            }
        }

        private void action_dowload () {
            update_sts ();
            if (status == StatusMode.ACTIVE) {
                var statusar = aria_pause (ariagid);
                if (statusar == "") {
                    load_agid ();
                }
                remove_timeout ();
            } else if (status == StatusMode.PAUSED) {
                aria_position (ariagid, actwaiting ());
                var statusup = aria_unpause (ariagid);
                if (statusup == "") {
                    load_agid ();
                }
            } else if (status == StatusMode.COMPLETE) {
                remove_timeout ();
            } else if (status == StatusMode.SEED) {
                aria_pause (ariagid);
            } else if (status == StatusMode.WAIT) {
                aria_pause (ariagid);
            } else {
                load_agid ();
            }
            update_sts ();
        }

        private void load_agid () {
            if (linkmode == LinkMode.TORRENT) {
                ariagid = aria_torrent (url, hashoption, actwaiting ());
            } else if (linkmode == LinkMode.METALINK) {
                ariagid = aria_metalink (url, hashoption, actwaiting ());
            } else if (linkmode == LinkMode.URL) {
                ariagid = aria_url (url, hashoption, actwaiting ());
            } else if (linkmode == LinkMode.MAGNETLINK) {
                ariagid = aria_url (url, hashoption, actwaiting ());
            }
        }

        public string set_selected (string selected) {
            if (selected != "") {
                hashoption[AriaOptions.SELECT_FILE.to_string ()] = selectedtr = selected;
                if (linkmode == LinkMode.TORRENT) {
                    aria_unpause (ariagid);
                    aria_remove (ariagid);
                    if (url.has_prefix ("magnet:?")) {
                        linkmode = LinkMode.MAGNETLINK;
                        this.ariagid = aria_url (url, hashoption, actwaiting ());
                    } else {
                        this.ariagid = aria_torrent (url, hashoption, actwaiting ());
                    }
                } else if (linkmode == LinkMode.METALINK) {
                    aria_unpause (ariagid);
                    aria_remove (ariagid);
                    this.ariagid = aria_metalink (url, hashoption, actwaiting ());
                }
                if (!db_option_exist (url)) {
                    set_dboptions (url, hashoption);
                } else {
                    update_optionts (url, hashoption);
                }
            }
            update_sts ();
            return ariagid;
        }

        public void update_sts () {
            status = status_aria (aria_tell_status (ariagid, TellStatus.STATUS));
        }

        public void remove_down () {
            remove_timeout ();
            if (ariagid != "") {
                new Thread<void> ("Rm-%s".printf (get_monotonic_time ().to_string ()), () => {
                    aria_remove (ariagid);
                    aria_deleteresult (ariagid);
                });
                GLib.Application.get_default ().lookup_action ("destroy").activate (new Variant.string (ariagid));
            }
            remove_download (url);
            remove_dboptions (url);
            destroy ();
        }

        public void download () {
            if (linkmode == LinkMode.HLS) {
                downloader_hls ();
            } else {
                if (ariagid != "") {
                    GLib.Application.get_default ().lookup_action ("downloader").activate (new Variant.string (ariagid));
                }
            }
        }

        private void add_timeout () {
            if (timeout_id == 0) {
                stoptimer = GLib.Source.CONTINUE;
                timeout_id = GLib.Timeout.add (1000, update_progress, GLib.Priority.HIGH);
            }
        }

        private void remove_timeout () {
            if (timeout_id != 0) {
                Source.remove (timeout_id);
                timeout_id = 0;
            }
            stoptimer = GLib.Source.REMOVE;
        }

        public bool update_progress () {
            var pack_data = aria_v2_status (ariagid);
            filepath = pharse_files (pack_data, AriaGetfiles.PATH);
            status = status_aria (aria_tell_status (ariagid, TellStatus.STATUS));
            totalsize = int64.parse (pharse_tells (pack_data, TellStatus.TOTALLENGTH));
            transferred = int64.parse (pharse_tells (pack_data, TellStatus.COMPELETEDLENGTH));
            transferrate = int.parse (pharse_tells (pack_data, TellStatus.DOWNLOADSPEED));
            uprate = int.parse (pharse_tells (pack_data, TellStatus.UPLOADSPEED));
            bitfield = aria_tell_status (ariagid, TellStatus.BITFIELD);
            piececount = int.parse (pharse_tells (pack_data, TellStatus.NUMPIECES));
            connectionsdl = pharse_tells (pack_data, TellStatus.CONNECTIONS);
            string duprate = uprate > 0? @"- U: $(GLib.format_size ((uint64) uprate))" : "";
            string downrate = transferrate > 0? @"- D: $(GLib.format_size ((uint64) transferrate))" : "";
            string timedownload = "";
            if (totalsize > 0 && transferrate > 0) {
                uint64 remaining_time = (totalsize - transferred) / transferrate;
                timedownload = @"- $(format_time ((int) remaining_time))";
            } else {
                timedownload = "";
            }
            if (status != StatusMode.ERROR) {
                if (status != StatusMode.ACTIVE) {
                    labeltransfer = @"$(GLib.format_size (transferred)) of $(GLib.format_size (totalsize))";
                } else {
                    labeltransfer = @"$(GLib.format_size (transferred)) of $(GLib.format_size (totalsize)) $(duprate) $(downrate) $(timedownload)";
                }
            }
            return stoptimer;
        }

        public int status_aria (string input) {
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
                    if (linkmode != LinkMode.URL && ariagid != null) {
                        if (bool.parse (aria_tell_status (ariagid, TellStatus.SEEDER))) {
                            return StatusMode.SEED;
                        } else {
                            return StatusMode.ACTIVE;
                        }
                    } else {
                        return StatusMode.ACTIVE;
                    }
            }
        }

        private void send_dialog () {
            var gabutinfo = new GabutSucces ();
            if (linkmode == LinkMode.TORRENT) {
                if (url.has_prefix ("magnet:?")) {
                    gabutinfo.set_info (url, InfoSucces.ADDRESS);
                } else {
                    gabutinfo.set_info (filename, InfoSucces.ADDRESS);
                }
            } else if (linkmode == LinkMode.METALINK) {
                gabutinfo.set_info (filename, InfoSucces.ADDRESS);
            } else {
                gabutinfo.set_info (url, InfoSucces.ADDRESS);
            }
            gabutinfo.set_info (pathname, InfoSucces.FILEPATH);
            gabutinfo.set_info (totalsize.to_string (), InfoSucces.FILESIZE);
            gabutinfo.set_info (fileordir, InfoSucces.ICONNAME);
            GLib.Application.get_default ().lookup_action ("succes").activate (new Variant.string (gabutinfo.get_info ()));
        }

        public void to_trash () {
            if (pathname == null && linkmode == LinkMode.TORRENT) {
                var file = File.new_for_path (filepath);
                pathname = GLib.File.new_build_filename (file.get_path ().split (filename)[0], filename).get_path ();
            }
            remove_down ();
            if (pathname != null) {
                try {
                    var filec = File.new_for_path (@"$(pathname).aria2");
                    if (filec.query_exists ()) {
                        filec.trash ();
                    }
                    var filep = File.new_for_path (pathname);
                    if (filep.query_exists ()) {
                        filep.trash ();
                    }
                } catch (Error e) {
                    GLib.warning (e.message);
                }
            }
        }

        public void open_filesr () {
            if (pathname != null) {
                var file = File.new_for_path (pathname);
                if (file.query_exists ()) {
                    if (fileordir == "inode/directory") {
                        open_fileman.begin (file.get_uri ());
                    } else {
                        open_fileman.begin (file.get_parent ().get_uri ());
                    }
                }
            }
        }
    }
}