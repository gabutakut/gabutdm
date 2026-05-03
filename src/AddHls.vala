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
    public class AddHls : Gtk.Dialog {
        public signal void downloadfile (string url, Gee.HashMap<string, string> options, bool later, int linkmode, bool server = false);
        public Gtk.Button save_button;
        public Gtk.Button start_button;
        public Gtk.Button later_button;
        public DownloadRow row;
        public DialogType dialogtype { get; construct; }
        private MediaEntry link_entry;
        private MediaEntry name_entry;
        private MediaEntry useragent_entry;
        private MediaEntry refer_entry;
        private Gtk.CheckButton usefolder;
        private Gtk.Button folder_location;
        private Gee.HashMap<string, string> hashoptions;
        private Gee.ArrayList<HlsOption> options_list;
        private Gtk.Button fetch_btn;
        private Gtk.DropDown res_dropdown;
        private Gtk.StringList res_model;
        private Gtk.Picture picture_blurry;
        private Gtk.Picture picture_sharp;
        private Gtk.Label duration_label;
        private Gtk.Stack thumb_stack;
        private Cancellable cancellable = new Cancellable ();
        private bool resolution;
        private string [] urlhls = null;

        File _selectfd = null;
        File selectfd {
            get {
                return _selectfd;
            }
            set {
                _selectfd = value;
                if (selectfd != null) {
                    folder_location.child = button_chooser (selectfd, 25);
                }
            }
        }

        public string url_link {
            get {
                return link_entry.text;
            }
            set {
                link_entry.text = value;
            }
        }

        private string _headerc;
        public string headerc {
            get {
                return _headerc;
            }
            set {
                _headerc = value;
            }
        }

        public MatchInfo portserver {
            set {
                headerc = value.fetch (PostServer.HEADER);
                link_entry.text = value.fetch (PostServer.URL);
                name_entry.text = value.fetch (PostServer.FILENAME);
                refer_entry.text = value.fetch (PostServer.REFERRER);
                useragent_entry.text = value.fetch (PostServer.USERAGENT);
            }
        }

        public AddHls () {
            Object (dialogtype: DialogType.ADDHLS, resizable: false, use_header_bar: 1);
        }

        public AddHls.Property () {
            Object (dialogtype: DialogType.PROPERTY, resizable: false, use_header_bar: 1);
        }

        construct {
            hashoptions = new Gee.HashMap<string, string> ();
            options_list = new Gee.ArrayList<HlsOption> ();
            var view_mode = new ModeButton () {
                hexpand = true,
                homogeneous = true,
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            view_mode.append_icon_text ("com.github.gabutakut.gabutdm.uri", _("Address"));
            view_mode.append_icon_text ("com.github.gabutakut.gabutdm.hdd", _("Option"));
            view_mode.selected = 0;

            var header = new Gtk.HeaderBar () {
                hexpand = true,
                decoration_layout = "none",
                title_widget = view_mode
            };
            set_titlebar (header);

            folder_location = new Gtk.Button () {
                tooltip_text = _("The directory to store the downloaded file")
            };
            folder_location.clicked.connect (()=> {
                string pathdir = hashoptions.@get (AriaOptions.DIR.to_string ()) == null? "" : hashoptions.@get (AriaOptions.DIR.to_string ());
                run_open_fd.begin (this, OpenFiles.OPENPERDONLOADFOLDER, pathdir, (obj, res)=> {
                    try {
                        GLib.File file = run_open_fd.end (res);
                        if (file != null) {
                            selectfd = file;
                        }
                    } catch (GLib.Error e) {
                        critical (e.message);
                    }
                });
            });
            selectfd = File.new_for_path (get_dbsetting (DBSettings.DIR));

            usefolder = new Gtk.CheckButton.with_label (_("Save to Folder")) {
                width_request = 200
            };
            usefolder.toggled.connect (()=> {
                folder_location.sensitive = usefolder.active;
            });
            ((Gtk.Label) usefolder.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            folder_location.sensitive = usefolder.active;

            link_entry = new MediaEntry ("com.github.gabutakut.gabutdm.uri", "edit-paste") {
                width_request = 150,
                placeholder_text = _("Paste here")
            };

            name_entry = new MediaEntry ("dialog-information", "edit-paste") {
                width_request = 150,
                placeholder_text = _("Follow source name")
            };

            fetch_btn = new Gtk.Button.from_icon_name ("com.github.gabutakut.gabutdm.sendrecv") {
                has_frame = false,
                tooltip_text = _("Fetch")
            };
            fetch_btn.clicked.connect(on_fetch_master_clicked);
            header.pack_end (fetch_btn);
            res_model = new Gtk.StringList(new string[] { "None" });

            res_dropdown = new Gtk.DropDown(res_model, null) {
                factory = facto_drpd ()
            };

            var addrquality = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            addrquality.append (headerlabel (_("Address:"), 390));
            addrquality.append (link_entry);
            addrquality.append (headerlabel (_("Qality:"), 390));
            addrquality.append (res_dropdown);
            addrquality.append (headerlabel (_("Filename:"), 390));
            addrquality.append (name_entry);

            var imagethumb = new Gtk.Image.from_icon_name ("com.github.gabutakut.gabutdm.ytb") {
                valign = Gtk.Align.CENTER,
                pixel_size = 128
            };
            picture_blurry = new Gtk.Picture () {
                valign = Gtk.Align.CENTER,
                width_request = 280,
                can_shrink = true
            };
            picture_sharp = new Gtk.Picture () {
                valign = Gtk.Align.CENTER,
                width_request = 280,
                can_shrink = true
            };
            thumb_stack = new Gtk.Stack () {
                valign = Gtk.Align.CENTER,
                transition_type = Gtk.StackTransitionType.CROSSFADE,
                transition_duration = 500
            };
            thumb_stack.add_named (imagethumb, "icon");
            thumb_stack.add_named (picture_blurry, "blur");
            thumb_stack.add_named (picture_sharp, "sharp");
            thumb_stack.set_visible_child_name ("icon");
            move_window (this, thumb_stack);

            var meta_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);

            duration_label = new Gtk.Label ("") {
                halign = Gtk.Align.END,
                valign = Gtk.Align.END,
                margin_end = 4,
                margin_bottom = 30,
                can_target = false,
                focusable = false,
                attributes = set_attribute (Pango.Weight.ULTRABOLD, 1.4, true)
            };
            var overlay = new Gtk.Overlay () {
                child = thumb_stack
            };
            overlay.add_overlay (duration_label);

            var info_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 8);
            info_box.append (overlay);
            info_box.append (addrquality);

            useragent_entry = new MediaEntry ("avatar-default", "edit-paste") {
                width_request = 200,
                placeholder_text = _("User Agent")
            };

            refer_entry = new MediaEntry.activable ("com.github.gabutakut.gabutdm.referer", "edit-paste") {
                width_request = 200,
                placeholder_text = _("Referer")
            };

            refer_entry.icon_press.connect ((icp)=> {
                if (icp == Gtk.EntryIconPosition.PRIMARY) {
                    if (refer_entry.text != "") {
                        open_fileman.begin (refer_entry.text);
                    }
                } else if (icp == Gtk.EntryIconPosition.SECONDARY) {
                    refer_entry.get_value.begin ();
                }
            });
            var moregrid = new Gtk.Grid () {
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            moregrid.attach (usefolder, 1, 1, 2, 1);
            moregrid.attach (folder_location, 1, 2, 2, 1);
            moregrid.attach (headerlabel (_("User Agent:"), 425), 1, 3, 1, 1);
            moregrid.attach (useragent_entry, 1, 4, 1, 1);
            moregrid.attach (headerlabel (_("Referer:"), 425), 1, 5, 1, 1);
            moregrid.attach (refer_entry, 1, 6, 1, 1);

            var stack = new Gtk.Stack () {
                transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT,
                transition_duration = 500,
                height_request = 210
            };
            stack.add_named (info_box, "info_box");
            stack.add_named (moregrid, "moregrid");
            stack.visible_child = info_box;
            stack.set_visible (true);

            var close_button = new Gtk.Button.with_label (_("Cancel")) {
                width_request = 120,
                height_request = 25
            };
            ((Gtk.Label) close_button.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            close_button.clicked.connect (()=> {
                if (cancellable != null) {
                    cancellable.cancel ();
                }
                close ();
            });

            start_button = new Gtk.Button.with_label (_("Download")) {
                width_request = 120,
                height_request = 25,
                sensitive = false
            };
            ((Gtk.Label) start_button.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            start_button.clicked.connect (()=> {
                set_option ();
                on_start_clicked (false);
            });

            later_button = new Gtk.Button.with_label (_("Download Later")) {
                width_request = 120,
                height_request = 25,
                sensitive = false
            };
            ((Gtk.Label) later_button.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            later_button.clicked.connect (()=> {
                set_option ();
                on_start_clicked (true);
            });

            save_button = new Gtk.Button.with_label (_("Save")) {
                width_request = 120,
                height_request = 25,
                sensitive = false
            };
            ((Gtk.Label) save_button.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            save_button.clicked.connect (()=> {
                set_option ();
                savetoaria ();
                close ();
            });
            var box_action = new Gtk.CenterBox () {
                margin_bottom = 10
            };

            switch (dialogtype) {
                case DialogType.PROPERTY:
                    var box_end = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
                    box_end.append (save_button);
                    box_end.append (close_button);
                    box_action.set_end_widget (box_end);
                    break;
                default:
                    var box_satart = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
                    box_satart.append (start_button);
                    box_satart.append (later_button);
                    box_action.set_start_widget (box_satart);
                    box_action.set_end_widget (close_button);
                    break;
            }
            var boxarea = new Gtk.Box (Gtk.Orientation.VERTICAL, 0) {
                margin_start = 10,
                margin_end = 10
            };
            boxarea.append (stack);
            boxarea.append (box_action);
            set_child (boxarea);

            view_mode.notify["selected"].connect (() => {
                switch (view_mode.selected) {
                    case 1:
                        stack.visible_child = moregrid;
                        break;
                    default:
                        stack.visible_child = info_box;
                        break;
                }
            });
        }

        public override bool close_request () {
            if (cancellable != null) {
                cancellable.cancel ();
            }
           return base.close_request ();
        }

        public override void close () {
            if (cancellable != null) {
                cancellable.cancel ();
            }
            base.close ();
        }

        private void on_fetch_master_clicked() {
            string url = link_entry.text;
            if (url == "" || !url.has_prefix("http")) {
                return;
            }
            thumb_stack.set_visible_child_name ("icon");
            fetch_btn.sensitive = false;
            new Thread<void> ("%s".printf (GLib.Checksum.compute_for_string (ChecksumType.MD5, url, url.length)), () => {
                try {
                    var sb = new GLib.StringBuilder();
                    string? urlh = hls_url (url);
                    if (urlh == "") {
                        throw new GLib.IOError.FAILED("Failed fetch");
                    }
                    sb.append (urlh);
                    parse_master_content ( url, sb.str);
                    MainContext.default ().invoke (() => {
                        update_dropdown_ui ();
                        fetch_btn.sensitive = save_button.sensitive = start_button.sensitive = later_button.sensitive = true;
                        if (!resolution) {
                            return false;
                        }
                        uint idx = res_dropdown.get_selected();
                        if (idx == Gtk.INVALID_LIST_POSITION || (int)idx >= options_list.size) {
                            return false;
                        }
                        var selected = options_list.get((int)idx);
                        load_urs (selected.url);
                        return GLib.Source.REMOVE;
                    });
                } catch (GLib.Error e) {
                    if (!cancellable.is_cancelled ()) {
                        fetch_btn.sensitive = true;
                    }
                }
            });
        }

        private void parse_master_content(string base_url, string txt) throws Error {
            options_list.clear();
            string[] lines = txt.split("gabuthls");
            string current_res = "Unknown";
            if (txt.contains("#EXT-X-STREAM-INF:")) {
                resolution = true;
                for (int i = 0; i < lines.length; i++) {
                    string line = lines[i].strip();
                    if (line.has_prefix("#EXT-X-STREAM-INF:")) {
                        current_res = extract_res_string(line);
                    } else if (line.length > 0 && !line.has_prefix("#")) {
                        string full_url = GLib.Uri.resolve_relative(base_url, line, GLib.UriFlags.NONE);
                        options_list.add(new HlsOption(current_res, full_url));
                        current_res = "Unknown";
                    }
                }
            } else {
                resolution = false;
                urlhls = null;
                string[] rescheck = null;
                foreach (string l in lines) {
                    string line = l.strip();
                    if (line.length == 0 || line.has_prefix("#")) {
                        continue;
                    }
                    string seg_url;
                    try {
                        seg_url = GLib.Uri.resolve_relative (base_url, line, GLib.UriFlags.NONE);
                    } catch (GLib.UriError e) {
                        continue;
                    }
                    rescheck += seg_url;
                    urlhls += line;
                }
                Soup.Session session = new Soup.Session ();
                string urlhl = rescheck[rescheck.length / 8];
                var ffmpeg = new Ffmpeg.Reader ();
                try {
                    GLib.Bytes? stream = session.send_and_read (full_message ("GET", urlhl, useragent_entry.text, headerc), cancellable);
                    if (stream == null) {
                        throw new GLib.IOError.FAILED("Error");
                    }
                    if (!cancellable.is_cancelled ()) {
                        uint8[] data = stream.get_data ();
                        ffmpeg.open_buffer(data);
                        thumnails (data);
                        current_res = @"[ $(resolution_label (ffmpeg.get_width(), ffmpeg.get_height())) ] $(ffmpeg.get_width())x$(ffmpeg.get_height())";
                        duration_label.label = @" $(rescheck.length) ";
                        options_list.add(new HlsOption (current_res, base_url));
                    }
                    stream = null;
                    ffmpeg = null;
                    rescheck = null;
                    lines = null;
                } catch (GLib.Error e) {
                    if (session != null) {
                        session.abort ();
                        session = null;
                    }
                } finally {
                    if (session != null) {
                        session.abort ();
                        session = null;
                    }
                }
            }
        }

        private void load_urs (string urls) {
            new Thread<void> ("%s".printf (GLib.Checksum.compute_for_string (ChecksumType.MD5, urls, urls.length)), () => {
                try {
                    Soup.Session sessions = new Soup.Session ();
                    var messs = full_message ("GET", urls, useragent_entry.text, headerc);
                    var streams = sessions.send(messs, cancellable);
                    if (!cancellable.is_cancelled ()) {
                        var diss = new GLib.DataInputStream(streams);
                        string lines;
                        string[] rescheck = null;
                        while ((lines = diss.read_line()) != null) {
                            string linex = lines.strip();
                            if (linex.length == 0 || linex.has_prefix("#")) {
                                continue;
                            }
                            string seg_url;
                            try {
                                seg_url = GLib.Uri.resolve_relative (urls, linex, GLib.UriFlags.NONE);
                            } catch (GLib.UriError e) {
                                continue;
                            }
                            rescheck += seg_url;
                        }
                        Soup.Session sessionx = new Soup.Session ();
                        string urlhl = rescheck[rescheck.length / 8];
                        GLib.Bytes? streamx = sessionx.send_and_read (full_message ("GET", urlhl, useragent_entry.text, headerc), cancellable);
                        if (!cancellable.is_cancelled ()) {
                            if (streamx == null) {
                                return;
                            }
                            thumnails (streamx.get_data ());
                            duration_label.label = @" $(rescheck.length) ";
                        }
                    }
                } catch (GLib.Error e) {}
            });
        }

        private void thumnails (uint8[] data) {
            var ffmpeg = new Ffmpeg.Reader ();
            int out_w, out_h, out_stride;
            uint8* ffdata = ffmpeg.ts_thumbnail_from_buffer (data, out out_w, out out_h, out out_stride);
            unowned uint8[] pixel_data = (uint8[]) ffdata;
            pixel_data.length = out_stride * out_h;
            if (pixel_data != null) {
                var pixbuf = new Gdk.Pixbuf.from_data(pixel_data, Gdk.Colorspace.RGB, false, 8, out_w, out_h, out_stride);
                load_thumbnail.begin (pixbuf);
            }
            ffmpeg = null;
        }

        private async void load_thumbnail (Gdk.Pixbuf pixbuf) throws Error {
            const int TARGET_W = 280;
            const int TARGET_H = 157;
            int src_w = pixbuf.get_width ();
            int src_h = pixbuf.get_height ();
            double scale = double.min ((double) TARGET_W / src_w, (double) TARGET_H / src_h);
            int scaled_w = (int) (src_w * scale);
            int scaled_h = (int) (src_h * scale);
            int offset_x = (TARGET_W - scaled_w) / 2;
            int offset_y = (TARGET_H - scaled_h) / 2;
            double tiny_scale = double.min (16.0 / src_w, 9.0 / src_h);
            int tiny_w = int.max (1, (int)(src_w * tiny_scale));
            int tiny_h = int.max (1, (int)(src_h * tiny_scale));
            var tiny = pixbuf.scale_simple (tiny_w, tiny_h, Gdk.InterpType.NEAREST);
            var blurry_canvas = new Gdk.Pixbuf (Gdk.Colorspace.RGB, false, 8, TARGET_W, TARGET_H);
            blurry_canvas.fill (0x000000ff);
            var blurry_scaled = tiny.scale_simple (scaled_w, scaled_h, Gdk.InterpType.BILINEAR);
            blurry_scaled.copy_area (0, 0, scaled_w, scaled_h, blurry_canvas, offset_x, offset_y);
            var sharp_canvas = new Gdk.Pixbuf (Gdk.Colorspace.RGB, false, 8, TARGET_W, TARGET_H);
            sharp_canvas.fill (0x000000ff);
            var sharp_scaled = pixbuf.scale_simple (scaled_w, scaled_h, Gdk.InterpType.BILINEAR);
            sharp_scaled.copy_area (0, 0, scaled_w, scaled_h, sharp_canvas, offset_x, offset_y);
            picture_blurry.set_paintable (Gdk.Texture.for_pixbuf (blurry_canvas));
            thumb_stack.set_visible_child_name ("blur");
            Idle.add (load_thumbnail.callback);
            yield;
            picture_sharp.set_paintable (Gdk.Texture.for_pixbuf (sharp_canvas));
            thumb_stack.set_visible_child_name ("sharp");
        }

        private void on_start_clicked(bool start) {
            var sb = new GLib.StringBuilder();
            sb.append(link_entry.text).append("gabuthls");
            if (resolution) {
                uint idx = res_dropdown.get_selected();
                if (idx == Gtk.INVALID_LIST_POSITION || (int)idx >= options_list.size) {
                    return;
                }
                start_button.sensitive = later_button.sensitive = false;
                var selected = options_list.get((int)idx).url;
                new Thread<void> ("%s".printf (GLib.Checksum.compute_for_string (ChecksumType.MD5, selected, selected.length)), () => {
                    try {
                        string? urlh = hls_url (selected);
                        if (urlh == "") {
                            throw new GLib.IOError.FAILED("Failed fetch");
                        }
                        sb.append(urlh);
                        MainContext.default ().invoke (() => {
                            downloadfile (sb.str, hashoptions, start, LinkMode.HLS);
                            close ();
                            return GLib.Source.REMOVE;
                        });
                    } catch (GLib.Error e) {
                        start_button.sensitive = later_button.sensitive = true;
                        set_visible (true);
                    }
                });
                set_visible (false);
            } else {
                foreach (var line in urlhls) {
                    sb.append(line).append ("gabuthls");
                }
                downloadfile (sb.str, hashoptions, start, LinkMode.HLS);
                close ();
            }
        }

        private string extract_res_string (string line) throws Error {
            var regex = new GLib.Regex("RESOLUTION=([0-9]+x[0-9]+)");
            GLib.MatchInfo match;
            if (regex.match(line, 0, out match)) {
                return "[ %s ] %s".printf (resolution_label (int.parse (match.fetch(1).split ("x")[0]), int.parse (match.fetch(1).split ("x")[1])), match.fetch(1));
            }
            return "Unknown";
        }

        private string hls_url (string gbturl) throws Error {
            var sb = new GLib.StringBuilder();
            Soup.Session session = new Soup.Session ();
            var mess = full_message ("GET", gbturl, useragent_entry.text, headerc);
            var stream = session.send(mess, cancellable);
            if (!cancellable.is_cancelled ()) {
                var dis = new GLib.DataInputStream(stream);
                string line;
                while ((line = dis.read_line ()) != null) {
                    sb.append(line).append("gabuthls");
                }
                stream.close ();
                dis.close ();
                if (session != null) {
                    session.abort ();
                    session = null;
                }
                mess = null;
                return sb.str;
            }
            return "";
        }

        private void update_dropdown_ui() {
            string[] items = {};
            foreach (var opt in options_list) {
                items += opt.resolution;
            }
            if (items.length > 0) {
                res_model.splice(0, res_model.get_n_items (), items);
            }
        }

        private void set_option () {
            hashoptions.clear ();
            if (usefolder.active) {
                hashoptions[AriaOptions.DIR.to_string ()] = selectfd.get_path ();
            } else {
                if (hashoptions.has_key (AriaOptions.DIR.to_string ())) {
                    hashoptions.unset (AriaOptions.DIR.to_string ());
                }
            }
            if (refer_entry.text.strip () != "") {
                hashoptions[AriaOptions.REFERER.to_string ()] = refer_entry.text.strip ();
            } else {
                if (hashoptions.has_key (AriaOptions.REFERER.to_string ())) {
                    hashoptions.unset (AriaOptions.REFERER.to_string ());
                }
            }
            if (name_entry.text.strip () != "") {
                hashoptions[AriaOptions.OUT.to_string ()] = name_entry.text.strip ();
            } else {
                if (hashoptions.has_key (AriaOptions.OUT.to_string ())) {
                    hashoptions.unset (AriaOptions.OUT.to_string ());
                }
            }
            if (useragent_entry.text.strip () != "") {
                hashoptions[AriaOptions.USER_AGENT.to_string ()] = useragent_entry.text.strip ();
            } else {
                if (hashoptions.has_key (AriaOptions.USER_AGENT.to_string ())) {
                    hashoptions.unset (AriaOptions.USER_AGENT.to_string ());
                }
            }
            if (headerc != "" && headerc != null) {
                hashoptions[AriaOptions.HEADER.to_string ()] = headerc;
            }
        }

        private void savetoaria () {
            var sb = new GLib.StringBuilder();
            sb.append(link_entry.text).append("gabuthls");
            if (resolution) {
                uint idx = res_dropdown.get_selected();
                if (idx == Gtk.INVALID_LIST_POSITION || (int)idx >= options_list.size) {
                    return;
                }
                try {
                    var selected = options_list.get((int)idx);
                    string? urlh = hls_url (selected.url);
                    if (urlh == "") {
                        throw new GLib.IOError.FAILED("Failed fetch");
                    }
                    sb.append(urlh);
                    row.update_url (hashoptions, name_entry.text, sb.str);
                } catch (GLib.Error e) {
                }
            } else {
                foreach (var line in urlhls) {
                    sb.append(line).append("gabuthls");
                }
                row.update_url (hashoptions, name_entry.text, sb.str);
            }
            if (!db_option_exist (row.url)) {
                set_dboptions (row.url, hashoptions);
            } else {
                update_optionts (row.url, hashoptions);
            }
            close ();
        }

        public override void show () {
            if (row != null) {
                name_entry.text = row.filename;
                link_entry.text = row.url.split ("gabuthls")[0];
                useragent_entry.text = row.hashoption.@get(AriaOptions.USER_AGENT.to_string ());
                refer_entry.text = row.hashoption.@get(AriaOptions.REFERER.to_string ());
                usefolder.active = hashoptions.has_key (AriaOptions.DIR.to_string ());
                if (usefolder.active) {
                    selectfd = File.new_for_path (hashoptions.@get (AriaOptions.DIR.to_string ()));
                }
            }
            base.show ();
        }
    }
}