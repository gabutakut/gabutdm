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
    public class GabutWindow : Gtk.Window {
        public signal bool send_file (string url);
        public signal void stop_server ();
        public signal void restart_server ();
        public signal void open_show ();
        public signal bool active_downloader (string ariagid);
        public signal void update_agid (string ariagid, string newgid);
        public signal string get_host ();
        private Preferences preferences;
        private QrCode qrcode;
        private ModeButton view_mode;
        private DBusMenu? menudbus = null;
        private GdmUnityLauncherEntry? launcher_entry = null;
        private AlertView nodown_alert;
        private DbusIndicator dbusindicator = null;
        private DeleteDialog delete_dialog;
        private HlsManBox hlsmanbox;
        private Gee.ArrayList<AddUrl> linkproperty;
        private Gee.ArrayList<AddTorrent> torrproperty;
        private Gee.ArrayList<AddHls> hlsproperty;
        private Gtk.ListBox list_box;
        private Gtk.Stack headerstack;
        private Gtk.SearchEntry search_entry;
        private DBusMenu.DbusmenuItem openmenu = null;
        private DBusMenu.DbusmenuItem urlmenu = null;
        private DBusMenu.DbusmenuItem hlsmenu = null;
        private DBusMenu.DbusmenuItem opentormenu = null;
        private DBusMenu.DbusmenuItem setmenu = null;
        private DBusMenu.DbusmenuItem startmenu = null;
        private DBusMenu.DbusmenuItem pausemenu = null;
        private DBusMenu.DbusmenuItem qrmenu = null;
        private Gtk.CheckButton showtime;
        private Gtk.CheckButton showdate;
        private Gtk.Label download_rate;
        private Gtk.Label upload_rate;
        private Gtk.Label labelact;
        private Gtk.Label labelview;
        private Gtk.Label labelselect;
        private Gtk.Image modeview;
        private int animation = 0;
        private int index_rowdm = 0;
        private int allactive = 0;
        private int limitcount = 0;
        private int64 totalfiles = 0;
        private int64 totalrecv = 0;
        private bool removing = false;
        private bool starting = false;
        private bool stoping = false;
        private bool waitme = false;

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
            }
        }

        private bool _indmenu = false;
        public bool indmenu {
            get {
                return _indmenu;
            }
            set {
                _indmenu = value;
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
            indmenu = bool.parse (get_dbsetting (DBSettings.MENUINDICATOR));
            dbmenu = bool.parse (get_dbsetting (DBSettings.DBUSMENU));
            setup_dbusmenu.begin ();
            regunreg_idmenu.begin ();
            hlsmanbox = new HlsManBox ();
            nodown_alert = new AlertView (
                _("No File Download"),
                _("Drag and Drop URL, Torrent, Metalink, Magnet URIs."),
                "com.github.gabutakut.gabutdm"
            );
            nodown_alert.show ();
            list_box = new Gtk.ListBox () {
                activate_on_single_click = false,
                selection_mode = Gtk.SelectionMode.MULTIPLE
            };
            list_box.row_activated.connect ((row) => {
                if (row.is_selected ()) {
                    list_box.unselect_row (row);
                } else {
                    list_box.select_row (row);
                }
            });
            list_box.set_sort_func ((Gtk.ListBoxSortFunc) sort_dm);
            list_box.set_placeholder (nodown_alert);

            var scrolled = new Gtk.ScrolledWindow () {
                height_request = 400,
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
            view_mode.append_icon_text ("com.github.gabutakut.gabutdm.progress", "All");
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
                gicon = new ThemedIcon ("com.github.gabutakut.gabutdm.progress")
            };

            labelview = new Gtk.Label (null) {
                ellipsize = Pango.EllipsizeMode.END,
                valign = Gtk.Align.CENTER,
                margin_start = 10,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };
            var selectview = new Gtk.Image () {
                margin_start = 10,
                valign = Gtk.Align.CENTER,
                gicon = new ThemedIcon ("com.github.gabutakut.gabutdm.select")
            };

            labelselect = new Gtk.Label (null) {
                ellipsize = Pango.EllipsizeMode.END,
                valign = Gtk.Align.CENTER,
                margin_start = 10,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };

            var boxinfo = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            boxinfo.append (selectview);
            boxinfo.append (labelselect);
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

        public override bool close_request () {
            if (bool.parse (get_dbsetting (DBSettings.ONBACKGROUND))) {
                hide();
                if (menudbus != null && dbmenu) {
                    if (!menudbus.dbus_contains (openmenu)) {
                        menudbus.insert_dbus (openmenu, 0);
                    }
                }
            } else {
                save_all_download ();
            }
            return base.close_request ();
        }

        private async void setup_dbusmenu () throws GLib.Error {
            if (dbmenu) {
                if (launcher_entry == null) {
                    launcher_entry = yield GdmUnityLauncherEntry.get_instance (Environment.get_application_name ());
                }
                if (menudbus == null) {
                    menudbus = yield DBusMenu.get_instance (get_app_id ());
                }
                if (openmenu == null) {
                    openmenu = new DBusMenu.DbusmenuItem ();
                    openmenu.property_set (MenuItem.LABEL.to_string (), _("Gabut Download Manager"));
                    openmenu.property_set (MenuItem.ICON_NAME.to_string (), "com.github.gabutakut.gabutdm");
                    openmenu.property_set_bool (MenuItem.VISIBLE.to_string (), true);
                    openmenu.item_activated.connect (()=> open_show ());
                }
                if (urlmenu == null) {
                    urlmenu = new DBusMenu.DbusmenuItem ();
                    urlmenu.property_set (MenuItem.LABEL.to_string (), _("Add Url/Magnet"));
                    urlmenu.property_set (MenuItem.ICON_NAME.to_string (), "com.github.gabutakut.gabutdm.uri");
                    urlmenu.property_set_bool (MenuItem.VISIBLE.to_string (), true);
                    urlmenu.item_activated.connect (()=> {
                        add_url ("com.github.gabutakut.gabutdm.insertlink");
                    });
                }
                if (hlsmenu == null) {
                    hlsmenu = new DBusMenu.DbusmenuItem ();
                    hlsmenu.property_set (MenuItem.LABEL.to_string (), _("Add HLS"));
                    hlsmenu.property_set (MenuItem.ICON_NAME.to_string (), "com.github.gabutakut.gabutdm.hls");
                    hlsmenu.property_set_bool (MenuItem.VISIBLE.to_string (), true);
                    hlsmenu.item_activated.connect (add_hls);
                }
                if (opentormenu == null) {
                    opentormenu = new DBusMenu.DbusmenuItem ();
                    opentormenu.property_set (MenuItem.LABEL.to_string (), _("Open Torrent"));
                    opentormenu.property_set (MenuItem.ICON_NAME.to_string (), "com.github.gabutakut.gabutdm.torrent");
                    opentormenu.property_set_bool (MenuItem.VISIBLE.to_string (), true);
                    opentormenu.item_activated.connect (()=> {
                        run_open_file.begin (this, OpenFiles.OPENFILES, (obj, res)=> {
                            try {
                                GLib.File[] files = run_open_file.end (res);
                                foreach (var file in files) {
                                    send_file (file.get_path ());
                                }
                            } catch (GLib.Error e) {
                                critical (e.message);
                            }
                        });
                    });
                }
                if (setmenu == null) {
                    setmenu = new DBusMenu.DbusmenuItem ();
                    setmenu.property_set (MenuItem.LABEL.to_string (), _("Settings"));
                    setmenu.property_set (MenuItem.ICON_NAME.to_string (), "com.github.gabutakut.gabutdm.settings");
                    setmenu.property_set_bool (MenuItem.VISIBLE.to_string (), true);
                    setmenu.item_activated.connect (menuprefernces);
                }
                if (startmenu == null) {
                    startmenu = new DBusMenu.DbusmenuItem();
                    startmenu.property_set (MenuItem.LABEL.to_string (), _("Start All"));
                    startmenu.property_set (MenuItem.ICON_NAME.to_string (), "com.github.gabutakut.gabutdm.active");
                    startmenu.property_set_bool (MenuItem.VISIBLE.to_string (), true);
                    startmenu.item_activated.connect (start_all);
                }
                if (pausemenu == null) {
                    pausemenu = new DBusMenu.DbusmenuItem ();
                    pausemenu.property_set (MenuItem.LABEL.to_string (), _("Pause All"));
                    pausemenu.property_set (MenuItem.ICON_NAME.to_string (), "com.github.gabutakut.gabutdm.pause");
                    pausemenu.property_set_bool (MenuItem.VISIBLE.to_string (), true);
                    pausemenu.item_activated.connect (stop_all);
                }
                if (qrmenu == null) {
                    qrmenu = new DBusMenu.DbusmenuItem ();
                    qrmenu.property_set (MenuItem.LABEL.to_string (), _("Remote"));
                    qrmenu.property_set (MenuItem.ICON_NAME.to_string (), "com.github.gabutakut.gabutdm.gohome");
                    qrmenu.property_set_bool (MenuItem.VISIBLE.to_string (), true);
                    qrmenu.item_activated.connect (qrmenuopen);
                }
                if (menudbus != null) {
                    menudbus.append_dbus (openmenu);
                    menudbus.append_dbus (urlmenu);
                    menudbus.append_dbus (hlsmenu);
                    menudbus.append_dbus (opentormenu);
                    menudbus.append_dbus (startmenu);
                    menudbus.append_dbus (pausemenu);
                    menudbus.append_dbus (setmenu);
                    menudbus.append_dbus (qrmenu);
                }
                if (launcher_entry != null) {
                    if (menudbus != null) {
                        launcher_entry.set_quicklist.begin (menudbus.get_dbus_path ());
                    }
                }
            } else {
                if (menudbus != null) {
                    menudbus.clear ();
                }
                if (launcher_entry != null) {
                    yield GdmUnityLauncherEntry.unregister_instance (Environment.get_application_name ());
                    launcher_entry = null;
                }
            }
        }

        public async void regunreg_idmenu () throws GLib.Error {
            if (indmenu && dbmenu) {
                if (dbusindicator == null) {
                    dbusindicator = yield DbusIndicator.get_instance (Environment.get_application_name ());
                    dbusindicator.set_status ("Active");
                    dbusindicator.set_icon_name ("com.github.gabutakut.gabutdm");
                }
            } else {
                if (dbusindicator != null) {
                    dbusindicator.set_status ("Passive");
                    yield DbusIndicator.unregister_instance (Environment.get_application_name ());
                    dbusindicator = null;
                }
            }
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
                    var rws = (DownloadRow) row;
                    if (rws.linkmode == LinkMode.URL || rws.linkmode == LinkMode.MAGNETLINK) {
                        urlprop (rws);
                    } else if (rws.linkmode == LinkMode.HLS){
                        hlsprop (rws);
                    } else {
                        torrprop (rws);
                    }
                });
            } else if (ctrl_pressed && match_keycode (Gdk.Key.z, keycode)) {
                start_all ();
            } else if (ctrl_pressed && match_keycode (Gdk.Key.x, keycode)) {
                stop_all ();
            } else if (ctrl_pressed && match_keycode (Gdk.Key.y, keycode)) {
                add_hls ();
            } else if (ctrl_pressed && match_keycode (Gdk.Key.a, keycode)) {
                list_box.select_all ();
            } else if (ctrl_pressed && match_keycode (Gdk.Key.u, keycode)) {
                add_url ("com.github.gabutakut.gabutdm.insertlink");
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
                remove_delete (false);
            } else if (ctrl_pressed && match_keycode (Gdk.Key.i, keycode)) {
                run_open_file.begin (this, OpenFiles.OPENFILES, (obj, res)=> {
                    try {
                        GLib.File[] files = run_open_file.end (res);
                        foreach (var file in files) {
                            send_file (file.get_path ());
                        }
                    } catch (GLib.Error e) {
                        critical (e.message);
                    }
                });
            }
            switch (keyval) {
                case Gdk.Key.Escape:
                    list_box.unselect_all ();
                    if (headerstack.visible_child_name == "search") {
                        searchf ();
                    }
                    break;
                case Gdk.Key.Delete:
                    remove_delete ();
                    break;
            }
            return false;
        }

        private void remove_delete (bool deletef = true) {
            if (headerstack.visible_child_name == "search") {
                return;
            }
            if (starting || stoping || removing) {
                return;
            }
            var hashrow = new Gee.ArrayList<DownloadRow> ();
            list_box.get_selected_rows ().foreach ((rows)=> {
                hashrow.add ((DownloadRow) rows);
            });
            if (hashrow.size < 1) {
                return;
            }
            int totalrow = count_rows_only ();
            if (delete_dialog == null) {
                delete_dialog = new DeleteDialog () {
                    transient_for = this,
                    datarow = hashrow,
                    totalrow = totalrow,
                    icimg = deletef? "user-trash-full" : "com.github.gabutakut.gabutdm.clear",
                    primmelb = deletef? _("Move to Trash") : _("Remove from list"),
                    infolabel = deletef? _("Delete") : _("Clear"),
                    labelrm = deletef? _("Delete") : _("Remove")
                };
                delete_dialog.move_file.clicked.connect (()=> {
                    int totaldx = hashrow.size;
                    GLib.Idle.add (() => {
                        if (hashrow.size > 0) {
                            removing = true;
                            for (int b = 0; b < totalrow; b++) {
                                var row = (DownloadRow) list_box.get_row_at_index (b);
                                if (hashrow.contains (row)) {
                                    labelview.label = _("%s (%i of %i)").printf (deletef? "Deleting…" : "Removing…", ((totaldx + 1) - hashrow.size), totaldx);
                                    indicatorstatus ();
                                    hashrow.remove (row);
                                    MainContext.default ().invoke (() => {
                                        if (deletef) {
                                            row.to_trash ();
                                        } else {
                                            row.remove_down ();
                                        }
                                        return false;
                                    });
                                }
                            }
                        } else {
                            removing = false;
                            update_info ();
                            view_status ();
                        }
                        return removing;
                    }, GLib.Priority.HIGH_IDLE);
                    delete_dialog.close ();
                });
                delete_dialog.close_request.connect (()=> {
                    delete_dialog = null;
                    return GLib.Source.REMOVE;
                });
                delete_dialog.show ();
            }
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

            var search_button = new Gtk.Button.from_icon_name ("com.github.gabutakut.gabutdm.find") {
                has_frame = false,
                tooltip_text = _("Search\nCTRL + S")
            };
            headerbar.pack_end (search_button);
            search_button.clicked.connect (searchf);
            headerstack.notify["visible-child"].connect (()=> {
                view_status ();
                search_entry.text = "";
                search_button.icon_name = headerstack.visible_child_name == "mode"? "com.github.gabutakut.gabutdm.find" : "com.github.gabutakut.gabutdm.stopfind";
                search_button.tooltip_text = headerstack.visible_child_name == "mode"? _("Search\nCTRL + S") : _("Back\nESC");
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
            var resumeall_button = new Gtk.Button.from_icon_name ("com.github.gabutakut.gabutdm.activeall") {
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

            var badge_rbtn = new Gtk.Image () {
                gicon = new ThemedIcon ("com.github.gabutakut.gabutdm.select"),
                tooltip_text = _("Remove Selected\nCTRL + C"),
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
            removeall_button.clicked.connect (()=> {
                remove_delete (false);
            });
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
                    case OpenMenus.ADDHLS:
                        add_hls ();
                        break;
                    case OpenMenus.OPENMN:
                        run_open_file.begin (this, OpenFiles.OPENFILES, (obj, res)=> {
                            try {
                                GLib.File[] files = run_open_file.end (res);
                                foreach (var file in files) {
                                    send_file (file.get_path ());
                                }
                            } catch (GLib.Error e) {
                                critical (e.message);
                            }
                        });
                        break;
                    case OpenMenus.ADDMAGNET:
                        add_url ("com.github.gabutakut.gabutdm.magnet");
                        break;
                    default:
                        add_url ("list-add");
                        break;
                }
            });
            return popovermenu;
        }

        private void add_hls () {
            var addhls = new AddHls () {
                transient_for = this,
                url_link = ""
            };
            addhls.downloadfile.connect (add_url_box);
            addhls.close_request.connect (()=> {
                addhls = null;
                return false;
            });
            addhls.show ();
        }

        private void add_url (string urlicon) {
            var addurl = new AddUrl () {
                transient_for = this,
                url_link = "",
                url_icon = urlicon
            };
            addurl.downloadfile.connect (add_url_box);
            addurl.close_request.connect (()=> {
                addurl = null;
                return false;
            });
            addurl.show ();
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
                preferences.restart_server.connect (()=> restart_server());
                preferences.restart_process.connect (()=> {
                    var models = list_box.observe_children ();
                    var maxsize = models.get_n_items ();
                    for (uint x = 0; x < maxsize; x++) {
                        var child = (Gtk.Widget) models.get_item (x);
                        if (child is Gtk.ListBoxRow) {
                            var row = (DownloadRow) child;
                            row.if_not_exist (row.ariagid, row.linkmode, row.status);
                        }
                    }
                });
                preferences.max_active.connect (next_download);
                preferences.global_opt.connect (update_options);
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
            setup_dbusmenu.begin ();
            regunreg_idmenu.begin ();
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
            linkproperty = new Gee.ArrayList<AddUrl> ();
            torrproperty = new Gee.ArrayList<AddTorrent> ();
            hlsproperty = new Gee.ArrayList<AddHls> ();
            list_box.selected_rows_changed.connect (()=> {
                if (list_box.get_selected_rows ().length () > 0) {
                    property_button.popover = get_menuprop ();
                } else {
                    property_button.popover = null;
                }
                labelselect.label = list_box.get_selected_rows ().length ().to_string ();
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
                    case DownloadMenu.OPENFOLDER:
                        list_box.get_selected_rows ().foreach ((rows)=> {
                            ((DownloadRow) rows).open_filesr ();
                        });
                        break;
                    case DownloadMenu.MOVETOTRASH:
                        remove_delete ();
                        break;
                    case DownloadMenu.PROPERTIES:
                        list_box.get_selected_rows ().foreach ((row)=> {
                            var rws = (DownloadRow) row;
                            if (rws.linkmode == LinkMode.URL || rws.linkmode == LinkMode.MAGNETLINK) {
                                urlprop (rws);
                            } else if (rws.linkmode == LinkMode.HLS){
                                hlsprop (rws);
                            } else {
                                torrprop (rws);
                            }
                        });
                        break;
                    default:
                        list_box.select_all ();
                        break;
                }
            });
            return urisel_popover;
        }

        private void urlprop (DownloadRow row) {
            if (!url_available (row)) {
                var urlproperty = new AddUrl.Property () {
                    transient_for = this,
                    row = row
                };
                linkproperty.add (urlproperty);
                urlproperty.close_request.connect (()=> {
                    if (linkproperty.contains (urlproperty)) {
                        linkproperty.remove (urlproperty);
                    }
                    urlproperty = null;
                    return GLib.Source.REMOVE;
                });
                urlproperty.update_agid.connect ((ariagid, newgid)=> update_agid (ariagid, newgid));
                urlproperty.show ();
            }
        }

        private void torrprop (DownloadRow row) {
            if (!torr_available (row)) {
                var addtorrpr = new AddTorrent.Property () {
                    transient_for = this,
                    row = row
                };
                torrproperty.add (addtorrpr);
                addtorrpr.close_request.connect (()=> {
                    if (torrproperty.contains (addtorrpr)) {
                        torrproperty.remove (addtorrpr);
                    }
                    addtorrpr = null;
                    return GLib.Source.REMOVE;
                });
                addtorrpr.update_agid.connect ((ariagid, newgid)=> update_agid (ariagid, newgid));
                addtorrpr.show ();
            }
        }

        private void hlsprop (DownloadRow row) {
            if (!hls_available (row)) {
                var addhls = new AddHls.Property () {
                    transient_for = this,
                    row = row
                };
                hlsproperty.add (addhls);
                addhls.close_request.connect (()=> {
                    if (hlsproperty.contains (addhls)) {
                        hlsproperty.remove (addhls);
                    }
                    addhls = null;
                    return GLib.Source.REMOVE;
                });
                addhls.show ();
            }
        }

        private bool url_available (DownloadRow row) {
            bool active = false;
            linkproperty.foreach ((propet)=> {
                if (propet.row == row) {
                    active = true;
                }
                return true;
            });
            return active;
        }

        private bool torr_available (DownloadRow row) {
            bool active = false;
            torrproperty.foreach ((propet)=> {
                if (propet.row == row) {
                    active = true;
                }
                return true;
            });
            return active;
        }

        private bool hls_available (DownloadRow row) {
            bool active = false;
            hlsproperty.foreach ((propet)=> {
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
            if (menudbus != null) {
                menudbus.delete_dbus (openmenu);
            }
            base.show ();
        }

        private bool set_menulauncher () {
            if (dbmenu) {
                var globalactive = int64.parse (aria_globalstat ()[GlobalStat.NUMACTIVE]) + hlsmanbox.active_hlsrow;
                bool statact = globalactive > 0;
                if (!statact) {
                    int stoped = 5;
                    Timeout.add (500, ()=> {
                        if (launcher_entry != null) {
                            launcher_entry.set_count.begin (0);
                            launcher_entry.set_count_visible.begin (false);
                            launcher_entry.set_urgent.begin (false);
                            launcher_entry.set_progress.begin (0);
                            launcher_entry.set_progress_visible.begin (false);
                        }
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
            return GLib.Source.REMOVE;
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
            var models = list_box.observe_children ();
            var maxsize = models.get_n_items ();
            for (uint x = 0; x < maxsize; x++) {
                var child = (Gtk.Widget) models.get_item (x);
                if (child is Gtk.ListBoxRow) {
                    var row = (DownloadRow) child;
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
            }
            set_download (downloads);
        }

        public Gee.ArrayList<DownloadRow> get_dl_row (int status) {
            var rowlist = new Gee.ArrayList<DownloadRow> ();
            var models = list_box.observe_children ();
            var maxsize = models.get_n_items ();
            for (uint x = 0; x < maxsize; x++) {
                var child = (Gtk.Widget) models.get_item (x);
                if (child != null) {
                    if (child is Gtk.ListBoxRow) {
                        var row = (DownloadRow) child;
                        if (row.status == status) {
                            rowlist.add (row);
                        }
                    }
                }
            }
            return rowlist;
        }

        public DownloadRow? get_dm_row (string ariagid) {
            var models = list_box.observe_children ();
            var maxsize = models.get_n_items ();
            for (uint x = 0; x < maxsize; x++) {
                var child = (Gtk.Widget) models.get_item (x);
                if (child != null) {
                    if (child is Gtk.ListBoxRow) {
                        var row = (DownloadRow) child;
                        if (row.ariagid == ariagid) {
                            return row;
                        }
                    }
                }
            }
            return null;
        }

        public DownloadRow? get_hls_row (string urlu) {
            var models = list_box.observe_children ();
            var maxsize = models.get_n_items ();
            for (uint x = 0; x < maxsize; x++) {
                var child = (Gtk.Widget) models.get_item (x);
                if (child != null) {
                    if (child is Gtk.ListBoxRow) {
                        var row = (DownloadRow) child;
                        if (row.linkmode == LinkMode.HLS) {
                            var check = GLib.Checksum.compute_for_string (ChecksumType.MD5, row.url, row.url.length);
                            if (check == urlu) {
                                return row;
                            }
                        }
                    }
                }
            }
            return null;
        }

        private void update_options () {
            var models = list_box.observe_children ();
            var maxsize = models.get_n_items ();
            for (uint x = 0; x < maxsize; x++) {
                var child = (Gtk.Widget) models.get_item (x);
                if (child is Gtk.ListBoxRow) {
                    var row = (DownloadRow) child;
                    if (row.status != StatusMode.COMPLETE && row.status != StatusMode.ERROR) {
                        glob_to_opt (row.ariagid);
                    }
                }
            }
        }

        private void next_download () {
            if (waitme) {
                return;
            }
            var a2active = aria_tell_active ();
            var models = list_box.observe_children ();
            var maxsize = models.get_n_items ();
            for (uint x = 0; x < maxsize; x++) {
                waitme = false;
                var child = (Gtk.Widget) models.get_item (x);
                if (child is Gtk.ListBoxRow) {
                    var row = (DownloadRow) child;
                    if (a2active.contains (row.ariagid)) {
                        if (row.status == StatusMode.PAUSED || row.status == StatusMode.WAIT || row.status == StatusMode.SEED) {
                            row.update_sts ();
                        }
                    }
                }
                if(x >= maxsize) {
                    waitme = true;
                }
            }
        }

        public string server_action (string ariagid, int status = 2) {
            var agid = ariagid;
            var models = list_box.observe_children ();
            var maxsize = models.get_n_items ();
            for (uint x = 0; x < maxsize; x++) {
                var child = (Gtk.Widget) models.get_item (x);
                if (child is Gtk.ListBoxRow) {
                    var row = (DownloadRow) child;
                    if (row.ariagid == ariagid) {
                        agid = row.action_btn (status);
                    }
                }
            }
            return agid;
        }

        public void lserv_action (string[] urlhash) {
            var models = list_box.observe_children ();
            var maxsize = models.get_n_items ();
            for (uint x = 0; x < maxsize; x++) {
                var child = (Gtk.Widget) models.get_item (x);
                if (child is Gtk.ListBoxRow) {
                    var row = (DownloadRow) child;
                    if (urlhash[1] == "url") {
                        if (row.ariagid == urlhash[0]) {
                            row.action_btn (StatusMode.COMPLETE);
                        }
                    } else if (urlhash[1] == "hls") {
                        var check = GLib.Checksum.compute_for_string (ChecksumType.MD5, row.url, row.url.length);
                        if (check == urlhash[0]) {
                            row.start_button.clicked (); 
                        }
                    }
                }
            }
        }

        public void remove_item (string[] ariagid) {
            var models = list_box.observe_children ();
            var maxsize = models.get_n_items ();
            for (uint x = 0; x < maxsize; x++) {
                var child = (Gtk.Widget) models.get_item (x);
                if (child is Gtk.ListBoxRow) {
                    var row = (DownloadRow) child;
                    if (ariagid[1] == "url") {
                        if (row.ariagid == ariagid[0]) {
                            row.to_trash ();
                        }
                    } else if (ariagid[1] == "hls") {
                        var check = GLib.Checksum.compute_for_string (ChecksumType.MD5, row.url, row.url.length);
                        if (check == ariagid[0]) {
                            row.to_trash (); 
                        }
                    }
                }
            }
        }

        public void load_dowanload () {
            get_download ().foreach ((row)=> {
                if (!get_exist (row.url)) {
                    if (row.linkmode != LinkMode.HLS) {
                        on_append (row);
                        row.notify_property ("status");
                    } else {
                        string useragent = "";
                        var useuseragt = row.hashoption.has_key (AriaOptions.USER_AGENT.to_string ());
                        if (useuseragt) {
                            useragent = row.hashoption.@get (AriaOptions.USER_AGENT.to_string ());
                        } else {
                            useragent = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36";
                        }
                        string head = "NOTSET";
                        var header = row.hashoption.has_key (AriaOptions.HEADER.to_string ());
                        if (header) {
                            head = row.hashoption.@get (AriaOptions.HEADER.to_string ());
                        }
                        row.pathname = row.filepath;
                        append_hls (row, row.url, row.filename, row.filepath, head, useragent);
                    }
                }
            });
        }

        public void add_url_box (string url, Gee.HashMap<string, string> options, bool later, int linkmode) {
            if (get_exist (url)) {
                return;
            }
            if (linkmode == LinkMode.HLS) {
                var row = new DownloadRow.Hls (url, options, linkmode) {
                    timeadded = new GLib.DateTime.now_local ().to_unix ()
                };
                var dm_fname = "";
                if (options.has_key (AriaOptions.OUT.to_string ())) {
                    dm_fname = options.@get (AriaOptions.OUT.to_string ());
                }
                var dir_dm = "";
                if (options.has_key (AriaOptions.DIR.to_string ())) {
                    dir_dm = options.@get (AriaOptions.DIR.to_string ());
                } else {
                    dir_dm = Environment.get_user_special_dir (GLib.UserDirectory.DOWNLOAD);
                }
                var opt_dir = File.new_build_filename (dir_dm, dm_fname.hash ().to_string ());
                if (!opt_dir.query_exists ()) {
                    try {
                        opt_dir.make_directory_with_parents ();
                    } catch (Error e) {
                        warning (e.message);
                    }
                }
                options[AriaOptions.DIR.to_string ()] = row.filepath = row.pathname = opt_dir.get_path ();
                string useragent = "";
                var useuseragt = options.has_key (AriaOptions.USER_AGENT.to_string ());
                if (useuseragt) {
                    useragent = options.@get (AriaOptions.USER_AGENT.to_string ());
                } else {
                    useragent = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36";
                }
                string head = "NOTSET";
                var header = options.has_key (AriaOptions.HEADER.to_string ());
                if (header) {
                    head = options.@get (AriaOptions.HEADER.to_string ());
                }
                append_hls (row, url, dm_fname, opt_dir.get_path (), useragent, head, later);
                row.filepath = row.pathname = opt_dir.get_path ();
            } else {
                var row = new DownloadRow.Url (url, options, linkmode) {
                    timeadded = new GLib.DateTime.now_local ().to_unix ()
                };
                MainContext.default ().invoke (() => {
                    if (row != null) {
                        row.update_progress ();
                        if (!later) {
                            row.download ();
                            var filename = row.filename;
                            if (filename != "" && filename != null) {
                                notify_app (_("Starting"), filename, get_icon_for_filename (filename));
                            }
                            play_sound ("device-added");
                        } else {
                            var ariagid = row.ariagid;
                            if (ariagid != "" && ariagid != null) {
                                aria_pause (ariagid);
                            }
                        }
                    }
                    return GLib.Source.REMOVE;
                });
                on_append (row);
            }
            save_all_download ();
        }

        private void append_hls (DownloadRow row, string url, string fname, string directory, string useragent, string header, bool later = true) {
            row.filename = fname;
            string homeurl = "";
            string[] hlslink = null;
            var urlhls = url.split("gabuthls");
            for (int b = 0; b < urlhls.length; b++) {
                if (b == 0) {
                    homeurl = urlhls[b];
                    continue;
                }
                hlslink += urlhls[b];
            }
            var hlslbox = new HLSLBox () {
                filename = fname,
                timeadded = row.timeadded,
                fileordir = row.fileordir,
                output_dir = directory,
                useragent = useragent,
                headerdm = header
            };
            var added = hlslbox.segment_urls.size;

            foreach (string l in hlslink) {
                string lines = l.strip();
                if (lines.length == 0 || lines.has_prefix("#")) {
                    continue;
                }
                string seg_url;
                try {
                    seg_url = GLib.Uri.resolve_relative(homeurl, lines, GLib.UriFlags.NONE);
                } catch (GLib.UriError e) {
                    continue;
                }
                if (!hlslbox.segment_urls.contains(seg_url)) {
                    hlslbox.segment_urls.add(seg_url);
                    string filename = "segment_%05d.ts".printf(added);
                    var row_hls = new HLSRow(added, filename, directory);
                    hlslbox.append_row (row_hls);
                    row_hls.show ();
                    added++;
                }
            }
            row.update_url.connect ((option, finame, hlsurl)=> {
                homeurl = "";
                hlslink = null;
                urlhls = hlsurl.split("gabuthls");
                for (int b = 0; b < urlhls.length; b++) {
                    if (b == 0) {
                        homeurl = urlhls[b];
                        continue;
                    }
                    hlslink += urlhls[b];
                }
                hlslbox.segment_urls.clear ();
                added = 0;
                var usefolder = option.has_key (AriaOptions.DIR.to_string ());
                if (usefolder) {
                    var pathdir = File.new_for_path (option.@get (AriaOptions.DIR.to_string ())).get_path ();
                    var fnamepath = File.new_build_filename (pathdir, row.filename.hash ().to_string ()).get_path ();
                    row.filepath = hlslbox.output_dir = fnamepath;
                } else {
                    var dir_dm = Environment.get_user_special_dir (GLib.UserDirectory.DOWNLOAD);
                    var opt_dir = File.new_build_filename (dir_dm, row.filename.hash ().to_string ());
                    row.filepath = hlslbox.output_dir = opt_dir.get_path ();
                }
                hlslbox.filename = fname;
                if (row.filename != finame) {
                    row.filename = hlslbox.filename = finame;
                }
                foreach (string ls in hlslink) {
                    string lines = ls.strip();
                    if (lines.length == 0 || lines.has_prefix("#")) {
                        continue;
                    }
                    string seg_url;
                    try {
                        seg_url = GLib.Uri.resolve_relative(homeurl, lines, GLib.UriFlags.NONE);
                    } catch (GLib.UriError e) {
                        continue;
                    }
                    if (!hlslbox.segment_urls.contains(seg_url)) {
                        hlslbox.segment_urls.add(seg_url);
                        added++;
                    }
                }
            });
            hlslbox.load_downloader ();
            hlslbox.simple_progress.connect ((progres)=> {
                row.labeltransfer = progres;
                row.fraction = hlslbox.progressmerg;
            });
            hlslbox.update_conn.connect ((act)=> {
                row.connectionsdl = act;
            });
            int updateinf = 0;
            hlslbox.bitfield_update.connect ((bitf, piece)=> {
                row.piececount = piece;
                row.bitfield = bitf;
                if (updateinf > (hlsmanbox.active_hlsrow * 3)) {
                    update_info ();
                    if (dbmenu) {
                        if (launcher_entry != null) {
                            launcher_entry.set_progress.begin (hlslbox.merged_ts? hlslbox.progressmerg : hlsmanbox.find_progress ());
                        }
                    }
                    updateinf = 0;
                }
                updateinf++;
            });
            row.start_button.clicked.connect (() => {
                if (row.linkmode == LinkMode.HLS) {
                    if (hlslbox.status == StatusMode.ACTIVE) {
                        hlslbox.on_stop_download ();
                    } else if (hlslbox.status == StatusMode.MERGE) {
                        hlslbox.merge_files ();
                    } else if (hlslbox.status == StatusMode.COMPLETE) {
                    } else if (hlslbox.status == StatusMode.WAIT) {
                        hlslbox.on_stop_download ();
                    } else {
                        hlsmanbox.hlsdlboxs.sort ((GLib.CompareDataFunc)sort_hls);
                        if (!hlsmanbox.processing) {
                            hlslbox.on_start_download ();
                            hlsmanbox.processing = true;
                            hlsmanbox.update_quee ();
                        } else {
                            hlslbox.on_wait_download ();
                        }
                    }
                }
            });
            var scroll = new Gtk.ScrolledWindow () {
                height_request = 150,
                overlay_scrolling = true,
                vexpand = true,
                child = hlslbox.hls_list_box
            };
            DownloaderHls downloaderhls = null;
            row.downloader_hls.connect (()=> {
                if (downloaderhls == null) {
                    downloaderhls = new DownloaderHls (hlslbox, scroll, row.filename) {
                        transient_for = this
                    };
                    downloaderhls.start_btn.clicked.connect (()=> {
                        if (hlslbox.status == StatusMode.PAUSED || hlslbox.status == StatusMode.ERROR) {
                            hlsmanbox.hlsdlboxs.sort ((GLib.CompareDataFunc)sort_hls);
                            if (!hlsmanbox.processing) {
                                hlslbox.on_start_download ();
                                hlsmanbox.processing = true;
                                hlsmanbox.update_quee ();
                            } else {
                                hlslbox.on_wait_download ();
                            }
                        } else {
                            hlslbox.on_stop_download ();
                        }
                    });
                    downloaderhls.show.connect (()=> {
                        if (menudbus != null) {
                            menudbus.delete_dbus (row.rowbus);
                        }
                    });
                    downloaderhls.close_request.connect (()=> {
                        if (menudbus != null) {
                            if (row.status == StatusMode.ACTIVE) {
                                menudbus.append_dbus (row.rowbus);
                            }
                        }
                        downloaderhls = null;
                        return false;
                    });
                    downloaderhls.show ();
                }
            });
            hlslbox.status = row.status;
            hlslbox.notify["status"].connect (()=> {
                row.status = hlslbox.status;
                if (hlslbox.status == StatusMode.COMPLETE) {
                    if (hlslbox.totalcomp >= hlslbox.segment_urls.size) {
                        try {
                            File.new_for_path (row.pathname).trash ();
                            row.totalsize = hlslbox.total_dl;
                            var pathname = hlslbox.mp4path;
                            if (pathname != null) {
                                row.filepath = row.pathname = pathname;
                            }
                            row.filename = hlslbox.filename;
                            update_download (row);
                        } catch (Error e) {
                            GLib.warning (e.message);
                        }
                    } else {
                        row.status = hlslbox.status = StatusMode.PAUSED;
                    }
                }
            });
            hlsmanbox.append_hlsbox (hlslbox);
            on_append (row);
            if (!later) {
                hlsmanbox.hlsdlboxs.sort ((GLib.CompareDataFunc)sort_hls);
                if (!hlsmanbox.processing) {
                    row.downloader_hls ();
                    hlslbox.on_start_download ();
                    row.status = StatusMode.ACTIVE;
                    hlsmanbox.processing = true;
                    hlsmanbox.update_quee ();
                } else {
                    hlslbox.on_wait_download ();
                    update_download (row);
                }
            } else {
                if (row.status != StatusMode.COMPLETE) {
                    hlslbox.on_stop_download ();
                }
            }
            hlsmanbox.active_hlsrow = hlsmanbox.find_active ();
            row.destroy.connect (()=> {
                hlsmanbox.remove_hlsbox (hlslbox);
                hlslbox.downloaders.clear ();
                hlslbox.segment_urls.clear ();
                hlslbox.files.clear ();
                scroll.destroy ();
                hlslbox.hls_list_box.remove_all ();
                hlslbox.hls_list_box.destroy ();
                hlslbox = null;
            });
        }

        private void on_append (DownloadRow row) {
            list_box.append (row);
            row.show ();
            row.notify["status"].connect (()=> {
                switch (row.status) {
                    case StatusMode.PAUSED:
                    case StatusMode.COMPLETE:
                    case StatusMode.MERGE:
                    case StatusMode.ERROR:
                        if (!starting && !stoping) {
                            if (row.linkmode != LinkMode.HLS) {
                                next_download ();
                            }
                        }
                        stop_launcher ();
                        if (menudbus != null) {
                            menudbus.delete_dbus (row.rowbus);
                        }
                        break;
                    case StatusMode.WAIT:
                    case StatusMode.NOTHING:
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
                list_box.remove (row);
                if (menudbus != null) {
                    menudbus.delete_dbus (row.rowbus);
                }
                stop_launcher ();
                view_status ();
            });
            row.update_agid.connect ((ariagid, newgid)=> update_agid (ariagid, newgid));
            if (list_box.get_selected_row () == null) {
                list_box.select_row (row);
            }
            list_box.set_sort_func ((Gtk.ListBoxSortFunc) sort_dm);
            update_info ();
            view_status ();
        }

        private void on_active (DownloadRow row) {
            if (menudbus != null) {
                if (!menudbus.dbus_contains (row.rowbus)) {
                    run_launcher ();
                    if (!active_downloader (row.ariagid)) {
                        menudbus.append_dbus (row.rowbus);
                    }
                }
            }
            if (limitcount >= allactive) {
                double fraction = (double) totalrecv / (double) totalfiles;
                if (fraction > 0.0) {
                    if (dbmenu) {
                        if (launcher_entry != null) {
                            launcher_entry.set_progress.begin (fraction);
                        }
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

        private void update_info () {
            var infol = aria_globalstat ();
            allactive = int.parse (infol[GlobalStat.NUMACTIVE]) + hlsmanbox.active_hlsrow;
            if (launcher_entry != null && allactive > 0) {
                launcher_entry.set_urgent.begin (true);
                launcher_entry.set_count.begin (allactive);
                launcher_entry.set_count_visible.begin (true);
                launcher_entry.set_progress_visible.begin (true);
            }
            download_rate.label = GLib.format_size (allactive > 0? (int64.parse (infol[GlobalStat.DOWNLOADSPEED]) + hlsmanbox.find_speed ()) : 0);
            upload_rate.label = GLib.format_size (allactive > 0? int64.parse (infol[GlobalStat.UPLOADSPEED]) : 0);
            labelact.label = allactive.to_string ();
            if (dbusindicator == null) {
                return;
            }
            if (!indmenu) {
                return;
            }
            if (starting || stoping || removing) {
                return;
            }
            if (allactive > 0) {
                switch (animation) {
                    case 1:
                        dbusindicator.set_icon_name ("com.github.gabutakut.gabutdm.seedloopy");
                        animation++;
                        break;
                    case 2:
                        dbusindicator.set_icon_name ("com.github.gabutakut.gabutdm.seedloopx");
                        animation++;
                        break;
                    case 3:
                        dbusindicator.set_icon_name ("com.github.gabutakut.gabutdm.seedloop");
                        animation = 0;
                        break;
                    default:
                        dbusindicator.set_icon_name ("com.github.gabutakut.gabutdm.seed");
                        animation++;
                        break;
                }
            } else {
                dbusindicator.set_icon_name ("com.github.gabutakut.gabutdm");
            }
            dbusindicator.new_icon ();
            if (_menulabel == 0) {
                dbusindicator.set_label ("");
            } else {
                int totalact = int.parse (infol[GlobalStat.NUMACTIVE]) + int.parse (infol[GlobalStat.NUMWAITING]) + hlsmanbox.find_waiting () + hlsmanbox.active_hlsrow;
                if (allactive > 0) {
                    if (_menulabel == 2) {
                        dbusindicator.set_label (GLib.format_size (allactive > 0? int64.parse (infol[GlobalStat.UPLOADSPEED]) + int64.parse (infol[GlobalStat.UPLOADSPEED]) + hlsmanbox.find_speed () : 0));
                    } else if (_menulabel == 1) {
                        dbusindicator.set_label (@"$(allactive.to_string ())/$(totalact)");
                    } else {
                        dbusindicator.set_label (@"$(allactive.to_string ())/$(totalact) " + GLib.format_size (allactive > 0? int64.parse (infol[GlobalStat.UPLOADSPEED]) + int64.parse (infol[GlobalStat.DOWNLOADSPEED]) + hlsmanbox.find_speed () : 0));
                    }
                } else {
                    dbusindicator.set_label (totalact > 0? "GabutDM" : "");
                }
            }
        }

        private void indicatorstatus () {
            if (dbusindicator != null) {
                dbusindicator.set_label (labelview.label);
                if (starting) {
                    dbusindicator.set_icon_name ("com.github.gabutakut.gabutdm.active");
                } else if (stoping) {
                    dbusindicator.set_icon_name ("com.github.gabutakut.gabutdm.pause");
                } else {
                    dbusindicator.set_icon_name ("com.github.gabutakut.gabutdm.clear");
                }
                dbusindicator.new_icon ();
            }
        }

        private bool get_exist (string url) {
            bool linkexist = false;
            var models = list_box.observe_children ();
            var maxsize = models.get_n_items ();
            for (uint x = 0; x < maxsize; x++) {
                var child = (Gtk.Widget) models.get_item (x);
                if (child is Gtk.ListBoxRow) {
                    var row = (DownloadRow) child;
                    if (row.url == url) {
                        linkexist = true;
                    }
                }
            }
            return linkexist;
        }

        public int beforest () {
            int count = 0;
            var models = list_box.observe_children ();
            var maxsize = models.get_n_items ();
            for (uint x = 0; x < maxsize; x++) {
                var child = (Gtk.Widget) models.get_item (x);
                if (child is Gtk.ListBoxRow) {
                    var row = (DownloadRow) child;
                    if (row.status == StatusMode.PAUSED) {
                        count++;
                    }
                }
            }
            return count;
        }

        private void start_all () {
            if (starting || stoping || removing) {
                return;
            }
            hlsmanbox.hlsdlboxs.sort ((GLib.CompareDataFunc)sort_hls);
            hlsmanbox.on_start_download ();
            int index = actwaiting ();
            int onstr = beforest ();
            int count = 0;
            int startdl = 0;
            int totalrow = count_rows_only ();
            GLib.Idle.add (() => {
                if (totalrow > 0) {
                    starting = true;
                    var row = (DownloadRow) list_box.get_row_at_index (count);
                    if (row.linkmode != LinkMode.HLS) {
                        if (row.status != StatusMode.COMPLETE && row.status != StatusMode.ERROR) {
                            if (row.status == StatusMode.PAUSED) {
                                aria_position (row.ariagid, index);
                                index++;
                                startdl++;
                                labelview.label = _("Starting… (%i of %i)").printf (startdl, onstr);
                                indicatorstatus ();
                                new Thread<void> ("startdl%d".printf (startdl), () => {
                                    aria_unpause (row.ariagid);
                                    MainContext.default ().invoke (() => {
                                        row.update_sts ();
                                        return GLib.Source.REMOVE;
                                    });
                                });
                            }
                        }
                    }
                    count++;
                } 
                if (totalrow == count) {
                    starting = false;
                    update_info ();
                    view_status ();
                }
                return starting;
            });
        }

        private void stop_all () {
            if (starting || stoping || removing) {
                return;
            }
            hlsmanbox.on_stop_download ();
            int index = 0;
            int count = 0;
            int acti = actwaiting ();
            int totalrow = count_rows_only ();
            GLib.Idle.add (() => {
                if (totalrow > 0) {
                    stoping = true;
                    var row = (DownloadRow) list_box.get_row_at_index (index);
                    if (row.linkmode != LinkMode.HLS) {
                        if (row.status != StatusMode.COMPLETE && row.status != StatusMode.ERROR) {
                            count++;
                            labelview.label = _("Stoping… (%i of %i)").printf (count, acti);
                            indicatorstatus ();
                            new Thread<void> ("stopdl%d".printf (count), () => {
                                aria_pause (row.ariagid);
                                if (row.status == StatusMode.WAIT) {
                                    MainContext.default ().invoke (() => {
                                        row.update_sts ();
                                        return GLib.Source.REMOVE;
                                    });
                                }
                            });
                        }
                    }
                    index++;
                }
                if (totalrow == index) {
                    stoping = false;
                    update_info ();
                    aria_pause_all ();
                    view_status ();
                }
                return stoping;
            });
        }

        public string set_selected (string ariagid, string selected) {
            string aria_gid = "";
            var models = list_box.observe_children ();
            var maxsize = models.get_n_items ();
            for (uint x = 0; x < maxsize; x++) {
                var child = (Gtk.Widget) models.get_item (x);
                if (child is Gtk.ListBoxRow) {
                    var row = (DownloadRow) child;
                    if (row.ariagid == ariagid) {
                        aria_gid = row.set_selected (selected);
                    }
                }
            }
            return aria_gid;
        }

        public void append_row (string ariagid) {
            var models = list_box.observe_children ();
            var maxsize = models.get_n_items ();
            for (uint x = 0; x < maxsize; x++) {
                var child = (Gtk.Widget) models.get_item (x);
                if (child is Gtk.ListBoxRow) {
                    var row = (DownloadRow) child;
                    if (row.ariagid == ariagid) {
                        if (row.status == StatusMode.ACTIVE) {
                            if (menudbus != null) {
                                menudbus.append_dbus (row.rowbus);
                            }
                        }
                    }
                }
            }
        }

        public void remove_row (string ariagid) {
            var models = list_box.observe_children ();
            var maxsize = models.get_n_items ();
            for (uint x = 0; x < maxsize; x++) {
                var child = (Gtk.Widget) models.get_item (x);
                if (child is Gtk.ListBoxRow) {
                    var row = (DownloadRow) child;
                    if (row.ariagid == ariagid) {
                        if (row.status == StatusMode.ACTIVE) {
                            if (menudbus != null) {
                                menudbus.delete_dbus (row.rowbus);
                            }
                        }
                    }
                }
            }
        }

        [CCode (instance_pos = -1)]
        private int sort_hls (HLSLBox row1, HLSLBox row2) {
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
                var total1 = row1.total_dl;
                var total2 = row2.total_dl;
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
                    labelview.label = index_rowdm.to_string ();
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
                    noerr_alert.show ();
                    list_box.set_placeholder (noerr_alert);
                    break;
                default:
                    bool hide_alert = false;
                    list_box.set_filter_func ((item)=> {
                        index_rowdm++;
                        if (item.get_child_visible ()) {
                            hide_alert = true;
                        }
                        return true;
                    });
                    if (!hide_alert) {
                        list_box.set_placeholder (nodown_alert);
                    }
                    break;
            }
            modeview.icon_name = view_mode.get_icon_name (view_mode.selected);
            labelview.label = index_rowdm.to_string ();
            list_box.set_sort_func ((Gtk.ListBoxSortFunc) sort_dm);
        }

        int count_rows_only () {
            int count = 0;
            var models = list_box.observe_children ();
            for (uint x = 0; x < models.get_n_items (); x++) {
                var child = (Gtk.Widget) models.get_item (x);
                if (child is Gtk.ListBoxRow) {
                    count++;
                }
            }
            return count;
        }
    }
}