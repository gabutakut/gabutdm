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
    public class AddUrl : Gtk.Dialog {
        public signal void downloadfile (string url, Gee.HashMap<string, string> options, bool later, int linkmode, bool server = false);
        public signal void update_agid (string ariagid, string newgid);
        public Gtk.Button save_button;
        private Gtk.Image status_image;
        private Gtk.Label sizelabel;
        private Gtk.Label typelabel;
        private MediaEntry link_entry;
        private MediaEntry name_entry;
        private MediaEntry proxy_entry;
        private Gtk.SpinButton port_entry;
        private MediaEntry user_entry;
        private MediaEntry pass_entry;
        private MediaEntry loguser_entry;
        private MediaEntry logpass_entry;
        private MediaEntry useragent_entry;
        private MediaEntry refer_entry;
        private MediaEntry checksum_entry;
        private Gtk.FlowBox method_flow;
        private Gtk.FlowBox checksums_flow;
        private Gtk.FlowBox login_flow;
        private Gtk.FlowBox type_flow;
        private Gtk.FlowBox save_flow;
        private Gtk.MenuButton prometh_button;
        private Gtk.MenuButton checksum_button;
        private Gtk.MenuButton login_button;
        private Gtk.MenuButton type_button;
        private Gtk.MenuButton savedproxy;
        private Gtk.CheckButton usefolder;
        private Gtk.Button folder_location;
        public DialogType dialogtype { get; construct; }
        private Gee.HashMap<string, string> hashoptions;
        public DownloadRow row;
        private bool save_meta;

        ProxyMethod _proxymethod = null;
        ProxyMethod proxymethod {
            get {
                return _proxymethod;
            }
            set {
                _proxymethod = value;
                prometh_button.label = _("Method: %s").printf (_proxymethod.method.to_string ());
            }
        }

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

        GdmChecksumType _checksumtype = null;
        GdmChecksumType checksumtype {
            get {
                return _checksumtype;
            }
            set {
                _checksumtype = value;
                checksum_button.label = _("%s").printf (_checksumtype.checksums.to_string ().up ().replace ("=", "").replace ("-", ""));
                checksum_entry.editable = checksumtype.checksums.to_string () == "none"? false : true;
            }
        }

        LoginUser _loginuser = null;
        LoginUser loginuser {
            get {
                return _loginuser;
            }
            set {
                _loginuser = value;
                login_button.label = _loginuser.loginuser.to_string ();
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

        public string url_link {
            get {
                return link_entry.text;
            }
            set {
                link_entry.text = value;
            }
        }

        public string filesize {
            get {
                return sizelabel.label;
            }
            set {
                sizelabel.label = value;
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

        public string url_icon {
            owned get {
                return status_image.icon_name?? "";
            }
            set {
                status_image.gicon = new ThemedIcon (value);
            }
        }

        public MatchInfo portserver {
            set {
                headerc = value.fetch (PostServer.HEADER);
                link_entry.text = value.fetch (PostServer.URL);
                name_entry.text = sanitize_utf8 (value.fetch (PostServer.FILENAME)).make_valid ();
                refer_entry.text = value.fetch (PostServer.REFERRER);
                status_image.gicon = GLib.ContentType.get_icon (value.fetch (PostServer.MIME));
                filesize = GLib.format_size (int64.parse (value.fetch (PostServer.FILESIZE)));
                useragent_entry.text = value.fetch (PostServer.USERAGENT);
            }
        }

        public AddUrl () {
            Object ( dialogtype: DialogType.ADDURL, resizable: false, use_header_bar: 1);
        }

        public AddUrl.Property () {
            Object ( dialogtype: DialogType.PROPERTY, resizable: false, use_header_bar: 1);
        }

        construct {
            hashoptions = new Gee.HashMap<string, string> ();
            var view_mode = new ModeButton () {
                hexpand = true,
                homogeneous = true,
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            view_mode.append_text (_("Address"));
            view_mode.append_text (_("Proxy"));
            view_mode.append_text (_("Login"));
            view_mode.append_text (_("Option"));
            view_mode.append_text (_("Checksum"));
            view_mode.selected = 0;

            unowned Gtk.HeaderBar header = this.get_header_bar ();
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

            status_image = new Gtk.Image () {
                valign = Gtk.Align.CENTER,
                pixel_size = 64
            };
            typelabel = new Gtk.Label ("File Type") {
                ellipsize = Pango.EllipsizeMode.END,
                max_width_chars = 20,
                use_markup = true,
                wrap = true,
                xalign = 0,
                valign = Gtk.Align.CENTER,
                halign = Gtk.Align.CENTER,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };
            sizelabel = new Gtk.Label ("Size") {
                ellipsize = Pango.EllipsizeMode.END,
                max_width_chars = 15,
                use_markup = true,
                wrap = true,
                xalign = 0,
                valign = Gtk.Align.CENTER,
                halign = Gtk.Align.CENTER,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };

            var leftinfo = new Gtk.Box(Gtk.Orientation.VERTICAL, 10) {
                height_request = 90,
                width_request = 150,
                valign = Gtk.Align.CENTER,
                halign = Gtk.Align.CENTER
            };
            leftinfo.append (typelabel);
            leftinfo.append (status_image);
            leftinfo.append (sizelabel);
            move_window (this, leftinfo);

            link_entry = new MediaEntry ("com.github.gabutakut.gabutdm.uri", "edit-paste") {
                width_request = 150,
                placeholder_text = _("Paste here")
            };

            name_entry = new MediaEntry ("dialog-information", "edit-paste") {
                width_request = 150,
                placeholder_text = _("Follow source name")
            };

            link_entry.changed.connect (()=> {
                save_meta = url_link.has_prefix ("magnet:?")? true : false;
                if (link_entry.text.has_prefix ("http://") || link_entry.text.has_prefix ("https://") || link_entry.text.has_prefix ("ftp://") || link_entry.text.has_prefix ("sftp://")) {
                    if (status_image != null && typelabel != null) {
                        string[] mimeicon = null;
                        new Thread<void> ("urlicon", () => {
                            if (headerc != null) {
                                mimeicon = get_content_type (link_entry.text, headerc);
                            } else {
                                mimeicon = get_content_type (link_entry.text, "");
                            }
                            MainContext.default ().invoke (() => {
                                if (mimeicon[0] != null) {
                                    status_image.gicon = GLib.ContentType.get_icon (mimeicon[0]);
                                    typelabel.tooltip_text = typelabel.label = mimeicon[0];
                                    sizelabel.label = GLib.format_size (int64.parse (mimeicon[1]));
                                }
                                return GLib.Source.REMOVE;
                            });
                        });
                    }
                }
            });
            var rightinfo = new Gtk.Grid () {
                width_request = 80
            };
            var alllink = new Gtk.Grid () {
                column_spacing = 10,
                height_request = 120,
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            alllink.attach (leftinfo, 0, 0, 1, 8);
            alllink.attach (headerlabel (_("Address:"), 425), 1, 1, 2, 1);
            alllink.attach (link_entry, 1, 2, 2, 1);
            alllink.attach (headerlabel (_("Filename:"), 425), 1, 3, 2, 1);
            alllink.attach (name_entry, 1, 4, 2, 1);
            alllink.attach (usefolder, 1, 5, 2, 1);
            alllink.attach (folder_location, 1, 6, 2, 1);
            alllink.attach (rightinfo, 3, 0, 1, 8);

            method_flow = new Gtk.FlowBox ();
            var method_popover = new Gtk.Popover () {
                child = method_flow
            };
            prometh_button = new Gtk.MenuButton () {
                popover = method_popover
            };
            foreach (var method in ProxyMethods.get_all ()) {
                method_flow.append (new ProxyMethod (method));
            }
            method_flow.set_visible (true);
            method_flow.child_activated.connect ((method)=> {
                ((Gtk.Label)((ProxyMethod) proxymethod).get_last_child ()).attributes = set_attribute (Pango.Weight.BOLD);
                proxymethod = method as ProxyMethod;
                ((Gtk.Label)proxymethod.get_last_child ()).attributes = color_attribute (0, 60000, 0);
                method_popover.set_visible (false);
            });
            proxymethod = method_flow.get_child_at_index (0) as ProxyMethod;
            ((Gtk.Label)proxymethod.get_last_child ()).attributes = color_attribute (0, 60000, 0);
            method_popover.show.connect (() => {
                method_flow.unselect_all ();
            });
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
                margin_top = 6,
                height_request = 130,
                column_spacing = 10,
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            proxygrid.attach (prometh_button, 0, 1, 1, 1);
            proxygrid.attach (savedproxy, 1, 1, 1, 1);
            proxygrid.attach (type_button, 0, 2, 2, 1);
            proxygrid.attach (headerlabel (_("Host:"), 300), 0, 3, 1, 1);
            proxygrid.attach (proxy_entry, 0, 4, 1, 1);
            proxygrid.attach (headerlabel (_("Port:"), 300), 1, 3, 1, 1);
            proxygrid.attach (port_entry, 1, 4, 1, 1);
            proxygrid.attach (headerlabel (_("Username:"), 300), 0, 5, 1, 1);
            proxygrid.attach (user_entry, 0, 6, 1, 1);
            proxygrid.attach (headerlabel (_("Password:"), 300), 1, 5, 1, 1);
            proxygrid.attach (pass_entry, 1, 6, 1, 1);

            login_flow = new Gtk.FlowBox ();
            var login_popover = new Gtk.Popover () {
                child = login_flow
            };
            login_button = new Gtk.MenuButton () {
                tooltip_text = _("FTP/HTTP download with username and password"),
                popover = login_popover
            };
            foreach (var logn in LoginUsers.get_all ()) {
                login_flow.append (new LoginUser (logn));
            }
            login_flow.set_visible (true);

            login_flow.child_activated.connect ((logn)=> {
                ((Gtk.Label)((LoginUser) loginuser).get_last_child ()).attributes = set_attribute (Pango.Weight.BOLD);
                loginuser = logn as LoginUser;
                ((Gtk.Label)loginuser.get_last_child ()).attributes = color_attribute (0, 60000, 0);
                login_popover.set_visible (false);
            });
            loginuser = login_flow.get_child_at_index (0) as LoginUser;
            ((Gtk.Label)loginuser.get_last_child ()).attributes = color_attribute (0, 60000, 0);
            login_popover.show.connect (() => {
                login_flow.unselect_all ();
            });
            loguser_entry = new MediaEntry ("avatar-default", "edit-paste") {
                width_request = 200,
                placeholder_text = _("User")
            };

            logpass_entry = new MediaEntry ("dialog-password", "edit-paste") {
                width_request = 200,
                placeholder_text = _("Password")
            };

            var logingrid = new Gtk.Grid () {
                height_request = 130,
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            logingrid.attach (login_button, 1, 0, 1, 1);
            logingrid.attach (headerlabel (_("User:"), 425), 1, 1, 1, 1);
            logingrid.attach (loguser_entry, 1, 2, 1, 1);
            logingrid.attach (headerlabel (_("Password:"), 425), 1, 3, 1, 1);
            logingrid.attach (logpass_entry, 1, 4, 1, 1);

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
                height_request = 130,
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            moregrid.attach (headerlabel (_("User Agent:"), 425), 1, 0, 1, 1);
            moregrid.attach (useragent_entry, 1, 1, 1, 1);
            moregrid.attach (headerlabel (_("Referer:"), 425), 1, 2, 1, 1);
            moregrid.attach (refer_entry, 1, 3, 1, 1);

            checksums_flow = new Gtk.FlowBox ();
            var checksums_popover = new Gtk.Popover () {
                child = checksums_flow
            };
            checksum_button = new Gtk.MenuButton () {
                tooltip_text = _("TYPE is hash type"),
                popover = checksums_popover
            };
            foreach (var checksum in AriaChecksumTypes.get_all ()) {
                checksums_flow.append (new GdmChecksumType (checksum));
            }
            checksums_flow.set_visible (true);

            checksum_entry = new MediaEntry ("com.github.gabutakut.gabutdm.hash", "edit-paste") {
                width_request = 350,
                placeholder_text = _("Hash")
            };
            checksums_flow.child_activated.connect ((checksum)=> {
                ((Gtk.Label)((GdmChecksumType) checksumtype).get_last_child ()).attributes = set_attribute (Pango.Weight.BOLD);
                checksumtype = checksum as GdmChecksumType;
                ((Gtk.Label)checksumtype.get_last_child ()).attributes = color_attribute (0, 60000, 0);
                checksum_entry.sensitive = checksumtype.checksums != AriaChecksumTypes.NONE? true : false;
                checksums_popover.set_visible (false);
            });
            checksumtype = checksums_flow.get_child_at_index (0) as GdmChecksumType;
            ((Gtk.Label)checksumtype.get_last_child ()).attributes = color_attribute (0, 60000, 0);
            checksum_entry.sensitive = checksumtype.checksums != AriaChecksumTypes.NONE? true : false;

            checksums_popover.show.connect (() => {
                checksums_flow.unselect_all ();
            });
            var checksumgrid = new Gtk.Grid () {
                height_request = 130,
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            checksumgrid.attach (headerlabel (_("Type:"), 425), 1, 0, 1, 1);
            checksumgrid.attach (checksum_button, 1, 1, 1, 1);
            checksumgrid.attach (headerlabel (_("Hash:"), 425), 1, 2, 1, 1);
            checksumgrid.attach (checksum_entry, 1, 3, 1, 1);

            var stack = new Gtk.Stack () {
                transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT,
                transition_duration = 500
            };
            stack.add_named (alllink, "alllink");
            stack.add_named (proxygrid, "proxygrid");
            stack.add_named (logingrid, "logingrid");
            stack.add_named (moregrid, "moregrid");
            stack.add_named (checksumgrid, "checksumgrid");
            stack.visible_child = alllink;
            stack.set_visible (true);

            var close_button = new Gtk.Button.with_label (_("Cancel")) {
                width_request = 120,
                height_request = 25
            };
            ((Gtk.Label) close_button.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            close_button.clicked.connect (()=> {
                close ();
            });

            var start_button = new Gtk.Button.with_label (_("Download")) {
                width_request = 120,
                height_request = 25
            };
            ((Gtk.Label) start_button.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            start_button.clicked.connect (()=> {
                set_option ();
                download_send.begin (false);
                close ();
            });

            var later_button = new Gtk.Button.with_label (_("Download Later")) {
                width_request = 120,
                height_request = 25
            };
            ((Gtk.Label) later_button.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            later_button.clicked.connect (()=> {
                set_option ();
                download_send.begin (true);
                close ();
            });

            save_button = new Gtk.Button.with_label (_("Save")) {
                width_request = 120,
                height_request = 25
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
            unowned Gtk.Box boxarea = this.get_content_area ();
            boxarea.margin_start = 10;
            boxarea.margin_end = 10;
            boxarea.append (stack);
            boxarea.append (box_action);

            view_mode.notify["selected"].connect (() => {
                switch (view_mode.selected) {
                    case 1:
                        stack.visible_child = proxygrid;
                        break;
                    case 2:
                        stack.visible_child = logingrid;
                        break;
                    case 3:
                        stack.visible_child = moregrid;
                        break;
                    case 4:
                        stack.visible_child = checksumgrid;
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
            base.close ();
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
            if (loginuser.loginuser.to_string ().down () == "http") {
                if (loguser_entry.text.strip () != "") {
                    hashoptions[AriaOptions.HTTP_USER.to_string ()] = loguser_entry.text.strip ();
                }
                if (logpass_entry.text.strip () != "") {
                    hashoptions[AriaOptions.HTTP_PASSWD.to_string ()] = logpass_entry.text.strip ();
                }
            } else {
                if (loguser_entry.text.strip () != "") {
                    hashoptions[AriaOptions.FTP_USER.to_string ()] = loguser_entry.text.strip ();
                }
                if (logpass_entry.text.strip () != "") {
                    hashoptions[AriaOptions.FTP_PASSWD.to_string ()] = logpass_entry.text.strip ();
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
            if (checksumtype.checksums.to_string ().down () != "none") {
                if (checksum_entry.text != "") {
                    hashoptions[AriaOptions.CHECKSUM.to_string ()] = checksumtype.checksums.to_string () + checksum_entry.text.strip ();
                }
            } else {
                if (hashoptions.has_key (AriaOptions.CHECKSUM.to_string ())) {
                    hashoptions.unset (AriaOptions.CHECKSUM.to_string ());
                }
            }
            if (headerc != "" && headerc != null) {
                hashoptions[AriaOptions.HEADER.to_string ()] = headerc;
            }
            hashoptions[AriaOptions.BT_SAVE_METADATA.to_string ()] = save_meta.to_string ();
            hashoptions[AriaOptions.RPC_SAVE_UPLOAD_METADATA.to_string ()] = save_meta.to_string ();
            hashoptions[AriaOptions.PROXY_METHOD.to_string ()] = proxymethod.method.to_string ().down ();
        }

        private void savetoaria () {
            aria_unpause (row.ariagid);
            aria_remove (row.ariagid);
            if (row.url.has_prefix ("magnet:?")) {
                row.linkmode = LinkMode.MAGNETLINK;
                var rowariagid = aria_url (row.url, hashoptions, actwaiting ());
                update_agid (row.ariagid, rowariagid);
                row.ariagid = rowariagid;
            } else {
                row.linkmode = LinkMode.URL;
                var rowariagid = aria_url (row.url, hashoptions, actwaiting ());
                update_agid (row.ariagid, rowariagid);
                row.ariagid = rowariagid;
            }
            row.status = row.status_aria (aria_tell_status (row.ariagid, TellStatus.STATUS));
            if (!db_option_exist (row.url)) {
                set_dboptions (row.url, hashoptions);
            } else {
                update_optionts (row.url, hashoptions);
            }
        }

        private async void download_send (bool start) throws Error {
            string url = link_entry.text;
            if (url.has_prefix ("magnet:?")) {
                downloadfile (url, hashoptions, start, LinkMode.MAGNETLINK);
            } else if (url.has_prefix ("http://") || url.has_prefix ("https://") || url.has_prefix ("ftp://") || url.has_prefix ("sftp://")) {
                downloadfile (url, hashoptions, start, LinkMode.URL);
            }
        }

        public override void show () {
            if (row != null) {
                headerc = aria_get_option (row.ariagid, AriaOptions.HEADER);
                link_entry.text = row.url;
                this.hashoptions = row.hashoption;
                status_image.gicon = GLib.ContentType.get_icon (row.fileordir);
                sizelabel.label = GLib.format_size (row.totalsize);
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
                string httpusr = aria_get_option (row.ariagid, AriaOptions.HTTP_USER);
                if (httpusr != "") {
                    loginuser = login_flow.get_child_at_index (0) as LoginUser;
                    loguser_entry.text = aria_get_option (row.ariagid, AriaOptions.HTTP_USER);
                    logpass_entry.text = aria_get_option (row.ariagid, AriaOptions.HTTP_PASSWD);
                }
                string ftpusr = aria_get_option (row.ariagid, AriaOptions.FTP_USER);
                if (ftpusr != "") {
                    loginuser = login_flow.get_child_at_index (1) as LoginUser;
                    loguser_entry.text = aria_get_option (row.ariagid, AriaOptions.FTP_USER);
                    logpass_entry.text = aria_get_option (row.ariagid, AriaOptions.FTP_PASSWD);
                }
                usefolder.active = hashoptions.has_key (AriaOptions.DIR.to_string ());
                if (usefolder.active) {
                    selectfd = File.new_for_path (hashoptions.@get (AriaOptions.DIR.to_string ()));
                }
                string reffer = aria_get_option (row.ariagid, AriaOptions.REFERER);
                if (reffer != "") {
                    refer_entry.text = reffer.contains ("\\/")? reffer.replace ("\\/", "/") : reffer;
                }
                string agntusr = aria_get_option (row.ariagid, AriaOptions.USER_AGENT);
                if (agntusr != "") {
                    useragent_entry.text = agntusr.contains ("\\/")? agntusr.replace ("\\/", "/") : agntusr;
                }
                name_entry.text = aria_get_option (row.ariagid, AriaOptions.OUT);
                foreach (var b in ProxyMethods.get_all ()) {
                    var promed = method_flow.get_child_at_index (b);
                    if (((ProxyMethod) promed).method.to_string ().down () == aria_get_option (row.ariagid, AriaOptions.PROXY_METHOD).down ()) {
                        proxymethod = promed as ProxyMethod;
                    }
                }
                foreach (var a in AriaChecksumTypes.get_all ()) {
                    var checksflow = checksums_flow.get_child_at_index (a);
                    if (aria_get_option (row.ariagid, AriaOptions.CHECKSUM).contains (((GdmChecksumType) checksflow).checksums.to_string ())) {
                        checksumtype = checksflow as GdmChecksumType;
                        checksum_entry.text = aria_get_option (row.ariagid, AriaOptions.CHECKSUM).split ("=")[1];
                        checksum_entry.sensitive = checksumtype.checksums != AriaChecksumTypes.NONE? true : false;
                    }
                }
                save_meta = bool.parse (aria_get_option (row.ariagid, AriaOptions.RPC_SAVE_UPLOAD_METADATA)) | bool.parse (aria_get_option (row.ariagid, AriaOptions.RPC_SAVE_UPLOAD_METADATA));
            }
            base.show ();
        }
    }
}