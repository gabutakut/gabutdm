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
    public class GabutApp : Gtk.Application {
        public static GabutWindow gabutwindow = null;
        public static Sqlite.Database db;
        private Gtk.Clipboard clipboard;
        public GLib.List<Downloader> downloaders;
        public GLib.List<SuccesDialog> succesdls;
        private static Gtk.TargetEntry [] target_list;
        private bool startingup = false;

        public GabutApp () {
            Object (
                application_id: "com.github.gabutakut.gabutdm",
                flags: ApplicationFlags.HANDLES_COMMAND_LINE
            );
        }

        construct {
            Gtk.TargetEntry string_entry = { "STRING", 0, Target.STRING};
            Gtk.TargetEntry urilist_entry = { "text/uri-list", 0, Target.URILIST};
            target_list += string_entry;
            target_list += urilist_entry;
            GLib.OptionEntry [] options = new GLib.OptionEntry [3];
            options [0] = { "startingup", 0, 0, OptionArg.NONE, null, null, "Run App on Startup" };
            options [1] = { GLib.OPTION_REMAINING, 0, 0, OptionArg.FILENAME_ARRAY, null, null, "Open File or URIs" };
            options [2] = { null };
            add_main_option_entries (options);
        }

        public override int command_line (ApplicationCommandLine command) {
            var dict = command.get_options_dict ();
            if (dict.contains ("startingup") && gabutwindow == null) {
                startingup = true;
            }
            create_startup.begin ();
            activate ();
            if (dict.contains (GLib.OPTION_REMAINING)) {
                foreach (string arg_file in dict.lookup_value (GLib.OPTION_REMAINING, VariantType.BYTESTRING_ARRAY).get_bytestring_array ()) {
                    if (GLib.FileUtils.test (arg_file, GLib.FileTest.EXISTS)) {
                        dialog_url (File.new_for_path (arg_file).get_uri ());
                    } else {
                        dialog_url (arg_file);
                    }
                }
            }
            return Posix.EXIT_SUCCESS;
        }

        protected override void activate () {
            if (gabutwindow == null) {
                if (open_database (out db) != Sqlite.OK) {
                    notify_app (_("Database Error"),
                                _("Can't open database: %s\n").printf (db.errmsg ()), new ThemedIcon ("office-database"));
                }
                if (!bool.parse (get_dbsetting (DBSettings.STARTUP)) && startingup) {
                    return;
                }
                exec_aria ();
                if (!GLib.FileUtils.test (create_folder (".bootstrap.min.css"), GLib.FileTest.EXISTS)) {
                    get_css_online.begin ("https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css", create_folder (".bootstrap.min.css"));
                }
                var gabutserver = new GabutServer ();
                gabutserver.set_listent.begin (int.parse (get_dbsetting (DBSettings.PORTLOCAL)));
                gabutserver.send_post_data.connect (dialog_server);
                gabutwindow = new GabutWindow (this);
                Gtk.drag_dest_set (gabutwindow, Gtk.DestDefaults.ALL, target_list, Gdk.DragAction.COPY);
                gabutwindow.drag_data_received.connect (on_drag_data_received);
                if (!startingup) {
                    gabutwindow.show_all ();
                }
                gabutwindow.send_file.connect (dialog_url);
                gabutwindow.stop_server.connect (()=> {
                    gabutserver.stop_server ();
                });
                gabutwindow.get_host.connect ((reboot)=> {
                    if (reboot) {
                        gabutserver.stop_server ();
                        gabutserver.set_listent.begin (int.parse (get_dbsetting (DBSettings.PORTLOCAL)));
                    }
                    return gabutserver.get_address ();
                });
                gabutwindow.restart_server.connect (()=> {
                    gabutserver.stop_server ();
                    gabutserver.set_listent.begin (int.parse (get_dbsetting (DBSettings.PORTLOCAL)));
                });
                gabutserver.address_url.connect ((url, options, later, linkmode)=> {
                    gabutwindow.add_url_box (url, options, later, linkmode);
                });
                downloaders = new GLib.List<Downloader> ();
                succesdls = new GLib.List<SuccesDialog> ();
                var action_download = new SimpleAction ("downloader", VariantType.STRING);
                action_download.activate.connect ((parameter) => {
                    string aria_gid = parameter.get_string (null);
                    if (!dialog_active (aria_gid)) {
                        download (aria_gid);
                    }
                });
                add_action (action_download);
                var action_status = new SimpleAction ("status", VariantType.STRING);
                action_status.activate.connect ((parameter) => {
                    string aria_gid = parameter.get_string (null);
                    gabutwindow.fast_respond (aria_gid);
                });
                add_action (action_status);
                var action_succes = new SimpleAction ("succes", VariantType.STRING);
                action_succes.activate.connect ((parameter) => {
                    string succes = parameter.get_string (null);
                    if (!succes_active (succes)) {
                        dialog_succes (succes);
                    }
                });
                add_action (action_succes);
                var close_dialog = new SimpleAction ("destroy", VariantType.STRING);
                close_dialog.activate.connect ((parameter) => {
                    string aria_gid = parameter.get_string (null);
                    destroy_active (aria_gid);
                });
                add_action (close_dialog);
                gabutserver.get_dl_row.connect ((status)=> {
                    return gabutwindow.get_dl_row (status);
                });
                clipboard = Gtk.Clipboard.get (Gdk.SELECTION_CLIPBOARD);
                start ();
                perform_key_event ("<Control>v", true, 100);
                perform_key_event ("<Control>v", false, 0);
                check_table ();
                pantheon_theme.begin ();
            } else {
                if (startingup) {
                    gabutwindow.show_all ();
                    startingup = false;
                } else {
                    gabutwindow.present ();
                }
            }
        }

        private bool succes_active (string datastr) {
            bool active = false;
            succesdls.foreach ((succesdl)=> {
                if (succesdl.datastr.split ("<gabut>")[1] == datastr.split ("<gabut>")[1]) {
                    succesdl.present ();
                    active = true;
                }
            });
            return active;
        }

        private void destroy_active (string ariagid) {
            downloaders.foreach ((downloader)=> {
                if (downloader.ariagid == ariagid) {
                    downloaders.remove_link (downloaders.find (downloader));
                    remove_window (downloader);
                    downloader.destroy ();
                }
            });
        }

        public void dialog_succes (string strdata) {
            var succesdl = new SuccesDialog (this);
            succesdl.show_all ();
            succesdl.set_dialog (strdata);
            succesdls.append (succesdl);
            succesdl.destroy.connect (()=> {
                succesdls.foreach ((succes)=> {
                    if (succes == succesdl) {
                        succesdls.remove_link (succesdls.find (succes));
                        remove_window (succes);
                    }
                });
            });
        }

        public void dialog_server (MatchInfo match_info) {
            var addurl = new AddUrl (this);
            addurl.show_all ();
            addurl.server_link (match_info);
            addurl.downloadfile.connect ((url, options, later, linkmode)=> {
                gabutwindow.add_url_box (url, options, later, linkmode);
            });
            addurl.destroy.connect (()=> {
                textclip = null;
            });
        }

        public void dialog_url (string link) {
            string icon = "";
            if (link.has_prefix ("http://") || link.has_prefix ("https://") || link.has_prefix ("ftp://") || link.has_prefix ("sftp://")) {
                icon = "insert-link";
            } else if (link.has_prefix ("magnet:?")) {
                icon = "com.github.gabutakut.gabutdm.magnet";
                link.replace ("tr.N=", "tr=");
            } else if (link.has_suffix (".torrent")) {
                icon = "application-x-bittorrent";
            } else if (link.has_suffix (".metalink")) {
                icon = "com.github.gabutakut.gabutdm";
            } else if (link == "") {
                icon = "list-add";
            } else {
                return;
            }
            var addurl = new AddUrl (this);
            addurl.show_all ();
            addurl.add_link (link, icon);
            addurl.downloadfile.connect ((url, options, later, linkmode)=> {
                gabutwindow.add_url_box (url, options, later, linkmode);
            });
            addurl.destroy.connect (()=> {
                textclip = null;
            });
        }

        private bool dialog_active (string ariagid) {
            bool active = false;
            downloaders.foreach ((downloader)=> {
                if (downloader.ariagid == ariagid) {
                    downloader.present ();
                    active = true;
                }
            });
            return active;
        }

        private void download (string aria_gid) {
            var downloader = new Downloader (this);
            downloader.aria_gid (aria_gid);
            downloader.show_all ();
            downloaders.append (downloader);
            downloader.destroy.connect (()=> {
                downloaders.foreach ((download)=> {
                    if (download == downloader) {
                        downloaders.remove_link (downloaders.find (download));
                        remove_window (download);
                    }
                });
            });
            downloader.sendselected.connect ((ariagid, selected)=> {
                return gabutwindow.set_selected (ariagid, selected);
            });
        }

        public virtual void start () {
            clipboard.owner_change.connect (on_clipboard_event);
        }

        private string? textclip = null;
        private void on_clipboard_event (Gdk.EventOwnerChange event) {
            string? text = clipboard.wait_for_text ();
            bool available = (text != null && text != "") || clipboard.wait_is_text_available ();
            if (available) {
                if (event.reason == Gdk.OwnerChange.NEW_OWNER) {
                    if (text != null && text != "") {
                        string strstrip = text.strip ();
                        if (textclip != strstrip) {
                            dialog_url (strstrip);
                            textclip = strstrip;
                        }
                    }
                }
            }
        }

        private static void perform_key_event (string accelerator, bool press, ulong delay) {
            uint keysym;
            Gdk.ModifierType modifiers;
            Gtk.accelerator_parse (accelerator, out keysym, out modifiers);
            unowned X.Display display = Gdk.X11.get_default_xdisplay ();
            int keycode = display.keysym_to_keycode (keysym);
            if (keycode != 0) {
                if (Gdk.ModifierType.CONTROL_MASK in modifiers) {
                    int modcode = display.keysym_to_keycode (Gdk.Key.Control_L);
                    XTest.fake_key_event (display, modcode, press, delay);
                }
                if (Gdk.ModifierType.SHIFT_MASK in modifiers) {
                    int modcode = display.keysym_to_keycode (Gdk.Key.Shift_L);
                    XTest.fake_key_event (display, modcode, press, delay);
                }
                XTest.fake_key_event (display, keycode, press, delay);
            }
        }

        private void on_drag_data_received (Gtk.Widget widget, Gdk.DragContext drag_context, int x, int y, Gtk.SelectionData selection_data, uint target_type, uint time) {
            if ((selection_data == null) || !(selection_data.get_length () >= 0)) {
                return;
            }
            switch (target_type) {
                case Target.STRING:
                    dialog_url ((string) selection_data.get_data ());
                    break;
                case Target.URILIST:
                    foreach (var uri in selection_data.get_uris ()) {
                        dialog_url (uri);
                    };
                break;
            }
        }

        public static int main (string[] args) {
            var app = new GabutApp ();
            return app.run (args);
        }
    }
}
