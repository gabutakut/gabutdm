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
    public class DownloadRow : Gtk.ListBoxRow {
        public signal int activedm ();
        public signal void update_agid (string ariagid, string newgid);
        public signal void gsmproperties ();
        private Gtk.Button start_button;
        private Gtk.Label transfer_rate;
        private Gtk.ProgressBar progressbar;
        private Gtk.Label filename_label;
        public Gtk.Image imagefile;
        public Gtk.Image badge_img;
        public DbusmenuItem rowbus;
        private bool stoptimer;
        private uint timeout_id = 0;
        public Gee.HashMap<string, string> hashoption = new Gee.HashMap<string, string> ();

        private int _linkmode;
        public int linkmode {
            get {
                return _linkmode;
            }
            set {
                _linkmode = value;
                imagefile.gicon = new ThemedIcon ("com.github.gabutakut.gabutdm");
                if (linkmode == LinkMode.METALINK) {
                    badge_img.gicon = new ThemedIcon ("com.github.gabutakut.gabutdm.metalink");
                } else if (linkmode == LinkMode.MAGNETLINK) {
                    badge_img.gicon = new ThemedIcon ("com.github.gabutakut.gabutdm.magnet");
                } else if (linkmode == LinkMode.TORRENT) {
                    badge_img.gicon = new ThemedIcon ("com.github.gabutakut.gabutdm.torrent");
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
                        start_button.tooltip_text = _("Paused");
                        remove_timeout ();
                        labeltransfer = @"$(GLib.format_size (transferred)) of $(GLib.format_size (totalsize))";
                        if (url != null && db_download_exist (url)) {
                            update_download (this);
                        }
                        break;
                    case StatusMode.COMPLETE:
                        if (ariagid != null) {
                            start_button.icon_name = "com.github.gabutakut.gabutdm.complete";
                            start_button.tooltip_text = _("Complete");
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
                                if (db_download_exist (url)) {
                                    update_download (this);
                                }
                            }
                        } else {
                            bool foundgid = false;
                            aria_tell_active ().foreach ((strgid)=> {
                                if (ariagid == aria_tell_status (strgid, TellStatus.FOLLOWING)) {
                                    status = status_aria (aria_tell_status (strgid, TellStatus.STATUS));
                                    filename = aria_tell_bittorent (strgid, TellBittorrent.NAME);
                                    update_agid (ariagid, strgid);
                                    ariagid = strgid;
                                    linkmode = LinkMode.TORRENT;
                                    progressbar.fraction = 0.0;
                                    foundgid = true;
                                }
                            });
                            if (foundgid) {
                                break;
                            }
                        }
                        remove_timeout ();
                        break;
                    case StatusMode.WAIT:
                        start_button.icon_name = "com.github.gabutakut.gabutdm.waiting";
                        start_button.tooltip_text = _("Waiting");
                        remove_timeout ();
                        labeltransfer = @"$(GLib.format_size (transferred)) of $(GLib.format_size (totalsize))";
                        if (url != null && db_download_exist (url)) {
                            update_download (this);
                        }
                        break;
                    case StatusMode.ERROR:
                        start_button.icon_name = "com.github.gabutakut.gabutdm.error";
                        start_button.tooltip_text = _("Error");
                        if (ariagid != null && url != null) {
                            labeltransfer = get_aria_error (int.parse (aria_tell_status (ariagid, TellStatus.ERRORCODE)));
                            if (filename != null) {
                                notify_app (_("Download Error"), filename, imagefile.gicon);
                                play_sound ("dialog-error");
                            }
                            aria_remove (ariagid);
                        }
                        remove_timeout ();
                        if (url != null && db_download_exist (url)) {
                            update_download (this);
                        }
                        break;
                    case StatusMode.SEED:
                        start_button.icon_name = "com.github.gabutakut.gabutdm.seed";
                        start_button.tooltip_text = _("Seeding");
                        add_timeout ();
                        break;
                    default:
                        start_button.icon_name = "com.github.gabutakut.gabutdm.active";
                        start_button.tooltip_text = _("Downloading");
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

        private string _filepath;
        public string filepath {
            get {
                return _filepath;
            }
            set {
                _filepath = value;
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
                filename_label.label = _filename != null? _filename : url;
                rowbus.property_set (MenuItem.LABEL.to_string (), _filename != null? _filename : url);
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

        private string _labeltransfer;
        public string labeltransfer {
            get {
                return _labeltransfer;
            }
            set {
                _labeltransfer = value;
                transfer_rate.label = _labeltransfer;
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

        public DownloadRow (Sqlite.Statement stmt) {
            linkmode = stmt.column_int (DBDownload.LINKMODE);
            ariagid = stmt.column_text (DBDownload.ARIAGID);
            status = stmt.column_int (DBDownload.STATUS);
            transferrate = stmt.column_int (DBDownload.TRANSFERRATE);
            totalsize = stmt.column_int64 (DBDownload.TOTALSIZE);
            transferred = stmt.column_int64 (DBDownload.TRANSFERRED);
            filepath = stmt.column_text (DBDownload.FILEPATH);
            filename = stmt.column_text (DBDownload.FILENAME);
            url = stmt.column_text (DBDownload.URL);
            fileordir = stmt.column_text (DBDownload.FILEORDIR);
            labeltransfer = stmt.column_text (DBDownload.LABELTRANSFER);
            timeadded = stmt.column_int64 (DBDownload.TIMEADDED);
            hashoption = get_dboptions (url);
            if_not_exist (ariagid, linkmode, status);
        }

        public DownloadRow.Url (string url, Gee.HashMap<string, string> options, int linkmode, int activedm, bool later) {
            this.hashoption = options;
            this.linkmode = linkmode;
            if (linkmode == LinkMode.TORRENT) {
                ariagid = aria_torrent (url, hashoption, activedm);
            } else if (linkmode == LinkMode.METALINK) {
                ariagid = aria_metalink (url, hashoption, activedm);
            } else {
                ariagid = aria_url (url, hashoption, activedm);
            }
            this.url = url;
            add_db_download (this);
            set_dboptions (url, hashoption);
            Idle.add (()=> {
                update_progress ();
                start_notif (later);
                return GLib.Source.REMOVE;
            });
        }

        construct {
            rowbus = new DbusmenuItem ();
            rowbus.item_activated.connect (download);
            imagefile = new Gtk.Image () {
                icon_size = Gtk.IconSize.LARGE
            };

            badge_img = new Gtk.Image () {
                halign = Gtk.Align.END,
                valign = Gtk.Align.END,
                icon_size = Gtk.IconSize.INHERIT
            };

            var overlay = new Gtk.Overlay () {
                child = imagefile
            };
            overlay.add_overlay (badge_img);

            var openimage = new Gtk.Button () {
                focus_on_click = false,
                has_frame = false,
                child = overlay,
                tooltip_text = _("Open Details")
            };
            openimage.clicked.connect (download);

            transfer_rate = new Gtk.Label (null) {
                xalign = 0,
                use_markup = true,
                valign = Gtk.Align.CENTER
            };
            progressbar = new Gtk.ProgressBar () {
                hexpand = true,
                pulse_step = 0.2
            };

            filename_label = new Gtk.Label (filename) {
                ellipsize = Pango.EllipsizeMode.END,
                hexpand = true,
                xalign = 0,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };

            start_button = new Gtk.Button.from_icon_name ("com.github.gabutakut.gabutdm.active") {
                valign = Gtk.Align.CENTER,
                has_frame = false
            };
            start_button.clicked.connect (()=> {
                action_btn ();
            });

            var remove_button = new Gtk.Button.from_icon_name ("com.github.gabutakut.gabutdm.clear") {
                valign = Gtk.Align.CENTER,
                has_frame = false,
                tooltip_text = _("Remove")
            };
            remove_button.clicked.connect (remove_down);

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
            grid.attach (openimage, 0, 0, 1, 4);
            grid.attach (filename_label, 1, 0, 1, 1);
            grid.attach (progressbar, 1, 1, 1, 1);
            grid.attach (transfer_rate, 1, 2, 1, 1);
            grid.attach (remove_button, 5, 0, 1, 4);
            grid.attach (start_button, 6, 0, 1, 4);
            child = grid;
        }

        public string action_btn (int stats = 2) {
            if (stats != StatusMode.NOTHING && status == StatusMode.COMPLETE) {
                send_dialog ();
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
                if (linkm == LinkMode.TORRENT) {
                    if (url.has_prefix ("magnet:?")) {
                        linkmode = LinkMode.MAGNETLINK;
                        ariagid = aria_url (url, hashoption, activedm ());
                    } else {
                        ariagid = aria_torrent (url, hashoption, activedm ());
                    }
                } else if (linkm == LinkMode.METALINK) {
                    ariagid = aria_metalink (url, hashoption, activedm ());
                } else if (linkm == LinkMode.URL) {
                    if (url.has_prefix ("magnet:?")) {
                        linkmode = LinkMode.MAGNETLINK;
                        ariagid = aria_url (url, hashoption, activedm ());
                    } else {
                        ariagid = aria_url (url, hashoption, activedm ());
                    }
                }
            }
            if (stats == StatusMode.PAUSED) {
                aria_pause (ariagid);
            }
        }

        public void start_notif (bool notif) {
            Idle.add (()=> {
                if (filename == null) {
                    filename = url;
                }
                if (!notif) {
                    notify_app (_("Starting"), filename, imagefile.gicon);
                    play_sound ("device-added");
                }
                return GLib.Source.REMOVE;
            });
        }

        private void action_dowload () {
            status = status_aria (aria_tell_status (ariagid, TellStatus.STATUS));
            if (status == StatusMode.ACTIVE) {
                if (aria_pause (ariagid) == "") {
                    if (linkmode == LinkMode.TORRENT) {
                        if (url.has_prefix ("magnet:?")) {
                            linkmode = LinkMode.MAGNETLINK;
                            ariagid = aria_url (url, hashoption, activedm ());
                        } else {
                            ariagid = aria_torrent (url, hashoption, activedm ());
                        }
                    }
                }
                remove_timeout ();
            } else if (status == StatusMode.PAUSED) {
                aria_position (ariagid, activedm ());
                if (aria_unpause (ariagid) == "") {
                    if (linkmode == LinkMode.TORRENT) {
                        if (url.has_prefix ("magnet:?")) {
                            linkmode = LinkMode.MAGNETLINK;
                            ariagid = aria_url (url, hashoption, activedm ());
                        } else {
                            ariagid = aria_torrent (url, hashoption, activedm ());
                        }
                    }
                }
                add_timeout ();
            } else if (status == StatusMode.COMPLETE) {
                remove_timeout ();
            } else if (status == StatusMode.SEED) {
                aria_pause (ariagid);
                add_timeout ();
            } else if (status == StatusMode.WAIT) {
                aria_pause (ariagid);
                add_timeout ();
            } else {
                if (linkmode == LinkMode.TORRENT) {
                    if (url.has_prefix ("magnet:?")) {
                        linkmode = LinkMode.MAGNETLINK;
                        ariagid = aria_url (url, hashoption, activedm ());
                    } else {
                        ariagid = aria_torrent (url, hashoption, activedm ());
                    }
                } else if (linkmode == LinkMode.METALINK) {
                    ariagid = aria_metalink (url, hashoption, activedm ());
                } else if (linkmode == LinkMode.URL) {
                    if (url.has_prefix ("magnet:?")) {
                        linkmode = LinkMode.MAGNETLINK;
                        ariagid = aria_url (url, hashoption, activedm ());
                    } else {
                        ariagid = aria_url (url, hashoption, activedm ());
                    }
                }
                add_timeout ();
            }
            status = status_aria (aria_tell_status (ariagid, TellStatus.STATUS));
        }

        public string set_selected (string selected) {
            if (linkmode == LinkMode.TORRENT) {
                aria_unpause (ariagid);
                aria_remove (ariagid);
                if (selected != "") {
                    hashoption[AriaOptions.SELECT_FILE.to_string ()] = selected;
                }
                if (url.has_prefix ("magnet:?")) {
                    linkmode = LinkMode.MAGNETLINK;
                    this.ariagid = aria_url (url, hashoption, activedm ());
                } else {
                    this.ariagid = aria_torrent (url, hashoption, activedm ());
                }
            } else if (linkmode == LinkMode.METALINK) {
                aria_unpause (ariagid);
                aria_remove (ariagid);
                if (selected != "") {
                    hashoption[AriaOptions.SELECT_FILE.to_string ()] = selected;
                }
                this.ariagid = aria_metalink (url, hashoption, activedm ());
            }
            status = status_aria (aria_tell_status (ariagid, TellStatus.STATUS));
            add_timeout ();
            return ariagid;
        }

        public void remove_down () {
            remove_timeout ();
            aria_unpause (ariagid);
            aria_remove (ariagid);
            remove_download (url);
            remove_dboptions (url);
            aria_deleteresult (ariagid);
            GLib.Application.get_default ().lookup_action ("destroy").activate (new Variant.string (ariagid));
            destroy ();
        }

        public void download () {
            GLib.Application.get_default ().lookup_action ("downloader").activate (new Variant.string (ariagid));
        }

        private void add_timeout () {
            if (timeout_id == 0) {
                stoptimer = GLib.Source.CONTINUE;
                timeout_id = Timeout.add_seconds (1, update_progress);
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

        public Gtk.Popover get_menu () {
            var downloadmn = new Gtk.FlowBox ();
            foreach (var dmmenu in DownloadMenu.get_all ()) {
                downloadmn.append (new GdmMenu (dmmenu));
            }
            var urisel_popover = new Gtk.Popover () {
                child = downloadmn
            };
            urisel_popover.show.connect (() => {
                downloadmn.unselect_all ();
            });
            downloadmn.child_activated.connect ((dmmenu)=> {
                urisel_popover.hide ();
                var gdmmenu = dmmenu as GdmMenu;
                switch (gdmmenu.downloadmenu) {
                    case DownloadMenu.MOVETOTRASH:
                        if (pathname != null) {
                            remove_down ();
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
                        break;
                    case DownloadMenu.PROPERTIES:
                        gsmproperties ();
                        break;
                    default:
                        if (pathname != null) {
                            var file = File.new_for_path (pathname);
                            if (fileordir == "inode/directory") {
                                open_fileman.begin (file.get_uri ());
                            } else {
                                open_fileman.begin (file.get_parent ().get_uri ());
                            }
                        }
                        break;
                }
            });
            return urisel_popover;
        }
    }
}