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
        public signal void statuschange (string ariagid);
        private Gtk.Button start_button;
        private Gtk.Label transfer_rate;
        private Gtk.ProgressBar progressbar;
        private Gtk.Label filename_label;
        public Gtk.Image imagefile;
        private bool stoptimer;
        public Gee.HashMap<string, string> hashoption = new Gee.HashMap<string, string> ();

        private int _linkmode;
        public int linkmode {
            get {
                return _linkmode;
            }
            set {
                _linkmode = value;
                if (linkmode == LinkMode.METALINK) {
                    imagefile.gicon = new ThemedIcon ("com.github.gabutakut.gabutdm");
                } else if (linkmode == LinkMode.MAGNETLINK) {
                    imagefile.gicon = new ThemedIcon ("com.github.gabutakut.gabutdm.magnet");
                } else if (linkmode == LinkMode.TORRENT) {
                    imagefile.gicon = new ThemedIcon ("application-x-bittorrent");
                } else {
                    imagefile.gicon = new ThemedIcon ("insert-link");
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
                if (value != "") {
                    imagefile.gicon = GLib.ContentType.get_icon (value);
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
                        ((Gtk.Image) start_button.image).icon_name = "media-playback-pause";
                        start_button.tooltip_text = _("Paused");
                        remove_timeout ();
                        break;
                    case StatusMode.COMPLETE:
                        ((Gtk.Image) start_button.image).icon_name = "process-completed";
                        start_button.tooltip_text = _("Complete");
                        if (linkmode != LinkMode.MAGNETLINK) {
                            if (filename != null) {
                                Idle.add (()=> {
                                    if (timeout_id == 0) {
                                        GabutApp.gabutwindow.application.activate_action ("destroy", new Variant.string (ariagid));
                                        notify_app (_("Download Complete"), filename);
                                        if (bool.parse (get_dbsetting (DBSettings.DIALOGNOTIF))) {
                                            send_dialog ();
                                        }
                                    }
                                    return false;
                                });
                            }
                        } else {
                            bool foundgid = false;
                            aria_tell_active ().foreach ((strgid)=> {
                                if (ariagid == aria_tell_status (strgid, TellStatus.FOLLOWING)) {
                                    status = status_aria (aria_tell_status (strgid, TellStatus.STATUS));
                                    filename = aria_tell_bittorent (strgid, TellBittorrent.NAME);
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
                        if (timeout_id != 0) {
                            statuschange (ariagid);
                        }
                        remove_timeout ();
                        break;
                    case StatusMode.WAIT:
                        ((Gtk.Image) start_button.image).icon_name = "preferences-system-time";
                        start_button.tooltip_text = _("Waiting");
                        if (timeout_id != 0) {
                            statuschange (ariagid);
                        }
                        remove_timeout ();
                        break;
                    case StatusMode.ERROR:
                        ((Gtk.Image) start_button.image).icon_name = "dialog-error";
                        start_button.tooltip_text = _("Error");
                        if (ariagid != null) {
                            filename = get_aria_error (int.parse (aria_tell_status (ariagid, TellStatus.ERRORCODE)));
                            notify_app (_("Download Error"), filename);
                            aria_remove (ariagid);
                        }
                        if (timeout_id != 0) {
                            statuschange (ariagid);
                        }
                        remove_timeout ();
                        break;
                    default:
                        if (linkmode != LinkMode.MAGNETLINK) {
                            ((Gtk.Image) start_button.image).icon_name = "media-playback-start";
                            start_button.tooltip_text = _("Downloading");
                        } else {
                            ((Gtk.Image) start_button.image).icon_name = "preferences-system-time";
                            start_button.tooltip_text = _("Waiting");
                        }
                        if (timeout_id == 0) {
                            statuschange (ariagid);
                        }
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
                var file = File.new_for_path (filepath);
                if (status != StatusMode.ERROR) {
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
                filename_label.label = _filename;
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
                double fraction = (double) transferred / (double) totalsize;
                if (fraction > 0.0) {
                    progressbar.fraction = fraction;
                }
                if (status == StatusMode.ACTIVE) {
                    set_progress.begin (progressbar.fraction);
                }
            }
        }

        public DownloadRow (Sqlite.Statement stmt) {
            linkmode = stmt.column_int (DBDownload.LINKMODE);
            status = stmt.column_int (DBDownload.STATUS);
            ariagid = stmt.column_text (DBDownload.ARIAGID);
            totalsize = stmt.column_int64 (DBDownload.TOTALSIZE);
            transferrate = stmt.column_int (DBDownload.TRANSFERRATE);
            transferred = stmt.column_int64 (DBDownload.TRANSFERRED);
            filepath = stmt.column_text (DBDownload.FILEPATH);
            filename = stmt.column_text (DBDownload.FILENAME);
            url = stmt.column_text (DBDownload.URL);
            fileordir = stmt.column_text (DBDownload.FILEORDIR);
            transfer_rate.label = @"$(GLib.format_size (transferred)) of $(GLib.format_size (totalsize))";
            double fraction = (double) transferred / (double) totalsize;
            if (fraction > 0.0) {
                progressbar.fraction = fraction;
            }
            hashoption = get_dboptions (url);
        }

        public DownloadRow.Url (string url, Gee.HashMap<string, string> options, bool later, int linkmode) {
            this.hashoption = options;
            this.linkmode = linkmode;
            if (linkmode == LinkMode.TORRENT) {
                ariagid = aria_torrent (url, hashoption);
                notify_app (_("Starting"),
                            _("Torrent"));
            } else if (linkmode == LinkMode.METALINK) {
                ariagid = aria_metalink (url, hashoption);
                notify_app (_("Starting"),
                            _("Metalink"));
            } else if (linkmode == LinkMode.MAGNETLINK || linkmode == LinkMode.URL) {
                ariagid = aria_url (url, hashoption);
                notify_app (_("Starting"), url);
            }
            this.url = url;
            if (later) {
                aria_pause (ariagid);
            }
        }

        construct {
            imagefile = new Gtk.Image () {
                icon_size = Gtk.IconSize.DND
            };
            var openimage = new Gtk.Button () {
                focus_on_click = false,
                tooltip_text = _("Open Details")
            };
            openimage.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            openimage.add (imagefile);
            openimage.clicked.connect (download);

            transfer_rate = new Gtk.Label (null) {
                xalign = 0,
                use_markup = true,
                valign = Gtk.Align.CENTER
            };
            progressbar = new Gtk.ProgressBar () {
                hexpand = true
            };

            filename_label = new Gtk.Label (filename) {
                ellipsize = Pango.EllipsizeMode.END,
                hexpand = true,
                xalign = 0
            };

            start_button = new Gtk.Button.from_icon_name ("media-playback-start", Gtk.IconSize.SMALL_TOOLBAR) {
                valign = Gtk.Align.CENTER
            };
            start_button.clicked.connect (()=> {
                if (status == StatusMode.COMPLETE) {
                    send_dialog ();
                    return;
                }
                if (linkmode != LinkMode.URL) {
                    action_dowload ();
                } else {
                    if (aria_geturis (ariagid) != "") {
                        action_dowload ();
                    } else {
                        ariagid = aria_url (url, hashoption);
                        status = status_aria (aria_tell_status (ariagid, TellStatus.STATUS));
                    }
                }
                statuschange (ariagid);
            });

            var remove_button = new Gtk.Button.from_icon_name ("edit-clear", Gtk.IconSize.SMALL_TOOLBAR) {
                valign = Gtk.Align.CENTER,
                tooltip_text = _("Remove")
            };
            remove_button.clicked.connect (remove_down);

            var grid = new Gtk.Grid () {
                margin = 6,
                column_spacing = 6,
                orientation = Gtk.Orientation.HORIZONTAL,
                valign = Gtk.Align.CENTER
            };
            grid.attach (openimage, 0, 0, 1, 4);
            grid.attach (filename_label, 1, 0, 1, 1);
            grid.attach (progressbar, 1, 1, 1, 1);
            grid.attach (transfer_rate, 1, 2, 1, 1);
            grid.attach (remove_button, 5, 0, 1, 4);
            grid.attach (start_button, 6, 0, 1, 4);
            add (grid);
            show_all ();
            add_timeout ();
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
                        linkmode = LinkMode.URL;
                        ariagid = aria_url (url, hashoption);
                    }
                }
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
            this.destroy ();
        }

        public void download () {
            GabutApp.gabutwindow.application.activate_action ("downloader", new Variant.string (ariagid));
        }

        private uint timeout_id = 0;
        public void add_timeout () {
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
            }
            transfer_rate.label = @"$(GLib.format_size (transferred)) of $(GLib.format_size (totalsize)) $(duprate) $(downrate) $(timedownload)";
            return stoptimer;
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
                default:
                    if (linkmode != LinkMode.URL && ariagid != null) {
                        if (aria_tell_status (ariagid, TellStatus.SEEDER) == "true") {
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
            var builder = new StringBuilder ();
            if (linkmode == LinkMode.TORRENT) {
                if (url.has_prefix ("magnet:?")) {
                    builder.append (url);
                } else {
                    builder.append ("File Torrent");
                }
            } else if (linkmode == LinkMode.METALINK) {
                builder.append ("File Metalink");
            } else {
                builder.append (url);
            }
            builder.append ("<gabut>");
            builder.append (pathname);
            builder.append ("<gabut>");
            builder.append (totalsize.to_string ());
            builder.append ("<gabut>");
            builder.append (fileordir);
            GabutApp.gabutwindow.application.activate_action ("succes", new Variant.string (builder.str));
        }
    }
}
