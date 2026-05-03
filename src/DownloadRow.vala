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
        public DBusMenu.DbusmenuItem rowbus;
        public Gee.HashMap<string, string> hashoption = new Gee.HashMap<string, string> ();
        private ProgressPaintable prpaint;
        private ProgressPaintable actpaint;
        private BitfieldWidget bitfield_widget;
        private bool stoptimer;
        private uint timeout_id = 0;

        private int _linkmode;
        public int linkmode {
            get {
                return _linkmode;
            }
            set {
                _linkmode = value;
                prpaint.icon_paintable = load_icon_paintable ("com.github.gabutakut.gabutdm.progress", 48);
                if (_linkmode == LinkMode.METALINK) {
                    prpaint.badge_paintable = load_icon_paintable ("com.github.gabutakut.gabutdm.metalink", 48);
                } else if (_linkmode == LinkMode.MAGNETLINK) {
                    prpaint.badge_paintable = load_icon_paintable ("com.github.gabutakut.gabutdm.magnet", 48);
                } else if (_linkmode == LinkMode.TORRENT) {
                    prpaint.badge_paintable = load_icon_paintable ("com.github.gabutakut.gabutdm.torrent", 48);
                } else if (_linkmode == LinkMode.HLS) {
                    prpaint.badge_paintable = load_icon_paintable ("applications-multimedia", 48);
                } else if (_linkmode == LinkMode.YTBAUDIO || _linkmode == LinkMode.YTBMP4 || _linkmode == LinkMode.YTBWEBM) {
                    prpaint.badge_paintable = load_icon_paintable ("com.github.gabutakut.gabutdm.ytb", 48);
                } else {
                    prpaint.badge_paintable = load_icon_paintable ("com.github.gabutakut.gabutdm.insertlink", 48);
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
                    prpaint.icon_paintable = load_icon_paintable (GLib.ContentType.get_generic_icon_name (value), 48);
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
                switch (_status) {
                    case StatusMode.PAUSED:
                        actpaint.icon_paintable = load_icon_paintable ( "com.github.gabutakut.gabutdm.pause", 24);
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
                            actpaint.icon_paintable = load_icon_paintable ("com.github.gabutakut.gabutdm.complete", 24);
                            start_button.tooltip_text = _("Complete\nCTRL + V");
                            if (linkmode == LinkMode.YTBAUDIO) {
                                if (filename != null) {
                                    var filep = File.new_for_path (filepath);
                                    string mp3_p = mp3_filename (filep.get_path ());
                                    var ffmpeg = new Ffmpeg.Merger ();
                                    int thread_done_int = 0;
                                    new Thread<void>("merworker-%s".printf (filename), () => {
                                        thread_done_int = ffmpeg.to_audio (filep.get_path (), mp3_p);
                                        AtomicInt.set (ref thread_done_int, 1);
                                    });
                                    GLib.Timeout.add (100, () => {
                                        fraction = (double) ffmpeg.get_last_progress();
                                        string hex_bitfield = ffmpeg.hex_bitfield();
                                        bitfield_widget.set_bitfield_data(hex_bitfield, 1);
                                        bool is_done = AtomicInt.get (ref thread_done_int) == 1;
                                        if (is_done || fraction >= 1.0) {
                                            try {
                                                filep.delete ();
                                                pathname = filepath = mp3_p;
                                                var info = File.new_for_path (filepath).query_info (GLib.FileAttribute.STANDARD_SIZE, GLib.FileQueryInfoFlags.NONE);
                                                labeltransfer = GLib.format_size (info.get_size ());
                                                notify_app (_("Download Complete"), filename, GLib.ContentType.get_icon (fileordir));
                                                play_sound ("complete");
                                                if (bool.parse (get_dbsetting (DBSettings.DIALOGNOTIF))) {
                                                    send_dialog ();
                                                }
                                                ffmpeg = null;
                                            } catch (Error e) {
                                                GLib.warning (e.message);
                                            }
                                            return false;
                                        }
                                        return true; 
                                    });
                                }
                            } else if (linkmode == LinkMode.YTBMP4) {
                                if (filename != null) {
                                    var filep = File.new_for_path (filepath);
                                    string m4a_a = m4a_filename(filep.get_path ());
                                    if (!GLib.FileUtils.test (m4a_a, GLib.FileTest.EXISTS)) {
                                        hashoption[AriaOptions.OUT.to_string ()] = GLib.Path.get_basename (m4a_a);
                                        filepath = m4a_a;
                                        ariagid = aria_url (url.split ("gabutytb")[2], hashoption, 0);
                                        status = StatusMode.ACTIVE;
                                        break;
                                    }
                                    string new_mp4 = no_ext (filep.get_path ())+"_combine.mp4";
                                    string mp4_old = mp4_filename (filep.get_path ());
                                    combine_file (mp4_old, m4a_a, new_mp4);
                                }
                            } else if (linkmode == LinkMode.YTBWEBM) {
                                if (filename != null) {
                                    var filep = File.new_for_path (filepath);
                                    string opus_a = opus_filename(filep.get_path ());
                                    if (!GLib.FileUtils.test (opus_a, GLib.FileTest.EXISTS)) {
                                        hashoption[AriaOptions.OUT.to_string ()] = GLib.Path.get_basename (opus_a);
                                        filepath = opus_a;
                                        ariagid = aria_url (url.split ("gabutytb")[2], hashoption, 0);
                                        status = StatusMode.ACTIVE;
                                        break;
                                    }
                                    string new_webm = no_ext (filep.get_path ())+"_combine.webm";
                                    string webm_old = webm_filename (filep.get_path ());
                                    combine_file (webm_old, opus_a, new_webm);
                                }
                            }
                        }
                        if (linkmode != LinkMode.MAGNETLINK) {
                            if (_pathname != null) {
                                open_thum ();
                            }
                            if (filename != null) {
                                GLib.Application.get_default ().lookup_action ("destroy").activate (new Variant.string (ariagid));
                                if (pathname != null && pathname != "" && fileordir != "" && fileordir != null) {
                                    if (linkmode != LinkMode.YTBMP4 && linkmode != LinkMode.YTBWEBM && linkmode != LinkMode.YTBAUDIO) {
                                        notify_app (_("Download Complete"), filename, GLib.ContentType.get_icon (fileordir));
                                        play_sound ("complete");
                                        if (bool.parse (get_dbsetting (DBSettings.DIALOGNOTIF))) {
                                            send_dialog ();
                                        }
                                    }
                                }
                            }
                        } else {
                            bool foundgid = false;
                            foreach (var strgid in aria_tell_active ()) {
                                if (ariagid == aria_tell_status (strgid, TellStatus.FOLLOWING)) {
                                    status = status_aria (aria_tell_status (strgid, TellStatus.STATUS));
                                    filename = aria_tell_bittorent (strgid, TellBittorrent.NAME);
                                    var dir_dm = "";
                                    if (hashoption.has_key (AriaOptions.DIR.to_string ())) {
                                        dir_dm = hashoption.@get (AriaOptions.DIR.to_string ());
                                    } else {
                                        dir_dm = get_dbsetting (DBSettings.DIR);
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
                                    break;
                                }
                            }
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
                        actpaint.icon_paintable = load_icon_paintable ("com.github.gabutakut.gabutdm.waiting", 24);
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
                        actpaint.icon_paintable = load_icon_paintable ( "com.github.gabutakut.gabutdm.error", 24);
                        start_button.tooltip_text = _("Error\nCTRL + V");
                        if (linkmode != LinkMode.HLS) {
                            if (ariagid != null && url != null) {
                                errorcode = get_aria_error (int.parse (aria_tell_status (ariagid, TellStatus.ERRORCODE)));
                                labeltransfer = _("-");
                                if (filename != null) {
                                    notify_app (_("Download Error"), filename, GLib.ContentType.get_icon (fileordir));
                                    play_sound ("bell");
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
                        actpaint.icon_paintable = load_icon_paintable ( "com.github.gabutakut.gabutdm.seed", 24);
                        start_button.tooltip_text = _("Seeding\nCTRL + V");
                        if (linkmode != LinkMode.HLS) {
                            add_timeout ();
                        }
                        break;
                    case StatusMode.VERIFY:
                        actpaint.icon_paintable = load_icon_paintable ( "com.github.gabutakut.gabutdm.verify", 24);
                        start_button.tooltip_text = _("Verify");
                        break;
                    case StatusMode.MERGE:
                        actpaint.icon_paintable = load_icon_paintable ( "applications-multimedia", 24);
                        start_button.tooltip_text = _("Merge\nCTRL + V");
                        break;
                    default:
                        actpaint.icon_paintable = load_icon_paintable ( "com.github.gabutakut.gabutdm.active", 24);
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
                    if (linkmode == LinkMode.URL || linkmode == LinkMode.YTBAUDIO || linkmode == LinkMode.YTBMP4 || linkmode == LinkMode.YTBWEBM) {
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
                prpaint.progress = _fraction;
                actpaint.progress = _fraction;
            }
        }

        public DownloadRow.Hls (string gbturl, Gee.HashMap<string, string> options, int linkmode) {
            this.hashoption = options;
            this.linkmode = linkmode;
            this.url = gbturl;
            errorcode = _("HLS waiting data…");
            bitfield_widget.set_bitfield_data ( "",  0);
            bitfield_widget.connectionsdl = "0";
            labeltransfer = "-";
            ariagid = "";
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
            if (transferred > 0 && totalsize > 0) {
                fraction = (double) transferred / (double) totalsize;
            }
            if (status == StatusMode.COMPLETE) {
                if (pathname != null) {
                    open_thum ();
                }
            }
        }

        public DownloadRow.Url (string gbturl, Gee.HashMap<string, string> options, int linkmode) {
            this.hashoption = options;
            this.linkmode = linkmode;
            if (linkmode == LinkMode.TORRENT) {
                ariagid = aria_torrent (gbturl, hashoption, actwaiting ());
            } else if (linkmode == LinkMode.METALINK) {
                ariagid = aria_metalink (gbturl, hashoption, actwaiting ());
            } else if (linkmode == LinkMode.YTBMP4 || linkmode == LinkMode.YTBWEBM) {
                ariagid = aria_url (gbturl.split ("gabutytb")[1].split ("gabutytb")[0], hashoption, actwaiting ());
            } else {
                ariagid = aria_url (gbturl, hashoption, actwaiting ());
            }
            this.url = gbturl;
            errorcode = _("Waiting download data…");
            if (options.has_key (AriaOptions.SELECT_FILE.to_string ())) {
                selectedtr = options.@get (AriaOptions.SELECT_FILE.to_string ());
            }
        }

        construct {
            bitfield_widget = new BitfieldWidget (true, 3) {
                valign = Gtk.Align.CENTER
            };
            rowbus = new DBusMenu.DbusmenuItem ();

            prpaint = new ProgressPaintable () {
                icon_ratio = 0.75,
                square_mode = true,
                badge_show_bg = true,
                line_width_ratio = 0.55,
                badge_ratio = 0.35,
                badge_position = BadgePosition.BOTTOM_RIGHT
            };
            var imagefile = new Gtk.Image () {
                pixel_size = 48,
                paintable = prpaint
            };
            prpaint.queue_draw.connect (imagefile.queue_draw);

            openimage = new Gtk.Button () {
                valign = Gtk.Align.CENTER,
                focus_on_click = false,
                has_frame = false,
                child = imagefile,
                height_request = 60,
                tooltip_text = _("Progress\nCTRL + W")
            };
            actpaint = new ProgressPaintable () {
                icon_ratio = 0.95,
                line_width_ratio = 0.15,
                square_mode = true,
                badge_show_bg = false
            };
            var actimage = new Gtk.Image () {
                pixel_size = 24,
                paintable = actpaint
            };
            actpaint.queue_draw.connect (actimage.queue_draw);
            start_button = new Gtk.Button () {
                valign = Gtk.Align.CENTER,
                has_frame = false,
                child = actimage,
                height_request = 40
            };
            var grid = new Gtk.Grid () {
                hexpand = true,
                valign = Gtk.Align.CENTER
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
            } else if (linkmode == LinkMode.YTBMP4 || linkmode == LinkMode.YTBWEBM) {
                if (linkmode == LinkMode.YTBMP4) {
                    if (filepath.has_suffix (".m4a")) {
                        var filep = File.new_for_path (filepath);
                        string m4a_a = m4a_filename(filep.get_path ());
                        hashoption[AriaOptions.OUT.to_string ()] = GLib.Path.get_basename (m4a_a);
                        ariagid = aria_url (url.split ("gabutytb")[2], hashoption, 0);
                        return;
                    }
                } else if (linkmode == LinkMode.YTBWEBM) {
                    if (filepath.has_suffix (".opus")) {
                        var filep = File.new_for_path (filepath);
                        string opus_a = opus_filename(filep.get_path ());
                        hashoption[AriaOptions.OUT.to_string ()] = GLib.Path.get_basename (opus_a);
                        ariagid = aria_url (url.split ("gabutytb")[2], hashoption, 0);
                        return;
                    }
                }
                ariagid = aria_url (url.split ("gabutytb")[1].split ("gabutytb")[0], hashoption, actwaiting ());
            } else if (linkmode == LinkMode.URL || linkmode == LinkMode.YTBAUDIO) {
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
                fraction = (double) transferred / (double) totalsize;
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
                    if (linkmode == LinkMode.TORRENT && ariagid != null) {
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

        private void combine_file (string vpath, string apath, string outpath) {
            var ffmpeg = new Ffmpeg.Merger ();
            int thread_done_int = 0;
            new Thread<void>("merworker-%s".printf (filename), () => {
                int result = ffmpeg.combine_file (vpath, apath, outpath);
                AtomicInt.set (ref thread_done_int, result == 0 ? 1 : result);
            });
            GLib.Timeout.add (100, () => {
                fraction = (double) ffmpeg.get_last_progress ();
                string hex_bitfield = ffmpeg.hex_bitfield ();
                bitfield_widget.set_bitfield_data (hex_bitfield, 2);
                int done = AtomicInt.get (ref thread_done_int);
                if (done == 0) {
                    return true;
                }
                fraction = (double) ffmpeg.get_last_progress ();
                bitfield_widget.set_bitfield_data (ffmpeg.hex_bitfield (), 2);
                if (done < 0) {
                    status = StatusMode.ERROR;
                    labeltransfer = _("combine_file failed: %d".printf (done));
                } else {
                    try {
                        GLib.FileUtils.remove (vpath);
                        GLib.FileUtils.remove (apath);
                        pathname = filepath = outpath;
                        var info = File.new_for_path (outpath).query_info (GLib.FileAttribute.STANDARD_SIZE, GLib.FileQueryInfoFlags.NONE);
                        labeltransfer = GLib.format_size (info.get_size ());
                        open_thum ();
                        if (bool.parse (get_dbsetting (DBSettings.DIALOGNOTIF))) {
                            send_dialog ();
                        }
                    } catch (Error e) {
                        GLib.warning (e.message);
                    }
                }
                ffmpeg = null;
                return false;
            });
        }

        private void open_thum () {
            if (pathname != null) {
                var filem = File.new_for_path (pathname);
                if (get_mime_type (filem).contains ("video/")) {
                    if (GLib.FileUtils.test (pathname, GLib.FileTest.EXISTS)) {
                        open_file_min.begin (filem);
                    }
                }
            }
        }

        private async void open_file_min (GLib.File file) throws Error {
            var info = file.query_info ("standard::size", FileQueryInfoFlags.NONE);
            int64 file_size = info.get_size ();
            const int64 MAX_CHUNK = 4 * 1024 * 1024;
            int64 read_size = file_size < MAX_CHUNK ? file_size : MAX_CHUNK;
            var input = file.read ();
            ((GLib.Seekable) input).seek (0, GLib.SeekType.SET);
            uint8[] buffer = new uint8[read_size];
            size_t bytes_read = 0;
            input.read_all (buffer, out bytes_read);
            input.close ();
            thumnails (buffer[0:bytes_read]);
        }

        private void thumnails (uint8[] data) {
            var ffmpeg = new Ffmpeg.Reader ();
            int out_w, out_h, out_stride;
            uint8* ffdata = ffmpeg.auto_thumbnail_from_buffer (data, out out_w, out out_h, out out_stride);
            unowned uint8[] pixel_data = (uint8[]) ffdata;
            pixel_data.length = out_stride * out_h;
            if (pixel_data != null) {
                var pixbuf = new Gdk.Pixbuf.from_data(pixel_data, Gdk.Colorspace.RGB, false, 8, out_w, out_h, out_stride);
                bitfield_widget.set_thumbnail(pixbuf);
            }
            ffmpeg = null;
        }
    }
}