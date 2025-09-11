/*
* Copyright (c) {2024} torikulhabib (https://github.com/gabutakut)
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
    public class GabutWindow : Gtk.Window {
        public signal bool send_file (string url);
        public signal void stop_server ();
        public signal void restart_server ();
        public signal void open_show ();
        public signal bool active_downloader (string ariagid);
        public signal void update_agid (string ariagid, string newgid);
        public signal string get_host ();
        private Gtk.ListBox list_box;
        private Gtk.Label labelview;
        private Gtk.Stack headerstack;
        private Preferences preferences;
        private QrCode qrcode;
        private Gtk.SearchEntry search_entry;
        private ModeButton view_mode;
        private AlertView nodown_alert;
        private Gee.ArrayList<AddUrl> properties;
        private Gee.ArrayList<DownloadRow> listrow;
        private DbusmenuItem menudbus;
        private DbusmenuItem openmenu;
        private CanonicalDbusmenu dbusserver;
        private DbusIndicator dbusindicator;
        private Gtk.CheckButton showtime;
        private Gtk.CheckButton showdate;
        private Gtk.Label download_rate;
        private Gtk.Label upload_rate;
        private Gtk.Label labelact;
        private Gtk.Image modeview;
        private Gtk.Image badge_rbtn;
        private int animation = 0;
        private int index_rowdm = 0;
        private int allactive = 0;
        private int limitcount = 0;
        private int64 totalfiles = 0;
        private int64 totalrecv = 0;
        private bool removing = false;
        private bool starting = false;
        private bool stoping = false;

        SortBy _sorttype = null;
        SortBy sorttype {
            get {
                return _sorttype;
            }
            set {
                _sorttype = value;
                set_dbsetting (DBSettings.SORTBY, _sorttype.get_index ().to_string ());
            }
        }

        DeAscend _deascend;
        DeAscend deascend {
            get {
                return _deascend;
            }
            set {
                _deascend = value;
            }
        }

        private bool _dbmenu = false;
        public bool dbmenu {
            get {
                return _dbmenu;
            }
            set {
                _dbmenu = value;
                if (dbusserver != null && dbusindicator != null) {
                    if (!dbmenu) {
                        dbusindicator.updatestatus = "Passive";
                    } else {
                        update_quicklist.begin ();
                        if (indmenu) {
                            dbusindicator.updatestatus = "Active";
                        }
                    }
                    if (indmenu) {
                        dbusindicator.register_dbus.begin ();
                    }
                    dbusindicator.new_status (dbusindicator.updatestatus);
                }
            }
        }

        private bool _indmenu = false;
        public bool indmenu {
            get {
                return _indmenu;
            }
            set {
                _indmenu = value;
                if (dbusserver != null && dbusindicator != null) {
                    if (indmenu) {
                        dbusindicator.updatestatus = "Active";
                    } else {
                        dbusindicator.updatestatus = "Passive";
                    }
                    if (dbmenu) {
                        dbusindicator.register_dbus.begin ();
                    }
                    dbusindicator.new_status (dbusindicator.updatestatus);
                }
            }
        }

        private int _menulabel = 0;
        public int menulabel {
            get {
                return _menulabel;
            }
            set {
                _menulabel = value;
                update_info ();
            }
        }

        construct {
            hide_on_close = bool.parse (get_dbsetting (DBSettings.ONBACKGROUND));
            title = _("Gabut Download Manager");
            dbmenu = bool.parse (get_dbsetting (DBSettings.DBUSMENU));
            dbusserver = new CanonicalDbusmenu ();
            dbusindicator = new DbusIndicator (dbusserver.dbus_object);
            indmenu = bool.parse (get_dbsetting (DBSettings.MENUINDICATOR));
            openmenu = new DbusmenuItem ();
            openmenu.property_set (MenuItem.LABEL.to_string (), _("Gabut Download Manager"));
            openmenu.property_set (MenuItem.ICON_NAME.to_string (), "com.github.gabutakut.gabutdm");
            openmenu.property_set_bool (MenuItem.VISIBLE.to_string (), true);
            openmenu.item_activated.connect (()=> {
                open_show ();
            });

            var urlmenu = new DbusmenuItem ();
            urlmenu.property_set (MenuItem.LABEL.to_string (), _("Add Url"));
            urlmenu.property_set (MenuItem.ICON_NAME.to_string (), "com.github.gabutakut.gabutdm.uri");
            urlmenu.property_set_bool (MenuItem.VISIBLE.to_string (), true);
            urlmenu.item_activated.connect (()=> {
                send_file ("");
            });

            var opentormenu = new DbusmenuItem ();
            opentormenu.property_set (MenuItem.LABEL.to_string (), _("Open Torrent"));
            opentormenu.property_set (MenuItem.ICON_NAME.to_string (), "document-open");
            opentormenu.property_set_bool (MenuItem.VISIBLE.to_string (), true);
            opentormenu.item_activated.connect (()=> {
                run_open_file.begin (this, OpenFiles.OPENFILES, (obj, res)=> {
                    try {
                        GLib.File[] files;
                        run_open_file.end (res, out files);
                        foreach (var file in files) {
                            send_file (file.get_uri ());
                        }
                    } catch (GLib.Error e) {
                        critical (e.message);
                    }
                });
            });

            var setmenu = new DbusmenuItem ();
            setmenu.property_set (MenuItem.LABEL.to_string (), _("Settings"));
            setmenu.property_set (MenuItem.ICON_NAME.to_string (), "com.github.gabutakut.gabutdm.settings");
            setmenu.property_set_bool (MenuItem.VISIBLE.to_string (), true);
            setmenu.item_activated.connect (menuprefernces);

            var startmenu = new DbusmenuItem ();
            startmenu.property_set (MenuItem.LABEL.to_string (), _("Start All"));
            startmenu.property_set (MenuItem.ICON_NAME.to_string (), "com.github.gabutakut.gabutdm.active");
            startmenu.property_set_bool (MenuItem.VISIBLE.to_string (), true);
            startmenu.item_activated.connect (start_all);

            var pausemenu = new DbusmenuItem ();
            pausemenu.property_set (MenuItem.LABEL.to_string (), _("Pause All"));
            pausemenu.property_set (MenuItem.ICON_NAME.to_string (), "com.github.gabutakut.gabutdm.pause");
            pausemenu.property_set_bool (MenuItem.VISIBLE.to_string (), true);
            pausemenu.item_activated.connect (stop_all);

            var qrmenu = new DbusmenuItem ();
            qrmenu.property_set (MenuItem.LABEL.to_string (), _("Remote"));
            qrmenu.property_set (MenuItem.ICON_NAME.to_string (), "com.github.gabutakut.gabutdm.gohome");
            qrmenu.property_set_bool (MenuItem.VISIBLE.to_string (), true);
            qrmenu.item_activated.connect (qrmenuopen);

            menudbus = new DbusmenuItem ();
            append_dbus.begin (openmenu);
            append_dbus.begin (urlmenu);
            append_dbus.begin (opentormenu);
            append_dbus.begin (startmenu);
            append_dbus.begin (pausemenu);
            append_dbus.begin (setmenu);
            append_dbus.begin (qrmenu);

            nodown_alert = new AlertView (
                _("No File Download"),
                _("Drag and Drop URL, Torrent, Metalink, Magnet URIs."),
                "com.github.gabutakut.gabutdm"
            );
            nodown_alert.show ();

            listrow = new Gee.ArrayList<DownloadRow> ();
            list_box = new Gtk.ListBox () {
                activate_on_single_click = true,
                selection_mode = Gtk.SelectionMode.BROWSE
            };
            list_box.set_sort_func ((Gtk.ListBoxSortFunc) sort_dm);
            list_box.set_placeholder (nodown_alert);

            var scrolled = new Gtk.ScrolledWindow () {
                height_request = 350,
                width_request = 650,
                overlay_scrolling = true,
                vexpand = true,
                child = list_box
            };

            search_entry = new Gtk.SearchEntry () {
                hexpand = true,
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER,
                placeholder_text = _("Find Here")
            };
            search_entry.search_changed.connect (view_status);

            view_mode = new ModeButton () {
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            view_mode.append_icon_text ("com.github.gabutakut.gabutdm", "All");
            view_mode.append_icon_text ("com.github.gabutakut.gabutdm.active","Downloading");
            view_mode.append_icon_text ("com.github.gabutakut.gabutdm.pause", "Paused");
            view_mode.append_icon_text ("com.github.gabutakut.gabutdm.complete", "Complete");
            view_mode.append_icon_text ("com.github.gabutakut.gabutdm.waiting", "Waiting");
            view_mode.append_icon_text ("com.github.gabutakut.gabutdm.error", "Error");
            view_mode.selected = 0;
            view_mode.notify["selected"].connect (view_status);

            headerstack = new Gtk.Stack () {
                transition_type = Gtk.StackTransitionType.SLIDE_UP,
                transition_duration = 500,
                hhomogeneous = false
            };
            headerstack.add_named (view_mode, "mode");
            headerstack.add_named (search_entry, "search");
            headerstack.visible_child_name = "mode";
            headerstack.show ();

            modeview = new Gtk.Image () {
                margin_start = 10,
                valign = Gtk.Align.CENTER,
                gicon = new ThemedIcon ("com.github.gabutakut.gabutdm")
            };

            labelview = new Gtk.Label (null) {
                ellipsize = Pango.EllipsizeMode.END,
                valign = Gtk.Align.CENTER,
                margin_start = 10,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };

            var boxinfo = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            boxinfo.append (modeview);
            boxinfo.append (labelview);

            var img_download = new Gtk.Image () {
                valign = Gtk.Align.CENTER,
                gicon = new ThemedIcon ("com.github.gabutakut.gabutdm.down"),
                tooltip_text = _("Download Speed")
            };

            download_rate = new Gtk.Label (null) {
                xalign = 0,
                use_markup = true,
                width_request = 60,
                valign = Gtk.Align.CENTER,
                tooltip_text = _("Download Speed"),
                attributes = color_attribute (0, 60000, 0)
            };

            var img_upload = new Gtk.Image () {
                valign = Gtk.Align.CENTER,
                gicon = new ThemedIcon ("com.github.gabutakut.gabutdm.up"),
                tooltip_text = _("Upload Speed")
            };

            upload_rate = new Gtk.Label (null) {
                xalign = 0,
                use_markup = true,
                width_request = 60,
                valign = Gtk.Align.CENTER,
                tooltip_text = _("Upload Speed"),
                attributes = color_attribute (60000, 0, 0)
            };

            var gridinf = new Gtk.Grid () {
                valign = Gtk.Align.CENTER,
                halign = Gtk.Align.CENTER
            };
            gridinf.attach (img_download, 0, 0);
            gridinf.attach (download_rate, 1, 0);
            gridinf.attach (img_upload, 2, 0);
            gridinf.attach (upload_rate, 3, 0);

            var imgactive = new Gtk.Image () {
                valign = Gtk.Align.CENTER,
                margin_end = 6,
                gicon = new ThemedIcon ("com.github.gabutakut.gabutdm.onactive"),
                tooltip_text = _("Active Download")
            };

            labelact = new Gtk.Label (null) {
                ellipsize = Pango.EllipsizeMode.END,
                valign = Gtk.Align.CENTER,
                margin_end = 10,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };

            var boxact = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            boxact.append (imgactive);
            boxact.append (labelact);

            var ceninfo = new Gtk.CenterBox () {
                orientation = Gtk.Orientation.HORIZONTAL,
                margin_top = 2,
                margin_bottom = 2,
                start_widget = boxinfo,
                center_widget = gridinf,
                end_widget = boxact
            };

            var mainwindow = new Gtk.Grid ();
            mainwindow.attach (ceninfo, 0, 0);
            mainwindow.attach (scrolled, 0, 1);
            mainwindow.attach (bottom_action (), 0, 2);
            child = mainwindow;
            close_request.connect (() => {
                if (bool.parse (get_dbsetting (DBSettings.ONBACKGROUND))) {
                    append_dbus.begin (openmenu);
                    menudbus.child_reorder (openmenu, 1);
                } else {
                    save_all_download ();
                }
                return false;
            });

            set_titlebar (build_headerbar ());
            menulabel = int.parse (get_dbsetting (DBSettings.LABELMODE));

            var spress = new Gtk.EventControllerKey ();
            search_entry.add_controller (spress);
            spress.key_pressed.connect (keyvalwd);

            var keypress = new Gtk.EventControllerKey ();
            mainwindow.add_controller (keypress);
            keypress.key_pressed.connect (keyvalwd);

            var titpress = new Gtk.EventControllerKey ();
            titlebar.add_controller (titpress);
            titpress.key_pressed.connect (keyvalwd);
        }

        private bool keyvalwd (uint keyval, uint keycode, Gdk.ModifierType state) {
            bool ctrl_pressed = (state & Gdk.ModifierType.CONTROL_MASK) != 0;
            if (ctrl_pressed && match_keycode (Gdk.Key.f, keycode)) {
                if (maximized) {
                    unmaximize ();
                } else {
                    maximize ();
                }
            } else if (ctrl_pressed && match_keycode (Gdk.Key.q, keycode)) {
                close ();
            } else if (ctrl_pressed && match_keycode (Gdk.Key.d, keycode)) {
                if (list_box.selection_mode == Gtk.SelectionMode.BROWSE) {
                    list_box.selection_mode = Gtk.SelectionMode.MULTIPLE;
                    for (int b = 0; b < listrow.size ; b++) {
                        var row = (DownloadRow) list_box.get_row_at_index (b);
                        row.remove_button.hide ();
                    }
                } else {
                    list_box.selection_mode = Gtk.SelectionMode.BROWSE;
                    for (int b = 0; b < listrow.size ; b++) {
                        var row = (DownloadRow) list_box.get_row_at_index (b);
                        row.remove_button.show ();
                    }
                }
                view_status ();
            } else if (ctrl_pressed && match_keycode (Gdk.Key.p, keycode)) {
                menuprefernces ();
            } else if (ctrl_pressed && match_keycode (Gdk.Key.h, keycode)) {
                qrmenuopen ();
            } else if (ctrl_pressed && match_keycode (Gdk.Key.s, keycode)) {
                if (headerstack.visible_child_name != "search") {
                    searchf ();
                }
            } else if (ctrl_pressed && match_keycode (Gdk.Key.m, keycode)) {
                list_box.get_selected_rows ().foreach ((row)=> {
                    proprow ((DownloadRow) row);
                });
            } else if (ctrl_pressed && match_keycode (Gdk.Key.z, keycode)) {
                start_all ();
            } else if (ctrl_pressed && match_keycode (Gdk.Key.x, keycode)) {
                stop_all ();
            } else if (ctrl_pressed && match_keycode (Gdk.Key.c, keycode)) {
                remove_all ();
            } else if (ctrl_pressed && match_keycode (Gdk.Key.a, keycode)) {
                list_box.select_all ();
            } else if (ctrl_pressed && match_keycode (Gdk.Key.u, keycode)) {
                send_file ("");
            } else if (ctrl_pressed && match_keycode (Gdk.Key.w, keycode)) {
                list_box.get_selected_rows ().foreach ((row)=> {
                    ((DownloadRow) row).download ();
                });
            } else if (ctrl_pressed && match_keycode (Gdk.Key.v, keycode)) {
                list_box.get_selected_rows ().foreach ((row)=> {
                    ((DownloadRow) row).action_btn ();
                });
            } else if (ctrl_pressed && match_keycode (Gdk.Key.o, keycode)) {
                list_box.get_selected_rows ().foreach ((row)=> {
                    ((DownloadRow) row).open_filesr ();
                });
            } else if (ctrl_pressed && match_keycode (Gdk.Key.r, keycode)) {
                if (list_box.selection_mode != Gtk.SelectionMode.MULTIPLE) {
                    var selecteddl = list_box.get_selected_rows ().length ();
                    if (selecteddl == 1) {
                        rm_perpart (StatusMode.SEED, (int) selecteddl);
                    }
                }
            } else if (ctrl_pressed && match_keycode (Gdk.Key.i, keycode)) {
                run_open_file.begin (this, OpenFiles.OPENFILES, (obj, res)=> {
                    try {
                        GLib.File[] files;
                        run_open_file.end (res, out files);
                        foreach (var file in files) {
                            send_file (file.get_uri ());
                        }
                    } catch (GLib.Error e) {
                        critical (e.message);
                    }
                });
            }
            switch (keyval) {
                case Gdk.Key.Escape:
                    if (list_box.selection_mode == Gtk.SelectionMode.BROWSE) {
                        var slrow = list_box.get_selected_row ();
                        if (slrow != null) {
                            list_box.unselect_row (slrow);
                        }
                    } else {
                        list_box.unselect_all ();
                    }
                    selected_mode ();
                    if (headerstack.visible_child_name == "search") {
                        searchf ();
                    }
                    break;
                case Gdk.Key.Delete:
                    dl_perpart ();
                    break;
            }
            return false;
        }

        private void dl_perpart () {
            var selecteddl = list_box.get_selected_rows ();
            if (selecteddl.length () < 1) {
                return;
            }
            var hashrow = new Gee.ArrayList<DownloadRow> ();
            selecteddl.foreach ((rows)=> {
                hashrow.add ((DownloadRow) rows);
            });
            var dldia = new DeleteDialog () {
                transient_for = this,
                datarow = hashrow,
                icimg = "user-trash-full",
                primmelb = _("Move to Trash"),
                topikname = "Delete selected"
            };
            dldia.show ();
            dldia.excuterd.connect (()=> {
                int totaldx = hashrow.size;
                Idle.add (()=> {
                    if (hashrow.size > 0) {
                        removing = true;
                        for (int b = 0; b < listrow.size ; b++) {
                            var row = (DownloadRow) list_box.get_row_at_index (b);
                            if (hashrow.contains (row)) {
                                labelview.label = _("Deleting… (%i of %i)").printf (((totaldx + 1) - hashrow.size), totaldx);
                                row.to_trash ();
                                indicatorstatus ();
                                hashrow.remove (row);
                            }
                        }
                    } else {
                        removing = false;
                        update_info ();
                        view_status ();
                    }
                    return removing;
                }, GLib.Priority.HIGH_IDLE);
                dldia.close ();
            });
        }

        private Gtk.HeaderBar build_headerbar () {
            var headerbar = new Gtk.HeaderBar () {
                hexpand = true,
                decoration_layout = ":close"
            };
            var menu_button = new Gtk.Button.from_icon_name ("com.github.gabutakut.gabutdm.settings") {
                has_frame = false,
                tooltip_text = _("Settings\nCTRL + P")
            };
            headerbar.pack_end (menu_button);
            menu_button.clicked.connect (menuprefernces);

            var search_button = new Gtk.Button.from_icon_name ("com.github.gabutakut.gabutdm") {
                has_frame = false,
                tooltip_text = _("Search\nCTRL + S")
            };
            headerbar.pack_end (search_button);
            search_button.clicked.connect (searchf);
            headerstack.notify["visible-child"].connect (()=> {
                view_status ();
                search_entry.text = "";
                search_button.icon_name = headerstack.visible_child_name == "mode"? "com.github.gabutakut.gabutdm" : "com.github.gabutakut.gabutdm.find";
                search_button.tooltip_text = headerstack.visible_child_name == "mode"? _("Search\nCTRL + S") : _("Search\nESC");
                if (headerstack.visible_child_name == "search") {
                    search_entry.grab_focus ();
                } else {
                    grab_focus ();
                }
            });
            var host_button = new Gtk.Button.from_icon_name ("com.github.gabutakut.gabutdm.gohome") {
                has_frame = false,
                tooltip_text = _("Remote\nCTRL + H")
            };
            headerbar.pack_end (host_button);
            host_button.clicked.connect (qrmenuopen);
            var add_open = new Gtk.MenuButton () {
                child = new Gtk.Image.from_icon_name ("com.github.gabutakut.gabutdm.insertlink"),
                direction = Gtk.ArrowType.UP,
                has_frame = false,
                popover = get_openmenu (),
                tooltip_text = _("Add\nCTRL + U\nOpen\nCTRL + I")
            };
            headerbar.pack_start (add_open);
            var resumeall_button = new Gtk.Button.from_icon_name ("com.github.gabutakut.gabutdm.active") {
                has_frame = false,
                tooltip_text = _("Start All\nCTRL + Z")
            };
            headerbar.pack_start (resumeall_button);
            resumeall_button.clicked.connect (start_all);

            var stopall_button = new Gtk.Button.from_icon_name ("com.github.gabutakut.gabutdm.pause") {
                has_frame = false,
                tooltip_text = _("Pause All\nCTRL + X")
            };
            headerbar.pack_start (stopall_button);
            stopall_button.clicked.connect (stop_all);
            var imagefile = new Gtk.Image () {
                icon_size = Gtk.IconSize.INHERIT,
                icon_name = "com.github.gabutakut.gabutdm.clear"
            };

            badge_rbtn = new Gtk.Image () {
                gicon = new ThemedIcon (nodown_alert.icon_name),
                tooltip_text = _("Remove All\nCTRL + C"),
                halign = Gtk.Align.END,
                valign = Gtk.Align.END,
                pixel_size = 12
            };

            var overlay = new Gtk.Overlay () {
                child = imagefile
            };
            overlay.add_overlay (badge_rbtn);

            var removeall_button = new Gtk.Button () {
                has_frame = false,
                child = overlay
            };
            headerbar.pack_start (removeall_button);
            removeall_button.clicked.connect (remove_all);
            return headerbar;
        }

        private void searchf () {
            headerstack.visible_child_name = headerstack.visible_child_name == "mode"? headerstack.visible_child_name = "search" : headerstack.visible_child_name = "mode";
            var row = (DownloadRow) list_box.get_selected_row ();
            if (row != null) {
                list_box.unselect_row (row);
            }
        }

        public Gtk.Popover get_openmenu () {
            var addopen = new Gtk.FlowBox ();
            foreach (var openmenu in OpenMenus.get_all ()) {
                addopen.append (new OpenMenu (openmenu));
            }
            var popovermenu = new Gtk.Popover () {
                child = addopen
            };
            popovermenu.show.connect (() => {
                popovermenu.position = Gtk.PositionType.BOTTOM;
                addopen.unselect_all ();
            });
            addopen.child_activated.connect ((openmn)=> {
                popovermenu.hide ();
                var add_open = openmn as OpenMenu;
                switch (add_open.openmn) {
                    case OpenMenus.OPENMN:
                        run_open_file.begin (this, OpenFiles.OPENFILES, (obj, res)=> {
                            try {
                                GLib.File[] files;
                                run_open_file.end (res, out files);
                                foreach (var file in files) {
                                    send_file (file.get_uri ());
                                }
                            } catch (GLib.Error e) {
                                critical (e.message);
                            }
                        });
                        break;
                    default:
                        send_file ("");
                        break;
                }
            });
            return popovermenu;
        }
    
        private void qrmenuopen () {
            if (qrcode == null) {
                qrcode = new QrCode () {
                    transient_for = this
                };
                qrcode.get_host.connect ((reboot)=> {
                    if (reboot) {
                        restart_server ();
                    }
                    return get_host ();
                });
                qrcode.close.connect (()=> {
                    qrcode = null;
                });
                qrcode.close_request.connect (()=> {
                    qrcode = null;
                    return false;
                });
                qrcode.show ();
                qrcode.load_host (false);
            }
        }

        private void menuprefernces () {
            if (preferences == null) {
                preferences = new Preferences () {
                    transient_for = this
                };
                preferences.restart_server.connect (()=> {
                    restart_server ();
                });
                preferences.restart_process.connect (()=> {
                    for (int index = 0; index < listrow.size ; index++) {
                        var row = (DownloadRow) list_box.get_row_at_index (index);
                        row.if_not_exist (row.ariagid, row.linkmode, row.status);
                    }
                });
                preferences.max_active.connect (()=> {
                    next_download ();
                });
                preferences.global_opt.connect (()=> {
                    update_options ();
                });
                preferences.close.connect (()=> {
                    save_close ();
                });
                preferences.close_request.connect (()=> {
                    save_close ();
                    return false;
                });
                preferences.show ();
            }
        }

        private void save_close () {
            if (bool.parse (get_dbsetting (DBSettings.ONBACKGROUND)) != hide_on_close) {
                hide_on_close = bool.parse (get_dbsetting (DBSettings.ONBACKGROUND));
            }
            if (bool.parse (get_dbsetting (DBSettings.DBUSMENU)) != dbmenu) {
                dbmenu = bool.parse (get_dbsetting (DBSettings.DBUSMENU));
            }
            menulabel = int.parse (get_dbsetting (DBSettings.LABELMODE));
            if (bool.parse (get_dbsetting (DBSettings.MENUINDICATOR)) != indmenu) {
                indmenu = bool.parse (get_dbsetting (DBSettings.MENUINDICATOR));
            }
            preferences = null;
        }

        private Gtk.CenterBox bottom_action () {
            var property_button = new Gtk.MenuButton () {
                child = new Gtk.Image.from_icon_name ("com.github.gabutakut.gabutdm.menu"),
                direction = Gtk.ArrowType.UP,
                has_frame = false,
                margin_start = 6,
                tooltip_text = _("Property")
            };
            properties = new Gee.ArrayList<AddUrl> ();
            list_box.selected_rows_changed.connect (()=> {
                if (list_box.get_selected_rows ().length () > 0) {
                    property_button.popover = get_menuprop ();
                } else {
                    property_button.popover = null;
                }
                selected_mode ();
            });

            var shortbutton = new Gtk.MenuButton () {
                direction = Gtk.ArrowType.UP,
                child = new Gtk.Image.from_icon_name ("com.github.gabutakut.gabutdm.opt"),
                popover = get_menu (),
                margin_end = 6,
                has_frame = false,
                tooltip_text = _("Sort by")
            };
            var actionbar = new Gtk.CenterBox () {
                hexpand = false,
                margin_top = 4,
                margin_bottom = 4,
                orientation = Gtk.Orientation.HORIZONTAL,
                start_widget = property_button,
                center_widget = headerstack,
                end_widget = shortbutton
            };
            return actionbar;
        }

        public Gtk.Popover get_menuprop () {
            var downloadmn = new Gtk.FlowBox ();
            foreach (var dmmenu in DownloadMenu.get_all ()) {
                downloadmn.append (new GdmMenu (dmmenu));
            }
            var urisel_popover = new Gtk.Popover () {
                child = downloadmn
            };
            urisel_popover.show.connect (() => {
                downloadmn.unselect_all ();
            });
            downloadmn.child_activated.connect ((dmmenu)=> {
                urisel_popover.hide ();
                var gdmmenu = dmmenu as GdmMenu;
                switch (gdmmenu.downloadmenu) {
                    case DownloadMenu.MOVETOTRASH:
                        dl_perpart ();
                        break;
                    case DownloadMenu.PROPERTIES:
                        list_box.get_selected_rows ().foreach ((rows)=> {
                            proprow ((DownloadRow) rows);
                        });
                        break;
                    default:
                        list_box.get_selected_rows ().foreach ((rows)=> {
                            ((DownloadRow) rows).open_filesr ();
                        });
                        break;
                }
            });
            return urisel_popover;
        }

        private void proprow (DownloadRow row) {
            if (!property_active (row)) {
                var property = new AddUrl.Property () {
                    transient_for = this,
                    row = row
                };
                properties.add (property);
                property.save_button.clicked.connect (()=> {
                    row = property.row;
                });
                property.close.connect (()=> {
                    if (properties.contains (property)) {
                        properties.remove (property);
                    }
                });
                property.close_request.connect (()=> {
                    if (properties.contains (property)) {
                        properties.remove (property);
                    }
                    return false;
                });
                property.update_agid.connect ((ariagid, newgid)=> update_agid (ariagid, newgid));
                property.show ();
            }
        }

        private bool property_active (DownloadRow row) {
            bool active = false;
            properties.foreach ((propet)=> {
                if (propet.row == row) {
                    active = true;
                }
                return true;
            });
            return active;
        }

        public Gtk.Popover get_menu () {
            var sort_flow = new Gtk.FlowBox ();
            showtime = new Gtk.CheckButton.with_label (_("Time")) {
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER,
                width_request = 140,
                active = bool.parse (get_dbsetting (DBSettings.SHOWTIME))
            };
            ((Gtk.Label) showtime.get_last_child ()).attributes = set_attribute (Pango.Weight.BOLD);
            ((Gtk.Label) showtime.get_last_child ()).halign = Gtk.Align.CENTER;
            ((Gtk.Label) showtime.get_last_child ()).wrap_mode = Pango.WrapMode.WORD_CHAR;
            var timeimg = new Gtk.Image () {
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER,
                gicon = new ThemedIcon ("com.github.gabutakut.gabutdm.waiting")
            };
            var centime = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            centime.append (showtime);
            centime.append (timeimg);
            showdate = new Gtk.CheckButton.with_label (_("Date")) {
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER,
                width_request = 140,
                active = bool.parse (get_dbsetting (DBSettings.SHOWDATE))
            };
            ((Gtk.Label) showdate.get_last_child ()).attributes = set_attribute (Pango.Weight.BOLD);
            ((Gtk.Label) showdate.get_last_child ()).halign = Gtk.Align.CENTER;
            ((Gtk.Label) showdate.get_last_child ()).wrap_mode = Pango.WrapMode.WORD_CHAR;
            var dateimg = new Gtk.Image () {
                valign = Gtk.Align.CENTER,
                halign = Gtk.Align.CENTER,
                gicon = new ThemedIcon ("com.github.gabutakut.gabutdm.date")
            };
            var cendate = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            cendate.append (showdate);
            cendate.append (dateimg);
            var dsasc = new ModeTogle () {
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            dsasc.add_item (new ModeTogle.with_icon_label (_("Ascending"), "com.github.gabutakut.gabutdm.down"));
            dsasc.add_item (new ModeTogle.with_icon_label (_("Descending"), "com.github.gabutakut.gabutdm.up"));
            var box = new Gtk.Grid () {
                margin_top = 4,
                margin_bottom = 4,
                row_spacing = 4,
                width_request = 150
            };
            box.attach (sort_flow, 0, 0);
            box.attach (new Gtk.Separator (Gtk.Orientation.HORIZONTAL), 0, 1);
            box.attach (dsasc, 0, 2);
            box.attach (new Gtk.Separator (Gtk.Orientation.HORIZONTAL), 0, 3);
            box.attach (centime, 0, 4);
            box.attach (cendate, 0, 5);
            var sort_popover = new Gtk.Popover () {
                position = Gtk.PositionType.TOP,
                child = box
            };
            dsasc.notify["id"].connect (()=> {
                sort_popover.hide ();
                deascend = (DeAscend) dsasc.id;
                set_dbsetting (DBSettings.ASCEDESCEN, dsasc.id.to_string ());
                list_box.set_sort_func ((Gtk.ListBoxSortFunc) sort_dm);
            });
            dsasc.id = int.parse (get_dbsetting (DBSettings.ASCEDESCEN));
            deascend = (DeAscend) dsasc.id;

            showdate.toggled.connect (()=> {
                sort_popover.hide ();
                ((Gtk.Label) showdate.get_last_child ()).attributes = showdate.active? color_attribute (0, 60000, 0) : set_attribute (Pango.Weight.BOLD);
                set_dbsetting (DBSettings.SHOWDATE, showdate.active.to_string ());
                set_listheader ();
            });
            ((Gtk.Label) showdate.get_last_child ()).attributes = showdate.active? color_attribute (0, 60000, 0) : set_attribute (Pango.Weight.BOLD);
            showtime.toggled.connect (()=> {
                sort_popover.hide ();
                ((Gtk.Label) showtime.get_last_child ()).attributes = showtime.active? color_attribute (0, 60000, 0) : set_attribute (Pango.Weight.BOLD);
                set_dbsetting (DBSettings.SHOWTIME, showtime.active.to_string ());
                set_listheader ();
            });
            ((Gtk.Label) showtime.get_last_child ()).attributes = showtime.active? color_attribute (0, 60000, 0) : set_attribute (Pango.Weight.BOLD);
            set_listheader ();
            foreach (var shorty in SortbyWindow.get_all ()) {
                sort_flow.append (new SortBy (shorty));
            }
            sort_flow.show ();
            sort_flow.child_activated.connect ((shorty)=> {
                sort_popover.hide ();
                ((Gtk.Label)((SortBy) sorttype).get_last_child ()).attributes = set_attribute (Pango.Weight.BOLD);
                sorttype = shorty as SortBy;
                ((Gtk.Label)sorttype.get_last_child ()).attributes = color_attribute (0, 60000, 0);
                list_box.set_sort_func ((Gtk.ListBoxSortFunc) sort_dm);
            });
            sorttype = sort_flow.get_child_at_index (int.parse (get_dbsetting (DBSettings.SORTBY))) as SortBy;
            ((Gtk.Label)sorttype.get_last_child ()).attributes = color_attribute (0, 60000, 0);
            sort_popover.show.connect (() => {
                sort_flow.unselect_all ();
            });
            return sort_popover;
        }

        private void set_listheader () {
            if (showtime.active || showdate.active) {
                list_box.set_header_func ((Gtk.ListBoxUpdateHeaderFunc) header_dm);
            } else {
                list_box.set_header_func (null);
            }
        }

        public override void show () {
            remove_dbus.begin (openmenu);
            base.show ();
        }

        private bool set_menulauncher () {
            if (dbmenu) {
                var globalactive = int64.parse (aria_globalstat (GlobalStat.NUMACTIVE));
                bool statact = globalactive > 0;
                set_count_visible.begin (globalactive);
                if (!statact) {
                    int stoped = 5;
                    Timeout.add (500, ()=> {
                        set_progress_visible.begin (0.0, false);
                        set_count_visible.begin (globalactive);
                        update_info ();
                        stoped--;
                        return stoped != 0;
                    }, GLib.Priority.HIGH);
                }
                if (timeout_id != 0) {
                    Source.remove (timeout_id);
                    timeout_id = 0;
                }
                if (rmtimeout_id != 0) {
                    Source.remove (rmtimeout_id);
                    rmtimeout_id = 0;
                }
            }
            return false;
        }

        private uint timeout_id = 0;
        private void run_launcher () {
            if (timeout_id == 0) {
                timeout_id = Timeout.add (500, set_menulauncher, GLib.Priority.HIGH);
            }
        }

        private uint rmtimeout_id = 0;
        private void stop_launcher () {
            if (rmtimeout_id == 0) {
                rmtimeout_id = Timeout.add (500, set_menulauncher, GLib.Priority.HIGH);
            }
        }

        public void save_all_download () {
            var downloads = new GLib.List<DownloadRow> ();
            for (int index = 0; index < listrow.size ; index++) {
                var row = (DownloadRow) list_box.get_row_at_index (index);
                if (row.url == "") {
                    return;
                }
                if (!db_option_exist (row.url)) {
                    set_dboptions (row.url, row.hashoption);
                } else {
                    update_optionts (row.url, row.hashoption);
                }
                downloads.append (row);
            }
            set_download (downloads);
        }

        public Gee.ArrayList<DownloadRow> get_dl_row (int status) {
            var rowlist = new Gee.ArrayList<DownloadRow> ();
            for (int index = 0; index < listrow.size ; index++) {
                var row = (DownloadRow) list_box.get_row_at_index (index);
                if (row.status == status) {
                    rowlist.add (row);
                }
            }
            return rowlist;
        }

        private void update_options () {
            for (int index = 0; index < listrow.size ; index++) {
                var row = (DownloadRow) list_box.get_row_at_index (index);
                if (row.status != StatusMode.COMPLETE && row.status != StatusMode.ERROR) {
                    glob_to_opt (row.ariagid);
                }
            }
        }

        private void next_download () {
            var a2active = aria_tell_active ();
            for (int index = 0; index < listrow.size ; index++) {
                var row = (DownloadRow) list_box.get_row_at_index (index);
                if (a2active.contains (row.ariagid)) {
                    if (row.status != StatusMode.ACTIVE) {
                       row.update_progress ();
                    }
               }
            }
        }

        public string server_action (string ariagid, int status = 2) {
            var agid = ariagid;
            for (int index = 0; index < listrow.size ; index++) {
                var row = (DownloadRow) list_box.get_row_at_index (index);
                if (row.ariagid == ariagid) {
                    agid = row.action_btn (status);
                }
            }
            return agid;
        }

        public void remove_item (string ariagid) {
            for (int index = 0; index < listrow.size ; index++) {
                var row = (DownloadRow) list_box.get_row_at_index (index);
                if (row.ariagid == ariagid) {
                    row.remove_down ();
                }
            }
        }

        public void remove_all () {
            if (headerstack.visible_child_name == "search") {
                return;
            }
            if (starting || stoping || removing) {
                return;
            }
            switch (view_mode.selected) {
                case 1:
                    rm_perpart (StatusMode.ACTIVE);
                    break;
                case 2:
                    rm_perpart (StatusMode.PAUSED);
                    break;
                case 3:
                    rm_perpart (StatusMode.COMPLETE);
                    break;
                case 4:
                    rm_perpart (StatusMode.WAIT);
                    break;
                case 5:
                    rm_perpart (StatusMode.ERROR);
                    break;
                default:
                    rm_perpart (StatusMode.ALL);
                    aria_purge_all ();
                    break;
            }
        }

        private void rm_perpart (StatusMode status, int single = 0) {
            var hashrow = new Gee.ArrayList<DownloadRow> ();
            if (single == 1) {
                list_box.get_selected_rows ().foreach ((rows)=> {
                    hashrow.add ((DownloadRow) rows);
                });
            } else {
                if (list_box.selection_mode != Gtk.SelectionMode.MULTIPLE) {
                    for (int c = 0; c < listrow.size ; c++) {
                        var rowc = (DownloadRow) list_box.get_row_at_index (c);
                        if (rowc.status == status || status == StatusMode.ALL) {
                            hashrow.add (rowc);
                        }
                    }
                } else {
                    var selecteddl = list_box.get_selected_rows ();
                    if (selecteddl.length () < 1) {
                        return;
                    }
                    selecteddl.foreach ((rows)=> {
                        hashrow.add ((DownloadRow) rows);
                    });
                }
            }
            var dldia = new DeleteDialog () {
                transient_for = this,
                icimg = "com.github.gabutakut.gabutdm.clear",
                primmelb = _("Remove from list"),
                datarow = hashrow,
                topikname = _("Clear %s list").printf (status.to_string ())
            };
            dldia.show ();
            dldia.excuterd.connect (()=> {
                int totaldx = hashrow.size;
                Idle.add (()=> {
                    if (hashrow.size > 0) {
                        removing = true;
                        for (int b = 0; b < listrow.size ; b++) {
                            var row = (DownloadRow) list_box.get_row_at_index (b);
                            if (hashrow.contains (row)) {
                                labelview.label = _("Removing… (%i of %i)").printf (((totaldx +1) - hashrow.size), totaldx);
                                indicatorstatus ();
                                row.remove_down ();
                                hashrow.remove (row);
                            }
                        }
                    } else {
                        removing = false;
                        update_info ();
                        view_status ();
                    }
                    return removing;
                }, GLib.Priority.HIGH_IDLE);
                dldia.close ();
            });
        }

        public void load_dowanload () {
            get_download ().foreach ((row)=> {
                if (!get_exist (row.url)) {
                    on_append (row);
                    row.notify_property ("status");
                }
            });
        }

        public void add_url_box (string url, Gee.HashMap<string, string> options, bool later, int linkmode) {
            if (get_exist (url)) {
                return;
            }
            var row = new DownloadRow.Url (url, options, linkmode, activedm (), later) {
                timeadded = new GLib.DateTime.now_local ().to_unix ()
            };
            on_append (row);
            if (!later) {
                row.download ();
            } else {
                aria_pause (row.ariagid);
            }
        }

        private void on_append (DownloadRow row) {
            list_box.append (row);
            listrow.add (row);
            row.show ();
            row.notify["status"].connect (()=> {
                switch (row.status) {
                    case StatusMode.PAUSED:
                    case StatusMode.COMPLETE:
                    case StatusMode.ERROR:
                        if (!starting && !stoping) {
                            next_download ();
                        }
                        stop_launcher ();
                        remove_dbus.begin (row.rowbus);
                        break;
                    case StatusMode.WAIT:
                    case StatusMode.NOTHING:
                        remove_dbus.begin (row.rowbus);
                        break;
                    case StatusMode.ACTIVE:
                        on_active (row);
                        return;
                }
                if (allactive < 2) {
                    view_status ();
                    update_info ();
                }
            });
            row.destroy.connect (()=> {
                listrow.remove (row);
                list_box.remove (row);
                remove_dbus.begin (row.rowbus);
                next_download ();
                stop_launcher ();
                view_status ();
            });
            row.update_agid.connect ((ariagid, newgid)=> update_agid (ariagid, newgid));
            row.activedm.connect (activedm);
            if (list_box.get_selected_row () == null) {
                list_box.select_row (row);
                list_box.row_activated (row);
            }
            list_box.set_sort_func ((Gtk.ListBoxSortFunc) sort_dm);
            update_info ();
            view_status ();
        }

        private void on_active (DownloadRow row) {
            if (!menudbus.get_exist (row.rowbus)) {
                run_launcher ();
                if (!active_downloader (row.ariagid)) {
                    append_dbus.begin (row.rowbus);
                }
            }
            if (limitcount >= allactive) {
                double fraction = (double) totalrecv / (double) totalfiles;
                if (fraction > 0.0) {
                    if (dbmenu) {
                        set_progress_visible.begin (fraction);
                    }
                }
                update_info ();
                view_status ();
                totalfiles = totalrecv = limitcount = 0;
            }
            totalrecv = totalrecv + row.transferred;
            totalfiles = totalfiles + row.totalsize;
            limitcount++;
        }

        public int activedm () {
            int count = 0;
            for (int index = 0; index < listrow.size ; index++) {
                var row = (DownloadRow) list_box.get_row_at_index (index);
                if (row.status == StatusMode.ACTIVE || row.status == StatusMode.WAIT) {
                    count++;
                }
            }
            return count;
        }

        private void update_info () {
            var infol = aria_label_info ();
            allactive = int.parse (infol.fetch (2));
            download_rate.label = GLib.format_size (allactive > 0? int64.parse (infol.fetch (1)) : 0);
            upload_rate.label = GLib.format_size (allactive > 0? int64.parse (infol.fetch (6)) : 0);
            labelact.label = allactive.to_string ();
            if (!indmenu) {
                return;
            }
            if (starting || stoping || removing) {
                return;
            }
            if (allactive > 0) {
                switch (animation) {
                    case 1:
                        dbusindicator.updateiconame = "com.github.gabutakut.gabutdm.seedloopy";
                        animation++;
                        break;
                    case 2:
                        dbusindicator.updateiconame = "com.github.gabutakut.gabutdm.seedloopx";
                        animation++;
                        break;
                    case 3:
                        dbusindicator.updateiconame = "com.github.gabutakut.gabutdm.seedloop";
                        animation = 0;
                        break;
                    default:
                        dbusindicator.updateiconame = "com.github.gabutakut.gabutdm.seed";
                        animation++;
                        break;
                }
            } else {
                dbusindicator.updateiconame = "com.github.gabutakut.gabutdm";
            }
            dbusindicator.new_icon ();
            if (_menulabel == 0) {
                dbusindicator.updateLabel = "";
            } else {
                if (allactive > 0) {
                    if (_menulabel == 2) {
                        dbusindicator.updateLabel = GLib.format_size (allactive > 0? int64.parse (infol.fetch (6)) + int64.parse (infol.fetch (1)) : 0);
                    } else if (_menulabel == 1) {
                        dbusindicator.updateLabel = @"$(allactive.to_string ())/$(listrow.size)";
                    } else {
                        dbusindicator.updateLabel = @"$(allactive.to_string ())/$(listrow.size) " + GLib.format_size (allactive > 0? int64.parse (infol.fetch (6)) + int64.parse (infol.fetch (1)) : 0);
                    }
                } else {
                    dbusindicator.updateLabel = listrow.size > 0? "GabutDM" : "";
                }
            }
            dbusindicator.x_ayatana_new_label (dbusindicator.updateLabel, "");
        }

        private void indicatorstatus () {
            dbusindicator.updateLabel = labelview.label;
            dbusindicator.x_ayatana_new_label (dbusindicator.updateLabel, "");
            if (starting) {
                dbusindicator.updateiconame = "com.github.gabutakut.gabutdm.active";
            } else if (stoping) {
                dbusindicator.updateiconame = "com.github.gabutakut.gabutdm.pause";
            } else {
                dbusindicator.updateiconame = "com.github.gabutakut.gabutdm.clear";
            }
            dbusindicator.new_icon ();
        }

        private bool get_exist (string url) {
            bool linkexist = false;
            for (int index = 0; index < listrow.size ; index++) {
                var row = (DownloadRow) list_box.get_row_at_index (index);
                if (row.url == url) {
                    linkexist = true;
                }
            }
            return linkexist;
        }

        public int beforest () {
            int count = 0;
            for (int index = 0; index < listrow.size ; index++) {
                var row = (DownloadRow) list_box.get_row_at_index (index);
                if (row.status == StatusMode.PAUSED) {
                    count++;
                }
            }
            return count;
        }

        private void start_all () {
            if (starting || stoping || removing) {
                return;
            }
            int index = activedm ();
            int onstr = beforest ();
            int count = 0;
            int startdl = 0;
            Idle.add (()=> {
                if (listrow.size > 0) {
                    starting = true;
                    var row = (DownloadRow) list_box.get_row_at_index (count);
                    if (row.status != StatusMode.COMPLETE && row.status != StatusMode.ERROR) {
                        if (row.status == StatusMode.PAUSED) {
                            aria_position (row.ariagid, index);
                            aria_unpause (row.ariagid);
                            row.update_progress ();
                            index++;
                            startdl++;
                            labelview.label = _("Starting… (%i of %i)").printf (startdl, onstr);
                            indicatorstatus ();
                        }
                    }
                    count++;
                } 
                if (listrow.size == count) {
                    starting = false;
                    update_info ();
                    view_status ();
                }
                return starting;
            }, GLib.Priority.HIGH_IDLE);
        }

        private void stop_all () {
            if (starting || stoping || removing) {
                return;
            }
            int index = 0;
            int count = 0;
            int acti = activedm ();
            Idle.add (()=> {
                if (listrow.size > 0) {
                    stoping = true;
                    var row = (DownloadRow) list_box.get_row_at_index (index);
                    if (row.status != StatusMode.COMPLETE && row.status != StatusMode.ERROR) {
                        aria_pause (row.ariagid);
                        if (row.status == StatusMode.WAIT) {
                            row.update_progress ();
                        }
                        count++;
                        if (acti > 0 && count <= acti) {
                            labelview.label = _("Stoping… (%i of %i)").printf (count, acti);
                            indicatorstatus ();
                        }
                    }
                    index++;
                } 
                if (listrow.size == index) {
                    stoping = false;
                    update_info ();
                    aria_pause_all ();
                    view_status ();
                }
                return stoping;
            }, GLib.Priority.HIGH_IDLE);
        }

        public string set_selected (string ariagid, string selected) {
            string aria_gid = "";
            for (int index = 0; index < listrow.size ; index++) {
                var row = (DownloadRow) list_box.get_row_at_index (index);
                if (row.ariagid == ariagid) {
                    aria_gid = row.set_selected (selected);
                }
            }
            return aria_gid;
        }

        public void append_row (string ariagid) {
            for (int index = 0; index < listrow.size ; index++) {
                var row = (DownloadRow) list_box.get_row_at_index (index);
                if (row.ariagid == ariagid) {
                    if (row.status == StatusMode.ACTIVE) {
                        append_dbus.begin (row.rowbus);
                    }
                }
            }
        }

        public void remove_row (string ariagid) {
            for (int index = 0; index < listrow.size ; index++) {
                var row = (DownloadRow) list_box.get_row_at_index (index);
                if (row.ariagid == ariagid) {
                    if (row.status == StatusMode.ACTIVE) {
                        remove_dbus.begin (row.rowbus);
                    }
                }
            }
        }

        private async void append_dbus (DbusmenuItem rowbus) throws GLib.Error {
            if (!menudbus.get_exist (rowbus)) {
                menudbus.child_append (rowbus);
            }
            if (dbmenu) {
                yield open_quicklist_dbus (dbusserver, menudbus);
            }
        }

        private async void remove_dbus (DbusmenuItem rowbus) throws GLib.Error {
            if (menudbus.get_exist (rowbus)) {
                menudbus.child_delete (rowbus);
            }
            if (dbmenu) {
                yield open_quicklist_dbus (dbusserver, menudbus);
            }
        }

        private async void update_quicklist () throws GLib.Error {
            if (dbmenu) {
                yield open_quicklist_dbus (dbusserver, menudbus);
            }
        }

        [CCode (instance_pos = -1)]
        private int sort_dm (DownloadRow row1, DownloadRow row2) {
            if (sorttype.get_index () == 0) {
                if (row1.filename != null && row2.filename != null) {
                    var name1 = row1.filename.down ();
                    var name2 = row2.filename.down ();
                    if (name1 > name2) {
                        return sort_a (deascend);
                    }
                    if (name1 < name2) {
                        return sort_b (deascend);
                    }
                } else {
                    return 0;
                }
            } else if (sorttype.get_index () == 1) {
                var total1 = row1.totalsize;
                var total2 = row2.totalsize;
                if (total1 > total2) {
                    return sort_a (deascend);
                }
                if (total1 < total2) {
                    return sort_b (deascend);
                }
            } else if (sorttype.get_index () == 2) {
                if (row1.fileordir != null && row2.fileordir != null) {
                    var fordir1 = row1.fileordir.down ();
                    var fordir2 = row2.fileordir.down ();
                    if (fordir1 > fordir2) {
                        return sort_a (deascend);
                    }
                    if (fordir1 < fordir2) {
                        return sort_b (deascend);
                    }
                } else {
                    return 0;
                }
            } else {
                var timeadded1 = row1.timeadded;
                var timeadded2 = row2.timeadded;
                if (timeadded1 > timeadded2) {
                    return sort_a (deascend);
                }
                if (timeadded1 < timeadded2) {
                    return sort_b (deascend);
                }
            }
            return 0;
        }

        [CCode (instance_pos = -1)]
        private void header_dm (DownloadRow row1, DownloadRow? row2) {
            var date1 = new GLib.DateTime.from_unix_local (row1.timeadded);
            var formdate = date1.format (@"%A $(showtime.active? "- %I:%M %p" : "") $(showdate.active? "- %d %B %Y" : "")");
            var label = new Gtk.Label (formdate) {
                xalign = 0,
                margin_start = 5,
                attributes = color_attribute (60000, 30000, 19764)
            };
            if (row2 == null) {
                row1.set_header (label);
            } else if (row2 == null || date1.format ("%x") != new GLib.DateTime.from_unix_local (row2.timeadded).format ("%x")) {
                row1.set_header (label);
            } else {
                if (showtime.active) {
                    if (formdate != new GLib.DateTime.from_unix_local (row2.timeadded).format ("%A - %I:%M %p ") && !showdate.active) {
                        row1.set_header (label);
                    } else if (formdate != new GLib.DateTime.from_unix_local (row2.timeadded).format ("%A - %I:%M %p - %d %B %Y") && showdate.active) {
                        row1.set_header (label);
                    } else {
                        row1.set_header (null);
                    }
                } else {
                    row1.set_header (null);
                }
            }
        }

        public void view_status () {
            if (starting || stoping || removing) {
                return;
            }
            index_rowdm = 0;
            if (headerstack.visible_child_name == "search") {
                if (list_box.selection_mode != Gtk.SelectionMode.MULTIPLE) {
                    badge_rbtn.gicon = modeview.gicon = new ThemedIcon ("com.github.gabutakut.gabutdm.find");
                    badge_rbtn.tooltip_text = _("Disabled\nCTRL + C");
                }
                if (search_entry.text.strip () == "") {
                    list_box.set_filter_func ((item) => {
                        index_rowdm = 0;
                        return false;
                    });
                    var search_alert = new AlertView (
                        _("Find File"),
                        _("Mode Search Based on Filename."),
                        "com.github.gabutakut.gabutdm.find"
                    );
                    search_alert.show ();
                    list_box.set_placeholder (search_alert);
                    selected_mode ();
                    return;
                }
                bool item_visible = false;
                list_box.set_filter_func ((item) => {
                    if (item.get_child_visible ()) {
                        item_visible = true;
                    }
                    if (((DownloadRow) item).filename == null) {
                        return false;
                    }
                    if (((DownloadRow) item).filename.casefold ().contains (search_entry.text.casefold ())) {
                        index_rowdm++;
                    }
                    if (list_box.selection_mode != Gtk.SelectionMode.MULTIPLE) {
                        labelview.label = index_rowdm.to_string ();
                    }
                    return ((DownloadRow) item).filename.casefold ().contains (search_entry.text.casefold ());
                });
                if (!item_visible) {
                    var empty_alert = new AlertView (
                        _("No Search Found"),
                        _("Drag and Drop URL, Torrent, Metalink, Magnet URIs."),
                        "com.github.gabutakut.gabutdm.find"
                    );
                    empty_alert.show ();
                    list_box.set_placeholder (empty_alert);
                }
                return;
            }
            switch (view_mode.selected) {
                case 1:
                    list_box.set_filter_func ((item) => {
                        if (((DownloadRow)item).status == StatusMode.ACTIVE) {
                            index_rowdm++;
                        }
                        return ((DownloadRow) item).status == StatusMode.ACTIVE;
                    });
                    if (index_rowdm < allactive) {
                        next_download ();
                    }
                    var active_alert = new AlertView (
                        _("No Active Download"),
                        _("Drag and Drop URL, Torrent, Metalink, Magnet URIs."),
                        "com.github.gabutakut.gabutdm.active"
                    );
                    badge_rbtn.gicon = modeview.gicon = new ThemedIcon (active_alert.icon_name);
                    badge_rbtn.tooltip_text = _("Remove All ACTIVE\nCTRL + C");
                    active_alert.show ();
                    list_box.set_placeholder (active_alert);
                    break;
                case 2:
                    list_box.set_filter_func ((item) => {
                        if (((DownloadRow)item).status == StatusMode.PAUSED) {
                            index_rowdm++;
                        }
                        return ((DownloadRow) item).status == StatusMode.PAUSED;
                    });
                    var nopause_alert = new AlertView (
                        _("No Paused Download"),
                        _("Drag and Drop URL, Torrent, Metalink, Magnet URIs."),
                        "com.github.gabutakut.gabutdm.pause"
                    );
                    badge_rbtn.gicon = modeview.gicon = new ThemedIcon (nopause_alert.icon_name);
                    badge_rbtn.tooltip_text = _("Remove All PAUSED\nCTRL + C");
                    nopause_alert.show ();
                    list_box.set_placeholder (nopause_alert);
                    break;
                case 3:
                    list_box.set_filter_func ((item) => {
                        if (((DownloadRow)item).status == StatusMode.COMPLETE) {
                            index_rowdm++;
                        }
                        return ((DownloadRow) item).status == StatusMode.COMPLETE;
                    });
                    var nocomp_alerst = new AlertView (
                        _("No Complete Download"),
                        _("Drag and Drop URL, Torrent, Metalink, Magnet URIs."),
                        "com.github.gabutakut.gabutdm.complete"
                    );
                    badge_rbtn.gicon = modeview.gicon = new ThemedIcon (nocomp_alerst.icon_name);
                    badge_rbtn.tooltip_text = _("Remove All COMPLETE\nCTRL + C");
                    nocomp_alerst.show ();
                    list_box.set_placeholder (nocomp_alerst);
                    break;
                case 4:
                    list_box.set_filter_func ((item) => {
                        if (((DownloadRow)item).status == StatusMode.WAIT) {
                            index_rowdm++;
                        }
                        return ((DownloadRow) item).status == StatusMode.WAIT;
                    });
                    var nowait_alert = new AlertView (
                        _("No Waiting Download"),
                        _("Drag and Drop URL, Torrent, Metalink, Magnet URIs."),
                        "com.github.gabutakut.gabutdm.waiting"
                    );
                    badge_rbtn.gicon = modeview.gicon = new ThemedIcon (nowait_alert.icon_name);
                    badge_rbtn.tooltip_text = _("Remove All WAITING\nCTRL + C");
                    nowait_alert.show ();
                    list_box.set_placeholder (nowait_alert);
                    break;
                case 5:
                    list_box.set_filter_func ((item) => {
                        if (((DownloadRow)item).status == StatusMode.ERROR) {
                            index_rowdm++;
                        }
                        return ((DownloadRow) item).status == StatusMode.ERROR;
                    });
                    var noerr_alert = new AlertView (
                        _("No Error Download"),
                        _("Drag and Drop URL, Torrent, Metalink, Magnet URIs."),
                        "com.github.gabutakut.gabutdm.error"
                    );
                    badge_rbtn.gicon = modeview.gicon = new ThemedIcon (noerr_alert.icon_name);
                    badge_rbtn.tooltip_text = _("Remove All ERROR\nCTRL + C");
                    noerr_alert.show ();
                    list_box.set_placeholder (noerr_alert);
                    break;
                default:
                    bool hide_alert = false;
                    list_box.set_filter_func ((item)=> {
                        if (item.get_child_visible ()) {
                            hide_alert = true;
                        }
                        return true;
                    });
                    index_rowdm = listrow.size;
                    badge_rbtn.gicon = modeview.gicon = new ThemedIcon (nodown_alert.icon_name);
                    badge_rbtn.tooltip_text = _("Remove All\nCTRL + C");
                    if (!hide_alert) {
                        list_box.set_placeholder (nodown_alert);
                    }
                    break;
            }
            selected_mode ();
            list_box.set_sort_func ((Gtk.ListBoxSortFunc) sort_dm);
        }

        private void selected_mode () {
            if (starting || stoping || removing) {
                return;
            }
            if (list_box.selection_mode == Gtk.SelectionMode.MULTIPLE) {
                badge_rbtn.gicon = modeview.gicon = new ThemedIcon ("com.github.gabutakut.gabutdm.select");
                badge_rbtn.tooltip_text = _("Remove Selected\nCTRL + C");
                labelview.label = list_box.get_selected_rows ().length ().to_string ();
            } else {
                labelview.label = index_rowdm.to_string ();
            }
        }
    }
}