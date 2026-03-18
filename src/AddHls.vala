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
        public signal void downloadfile (string url, Gee.HashMap<string, string> options, bool later, int linkmode);
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
        private Cancellable cancel = new Cancellable ();
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
            options_list = new Gee.ArrayList<HlsOption>();
            var view_mode = new ModeButton () {
                hexpand = true,
                homogeneous = true,
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            view_mode.append_text (_("Address"));
            view_mode.append_text (_("Option"));
            view_mode.selected = 0;

            var header = get_header_bar ();
            header.title_widget = view_mode;
            header.decoration_layout = "none";

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

            fetch_btn = new Gtk.Button.with_label("Fetch");
            fetch_btn.clicked.connect(on_fetch_master_clicked);
            res_model = new Gtk.StringList(new string[] { "None" });
            res_dropdown = new Gtk.DropDown(res_model, null);

            var alllink = new Gtk.Grid () {
                column_spacing = 10,
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            alllink.attach (headerlabel (_("Address:"), 660), 0, 0, 2, 1);
            alllink.attach (link_entry, 0, 1, 2, 1);
            alllink.attach (headerlabel (_("Qality:"), 650), 0, 2, 2, 1);
            alllink.attach (fetch_btn, 0, 3, 1, 1);
            alllink.attach (res_dropdown, 1, 3, 1, 1);
            alllink.attach (headerlabel (_("Filename:"), 425), 0, 5, 2, 1);
            alllink.attach (name_entry, 0, 6, 2, 1);

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
            stack.add_named (alllink, "alllink");
            stack.add_named (moregrid, "moregrid");
            stack.visible_child = alllink;
            stack.show ();

            var close_button = new Gtk.Button.with_label (_("Cancel")) {
                width_request = 120,
                height_request = 25
            };
            ((Gtk.Label) close_button.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            close_button.clicked.connect (()=> {
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
                margin_top = 10,
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
            var boxarea = get_content_area ();
            boxarea.margin_start = 10;
            boxarea.margin_end = 10;
            boxarea.append (stack);
            boxarea.append (box_action);

            view_mode.notify["selected"].connect (() => {
                switch (view_mode.selected) {
                    case 1:
                        stack.visible_child = moregrid;
                        break;
                    default:
                        stack.visible_child = alllink;
                        break;
                }
            });
        }

        public override bool close_request () {
           return base.close_request ();
        }

        public override void close () {
            cancel.cancel ();
            base.close ();
        }

        private void on_fetch_master_clicked() {
            string url = link_entry.text;
            if (url == "" || !url.has_prefix("http")) {
                return;
            }
            fetch_btn.sensitive = false;
            new Thread<void> ("%s".printf (get_monotonic_time ().to_string ()), () => {
                while (!cancel.is_cancelled ()) {
                    try {
                        var session = SoupSessionPool.get_default().acquire();
                        var mess = full_message ("GET", url, useragent_entry.text);
                        var stream = session.send(mess);
                        var dis = new GLib.DataInputStream(stream);
                        var sb = new GLib.StringBuilder();
                        string line;
                        while ((line = dis.read_line()) != null) {
                            sb.append(line).append("gabuthls");
                        }
                        SoupSessionPool.get_default().release(session);
                        stream.close ();
                        dis.close ();
                        mess = null;
                        parse_master_content (url, sb.str);
                        MainContext.default ().invoke (() => {
                            update_dropdown_ui();
                            fetch_btn.sensitive = save_button.sensitive = start_button.sensitive = later_button.sensitive = true;
                            return false;
                        });
                        break;
                    } catch (GLib.Error e) {
                        fetch_btn.sensitive = true;
                        break;
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
                        seg_url = GLib.Uri.resolve_relative(base_url, line, GLib.UriFlags.NONE);
                    } catch (GLib.UriError e) {
                        continue;
                    }
                    rescheck += seg_url;
                    urlhls += line;
                }
                var ffmpeg = new Ffmpeg.Reader();
                var session = SoupSessionPool.get_default().acquire();
                GLib.Bytes stream = session.send_and_read(full_message ("GET", rescheck[0], useragent_entry.text));
                ffmpeg.open_buffer(stream.get_data());
                current_res = @"$(ffmpeg.get_width())x$(ffmpeg.get_height())";
                options_list.add(new HlsOption(current_res, base_url));
                SoupSessionPool.get_default().release(session);
                stream = null;
                ffmpeg = null;
                rescheck = null;
                lines = null;
            }
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
                new Thread<void> ("%s".printf (get_monotonic_time ().to_string ()), () => {
                    try {
                        var selected = options_list.get((int)idx);
                        var session = SoupSessionPool.get_default().acquire();
                        var mess = full_message ("GET", selected.url, useragent_entry.text);
                        var stream = session.send(mess);
                        var dis = new GLib.DataInputStream(stream);
                        string line;
                        while ((line = dis.read_line()) != null) {
                            sb.append(line).append("gabuthls");
                        }
                        SoupSessionPool.get_default().release(session);
                        stream.close ();
                        dis.close ();
                        mess = null;
                        MainContext.default ().invoke (() => {
                            downloadfile (sb.str, hashoptions, start, LinkMode.HLS);
                            close ();
                            return GLib.Source.REMOVE;
                        });
                    } catch (GLib.Error e) {
                        start_button.sensitive = later_button.sensitive = true;
                        show ();
                    }
                });
                hide ();
            } else {
                foreach (var line in urlhls) {
                    sb.append(line).append("gabuthls");
                }
                downloadfile (sb.str, hashoptions, start, LinkMode.HLS);
                close ();
            }
        }

        private string extract_res_string(string line) throws Error {
            var regex = new GLib.Regex("RESOLUTION=([0-9]+x[0-9]+)");
            GLib.MatchInfo match;
            if (regex.match(line, 0, out match)) {
                return match.fetch(1);
            }
            return "Unknown";
        }

        private void update_dropdown_ui() {
            string[] items = {};
            foreach (var opt in options_list) {
                items += opt.resolution;
            }
            if (items.length > 0) {
                res_model.splice(0, res_model.get_n_items(), items);
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
                    var session = SoupSessionPool.get_default().acquire();
                    var mess = full_message ("GET", selected.url, useragent_entry.text);
                    var stream = session.send(mess);
                    var dis = new GLib.DataInputStream(stream);
                    string line;
                    while ((line = dis.read_line()) != null) {
                        sb.append(line).append("gabuthls");
                    }
                    row.update_url (hashoptions, name_entry.text, sb.str);
                    SoupSessionPool.get_default().release(session);
                    stream.close ();
                    dis.close ();
                    mess = null;
                } catch (GLib.Error e) {}
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
            base.show ();
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
        }
    }
}