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
    public class GabutApp : Gtk.Application {
        public GabutWindow? gabutwindow = null;
        private SplashScreen? spalshsc = null;
        private Gdk.Clipboard clipboard;
        public GLib.List<Downloader> downloaders;
        public GLib.List<SuccesDialog> succesdls;
        public GLib.List<AddUrl> addurls;
        private string lastclipboard;

        public GabutApp () {
            Object(application_id: "com.github.gabutakut.gabutdm", flags: GLib.ApplicationFlags.HANDLES_COMMAND_LINE);
        }

        construct {
            engine = new Aria2.Engine();
            GLib.OptionEntry [] options = new GLib.OptionEntry [3];
            options [0] = { "startingup", 's', GLib.OptionFlags.NONE, GLib.OptionArg.NONE, null, "Starup", "Run App on Startup" };
            options [1] = { GLib.OPTION_REMAINING, 0, GLib.OptionFlags.NONE, GLib.OptionArg.STRING_ARRAY, null, "Array file", "Open File or URIs" };
            options [2] = { null };
            add_main_option_entries (options);
        }

        public override int command_line (GLib.ApplicationCommandLine command) {
            if (spalshsc == null && gabutwindow == null) {
                spalshsc = new SplashScreen (this);
                spalshsc.set_visible (true);
            }
            if (gabutdb == null) {
                if (open_database (out gabutdb) != Sqlite.OK) {
                    spalshsc.preparing.connect (()=> {
                        spalshsc.status_dm (_("Database Error…"));
                        play_sound ("dialog-warning");
                    });
                    return base.command_line (command);
                }
                settings_table ();
            }
            var dict = command.get_options_dict ();
            bool cremaint = dict.contains (GLib.OPTION_REMAINING);
            if (dict.contains ("startingup")) {
                var dbstartup = bool.parse (get_dbsetting (DBSettings.STARTUP));
                flatpack_autostart.begin (dbstartup);
                default_autostart.begin (dbstartup);
                if (!dbstartup) {
                    spalshsc.preparing.connect (()=> {
                        spalshsc.status_dm (_("Starting on startup disabled…"));
                        play_sound ("dialog-warning");
                    });
                    return base.command_line (command);
                }
            }
            if (gabutwindow == null) {
                start_engine.begin ();
                var gabutserver = new GabutServer ();
                gabutserver.set_listent.begin (int.parse (get_dbsetting (DBSettings.PORTLOCAL)));
                gabutserver.send_post_data.connect (dialog_server);
                gabutwindow = new GabutWindow ();
                add_window (gabutwindow);

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
                    foreach (var download in downloaders) {
                        if (download.ariagid == ariagid) {
                            download.ariagid = newgid;
                            download.get_active_status ();
                            break;
                        }
                    }
                });
                gabutserver.address_url.connect (gabutwindow.add_url_box);
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
                gabutserver.get_dm_row.connect ((ariagid)=> {
                    return gabutwindow.get_dm_row (ariagid);
                });
                gabutserver.get_hls_row.connect ((ariagid)=> {
                    return gabutwindow.get_hls_row (ariagid);
                });
                gabutserver.lserv_action.connect ((status)=> {
                    gabutwindow.lserv_action (status);
                });
                gabutserver.delete_row.connect ((status)=> {
                    gabutwindow.remove_item (status);
                });
                gdm_theme ();
                download_table ();
                spalshsc.preparing.connect (()=> {
                    spalshsc.simulate_loading (gabutwindow);
                });
                spalshsc.close_request.connect (()=> {
                    play_sound ("device-added");
                    if (!dict.contains ("startingup") && !cremaint) {
                        open_now ();
                    }
                    spalshsc = null;
                    if (cremaint) {
                        open_dict (string.joinv ("\n", dict.lookup_value (GLib.OPTION_REMAINING, GLib.VariantType.STRING_ARRAY).get_strv ()), _("Try to Open"));
                    }
                    return GLib.Source.REMOVE;
                });
                menuglobal ();
                lastclipboard = get_dbsetting (Gabut.DBSettings.LASTCLIPBOARD);
                clipboard = gabutwindow.titlebar.get_clipboard ();
                Timeout.add_seconds (1, on_clipboard);
                gabutwindow.close_request.connect (()=> {
                    if (!bool.parse (get_dbsetting (DBSettings.ONBACKGROUND))) {
                        if (spalshsc == null && gabutwindow != null) {
                            spalshsc = new SplashScreen (this);
                            spalshsc.status_text = "Preparing…";
                            spalshsc.set_visible (true);
                            spalshsc.preparing.connect (()=> {
                                spalshsc.save_all_download (gabutwindow);
                            });
                            spalshsc.close_request.connect (()=> {
                                play_sound ("device-removed");
                                return GLib.Source.REMOVE;
                            });
                        }
                    }
                    return GLib.Source.REMOVE;
                });
            } else {
                if (dict.contains ("startingup") || cremaint) {
                    if (cremaint) {
                        open_dict (string.joinv ("\n", dict.lookup_value (GLib.OPTION_REMAINING, GLib.VariantType.STRING_ARRAY).get_strv ()), _("Try to Open"));
                    }
                    return base.command_line (command);
                }
                open_now ();
            }
            return base.command_line (command);
        }

        private void open_dict (string dict, string title) {
            if (spalshsc == null) {
                spalshsc = new SplashScreen (this) {
                    is_processing = true,
                    title_text = title
                };
                spalshsc.status_text = "Opening…";
                spalshsc.set_visible (true);
                spalshsc.preparing.connect (()=> {
                    spalshsc.prosessing_files (dict);
                });
                spalshsc.open_files.connect ((urlist)=> {
                    if (urlist.contains ("\n")) {
                        var uris = urlist.split ("\n");
                        int x = 0;
                        var lent = uris.length;
                        GLib.Timeout.add (250, () => {
                            var uri = uris[x].strip ();
                            dialog_url (uri);
                            x++;
                            return x < lent;
                        });
                    } else {
                        dialog_url (urlist);
                    }
                });
                spalshsc.close_request.connect (()=> {
                    play_sound ("device-removed");
                    spalshsc = null;
                    return GLib.Source.REMOVE;
                });
            }
        }

        private void open_now () {
            if (!gabutwindow.is_visible ()) {
                gabutwindow.set_visible (true);
            }
        }

        private void destroy_active (string ariagid) {
            foreach (var downloader in downloaders) {
                if (downloader.ariagid == ariagid) {
                    downloaders.delete_link (downloaders.find (downloader));
                    remove_window (downloader);
                    downloader.close ();
                    downloader = null;
                    break;
                }
            }
        }

        private bool succes_active (string datastr) {
            bool active = false;
                foreach (var succesdl in succesdls) {
                if (succesdl.datastr == datastr) {
                    succesdl.present ();
                    active = true;
                    break;
                }
            }
            return active;
        }

        public void dialog_succes (string strdata) {
            var succesdl = new SuccesDialog (strdata) {
                transient_for = gabutwindow
            };
            succesdls.append (succesdl);
            succesdl.close_request.connect (()=> {
                foreach (var succes in succesdls) {
                    if (succes == succesdl) {
                        succesdls.delete_link (succesdls.find (succes));
                        remove_window (succes);
                        succesdl = null;
                        break;
                    }
                }
                return GLib.Source.REMOVE;
            });
            succesdl.set_visible (true);
        }

        public void dialog_server (MatchInfo match_info) {
            var urls = match_info.fetch (PostServer.URL);
            if (url_active (urls)) {
                return;
            }
            if (is_hls (urls)) {
                var addhls = new AddHls () {
                    transient_for = gabutwindow,
                    portserver = match_info
                };
                addhls.downloadfile.connect (gabutwindow.add_url_box);
                    addhls.close_request.connect (()=> {
                    addhls = null;
                    return GLib.Source.REMOVE;
                });
                addhls.set_visible (true);
                return;
            }
            var addurl = new AddUrl () {
                transient_for = gabutwindow,
                portserver = match_info
            };
            addurls.append (addurl);
            addurl.downloadfile.connect (gabutwindow.add_url_box);
            addurl.close_request.connect (()=> {
                foreach (var addur in addurls) {
                    if (addur == addurl) {
                        addurls.delete_link (addurls.find (addur));
                        remove_window (addur);
                        addurl = null;
                        break;
                    }
                }
                return GLib.Source.REMOVE;
            });
            addurl.set_visible (true);
        }

        public void dialog_url (string link) {
            if (is_url (link)) {
                if (is_hls (link)) {
                    var addhls = new AddHls () {
                        transient_for = gabutwindow,
                        url_link = link.strip ()
                    };
                    addhls.downloadfile.connect (gabutwindow.add_url_box);
                    addhls.set_visible (true);
                } else {
                    if (link.has_prefix ("magnet:?")) {
                        link.replace ("tr.N=", "tr=");
                    }
                    var addurl = new AddUrl () {
                        transient_for = gabutwindow,
                        url_link = link.strip (),
                        url_icon = link.has_prefix ("magnet:?")? "com.github.gabutakut.gabutdm.magnet" : "com.github.gabutakut.gabutdm.insertlink"
                    };
                    addurls.append (addurl);
                    addurl.downloadfile.connect (gabutwindow.add_url_box);
                    addurl.close_request.connect (()=> {
                        foreach (var addur in addurls) {
                            if (addur == addurl) {
                                addurls.delete_link (addurls.find (addur));
                                remove_window (addur);
                                addurl = null;
                                break;
                            }
                        }
                        return GLib.Source.REMOVE;
                    });
                    addurl.set_visible (true);
                }
            } else if (link.has_suffix (".torrent") || link.has_suffix (".metalink")) {
                if (GLib.FileUtils.test (link, GLib.FileTest.EXISTS)) {
                    var addtrr = new AddTorrent () {
                        transient_for = gabutwindow
                    };
                    addtrr.load_torrent (link);
                    addtrr.downloadfile.connect (gabutwindow.add_url_box);
                    addtrr.close_request.connect (()=> {
                        addtrr = null;
                        return GLib.Source.REMOVE;
                    });
                    addtrr.set_visible (true);
                }
            }
        }

        private bool url_active (string url) {
            bool active = false;
            foreach (var urls in addurls) {
                if (urls.url_link == url) {
                    active = true;
                    break;
                }
            }
            return active;
        }

        private bool download_active (string ariagid) {
            bool active = false;
            foreach (var downloader in downloaders) {
                if (downloader.ariagid == ariagid) {
                    downloader.get_active_status ();
                    active = true;
                    break;
                }
            }
            return active;
        }

        private void download (string aria_gid) {
            var downloader = new Downloader ()  {
                transient_for = gabutwindow,
                ariagid = aria_gid
            };
            downloaders.append (downloader);
            downloader.show.connect (()=> {
                gabutwindow.remove_row (downloader.ariagid);
            });
            downloader.close_request.connect (()=> {
                foreach (var download in downloaders) {
                    if (download == downloader) {
                        gabutwindow.append_row (downloader.ariagid);
                        downloaders.delete_link (downloaders.find (download));
                        downloader = null;
                        break;
                    }
                }
                return GLib.Source.REMOVE;
            });
            downloader.sendselected.connect ((ariagid, selected)=> {
                return gabutwindow.set_selected (ariagid, selected);
            });
            downloader.actions_button.connect ((ariagid, status)=> {
                return gabutwindow.server_action (ariagid, status);
            });
            downloader.set_visible (true);
        }

        private bool on_clipboard () {
            if (cliboardmenu) {
                if (clipboard.formats.contain_gtype (GLib.Type.STRING)) {
                    clipboard.read_text_async.begin (null, (obj, res)=> {
                        try {
                            string? textclip = clipboard.read_text_async.end (res);
                            if (textclip != null && textclip != lastclipboard) {
                                if (!url_active (textclip)) {
                                    if (is_url (textclip) || textclip.has_suffix (".torrent") || textclip.has_suffix (".metalink")) {
                                        lastclipboard = set_dbsetting (Gabut.DBSettings.LASTCLIPBOARD, textclip);
                                        open_dict (textclip, _("Clipboard Processing"));
                                    }
                                }
                            }
                        } catch (GLib.Error e) {
                            critical (e.message);
                        }
                    });
                }
            }
            return GLib.Source.CONTINUE;
        }

        public static int main (string[] args) {
            var app = new GabutApp ();
            return app.run (args);
        }
    }
}