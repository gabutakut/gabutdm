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
    public class GabutWindow : Hdy.ApplicationWindow {
        public signal void send_file (string url);
        public signal void stop_server ();
        public signal void restart_server ();
        public signal string get_host (bool reboot);
        private Gtk.ListBox list_box;
        private Gtk.Stack headerstack;
        private Gtk.Revealer property_rev;
        private Preferences preferences = null;
        private QrCode qrcode;
        private Gtk.SearchEntry search_entry;
        private ModeButton view_mode;
        private AlertView nodown_alert;
        private GLib.List<AddUrl> properties;
#if HAVE_DBUSMENU
        public Dbusmenu.Menuitem menudbus;
        public Dbusmenu.Menuitem openmenu;
        public Dbusmenu.Menuitem startmenu;
        public Dbusmenu.Menuitem pausemenu;
        public Dbusmenu.Server dbusserver;
#endif
        public GabutWindow (Gtk.Application application) {
            Object (application: application);
        }

        construct {
#if HAVE_DBUSMENU
            openmenu = new Dbusmenu.Menuitem ();
            openmenu.property_set (Dbusmenu.MENUITEM_PROP_LABEL, _("GabutDM"));
            openmenu.property_set (Dbusmenu.MENUITEM_PROP_ICON_NAME, "com.github.gabutakut.gabutdm");
            openmenu.property_set_bool (Dbusmenu.MENUITEM_PROP_VISIBLE, true);
            openmenu.item_activated.connect (()=> {
                present ();
            });

            startmenu = new Dbusmenu.Menuitem ();
            startmenu.property_set (Dbusmenu.MENUITEM_PROP_LABEL, _("Start All"));
            startmenu.property_set (Dbusmenu.MENUITEM_PROP_ICON_NAME, "media-playback-start");
            startmenu.property_set_bool (Dbusmenu.MENUITEM_PROP_VISIBLE, true);
            startmenu.item_activated.connect (start_all);

            pausemenu = new Dbusmenu.Menuitem ();
            pausemenu.property_set (Dbusmenu.MENUITEM_PROP_LABEL, _("Pause All"));
            pausemenu.property_set (Dbusmenu.MENUITEM_PROP_ICON_NAME, "media-playback-pause");
            pausemenu.property_set_bool (Dbusmenu.MENUITEM_PROP_VISIBLE, true);
            pausemenu.item_activated.connect (stop_all);

            menudbus = new Dbusmenu.Menuitem ();
            dbusserver = new Dbusmenu.Server (new UnityLauncherEntry ().objpath);
#endif
            nodown_alert = new AlertView (
                _("No File Download"),
                _("insert Link, open file or Drag and Drop Torrent, Metalink, Magnet URIs."),
                "com.github.gabutakut.gabutdm"
            );
            nodown_alert.show_all ();
            list_box = new Gtk.ListBox () {
                activate_on_single_click = true,
                selection_mode = Gtk.SelectionMode.BROWSE,
                expand = true
            };
            list_box.set_placeholder (nodown_alert);

            var scrolled = new Gtk.ScrolledWindow (null, null) {
                height_request = 350,
                width_request = 650,
                expand = true
            };
            scrolled.add (list_box);

            headerstack = new Gtk.Stack () {
                transition_type = Gtk.StackTransitionType.SLIDE_DOWN,
                transition_duration = 500,
                hhomogeneous = false
            };
            headerstack.add_named (mode_headerbar (), "mode");
            headerstack.add_named (saarch_headerbar (), "search");
            headerstack.visible_child_name = "mode";
            headerstack.show_all ();

            var frame_header = new Gtk.Grid () {
                orientation = Gtk.Orientation.VERTICAL,
                valign = Gtk.Align.START
            };
            frame_header.add (build_headerbar ());
            frame_header.add (headerstack);

            var mainwindow = new Gtk.Grid () {
                orientation = Gtk.Orientation.VERTICAL,
                expand = true
            };
            mainwindow.add (frame_header);
            mainwindow.add (scrolled);
            add (mainwindow);
            list_box.remove.connect ((wid)=> {
                view_status ();
            });
            Timeout.add (500, ()=> {
                bool statact = int.parse (aria_globalstat (GlobalStat.NUMACTIVE)) > 0;
                set_progress_visible.begin (!is_active && statact);
                set_badge_visible.begin (!is_active && statact);
                return true;
            });
            delete_event.connect (() => {
                if (bool.parse (get_dbsetting (DBSettings.ONBACKGROUND))) {
#if HAVE_DBUSMENU
                    append_dbus.begin (openmenu);
                    append_dbus.begin (startmenu);
                    append_dbus.begin (pausemenu);
                    menudbus.child_reorder (openmenu, 0);
                    menudbus.child_reorder (startmenu, 1);
                    menudbus.child_reorder (pausemenu, 2);
#endif
                    return hide_on_delete ();
                } else {
                    stop_server ();
                    return false;
                }
            });
        }

        private Hdy.HeaderBar build_headerbar () {
            var headerbar = new Hdy.HeaderBar () {
                title = _("Gabut Download Manager"),
                has_subtitle = false,
                show_close_button = true,
                interpolate_size = false,
                hexpand = true,
                decoration_layout = "close:maximize"
            };
            move_widget (headerbar);
            var menu_button = new Gtk.Button.from_icon_name ("open-menu", Gtk.IconSize.BUTTON) {
                tooltip_text = _("Open Settings")
            };
            headerbar.pack_end (menu_button);
            menu_button.clicked.connect (()=> {
                if (preferences == null && aria_getverion ()) {
                    preferences = new Preferences (application);
                    preferences.restart_server.connect (()=> {
                        restart_server ();
                    });
                    preferences.show_all ();
                    preferences.max_active.connect (()=> {
                        next_download ();
                    });
                    preferences.destroy.connect (()=> {
                        preferences = null;
                    });
                }
            });

            var search_button = new Gtk.Button.from_icon_name ("system-search", Gtk.IconSize.BUTTON) {
                tooltip_text = _("Search")
            };
            headerbar.pack_end (search_button);
            search_button.clicked.connect (()=> {
                ((Gtk.Image) search_button.image).icon_name = headerstack.visible_child_name == "mode"? "com.github.gabutakut.gabutdm" : "system-search";
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
            var host_button = new Gtk.Button.from_icon_name ("go-home", Gtk.IconSize.BUTTON) {
                tooltip_text = _("Host")
            };
            headerbar.pack_end (host_button);
            host_button.clicked.connect (()=> {
                if (qrcode == null) {
                    qrcode = new QrCode (application);
                    qrcode.show_all ();
                    qrcode.get_host.connect ((reboot)=> {
                        return get_host (reboot);
                    });
                    qrcode.destroy.connect (()=> {
                        qrcode = null;
                    });
                }
            });
            var property_button = new Gtk.Button.from_icon_name ("document-properties", Gtk.IconSize.BUTTON) {
                tooltip_text = _("Property")
            };
            properties = new GLib.List<AddUrl> ();
            property_button.clicked.connect (()=> {
                var row = (DownloadRow) list_box.get_selected_row ();
                if (row != null) {
                    if (!property_active (row)) {
                        var property = new AddUrl.Property (application);
                        property.show_all ();
                        properties.append (property);
                        property.property (row);
                        property.save_button.clicked.connect (()=> {
                            row = property.row;
                        });
                        property.destroy.connect (()=> {
                            properties.foreach ((proper)=> {
                                if (proper == property) {
                                    properties.remove_link (properties.find (proper));
                                }
                            });
                        });
                    }
                }
            });
            property_rev = new Gtk.Revealer () {
                transition_type = Gtk.RevealerTransitionType.CROSSFADE
            };
            property_rev.add (property_button);
            headerbar.pack_end (property_rev);
            list_box.row_selected.connect ((row)=> {
                property_rev.reveal_child = row != null? true : false;
            });
            var add_button = new Gtk.Button.from_icon_name ("insert-link", Gtk.IconSize.BUTTON) {
                tooltip_text = _("add link")
            };
            add_button.clicked.connect (()=> {
                send_file ("");
            });
            headerbar.pack_start (add_button);
            var torrentbutton = new Gtk.Button.from_icon_name ("document-open", Gtk.IconSize.BUTTON) {
                tooltip_text = _("Open .torrent .metalink file")
            };
            headerbar.pack_start (torrentbutton);
            torrentbutton.clicked.connect (()=> {
                var files = run_open_file (this, true);
                foreach (var file in files) {
                    send_file (file.get_uri ());
                }
            });
            var resumeall_button = new Gtk.Button.from_icon_name ("media-playback-start", Gtk.IconSize.BUTTON) {
                tooltip_text = _("Start All")
            };
            headerbar.pack_start (resumeall_button);
            resumeall_button.clicked.connect (start_all);

            var stopall_button = new Gtk.Button.from_icon_name ("media-playback-pause", Gtk.IconSize.BUTTON) {
                tooltip_text = _("Pause All")
            };
            headerbar.pack_start (stopall_button);
            stopall_button.clicked.connect (stop_all);

            var removeall_button = new Gtk.Button.from_icon_name ("edit-delete", Gtk.IconSize.BUTTON) {
                tooltip_text = _("Remove All")
            };
            headerbar.pack_start (removeall_button);
            removeall_button.clicked.connect (remove_all);
            return headerbar;
        }

        private bool property_active (DownloadRow row) {
            bool active = false;
            properties.foreach ((propet)=> {
                if (propet.row == row) {
                    propet.present ();
                    active = true;
                }
            });
            return active;
        }

        public override void destroy () {
            base.destroy ();
            var downloads = new GLib.List<DownloadRow> ();
            foreach (var row in list_box.get_children ()) {
                if (((DownloadRow) row).url == "") {
                    return;
                }
                if (!db_option_exist (((DownloadRow) row).url)) {
                    set_dboptions (((DownloadRow) row).url, ((DownloadRow) row).hashoption);
                } else {
                    update_optionts (((DownloadRow) row).url, ((DownloadRow) row).hashoption);
                }
                downloads.append ((DownloadRow) row);
            }
            set_download (downloads);
        }

        public GLib.List<string> get_dl_row (int status) {
            var strlist = new GLib.List<string> ();
            foreach (var row in list_box.get_children ()) {
                if (((DownloadRow) row).status == status) {
                    strlist.append (((DownloadRow) row).ariagid);
                }
            }
            return strlist;
        }

        private Hdy.HeaderBar mode_headerbar () {
            var headerbar = new Hdy.HeaderBar () {
                has_subtitle = false,
                show_close_button = false,
                hexpand = true
            };
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
            headerbar.set_custom_title (view_mode);
            view_mode.notify["selected"].connect (view_status);
            return headerbar;
        }

        private Hdy.HeaderBar saarch_headerbar () {
            var box_s = new Hdy.HeaderBar () {
                has_subtitle = false,
                show_close_button = false,
                hexpand = true
            };
            search_entry = new Gtk.SearchEntry () {
                placeholder_text = _("Find Here")
            };
            search_entry.search_changed.connect (view_status);
            box_s.set_custom_title (search_entry);
            return box_s;
        }

        private void next_download () {
            foreach (var row in list_box.get_children ()) {
                if (((DownloadRow) row).status == StatusMode.WAIT) {
                    aria_unpause (((DownloadRow) row).ariagid);
                    ((DownloadRow) row).update_progress ();
                }
            }
        }

        public void fast_respond (string ariagid) {
            foreach (var row in list_box.get_children ()) {
                if (((DownloadRow) row).ariagid == ariagid) {
                    ((DownloadRow) row).update_progress ();
                }
            }
        }

        public void remove_all () {
            foreach (var row in list_box.get_children ()) {
                ((DownloadRow) row).remove_down ();
            }
            aria_purge_all ();
        }

        private int openmode = StatusMode.NOTHING;
        private int openact = 0;
        public void load_dowanload () {
            get_download ().foreach ((row)=> {
                if (!get_exist (row.url)) {
                    list_box.add (row);
                    row.notify_property ("status");
                    row.notify["status"].connect (()=> {
                        switch (((DownloadRow) row).status) {
                            case StatusMode.PAUSED:
                                next_download ();
#if HAVE_DBUSMENU
                                remove_dbus.begin (((DownloadRow) row).rowbus);
#endif
                                break;
                            case StatusMode.COMPLETE:
                                next_download ();
#if HAVE_DBUSMENU
                                    remove_dbus.begin (((DownloadRow) row).rowbus);
#endif
                                break;
                            case StatusMode.WAIT:
                            case StatusMode.ERROR:
                            case StatusMode.NOTHING:
#if HAVE_DBUSMENU
                                    remove_dbus.begin (((DownloadRow) row).rowbus);
#endif
                                break;
                            case StatusMode.ACTIVE:
                                if (openmode == StatusMode.ACTIVE) {
                                    if (openact > int.parse (aria_globalstat (GlobalStat.NUMACTIVE))) {
                                        openact = 0;
                                        view_status ();
                                    }
                                    openact++;
#if HAVE_DBUSMENU
                                        append_dbus.begin (((DownloadRow) row).rowbus);
#endif
                                    return;
                                }
                                break;
                        }
                        openmode = ((DownloadRow) row).status;
                        view_status ();
                    });
                    row.destroy.connect (view_status);
                    if (list_box.get_selected_row () == null) {
                        list_box.select_row (row);
                        list_box.row_activated (row);
                    }
                }
            });
        }

        private int addmode = StatusMode.NOTHING;
        private int addact = 0;
        public void add_url_box (string url, Gee.HashMap<string, string> options, bool later, int linkmode) {
            if (get_exist (url)) {
                return;
            }
            var row = new DownloadRow.Url (url, options, later, linkmode);
            list_box.add (row);
            row.notify["status"].connect (()=> {
                switch (((DownloadRow) row).status) {
                    case StatusMode.PAUSED:
                        next_download ();
#if HAVE_DBUSMENU
                            remove_dbus.begin (((DownloadRow) row).rowbus);
#endif
                        break;
                    case StatusMode.COMPLETE:
                        next_download ();
#if HAVE_DBUSMENU
                            remove_dbus.begin (((DownloadRow) row).rowbus);
#endif
                        break;
                    case StatusMode.WAIT:
                    case StatusMode.ERROR:
                    case StatusMode.NOTHING:
#if HAVE_DBUSMENU
                            remove_dbus.begin (((DownloadRow) row).rowbus);
#endif
                        break;
                    case StatusMode.ACTIVE:
                        if (addmode == StatusMode.ACTIVE) {
                            if (addact > int.parse (aria_globalstat (GlobalStat.NUMACTIVE))) {
                                addact = 0;
                                view_status ();
                            }
                            addact++;
#if HAVE_DBUSMENU
                                append_dbus.begin (((DownloadRow) row).rowbus);
#endif
                            return;
                        }
                        break;
                }
                addmode = ((DownloadRow) row).status;
                view_status ();
            });
            row.destroy.connect (view_status);
            if (list_box.get_selected_row () == null) {
                list_box.select_row (row);
                list_box.row_activated (row);
            }
            if (!later) {
                row.download ();
            }
        }
#if HAVE_DBUSMENU
        private async void append_dbus (Dbusmenu.Menuitem rowbus) throws GLib.Error {
            var menuofdbus = menudbus.find_id (rowbus.get_id ());
            if (menuofdbus != rowbus && rowbus.property_get (Dbusmenu.MENUITEM_PROP_ICON_NAME) != null) {
                menudbus.child_append (rowbus);
                yield open_quicklist (dbusserver, menudbus);
            }
        }

        private async void remove_dbus (Dbusmenu.Menuitem rowbus) throws GLib.Error {
            if (menudbus.find_id (rowbus.get_id ()) == rowbus) {
                menudbus.child_delete (rowbus);
                yield open_quicklist (dbusserver, menudbus);
            }
        }
#endif
        public override void show () {
            base.show ();
#if HAVE_DBUSMENU
            remove_dbus.begin (openmenu);
            append_dbus.begin (startmenu);
            append_dbus.begin (pausemenu);
            menudbus.child_reorder (startmenu, 0);
            menudbus.child_reorder (pausemenu, 1);
#endif
        }

        private bool get_exist (string url) {
            bool linkexist = false;
            foreach (var row in list_box.get_children ()) {
                if (((DownloadRow) row).url == url) {
                    linkexist = true;
                }
            }
            return linkexist;
        }

        private void start_all () {
            foreach (var row in list_box.get_children ()) {
                if (((DownloadRow) row).status != StatusMode.COMPLETE && ((DownloadRow) row).status != StatusMode.ERROR) {
                    aria_unpause (((DownloadRow) row).ariagid);
                    ((DownloadRow) row).update_progress ();
                }
            }
            view_status ();
        }

        private void stop_all () {
            aria_pause_all ();
            foreach (var row in list_box.get_children ()) {
                if (((DownloadRow) row).status != StatusMode.COMPLETE && ((DownloadRow) row).status != StatusMode.ERROR) {
                    aria_pause (((DownloadRow) row).ariagid);
                    ((DownloadRow) row).update_progress ();
                }
            }
            view_status ();
        }

        public string set_selected (string ariagid, string selected) {
            string aria_gid = "";
            foreach (var row in list_box.get_children ()) {
                if (((DownloadRow) row).ariagid == ariagid) {
                    aria_gid = ((DownloadRow) row).set_selected (selected);
                }
            }
            return aria_gid;
        }

        public bool has_visible_children () {
            foreach (var child in list_box.get_children ()) {
                if (child.get_child_visible ()) {
                    return true;
                }
            }
            return false;
        }

        public void view_status () {
            set_badge.begin (int.parse (aria_globalstat (GlobalStat.NUMACTIVE)));
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
                    search_alert.show_all ();
                    list_box.set_placeholder (search_alert);
                    return;
                }
                list_box.set_filter_func ((item) => {
                    if (((DownloadRow) item).filename == null) {
                        return false;
                    }
                    return ((DownloadRow) item).filename.casefold ().contains (search_entry.text.casefold ());
                });
                if (!has_visible_children ()) {
                    var empty_alert = new AlertView (
                        _("No Search Found"),
                        _("insert Link, open file or Drag and Drop Torrent, Metalink, Magnet URIs."),
                        "system-search"
                    );
                    empty_alert.show_all ();
                    list_box.set_placeholder (empty_alert);
                } else {
                    list_box.set_placeholder (null);
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
                        _("insert Link, open file or Drag and Drop Torrent, Metalink, Magnet URIs."),
                        "com.github.gabutakut.gabutdm.active"
                    );
                    active_alert.show_all ();
                    list_box.set_placeholder (active_alert);
                    return;
                case 2:
                    list_box.set_filter_func ((item) => {
                        return ((DownloadRow) item).status == StatusMode.PAUSED;
                    });
                    var nopause_alert = new AlertView (
                        _("No Paused Download"),
                        _("insert Link, open file or Drag and Drop Torrent, Metalink, Magnet URIs."),
                        "com.github.gabutakut.gabutdm.pause"
                    );
                    nopause_alert.show_all ();
                    list_box.set_placeholder (nopause_alert);
                    return;
                case 3:
                    list_box.set_filter_func ((item) => {
                        return ((DownloadRow) item).status == StatusMode.COMPLETE;
                    });
                    var nocomp_alerst = new AlertView (
                        _("No Complete Download"),
                        _("insert Link, open file or Drag and Drop Torrent, Metalink, Magnet URIs."),
                        "com.github.gabutakut.gabutdm.complete"
                    );
                    nocomp_alerst.show_all ();
                    list_box.set_placeholder (nocomp_alerst);
                    return;
                case 4:
                    list_box.set_filter_func ((item) => {
                        return ((DownloadRow) item).status == StatusMode.WAIT;
                    });
                    var nowait_alert = new AlertView (
                        _("No Waiting Download"),
                        _("insert Link, open file or Drag and Drop Torrent, Metalink, Magnet URIs."),
                        "com.github.gabutakut.gabutdm.waiting"
                    );
                    nowait_alert.show_all ();
                    list_box.set_placeholder (nowait_alert);
                    return;
                case 5:
                    list_box.set_filter_func ((item) => {
                        return ((DownloadRow) item).status == StatusMode.ERROR;
                    });
                    var noerr_alert = new AlertView (
                        _("No Error Download"),
                        _("insert Link, open file or Drag and Drop Torrent, Metalink, Magnet URIs."),
                        "com.github.gabutakut.gabutdm.error"
                    );
                    noerr_alert.show_all ();
                    list_box.set_placeholder (noerr_alert);
                    return;
                default:
                    list_box.set_filter_func (null);
                    if (!has_visible_children ()) {
                        list_box.set_placeholder (nodown_alert);
                    }
                    break;
            }
        }
    }
}
