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
    public class GabutServer : Soup.Server {
        public signal void send_post_data (MatchInfo match_info);
        public signal void address_url (string url, Gee.HashMap<string, string> options, bool later, int linkmode);
        public signal void address_port (string address);
        public signal GLib.List<string> get_dl_row (int status);
        private SourceFunc callback;

        public async void set_listent (int port) throws Error {
            callback = set_listent.callback;
            this.add_handler ("/", home_handler);
            this.add_handler ("/Upload", upload_handler);
            this.add_handler ("/Downloading", gabut_handler);
            this.add_handler ("/Paused", gabut_handler);
            this.add_handler ("/Complete", gabut_handler);
            this.add_handler ("/Waiting", gabut_handler);
            this.add_handler ("/Error", gabut_handler);
            if (!bool.parse (get_dbsetting (DBSettings.IPLOCAL))) {
                this.listen_all (port, Soup.ServerListenOptions.IPV4_ONLY);
            } else {
                this.listen_local (port, Soup.ServerListenOptions.IPV4_ONLY);
            }
            yield;
        }

        public void stop_server () {
            if (callback != null) {
                Idle.add ((owned)callback);
            }
            disconnect ();
        }

        private void upload_handler (Soup.Server server, Soup.Message msg, string path, GLib.HashTable? query, Soup.ClientContext client) {
            unowned GabutServer self = server as GabutServer;
            Idle.add (()=> {
                var upload = new ServerUpload ();
                msg.set_response ("text/html", Soup.MemoryUse.COPY, upload.get_upload ().data);
                self.unpause_message (msg);
                return false;
            });
            self.pause_message (msg);
            if (msg.method == "POST") {
                try {
                    if (msg.request_headers.get_content_type (null) == "multipart/form-data") {
                        var multipart = new Soup.Multipart.from_message (msg.request_headers , msg.request_body);
                        Soup.MessageHeaders headers;
                        unowned Soup.Buffer body;
                        multipart.get_part (0, out headers, out body);
                        GLib.HashTable<string, string> params;
                        headers.get_content_disposition (null, out params);
                        string filename = params.get ("filename");
                        if (filename != null && filename != "") {
                            File filed = File.new_for_path (aria_get_globalops (AriaOptions.DIR).replace ("\\/", "/") + "/" + filename);
                            if (!filed.query_exists ()) {
                                FileOutputStream out_stream = filed.create (FileCreateFlags.REPLACE_DESTINATION);
                                out_stream.write (body.get_as_bytes ().get_data ());
                                notify_app (_("File Transfered"), _("%s").printf (filename));
                            } else {
                                notify_app (_("File Exist"), _("%s").printf (filename));
                            }
                        }
                    }
                    msg.set_status_full (200, "OK");
                } catch (Error e) {
                    notify_app (_("Error Make"), _("%s").printf (e.message));
                    GLib.warning (e.message);
                }
            } else if (msg.method == "GET") {
                msg.set_status_full (200, "OK");
            }
        }

        private void home_handler (Soup.Server server, Soup.Message msg, string path, GLib.HashTable? query, Soup.ClientContext client) {
            unowned GabutServer self = server as GabutServer;
            Idle.add (() => {
                var serverhome = new ServerHome ();
                msg.set_response ("text/html", Soup.MemoryUse.COPY, serverhome.get_home ().data);
                self.unpause_message (msg);
                return false;
            });
            self.pause_message (msg);
            if (msg.method == "POST") {
                string result = (string) msg.request_body.data;
                try {
                    MatchInfo match_info;
                    Regex regex = new Regex ("link:(.*?),filename:(.*?),referrer:(.*?),mimetype:(.*?),filesize:(.*?),resumable:(.*?),");
                    bool matches = regex.match_full (result, -1, 0, 0, out match_info);
                    if (matches) {
                        msg.set_status_full (200, "OK");
                        send_post_data (match_info);
                    } else {
                        msg.set_status_full (500, "Error");
                    }
                } catch (Error e) {
                    GLib.warning (e.message);
                }
            } else if (msg.method == "GET") {
                msg.set_status_full (200, "OK");
            }
        }

        private void gabut_handler (Soup.Server server, Soup.Message msg, string path, GLib.HashTable? query, Soup.ClientContext client) {
            unowned GabutServer self = server as GabutServer;
            string pathname = "";
            if (path.contains ("Downloading") || path.contains ("Paused") || path.contains ("Complete") || path.contains ("Waiting") || path.contains ("Error")) {
                pathname = path.split ("/")[1].strip ();
            }
            Idle.add (() => {
                var serverdm = new ServerDM ();
                msg.set_response ("text/html", Soup.MemoryUse.COPY, serverdm.get_dm (pathname).data);
                self.unpause_message (msg);
                return false;
            });
            self.pause_message (msg);
            if (msg.method == "POST") {
                string result = (string) msg.request_body.data;
                var hashoption = new Gee.HashMap<string, string> ();
                hashoption[AriaOptions.BT_SAVE_METADATA.get_name ()] = "true";
                hashoption[AriaOptions.RPC_SAVE_UPLOAD_METADATA.get_name ()] = "true";
                if (Regex.match_simple ("gabutlink=(.*?)", result)) {
                    string reslink = result.split ("gabutlink=")[1].strip ();
                    if (reslink != "") {
                        if (reslink.has_prefix ("magnet:?")) {
                            address_url (reslink, hashoption, false, LinkMode.MAGNETLINK);
                        } else if (reslink.has_prefix ("http://") || reslink.has_prefix ("https://") || reslink.has_prefix ("ftp://") || reslink.has_prefix ("sftp://")) {
                            address_url (reslink, hashoption, false, LinkMode.URL);
                        }
                    }
                    msg.set_status_full (200, "OK");
                } else {
                    msg.set_status_full (500, "OK");
                }
                if (msg.request_headers.get_content_type (null) == "multipart/form-data") {
                    var multipart = new Soup.Multipart.from_message (msg.request_headers , msg.request_body);
                    Soup.MessageHeaders headers;
                    unowned Soup.Buffer body;
                    multipart.get_part (0, out headers, out body);
                    GLib.HashTable<string, string> params;
                    headers.get_content_disposition (null, out params);
                    string filename = params.get ("filename");
                    if (filename != null && filename != "") {
                        string bencode = data_bencoder (body.get_as_bytes ());
                        if (filename.down ().has_suffix (".torrent")) {
                            address_url (bencode, hashoption, false, LinkMode.TORRENT);
                        } else if (filename.down ().has_suffix (".metalink")) {
                            address_url (bencode, hashoption, false, LinkMode.METALINK);
                        }
                    }
                }
                msg.set_status_full (200, "OK");
            } else if (msg.method == "GET") {
                msg.set_status_full (200, "OK");
            }
        }

        public string get_address () {
            if (!bool.parse (get_dbsetting (DBSettings.IPLOCAL))) {
                try {
                    var resolver = Resolver.get_default ();
                    var address = resolver.lookup_by_name ("www.google.com");
                    var client = new SocketClient ();
                    var connection = client.connect_to_host (address.nth_data (0).to_string (), 80);
                    InetSocketAddress local = connection.get_local_address () as InetSocketAddress;
                    return @"http://$(local.get_address ()):$(get_uris ().nth_data (0).port)";
                } catch (Error e) {
                    return e.message;
                }
            } else {
                return @"http://$(get_listeners ().nth_data (0).local_address)";
            }
        }
    }
}
