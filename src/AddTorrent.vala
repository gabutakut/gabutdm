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
    public class AddTorrent : Gtk.Dialog {
        public signal void downloadfile (string url, Gee.HashMap<string, string> options, bool later, int linkmode, bool server = false);
        public signal void update_agid (string ariagid, string newgid);
        private Gtk.Label name_label;
        private Gtk.Label selected_count_label;
        private Gtk.ListView file_list_view;
        private GLib.ListStore file_store;
        private Gtk.Stack file_stack;
        private Gtk.Box folder_view_box;
        private Gtk.ScrolledWindow folder_scroll;
        private Gtk.ListBox current_folder_list;
        private Gtk.Button back_button;
        private Gtk.Button up_button;
        public Gtk.Button save_button;
        private Gtk.Label current_path_label;
        private TrFileInfo? current_folder = null;
        private Gee.ArrayList<TrFileInfo> folder_history;
        private TorrentInfo? current_torrent = null;
        private GLib.HashTable<FileTreeItem, Gtk.CheckButton> check_buttons;
        public DialogType dialogtype { get; construct; }
        private Gtk.FlowBox encrypt_flow;
        private Gtk.MenuButton encrypt_button;
        private Gtk.CheckButton usefolder;
        private Gtk.CheckButton encrypt;
        private Gtk.CheckButton integrity;
        private Gtk.CheckButton unverified;
        private Gtk.Button folder_location;
        private MediaEntry useragent_entry;
        private Gtk.TextView infotorrent;
        private Gtk.TextView commenttext;
        private Gtk.Label createdbylb;
        private Gtk.Label timecreation;
        private Gee.HashMap<string, string> hashoptions;
        private MediaEntry proxy_entry;
        private Gtk.SpinButton port_entry;
        private MediaEntry user_entry;
        private MediaEntry pass_entry;
        public DownloadRow row;
        private string tfile_size;
        private Gtk.MenuButton savedproxy;
        private Gtk.MenuButton type_button;
        private Gtk.FlowBox save_flow;
        private Gtk.FlowBox type_flow;

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

        BTEncrypt _btencrypt = null;
        BTEncrypt btencrypt {
            get {
                return _btencrypt;
            }
            set {
                _btencrypt = value;
                encrypt_button.label = _btencrypt.btencrypt.to_string ();
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

        public AddTorrent() {
            Object (dialogtype: DialogType.ADDTR, resizable: false, use_header_bar: 1);
        }

        public AddTorrent.Property() {
            Object (dialogtype: DialogType.PROPERTY, resizable: false, use_header_bar: 1);
        }

        construct {
            hashoptions = new Gee.HashMap<string, string> ();
            folder_history = new Gee.ArrayList<TrFileInfo>();
            check_buttons = new GLib.HashTable<FileTreeItem, Gtk.CheckButton>(GLib.direct_hash, GLib.direct_equal);
            var view_mode = new ModeButton () {
                hexpand = true,
                homogeneous = true,
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            view_mode.append_text (_("Files"));
            view_mode.append_text (_("Info"));
            view_mode.append_text (_("Proxy"));
            view_mode.append_text (_("Option"));
            view_mode.append_text (_("Torrent"));
            view_mode.selected = 0;
            var header = get_header_bar ();
            header.title_widget = view_mode;
            header.decoration_layout = "none";
            Gtk.Box main_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 10) {
                margin_start = 10,
                margin_end = 10,
                margin_top = 10,
                margin_bottom = 10
            };

            Gtk.Box info_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 5);

            name_label = new Gtk.Label("") {
                max_width_chars = 50,
                halign = Gtk.Align.START,
                wrap = true,
                wrap_mode = Pango.WrapMode.WORD_CHAR,
                xalign = 0,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };
            info_box.append(name_label);

            file_stack = new Gtk.Stack() {
                transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT
            };
            info_box.append(file_stack);
            
            selected_count_label = new Gtk.Label("") {
                halign = Gtk.Align.START,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };
            info_box.append(selected_count_label);

            folder_view_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 5);

            Gtk.Box nav_header = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 2);            
            back_button = new Gtk.Button.from_icon_name("com.github.gabutakut.gabutdm.back") {
                has_frame = false,
                sensitive = false
            };
            back_button.clicked.connect(on_back_clicked);
            nav_header.append(back_button);
            up_button = new Gtk.Button.from_icon_name("com.github.gabutakut.gabutdm.up") {
                has_frame = false,
                sensitive = false
            };
            up_button.clicked.connect(on_up_clicked);
            nav_header.append(up_button);
            var home_button = new Gtk.Button.from_icon_name("com.github.gabutakut.gabutdm.gohome") {
                has_frame = false,
                sensitive = true
            };
            home_button.clicked.connect(() => {
                file_stack.set_visible_child_name("list");
            });
            file_stack.notify["visible-child-name"].connect(() => {
                if (file_stack.get_visible_child_name() == "list") {
                    file_store.sort(folder_first_compare);
                }
            });
            nav_header.append(home_button);

            current_path_label = new Gtk.Label("") {
                halign = Gtk.Align.START,
                hexpand = true,
                xalign = 0,
                max_width_chars = 75,
                ellipsize = Pango.EllipsizeMode.START,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };
            nav_header.append(current_path_label);

            folder_view_box.append(nav_header);
        
            folder_scroll = new Gtk.ScrolledWindow() {
                vexpand = true
            };
            folder_view_box.append(folder_scroll);

            file_stack.add_titled(folder_view_box, "folder", "Isi Folder");
            
            Gtk.Box list_page = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);

            Gtk.ScrolledWindow list_scroll = new Gtk.ScrolledWindow() {
                vexpand = true
            };

            file_store = new GLib.ListStore(typeof(FileTreeItem));
            file_store.items_changed(0, 0, 0);

            Gtk.SignalListItemFactory factory = new Gtk.SignalListItemFactory();
            factory.setup.connect(on_setup_list_item);
            factory.bind.connect(on_bind_list_item);
            factory.unbind.connect(on_unbind_list_item);

            Gtk.SingleSelection selection = new Gtk.SingleSelection(file_store);

            file_list_view = new Gtk.ListView(selection, factory);
            file_list_view.activate.connect(on_file_activated);
            list_scroll.child = file_list_view;

            list_page.append(list_scroll);
            file_stack.add_titled(list_page, "list", "Daftar");

            file_stack.set_visible_child_name("list");

            createdbylb = new Gtk.Label (null) {
                ellipsize = Pango.EllipsizeMode.END,
                hexpand = true,
                use_markup = true,
                xalign = 0,
                max_width_chars = 30,
                width_request = 200,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };

            timecreation = new Gtk.Label (null) {
                ellipsize = Pango.EllipsizeMode.END,
                hexpand = true,
                use_markup = true,
                xalign = 0,
                max_width_chars = 30,
                width_request = 200,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };

            infotorrent = new Gtk.TextView () {
                hexpand = true,
                editable = false,
                wrap_mode = Gtk.WrapMode.WORD_CHAR
            };

            var infoscr = new Gtk.ScrolledWindow () {
                hexpand = true,
                width_request = 250,
                height_request = 140,
                child = infotorrent
            };

            commenttext = new Gtk.TextView () {
                hexpand = true,
                editable = false,
                wrap_mode = Gtk.WrapMode.WORD_CHAR
            };

            var comment = new Gtk.ScrolledWindow () {
                hexpand = true,
                width_request = 250,
                height_request = 140,
                child = commenttext
            };

            var torrentinfo = new Gtk.Grid () {
                hexpand = true,
                column_homogeneous = true,
                height_request = 140,
                column_spacing = 10,
                margin_bottom = 5,
                valign = Gtk.Align.CENTER,
                width_request = 550
            };
            torrentinfo.attach (createdbylb, 0, 0, 1, 1);
            torrentinfo.attach (headerlabel (_("Announce:"), 250), 0, 1, 1, 1);
            torrentinfo.attach (infoscr, 0, 2, 1, 1);
            torrentinfo.attach (timecreation, 1, 0, 1, 1);
            torrentinfo.attach (headerlabel (_("Comment:"), 250), 1, 1, 1, 1);
            torrentinfo.attach (comment, 1, 2, 1, 1);

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

            var moregrid = new Gtk.Grid () {
                height_request = 130,
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            moregrid.attach (usefolder, 1, 0, 1, 1);
            moregrid.attach (folder_location, 1, 1, 1, 1);
            moregrid.attach (headerlabel (_("User Agent:"), 425), 1, 2, 1, 1);
            moregrid.attach (useragent_entry, 1, 3, 1, 1);

            integrity = new Gtk.CheckButton.with_label (_("BT Seed")) {
                tooltip_text = _("Check file integrity by validating piece hashes or a hash of entire file."),
                width_request = 350,
                margin_bottom = 5
            };

            unverified = new Gtk.CheckButton.with_label (_("BT Seed Unverified")) {
                tooltip_text = _("Seed previously downloaded files without verifying piece hashes"),
                width_request = 350
            };

            encrypt_flow = new Gtk.FlowBox ();
            var encrypt_popover = new Gtk.Popover () {
                child = encrypt_flow
            };
            encrypt_button = new Gtk.MenuButton () {
                popover = encrypt_popover
            };
            foreach (var encrp in BTEncrypts.get_all ()) {
                encrypt_flow.append (new BTEncrypt (encrp));
            }
            encrypt_flow.set_visible (true);

            encrypt_flow.child_activated.connect ((encrp)=> {
                ((Gtk.Label)((BTEncrypt) btencrypt).get_last_child ()).attributes = set_attribute (Pango.Weight.BOLD);
                btencrypt = encrp as BTEncrypt;
                ((Gtk.Label)btencrypt.get_last_child ()).attributes = color_attribute (0, 60000, 0);
                encrypt_popover.set_visible (false);
            });
            btencrypt = encrypt_flow.get_child_at_index (0) as BTEncrypt;
            ((Gtk.Label)btencrypt.get_last_child ()).attributes = color_attribute (0, 60000, 0);

            encrypt_popover.show.connect (() => {
                encrypt_flow.unselect_all ();
            });
            encrypt = new Gtk.CheckButton.with_label (_("BT Require Crypto")) {
                tooltip_text = _("Aria2 doesn't accept and establish connection with legacy BitTorrent handshake"),
                width_request = 350,
                margin_bottom = 5
            };
            encrypt.toggled.connect (()=> {
                encrypt_button.sensitive = encrypt.active;
            });
            encrypt_button.sensitive = encrypt.active;

            var encryptgrid = new Gtk.Grid () {
                height_request = 130,
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            encryptgrid.attach (headerlabel (_("BitTorrent Seed:"), 425), 1, 0, 1, 1);
            encryptgrid.attach (integrity, 1, 1, 1, 1);
            encryptgrid.attach (unverified, 1, 2, 1, 1);
            encryptgrid.attach (headerlabel (_("BitTorrent Encryption:"), 425), 1, 3, 1, 1);
            encryptgrid.attach (encrypt, 1, 4, 1, 1);
            encryptgrid.attach (encrypt_button, 1, 5, 1, 1);

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

            var stack = new Gtk.Stack () {
                transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT,
                transition_duration = 500,
                width_request = 680,
                height_request = 210
            };
            stack.add_named (info_box, "filelist");
            stack.add_named (torrentinfo, "ifotorr");
            stack.add_named (proxygrid, "proxy");
            stack.add_named (moregrid, "moregrid");
            stack.add_named (encryptgrid, "encryptgrid");
            stack.visible_child = info_box;
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
                new Thread<void> ("strnow-%s".printf (get_monotonic_time ().to_string ()), () => {
                    var encodetr = Base64.encode (BencodeParser.encode_to_bytes (current_torrent.bencode_data.copy()));
                    MainContext.default ().invoke (() => {
                        trset_options ();
                        downloadfile (encodetr, hashoptions, false, LinkMode.TORRENT);
                        return false;
                    });
                });
                close ();
            });

            var later_button = new Gtk.Button.with_label (_("Download Later")) {
                width_request = 120,
                height_request = 25
            };
            ((Gtk.Label) later_button.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            later_button.clicked.connect (()=> {
                new Thread<void> ("strlater-%s".printf (get_monotonic_time ().to_string ()), () => {
                    var encodetr = Base64.encode (BencodeParser.encode_to_bytes (current_torrent.bencode_data.copy()));
                    MainContext.default ().invoke (() => {
                        trset_options ();
                        downloadfile (encodetr, hashoptions, true, LinkMode.TORRENT);
                        return false;
                    });
                });
                close ();
            });

            save_button = new Gtk.Button.with_label (_("Save")) {
                width_request = 120,
                height_request = 25
            };
            ((Gtk.Label) save_button.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            save_button.clicked.connect (()=> {
                trset_options ();
                savetoaria ();
                close ();
            });
            var box_action = new Gtk.CenterBox () {
                margin_top = 5,
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
                        stack.visible_child = torrentinfo;
                        break;
                    case 2:
                        stack.visible_child = proxygrid;
                        break;
                    case 3:
                        stack.visible_child = moregrid;
                        break;
                    case 4:
                        stack.visible_child = encryptgrid;
                        break;
                    default:
                        stack.visible_child = info_box;
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

        private void on_setup_list_item(Gtk.SignalListItemFactory factory, GLib.Object object) {
            Gtk.ListItem item = object as Gtk.ListItem;
            if (item == null) {
                return;
            }
            Gtk.Box row = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5) {
                margin_start = 2,
                margin_end = 5
            };

            Gtk.CheckButton check_button = new Gtk.CheckButton() {
                valign = Gtk.Align.CENTER,
                margin_start = 5
            };
            check_button.toggled.connect((btn) => {
                if (item.item is FileTreeItem) {
                    FileTreeItem tree_item = (FileTreeItem) item.item;
                    tree_item.file_info.selected = btn.active;
                    update_selected_count();
                }
            });
            row.append(check_button);

            Gtk.Image icon = new Gtk.Image() {
                pixel_size = 16
            };
            row.append(icon);

            Gtk.Label name_label = new Gtk.Label("") {
                halign = Gtk.Align.START,
                hexpand = true,
                xalign = 0,
                use_markup = true,
                width_request = 450,
                max_width_chars = 70,
                ellipsize = Pango.EllipsizeMode.MIDDLE,
                valign = Gtk.Align.CENTER,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };
            row.append(name_label);

            Gtk.Label size_label = new Gtk.Label("") {
                halign = Gtk.Align.END,
                attributes = color_attribute (0, 60000, 0)
            };
            row.append(size_label);

            item.child = row;
        }
        
        private void on_bind_list_item(Gtk.SignalListItemFactory factory, GLib.Object object) {
            Gtk.ListItem item = object as Gtk.ListItem;
            if (item == null) {
                return;
            }
            FileTreeItem? tree_item = item.item as FileTreeItem;
            if (tree_item == null) {
                return;
            }
            Gtk.Box row = item.child as Gtk.Box;
            if (row == null) {
                return;
            }
            Gtk.CheckButton check_button = row.get_first_child() as Gtk.CheckButton;
            Gtk.Image icon = check_button.get_next_sibling() as Gtk.Image;
            Gtk.Label name_label = icon.get_next_sibling() as Gtk.Label;
            Gtk.Label size_label = name_label.get_next_sibling() as Gtk.Label;

            if (tree_item != null && check_button != null) {
                check_buttons.set(tree_item, check_button);
            }

            if (check_button != null) {
                check_button.active = tree_item.file_info.selected;
                if (tree_item.file_info.is_folder) {
                    int64 total_select = 0;
                    int64 all_select = 0;
                    selected_in_folder (tree_item.file_info, ref total_select, ref all_select);
                    if (total_select >= all_select) {
                        check_button.inconsistent = false;
                        check_button.active = true;
                    } else if (total_select > 0 && total_select < all_select) {
                        check_button.inconsistent = true;
                    } else if (total_select == 0) {
                        check_button.active = false;
                    } else {
                        check_button.inconsistent = false;
                    }
                }
                ulong handler_id = check_button.get_data<ulong>("toggle-handler");
                if (handler_id != 0) {
                    check_button.disconnect(handler_id);
                }
                handler_id = check_button.toggled.connect(() => {
                    tree_item.file_info.selected = check_button.active;
                    if (tree_item.file_info.is_folder) {
                        if (check_button.inconsistent) {
                            check_button.inconsistent = false;
                        }
                        update_folder_selection(tree_item.file_info, check_button.active);
                    }
                    update_selected_count();
                });
                check_button.set_data<ulong>("toggle-handler", handler_id);
            }
            if (icon != null) {
                if (tree_item.file_info.is_folder) {
                    icon.icon_name = "folder";
                } else {
                    icon.gicon = get_icon_for_filename(tree_item.file_info.path);
                }
            }
            if (name_label != null) {
                string display_name = tree_item.file_info.path;
                name_label.label = display_name;
            }
            if (size_label != null) {
                size_label.label = GLib.format_size(tree_item.file_info.size);
            }
        }

        private void on_unbind_list_item(Gtk.SignalListItemFactory factory, GLib.Object object) {
            Gtk.ListItem item = object as Gtk.ListItem;
            if (item == null) {
                return;
            }
            FileTreeItem? tree_item = item.item as FileTreeItem;
            if (tree_item != null) {
                check_buttons.remove(tree_item);
            }
        }

        private void on_file_activated(uint position) {
            FileTreeItem? tree_item = file_store.get_item(position) as FileTreeItem;
            if (tree_item == null || !tree_item.file_info.is_folder) {
                return;
            }
            navigate_to_folder(tree_item.file_info);
        }

        private void on_back_clicked() {
            if (folder_history.size > 0) {
                folder_history.remove_at(folder_history.size - 1);
                if (folder_history.size > 0) {
                    navigate_to_folder(folder_history[folder_history.size - 1], false);
                } else {
                    current_folder = null;
                    update_navigation_buttons();
                    file_stack.set_visible_child_name("list");
                }
            }
        }

        private void on_up_clicked() {
            if (current_folder != null && current_folder.parent != null) {
                navigate_to_folder(current_folder.parent);
            }
        }

        private void update_folder_selection(TrFileInfo folder, bool selected) {
            folder.selected = selected;
            foreach (TrFileInfo child in folder.children) {
                child.selected = selected;
                if (child.is_folder) {
                    update_folder_selection(child, selected);
                }
            }
        }
        
        private void navigate_to_folder(TrFileInfo folder, bool add_to_history = true) {
            if (add_to_history && current_folder != null) {
                folder_history.add(current_folder);
            }
            
            current_folder = folder;
            update_navigation_buttons();
            show_folder_contents(folder);
            file_stack.set_visible_child_name("folder");
        }
        
        private void update_navigation_buttons() {
            back_button.sensitive = (folder_history.size > 0);
            up_button.sensitive = (current_folder != null && current_folder.parent != null);
            if (current_folder != null) {
                Gee.ArrayList<string> path_parts = new Gee.ArrayList<string>();
                TrFileInfo? current = current_folder;
                while (current != null) {
                    path_parts.insert(0, current.path);
                    current = current.parent;
                }
                string[] path_array = new string[path_parts.size];
                for (int i = 0; i < path_parts.size; i++) {
                    path_array[i] = path_parts.get(i);
                }
                string path_str = string.joinv(" / ", path_array);
                current_path_label.label = path_str;
            } else {
                current_path_label.label = "";
            }
        }
        
        private void show_folder_contents(TrFileInfo folder) {
            Gtk.Widget? child = folder_scroll.child;
            if (child != null) {
                folder_scroll.child = null;
            }

            current_folder_list = new Gtk.ListBox() {
                selection_mode = Gtk.SelectionMode.BROWSE
            };

            Gtk.GestureClick gesture = new Gtk.GestureClick() {
                button = Gdk.BUTTON_PRIMARY
            };
            gesture.pressed.connect((n_press, x, y) => {
                if (n_press == 2) {
                    Gtk.ListBoxRow? row = current_folder_list.get_row_at_y((int)y);
                    if (row != null) {
                        Gtk.Widget? row_widget = row.get_child();
                        if (row_widget != null) {
                            Gtk.Box? row_box = row_widget as Gtk.Box;
                            if (row_box != null) {
                                Gtk.CheckButton? checkbtn = row_box.get_first_child() as Gtk.CheckButton;
                                if(checkbtn != null) {
                                    Gtk.Image? icon = checkbtn.get_next_sibling() as Gtk.Image;
                                    if (icon != null && icon.icon_name == "folder") {
                                        string folder_name = "";
                                        Gtk.Label? name_label = icon.get_next_sibling() as Gtk.Label;
                                        if (name_label != null) {
                                            folder_name = name_label.label;
                                        }
                                        foreach (TrFileInfo item in folder.children) {
                                            if (item.is_folder && item.path == folder_name) {
                                                navigate_to_folder(item);
                                                break;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            });
            current_folder_list.add_controller(gesture);

            if (folder.children.size > 0) {
                foreach (TrFileInfo item in folder.children) {
                    if (item.is_folder) {
                        current_folder_list.append(create_folder_row(item));
                    }
                }
            }

            if (folder.children.size > 0) {
                bool has_files = false;
                foreach (TrFileInfo item in folder.children) {
                    if (!item.is_folder) {
                        has_files = true;
                        break;
                    }
                }

                if (has_files) {
                    foreach (TrFileInfo item in folder.children) {
                        if (!item.is_folder) {
                            current_folder_list.append(create_file_row(item));
                        }
                    }
                }
            }

            folder_scroll.child = current_folder_list;
            update_navigation_buttons();
        }

        private void selected_in_folder(TrFileInfo folder, ref int64 totalselect, ref int64 allselect) {
            foreach (TrFileInfo child in folder.children) {
                if (!child.is_folder) {
                    if (child.selected) {
                        totalselect++;
                    }
                    allselect++;
                } else {
                    selected_in_folder(child, ref totalselect, ref allselect);
                }
            }
        }

        private Gtk.Widget create_folder_row(TrFileInfo folder) {
            Gtk.Box row = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5) {
                margin_start = 2,
                margin_end = 5
            };
            Gtk.CheckButton check_button = new Gtk.CheckButton() {
                active = folder.selected,
                sensitive = true
            };
            int64 total_select = 0;
            int64 all_select = 0;
            selected_in_folder (folder, ref total_select, ref all_select);
            if (total_select >= all_select) {
                check_button.inconsistent = false;
                check_button.active = true;
            } else if (total_select > 0 && total_select < all_select) {
                check_button.inconsistent = true;
                check_button.active = false;
            } else {
                check_button.inconsistent = false;
                check_button.active = false;
            }
            check_button.toggled.connect(() => {
                if (check_button.inconsistent) {
                    check_button.inconsistent = false;
                }
                folder.selected = check_button.active;
                update_folder_selection(folder, check_button.active);
                update_selected_count();
            });
            row.append(check_button);

            Gtk.Image icon = new Gtk.Image() {
                icon_name = "folder",
                pixel_size = 16
            };
            row.append(icon);
            Gtk.Label name_label = new Gtk.Label(folder.path) {
                halign = Gtk.Align.START,
                hexpand = true,
                xalign = 0,
                use_markup = true,
                width_request = 450,
                max_width_chars = 70,
                ellipsize = Pango.EllipsizeMode.MIDDLE,
                valign = Gtk.Align.CENTER,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };
            row.append(name_label);
            Gtk.Label size_label = new Gtk.Label(GLib.format_size(folder.size)) {
                halign = Gtk.Align.END,
                attributes = color_attribute (0, 60000, 0)
            };
            row.append(size_label);
            return row;
        }
        
        private Gtk.Widget create_file_row(TrFileInfo file) {
            Gtk.Box row = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5) {
                margin_start = 2,
                margin_end = 5
            };
            Gtk.CheckButton check_button = new Gtk.CheckButton() {
                active = file.selected
            };
            check_button.toggled.connect((btn) => {
                file.selected = btn.active;
                update_selected_count();
            });
            row.append(check_button);
            Gtk.Image icon = new Gtk.Image() {
                gicon = get_icon_for_filename(file.path),
                pixel_size = 16
            };
            row.append(icon);
            
            Gtk.Label name_label = new Gtk.Label(file.path) {
                halign = Gtk.Align.START,
                hexpand = true,
                xalign = 0,
                use_markup = true,
                width_request = 450,
                max_width_chars = 70,
                ellipsize = Pango.EllipsizeMode.MIDDLE,
                valign = Gtk.Align.CENTER,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };
            row.append(name_label);
            Gtk.Label size_label = new Gtk.Label(GLib.format_size(file.size)) {
                halign = Gtk.Align.END,
                attributes = color_attribute (0, 60000, 0)
            };
            row.append(size_label);
            return row;
        }

        public void load_torrent(string filepath) {
            TorrentInfo? info = TorrentParser.parse_file(filepath);
            opentorrent (info);
        }

        private void opentorrent (TorrentInfo info) {
            if (info == null) {
                return;
            }
            current_torrent = info;
            if (row != null) {
                if (hashoptions.has_key (AriaOptions.SELECT_FILE.to_string ())) {
                    var hasoption = get_dboptions (row.url);
                    var selected_indices = TorrentParser.parse_selected_indices(hasoption.@get (AriaOptions.SELECT_FILE.to_string ()));
                    TorrentParser.apply_selection_to_files(current_torrent.files, selected_indices);
                }
            }
            name_label.label = info.name;
            tfile_size = GLib.format_size(info.total_size);
            createdbylb.label = _("Created by: %s").printf (info.created_by);
            timecreation.label = _("Time Creation: %s").printf (info.creation_date != 0? new GLib.DateTime.from_unix_local (info.creation_date).format ("%a, %I:%M %p %x") : "");
            refresh_file_list();

            folder_history.clear();
            current_folder = null;
            update_navigation_buttons();

            update_selected_count();

            infotorrent.buffer.text = "";
            foreach (string announce_url in info.announce_list) {
                infotorrent.buffer.text += announce_url.make_valid();
                infotorrent.buffer.text += "\n";
            }
            if (info.comment != "") {
                commenttext.buffer.text = info.comment.make_valid();
            } else {
                commenttext.buffer.text = _("Nothing comment");
            }
        }
        
        private void refresh_file_list() {
            if (current_torrent == null) {
                return;
            }
            file_store.remove_all();
            check_buttons.remove_all();
            foreach (TrFileInfo file in current_torrent.files) {
                file_store.append(new FileTreeItem(file, true));
            }
            file_store.sort(folder_first_compare);
        }
        
        private void update_selected_count() {
            if (current_torrent == null) {
                selected_count_label.label = _("Selected: 0 of 0 Size: 0 of %s").printf (tfile_size);
                return;
            }
            int selected = count_selected_files(current_torrent.files);
            int64 sizeselect = size_selected_files ((current_torrent.files));
            selected_count_label.label = _("Selected: %d of %d Size: %s of %s").printf(selected, current_torrent.file_count, GLib.format_size(sizeselect), tfile_size);
        }

        private static int folder_first_compare(GLib.Object a, GLib.Object b) {
            FileTreeItem fa = a as FileTreeItem;
            FileTreeItem fb = b as FileTreeItem;
            if (fa == null || fb == null) {
                return 0;
            }
            if (fa.file_info.is_folder && !fb.file_info.is_folder) {
                return -1;
            }
            if (!fa.file_info.is_folder && fb.file_info.is_folder) {
                return 1;
            }
            return fa.file_info.path.collate(fb.file_info.path);
        }

        private int count_selected_files(Gee.ArrayList<TrFileInfo> files) {
            int count = 0;
            foreach (TrFileInfo file in files) {
                if (file.is_folder) {
                    count += count_selected_files(file.children);
                } else if (file.selected) {
                    count++;
                }
            }
            return count;
        }

        private int64 size_selected_files(Gee.ArrayList<TrFileInfo> files) {
            int64 sizecount = 0;
            foreach (TrFileInfo file in files) {
                if (file.is_folder) {
                    sizecount = sizecount + size_selected_files(file.children);
                } else if (file.selected) {
                    sizecount = sizecount + file.size;
                }
            }
            return sizecount;
        }

        private void trset_options() {
            if (current_torrent == null) {
                return;
            }
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
                hashoptions[AriaOptions.DIR.to_string ()] = selectfd.get_path ().replace ("/", "\\/");
            } else {
                if (hashoptions.has_key (AriaOptions.DIR.to_string ())) {
                    hashoptions.unset (AriaOptions.DIR.to_string ());
                }
            }
            hashoptions[AriaOptions.BT_SEED_UNVERIFIED.to_string ()] = unverified.active.to_string ();
            hashoptions[AriaOptions.CHECK_INTEGRITY.to_string ()] = integrity.active.to_string ();
            hashoptions[AriaOptions.BT_SAVE_METADATA.to_string ()] = false.to_string ();
            hashoptions[AriaOptions.RPC_SAVE_UPLOAD_METADATA.to_string ()] = false.to_string ();
            hashoptions[AriaOptions.BT_REQUIRE_CRYPTO.to_string ()] = encrypt.active.to_string ();
            hashoptions[AriaOptions.BT_MIN_CRYPTO_LEVEL.to_string ()] = btencrypt.btencrypt.to_string ().down ();
            if (!integrity.active && !unverified.active) {
                hashoptions[AriaOptions.SEED_TIME.to_string ()] = "0";
            } else {
                hashoptions[AriaOptions.SEED_TIME.to_string ()] = get_dbsetting (DBSettings.SEEDTIME);
            }
            int selectedidx = count_selected_files(current_torrent.files);
            if (selectedidx != current_torrent.file_count) {
                string command = TorrentParser.selected_options(current_torrent);
                hashoptions[AriaOptions.SELECT_FILE.to_string ()] = command;
            } else {
                hashoptions.unset (AriaOptions.SELECT_FILE.to_string ());
            }
        }

        private void savetoaria () {
            aria_unpause (row.ariagid);
            aria_remove (row.ariagid);
            if (row.linkmode == LinkMode.TORRENT) {
                var rowariagid = aria_torrent (row.url, hashoptions, actwaiting ());
                update_agid (row.ariagid, rowariagid);
                row.ariagid = rowariagid;
            } else if (row.linkmode == LinkMode.METALINK) {
                var rowariagid = aria_metalink (row.url, hashoptions, actwaiting ());
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

        public override void show () {
            if (row != null) {
                this.hashoptions = row.hashoption;
                var encod = GLib.Base64.decode(row.url);
                TorrentInfo? info = TorrentParser.parsetorrent(encod);
                opentorrent (info);
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
                string agntusr = aria_get_option (row.ariagid, AriaOptions.USER_AGENT);
                if (agntusr != "") {
                    useragent_entry.text = agntusr.contains ("\\/")? agntusr.replace ("\\/", "/") : agntusr;
                }
                encrypt.active = bool.parse (aria_get_option (row.ariagid, AriaOptions.BT_REQUIRE_CRYPTO));
                integrity.active = bool.parse (aria_get_option (row.ariagid, AriaOptions.CHECK_INTEGRITY));
                unverified.active = bool.parse (aria_get_option (row.ariagid, AriaOptions.BT_SEED_UNVERIFIED));
                if (encrypt.active) {
                    foreach (var c in BTEncrypts.get_all ()) {
                        var encrp = encrypt_flow.get_child_at_index (c);
                        if (aria_get_option (row.ariagid, AriaOptions.BT_MIN_CRYPTO_LEVEL).contains (((BTEncrypt) encrp).btencrypt.to_string ().down ())) {
                            btencrypt = encrp as BTEncrypt;
                        }
                    }
                }
            }
            base.show ();
        }
    }
}