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
    public class GabutWindow : Gtk.ApplicationWindow {
        public signal bool send_file (string url);
        public signal void stop_server ();
        public signal void restart_server ();
        public signal void open_show ();
        public signal bool active_downloader (string ariagid);
        public signal void update_agid (string ariagid, string newgid);
        public signal string get_host ();
        private Gtk.ListBox list_box;
        private Gtk.Label labelall;
        private Gtk.Stack headerstack;
        private Preferences preferences;
        private QrCode qrcode;
        private Gtk.SearchEntry search_entry;
        private ModeButton view_mode;
        private AlertView nodown_alert;
        private GLib.List<AddUrl> properties;
        private Gee.ArrayList<DownloadRow> listrow;
        private DbusmenuItem menudbus;
        private DbusmenuItem openmenu;
        private CanonicalDbusmenu dbusserver;
        private DbusIndicator dbusindicator;
        private Gtk.MenuButton shortbutton;
        private Gtk.FlowBox sort_flow;
        private Gtk.FlowBox deas_flow;
        private Gtk.CheckButton showtime;
        private Gtk.CheckButton showdate;

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

        DeAscending _deascend = null;
        DeAscending deascend {
            get {
                return _deascend;
            }
            set {
                _deascend = value;
                set_dbsetting (DBSettings.ASCEDESCEN, _deascend.get_index ().to_string ());
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
                if (indmenu) {
                    if (_menulabel == 0) {
                        dbusindicator.updateLabel = "";
                    } else if (_menulabel == 1) {
                        dbusindicator.updateLabel = title;
                    } else {
                        update_info ();
                    }
                    dbusindicator.x_ayatana_new_label (dbusindicator.updateLabel, "");
                }
            }
        }

        public GabutWindow (Gtk.Application application) {
            Object (application: application,
                    hide_on_close: bool.parse (get_dbsetting (DBSettings.ONBACKGROUND)),
                    title: _("Gabut Download Manager")
            );
        }

        construct {
            dbmenu = bool.parse (get_dbsetting (DBSettings.DBUSMENU));
            indmenu = bool.parse (get_dbsetting (DBSettings.MENUINDICATOR));
            dbusserver = new CanonicalDbusmenu ();
            dbusindicator = new DbusIndicator (dbusserver.dbus_object);
            if (indmenu) {
                dbusindicator.register_dbus.begin ();
            }
            openmenu = new DbusmenuItem ();
            openmenu.property_set (MenuItem.LABEL.to_string (), _("Gabut Download Manager"));
            openmenu.property_set (MenuItem.ICON_NAME.to_string (), "com.github.gabutakut.gabutdm");
            openmenu.property_set_bool (MenuItem.VISIBLE.to_string (), true);
            openmenu.item_activated.connect (()=> {
                open_show ();
            });

            var urlmenu = new DbusmenuItem ();
            urlmenu.property_set (MenuItem.LABEL.to_string (), _("Add Url"));
            urlmenu.property_set (MenuItem.ICON_NAME.to_string (), "insert-link");
            urlmenu.property_set_bool (MenuItem.VISIBLE.to_string (), true);
            urlmenu.item_activated.connect (()=> {
                send_file ("");
            });

            var opentormenu = new DbusmenuItem ();
            opentormenu.property_set (MenuItem.LABEL.to_string (), _("Open Torrent"));
            opentormenu.property_set (MenuItem.ICON_NAME.to_string (), "document-open");
            opentormenu.property_set_bool (MenuItem.VISIBLE.to_string (), true);
            opentormenu.item_activated.connect (()=> {
                var files = run_open_file (this);
                foreach (var file in files) {
                    send_file (file.get_uri ());
                }
            });

            var setmenu = new DbusmenuItem ();
            setmenu.property_set (MenuItem.LABEL.to_string (), _("Open Settings"));
            setmenu.property_set (MenuItem.ICON_NAME.to_string (), "open-menu");
            setmenu.property_set_bool (MenuItem.VISIBLE.to_string (), true);
            setmenu.item_activated.connect (menuprefernces);

            var startmenu = new DbusmenuItem ();
            startmenu.property_set (MenuItem.LABEL.to_string (), _("Start All"));
            startmenu.property_set (MenuItem.ICON_NAME.to_string (), "media-playback-start");
            startmenu.property_set_bool (MenuItem.VISIBLE.to_string (), true);
            startmenu.item_activated.connect (start_all);

            var pausemenu = new DbusmenuItem ();
            pausemenu.property_set (MenuItem.LABEL.to_string (), _("Pause All"));
            pausemenu.property_set (MenuItem.ICON_NAME.to_string (), "media-playback-pause");
            pausemenu.property_set_bool (MenuItem.VISIBLE.to_string (), true);
            pausemenu.item_activated.connect (stop_all);

            var qrmenu = new DbusmenuItem ();
            qrmenu.property_set (MenuItem.LABEL.to_string (), _("Remote"));
            qrmenu.property_set (MenuItem.ICON_NAME.to_string (), "go-home");
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
            listrow.sort (sort_dm);
            list_box = new Gtk.ListBox () {
                activate_on_single_click = true,
                selection_mode = Gtk.SelectionMode.BROWSE
            };
            list_box.set_sort_func ((Gtk.ListBoxSortFunc) sort_dm);
            list_box.set_placeholder (nodown_alert);

            var scrolled = new Gtk.ScrolledWindow () {
                height_request = 350,
                width_request = 650,
                vexpand = true,
                child = list_box
            };

            headerstack = new Gtk.Stack () {
                transition_type = Gtk.StackTransitionType.SLIDE_UP,
                transition_duration = 500,
                hhomogeneous = false
            };
            headerstack.add_named (bottom_action (), "mode");
            headerstack.add_named (saarch_headerbar (), "search");
            headerstack.visible_child_name = "mode";
            headerstack.show ();

            labelall = new Gtk.Label ("Active: 0 Download: 0 Upload: 0") {
                ellipsize = Pango.EllipsizeMode.END,
                hexpand = true,
                margin_top = 4,
                margin_bottom = 4,
                attributes = set_attribute (Pango.Weight.SEMIBOLD)
            };

            var mainwindow = new Gtk.Grid ();
            mainwindow.attach (labelall, 0, 0);
            mainwindow.attach (scrolled, 0, 1);
            mainwindow.attach (headerstack, 0, 2);
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
        }

        private Gtk.HeaderBar build_headerbar () {
            var headerbar = new Gtk.HeaderBar () {
                hexpand = true,
                decoration_layout = "close:minimize,maximize"
            };
            var menu_button = new Gtk.Button.from_icon_name ("open-menu") {
                tooltip_text = _("Open Settings")
            };
            headerbar.pack_end (menu_button);
            menu_button.clicked.connect (menuprefernces);

            var search_button = new Gtk.Button.from_icon_name ("system-search") {
                tooltip_text = _("Search")
            };
            headerbar.pack_end (search_button);
            search_button.clicked.connect (()=> {
                search_button.icon_name = headerstack.visible_child_name == "mode"? "com.github.gabutakut.gabutdm" : "system-search";
                headerstack.visible_child_name = headerstack.visible_child_name == "mode"? headerstack.visible_child_name = "search" : headerstack.visible_child_name = "mode";
                var row = (DownloadRow) list_box.get_selected_row ();
                if (row != null) {
                    list_box.unselect_row (row);
                }
            });
            headerstack.notify["visible-child"].connect (()=> {
                view_status ();
                search_entry.text = "";
            });
            var host_button = new Gtk.Button.from_icon_name ("go-home") {
                tooltip_text = _("Remote")
            };
            headerbar.pack_end (host_button);
            host_button.clicked.connect (qrmenuopen);
            var add_button = new Gtk.Button.from_icon_name ("insert-link") {
                tooltip_text = _("add link")
            };
            add_button.clicked.connect (()=> {
                send_file ("");
            });
            headerbar.pack_start (add_button);
            var torrentbutton = new Gtk.Button.from_icon_name ("document-open") {
                tooltip_text = _("Open .torrent .metalink file")
            };
            headerbar.pack_start (torrentbutton);
            torrentbutton.clicked.connect (()=> {
                var files = run_open_file (this);
                foreach (var file in files) {
                    send_file (file.get_uri ());
                }
            });
            var resumeall_button = new Gtk.Button.from_icon_name ("media-playback-start") {
                tooltip_text = _("Start All")
            };
            headerbar.pack_start (resumeall_button);
            resumeall_button.clicked.connect (start_all);

            var stopall_button = new Gtk.Button.from_icon_name ("media-playback-pause") {
                tooltip_text = _("Pause All")
            };
            headerbar.pack_start (stopall_button);
            stopall_button.clicked.connect (stop_all);

            var removeall_button = new Gtk.Button.from_icon_name ("edit-delete") {
                tooltip_text = _("Remove All")
            };
            headerbar.pack_start (removeall_button);
            removeall_button.clicked.connect (remove_all);
            return headerbar;
        }

        private void qrmenuopen () {
            if (qrcode == null) {
                qrcode = new QrCode (application) {
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
                preferences = new Preferences (application) {
                    transient_for = this
                };
                preferences.restart_server.connect (()=> {
                    restart_server ();
                });
                preferences.restart_process.connect (()=> {
                    listrow.foreach ((row)=> {
                        row.if_not_exist (row.ariagid, row.linkmode, row.status);
                        return true;
                    });
                });
                preferences.max_active.connect (()=> {
                    next_download ();
                });
                preferences.global_opt.connect (()=> {
                    update_options ();
                });
                preferences.close.connect (()=> {
                    if (bool.parse (get_dbsetting (DBSettings.ONBACKGROUND)) != hide_on_close) {
                        hide_on_close = bool.parse (get_dbsetting (DBSettings.ONBACKGROUND));
                    }
                    if (bool.parse (get_dbsetting (DBSettings.DBUSMENU)) != dbmenu) {
                        dbmenu = bool.parse (get_dbsetting (DBSettings.DBUSMENU));
                    }
                    menulabel = int.parse (get_dbsetting (DBSettings.LABELMODE));
                    preferences = null;
                });
                preferences.close_request.connect (()=> {
                    if (bool.parse (get_dbsetting (DBSettings.ONBACKGROUND)) != hide_on_close) {
                        hide_on_close = bool.parse (get_dbsetting (DBSettings.ONBACKGROUND));
                    }
                    if (bool.parse (get_dbsetting (DBSettings.DBUSMENU)) != dbmenu) {
                        dbmenu = bool.parse (get_dbsetting (DBSettings.DBUSMENU));
                    }
                    menulabel = int.parse (get_dbsetting (DBSettings.LABELMODE));
                    preferences = null;
                    return false;
                });
                preferences.show ();
            }
        }

        private Gtk.CenterBox bottom_action () {
            var actionbar = new Gtk.CenterBox () {
                hexpand = true,
                margin_top = 4,
                margin_bottom = 4
            };
            var property_button = new Gtk.MenuButton () {
                child = image_btn ("format-justify-center", 16),
                direction = Gtk.ArrowType.UP,
                margin_start = 10,
                tooltip_text = _("Property")
            };
            properties = new GLib.List<AddUrl> ();
            actionbar.set_start_widget (property_button);
            list_box.row_selected.connect ((rw)=> {
                if (rw != null) {
                    var row = (DownloadRow) rw;
                    property_button.popover = row.get_menu ();
                    row.myproperty.connect (()=> {
                        if (!property_active (row)) {
                            var property = new AddUrl.Property (application) {
                                transient_for = this,
                                row = row
                            };
                            properties.append (property);
                            property.save_button.clicked.connect (()=> {
                                row = property.row;
                            });
                            property.close.connect (()=> {
                                properties.foreach ((proper)=> {
                                    if (proper == property) {
                                        properties.delete_link (properties.find (proper));
                                    }
                                });
                            });
                            property.close_request.connect (()=> {
                                properties.foreach ((proper)=> {
                                    if (proper == property) {
                                        properties.delete_link (properties.find (proper));
                                    }
                                });
                                return false;
                            });
                            property.update_agid.connect ((ariagid, newgid)=> {
                                update_agid (ariagid, newgid);
                            });
                            property.show ();
                        }
                    });
                } else {
                    property_button.popover = null;
                }
            });
            view_mode = new ModeButton () {
                hexpand = false
            };
            view_mode.append_text (_("All"));
            view_mode.append_text (_("Downloading"));
            view_mode.append_text (_("Paused"));
            view_mode.append_text (_("Complete"));
            view_mode.append_text (_("Waiting"));
            view_mode.append_text (_("Error"));
            view_mode.selected = 0;
            actionbar.set_center_widget (view_mode);
            view_mode.notify["selected"].connect (view_status);
            shortbutton = new Gtk.MenuButton () {
                direction = Gtk.ArrowType.UP,
                child = image_btn ("format-justify-fill", 16),
                margin_end = 10,
                popover = get_menu (),
                tooltip_text = _("Sort by")
            };
            actionbar.set_end_widget (shortbutton);
            return actionbar;
        }

        public Gtk.Popover get_menu () {
            sort_flow = new Gtk.FlowBox () {
                orientation = Gtk.Orientation.HORIZONTAL,
                width_request = 70,
                margin_top = 4,
                margin_bottom = 4
            };
            deas_flow = new Gtk.FlowBox () {
                orientation = Gtk.Orientation.HORIZONTAL,
                width_request = 70
            };
            showtime = new Gtk.CheckButton.with_label (_("Time")) {
                margin_start = 6,
                margin_top = 4,
                margin_bottom = 4,
                margin_end = 4,
                active = bool.parse (get_dbsetting (DBSettings.SHOWTIME))
            };
            ((Gtk.Label) showtime.get_last_child ()).attributes = set_attribute (Pango.Weight.BOLD);
            ((Gtk.Label) showtime.get_last_child ()).halign = Gtk.Align.CENTER;
            ((Gtk.Label) showtime.get_last_child ()).wrap_mode = Pango.WrapMode.WORD_CHAR;
            showdate = new Gtk.CheckButton.with_label (_("Date")) {
                margin_start = 6,
                margin_top = 4,
                margin_bottom = 4,
                margin_end = 4,
                active = bool.parse (get_dbsetting (DBSettings.SHOWDATE))
            };
            ((Gtk.Label) showdate.get_last_child ()).attributes = set_attribute (Pango.Weight.BOLD);
            ((Gtk.Label) showdate.get_last_child ()).halign = Gtk.Align.CENTER;
            ((Gtk.Label) showdate.get_last_child ()).wrap_mode = Pango.WrapMode.WORD_CHAR;
            var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0) {
                margin_top = 4,
                margin_bottom = 4
            };
            box.append (sort_flow);
            box.append (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
            box.append (deas_flow);
            box.append (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
            box.append (showtime);
            box.append (showdate);
            var sort_popover = new Gtk.Popover () {
                position = Gtk.PositionType.TOP,
                width_request = 70,
                child = box
            };
            sort_popover.show.connect (() => {
                if (sorttype != null) {
                    sort_flow.select_child (sorttype);
                    sorttype.grab_focus ();
                }
                if (deascend != null) {
                    deas_flow.unselect_child (deascend);
                }
            });
            showdate.toggled.connect (()=> {
                sort_popover.hide ();
                set_dbsetting (DBSettings.SHOWDATE, showdate.active.to_string ());
                set_listheader ();
            });
            showtime.toggled.connect (()=> {
                sort_popover.hide ();
                set_dbsetting (DBSettings.SHOWTIME, showtime.active.to_string ());
                set_listheader ();
            });
            set_listheader ();
            foreach (var shorty in SortbyWindow.get_all ()) {
                sort_flow.append (new SortBy (shorty));
            }
            sort_flow.show ();
            sort_flow.child_activated.connect ((shorty)=> {
                sort_popover.hide ();
                sorttype = shorty as SortBy;
                list_box.set_sort_func ((Gtk.ListBoxSortFunc) sort_dm);
                listrow.sort (sort_dm);
            });
            sorttype = sort_flow.get_child_at_index (int.parse (get_dbsetting (DBSettings.SORTBY))) as SortBy;
            foreach (var deas in DeAscend.get_all ()) {
                deas_flow.append (new DeAscending (deas));
            }
            deas_flow.show ();
            deas_flow.child_activated.connect ((deas)=> {
                sort_popover.hide ();
                deascend = deas as DeAscending;
                for (int i = 0; i <= DeAscend.DESCENDING; i++) {
                    ((DeAscending) deas_flow.get_child_at_index (i)).activebtn = false;    
                }
                ((DeAscending) deas_flow.get_child_at_index (deascend.get_index ())).activebtn = true;
                list_box.set_sort_func ((Gtk.ListBoxSortFunc) sort_dm);
                listrow.sort (sort_dm);
            });
            deascend = deas_flow.get_child_at_index (int.parse (get_dbsetting (DBSettings.ASCEDESCEN))) as DeAscending;
            ((DeAscending) deas_flow.get_child_at_index (deascend.get_index ())).activebtn = true;
            return sort_popover;
        }

        private void set_listheader () {
            if (showtime.active || showdate.active) {
                list_box.set_header_func ((Gtk.ListBoxUpdateHeaderFunc) header_dm);
            } else {
                list_box.set_header_func (null);
            }
        }

        private Gtk.Box saarch_headerbar () {
            var headerbar = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                hexpand = true,
                margin_top = 4,
                margin_bottom = 4,
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            search_entry = new Gtk.SearchEntry () {
                placeholder_text = _("Find Here")
            };
            search_entry.search_changed.connect (view_status);
            headerbar.append (search_entry);
            return headerbar;
        }

        public override void show () {
            base.show ();
            menulabel = int.parse (get_dbsetting (DBSettings.LABELMODE));
            remove_dbus.begin (openmenu);
        }

        private bool set_menulauncher () {
            if (dbmenu) {
                var globalactive = int64.parse (aria_globalstat (GlobalStat.NUMACTIVE));
                bool statact = globalactive > 0;
                set_count_visible.begin (globalactive);
                if (!statact) {
                    int stoped = 3;
                    Timeout.add (500, ()=> {
                        set_progress_visible.begin (0.0, false);
                        set_count_visible.begin (globalactive);
                        if (indmenu) {
                            update_info ();
                            dbusindicator.updateiconame = "com.github.gabutakut.gabutdm";
                            dbusindicator.new_icon ();
                        }
                        stoped--;
                        return stoped != 0;
                    });
                }
                if (timeout_id != 0) {
                    Source.remove (timeout_id);
                    timeout_id = 0;
                }
                if (rmtimeout_id != 0) {
                    Source.remove (rmtimeout_id);
                    rmtimeout_id = 0;
                }
                if (indmenu) {
                    dbusindicator.updateiconame = "com.github.gabutakut.gabutdm.seed";
                    dbusindicator.new_icon ();
                }
            }
            return false;
        }

        private uint timeout_id = 0;
        private void run_launcher () {
            if (timeout_id == 0) {
                timeout_id = Timeout.add (500, set_menulauncher);
            }
        }

        private uint rmtimeout_id = 0;
        private void stop_launcher () {
            if (rmtimeout_id == 0) {
                rmtimeout_id = Timeout.add (500, set_menulauncher);
            }
        }

        private bool property_active (DownloadRow row) {
            bool active = false;
            properties.foreach ((propet)=> {
                if (propet.row == row) {
                    active = true;
                }
            });
            return active;
        }

        public void save_all_download () {
            var downloads = new GLib.List<DownloadRow> ();
            listrow.foreach ((row)=> {
                if (row.url == "") {
                    return true;
                }
                if (!db_option_exist (row.url)) {
                    set_dboptions (row.url, row.hashoption);
                } else {
                    update_optionts (row.url, row.hashoption);
                }
                downloads.append (row);
                return true;
            });
            set_download (downloads);
        }

        public Gee.ArrayList<DownloadRow> get_dl_row (int status) {
            var rowlist = new Gee.ArrayList<DownloadRow> ();
            listrow.foreach ((row)=> {
                if (row.status == status) {
                    rowlist.add (row);
                }
                return true;
            });
            return rowlist;
        }

        private void update_options () {
            listrow.foreach ((row)=> {
                if (row.status != StatusMode.COMPLETE && row.status != StatusMode.ERROR) {
                    glob_to_opt (row.ariagid);
                }
                return true;
            });
        }

        private void next_download () {
            listrow.foreach ((row)=> {
                if (row.status == StatusMode.WAIT) {
                    row.update_progress ();
                }
                return true;
            });
        }

        public string server_action (string ariagid, int status = 2) {
            var agid = ariagid;
            listrow.foreach ((row)=> {
                if (row.ariagid == ariagid) {
                    agid = row.action_btn (status);
                }
                return true;
            });
            return agid;
        }

        public void remove_item (string ariagid) {
            listrow.foreach ((row)=> {
                if (row.ariagid == ariagid) {
                    row.remove_down ();
                }
                return true;
            });
        }

        public void remove_all () {
            int total = listrow.size;
            for (int i = 0; i < total; i++) {
                listrow.get (0).remove_down ();
            }
            aria_purge_all ();
        }

        public void load_dowanload () {
            get_download ().foreach ((row)=> {
                if (!get_exist (row.url)) {
                    list_box.append (row);
                    listrow.add (row);
                    row.show ();
                    row.notify_property ("status");
                    row.notify["status"].connect (()=> {
                        switch (row.status) {
                            case StatusMode.PAUSED:
                            case StatusMode.COMPLETE:
                            case StatusMode.ERROR:
                                next_download ();
                                stop_launcher ();
                                remove_dbus.begin (row.rowbus);
                                break;
                            case StatusMode.WAIT:
                            case StatusMode.NOTHING:
                                remove_dbus.begin (row.rowbus);
                                break;
                            case StatusMode.ACTIVE:
                                if (!menudbus.get_exist (row.rowbus)) {
                                    run_launcher ();
                                    if (!active_downloader (row.ariagid)) {
                                        append_dbus.begin (row.rowbus);
                                    }
                                    view_status ();
                                }
                                if (dbmenu) {
                                    row.fraction_laucher ();
                                }
                                update_info ();
                                return;
                        }
                        view_status ();
                        update_info ();
                    });
                    if (list_box.get_selected_row () == null) {
                        list_box.select_row (row);
                        list_box.row_activated (row);
                    }
                    row.destroy.connect (()=> {
                        list_box.remove (row);
                        remove_dbus.begin (row.rowbus);
                        next_download ();
                        view_status ();
                        listrow.remove (row);
                        stop_launcher ();
                    });
                    row.update_agid.connect ((ariagid, newgid)=> {
                        update_agid (ariagid, newgid);
                    });
                    row.activedm.connect (activedm);
                }
            });
            listrow.sort (sort_dm);
        }

        public void add_url_box (string url, Gee.HashMap<string, string> options, bool later, int linkmode) {
            if (get_exist (url)) {
                return;
            }
            var row = new DownloadRow.Url (url, options, linkmode, activedm ()) {
                timeadded = new GLib.DateTime.now_local ().to_unix ()
            };
            list_box.append (row);
            listrow.add (row);
            row.show ();
            row.notify["status"].connect (()=> {
                switch (row.status) {
                    case StatusMode.PAUSED:
                    case StatusMode.COMPLETE:
                    case StatusMode.ERROR:
                        next_download ();
                        stop_launcher ();
                        remove_dbus.begin (row.rowbus);
                        break;
                    case StatusMode.WAIT:
                    case StatusMode.NOTHING:
                        remove_dbus.begin (row.rowbus);
                        break;
                    case StatusMode.ACTIVE:
                        if (!menudbus.get_exist (row.rowbus)) {
                            run_launcher ();
                            if (!active_downloader (row.ariagid)) {
                                append_dbus.begin (row.rowbus);
                            }
                            view_status ();
                        }
                        if (dbmenu) {
                            row.fraction_laucher ();
                        }
                        update_info ();
                        return;
                }
                view_status ();
                update_info ();
            });
            row.destroy.connect (()=> {
                list_box.remove (row);
                remove_dbus.begin (row.rowbus);
                next_download ();
                view_status ();
                listrow.remove (row);
                stop_launcher ();
            });
            row.update_agid.connect ((ariagid, newgid)=> {
                update_agid (ariagid, newgid);
            });
            row.activedm.connect (activedm);
            if (list_box.get_selected_row () == null) {
                list_box.select_row (row);
                list_box.row_activated (row);
            }
            if (!later) {
                row.download ();
                row.start_notif ();
            } else {
                aria_pause (row.ariagid);
            }
            listrow.sort (sort_dm);
        }

        public int activedm () {
            int count = 0;
            listrow.foreach ((row)=> {
                if (row.status == StatusMode.ACTIVE || row.status == StatusMode.WAIT) {
                    count++;
                }
                return true;
            });
            return count;
        }

        private void update_info () {
            var infol = aria_label_info ();
            var activedmapp = int64.parse (infol.fetch (2));
            labelall.label = @"Active: $(activedmapp) Download: $(GLib.format_size (activedmapp > 0? int64.parse (infol.fetch (1)) : 0)) Upload: $(GLib.format_size (activedmapp > 0? int64.parse (infol.fetch (6)) : 0))";
            if (menulabel == 2 && indmenu) {
                dbusindicator.updateLabel = @" $(GLib.format_size (activedmapp > 0? int64.parse (infol.fetch (1)) : 0))";
                dbusindicator.x_ayatana_new_label (dbusindicator.updateLabel, "");
            }
        }

        private bool get_exist (string url) {
            bool linkexist = false;
            listrow.foreach ((row)=> {
                if (row.url == url) {
                    linkexist = true;
                }
                return true;
            });
            return linkexist;
        }

        private void start_all () {
            listrow.foreach ((row)=> {
                if (row.status != StatusMode.COMPLETE && row.status != StatusMode.ERROR) {
                    aria_position (row.ariagid, listrow.index_of (row));
                    aria_unpause (row.ariagid);
                    row.update_progress ();
                }
                return true;
            });
            view_status ();
        }

        private void stop_all () {
            listrow.foreach ((row)=> {
                if (row.status != StatusMode.COMPLETE && row.status != StatusMode.ERROR) {
                    aria_pause (row.ariagid);
                    row.idle_progress ();
                }
                return true;
            });
            aria_pause_all ();
            view_status ();
        }

        public string set_selected (string ariagid, string selected) {
            string aria_gid = "";
            listrow.foreach ((row)=> {
                if (row.ariagid == ariagid) {
                    aria_gid = row.set_selected (selected);
                }
                return true;
            });
            return aria_gid;
        }

        public void append_row (string ariagid) {
            listrow.foreach ((row)=> {
                if (row.ariagid == ariagid) {
                    if (row.status == StatusMode.ACTIVE) {
                        append_dbus.begin (row.rowbus);
                    }
                }
                return true;
            });
        }

        public void remove_row (string ariagid) {
            listrow.foreach ((row)=> {
                if (row.ariagid == ariagid) {
                    if (row.status == StatusMode.ACTIVE) {
                        remove_dbus.begin (row.rowbus);
                    }
                }
                return true;
            });
        }

        private async void append_dbus (DbusmenuItem rowbus) throws GLib.Error {
            if (!menudbus.get_exist (rowbus)) {
                menudbus.child_append (rowbus);
            }
            if (dbmenu) {
                open_quicklist_dbus.begin (dbusserver, menudbus);
            }
        }

        private async void remove_dbus (DbusmenuItem rowbus) throws GLib.Error {
            if (menudbus.get_exist (rowbus)) {
                menudbus.child_delete (rowbus);
            }
            if (dbmenu) {
                open_quicklist_dbus.begin (dbusserver, menudbus);
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
                    if (formdate != new GLib.DateTime.from_unix_local (row2.timeadded).format (@"%A - %I:%M %p - %d %B %Y")) {
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
            if (headerstack.visible_child_name == "search") {
                if (search_entry.text.strip () == "") {
                    list_box.set_filter_func ((item) => {
                        return false;
                    });
                    var search_alert = new AlertView (
                        _("Find File"),
                        _("Mode Search Based on Filename."),
                        "system-search"
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
                    return ((DownloadRow) item).filename.casefold ().contains (search_entry.text.casefold ());
                });
                if (!item_visible) {
                    var empty_alert = new AlertView (
                        _("No Search Found"),
                        _("Drag and Drop URL, Torrent, Metalink, Magnet URIs."),
                        "system-search"
                    );
                    empty_alert.show ();
                    list_box.set_placeholder (empty_alert);
                }
                return;
            }
            switch (view_mode.selected) {
                case 1:
                    list_box.set_filter_func ((item) => {
                        return ((DownloadRow) item).status == StatusMode.ACTIVE;
                    });
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
            list_box.set_sort_func ((Gtk.ListBoxSortFunc) sort_dm);
            listrow.sort (sort_dm);
        }
    }
}
