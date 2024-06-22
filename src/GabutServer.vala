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
    public class GabutServer : Soup.Server {
        public signal void updat_row (string ariagid);
        public signal void delete_row (string ariagid);
        public signal void send_post_data (MatchInfo match_info);
        public signal void address_url (string url, Gee.HashMap<string, string> options, bool later, int linkmode);
        public signal Gee.ArrayList<DownloadRow> get_dl_row (int status);
        private string username;
        private Soup.AuthDomainDigest authenti;
        private SourceFunc callback;

        public async void set_listent (int port) throws Error {
            callback = set_listent.callback;
            authenti = new Soup.AuthDomainDigest ("realm", "server-gabut");
            authenti.add_path ("/Upload");
            authenti.add_path ("/Home");
            authenti.add_path ("/Downloading");
            authenti.add_path ("/Paused");
            authenti.add_path ("/Complete");
            authenti.add_path ("/Waiting");
            authenti.add_path ("/Error");
            authenti.add_path ("/Dialog");
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
            this.add_handler ("/Dialog", dialog_handler);
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
            this.username = username;
            if (!bool.parse (get_db_user (UserID.ACTIVE, username))) {
                return "";
            }
            return Soup.AuthDomainDigest.encode_password (get_db_user (UserID.USER, username), "server-gabut", get_db_user (UserID.PASSWD, username));
        }

        private void upload_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable? query) {
            if (msg.get_method () == "POST") {
                string result = (string) msg.get_request_body ().data;
                if (msg.get_request_headers ().get_content_type (null) == Soup.FORM_MIME_TYPE_MULTIPART) {
                    var multipart = new Soup.Multipart.from_message (msg.get_request_headers (), msg.get_request_body ().flatten ());
                    Soup.MessageHeaders headers;
                    GLib.Bytes body;
                    multipart.get_part (0, out headers, out body);
                    GLib.HashTable<string, string> params;
                    headers.get_content_disposition (null, out params);
                    string filename = params.get ("filename");
                    if (filename != null && filename != "") {
                        File filed = GLib.File.new_build_filename (aria_get_globalops (AriaOptions.DIR).replace ("\\/", "/"), filename);
                        if (!filed.query_exists ()) {
                            write_file.begin (body, filed.get_path ());
                            notify_app (_("File Transfered"), _("%s").printf (filename), new ThemedIcon (GLib.ContentType.get_generic_icon_name (headers.get_content_type (null))));
                            play_sound ("complete");
                        } else {
                            notify_app (_("File Exist"), _("%s").printf (filename), new ThemedIcon (GLib.ContentType.get_generic_icon_name (headers.get_content_type (null))));
                            play_sound ("dialog-error");
                        }
                    }
                    msg.set_status (Soup.Status.OK, "OK");
                } else if (Regex.match_simple ("openlink=(.*?)", result)) {
                    string reslink = result.replace ("openlink=", "").strip ();
                    if (reslink != "") {
                        if (reslink.has_prefix ("http://") || reslink.has_prefix ("https://") || reslink.has_prefix ("ftp://") || reslink.has_prefix ("sftp://")) {
                            notify_app (_("Open Link"), reslink, new ThemedIcon ("insert-link"));
                            open_fileman.begin (reslink);
                            play_sound ("complete");
                        }
                    }
                    msg.set_response ("text/html", Soup.MemoryUse.COPY, get_upload ().data);
                    msg.set_status (Soup.Status.OK, "OK");
                } else {
                    msg.set_status (Soup.Status.INTERNAL_SERVER_ERROR, "Error");
                }
            } else if (msg.get_method () == "GET") {
                msg.set_response ("text/html", Soup.MemoryUse.COPY, get_upload ().data);
                msg.set_status (Soup.Status.OK, "OK");
            }
        }

        private void dialog_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable? query) {
            if (msg.get_method () == "POST") {
                string result = (string) msg.get_request_body ().data;
                if (result.contains ("actiondm")) {
                    var dlist = get_dl_row (StatusMode.COMPLETE);
                    dlist.sort (sort_dm);
                    dlist.foreach ((row)=> {
                        if (row.ariagid == result.slice (result.last_index_of ("+") + 1, result.last_index_of ("="))) {
                            msg.set_response ("text/html", Soup.MemoryUse.COPY, get_complete (row).data);
                            msg.set_status (Soup.Status.OK, "OK");
                        } else {
                            msg.set_response ("text/html", Soup.MemoryUse.COPY, get_not_found ().data);
                            msg.set_status (Soup.Status.INTERNAL_SERVER_ERROR, "Error");
                        }
                        return true;
                    });
                } else {
                    msg.set_response ("text/html", Soup.MemoryUse.COPY, get_not_found ().data);
                    msg.set_status (Soup.Status.INTERNAL_SERVER_ERROR, "Error");
                }
            }
        }

        private void home_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable? query) {
            if (path != "/" && path != "favicon.ico") {
                if (msg.get_method () == "POST") {
                    var meseg = (string) msg.get_request_body ().data;
                    if (!meseg.contains ("+") && meseg.contains ("sort")) {
                        update_user (username, UserID.SHORTBY, meseg.split ("=")[1]);
                    }
                }
                File sourcef = File.new_for_path (get_dbsetting (DBSettings.SHAREDIR));
                File filegbt = GLib.File.new_build_filename (sourcef.get_path (), path);
                var ftype = filegbt.query_file_type (FileQueryInfoFlags.NOFOLLOW_SYMLINKS);
                msg.set_status (Soup.Status.OK, "OK");
                if (ftype == FileType.DIRECTORY) {
                    directory_mode.begin (msg, filegbt, sourcef);
                    return;
                } else if (ftype == FileType.REGULAR) {
                    open_file.begin (msg, filegbt);
                    return;
                }
                if (!filegbt.query_exists (null)) {
                    var pathfile = @"$(filegbt.get_parent ().get_path ().split (sourcef.get_path ())[1])/";
                    msg.set_redirect (Soup.Status.TEMPORARY_REDIRECT, pathfile == "/"? "/Home" : pathfile);
                    return;
                }
            }
            if (msg.get_method () == "POST") {
                string result = (string) msg.get_request_body ().data;
                try {
                    MatchInfo match_info;
                    Regex regex = new Regex ("link:(.*?),filename:(.*?),referrer:(.*?),mimetype:(.*?),filesize:(.*?),resumable:(.*?),");
                    if (regex.match_full (result, -1, 0, 0, out match_info)) {
                        send_post_data (match_info);
                        msg.set_response ("text/html", Soup.MemoryUse.COPY, get_home ().data);
                        msg.set_status (Soup.Status.OK, "OK");
                    } else {
                        msg.set_response ("text/html", Soup.MemoryUse.COPY, get_not_found ().data);
                        msg.set_status (Soup.Status.INTERNAL_SERVER_ERROR, "Error");
                    }
                } catch (Error e) {
                    GLib.warning (e.message);
                }
            } else if (msg.get_method () == "GET") {
                msg.set_response ("text/html", Soup.MemoryUse.COPY, get_home ().data);
                msg.set_status (Soup.Status.OK, "OK");
            }
        }

        private void gabut_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable? query) {
            string pathname = path.split ("/")[1].strip ();
            if (msg.get_method () == "POST") {
                string result = (string) msg.get_request_body ().data;
                var hashoption = new Gee.HashMap<string, string> ();
                hashoption[AriaOptions.BT_SAVE_METADATA.to_string ()] = "true";
                hashoption[AriaOptions.RPC_SAVE_UPLOAD_METADATA.to_string ()] = "true";
                if (Regex.match_simple ("gabutlink=(.*?)", result)) {
                    string reslink = result.replace ("gabutlink=", "").strip ();
                    if (reslink != "") {
                        if (reslink.has_prefix ("magnet:?")) {
                            address_url (reslink, hashoption, false, LinkMode.MAGNETLINK);
                        } else if (reslink.has_prefix ("http://") || reslink.has_prefix ("https://") || reslink.has_prefix ("ftp://") || reslink.has_prefix ("sftp://")) {
                            address_url (reslink, hashoption, false, LinkMode.URL);
                        }
                    }
                    msg.set_response ("text/html", Soup.MemoryUse.COPY, get_dm (pathname, html_dm (path), javascr_dm (path), username).data);
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
                    msg.set_response ("text/html", Soup.MemoryUse.COPY, get_dm (pathname, html_dm (path), javascr_dm (path), username).data);
                    msg.set_status (Soup.Status.OK, "OK");
                } else if (result.contains ("actiondm")) {
                    updat_row (result.slice (result.last_index_of ("+") + 1, result.last_index_of ("=")));
                    msg.set_response ("text/html", Soup.MemoryUse.COPY, get_dm (pathname, html_dm (path), javascr_dm (path), username).data);
                    msg.set_status (Soup.Status.OK, "OK");
                } else if (result.contains ("actiondelete")) {
                    delete_row (result.slice (result.last_index_of ("+") + 1, result.last_index_of ("=")));
                    msg.set_response ("text/html", Soup.MemoryUse.COPY, get_dm (pathname, html_dm (path), javascr_dm (path), username).data);
                    msg.set_status (Soup.Status.OK, "OK");
                } else if (!result.contains ("+") && result.contains ("sort")) {
                    update_user (username, UserID.SHORTBY, result.split ("=")[1]);
                    msg.set_response ("text/html", Soup.MemoryUse.COPY, get_dm (pathname, html_dm (path), javascr_dm (path), username).data);
                    msg.set_status (Soup.Status.OK, "OK");
                } else {
                    msg.set_response ("text/html", Soup.MemoryUse.COPY, get_not_found ().data);
                    msg.set_status (Soup.Status.INTERNAL_SERVER_ERROR, "Error");
                }
            } else if (msg.get_method () == "GET") {
                msg.set_response ("text/html", Soup.MemoryUse.COPY, get_dm (pathname, html_dm (path), javascr_dm (path), username).data);
                msg.set_status (Soup.Status.OK, "OK");
            }
        }

        private string html_dm (string path) {
            var htmlstr = "";
            if (path == "/Downloading") {
                var dlist = get_dl_row (StatusMode.ACTIVE);
                dlist.sort (sort_dm);
                if (dlist.size > 0) {
                    htmlstr = "<div class=\"append\">";
                    dlist.foreach ((row)=> {
                        htmlstr += dm_div (row, "Pause", path);
                        return true;
                    });
                    htmlstr += "</div>";
                }
            } else if (path == "/Paused") {
                var dlist = get_dl_row (StatusMode.PAUSED);
                dlist.sort (sort_dm);
                if (dlist.size > 0) {
                    htmlstr = "<div class=\"append\">";
                    dlist.foreach ((row)=> {
                        htmlstr += dm_div (row, "Start", path);
                        return true;
                    });
                    htmlstr += "</div>";
                }
            } else if (path == "/Complete") {
                var dlist = get_dl_row (StatusMode.COMPLETE);
                dlist.sort (sort_dm);
                if (dlist.size > 0) {
                    htmlstr = "<div class=\"append\">";
                    dlist.foreach ((row)=> {
                        htmlstr += dm_div (row, "Complete", path);
                        return true;
                    });
                    htmlstr += "</div>";
                }
            } else if (path == "/Waiting") {
                var dlist = get_dl_row (StatusMode.WAIT);
                dlist.sort (sort_dm);
                if (dlist.size > 0) {
                    htmlstr = "<div class=\"append\">";
                    dlist.foreach ((row)=> {
                        htmlstr += dm_div (row, "Waiting", path);
                        return true;
                    });
                    htmlstr += "</div>";
                }
            } else if (path == "/Error") {
                var dlist = get_dl_row (StatusMode.ERROR);
                dlist.sort (sort_dm);
                if (dlist.size > 0) {
                    htmlstr = "<div class=\"append\">";
                    dlist.foreach ((row)=> {
                        htmlstr += dm_div (row, "Error", path);
                        return true;
                    });
                    htmlstr += "</div>";
                }
            }
            return htmlstr;
        }

        private string javascr_dm (string path) {
            var script = "";
            if (path == "/Downloading") {
                if (get_dl_row (StatusMode.ACTIVE).size > 0) {
                    script = "<script>setInterval(function () { if (document.getElementById(\"myOverlay\").style.display != \"block\") {window.location.reload ();} }, 1300); </script>\n";
                }
            }
            return script;
        }

        private int sort_dm (DownloadRow row1, DownloadRow row2) {
            var sortpos = int.parse (get_db_user (UserID.SHORTBY, username));
            if (sortpos == 0) {
                if (row1.filename != null && row2.filename != null) {
                    var name1 = row1.filename.down ();
                    var name2 = row2.filename.down ();
                    if (name1 > name2) {
                        return 1;
                    }
                    if (name1 < name2) {
                        return -1;
                    }
                } else {
                    return 0;
                }
            } else if (sortpos == 1) {
                var total1 = row1.totalsize;
                var total2 = row2.totalsize;
                if (total1 > total2) {
                    return 1;
                }
                if (total1 < total2) {
                    return -1;
                }
            } else if (sortpos == 2) {
                if (row1.fileordir != null && row2.fileordir != null) {
                    var fordir1 = row1.fileordir.down ();
                    var fordir2 = row2.fileordir.down ();
                    if (fordir1 > fordir2) {
                        return 1;
                    }
                    if (fordir1 < fordir2) {
                        return -1;
                    }
                } else {
                    return 0;
                }
            } else {
                var timeadded1 = row1.timeadded;
                var timeadded2 = row2.timeadded;
                if (timeadded1 > timeadded2) {
                    return 1;
                }
                if (timeadded1 < timeadded2) {
                    return -1;
                }
            }
            return 0;
        }

        private void share_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable? query) {
            if (bool.parse (get_dbsetting (DBSettings.SWITCHDIR))) {
                if (msg.get_method () == "POST") {
                    var meseg = (string) msg.get_request_body ().data;
                    if (!meseg.contains ("+") && meseg.contains ("sort")) {
                        update_user (username, UserID.SHORTBY, meseg.split ("=")[1]);
                    }
                }
                msg.set_status (Soup.Status.OK, _("OK"));
                File sourcef = File.new_for_path (get_dbsetting (DBSettings.SHAREDIR));
                directory_mode.begin (msg, sourcef, sourcef);
            } else {
                msg.set_response ("text/html", Soup.MemoryUse.COPY, get_not_found ().data);
                msg.set_status (Soup.Status.OK, "OK");
            }
        }

        private string dm_div (DownloadRow? row, string action, string path) {
            double fraction = ((double) row.transferred / (double) row.totalsize);
            var sbuilder = "<div class=\"item\">";
            if (row.fileordir != null) {
                sbuilder += @"<a class=\"icon $(get_mime_css (row.fileordir))\"></a>";
            } else {
                sbuilder += "<a class=\"icon file\"></a>";
            }
            sbuilder += "<ul class=\"name\">";
            if (row.filename != null && row.pathname != null) {
                sbuilder += @"<li><h4 title=\"$(row.pathname)\">$(row.filename)</h4></li>";
            } else {
                sbuilder += "<li><h4 title=\"Loading Informatioan\">\"Loading Informatioan\"</h4></li>";
            }
            if (row.totalsize > 0) {
                sbuilder += @"<li><div class=\"progress\"><div class=\"progress-bar progress-bar-striped active\" role=\"progressbar\" style=\"width:$(fraction * 100)%\"></div></div></li>";
            } else {
                sbuilder += "<li><div class=\"progress\"></div></li>";
            }
            if (row.labeltransfer != null) {
                sbuilder += @"<li>$(row.labeltransfer.to_ascii ())</li>";
            } else {
                sbuilder += "<li>\"Loading file...\"</li>";
            }
            sbuilder += "</ul>";
            sbuilder += @"<div class=\"deleteb\"><form action=\"$(path)\" method=\"post\"> <input type=\"submit\" name=\"actiondelete $(row.ariagid)\" value=\"Delete\" class=\"btn btn-danger btn-lg active\"/></form></div>";
            sbuilder += @"<form action=\"$(action != "Complete"? path : "/Dialog")\" method=\"post\"> <input type=\"submit\" name=\"actiondm $(row.ariagid)\" value=\"$(action)\" class=\"btn btn-primary btn-lg active\"/></form>";
            sbuilder += "</div>\n";
            return sbuilder;
        }

        private int path_lenght = 0;
        private bool firstscan = false;
        private async void directory_mode (Soup.ServerMessage msg, File file, File sourcef) throws Error {
            var filesorters = new Gee.ArrayList<FSorter?> ();
            GLib.FileEnumerator enumerator = file.enumerate_children ("*", GLib.FileQueryInfoFlags.NOFOLLOW_SYMLINKS);
            GLib.FileInfo info;
            GLib.File fileout;
            while (enumerator.iterate (out info, out fileout) && info != null) {
                if (info.get_is_hidden ()) {
                    continue;
                }
                bool fileordir = false;
                int container = 0;
                if (info.get_file_type () == FileType.DIRECTORY) {
                    fileordir = true;
                    container = get_container (fileout);
                }
                var fsorter = FSorter ();
                fsorter.name = info.get_name ();
                fsorter.mimetype = info.get_content_type ();
                fsorter.fileordir = fileordir;
                fsorter.size = info.get_size ();
                fsorter.fileindir = container;
                fsorter.fileinfo = info;
                fsorter.date = info.get_modification_date_time ().to_string ();
                filesorters.add (fsorter);
            }
            var pathfile = @"$(file.get_path ().split (sourcef.get_path ())[1])/";
            var htmlstr = "";
            if (pathfile == "/") {
                htmlstr = _("<header><a class=\"icon myhome\" title=Home href=\"/Home\"></a><a class=\"shortfd\" href=\"/Home\">Home/</a></header>");
            } else {
                htmlstr += "<header>";
                foreach (string path in pathfile.split ("/")) {
                    if (path != "") {
                        var strpath = pathfile.split (path)[0];
                        if (strpath == "/") {
                            htmlstr += "<a class=\"icon myhome\" title=Home href=\"/Home\"></a><a class=\"shortfd\" href=\"/Home\">Home/</a>";
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
            if (username == null) {
                msg.set_redirect (Soup.Status.TEMPORARY_REDIRECT, "/Home");
                return;
            }
            switch (int.parse (get_db_user (UserID.SHORTBY, username))) {
                case 1:
                case 2:
                    firstscan = true;
                    filesorters.sort ((GLib.CompareDataFunc) sort_sfile);
                    htmlstr += load_item (filesorters, pathfile, 1);
                    firstscan = false;
                    filesorters.sort ((GLib.CompareDataFunc) sort_sfile);
                    htmlstr += load_item (filesorters, pathfile, 2);
                    break;
                case 3:
                default:
                    filesorters.sort ((GLib.CompareDataFunc) sort_sfile);
                    htmlstr += load_item (filesorters, pathfile, 0);
                    break;
            }
            htmlstr += "</div>";
            var opcls = path_lenght < pathfile.length? "fadeInRight" : "fadeInLeft";
            msg.set_response ("text/html", Soup.MemoryUse.COPY, get_share (pathfile, htmlstr, opcls, username).data);
            path_lenght = pathfile.length;
        }

        [CCode (instance_pos = -1)]
        private int sort_sfile (FSorter row1, FSorter row2) {
            var sortpos = int.parse (get_db_user (UserID.SHORTBY, username));
            if (sortpos == 0) {
                if (row1.name != null && row2.name != null) {
                    var name1 = row1.name.down ();
                    var name2 = row2.name.down ();
                    if (name1 > name2) {
                        return 1;
                    }
                    if (name1 < name2) {
                        return -1;
                    }
                } else {
                    return 0;
                }
            } else if (sortpos == 1) {
                if (firstscan) {
                    var fileindir1 = row1.fileindir;
                    var fileindir2 = row2.fileindir;
                    if (fileindir1 > fileindir2) {
                        return 1;
                    }
                    if (fileindir1 < fileindir2) {
                        return -1;
                    }
                } else {
                    var size1 = row1.size;
                    var size2 = row2.size;
                    if (size1 > size2) {
                        return 1;
                    }
                    if (size1 < size2) {
                        return -1;
                    }
                }
            } else if (sortpos == 2) {
                if (firstscan) {
                    if (row1.name != null && row2.name != null) {
                        var name1 = row1.name.down ();
                        var name2 = row2.name.down ();
                        if (name1 > name2) {
                            return 1;
                        }
                        if (name1 < name2) {
                            return -1;
                        }
                    } else {
                        return 0;
                    }
                } else {
                    if (row1.mimetype != null && row2.mimetype != null) {
                        var mime1 = row1.mimetype.down ();
                        var mime2 = row2.mimetype.down ();
                        if (mime1 > mime2) {
                            return 1;
                        }
                        if (mime1 < mime2) {
                            return -1;
                        }
                    } else {
                        return 0;
                    }
                }
            } else {
                var timeadded1 = row1.date;
                var timeadded2 = row2.date;
                if (timeadded1 > timeadded2) {
                    return 1;
                }
                if (timeadded1 < timeadded2) {
                    return -1;
                }
            }
            return 0;
        }

        private string load_item (Gee.ArrayList<FSorter?> filesorter, string pathfile, int dirfirst) {
            string htmlstr = "";
            filesorter.foreach ((fsorter) => {
                switch (dirfirst) {
                    case 1:
                        if (fsorter.fileordir) {
                            htmlstr += loaddiv (pathfile + fsorter.name, fsorter.fileinfo, false, fsorter.fileordir, fsorter.mimetype, fsorter.size, fsorter.fileindir);
                        }
                        return true;
                    case 2:
                        if (!fsorter.fileordir) {
                            htmlstr += loaddiv (pathfile +  fsorter.name, fsorter.fileinfo, false, fsorter.fileordir, fsorter.mimetype, fsorter.size, fsorter.fileindir);
                        }
                        return true;
                    default:
                        htmlstr += loaddiv (pathfile +  fsorter.name, fsorter.fileinfo, false, fsorter.fileordir, fsorter.mimetype, fsorter.size, fsorter.fileindir);
                        return true;
                }
            });
            return htmlstr;
        }

        private string loaddiv (string path, FileInfo? fileinfo, bool goback = true, bool fileordir = false, string mime = "", int64 size = 0, int infolder = 0) {
            var sbuilder = "<div class=\"item\">";
            if (goback) {
                sbuilder += @"<a class=\"icon up\" href=\"$(GLib.Uri.unescape_string (path))\"></a>";
            } else {
                if (fileordir) {
                    sbuilder += @"<a class=\"icon folder\" href=\"$(GLib.Uri.unescape_string (path))\"></a>";
                } else {
                    sbuilder += @"<a class=\"icon $(get_mime_css (mime))\" href=\"$(GLib.Uri.unescape_string (path))\"></a>";
                }
            }
            if (fileinfo != null) {
                sbuilder += @"<div class=\"name\"><a title=\"$(fileinfo.get_name ())\" href=\"$(GLib.Uri.unescape_string (path))\">$(fileinfo.get_name ())</a></div>";
                if (!fileordir) {
                    sbuilder += @"<div class=\"size\">$(GLib.format_size (size).to_ascii ())</div>";
                } else {
                    authenti.add_path (path);
                    if (infolder != 0) {
                        sbuilder += @"<div class=\"size\">$(infolder) items</div>";
                    } else {
                        sbuilder += "<div class=\"size\">Empty</div>";
                    }
                }
                sbuilder += @"<div class=\"modified\">$(fileinfo.get_modification_date_time ().format ("%I:%M %p %x"))</div>";
            } else {
                sbuilder += @"<div class=\"name\"><a title=\"Go Up\" href=\"$(GLib.Uri.unescape_string (path))\">Go Up</a></div>";
            }
            sbuilder += "</div>\n";
            return sbuilder;
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