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
    public class AddUrl : Gtk.Dialog {
        public enum DialogType {
            ADDURL,
            PROPERTY
        }
        public signal void downloadfile (string url, Gee.HashMap<string, string> options, bool later, int linkmode);
        public signal void saveproperty (Gee.HashMap<string, string> options);
        private Gtk.Image status_image;
        private Gtk.Label sizelabel;
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
        private Gtk.CheckButton save_meta;
        private Gtk.FlowBox method_flow;
        private Gtk.FlowBox checksums_flow;
        private Gtk.FlowBox encrypt_flow;
        private Gtk.FlowBox login_flow;
        private Gtk.MenuButton prometh_button;
        private Gtk.MenuButton checksum_button;
        private Gtk.MenuButton encrypt_button;
        private Gtk.MenuButton login_button;
        private Gtk.CheckButton usecookie;
        private Gtk.CheckButton usefolder;
        private Gtk.CheckButton encrypt;
        private Gtk.FileChooserButton folder_location;
        private Gtk.FileChooserButton cookie_location;
        public DialogType dialogtype { get; construct; }
        private Gee.HashMap<string, string> hashoptions;
        public DownloadRow row;

        ProxyMethod _proxymethod = null;
        ProxyMethod proxymethod {
            get {
                return _proxymethod;
            }
            set {
                _proxymethod = value;
                prometh_button.label = _("Method: %s").printf (_proxymethod.method.get_name ());
            }
        }

        ChecksumType _checksumtype = null;
        ChecksumType checksumtype {
            get {
                return _checksumtype;
            }
            set {
                _checksumtype = value;
                checksum_button.label = _("%s").printf (_checksumtype.checksums.get_name ().up ().replace ("=", "").replace ("-", ""));
                checksum_entry.sensitive = checksumtype.checksums.get_name () == "none"? false : true;
            }
        }

        BTEncrypt _btencrypt = null;
        BTEncrypt btencrypt {
            get {
                return _btencrypt;
            }
            set {
                _btencrypt = value;
                encrypt_button.label = _btencrypt.btencrypt.get_name ();
            }
        }

        LoginUser _loginuser = null;
        LoginUser loginuser {
            get {
                return _loginuser;
            }
            set {
                _loginuser = value;
                login_button.label = _loginuser.loginuser.get_name ();
            }
        }

        public AddUrl (Gtk.Application application) {
            Object (application: application,
                    dialogtype: DialogType.ADDURL,
                    resizable: false,
                    use_header_bar: 1
            );
        }

        public AddUrl.Property (Gtk.Application application) {
            Object (application: application,
                    dialogtype: DialogType.PROPERTY,
                    resizable: false,
                    use_header_bar: 1
            );
        }

        construct {
            hashoptions = new Gee.HashMap<string, string> ();
            var view_mode = new ModeButton () {
                hexpand = false,
                margin = 2,
                width_request = 350
            };
            view_mode.append_text (_("Address"));
            view_mode.append_text (_("Proxy"));
            view_mode.append_text (_("Login"));
            view_mode.append_text (_("Option"));
            view_mode.append_text (_("Folder"));
            view_mode.append_text (_("Checksum"));
            view_mode.append_text (_("Encrypt"));
            view_mode.selected = 0;

            var header = get_header_bar ();
            header.has_subtitle = false;
            header.show_close_button = false;
            header.get_style_context ().add_class (Gtk.STYLE_CLASS_HEADER);
            header.set_custom_title (view_mode);

            status_image = new Gtk.Image () {
                valign = Gtk.Align.CENTER,
                pixel_size = 64,
                margin = 10
            };

            sizelabel = new Gtk.Label ("?") {
                ellipsize = Pango.EllipsizeMode.END,
                max_width_chars = 10,
                use_markup = true,
                wrap = true,
                xalign = 0,
                valign = Gtk.Align.END,
                halign = Gtk.Align.CENTER
            };
            sizelabel.get_style_context ().add_class ("h4");

            var overlay = new Gtk.Overlay ();
            overlay.add (status_image);
            overlay.add_overlay (sizelabel);

            link_entry = new MediaEntry ("insert-link", "edit-paste") {
                width_request = 340,
                margin_end = 74,
                placeholder_text = _("Url or Magnet")
            };

            name_entry = new MediaEntry ("dialog-information", "edit-paste") {
                width_request = 340,
                margin_end = 74,
                placeholder_text = _("Follow source name")
            };

            save_meta = new Gtk.CheckButton.with_label (_("Backup Magnet, Torrent, Metalink to File")) {
                margin_top = 5
            };

            var alllink = new Gtk.Grid () {
                expand = true,
                height_request = 130,
                halign = Gtk.Align.START
            };
            alllink.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            alllink.attach (overlay, 0, 0, 1, 5);
            alllink.attach (new HeaderLabel (_("Address:"), 340), 1, 1, 1, 1);
            alllink.attach (link_entry, 1, 2, 1, 1);
            alllink.attach (new HeaderLabel (_("Filename:"), 340), 1, 3, 1, 1);
            alllink.attach (name_entry, 1, 4, 1, 1);
            alllink.attach (save_meta, 1, 5, 1, 1);

            prometh_button = new Gtk.MenuButton ();
            method_flow = new Gtk.FlowBox () {
                orientation = Gtk.Orientation.HORIZONTAL,
                width_request = 70,
                margin = 10
            };
            var method_popover = new Gtk.Popover (prometh_button) {
                position = Gtk.PositionType.TOP,
                width_request = 70
            };
            method_popover.add (method_flow);
            method_popover.show.connect (() => {
                if (proxymethod != null) {
                    method_flow.select_child (proxymethod);
                    proxymethod.grab_focus ();
                }
            });
            prometh_button.popover = method_popover;
            foreach (var method in ProxyMethods.get_all ()) {
                method_flow.add (new ProxyMethod (method));
            }
            method_flow.show_all ();
            method_flow.child_activated.connect ((method)=> {
                proxymethod = method as ProxyMethod;
                method_popover.hide ();
            });
            proxymethod = method_flow.get_children ().nth_data (0) as ProxyMethod;

            proxy_entry = new MediaEntry ("user-home", "edit-paste") {
                width_request = 100,
                placeholder_text = _("Address")
            };

            port_entry = new Gtk.SpinButton.with_range (0, 99999, 1) {
                width_request = 100,
                primary_icon_name = "dialog-information"
            };

            user_entry = new MediaEntry ("avatar-default", "edit-paste") {
                width_request = 100,
                placeholder_text = _("Username")
            };

            pass_entry = new MediaEntry ("dialog-password", "edit-paste") {
                width_request = 100,
                placeholder_text = _("Password")
            };

            var proxygrid = new Gtk.Grid () {
                expand = true,
                height_request = 130,
                column_spacing = 10
            };
            proxygrid.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            proxygrid.attach (prometh_button, 0, 1, 1, 1);
            proxygrid.attach (new HeaderLabel (_("Host:"), 100), 0, 2, 1, 1);
            proxygrid.attach (proxy_entry, 0, 3, 1, 1);
            proxygrid.attach (new HeaderLabel (_("Port:"), 100), 1, 2, 1, 1);
            proxygrid.attach (port_entry, 1, 3, 1, 1);
            proxygrid.attach (new HeaderLabel (_("Username:"), 100), 0, 4, 1, 1);
            proxygrid.attach (user_entry, 0, 5, 1, 1);
            proxygrid.attach (new HeaderLabel (_("Password:"), 100), 1, 4, 1, 1);
            proxygrid.attach (pass_entry, 1, 5, 1, 1);

            login_button = new Gtk.MenuButton ();
            login_flow = new Gtk.FlowBox () {
                orientation = Gtk.Orientation.HORIZONTAL,
                width_request = 70,
                margin = 10
            };
            var login_popover = new Gtk.Popover (login_button) {
                position = Gtk.PositionType.TOP,
                width_request = 140
            };
            login_popover.add (login_flow);
            login_popover.show.connect (() => {
                if (loginuser != null) {
                    login_flow.select_child (loginuser);
                    loginuser.grab_focus ();
                }
            });
            login_button.popover = login_popover;
            foreach (var logn in LoginUsers.get_all ()) {
                login_flow.add (new LoginUser (logn));
            }
            login_flow.show_all ();

            login_flow.child_activated.connect ((logn)=> {
                loginuser = logn as LoginUser;
                login_popover.hide ();
            });
            loginuser = login_flow.get_children ().nth_data (0) as LoginUser;

            loguser_entry = new MediaEntry ("avatar-default", "edit-paste") {
                width_request = 300,
                placeholder_text = _("User")
            };

            logpass_entry = new MediaEntry ("dialog-password", "edit-paste") {
                width_request = 300,
                placeholder_text = _("Password")
            };

            var logingrid = new Gtk.Grid () {
                expand = true,
                height_request = 130,
                halign = Gtk.Align.CENTER
            };
            logingrid.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            logingrid.attach (login_button, 1, 0, 1, 1);
            logingrid.attach (new HeaderLabel (_("User:"), 300), 1, 1, 1, 1);
            logingrid.attach (loguser_entry, 1, 2, 1, 1);
            logingrid.attach (new HeaderLabel (_("Password:"), 300), 1, 3, 1, 1);
            logingrid.attach (logpass_entry, 1, 4, 1, 1);

            useragent_entry = new MediaEntry ("avatar-default", "edit-paste") {
                width_request = 300,
                placeholder_text = _("User Agent")
            };

            refer_entry = new MediaEntry ("emblem-symbolic-link", "edit-paste") {
                width_request = 300,
                placeholder_text = _("Referer")
            };

            var moregrid = new Gtk.Grid () {
                expand = true,
                height_request = 130,
                halign = Gtk.Align.CENTER
            };
            moregrid.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            moregrid.attach (new HeaderLabel (_("User Agent:"), 300), 1, 0, 1, 1);
            moregrid.attach (useragent_entry, 1, 1, 1, 1);
            moregrid.attach (new HeaderLabel (_("Referer:"), 300), 1, 2, 1, 1);
            moregrid.attach (refer_entry, 1, 3, 1, 1);

            cookie_location = new Gtk.FileChooserButton (_("Open"), Gtk.FileChooserAction.OPEN);
            var all_file = new Gtk.FileFilter ();
            all_file.set_filter_name (_("All Files"));
            all_file.add_pattern ("*");
            cookie_location.set_filter (all_file);

            usecookie = new Gtk.CheckButton.with_label (_("Cookie")) {
                width_request = 300,
                margin_top = 5,
                margin_bottom = 5
            };
            usecookie.toggled.connect (()=> {
                cookie_location.sensitive = usecookie.active;
            });
            cookie_location.sensitive = usecookie.active;

            folder_location = new Gtk.FileChooserButton (_("Open"), Gtk.FileChooserAction.SELECT_FOLDER);
            var filter_folder = new Gtk.FileFilter ();
            filter_folder.add_mime_type ("inode/directory");
            folder_location.set_filter (filter_folder);
            folder_location.set_uri (File.new_for_path (get_dbsetting (DBSettings.DIR).replace ("\\/", "/")).get_uri ());

            usefolder = new Gtk.CheckButton.with_label (_("Folder")) {
                width_request = 300,
                margin_top = 5,
                margin_bottom = 5
            };
            usefolder.toggled.connect (()=> {
                folder_location.sensitive = usefolder.active;
            });
            folder_location.sensitive = usefolder.active;
            var foldergrid = new Gtk.Grid () {
                expand = true,
                height_request = 130,
                halign = Gtk.Align.CENTER
            };
            foldergrid.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            foldergrid.attach (usecookie, 1, 0, 1, 1);
            foldergrid.attach (cookie_location, 1, 1, 1, 1);
            foldergrid.attach (usefolder, 1, 2, 1, 1);
            foldergrid.attach (folder_location, 1, 3, 1, 1);

            checksum_button = new Gtk.MenuButton ();
            checksums_flow = new Gtk.FlowBox () {
                orientation = Gtk.Orientation.HORIZONTAL,
                margin = 10
            };
            var checksums_popover = new Gtk.Popover (checksum_button) {
                position = Gtk.PositionType.TOP,
                width_request = 200
            };
            checksums_popover.add (checksums_flow);
            checksums_popover.show.connect (() => {
                checksums_popover.width_request = checksum_button.get_allocated_width ();
                if (checksumtype != null) {
                    checksums_flow.select_child (checksumtype);
                    checksumtype.grab_focus ();
                }
            });
            checksum_button.popover = checksums_popover;
            foreach (var checksum in AriaChecksumTypes.get_all ()) {
                checksums_flow.add (new ChecksumType (checksum));
            }
            checksums_flow.show_all ();

            checksum_entry = new MediaEntry ("emblem-symbolic-link", "edit-paste") {
                width_request = 300,
                placeholder_text = _("Hash")
            };
            checksums_flow.child_activated.connect ((checksum)=> {
                checksumtype = checksum as ChecksumType;
                checksums_popover.hide ();
            });
            checksumtype = checksums_flow.get_children ().nth_data (0) as ChecksumType;

            var checksumgrid = new Gtk.Grid () {
                expand = true,
                height_request = 130,
                halign = Gtk.Align.CENTER
            };
            checksumgrid.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            checksumgrid.attach (new HeaderLabel (_("Type:"), 300), 1, 0, 1, 1);
            checksumgrid.attach (checksum_button, 1, 1, 1, 1);
            checksumgrid.attach (new HeaderLabel (_("Hash:"), 300), 1, 2, 1, 1);
            checksumgrid.attach (checksum_entry, 1, 3, 1, 1);

            encrypt_button = new Gtk.MenuButton ();
            encrypt_flow = new Gtk.FlowBox () {
                orientation = Gtk.Orientation.HORIZONTAL,
                width_request = 70,
                margin = 10
            };
            var encrypt_popover = new Gtk.Popover (encrypt_button) {
                position = Gtk.PositionType.TOP,
                width_request = 150
            };
            encrypt_popover.add (encrypt_flow);
            encrypt_popover.show.connect (() => {
                if (btencrypt != null) {
                    encrypt_flow.select_child (btencrypt);
                    btencrypt.grab_focus ();
                }
            });
            encrypt_button.popover = encrypt_popover;
            foreach (var encrp in BTEncrypts.get_all ()) {
                encrypt_flow.add (new BTEncrypt (encrp));
            }
            encrypt_flow.show_all ();

            encrypt_flow.child_activated.connect ((encrp)=> {
                btencrypt = encrp as BTEncrypt;
                encrypt_popover.hide ();
            });
            btencrypt = encrypt_flow.get_children ().nth_data (0) as BTEncrypt;

            encrypt = new Gtk.CheckButton.with_label (_("BT Require Crypto")) {
                width_request = 300,
                margin_top = 5,
                margin_bottom = 5
            };
            encrypt.toggled.connect (()=> {
                encrypt_button.sensitive = encrypt.active;
            });
            encrypt_button.sensitive = encrypt.active;

            var encryptgrid = new Gtk.Grid () {
                expand = true,
                height_request = 130,
                halign = Gtk.Align.CENTER
            };
            encryptgrid.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            encryptgrid.attach (new HeaderLabel (_("BitTorrent Encryption:"), 300), 1, 0, 1, 1);
            encryptgrid.attach (encrypt, 1, 1, 1, 1);
            encryptgrid.attach (encrypt_button, 1, 2, 1, 1);

            var stack = new Gtk.Stack () {
                transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT,
                transition_duration = 500
            };
            stack.add_named (alllink, "alllink");
            stack.add_named (proxygrid, "proxygrid");
            stack.add_named (logingrid, "logingrid");
            stack.add_named (moregrid, "moregrid");
            stack.add_named (foldergrid, "foldergrid");
            stack.add_named (checksumgrid, "checksumgrid");
            stack.add_named (encryptgrid, "encryptgrid");
            stack.visible_child = alllink;
            stack.show_all ();

            var close_button = new Gtk.Button.with_label (_("Cancel")) {
                width_request = 120,
                height_request = 25
            };
            close_button.clicked.connect (()=> {
                destroy ();
            });

            var start_button = new Gtk.Button.with_label (_("Download")) {
                width_request = 120,
                height_request = 25
            };
            start_button.clicked.connect (()=> {
                set_option ();
                download_send.begin (false);
                destroy ();
            });

            var later_button = new Gtk.Button.with_label (_("Download Later")) {
                width_request = 120,
                height_request = 25
            };
            later_button.clicked.connect (()=> {
                set_option ();
                download_send.begin (true);
                destroy ();
            });

            var save_button = new Gtk.Button.with_label (_("Save")) {
                width_request = 120,
                height_request = 25
            };
            save_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
            save_button.clicked.connect (()=> {
                set_option (true);
                saveproperty (hashoptions);
                destroy ();
            });
            var box_action = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5) {
                margin_top = 10,
                margin_bottom = 10
            };
            box_action.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);

            switch (dialogtype) {
                case DialogType.PROPERTY:
                    box_action.pack_end (close_button, false, false, 0);
                    box_action.pack_end (save_button, false, false, 0);
                    break;
                default:
                    box_action.pack_start (start_button, false, false, 0);
                    box_action.pack_start (later_button, false, false, 0);
                    box_action.pack_end (close_button, false, false, 0);
                    break;
            }


            var maingrid = new Gtk.Grid () {
                orientation = Gtk.Orientation.VERTICAL,
                halign = Gtk.Align.CENTER,
                margin_start = 10,
                margin_end = 10,
                expand = true
            };
            maingrid.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            maingrid.add (stack);
            maingrid.add (box_action);

            get_content_area ().add (maingrid);
            move_widget (this);
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
                        stack.visible_child = foldergrid;
                        break;
                    case 5:
                        stack.visible_child = checksumgrid;
                        break;
                    case 6:
                        stack.visible_child = encryptgrid;
                        break;
                    default:
                        stack.visible_child = alllink;
                        break;
                }
            });
        }

        private void set_option (bool save = false) {
            if (proxy_entry.text.strip () != "") {
                hashoptions[AriaOptions.PROXY.get_name ()] = proxy_entry.text.strip ();
            } else {
                if (hashoptions.has_key (AriaOptions.PROXY.get_name ())) {
                    hashoptions.unset (AriaOptions.PROXY.get_name ());
                }
            }
            if (port_entry.value != 0) {
                hashoptions[AriaOptions.PROXYPORT.get_name ()] = port_entry.value.to_string ();
            } else {
                if (hashoptions.has_key (AriaOptions.PROXYPORT.get_name ())) {
                    hashoptions.unset (AriaOptions.PROXYPORT.get_name ());
                }
            }
            if (user_entry.text.strip () != "") {
                hashoptions[AriaOptions.PROXYUSERNAME.get_name ()] = user_entry.text.strip ();
            } else {
                if (hashoptions.has_key (AriaOptions.PROXYUSERNAME.get_name ())) {
                    hashoptions.unset (AriaOptions.PROXYUSERNAME.get_name ());
                }
            }
            if (pass_entry.text.strip () != "") {
                hashoptions[AriaOptions.PROXYPASSWORD.get_name ()] = pass_entry.text.strip ();
            } else {
                if (hashoptions.has_key (AriaOptions.PROXYPASSWORD.get_name ())) {
                    hashoptions.unset (AriaOptions.PROXYPASSWORD.get_name ());
                }
            }
            if (loguser_entry.text.strip () != "") {
                hashoptions[AriaOptions.USERNAME.get_name ()] = loguser_entry.text.strip ();
            } else {
                if (hashoptions.has_key (AriaOptions.USERNAME.get_name ())) {
                    hashoptions.unset (AriaOptions.USERNAME.get_name ());
                }
            }
            if (logpass_entry.text.strip () != "") {
                hashoptions[AriaOptions.PASSWORD.get_name ()] = logpass_entry.text.strip ();
            } else {
                if (hashoptions.has_key (AriaOptions.PASSWORD.get_name ())) {
                    hashoptions.unset (AriaOptions.PASSWORD.get_name ());
                }
            }
            if (usefolder.active) {
                hashoptions[AriaOptions.DIR.get_name ()] = folder_location.get_file ().get_path ().replace ("/", "\\/");
            } else {
                if (hashoptions.has_key (AriaOptions.DIR.get_name ())) {
                    hashoptions.unset (AriaOptions.DIR.get_name ());
                }
            }
            if (usecookie.active) {
                hashoptions[AriaOptions.COOKIE.get_name ()] = cookie_location.get_file ().get_path ().replace ("/", "\\/");
            } else {
                if (hashoptions.has_key (AriaOptions.COOKIE.get_name ())) {
                    hashoptions.unset (AriaOptions.COOKIE.get_name ());
                }
            }
            if (refer_entry.text.strip () != "") {
                hashoptions[AriaOptions.REFERER.get_name ()] = refer_entry.text.strip ();
            } else {
                if (hashoptions.has_key (AriaOptions.REFERER.get_name ())) {
                    hashoptions.unset (AriaOptions.REFERER.get_name ());
                }
            }
            if (name_entry.text.strip () != "") {
                hashoptions[AriaOptions.OUT.get_name ()] = name_entry.text.strip ();
            } else {
                if (hashoptions.has_key (AriaOptions.OUT.get_name ())) {
                    hashoptions.unset (AriaOptions.OUT.get_name ());
                }
            }
            if (useragent_entry.text.strip () != "") {
                hashoptions[AriaOptions.USER_AGENT.get_name ()] = useragent_entry.text.strip ();
            } else {
                if (hashoptions.has_key (AriaOptions.USER_AGENT.get_name ())) {
                    hashoptions.unset (AriaOptions.USER_AGENT.get_name ());
                }
            }
            if (checksumtype.checksums.get_name ().down () != "none") {
                if (checksum_entry.text != "") {
                    hashoptions[AriaOptions.CHECKSUM.get_name ()] = checksumtype.checksums.get_name () + checksum_entry.text.strip ();
                }
            } else {
                if (hashoptions.has_key (AriaOptions.CHECKSUM.get_name ())) {
                    hashoptions.unset (AriaOptions.CHECKSUM.get_name ());
                }
            }
            hashoptions[AriaOptions.BT_SAVE_METADATA.get_name ()] = save_meta.active.to_string ();
            hashoptions[AriaOptions.RPC_SAVE_UPLOAD_METADATA.get_name ()] = save_meta.active.to_string ();
            hashoptions[AriaOptions.PROXY_METHOD.get_name ()] = proxymethod.method.get_name ().down ();
            hashoptions[AriaOptions.BT_REQUIRE_CRYPTO.get_name ()] = encrypt.active.to_string ();
            hashoptions[AriaOptions.BT_MIN_CRYPTO_LEVEL.get_name ()] = btencrypt.btencrypt.get_name ().down ();
            if (save) {
                if (checksumtype.checksums.get_name ().down () != "none") {
                    aria_set_option (row.ariagid, AriaOptions.CHECKSUM, checksumtype.checksums.get_name () + checksum_entry.text.strip ());
                } else {
                    aria_set_option (row.ariagid, AriaOptions.CHECKSUM, "");
                }
                aria_set_option (row.ariagid, AriaOptions.PROXYUSERNAME, user_entry.text);
                aria_set_option (row.ariagid, AriaOptions.PROXYPASSWORD, pass_entry.text);
                aria_set_option (row.ariagid, AriaOptions.USERNAME, loguser_entry.text);
                aria_set_option (row.ariagid, AriaOptions.PASSWORD, logpass_entry.text);
                aria_set_option (row.ariagid, AriaOptions.COOKIE, usecookie.active? cookie_location.get_file ().get_path ().replace ("/", "\\/") : "");
                aria_set_option (row.ariagid, AriaOptions.DIR, usefolder.active? folder_location.get_file ().get_path ().replace ("/", "\\/") : get_dbsetting (DBSettings.DIR));
                aria_set_option (row.ariagid, AriaOptions.REFERER, refer_entry.text);
                if (name_entry.text.strip () != "") {
                    aria_set_option (row.ariagid, AriaOptions.OUT, name_entry.text);
                }
                aria_set_option (row.ariagid, AriaOptions.USER_AGENT, useragent_entry.text.strip ());
                aria_set_option (row.ariagid, AriaOptions.PROXY, proxy_entry.text.strip () != ""? @"$(proxy_entry.text):$(port_entry.value))" : "");
                aria_set_option (row.ariagid, AriaOptions.BT_SAVE_METADATA, save_meta.active.to_string ());
                aria_set_option (row.ariagid, AriaOptions.RPC_SAVE_UPLOAD_METADATA, save_meta.active.to_string ());
                aria_set_option (row.ariagid, AriaOptions.PROXY_METHOD, proxymethod.method.get_name ().down ());
                aria_set_option (row.ariagid, AriaOptions.BT_REQUIRE_CRYPTO, encrypt.active.to_string ());
                aria_set_option (row.ariagid, AriaOptions.BT_MIN_CRYPTO_LEVEL, btencrypt.btencrypt.get_name ().down ());
            }
        }

        public override void show () {
            base.show ();
            set_keep_above (true);
        }

        private async void download_send (bool start) throws Error {
            string url = link_entry.text;
            if (url.has_prefix ("file://") && url.has_suffix (".torrent")) {
                string bencode = data_bencoder (File.new_for_uri (url).load_bytes ());
                downloadfile (bencode, hashoptions, start, LinkMode.TORRENT);
            } else if (url.has_prefix ("file://") && url.has_suffix (".meta4")) {
                string bencode = data_bencoder (File.new_for_uri (url).load_bytes ());
                downloadfile (bencode, hashoptions, start, LinkMode.METALINK);
            } else if (url.has_prefix ("file://") && url.has_suffix (".metalink")) {
                string bencode = data_bencoder (File.new_for_uri (url).load_bytes ());
                downloadfile (bencode, hashoptions, start, LinkMode.METALINK);
            } else {
                if (url.has_prefix ("magnet:?")) {
                    downloadfile (url, hashoptions, start, LinkMode.MAGNETLINK);
                } else if (url.has_prefix ("http://") || url.has_prefix ("https://") || url.has_prefix ("ftp://") || url.has_prefix ("sftp://")) {
                    downloadfile (url, hashoptions, start, LinkMode.URL);
                }
            }
        }

        public void add_link (string url, string icon) {
            link_entry.text = url;
            status_image.gicon = new ThemedIcon (icon);
        }

        public void server_link (MatchInfo match_info) {
            link_entry.text = match_info.fetch (PostServer.URL);
            name_entry.text = match_info.fetch (PostServer.FILENAME);
            refer_entry.text = match_info.fetch (PostServer.REFERRER);
            status_image.gicon = GLib.ContentType.get_icon (match_info.fetch (PostServer.MIME));
            sizelabel.label = GLib.format_size (int64.parse (match_info.fetch (PostServer.FILESIZE)));
        }

        public void property (DownloadRow row) {
            this.row = row;
            link_entry.text = row.url;
            this.hashoptions = row.hashoption;
            status_image.gicon = row.imagefile.gicon;
            sizelabel.label = GLib.format_size (row.totalsize);
            if (hashoptions.has_key (AriaOptions.PROXY.get_name ())) {
                proxy_entry.text = hashoptions.@get (AriaOptions.PROXY.get_name ().replace (@":$(hashoptions.@get (AriaOptions.PROXYPORT.get_name ()))", ""));
            }
            if (hashoptions.has_key (AriaOptions.PROXYPORT.get_name ())) {
                port_entry.value = double.parse (hashoptions.@get (AriaOptions.PROXYPORT.get_name ()));
            }
            if (hashoptions.has_key (AriaOptions.PROXYUSERNAME.get_name ())) {
                user_entry.text = hashoptions.@get (AriaOptions.PROXYUSERNAME.get_name ());
            }
            if (hashoptions.has_key (AriaOptions.PROXYPASSWORD.get_name ())) {
                pass_entry.text = hashoptions.@get (AriaOptions.PROXYPASSWORD.get_name ());
            }
            if (hashoptions.has_key (AriaOptions.USERNAME.get_name ())) {
                loguser_entry.text = hashoptions.@get (AriaOptions.USERNAME.get_name ());
            }
            if (hashoptions.has_key (AriaOptions.PASSWORD.get_name ())) {
                logpass_entry.text = hashoptions.@get (AriaOptions.PASSWORD.get_name ());
            }
            usefolder.active = hashoptions.has_key (AriaOptions.DIR.get_name ());
            if (usefolder.active) {
                folder_location.set_uri (File.new_for_path (hashoptions.@get (AriaOptions.DIR.get_name ()).replace ("\\/", "/")).get_uri ());
            }
            usecookie.active = hashoptions.has_key (AriaOptions.COOKIE.get_name ());
            if (usecookie.active) {
                cookie_location.set_uri (File.new_for_path (hashoptions.@get (AriaOptions.COOKIE.get_name ()).replace ("\\/", "/")).get_uri ());
            }
            if (hashoptions.has_key (AriaOptions.REFERER.get_name ())) {
                refer_entry.text = hashoptions.@get (AriaOptions.REFERER.get_name ());
            }
            if (hashoptions.has_key (AriaOptions.USER_AGENT.get_name ())) {
                useragent_entry.text = hashoptions.@get (AriaOptions.USER_AGENT.get_name ());
            }
            if (hashoptions.has_key (AriaOptions.OUT.get_name ())) {
                name_entry.text = hashoptions.@get (AriaOptions.OUT.get_name ());
            }
            if (hashoptions.has_key (AriaOptions.BT_REQUIRE_CRYPTO.get_name ())) {
                encrypt.active = bool.parse (hashoptions.@get (AriaOptions.BT_REQUIRE_CRYPTO.get_name ()));
            }
            if (hashoptions.has_key (AriaOptions.PROXY_METHOD.get_name ())) {
                foreach (var method in method_flow.get_children ()) {
                    if (((ProxyMethod) method).method.get_name ().down () == hashoptions.@get (AriaOptions.PROXY_METHOD.get_name ())) {
                        proxymethod = method as ProxyMethod;
                    }
                };
            }
            if (hashoptions.has_key (AriaOptions.CHECKSUM.get_name ())) {
                foreach (var checksum in checksums_flow.get_children ()) {
                    if (hashoptions.@get (AriaOptions.CHECKSUM.get_name ()).contains (((ChecksumType) checksum).checksums.get_name ())) {
                        checksumtype = checksum as ChecksumType;
                        checksum_entry.text = hashoptions.@get (AriaOptions.CHECKSUM.get_name ()).split ("=")[1];
                    }
                };
            }
            if (hashoptions.has_key (AriaOptions.BT_MIN_CRYPTO_LEVEL.get_name ())) {
                foreach (var encrp in encrypt_flow.get_children ()) {
                    if (hashoptions.@get (AriaOptions.BT_MIN_CRYPTO_LEVEL.get_name ()).contains (((BTEncrypt) encrp).btencrypt.get_name ().down ())) {
                        btencrypt = encrp as BTEncrypt;
                    }
                };
            }
            save_meta.active = bool.parse (hashoptions.get (AriaOptions.RPC_SAVE_UPLOAD_METADATA.get_name ())) | bool.parse (hashoptions.get (AriaOptions.RPC_SAVE_UPLOAD_METADATA.get_name ()));
        }
    }
}
