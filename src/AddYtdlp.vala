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
    public class AddYtdlp : Gtk.Dialog {
        public signal void downloadfile (string url, Gee.HashMap<string, string> options, bool later, int linkmode, bool server = false);
        public signal void update_agid (string ariagid, string newgid);
        public Gtk.Button save_button;
        public Gtk.Button start_button;
        public Gtk.Button later_button;
        public Gtk.Entry refer_entry;
        public Gtk.Entry url_entry;
        public DownloadRow row;
        public DialogType dialogtype { get; construct; }
        private Gtk.CheckButton usefolder;
        private Gtk.Button folder_location;
        private MediaEntry useragent_entry;
        private MediaEntry name_entry;
        private Gtk.Image menuimg;
        private Gtk.Image stsimg;
        private Gee.HashMap<string, string> hashoptions;
        private MediaEntry proxy_entry;
        private Gtk.SpinButton port_entry;
        private MediaEntry user_entry;
        private MediaEntry pass_entry;
        private Gtk.MenuButton savedproxy;
        private Gtk.MenuButton type_button;
        private Gtk.FlowBox save_flow;
        private Gtk.FlowBox type_flow;
        private ModeButton formatid;
        private Gtk.Button fetch_btn;
        private Gtk.Spinner spinner;
        private Gtk.Label duration_label;
        private Gtk.DropDown mp4_video_dd;
        private Gtk.DropDown webm_video_dd;
        private Gtk.DropDown audio_dropdown;
        private Gtk.DropDown m4a_audio_dd;
        private Gtk.DropDown opus_audio_dd;
        private GLib.ListStore mp4_video_m;
        private GLib.ListStore webm_video_m;
        private GLib.ListStore audio_model;
        private GLib.ListStore m4a_audio_m;
        private GLib.ListStore opus_audio_m;
        private Gtk.Stack video_stack;
        private Gtk.Stack audio_stack;
        private Gtk.Stack box_stack;
        private Soup.Session http_session;
        private ModeButton view_mode;
        private Gtk.Stack thumb_stack;
        private Gtk.Picture picture_blurry;
        private Gtk.Picture picture_sharp;

        ProxyRecently _myrcproxy = null;
        ProxyRecently myrcproxy {
            get {
                return _myrcproxy;
            }
            set {
                _myrcproxy = value;
                savedproxy.label = _("%s").printf (_myrcproxy.myproxy.to_string ());
            }
        }

        ProxyType _proxytype = null;
        ProxyType proxytype {
            get {
                return _proxytype;
            }
            set {
                _proxytype = value;
                type_button.label = _proxytype.proxytype.to_string ();
            }
        }

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

        private string _headerc;
        public string headerc {
            get {
                return _headerc;
            }
            set {
                _headerc = value;
            }
        }

        public AddYtdlp() {
            Object (dialogtype: DialogType.YTDLP, resizable: false, use_header_bar: 1);
        }

        public AddYtdlp.Property() {
            Object (dialogtype: DialogType.PROPERTY, resizable: false, use_header_bar: 1);
        }

        construct {
            http_session = new Soup.Session () {
                timeout = 60
            };
            hashoptions = new Gee.HashMap<string, string> ();
            mp4_video_m = new GLib.ListStore (typeof (FormatItem));
            webm_video_m = new GLib.ListStore (typeof (FormatItem));
            audio_model = new GLib.ListStore (typeof (FormatItem));
            m4a_audio_m = new GLib.ListStore (typeof (FormatItem));
            opus_audio_m = new GLib.ListStore (typeof (FormatItem));

            formatid = new ModeButton () {
                hexpand = true,
                homogeneous = true,
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            formatid.append_icon_text ("com.github.gabutakut.gabutdm.ytb",_("MP4"));
            formatid.append_icon_text ("com.github.gabutakut.gabutdm.ytb", _("WEBM"));
            formatid.append_icon_text ("audio-x-generic", _("MP3"));
            formatid.selected = 0;

            fetch_btn = new Gtk.Button.from_icon_name ("com.github.gabutakut.gabutdm.sendrecv") {
                has_frame = false,
                tooltip_text = _("Fetch")
            };
            fetch_btn.clicked.connect (on_fetch_clicked);
            stsimg = new Gtk.Image.from_icon_name ("com.github.gabutakut.gabutdm.default") {
                visible = false
            };

            spinner = new Gtk.Spinner ();
            menuimg = new Gtk.Image.from_icon_name ("com.github.gabutakut.gabutdm.default");
            var add_open = new Gtk.MenuButton () {
                child = menuimg,
                direction = Gtk.ArrowType.UP,
                has_frame = false,
                popover = get_openmenu (),
                tooltip_text = _("Info Format")
            };

            var status_bar = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 4);
            status_bar.append (add_open);
            status_bar.append (stsimg);
            status_bar.append (spinner);

            var header = new Gtk.HeaderBar () {
                title_widget = formatid,
                hexpand = true,
                decoration_layout = "none",
            };
            set_titlebar (header);
            header.pack_end (fetch_btn);
            header.pack_start (status_bar);
            var imagethumb = new Gtk.Image.from_icon_name ("com.github.gabutakut.gabutdm.ytb") {
                pixel_size = 128
            };
            picture_blurry = new Gtk.Picture () {
                width_request = 280,
                can_shrink = true
            };
            picture_sharp = new Gtk.Picture () {
                width_request = 280,
                can_shrink = true
            };
            thumb_stack = new Gtk.Stack () {
                transition_type = Gtk.StackTransitionType.CROSSFADE,
                transition_duration = 500
            };
            thumb_stack.add_named (imagethumb, "icon");
            thumb_stack.add_named (picture_blurry, "blur");
            thumb_stack.add_named (picture_sharp, "sharp");
            thumb_stack.set_visible_child_name ("icon");

            var overlay = new Gtk.Overlay () {
                child = thumb_stack
            };
            move_window (this, thumb_stack);

            var meta_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);

            duration_label = new Gtk.Label ("") {
                halign = Gtk.Align.END,
                valign = Gtk.Align.END,
                margin_end = 4,
                margin_bottom = 4,
                can_target = false,
                focusable = false,
                attributes = set_attribute (Pango.Weight.ULTRABOLD, 1.4, true)
            };
            overlay.add_overlay (duration_label);

            var info_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 8);
            info_box.append (overlay);
            info_box.append (meta_box);

            var v_label = new Gtk.Label ("Video:") {
                use_markup = true,
                halign = Gtk.Align.START,
                attributes = set_attribute (Pango.Weight.ULTRABOLD, 1.0)
            };

            mp4_video_dd = new Gtk.DropDown (mp4_video_m, new Gtk.PropertyExpression (typeof (FormatItem), null, "label")) {
                factory = factory_drpd ()
            };
            mp4_video_dd.notify["selected"].connect (on_video_selection_changed);

            webm_video_dd = new Gtk.DropDown (webm_video_m, new Gtk.PropertyExpression (typeof (FormatItem), null, "label")) {
                factory = factory_drpd ()
            };
            webm_video_dd.notify["selected"].connect (on_video_selection_changed);

            video_stack = new Gtk.Stack ();
            video_stack.add_child (mp4_video_dd);
            video_stack.add_child (webm_video_dd);

            var a_label = new Gtk.Label ("Audio:") {
                use_markup = true,
                halign = Gtk.Align.START,
                attributes = set_attribute (Pango.Weight.ULTRABOLD, 1.0)
            };
            audio_dropdown = new Gtk.DropDown (audio_model, new Gtk.PropertyExpression (typeof (FormatItem), null, "label")) {
                factory = factory_drpd ()
            };

            m4a_audio_dd = new Gtk.DropDown (m4a_audio_m, new Gtk.PropertyExpression (typeof (FormatItem), null, "label")) {
                factory = factory_drpd ()
            };

            opus_audio_dd = new Gtk.DropDown (opus_audio_m, new Gtk.PropertyExpression (typeof (FormatItem), null, "label")) {
                factory = factory_drpd ()
            };

            audio_stack = new Gtk.Stack ();
            audio_stack.add_child (m4a_audio_dd);
            audio_stack.add_child (opus_audio_dd);
            audio_stack.add_child (audio_dropdown);

            var f_label = new Gtk.Label ("Filename:") {
                use_markup = true,
                halign = Gtk.Align.START,
                attributes = set_attribute (Pango.Weight.ULTRABOLD, 1.0)
            };
            name_entry = new MediaEntry ("dialog-information", "edit-paste") {
                width_request = 380,
                placeholder_text = _("Follow source name")
            };
            meta_box.append (v_label);
            meta_box.append (video_stack);
            meta_box.append (a_label);
            meta_box.append (audio_stack);
            meta_box.append (f_label);
            meta_box.append (name_entry);

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
                on_download (false);
                close ();
            });

            later_button = new Gtk.Button.with_label (_("Download Later")) {
                width_request = 120,
                height_request = 25,
                sensitive = false
            };
            ((Gtk.Label) later_button.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            later_button.clicked.connect (()=> {
                on_download (true);
                close ();
            });

            save_button = new Gtk.Button.with_label (_("Save")) {
                width_request = 120,
                height_request = 25
            };
            ((Gtk.Label) save_button.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            save_button.clicked.connect (()=> {
                set_option ();
                save_to_aria ();
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

            url_entry = new MediaEntry ("com.github.gabutakut.gabutdm.uri", "edit-paste") {
                margin_bottom = 6,
                width_request = 380,
                placeholder_text = _("Paste here")
            };
            url_entry.changed.connect (()=> {
                on_fetch_clicked ();
            });
            var sel_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6) {
                margin_top = 8
            };
            sel_box.append (info_box);
            sel_box.append (url_entry);

            save_flow = new Gtk.FlowBox ();
            foreach (var mprx in MyProxy.get_all ()) {
                save_flow.append (new ProxyRecently (mprx));
            }

            var saved_popover = new Gtk.Popover () {
                child = save_flow
            };
            savedproxy = new Gtk.MenuButton () {
                popover = saved_popover
            };
            save_flow.set_visible (true);
            myrcproxy = save_flow.get_child_at_index (0) as ProxyRecently;
            ((Gtk.Label)myrcproxy.get_last_child ()).attributes = color_attribute (0, 60000, 0);

            type_flow = new Gtk.FlowBox ();
            var type_popover = new Gtk.Popover () {
                child = type_flow
            };
            type_button = new Gtk.MenuButton () {
                margin_top = 6,
                sensitive = myrcproxy.myproxy != MyProxy.NONE,
                popover = type_popover
            };
            foreach (var typepr in ProxyTypes.get_all ()) {
                type_flow.append (new ProxyType (typepr));
            }
            type_flow.set_visible (true);
            type_flow.child_activated.connect ((typepr)=> {
                ((Gtk.Label)((ProxyType) proxytype).get_last_child ()).attributes = set_attribute (Pango.Weight.BOLD);
                proxytype = typepr as ProxyType;
                ((Gtk.Label)proxytype.get_last_child ()).attributes = color_attribute (0, 60000, 0);
                type_popover.set_visible (false);
            });
            proxytype = type_flow.get_child_at_index (0) as ProxyType;
            ((Gtk.Label)proxytype.get_last_child ()).attributes = color_attribute (0, 60000, 0);
            type_popover.show.connect (() => {
                type_flow.unselect_all ();
            });

            proxy_entry = new MediaEntry ("com.github.gabutakut.gabutdm.gohome", "edit-paste") {
                width_request = 200,
                sensitive = myrcproxy.myproxy != MyProxy.NONE,
                placeholder_text = _("http, https, ftp, i2p = ALL")
            };

            port_entry = new Gtk.SpinButton.with_range (0, 999999, 1) {
                tooltip_text = _("Port"),
                sensitive = myrcproxy.myproxy != MyProxy.NONE,
                width_request = 200
            };

            user_entry = new MediaEntry ("avatar-default", "edit-paste") {
                width_request = 200,
                sensitive = myrcproxy.myproxy != MyProxy.NONE,
                placeholder_text = _("Username")
            };

            pass_entry = new MediaEntry ("dialog-password", "edit-paste") {
                width_request = 200,
                sensitive = myrcproxy.myproxy != MyProxy.NONE,
                placeholder_text = _("Password")
            };
            save_flow.child_activated.connect ((typepro)=> {
                ((Gtk.Label)((ProxyRecently) myrcproxy).get_last_child ()).attributes = set_attribute (Pango.Weight.BOLD);
                myrcproxy = typepro as ProxyRecently;
                ((Gtk.Label)myrcproxy.get_last_child ()).attributes = color_attribute (0, 60000, 0);
                pass_entry.sensitive = user_entry.sensitive = port_entry.sensitive = proxy_entry.sensitive = type_button.sensitive = myrcproxy.myproxy != MyProxy.NONE;
                ((Gtk.Label)((ProxyType) proxytype).get_last_child ()).attributes = set_attribute (Pango.Weight.BOLD);
                var mprxy = get_myproxy ();
                proxytype = type_flow.get_child_at_index (mprxy.typepr) as ProxyType;
                type_flow.child_activated (proxytype);
                proxy_entry.text = mprxy.host;
                port_entry.value = int.parse (mprxy.port);
                user_entry.text = mprxy.user;
                pass_entry.text = mprxy.passwd;
                saved_popover.set_visible (false);
            });

            saved_popover.show.connect (() => {
                save_flow.unselect_all ();
            });

            var proxygrid = new Gtk.Grid () {
                height_request = 130,
                column_spacing = 10,
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            proxygrid.attach (savedproxy, 0, 1, 2, 1);
            proxygrid.attach (type_button, 0, 2, 2, 1);
            proxygrid.attach (headerlabel (_("Host:"), 300), 0, 3, 1, 1);
            proxygrid.attach (proxy_entry, 0, 4, 1, 1);
            proxygrid.attach (headerlabel (_("Port:"), 300), 1, 3, 1, 1);
            proxygrid.attach (port_entry, 1, 4, 1, 1);
            proxygrid.attach (headerlabel (_("Username:"), 300), 0, 5, 1, 1);
            proxygrid.attach (user_entry, 0, 6, 1, 1);
            proxygrid.attach (headerlabel (_("Password:"), 300), 1, 5, 1, 1);
            proxygrid.attach (pass_entry, 1, 6, 1, 1);

            folder_location = new Gtk.Button () {
                tooltip_text = _("The directory to store the downloaded file")
            };
            folder_location.clicked.connect (()=> {
                string pathdir = hashoptions.@get (AriaOptions.DIR.to_string ()) == null? "" : hashoptions.@get (AriaOptions.DIR.to_string ()).replace ("\\/", "/");
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
            selectfd = File.new_for_path (get_dbsetting (DBSettings.DIR).replace ("\\/", "/"));

            usefolder = new Gtk.CheckButton.with_label (_("Save to Folder")) {
                width_request = 240
            };
            usefolder.toggled.connect (()=> {
                folder_location.sensitive = usefolder.active;
            });
            ((Gtk.Label) usefolder.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            folder_location.sensitive = usefolder.active;

            useragent_entry = new MediaEntry ("avatar-default", "edit-paste") {
                width_request = 350,
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
                    ((MediaEntry)refer_entry).get_value.begin ();
                }
            });
            var moregrid = new Gtk.Grid () {
                height_request = 130,
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            moregrid.attach (usefolder, 1, 0, 1, 1);
            moregrid.attach (folder_location, 1, 1, 1, 1);
            moregrid.attach (headerlabel (_("User Agent:"), 425), 1, 2, 1, 1);
            moregrid.attach (useragent_entry, 1, 3, 1, 1);
            moregrid.attach (headerlabel (_("Referer:"), 425), 1, 4, 1, 1);
            moregrid.attach (refer_entry, 1, 5, 1, 1);
    
            formatid.notify["selected"].connect (() => {
                video_stack.sensitive = true;
                switch (formatid.selected) {
                    case 1:
                        video_stack.visible_child = webm_video_dd;
                        audio_stack.visible_child = opus_audio_dd;
                        break;
                    case 2:
                        video_stack.sensitive = false;
                        audio_stack.visible_child = audio_dropdown;
                        break;
                    default:
                        video_stack.visible_child = mp4_video_dd;
                        audio_stack.visible_child = m4a_audio_dd;
                    break;
                }
            });

            box_stack = new Gtk.Stack () {
                transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT,
                transition_duration = 500,
                width_request = 680,
                height_request = 210,
                visible = true
            };
            box_stack.add_named (sel_box, "sel_box");
            box_stack.add_named (proxygrid, "proxygrid");
            box_stack.add_named (moregrid, "moregrid");
            box_stack.visible_child = sel_box;

            var root = new Gtk.Box (Gtk.Orientation.VERTICAL, 0) {
                margin_start = 10,
                margin_end = 10
            };
            root.append (box_stack);
            root.append (box_action);
            set_child (root);
        }

        public Gtk.Popover get_openmenu () {
            view_mode = new ModeButton () {
                orientation = Gtk.Orientation.VERTICAL,
                hexpand = true,
                homogeneous = true,
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            view_mode.append_icon_text ("com.github.gabutakut.gabutdm.default",_("Info Format"));
            view_mode.append_icon_text ("com.github.gabutakut.gabutdm.proxy",_("Proxy"));
            view_mode.append_icon_text ("com.github.gabutakut.gabutdm.hdd",_("Options"));
            view_mode.selected = 0;

            var popovermenu = new Gtk.Popover () {
                child = view_mode
            };
            popovermenu.show.connect (() => {
                popovermenu.position = Gtk.PositionType.BOTTOM;
            });
            view_mode.notify["selected"].connect (() => {
                popovermenu.visible = false;
                menuimg.icon_name = view_mode.get_icon_name (view_mode.selected);
                menuimg.tooltip_text = view_mode.get_view_name (view_mode.selected);
                switch (view_mode.selected) {
                    case 1:
                        box_stack.visible_child_name = "proxygrid";
                        break;
                    case 2:
                        box_stack.visible_child_name = "moregrid";
                        break;
                    default:
                        box_stack.visible_child_name = "sel_box";
                        break;
                }
            });
            return popovermenu;
        }

        private void on_video_selection_changed () {
            var mselected = mp4_video_dd.get_selected_item () as FormatItem;
            var wselected = webm_video_dd.get_selected_item () as FormatItem;
            if (mselected != null) {
                m4a_audio_dd.set_sensitive (!mselected.has_audio);
            }
            if (wselected != null) {
                opus_audio_dd.set_sensitive (!wselected.has_audio);
            }
        }
        private void on_fetch_clicked () {
            string url = url_entry.get_text ().strip ();
            if (url != "") {
                thumb_stack.set_visible_child_name ("icon");
                if (url.contains ("gabutytb")) {
                    do_fetch.begin (url.split ("gabutytb")[0]);
                } else {
                    do_fetch.begin (url);
                }
            }
        }

        private async void do_fetch (string url) {
            set_loading (true);
            stsimg.icon_name = "com.github.gabutakut.gabutdm.complete";
            stsimg.tooltip_text = _("Connecting…");
            var root_obj = new Json.Object ();
            root_obj.set_string_member ("jsonrpc", "2.0");
            root_obj.set_string_member ("method", "info");
            var p = new Json.Object ();
            p.set_string_member ("url", url);
            root_obj.set_object_member ("params", p);
            root_obj.set_int_member ("id", 1);
            var gen = new Json.Generator ();
            var node = new Json.Node (Json.NodeType.OBJECT);
            node.set_object (root_obj);
            gen.set_root (node);
            string payload = gen.to_data (null);
            var msg = new Soup.Message ("POST", @"http://localhost:$(gbtytbport)");
            msg.set_request_body_from_bytes ("application/json", new GLib.Bytes (payload.data));
            try {
                var bytes = yield http_session.send_and_read_async (msg, GLib.Priority.DEFAULT, null);
                if (msg.get_status () == 200) {
                    var stream = new GLib.MemoryInputStream.from_bytes (bytes);
                    var parser = new Json.Parser ();
                    yield parser.load_from_stream_async (stream, null);
                    var res_root = parser.get_root ().get_object ();
                    if (res_root.has_member ("error")) {
                        var err_obj = res_root.get_object_member ("error");
                        string err_msg = err_obj.has_member ("message")? err_obj.get_string_member ("message") : _("Unknown error");
                        stsimg.icon_name = "com.github.gabutakut.gabutdm.error";
                        stsimg.tooltip_text = _("❌ %s".printf (err_msg));
                    } else if (res_root.has_member ("result")) {
                        var result = res_root.get_object_member ("result");
                        string user_agent = result.has_member ("user_agent") ? result.get_string_member ("user_agent") : "";
                        string cookie_str = result.has_member ("cookie_header") ? result.get_string_member ("cookie_header"): "";
                        if (cookie_str != "") {
                            headerc = cookie_str;
                        }
                        if (user_agent != "") {
                            useragent_entry.text = user_agent;
                        }
                        update_ui_with_result (res_root.get_object_member ("result"));
                        stsimg.icon_name = "com.github.gabutakut.gabutdm.complete";
                        stsimg.tooltip_text = _("✓ Done.");
                    }
                } else {
                    stsimg.icon_name = "com.github.gabutakut.gabutdm.error";
                    stsimg.tooltip_text = _("✗ Server Error: %u".printf (msg.get_status ()));
                }
            } catch (GLib.Error e) {
                stsimg.icon_name = "com.github.gabutakut.gabutdm.error";
                stsimg.tooltip_text = _("❌ Failed: %s".printf (e.message));
            }
            set_loading (false);
        }

        private void update_ui_with_result (Json.Object res) throws Error {
            name_entry.text = res.get_string_member ("title") ?? "Unknown";
            duration_label.set_text (" %s ".printf (seconds_to_time((int)res.get_int_member ("duration"))));
            string thumb = res.get_string_member ("thumbnail") ?? "";
            if (thumb != "") {
                load_thumbnail.begin (thumb);
            }
            mp4_video_m.remove_all ();
            webm_video_m.remove_all ();
            audio_model.remove_all ();
            m4a_audio_m.remove_all ();
            opus_audio_m.remove_all ();
            if (res.has_member ("formats")) {
                var fmts = res.get_array_member ("formats");
                var item0 = new FormatItem ("none", "Not Set", "", 0, "", false, false);
                m4a_audio_m.append (item0);
                opus_audio_m.append (item0);
                fmts.foreach_element ((arr, idx, node) => {
                    var f = node.get_object ();
                    string fid = f.get_string_member ("format_id");
                    string ext = f.get_string_member ("ext");
                    string res_str = f.get_string_member ("resolution") ?? "audio";
                    int64 size = f.get_int_member ("filesize");
                    string f_url = f.get_string_member ("url");
                    string vcodec = f.get_string_member ("vcodec") ?? "none";
                    string acodec = f.get_string_member ("acodec") ?? "none";
                    bool is_v = (vcodec != "none");
                    bool has_a = (acodec != "none");
                    if (is_v) {
                        string resolusi = "";
                        if (res_str.contains ("x")) {
                            resolusi = resolution_label (int.parse (res_str.split ("x")[0]), int.parse (res_str.split ("x")[1]));
                        }
                        string label = "[ %s ] %s - %s %s\t%s".printf (resolusi, res_str, vcodec.up (), (is_v && has_a)? acodec.up () : "", format_size (size));
                        var item = new FormatItem (fid, label, f_url, size, ext, is_v, has_a);
                        if (ext == "mp4") {
                            mp4_video_m.append (item);
                        } else {
                            webm_video_m.append (item);
                        }
                    } else if (has_a) {
                        string label = "[%s] %s - %s\t%s".printf (ext.up (), res_str, acodec.up (), format_size(size));
                        var item = new FormatItem (fid, label, f_url, size, ext, is_v, has_a);
                        audio_model.append (item);
                        if (ext == "m4a") {
                            m4a_audio_m.append (item);
                        } else {
                            opus_audio_m.append (item);
                        }
                    }
                });
            }
        }

        private void on_download (bool later) {
            set_option ();
            if (formatid.selected == 0) {
                var vmp4 = mp4_video_dd.get_selected_item () as FormatItem;
                if (vmp4.has_audio) {
                    hashoptions[AriaOptions.OUT.to_string ()] = name_entry.text + "." + vmp4.ext;
                    downloadfile (vmp4.url, hashoptions, later, LinkMode.URL);
                    return;
                }
                hashoptions[AriaOptions.OUT.to_string ()] = name_entry.text + "." + vmp4.ext;
                var m4a = m4a_audio_dd.get_selected_item () as FormatItem;
                if (m4a.id == "none") {
                    downloadfile (vmp4.url, hashoptions, later, LinkMode.URL);
                } else {
                    downloadfile (url_entry.text+"gabutytb"+vmp4.url+"gabutytb"+m4a.url, hashoptions, later, LinkMode.YTBMP4);
                }
            } else if (formatid.selected == 1) {
                var vwebm = webm_video_dd.get_selected_item () as FormatItem;
                var opus = opus_audio_dd.get_selected_item () as FormatItem;
                hashoptions[AriaOptions.OUT.to_string ()] = name_entry.text + "." + vwebm.ext;
                if (opus.id == "none") {
                    downloadfile (vwebm.url, hashoptions, later, LinkMode.URL);
                } else {
                    downloadfile (url_entry.text+"gabutytb"+vwebm.url+"gabutytb"+opus.url, hashoptions, later, LinkMode.YTBWEBM);
                }
            } else {
                var audio = audio_dropdown.get_selected_item () as FormatItem;
                hashoptions[AriaOptions.OUT.to_string ()] = name_entry.text + "." + audio.ext;
                downloadfile (audio.url, hashoptions, later, LinkMode.YTBAUDIO);
            }
        }

        private async void load_thumbnail (string url) throws Error {
            var msg = new Soup.Message ("GET", url);
            var bytes = yield http_session.send_and_read_async (msg, GLib.Priority.DEFAULT, null);
            var stream = new GLib.MemoryInputStream.from_bytes (bytes);
            var pixbuf = yield new Gdk.Pixbuf.from_stream_async (stream, null);
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
            save_button.sensitive = start_button.sensitive = later_button.sensitive = true;
            stream.close ();
        }

        private void set_loading (bool state) {
            fetch_btn.set_sensitive (!state);
            save_button.sensitive = start_button.sensitive = later_button.sensitive = false;
            if (state) {
                stsimg.visible = false;
                spinner.start ();
            } else {
                stsimg.visible = true;
                spinner.stop ();
            }
        }

      private void set_option () {
            hashoptions.clear ();
            if (myrcproxy.myproxy != MyProxy.NONE) {
                if (proxy_entry.text.strip () != "") {
                    if (proxytype.proxytype.to_string () == "ALL") {
                        hashoptions[AriaOptions.PROXY.to_string ()] = @"$(proxy_entry.text.strip ()):$(port_entry.value)";
                        if (user_entry.text.strip () != "") {
                            hashoptions[AriaOptions.PROXYUSER.to_string ()] = user_entry.text.strip ();
                        }
                        if (pass_entry.text.strip () != "") {
                            hashoptions[AriaOptions.PROXYPASSWORD.to_string ()] = pass_entry.text.strip ();
                        }
                        set_myproxy (DBMyproxy.TYPEPR, "0");
                    } else if (proxytype.proxytype.to_string () == "FTP") {
                        hashoptions[AriaOptions.FTP_PROXY.to_string ()] = @"$(proxy_entry.text.strip ()):$(port_entry.value)";
                        if (user_entry.text.strip () != "") {
                            hashoptions[AriaOptions.FTP_PROXY_USER.to_string ()] = user_entry.text.strip ();
                        }
                        if (pass_entry.text.strip () != "") {
                            hashoptions[AriaOptions.FTP_PROXY_PASSWD.to_string ()] = pass_entry.text.strip ();
                        }
                        set_myproxy (DBMyproxy.TYPEPR, "3");
                    } if (proxytype.proxytype.to_string () == "HTTP") {
                        hashoptions[AriaOptions.HTTP_PROXY.to_string ()] = @"$(proxy_entry.text.strip ()):$(port_entry.value)";
                        if (user_entry.text.strip () != "") {
                            hashoptions[AriaOptions.HTTP_PROXY_USER.to_string ()] = user_entry.text.strip ();
                        }
                        if (pass_entry.text.strip () != "") {
                            hashoptions[AriaOptions.HTTP_PROXY_PASSWD.to_string ()] = pass_entry.text.strip ();
                        }
                        set_myproxy (DBMyproxy.TYPEPR, "1");
                    } else if (proxytype.proxytype.to_string () == "HTTPS") {
                        hashoptions[AriaOptions.HTTPS_PROXY.to_string ()] = @"$(proxy_entry.text.strip ()):$(port_entry.value)";
                        if (user_entry.text.strip () != "") {
                            hashoptions[AriaOptions.HTTPS_PROXY_USER.to_string ()] = user_entry.text.strip ();
                        }
                        if (pass_entry.text.strip () != "") {
                            hashoptions[AriaOptions.HTTPS_PROXY_PASSWD.to_string ()] = pass_entry.text.strip ();
                        }
                        set_myproxy (DBMyproxy.TYPEPR, "2");
                    }
                    set_myproxy (DBMyproxy.HOST, proxy_entry.text.strip ());
                    set_myproxy (DBMyproxy.PORT, port_entry.value.to_string ());
                    set_myproxy (DBMyproxy.USER, user_entry.text.strip ());
                    set_myproxy (DBMyproxy.PASSWD, pass_entry.text.strip ());
                }
            }
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
            if (useragent_entry.text.strip () != "") {
                hashoptions[AriaOptions.USER_AGENT.to_string ()] = useragent_entry.text.strip ();
            } else {
                if (hashoptions.has_key (AriaOptions.USER_AGENT.to_string ())) {
                    hashoptions.unset (AriaOptions.USER_AGENT.to_string ());
                }
            }
            if (headerc != "") {
                hashoptions[AriaOptions.HEADER.to_string ()] = headerc;
            }
            hashoptions[AriaOptions.BT_SAVE_METADATA.to_string ()] = "false";
            hashoptions[AriaOptions.RPC_SAVE_UPLOAD_METADATA.to_string ()] = "false";
        }

        public override bool close_request () {
           return base.close_request ();
        }

        public override void close () {
            base.close ();
        }

        private void save_to_aria () {
            aria_remove (row.ariagid);
            aria_deleteresult (row.ariagid);
            remove_download (row.url);
            remove_dboptions (row.url);
            if (formatid.selected == 0) {
                var vmp4 = mp4_video_dd.get_selected_item () as FormatItem;
                if (vmp4.has_audio) {
                    hashoptions[AriaOptions.OUT.to_string ()] = name_entry.text + "." + vmp4.ext;
                    row.url = vmp4.url;
                    var rowariagid = aria_url (row.url, hashoptions, actwaiting ());
                    update_agid (row.ariagid, rowariagid);
                    row.ariagid = rowariagid;
                    add_db_download (row);
                    set_dboptions (row.url, hashoptions);
                    return;
                }
                hashoptions[AriaOptions.OUT.to_string ()] = name_entry.text + "." + vmp4.ext;
                var m4a = m4a_audio_dd.get_selected_item () as FormatItem;
                if (m4a.id == "none") {
                    row.url = vmp4.url;
                    var rowariagid = aria_url (row.url, hashoptions, actwaiting ());
                    update_agid (row.ariagid, rowariagid);
                    row.ariagid = rowariagid;
                    add_db_download (row);
                    set_dboptions (row.url, hashoptions);
                } else {
                    row.url = url_entry.text+"gabutytb"+vmp4.url+"gabutytb"+m4a.url;
                    if (row.filepath.has_suffix (".m4a")) {
                        var filep = File.new_for_path (row.filepath);
                        string m4a_a = m4a_filename(filep.get_path ());
                        hashoptions[AriaOptions.OUT.to_string ()] = GLib.Path.get_basename (m4a_a);
                        var rowariagid = aria_url (row.url.split ("gabutytb")[2], hashoptions, 0);
                        update_agid (row.ariagid, rowariagid);
                        row.ariagid = rowariagid;
                        add_db_download (row);
                        set_dboptions (row.url, hashoptions);
                        return;
                    }
                    var rowariagid = aria_url (row.url.split ("gabutytb")[1].split ("gabutytb")[0], hashoptions, actwaiting ());
                    update_agid (row.ariagid, rowariagid);
                    row.ariagid = rowariagid;
                    add_db_download (row);
                    set_dboptions (row.url, hashoptions);
                }
            } else if (formatid.selected == 1) {
                var vwebm = webm_video_dd.get_selected_item () as FormatItem;
                var opus = opus_audio_dd.get_selected_item () as FormatItem;
                hashoptions[AriaOptions.OUT.to_string ()] = name_entry.text + "." + vwebm.ext;
                if (opus.id == "none") {
                    row.url = vwebm.url;
                    var rowariagid = aria_url (row.url, hashoptions, actwaiting ());
                    update_agid (row.ariagid, rowariagid);
                    row.ariagid = rowariagid;
                    add_db_download (row);
                    set_dboptions (row.url, hashoptions);
                } else {
                    row.url = url_entry.text+"gabutytb"+vwebm.url+"gabutytb"+opus.url;
                    if (row.filepath.has_suffix (".opus")) {
                        var filep = File.new_for_path (row.filepath);
                        string opus_a = opus_filename(filep.get_path ());
                        hashoptions[AriaOptions.OUT.to_string ()] = GLib.Path.get_basename (opus_a);
                        var rowariagid = aria_url (row.url.split ("gabutytb")[2], hashoptions, 0);
                        update_agid (row.ariagid, rowariagid);
                        row.ariagid = rowariagid;
                        add_db_download (row);
                        set_dboptions (row.url, hashoptions);
                        return;
                    }
                    var rowariagid = aria_url (row.url.split ("gabutytb")[1].split ("gabutytb")[0], hashoptions, actwaiting ());
                    update_agid (row.ariagid, rowariagid);
                    row.ariagid = rowariagid;
                    add_db_download (row);
                    set_dboptions (row.url, hashoptions);
                }
            } else {
                var audio = audio_dropdown.get_selected_item () as FormatItem;
                hashoptions[AriaOptions.OUT.to_string ()] = name_entry.text + "." + audio.ext;
                row.url = audio.url;
                var rowariagid = aria_url (row.url, hashoptions, actwaiting ());
                update_agid (row.ariagid, rowariagid);
                row.ariagid = rowariagid;
                add_db_download (row);
                set_dboptions (row.url, hashoptions);
            }
            row.status = row.status_aria (aria_tell_status (row.ariagid, TellStatus.STATUS));
        }

        public override void show () {
            if (row != null) {
                hashoptions = row.hashoption;
                url_entry.text = row.url;
                string myproxy = aria_get_option (row.ariagid, AriaOptions.PROXY);
                string ftpproxy = aria_get_option (row.ariagid, AriaOptions.FTP_PROXY);
                string httpproxy = aria_get_option (row.ariagid, AriaOptions.HTTP_PROXY);
                string hsproxy = aria_get_option (row.ariagid, AriaOptions.HTTPS_PROXY);
                if (myproxy.strip () != "" | ftpproxy.strip () != "" | httpproxy.strip () != "" | hsproxy.strip () != "") {
                    ((Gtk.Label)((ProxyRecently) myrcproxy).get_last_child ()).attributes = set_attribute (Pango.Weight.BOLD);
                    myrcproxy = save_flow.get_child_at_index (1) as ProxyRecently;
                    save_flow.child_activated (myrcproxy);
                }
                if (myproxy != "") {
                    proxytype = type_flow.get_child_at_index (0) as ProxyType;
                    int lastprox = myproxy.last_index_of (":");
                    string proxytext = myproxy.slice (0, lastprox);
                    proxy_entry.text = proxytext.contains ("\\/")? proxytext.replace ("\\/", "/") : proxytext;
                    port_entry.value = int.parse (myproxy.slice (lastprox + 1, myproxy.length));
                    user_entry.text = aria_get_option (row.ariagid, AriaOptions.PROXYUSER);
                    pass_entry.text = aria_get_option (row.ariagid, AriaOptions.PROXYPASSWORD);
                } else if (ftpproxy != "") {
                    proxytype = type_flow.get_child_at_index (3) as ProxyType;
                    int flastprox = ftpproxy.last_index_of (":");
                    string fproxytext = ftpproxy.slice (0, flastprox);
                    proxy_entry.text = fproxytext.contains ("\\/")? fproxytext.replace ("\\/", "/") : fproxytext;
                    port_entry.value = int.parse (ftpproxy.slice (flastprox + 1, ftpproxy.length));
                    user_entry.text = aria_get_option (row.ariagid, AriaOptions.FTP_PROXY_USER);
                    pass_entry.text = aria_get_option (row.ariagid, AriaOptions.FTP_PROXY_PASSWD);
                } else if (httpproxy != "") {
                    proxytype = type_flow.get_child_at_index (1) as ProxyType;
                    int hlastprox = httpproxy.last_index_of (":");
                    string hproxytext = httpproxy.slice (0, hlastprox);
                    proxy_entry.text = hproxytext.contains ("\\/")? hproxytext.replace ("\\/", "/") : hproxytext;
                    port_entry.value = int.parse (httpproxy.slice (hlastprox + 1, httpproxy.length));
                    user_entry.text = aria_get_option (row.ariagid, AriaOptions.HTTP_PROXY_USER);
                    pass_entry.text = aria_get_option (row.ariagid, AriaOptions.HTTP_PROXY_PASSWD);
                } else if (hsproxy != "") {
                    proxytype = type_flow.get_child_at_index (2) as ProxyType;
                    int hslastprox = hsproxy.last_index_of (":");
                    string hsproxytext = hsproxy.slice (0, hslastprox);
                    proxy_entry.text = hsproxytext.contains ("\\/")? hsproxytext.replace ("\\/", "/") : hsproxytext;
                    port_entry.value = int.parse (hsproxy.slice (hslastprox + 1, hsproxy.length));
                    user_entry.text = aria_get_option (row.ariagid, AriaOptions.HTTPS_PROXY_USER);
                    pass_entry.text = aria_get_option (row.ariagid, AriaOptions.HTTPS_PROXY_PASSWD);
                }
                usefolder.active = hashoptions.has_key (AriaOptions.DIR.to_string ());
                if (usefolder.active) {
                    selectfd = File.new_for_path (hashoptions.@get (AriaOptions.DIR.to_string ()));
                }
                string reffer = aria_get_option (row.ariagid, AriaOptions.REFERER);
                if (reffer != "") {
                    refer_entry.text = reffer.contains ("\\/")? reffer.replace ("\\/", "/") : reffer;
                } else {
                    refer_entry.text = hashoptions.@get (AriaOptions.REFERER.to_string ());
                }
                string agntusr = aria_get_option (row.ariagid, AriaOptions.USER_AGENT);
                if (agntusr != "") {
                    useragent_entry.text = agntusr.contains ("\\/")? agntusr.replace ("\\/", "/") : agntusr;
                } else {
                    useragent_entry.text = hashoptions.@get (AriaOptions.USER_AGENT.to_string ());
                }
                string? name = aria_get_option (row.ariagid, AriaOptions.OUT);
                if (name != "") {
                    name_entry.text = name;
                } else {
                    name_entry.text = row.filename;
                }
            }
            base.show ();
        }
    }
}