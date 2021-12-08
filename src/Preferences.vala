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
    public class Preferences : Gtk.Dialog {
        public signal void restart_server ();
        public signal void max_active ();
        private Gtk.MenuButton allocate_button;

        FileAllocation _fileallocation = null;
        FileAllocation fileallocation {
            get {
                return _fileallocation;
            }
            set {
                _fileallocation = value;
                allocate_button.label = _("File Allocation: %s").printf (_fileallocation.fileallocation.get_name ());
            }
        }

        public Preferences (Gtk.Application application) {
            Object (application: application,
                    resizable: false,
                    use_header_bar: 1
            );
        }

        construct {
            var view_mode = new ModeButton () {
                hexpand = false,
                margin = 2,
                width_request = 300
            };
            view_mode.append_text (_("Default"));
            view_mode.append_text (_("BitTorrent"));
            view_mode.append_text (_("Folder"));
            view_mode.append_text (_("RPC Option"));
            view_mode.append_text (_("System"));
            view_mode.selected = 0;

            var header = get_header_bar ();
            header.has_subtitle = false;
            header.show_close_button = false;
            header.get_style_context ().add_class (Gtk.STYLE_CLASS_HEADER);
            header.set_custom_title (view_mode);

            var numbtries = new Gtk.SpinButton.with_range (0, 100, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (aria_get_globalops (AriaOptions.MAX_TRIES))
            };

            var numbconn = new Gtk.SpinButton.with_range (0, 16, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (aria_get_globalops (AriaOptions.MAX_CONNECTION_PER_SERVER))
            };

            var maxcurrent = new Gtk.SpinButton.with_range (1, 20, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (aria_get_globalops (AriaOptions.MAX_CONCURRENT_DOWNLOADS))
            };

            var timeout = new Gtk.SpinButton.with_range (0, 600, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (aria_get_globalops (AriaOptions.TIMEOUT))
            };

            var retry = new Gtk.SpinButton.with_range (0, 100, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (aria_get_globalops (AriaOptions.RETRY_WAIT))
            };

            var split = new Gtk.SpinButton.with_range (0, 100, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (aria_get_globalops (AriaOptions.SPLIT))
            };

            var settings = new Gtk.Grid () {
                expand = true,
                height_request = 150,
                margin_bottom = 5,
                column_spacing = 10,
                halign = Gtk.Align.START
            };
            settings.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            settings.attach (new HeaderLabel (_("Number of Tries:"), 220), 1, 0, 1, 1);
            settings.attach (numbtries, 1, 1, 1, 1);
            settings.attach (new HeaderLabel (_("Connection:"), 220), 0, 0, 1, 1);
            settings.attach (numbconn, 0, 1, 1, 1);
            settings.attach (new HeaderLabel (_("Active Download:"), 220), 1, 2, 1, 1);
            settings.attach (maxcurrent, 1, 3, 1, 1);
            settings.attach (new HeaderLabel (_("Time out (in Secconds):"), 220), 0, 2, 1, 1);
            settings.attach (timeout, 0, 3, 1, 1);
            settings.attach (new HeaderLabel (_("Retry Wait:"), 220), 1, 4, 1, 1);
            settings.attach (retry, 1, 5, 1, 1);
            settings.attach (new HeaderLabel (_("Split:"), 220), 0, 4, 1, 1);
            settings.attach (split, 0, 5, 1, 1);

            var maxopfile = new Gtk.SpinButton.with_range (0, 100, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (aria_get_globalops (AriaOptions.BT_MAX_OPEN_FILES))
            };

            var maxpeers = new Gtk.SpinButton.with_range (0, 100, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (aria_get_globalops (AriaOptions.BT_MAX_PEERS))
            };

            var bt_timeout = new Gtk.SpinButton.with_range (0, 240, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (aria_get_globalops (AriaOptions.BT_TRACKER_TIMEOUT))
            };

            var bt_seedtime = new Gtk.SpinButton.with_range (0, 240, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (aria_get_globalops (AriaOptions.SEED_TIME))
            };

            var bittorrent = new Gtk.Grid () {
                expand = true,
                height_request = 150,
                margin_bottom = 5,
                column_spacing = 10,
                halign = Gtk.Align.START
            };
            bittorrent.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            bittorrent.attach (new HeaderLabel (_("Max Open File:"), 220), 1, 0, 1, 1);
            bittorrent.attach (maxopfile, 1, 1, 1, 1);
            bittorrent.attach (new HeaderLabel (_("Bittorent Max Peers:"), 220), 0, 0, 1, 1);
            bittorrent.attach (maxpeers, 0, 1, 1, 1);
            bittorrent.attach (new HeaderLabel (_("Tracker Time out (in Secconds):"), 220), 1, 2, 1, 1);
            bittorrent.attach (bt_timeout, 1, 3, 1, 1);
            bittorrent.attach (new HeaderLabel (_("Seed Time (in Minutes):"), 220), 0, 2, 1, 1);
            bittorrent.attach (bt_seedtime, 0, 3, 1, 1);

            var folder_location = new Gtk.FileChooserButton (_("Open"), Gtk.FileChooserAction.SELECT_FOLDER);
            var filter_folder = new Gtk.FileFilter ();
            filter_folder.add_mime_type ("inode/directory");
            folder_location.set_filter (filter_folder);
            folder_location.set_uri (File.new_for_path (aria_get_globalops (AriaOptions.DIR).replace ("\\/", "/")).get_uri ());

            var folderopt = new Gtk.Grid () {
                expand = true,
                height_request = 150,
                margin_bottom = 5,
                halign = Gtk.Align.START
            };
            folderopt.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            folderopt.attach (new HeaderLabel (_("Folder:"), 450), 1, 0, 1, 1);
            folderopt.attach (folder_location, 1, 1, 1, 1);

            var rpc_port = new Gtk.SpinButton.with_range (0, 9999, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (aria_get_globalops (AriaOptions.RPC_LISTEN_PORT))
            };

            var local_port = new Gtk.SpinButton.with_range (0, 9999, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (get_dbsetting (DBSettings.PORTLOCAL))
            };

            var maxrequest = new Gtk.SpinButton.with_range (0, 9000000000, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (aria_get_globalops (AriaOptions.RPC_MAX_REQUEST_SIZE))
            };

            var diskcache = new Gtk.SpinButton.with_range (0, 9000000000, 1) {
                width_request = 220,
                hexpand = true,
                value = double.parse (aria_get_globalops (AriaOptions.DISK_CACHE))
            };
            allocate_button = new Gtk.MenuButton () {
                margin_top = 5
            };
            var allocate_flow = new Gtk.FlowBox ();
            var allocate_popover = new Gtk.Popover (allocate_button);
            allocate_popover.position = Gtk.PositionType.TOP;
            allocate_popover.add (allocate_flow);
            allocate_popover.show.connect (() => {
                if (fileallocation != null) {
                    allocate_flow.select_child (fileallocation);
                    fileallocation.grab_focus ();
                }
            });
            allocate_button.popover = allocate_popover;
            foreach (var allocate in FileAllocations.get_all ()) {
                allocate_flow.add (new FileAllocation (allocate));
            }
            allocate_flow.show_all ();
            allocate_flow.child_activated.connect ((allocate)=> {
                fileallocation = allocate as FileAllocation;
                allocate_popover.hide ();
            });
            foreach (var allocate in allocate_flow.get_children ()) {
                if (((FileAllocation) allocate).fileallocation.get_name () == get_dbsetting (DBSettings.FILEALLOCATION)) {
                    fileallocation = allocate as FileAllocation;
                }
            };

            var moreoptions = new Gtk.Grid () {
                expand = true,
                height_request = 150,
                margin_bottom = 5,
                column_spacing = 10,
                halign = Gtk.Align.START
            };
            moreoptions.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            moreoptions.attach (new HeaderLabel (_("RPC Port:"), 220), 1, 0, 1, 1);
            moreoptions.attach (rpc_port, 1, 1, 1, 1);
            moreoptions.attach (new HeaderLabel (_("Local Port:"), 220), 0, 0, 1, 1);
            moreoptions.attach (local_port, 0, 1, 1, 1);
            moreoptions.attach (new HeaderLabel (_("RPC Max Request Size (in Byte):"), 220), 1, 2, 1, 1);
            moreoptions.attach (maxrequest, 1, 3, 1, 1);
            moreoptions.attach (new HeaderLabel (_("Disk Cache (in Byte):"), 220), 1, 4, 1, 1);
            moreoptions.attach (diskcache, 1, 5, 1, 1);
            moreoptions.attach (allocate_button, 1, 6, 1, 1);

            var notifydia = new Gtk.Grid ();
            notifydia.add (new Gtk.Image.from_icon_name ("dialog-information", Gtk.IconSize.SMALL_TOOLBAR));
            notifydia.add (new Gtk.Label (_("Open dialog succes when download complete")));

            var dialognotify = new Gtk.CheckButton () {
                margin_top = 5,
                width_request = 450,
                active = bool.parse (get_dbsetting (DBSettings.DIALOGNOTIF))
            };
            dialognotify.add (notifydia);

            var notifygrid = new Gtk.Grid ();
            notifygrid.add (new Gtk.Image.from_icon_name ("preferences-system-notifications", Gtk.IconSize.SMALL_TOOLBAR));
            notifygrid.add (new Gtk.Label (_("Send notification system")));

            var systemnotif = new Gtk.CheckButton () {
                margin_top = 5,
                width_request = 450,
                active = bool.parse (get_dbsetting (DBSettings.SYSTEMNOTIF))
            };
            systemnotif.add (notifygrid);

            var deletegrid = new Gtk.Grid ();
            deletegrid.add (new Gtk.Image.from_icon_name ("system-shutdown", Gtk.IconSize.SMALL_TOOLBAR));
            deletegrid.add (new Gtk.Label (_("Running on background")));

            var retonhide = new Gtk.CheckButton () {
                margin_top = 5,
                width_request = 450,
                active = bool.parse (get_dbsetting (DBSettings.ONBACKGROUND))
            };
            retonhide.add (deletegrid);

            var startupgrid = new Gtk.Grid ();
            startupgrid.add (new Gtk.Image.from_icon_name ("system-run", Gtk.IconSize.SMALL_TOOLBAR));
            startupgrid.add (new Gtk.Label (_("Launch App on Startup")));

            var appstartup = new Gtk.CheckButton () {
                margin_top = 5,
                width_request = 450,
                active = bool.parse (get_dbsetting (DBSettings.STARTUP))
            };
            appstartup.add (startupgrid);

            var replacegrid = new Gtk.Grid ();
            replacegrid.add (new Gtk.Image.from_icon_name ("edit-find-replace", Gtk.IconSize.SMALL_TOOLBAR));
            replacegrid.add (new Gtk.Label (_("Replace File")));

            var allowrepl = new Gtk.CheckButton () {
                margin_top = 5,
                width_request = 450,
                active = bool.parse (aria_get_globalops (AriaOptions.ALLOW_OVERWRITE))
            };
            allowrepl.add (replacegrid);

            var autorengrid = new Gtk.Grid ();
            autorengrid.add (new Gtk.Image.from_icon_name ("edit", Gtk.IconSize.SMALL_TOOLBAR));
            autorengrid.add (new Gtk.Label (_("Auto Rename")));

            var autorename = new Gtk.CheckButton () {
                margin_top = 5,
                width_request = 450,
                active = bool.parse (aria_get_globalops (AriaOptions.AUTO_FILE_RENAMING))
            };
            autorename.add (autorengrid);

            var notifyopt = new Gtk.Grid () {
                expand = true,
                height_request = 190
            };
            notifyopt.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            notifyopt.attach (new HeaderLabel (_("Settings:"), 450), 0, 0, 1, 1);
            notifyopt.attach (retonhide, 0, 1, 1, 1);
            notifyopt.attach (appstartup, 0, 2, 1, 1);
            notifyopt.attach (new HeaderLabel (_("Notify:"), 450), 0, 3, 1, 1);
            notifyopt.attach (systemnotif, 0, 4, 1, 1);
            notifyopt.attach (dialognotify, 0, 5, 1, 1);
            notifyopt.attach (new HeaderLabel (_("File Download:"), 450), 0, 6, 1, 1);
            notifyopt.attach (allowrepl, 0, 7, 1, 1);
            notifyopt.attach (autorename, 0, 8, 1, 1);

            var stack = new Gtk.Stack () {
                transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT,
                transition_duration = 500,
                hhomogeneous = false
            };
            stack.add_named (settings, "settings");
            stack.add_named (bittorrent, "bittorrent");
            stack.add_named (folderopt, "folderopt");
            stack.add_named (moreoptions, "moreoptions");
            stack.add_named (notifyopt, "notifyopt");
            stack.visible_child = settings;
            stack.show_all ();

            var close_button = new Gtk.Button.with_label (_("Close"));
            close_button.clicked.connect (()=> {
                destroy ();
            });

            var save_button = new Gtk.Button.with_label (_("Save"));
            save_button.clicked.connect (()=> {
                aria_set_globalops (AriaOptions.MAX_TRIES, set_dbsetting (DBSettings.MAXTRIES, numbtries.value.to_string ()));
                aria_set_globalops (AriaOptions.MAX_CONNECTION_PER_SERVER, set_dbsetting (DBSettings.CONNSERVER, numbconn.value.to_string ()));
                aria_set_globalops (AriaOptions.TIMEOUT, set_dbsetting (DBSettings.TIMEOUT, timeout.value.to_string ()));
                aria_set_globalops (AriaOptions.RETRY_WAIT, set_dbsetting (DBSettings.RETRY, retry.value.to_string ()));
                aria_set_globalops (AriaOptions.DIR, set_dbsetting (DBSettings.DIR, folder_location.get_file ().get_path ().replace ("/", "\\/")));
                aria_set_globalops (AriaOptions.BT_MAX_PEERS, set_dbsetting (DBSettings.BTMAXPEERS, maxpeers.value.to_string ()));
                aria_set_globalops (AriaOptions.SPLIT, set_dbsetting (DBSettings.SPLIT, split.value.to_string ()));
                aria_set_globalops (AriaOptions.BT_TRACKER_TIMEOUT, set_dbsetting (DBSettings.BTTIMEOUTTRACK, bt_timeout.value.to_string ()));
                aria_set_globalops (AriaOptions.BT_MAX_OPEN_FILES, set_dbsetting (DBSettings.MAXOPENFILE, maxopfile.value.to_string ()));
                aria_set_globalops (AriaOptions.SEED_TIME, set_dbsetting (DBSettings.SEEDTIME, bt_seedtime.value.to_string ()));
                aria_set_globalops (AriaOptions.ALLOW_OVERWRITE, set_dbsetting (DBSettings.OVERWRITE, allowrepl.active.to_string ()));
                aria_set_globalops (AriaOptions.AUTO_FILE_RENAMING, set_dbsetting (DBSettings.AUTORENAMING, autorename.active.to_string ()));
                set_dbsetting (DBSettings.DIALOGNOTIF, dialognotify.active.to_string ());
                set_dbsetting (DBSettings.SYSTEMNOTIF, systemnotif.active.to_string ());
                set_dbsetting (DBSettings.ONBACKGROUND, retonhide.active.to_string ());
                set_dbsetting (DBSettings.STARTUP, appstartup.active.to_string ());
                if (maxcurrent.value != double.parse (aria_get_globalops (AriaOptions.MAX_CONCURRENT_DOWNLOADS))) {
                    aria_set_globalops (AriaOptions.MAX_CONCURRENT_DOWNLOADS, set_dbsetting (DBSettings.MAXACTIVE, maxcurrent.value.to_string ()));
                    max_active ();
                }
                if (rpc_port.value != double.parse (aria_get_globalops (AriaOptions.RPC_LISTEN_PORT))) {
                    set_dbsetting (DBSettings.RPCPORT, rpc_port.value.to_string ());
                }
                if (maxrequest.value != double.parse (aria_get_globalops (AriaOptions.RPC_MAX_REQUEST_SIZE))) {
                    set_dbsetting (DBSettings.RPCSIZE, maxrequest.value.to_string ());
                }
                if (maxrequest.value != double.parse (aria_get_globalops (AriaOptions.DISK_CACHE))) {
                    set_dbsetting (DBSettings.DISKCACHE, diskcache.value.to_string ());
                }
                if (diskcache.value != double.parse (aria_get_globalops (AriaOptions.DISK_CACHE))
                || maxrequest.value != double.parse (aria_get_globalops (AriaOptions.RPC_MAX_REQUEST_SIZE))
                || rpc_port.value != double.parse (aria_get_globalops (AriaOptions.RPC_LISTEN_PORT))
                || get_dbsetting (DBSettings.FILEALLOCATION) != fileallocation.fileallocation.get_name ()) {
                    set_dbsetting (DBSettings.FILEALLOCATION, fileallocation.fileallocation.get_name ());
                    aria_shutdown ();
                    do {
                    } while (aria_getverion ());
                    exec_aria ();
                    destroy ();
                } else if (local_port.value.to_string () != get_dbsetting (DBSettings.PORTLOCAL)) {
                    set_dbsetting (DBSettings.PORTLOCAL, local_port.value.to_string ());
                    restart_server ();
                    destroy ();
                } else {
                    destroy ();
                }
            });

            var box_action = new Gtk.Grid () {
                width_request = 250,
                margin_top = 10,
                margin_bottom = 10,
                column_spacing = 10,
                column_homogeneous = true,
                halign = Gtk.Align.CENTER,
                orientation = Gtk.Orientation.HORIZONTAL
            };
            box_action.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            box_action.add (save_button);
            box_action.add (close_button);

            var maingrid = new Gtk.Grid () {
                orientation = Gtk.Orientation.VERTICAL,
                halign = Gtk.Align.CENTER,
                margin_start = 10,
                margin_end = 10
            };
            maingrid.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            maingrid.add (stack);
            maingrid.add (box_action);

            get_content_area ().add (maingrid);
            move_widget (this);
            view_mode.notify["selected"].connect (() => {
                switch (view_mode.selected) {
                    case 1:
                        stack.visible_child = bittorrent;
                        break;
                    case 2:
                        stack.visible_child = folderopt;
                        break;
                    case 3:
                        stack.visible_child = moreoptions;
                        break;
                    case 4:
                        stack.visible_child = notifyopt;
                        break;
                    default:
                        stack.visible_child = settings;
                        break;
                }
            });
        }
    }
}
