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
        public signal GLib.List<string> get_dl_row (int status);
        private SourceFunc callback;

        public async void set_listent (int port) throws Error {
            callback = set_listent.callback;
            var authenti = new Soup.AuthDomainDigest ("realm", "server-gabut");
            authenti.add_path ("/Upload");
            authenti.add_path ("/Home");
            authenti.add_path ("/Downloading");
            authenti.add_path ("/Paused");
            authenti.add_path ("/Complete");
            authenti.add_path ("/Waiting");
            authenti.add_path ("/Error");
            authenti.set_auth_callback (authentication);
            this.add_auth_domain (authenti);
            this.add_handler ("/", home_handler);
            this.add_handler ("/Upload", upload_handler);
            this.add_handler ("/Home", share_handler);
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

        private string authentication (Soup.AuthDomainDigest domain, Soup.ServerMessage msg, string username) {
            if (!bool.parse (get_db_user (UserID.ACTIVE, username))) {
                return "";
            }
            return Soup.AuthDomainDigest.encode_password (get_db_user (UserID.USER, username), "server-gabut", get_db_user (UserID.PASSWD, username));
        }

        private void upload_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable? query) {
            unowned GabutServer self = server as GabutServer;
            self.pause_message (msg);
            if (msg.get_method () == "POST") {
                try {
                    if (msg.get_request_headers ().get_content_type (null) == Soup.FORM_MIME_TYPE_MULTIPART) {
                        var multipart = new Soup.Multipart.from_message (msg.get_request_headers () , msg.get_request_body ().flatten ());
                        Soup.MessageHeaders headers;
                        GLib.Bytes body;
                        multipart.get_part (0, out headers, out body);
                        GLib.HashTable<string, string> params;
                        headers.get_content_disposition (null, out params);
                        string filename = params.get ("filename");
                        if (filename != null && filename != "") {
                            File filed = File.new_for_path (aria_get_globalops (AriaOptions.DIR).replace ("\\/", "/") + GLib.Path.DIR_SEPARATOR_S + filename);
                            if (!filed.query_exists ()) {
                                FileOutputStream out_stream = filed.create (FileCreateFlags.REPLACE_DESTINATION);
                                out_stream.write (body.get_data ());
                                notify_app (_("File Transfered"), _("%s").printf (filename), GLib.ContentType.get_icon (get_mime_type (filed)));
                            } else {
                                notify_app (_("File Exist"), _("%s").printf (filename), GLib.ContentType.get_icon (get_mime_type (filed)));
                            }
                        }
                    }
                    msg.set_status (Soup.Status.OK, "OK");
                    self.unpause_message (msg);
                } catch (Error e) {
                    GLib.warning (e.message);
                }
            } else if (msg.get_method () == "GET") {
                msg.set_response ("text/html", Soup.MemoryUse.COPY, get_upload ().data);
                msg.set_status (Soup.Status.OK, "OK");
                self.unpause_message (msg);
            }
        }

        private void home_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable? query) {
            unowned GabutServer self = server as GabutServer;
            self.pause_message (msg);
            string path_msg = msg.get_uri ().get_path ();
            if (path_msg != "/" && path_msg != "favicon.ico") {
                if (msg.get_method () == "POST") {
                    var meseg = (string) msg.get_request_body ().data;
                    if (!meseg.contains ("+")) {
                        set_dbsetting (DBSettings.SHORTBY, meseg.split ("=")[1]);
                    }
                }
                File filegbt = File.new_for_path (@"$(get_dbsetting (DBSettings.SHAREDIR))$(path_msg)");
                var ftype = filegbt.query_file_type (FileQueryInfoFlags.NOFOLLOW_SYMLINKS);
                msg.set_status (Soup.Status.OK, "OK");
                if (ftype == FileType.DIRECTORY) {
                    directory_mode.begin (msg, filegbt);
                    self.unpause_message (msg);
                    return;
                } else if (ftype == FileType.REGULAR) {
                    open_file.begin (msg, filegbt);
                    self.unpause_message (msg);
                    return;
                }
            }
            if (msg.get_method () == "POST") {
                string result = (string) msg.get_request_body ().data;
                try {
                    MatchInfo match_info;
                    Regex regex = new Regex ("link:(.*?),filename:(.*?),referrer:(.*?),mimetype:(.*?),filesize:(.*?),resumable:(.*?),");
                    if (regex.match_full (result, -1, 0, 0, out match_info)) {
                        msg.set_status (Soup.Status.OK, "OK");
                        send_post_data (match_info);
                    } else if (Regex.match_simple ("openlink=(.*?)", result)) {
                        msg.set_status (Soup.Status.OK, "OK");
                        string reslink = result.replace ("openlink=", "").strip ();
                        if (reslink != "") {
                            if (reslink.has_prefix ("http://") || reslink.has_prefix ("https://") || reslink.has_prefix ("ftp://") || reslink.has_prefix ("sftp://")) {
                                notify_app (_("Open Link"), reslink, new ThemedIcon ("insert-link"));
                                open_fileman.begin (reslink);
                            }
                        }
                    } else {
                        msg.set_status (Soup.Status.INTERNAL_SERVER_ERROR, "Error");
                    }
                    self.unpause_message (msg);
                } catch (Error e) {
                    GLib.warning (e.message);
                }
            } else if (msg.get_method () == "GET") {
                msg.set_response ("text/html", Soup.MemoryUse.COPY, get_home ().data);
                msg.set_status (Soup.Status.OK, "OK");
                self.unpause_message (msg);
            }
        }

        private void gabut_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable? query) {
            unowned GabutServer self = server as GabutServer;
            string pathname = "";
            if (path.contains ("Downloading") || path.contains ("Paused") || path.contains ("Complete") || path.contains ("Waiting") || path.contains ("Error")) {
                pathname = path.split ("/")[1].strip ();
            }
            self.pause_message (msg);
            if (msg.get_method () == "POST") {
                string result = (string) msg.get_request_body ().data;
                var hashoption = new Gee.HashMap<string, string> ();
                hashoption[AriaOptions.BT_SAVE_METADATA.get_name ()] = "true";
                hashoption[AriaOptions.RPC_SAVE_UPLOAD_METADATA.get_name ()] = "true";
                if (Regex.match_simple ("gabutlink=(.*?)", result)) {
                    string reslink = result.replace ("gabutlink=", "").strip ();
                    if (reslink != "") {
                        if (reslink.has_prefix ("magnet:?")) {
                            address_url (reslink, hashoption, false, LinkMode.MAGNETLINK);
                        } else if (reslink.has_prefix ("http://") || reslink.has_prefix ("https://") || reslink.has_prefix ("ftp://") || reslink.has_prefix ("sftp://")) {
                            address_url (reslink, hashoption, false, LinkMode.URL);
                        }
                    }
                    msg.set_status (Soup.Status.OK, "OK");
                } else if (msg.get_request_headers ().get_content_type (null) == Soup.FORM_MIME_TYPE_MULTIPART) {
                    var multipart = new Soup.Multipart.from_message (msg.get_request_headers () , msg.get_request_body ().flatten ());
                    Soup.MessageHeaders headers;
                    GLib.Bytes body;
                    multipart.get_part (0, out headers, out body);
                    GLib.HashTable<string, string> params;
                    headers.get_content_disposition (null, out params);
                    string filename = params.get ("filename");
                    if (filename != null && filename != "") {
                        string bencode = data_bencoder (body);
                        if (filename.down ().has_suffix (".torrent")) {
                            address_url (bencode, hashoption, false, LinkMode.TORRENT);
                        } else if (filename.down ().has_suffix (".metalink")) {
                            address_url (bencode, hashoption, false, LinkMode.METALINK);
                        }
                    }
                    msg.set_status (Soup.Status.OK, "OK");
                } else {
                    msg.set_status (Soup.Status.INTERNAL_SERVER_ERROR, "Error");
                }
                self.unpause_message (msg);
            } else if (msg.get_method () == "GET") {
                msg.set_response ("text/html", Soup.MemoryUse.COPY, get_dm (pathname).data);
                msg.set_status (Soup.Status.OK, "OK");
                self.unpause_message (msg);
            }
        }

        private void share_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable? query) {
            unowned GabutServer self = server as GabutServer;
            self.pause_message (msg);
            if (msg.get_method () == "GET" && (!bool.parse (get_dbsetting (DBSettings.SWITCHDIR)))) {
                msg.set_response ("text/html", Soup.MemoryUse.COPY, get_not_found ().data);
                msg.set_status (Soup.Status.OK, "OK");
                self.unpause_message (msg);
                return;
            }
            if (msg.get_method () == "POST") {
                var meseg = (string) msg.get_request_body ().data;
                if (!meseg.contains ("+")) {
                    set_dbsetting (DBSettings.SHORTBY, meseg.split ("=")[1]);
                }
            }
            msg.set_status(Soup.Status.OK, _("OK"));
            directory_mode.begin (msg, File.new_for_path (get_dbsetting (DBSettings.SHAREDIR)));
            self.unpause_message (msg);
        }

        private async void open_file (Soup.ServerMessage msg, File file) throws Error {
            msg.set_response (get_mime_type (file), Soup.MemoryUse.COPY, file.load_bytes ().get_data ());
        }

        private int path_lenght = 0;
        private async void directory_mode (Soup.ServerMessage msg, File file) throws Error {
            var filesorter = new Gtk.ListStore (FSorter.N_COLUMNS, typeof (string), typeof (string), typeof (bool), typeof (int64), typeof (int), typeof (FileInfo), typeof (string));
            FileEnumerator enumerator = file.enumerate_children ("*", FileQueryInfoFlags.NOFOLLOW_SYMLINKS);
            FileInfo info = null;
            while (((info = enumerator.next_file (null)) != null)) {
                if (info.get_name ().length > 0 && info.get_name ()[0] == '.') {
                    continue;
                }
                bool fileordir = false;
                int container = 0;
                if (info.get_file_type () == FileType.DIRECTORY) {
                    fileordir = true;
                    container = get_container (File.new_for_path (@"$(file.get_path ())/$(info.get_name ())"));
                }
                Gtk.TreeIter iter;
                filesorter.append (out iter);
                filesorter.set (iter, FSorter.NAME, info.get_name (), FSorter.MIMETYPE, info.get_content_type (), FSorter.FILEORDIR, fileordir, FSorter.SIZE, info.get_size (), FSorter.FILEINDIR, container, FSorter.FILEINFO, info, FSorter.DATE, info.get_modification_date_time ().to_string ());
            }
            File sourcef = File.new_for_path (get_dbsetting (DBSettings.SHAREDIR));
            var pathfile = @"$(file.get_path ().split (sourcef.get_path ())[1])/";
            var htmlstr = "";
            if (pathfile == "/") {
                htmlstr = _(@"<header><a class=\"icon myhome\" title=Home href=\"/Home\"></a><a class=\"shortfd\">/</a></header>");
            } else {
                htmlstr += "<header>";
                foreach (string path in pathfile.split ("/")) {
                    if (path != "") {
                        var strpath = pathfile.split (path)[0];
                        if (strpath == "/") {
                            htmlstr += @"<a class=\"icon myhome\" title=Home href=\"/Home\"></a><a class=\"shortfd\">/</a>";
                        }
                        htmlstr += @"<a class=\"shortfd\" title=\"$(path)\" href=\"$(GLib.Uri.unescape_string (strpath+path))\">$(path)/</a>";
                    }
                }
                htmlstr += "</header>";
            }
            if (sourcef.get_path () != file.get_path () && file.has_parent (null)) {
                string path_back = file.get_parent ().get_path ().split (sourcef.get_path ())[1];
                if (path_back == "") {
                    path_back = "/Home";
                }
                htmlstr += @"<div class=\"append\">$(loaddiv (path_back, null))</div>";
            }
            htmlstr += "<div class=\"append\">";
            switch (int.parse (get_dbsetting (DBSettings.SHORTBY))) {
                case 1:
                    ((Gtk.TreeSortable)filesorter).set_sort_column_id (FSorter.NAME, Gtk.SortType.ASCENDING);
                    htmlstr += load_item (filesorter, pathfile, 1);
                    ((Gtk.TreeSortable)filesorter).set_sort_column_id (FSorter.MIMETYPE, Gtk.SortType.ASCENDING);
                    htmlstr += load_item (filesorter, pathfile, 2);
                    break;
                case 2:
                    ((Gtk.TreeSortable)filesorter).set_sort_column_id (FSorter.FILEINDIR, Gtk.SortType.ASCENDING);
                    htmlstr += load_item (filesorter, pathfile, 1);
                    ((Gtk.TreeSortable)filesorter).set_sort_column_id (FSorter.SIZE, Gtk.SortType.ASCENDING);
                    htmlstr += load_item (filesorter, pathfile, 2);
                    break;
                case 3:
                    ((Gtk.TreeSortable)filesorter).set_sort_column_id (FSorter.DATE, Gtk.SortType.ASCENDING);
                    htmlstr += load_item (filesorter, pathfile, 0);
                    break;
                default:
                    ((Gtk.TreeSortable)filesorter).set_sort_column_id (FSorter.NAME, Gtk.SortType.ASCENDING);
                    htmlstr += load_item (filesorter, pathfile, 0);
                    break;
            }
            htmlstr += "</div>";
            var opcls = path_lenght < pathfile.length? "fadeInRight" : "fadeInLeft";
            msg.set_response ("text/html", Soup.MemoryUse.COPY, get_share (pathfile, htmlstr, opcls).data);
            path_lenght = pathfile.length;
        }

        private string load_item (Gtk.ListStore filesorter, string pathfile, int dirfirst) {
            string htmlstr = "";
            filesorter.foreach ((model, path, iter) => {
                string name, mime;
                int infolder;
                int64 fsize;
                bool filordir;
                FileInfo infofile;
                filesorter.get (iter, FSorter.NAME, out name, FSorter.MIMETYPE, out mime, FSorter.FILEORDIR, out filordir, FSorter.SIZE, out fsize, FSorter.FILEINDIR, out infolder, FSorter.FILEINFO, out infofile);
                switch (dirfirst) {
                    case 1:
                        if (filordir) {
                            htmlstr += loaddiv (pathfile + name, infofile, false, filordir, mime, fsize, infolder);
                        }
                        return false;
                    case 2:
                        if (!filordir) {
                            htmlstr += loaddiv (pathfile + name, infofile, false, filordir, mime, fsize, infolder);
                        }
                        return false;
                    default:
                        htmlstr += loaddiv (pathfile + name, infofile, false, filordir, mime, fsize, infolder);
                        return false;
                }
            });
            return htmlstr;
        }

        private string loaddiv (string path, FileInfo? fileinfo, bool goback = true, bool fileordir = false, string mime = "", int64 size = 0, int infolder = 0) {
            var sbuilder = new StringBuilder ("<div class=\"item\">");
            if (goback) {
                sbuilder.append (@"<a class=\"icon up\" href=\"$(GLib.Uri.unescape_string (path))\"></a>");
            } else {
                if (fileordir) {
                    sbuilder.append ("<div class=\"icon folder\"></div>");
                } else {
                    sbuilder.append (@"<div class=\"icon $(get_mime_css (mime))\"></div>");
                }
            }
            if (fileinfo != null) {
                sbuilder.append (@"<div class=\"name\"><a title=\"$(fileinfo.get_name ())\" href=\"$(GLib.Uri.unescape_string (path))\">$(fileinfo.get_name ())</a></div>");
                if (!fileordir) {
                    sbuilder.append (@"<div class=\"size\">$(GLib.format_size (size).to_ascii ())</div>");
                } else {
                    if (infolder != 0) {
                        sbuilder.append (@"<div class=\"size\">$(infolder) items</div>");
                    } else {
                        sbuilder.append ("<div class=\"size\">Empty</div>");
                    }
                }
                sbuilder.append (@"<div class=\"modified\">$(fileinfo.get_modification_date_time ().format ("%I:%M %p %x"))</div>");
            } else {
                sbuilder.append (@"<div class=\"name\"><a title=\"Go Up\" href=\"$(GLib.Uri.unescape_string (path))\">Go Up</a></div>");
            }
            sbuilder.append ("</div>");
            return sbuilder.str;
        }

        public string get_address () {
            var soupuri = get_uris ().nth_data (0);
            if (!bool.parse (get_dbsetting (DBSettings.IPLOCAL))) {
                return @"$(soupuri.get_scheme ())://$(get_local_address ()):$(soupuri.get_port ())";
            } else {
                return @"$(soupuri.get_scheme ())://$(get_listeners ().nth_data (0).local_address)";
            }
        }
    }
}
