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
    public class DownloadRow : Gtk.ListBoxRow {
        public signal void delete_me (DownloadRow row);
        public signal void update_agid (string ariagid, string newgid);
        private Gtk.Button start_button;
        private Gtk.Label transfer_rate;
        private Gtk.ProgressBar progressbar;
        private Gtk.Label filename_label;
        public Gtk.Image imagefile;
        public Gtk.Image badge_img;
        public DbusmenuItem rowbus;
        private bool stoptimer;
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
                    badge_img.gicon = new ThemedIcon ("application-x-bittorrent");
                } else {
                    badge_img.gicon = new ThemedIcon ("insert-link");
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
                    rowbus.property_set (MenuItem.ICON_NAME.get_name (), GLib.ContentType.get_generic_icon_name (value));
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
                        start_button.icon_name = "media-playback-pause";
                        start_button.tooltip_text = _("Paused");
                        remove_timeout ();
                        if (url != null && db_download_exist (url)) {
                            update_download (this);
                        }
                        break;
                    case StatusMode.COMPLETE:
                        if (ariagid != null) {
                            if (bool.parse (aria_tell_status (ariagid, TellStatus.SEEDER))) {
                                start_button.icon_name = "com.github.gabutakut.gabutdm.seed";
                                start_button.tooltip_text = _("Seeding");
                                return;
                            } else {
                                start_button.icon_name = "process-completed";
                                start_button.tooltip_text = _("Complete");
                            }
                        }
                        if (linkmode != LinkMode.MAGNETLINK) {
                            if (filename != null) {
                                GLib.Application.get_default ().lookup_action ("destroy").activate (new Variant.string (ariagid));
                                notify_app (_("Download Complete"), filename, imagefile.gicon);
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
                        start_button.icon_name = "preferences-system-time";
                        start_button.tooltip_text = _("Waiting");
                        remove_timeout ();
                        if (url != null && db_download_exist (url)) {
                            update_download (this);
                        }
                        break;
                    case StatusMode.ERROR:
                        start_button.icon_name = "dialog-error";
                        start_button.tooltip_text = _("Error");
                        if (ariagid != null) {
                            filepath = aria_str_files (AriaGetfiles.PATH, ariagid);
                            labeltransfer = get_aria_error (int.parse (aria_tell_status (ariagid, TellStatus.ERRORCODE)));
                            if (filename != null) {
                                notify_app (_("Download Error"), filename, imagefile.gicon);
                            }
                            aria_remove (ariagid);
                        }
                        remove_timeout ();
                        if (url != null && db_download_exist (url)) {
                            update_download (this);
                        }
                        break;
                    default:
                        start_button.icon_name = "media-playback-start";
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
                    } else if (linkmode == LinkMode.METALINK || linkmode == LinkMode.TORRENT) {
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
                rowbus.property_set (MenuItem.LABEL.get_name (), _filename != null? _filename : url);
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
                    if (status == StatusMode.ACTIVE) {
                        set_progress_visible.begin (progressbar.fraction);
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
            hashoption = get_dboptions (url);
            if_not_exist (ariagid, linkmode, status);
        }

        public DownloadRow.Url (string url, Gee.HashMap<string, string> options, int linkmode) {
            this.hashoption = options;
            this.linkmode = linkmode;
            if (linkmode == LinkMode.TORRENT) {
                ariagid = aria_torrent (url, hashoption);
            } else if (linkmode == LinkMode.METALINK) {
                ariagid = aria_metalink (url, hashoption);
            } else if (linkmode == LinkMode.MAGNETLINK || linkmode == LinkMode.URL) {
                ariagid = aria_url (url, hashoption);
                filename = url;
            }
            this.url = url;
            add_db_download (this);
            idle_progress ();
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

            start_button = new Gtk.Button.from_icon_name ("media-playback-start") {
                valign = Gtk.Align.CENTER
            };
            start_button.clicked.connect (()=> {
                action_btn ();
            });

            var remove_button = new Gtk.Button.from_icon_name ("edit-delete") {
                valign = Gtk.Align.CENTER,
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
                        ariagid = aria_url (url, hashoption);
                    } else {
                        ariagid = aria_torrent (url, hashoption);
                    }
                } else if (linkm == LinkMode.METALINK) {
                    ariagid = aria_metalink (url, hashoption);
                } else if (linkm == LinkMode.URL) {
                    if (url.has_prefix ("magnet:?")) {
                        linkmode = LinkMode.MAGNETLINK;
                        ariagid = aria_url (url, hashoption);
                    } else {
                        ariagid = aria_url (url, hashoption);
                    }
                }
            }
            if (stats == StatusMode.PAUSED) {
                aria_pause (ariagid);
            }
        }

        public void start_notif () {
            if (linkmode == LinkMode.TORRENT) {
                notify_app (_("Starting"),
                            _("Torrent"), imagefile.gicon);
            } else if (linkmode == LinkMode.METALINK) {
                notify_app (_("Starting"),
                            _("Metalink"), imagefile.gicon);
            } else if (linkmode == LinkMode.MAGNETLINK || linkmode == LinkMode.URL) {
                notify_app (_("Starting"), url, imagefile.gicon);
            }
        }

        public void idle_progress () {
            Idle.add (()=> { update_progress (); return false; });
        }

        private void action_dowload () {
            status = status_aria (aria_tell_status (ariagid, TellStatus.STATUS));
            if (status == StatusMode.ACTIVE) {
                if (aria_pause (ariagid) == "") {
                    if (linkmode == LinkMode.TORRENT) {
                        if (url.has_prefix ("magnet:?")) {
                            linkmode = LinkMode.MAGNETLINK;
                            ariagid = aria_url (url, hashoption);
                        } else {
                            ariagid = aria_torrent (url, hashoption);
                        }
                    }
                }
                remove_timeout ();
            } else if (status == StatusMode.PAUSED) {
                if (aria_unpause (ariagid) == "") {
                    if (linkmode == LinkMode.TORRENT) {
                        if (url.has_prefix ("magnet:?")) {
                            linkmode = LinkMode.MAGNETLINK;
                            ariagid = aria_url (url, hashoption);
                        } else {
                            ariagid = aria_torrent (url, hashoption);
                        }
                    }
                }
                add_timeout ();
            } else if (status == StatusMode.COMPLETE) {
                remove_timeout ();
            } else if (status == StatusMode.WAIT) {
                aria_pause (ariagid);
                add_timeout ();
            } else {
                if (linkmode == LinkMode.TORRENT) {
                    if (url.has_prefix ("magnet:?")) {
                        linkmode = LinkMode.MAGNETLINK;
                        ariagid = aria_url (url, hashoption);
                    } else {
                        ariagid = aria_torrent (url, hashoption);
                    }
                } else if (linkmode == LinkMode.METALINK) {
                    ariagid = aria_metalink (url, hashoption);
                } else if (linkmode == LinkMode.URL) {
                    if (url.has_prefix ("magnet:?")) {
                        linkmode = LinkMode.MAGNETLINK;
                        ariagid = aria_url (url, hashoption);
                    } else {
                        ariagid = aria_url (url, hashoption);
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
                    hashoption[AriaOptions.SELECT_FILE.get_name ()] = selected;
                }
                if (url.has_prefix ("magnet:?")) {
                    linkmode = LinkMode.MAGNETLINK;
                    this.ariagid = aria_url (url, hashoption);
                } else {
                    this.ariagid = aria_torrent (url, hashoption);
                }
            } else if (linkmode == LinkMode.METALINK) {
                aria_unpause (ariagid);
                aria_remove (ariagid);
                if (selected != "") {
                    hashoption[AriaOptions.SELECT_FILE.get_name ()] = selected;
                }
                this.ariagid = aria_metalink (url, hashoption);
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
            delete_me (this);
            GLib.Application.get_default ().lookup_action ("destroy").activate (new Variant.string (ariagid));
            destroy ();
        }

        public void download () {
            GLib.Application.get_default ().lookup_action ("downloader").activate (new Variant.string (ariagid));
        }

        private uint timeout_id = 0;
        private void add_timeout () {
            if (timeout_id == 0) {
                stoptimer = true;
                timeout_id = Timeout.add_seconds (1, update_progress);
            }
        }

        private void remove_timeout () {
            if (timeout_id != 0) {
                Source.remove (timeout_id);
                timeout_id = 0;
            }
            stoptimer = false;
        }

        public bool update_progress () {
            totalsize = int64.parse (aria_tell_status (ariagid, TellStatus.TOTALLENGTH));
            transferred = int64.parse (aria_tell_status (ariagid, TellStatus.COMPELETEDLENGTH));
            transferrate = int.parse (aria_tell_status (ariagid, TellStatus.DOWNLOADSPEED));
            uprate = int.parse (aria_tell_status (ariagid, TellStatus.UPLOADSPEED));
            status = status_aria (aria_tell_status (ariagid, TellStatus.STATUS));
            filepath = aria_str_files (AriaGetfiles.PATH, ariagid);
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
                labeltransfer = @"$(GLib.format_size (transferred)) of $(GLib.format_size (totalsize)) $(duprate) $(downrate) $(timedownload)";
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
                            return StatusMode.COMPLETE;
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
                    gabutinfo.set_info ("File Torrent", InfoSucces.ADDRESS);
                }
            } else if (linkmode == LinkMode.METALINK) {
                gabutinfo.set_info ("File Metalink", InfoSucces.ADDRESS);
            } else {
                gabutinfo.set_info (url, InfoSucces.ADDRESS);
            }
            gabutinfo.set_info (pathname, InfoSucces.FILEPATH);
            gabutinfo.set_info (totalsize.to_string (), InfoSucces.FILESIZE);
            gabutinfo.set_info (fileordir, InfoSucces.ICONNAME);
            GLib.Application.get_default ().lookup_action ("succes").activate (new Variant.string (gabutinfo.get_info ()));
        }
    }
}
