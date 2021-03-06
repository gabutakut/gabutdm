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
        public GabutWindow gabutwindow = null;
        private Gdk.Clipboard clipboard;
        public GLib.List<Downloader> downloaders;
        public GLib.List<SuccesDialog> succesdls;
        public GLib.List<AddUrl> addurls;
        private bool startingup = false;
        private bool dontopen = false;

        public GabutApp () {
            Object (
                application_id: "com.github.gabutakut.gabutdm",
                flags: ApplicationFlags.HANDLES_COMMAND_LINE
            );
        }

        construct {
            GLib.OptionEntry [] options = new GLib.OptionEntry [3];
            options [0] = { "startingup", 's', 0, GLib.OptionArg.NONE, null, null, "Run App on Startup" };
            options [1] = { GLib.OPTION_REMAINING, 0, 0, GLib.OptionArg.STRING_ARRAY, null, null, "Open File or URIs" };
            options [2] = { null };
            add_main_option_entries (options);
        }

        public override int command_line (ApplicationCommandLine command) {
            var dict = command.get_options_dict ();
            if (dict.contains ("startingup") && gabutwindow == null) {
                startingup = true;
            }
            if (dict.contains (GLib.OPTION_REMAINING)) {
                foreach (string arg_file in dict.lookup_value (GLib.OPTION_REMAINING, VariantType.STRING_ARRAY).get_strv ()) {
                    if (GLib.FileUtils.test (arg_file, GLib.FileTest.EXISTS)) {
                        dialog_url (File.new_for_path (arg_file).get_uri ());
                    } else {
                        dialog_url (arg_file);
                    }
                }
                if (gabutwindow != null) {
                    return Posix.EXIT_SUCCESS;
                } else {
                    dontopen = true;
                }
            }
            activate ();
            return Posix.EXIT_SUCCESS;
        }

        protected override void activate () {
            if (gabutwindow == null) {
                if (open_database (out gabutdb) != Sqlite.OK) {
                    notify_app (_("Database Error"),
                                _("Can't open database: %s\n").printf (gabutdb.errmsg ()), new ThemedIcon ("office-database"));
                }
                settings_table ();
                if (!bool.parse (get_dbsetting (DBSettings.STARTUP)) && startingup) {
                    return;
                }
                exec_aria ();
                if (!GLib.FileUtils.test (file_config (".bootstrap.min.css"), GLib.FileTest.EXISTS)) {
                    var loop = new GLib.MainLoop (null, false);
                    boot_strap.begin (()=> {
                        loop.quit ();
                    });
                    loop.run ();
                }
                if (!GLib.FileUtils.test (file_config (".dropzone.min.js"), GLib.FileTest.EXISTS)) {
                    var loop = new GLib.MainLoop (null, false);
                    drop_zone.begin (()=> {
                        loop.quit ();
                    });
                    loop.run ();
                }
                if (!GLib.FileUtils.test (file_config (".dropzone.min.css"), GLib.FileTest.EXISTS)) {
                    var loop = new GLib.MainLoop (null, false);
                    drop_zonemin.begin (()=> {
                        loop.quit ();
                    });
                    loop.run ();
                }
                var gabutserver = new GabutServer ();
                gabutserver.set_listent.begin (int.parse (get_dbsetting (DBSettings.PORTLOCAL)));
                gabutserver.send_post_data.connect (dialog_server);
                gabutwindow = new GabutWindow (this);

                var droptarget = new Gtk.DropTarget (Type.STRING, Gdk.DragAction.COPY);
                gabutwindow.child.add_controller (droptarget);
                droptarget.accept.connect (on_drag_data_received);

                gabutwindow.send_file.connect (dialog_url);
                gabutwindow.open_show.connect (open_now);
                gabutwindow.stop_server.connect (()=> {
                    gabutserver.stop_server ();
                });
                gabutwindow.active_downloader.connect ((ariagid)=> {
                    return download_active (ariagid);
                });
                gabutwindow.get_host.connect (()=> {
                    return gabutserver.get_address ();
                });
                gabutwindow.restart_server.connect (()=> {
                    gabutserver.stop_server ();
                    gabutserver.set_listent.begin (int.parse (get_dbsetting (DBSettings.PORTLOCAL)));
                });
                gabutwindow.update_agid.connect ((ariagid, newgid)=> {
                    downloaders.foreach ((downloader)=> {
                        if (downloader.ariagid == ariagid) {
                            downloader.ariagid = newgid;
                            downloader.get_active_status ();
                        }
                    });
                });
                gabutserver.address_url.connect ((url, options, later, linkmode)=> {
                    gabutwindow.add_url_box (url, options, later, linkmode);
                });
                downloaders = new GLib.List<Downloader> ();
                succesdls = new GLib.List<SuccesDialog> ();
                addurls = new GLib.List<AddUrl> ();
                var action_download = new SimpleAction ("downloader", VariantType.STRING);
                action_download.activate.connect ((parameter) => {
                    string aria_gid = parameter.get_string (null);
                    if (!download_active (aria_gid)) {
                        download (aria_gid);
                    }
                });
                add_action (action_download);
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
                    destroy_active (parameter.get_string (null));
                });
                add_action (close_dialog);
                gabutserver.get_dl_row.connect ((status)=> {
                    return gabutwindow.get_dl_row (status);
                });
                gabutserver.updat_row.connect ((status)=> {
                    gabutwindow.server_action (status);
                });
                gabutserver.delete_row.connect ((status)=> {
                    gabutwindow.remove_item (status);
                });
                clipboard = gabutwindow.get_display ().get_clipboard ();
                clipboard.changed.connect (on_clipboard);
                pantheon_theme.begin ();
                gabutwindow.load_dowanload ();
                download_table ();
                if (!startingup && !dontopen) {
                    gabutwindow.show ();
                }
            } else {
                open_now ();
            }
        }

        private void open_now () {
            if (startingup) {
                gabutwindow.show ();
                startingup = false;
            } else {
                gabutwindow.present ();
            }
        }

        private void destroy_active (string ariagid) {
            downloaders.foreach ((downloader)=> {
                if (downloader.ariagid == ariagid) {
                    downloaders.delete_link (downloaders.find (downloader));
                    remove_window (downloader);
                    downloader.close ();
                }
            });
        }

        private bool succes_active (string datastr) {
            bool active = false;
            succesdls.foreach ((succesdl)=> {
                if (succesdl.datastr == datastr) {
                    succesdl.present ();
                    active = true;
                }
            });
            return active;
        }

        public void dialog_succes (string strdata) {
            var succesdl = new SuccesDialog (this);
            succesdl.set_transient_for (gabutwindow);
            succesdl.set_dialog (strdata);
            succesdl.show ();
            succesdls.append (succesdl);
            succesdl.close.connect (()=> {
                succesdls.foreach ((succes)=> {
                    if (succes == succesdl) {
                        succesdls.delete_link (succesdls.find (succes));
                        remove_window (succes);
                    }
                });
            });
            succesdl.close_request.connect (()=> {
                succesdls.foreach ((succes)=> {
                    if (succes == succesdl) {
                        succesdls.delete_link (succesdls.find (succes));
                        remove_window (succes);
                    }
                });
                return false;
            });
        }

        public void dialog_server (MatchInfo match_info) {
            if (url_active (match_info.fetch (PostServer.URL))) {
                return;
            }
            var addurl = new AddUrl (this);
            addurl.set_transient_for (gabutwindow);
            addurl.server_link (match_info);
            addurl.show ();
            addurls.append (addurl);
            addurl.downloadfile.connect ((url, options, later, linkmode)=> {
                gabutwindow.add_url_box (url, options, later, linkmode);
            });
            addurl.close.connect (()=> {
                addurls.foreach ((addur)=> {
                    if (addur == addurl) {
                        addurls.delete_link (addurls.find (addur));
                        remove_window (addur);
                    }
                });
            });
            addurl.close_request.connect (()=> {
                addurls.foreach ((addur)=> {
                    if (addur == addurl) {
                        addurls.delete_link (addurls.find (addur));
                        remove_window (addur);
                    }
                });
                return false;
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
            var addurl = new AddUrl (this) {
                transient_for = gabutwindow
            };
            addurl.add_link (link, icon);
            addurl.show ();
            addurls.append (addurl);
            addurl.downloadfile.connect ((url, options, later, linkmode)=> {
                gabutwindow.add_url_box (url, options, later, linkmode);
            });
            addurl.close.connect (()=> {
                addurls.foreach ((addur)=> {
                    if (addur == addurl) {
                        addurls.delete_link (addurls.find (addur));
                        remove_window (addur);
                    }
                });
            });
            addurl.close_request.connect (()=> {
                addurls.foreach ((addur)=> {
                    if (addur == addurl) {
                        addurls.delete_link (addurls.find (addur));
                        remove_window (addur);
                    }
                });
                return false;
            });
        }

        private bool url_active (string url) {
            bool active = false;
            addurls.foreach ((urls)=> {
                if (urls.get_link () == url) {
                    active = true;
                }
            });
            return active;
        }

        private bool download_active (string ariagid) {
            bool active = false;
            downloaders.foreach ((downloader)=> {
                if (downloader.ariagid == ariagid) {
                    downloader.get_active_status ();
                    active = true;
                }
            });
            return active;
        }

        private void download (string aria_gid) {
            var downloader = new Downloader (this);
            downloader.set_transient_for (gabutwindow);
            downloader.aria_gid (aria_gid);
            downloaders.append (downloader);
            downloader.show.connect (()=> {
                gabutwindow.remove_row (downloader.ariagid);
            });
            downloader.show ();
            downloader.close.connect (()=> {
                downloaders.foreach ((download)=> {
                    if (download == downloader) {
                        download.remove_timeout ();
                        gabutwindow.append_row (downloader.ariagid);
                        downloaders.delete_link (downloaders.find (download));
                    }
                });
            });
            downloader.close_request.connect (()=> {
                downloaders.foreach ((download)=> {
                    if (download == downloader) {
                        download.remove_timeout ();
                        gabutwindow.append_row (downloader.ariagid);
                        downloaders.delete_link (downloaders.find (download));
                    }
                });
                return false;
            });
            downloader.sendselected.connect ((ariagid, selected)=> {
                return gabutwindow.set_selected (ariagid, selected);
            });
            downloader.actions_button.connect ((ariagid, status)=> {
                return gabutwindow.server_action (ariagid, status);
            });
        }

        private void on_clipboard () {
            if (!bool.parse (get_dbsetting (DBSettings.CLIPBOARD))) {
                return;
            }
            if (clipboard.formats.contain_gtype (GLib.Type.STRING)) {
                get_clipboard.begin ((obj, res)=> {
                    try {
                        string textclip;
                        get_clipboard.end (res, out textclip);
                        if (textclip != null && textclip != "") {
                            if (!url_active (textclip.strip ())) {
                                dialog_url (textclip.strip ());
                            }
                        }
                    } catch (GLib.Error e) {
                        critical (e.message);
                    }
                });
            }
        }

        private async void get_clipboard (out string? valu) throws Error {
            valu = yield clipboard.read_text_async (null);
        }

        private bool on_drag_data_received (Gdk.Drop drop) {
            drag_value.begin (drop, (obj, res)=> {
                try {
                    GLib.Value value;
                    drag_value.end (res, out value);
                    if (value.get_string ().contains ("\n")) {
                        foreach (string url in value.get_string ().strip ().split ("\n")) {
                            if (!url_active (url.strip ())) {
                                dialog_url (url.strip ());
                            }
                        }
                    } else {
                        if (!url_active (value.get_string ().strip ())) {
                            dialog_url (value.get_string ().strip ());
                        }
                    }
                } catch (GLib.Error e) {
                    critical (e.message);
                }
            });
            return Gdk.EVENT_PROPAGATE;
        }

        private async void drag_value (Gdk.Drop drop, out Value? valu) throws Error {
            valu = yield drop.read_value_async (GLib.Type.STRING, GLib.Priority.DEFAULT, null);
        }

        public static int main (string[] args) {
            var app = new GabutApp ();
            return app.run (args);
        }
    }
}
