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
    public class GabutServer : Soup.Server {
        public signal void lserv_action (string[] ariagid);
        public signal void delete_row (string[] urlohls);
        public signal void send_post_data (MatchInfo match_info);
        public signal void address_url (string url, Gee.HashMap<string, string> options, bool later, int linkmode);
        public signal Gee.ArrayList<DownloadRow> get_dl_row (int status);
        public signal DownloadRow get_dm_row (string ariagid);
        public signal DownloadRow get_hls_row (string hurlu);
        private Soup.AuthDomainDigest authenti;
        private SourceFunc callback;
        private int path_lenght = 0;
        private bool firstscan = false;
        private string username;

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
            this.add_handler ("/Arirow", dlrow_handler);
            this.add_handler ("/HLSrow", hlsrow_handler);
            this.add_handler ("/Rawori", rawori_handler);
            this.add_handler ("/Rawpix", rawpix_handler);
            this.add_handler ("/DirList", dir_list_handler);
            this.add_handler ("/DirListVideo", dir_list_video_handler);
            this.add_handler ("/DirListImage", dir_list_image_handler);
            this.add_handler ("/TorrentPreview", torrent_handler);
            this.add_handler ("/PdfjsLib",  pdfjs_lib_handler);
            this.add_handler ("/PdfjsWorker", pdfjs_worker_handler);
            this.add_handler ("/MammothJs", mammoth_handler);
            this.add_handler ("/SheetJs", sheetjs_handler);
            this.add_handler ("/LibarchiveJs", libarchive_js_handler);
            this.add_handler ("/WorkerarchiveJs", worker_archive_handler);
            this.add_handler ("/WasmarchiveJs", wasm_archive_handler);
            this.add_handler ("/Hlsjs", play_hls_handler);
            this.add_handler ("/Mpegjs", play_mpeg_handler);
            this.add_handler ("/Mpegplayjs", play_mpg_handler);
            this.add_handler ("/JsMediaTags", jsmediatags_handler);
            this.add_handler ("/JsZip", jsjzip_handler);
            this.add_handler ("/Player", player_handler);
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
            disconnect ();
            if (callback != null) {
                Idle.add ((owned)callback);
            }
        }

        private string authentication (Soup.AuthDomainDigest domain, Soup.ServerMessage msg, string username) {
            this.username = username;
            if (!bool.parse (get_db_user (UserID.ACTIVE, username))) {
                return "";
            }
            return Soup.AuthDomainDigest.encode_password (get_db_user (UserID.USER, username), "server-gabut", get_db_user (UserID.PASSWD, username));
        }

        private void dlrow_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable<string, string>? query) {
            if (msg.get_method () == "POST") {
                if (msg.get_request_body () != null) {
                    string result = (string) msg.get_request_body ().data;
                    var row = get_dm_row (result);
                    if (row != null) {
                        if (row.status == StatusMode.ACTIVE) {
                            var respond = @"{\"fraction\": $((double) row.transferred / (double) row.totalsize),\"label\": \"$(row.labeltransfer)\"}";
                            msg.set_response ("application/json; charset=utf-8", Soup.MemoryUse.COPY, respond.data);
                            msg.set_status (Soup.Status.OK, "OK");
                        } else {
                            msg.set_status (Soup.Status.INTERNAL_SERVER_ERROR, "ERROR");
                        }
                    } else {
                        msg.set_status (Soup.Status.INTERNAL_SERVER_ERROR, "ERROR");
                    }
                }
            }
        }

        private void hlsrow_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable<string, string>? query) {
            if (msg.get_method () == "POST") {
                if (msg.get_request_body () != null) {
                    string result = (string) msg.get_request_body ().data;
                    var row = get_hls_row (result);
                    if (row != null) {
                        if (row.status == StatusMode.ACTIVE) {
                            var hrespond = @"{\"fraction\": $((double)row.fraction),\"label\": \"$(row.labeltransfer)\"}";
                            msg.set_response ("application/json; charset=utf-8", Soup.MemoryUse.COPY, hrespond.data);
                            msg.set_status (Soup.Status.OK, "OK");
                        } else {
                            msg.set_status (Soup.Status.INTERNAL_SERVER_ERROR, "ERROR");
                        }
                    } else {
                        msg.set_status (Soup.Status.INTERNAL_SERVER_ERROR, "ERROR");
                    }
                }
            }
        }

        private void upload_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable<string, string>? query) {
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
                        GLib.File filed = GLib.File.new_build_filename (aria_get_globalops (AriaOptions.DIR).replace ("\\/", "/"), filename);
                        if (!filed.query_exists ()) {
                            write_file.begin (body, filed.get_path (), (obj, res)=> {
                                try {
                                    write_file.end (res);
                                } catch (GLib.Error e) {
                                } finally {
                                    notify_app (_("File Transfered"), _("%s").printf (filename), new ThemedIcon (GLib.ContentType.get_generic_icon_name (headers.get_content_type (null))));
                                    play_sound ("complete");
                                    multipart = null;
                                }
                            });
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

        private void dialog_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable<string, string>? query) {
            if (msg.get_method () == "POST") {
                string result = (string) msg.get_request_body ().data;
                if (result.contains ("actiondm")) {
                    var dlist = get_dl_row (StatusMode.COMPLETE);
                    if (dlist.size > 0) {
                        dlist.foreach ((row)=> {
                            if (result.contains ("linkmodeurl")) {
                                if (row.ariagid == result.slice (result.last_index_of ("+") + 1, result.last_index_of ("linkmodeurl="))) {
                                    msg.set_response ("text/html", Soup.MemoryUse.COPY, get_complete (row).data);
                                    msg.set_status (Soup.Status.OK, "OK");
                                }
                            } else if (result.contains ("linkmodehls")) {
                                var check = GLib.Checksum.compute_for_string (ChecksumType.MD5, row.url, row.url.length);
                                if (check == result.slice (result.last_index_of ("+") + 1, result.last_index_of ("linkmodehls="))) {
                                    msg.set_response ("text/html", Soup.MemoryUse.COPY, get_complete (row).data);
                                    msg.set_status (Soup.Status.OK, "OK");
                                }
                            }
                            return true;
                        });
                    }
                } else {
                    msg.set_response ("text/html", Soup.MemoryUse.COPY, get_not_found ().data);
                    msg.set_status (Soup.Status.INTERNAL_SERVER_ERROR, "Error");
                }
            }
        }

        private void home_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable<string, string>? query) {
            if (path != "/" && path != "favicon.ico") {
                if (msg.get_method () == "POST") {
                    var meseg = (string) msg.get_request_body ().data;
                    if (!meseg.contains ("+") && meseg.contains ("sort")) {
                        update_user (username, UserID.SHORTBY, meseg.split ("=")[1]);
                    }
                }
                var file = File.new_for_path (path);
                if (file.query_exists ()) {
                    var fitype = file.query_file_type (FileQueryInfoFlags.NOFOLLOW_SYMLINKS);
                    if (fitype == FileType.REGULAR) {
                        open_file.begin (msg, file);
                        return;
                    }
                }
                File filegbt = GLib.File.new_build_filename (serverdir.get_path (), path);
                var ftype = filegbt.query_file_type (FileQueryInfoFlags.NOFOLLOW_SYMLINKS);
                msg.set_status (Soup.Status.OK, "OK");
                if (ftype == FileType.DIRECTORY) {
                    directory_mode.begin (msg, filegbt, serverdir);
                    return;
                } else if (ftype == FileType.REGULAR) {
                    open_file.begin (msg, filegbt);
                    return;
                }
                if (!filegbt.query_exists ()) {
                    var pathfile = @"$(filegbt.get_parent ().get_path ().split (serverdir.get_path ())[1])/";
                    msg.set_redirect (Soup.Status.TEMPORARY_REDIRECT, pathfile == "/"? "/Home" : pathfile);
                    return;
                }
            }
            if (msg.get_method () == "POST") {
                string result = (string) msg.get_request_body ().data;
                try {
                    MatchInfo match_info;
                    Regex regex = new Regex ("link:(.*?);,filename:(.*?);,referrer:(.*?);,mimetype:(.*?);,filesize:(.*?);,resumable:(.*?);,useragent:(.*?);,header:(.*?);,");
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

        private void gabut_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable<string, string>? query) {
            string pathname = path.split ("/")[1].strip ();
            if (msg.get_method () == "POST") {
                string result = (string) msg.get_request_body ().data;
                var hashoption = new Gee.HashMap<string, string> ();
                if (Regex.match_simple ("gabutlink=(.*?)", result)) {
                    string reslink = result.replace ("gabutlink=", "").strip ();
                    if (reslink != "") {
                        if (reslink.has_prefix ("magnet:?")) {
                            hashoption[AriaOptions.BT_SAVE_METADATA.to_string ()] = "true";
                            hashoption[AriaOptions.RPC_SAVE_UPLOAD_METADATA.to_string ()] = "true";
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
                        hashoption[AriaOptions.BT_SAVE_METADATA.to_string ()] = "false";
                        hashoption[AriaOptions.RPC_SAVE_UPLOAD_METADATA.to_string ()] = "false";
                        string bencode = GLib.Base64.encode (body.get_data ());
                        if (filename.down ().has_suffix (".torrent")) {
                            address_url (bencode, hashoption, false, LinkMode.TORRENT);
                        } else if (filename.down ().has_suffix (".metalink")) {
                            address_url (bencode, hashoption, false, LinkMode.METALINK);
                        }
                    }
                    msg.set_response ("text/html", Soup.MemoryUse.COPY, get_dm (pathname, html_dm (path), javascr_dm (path), username).data);
                    msg.set_status (Soup.Status.OK, "OK");
                } else if (result.contains ("actiondm")) {
                    var typeact = result.slice (result.last_index_of ("+") + 1, result.last_index_of ("=")).split ("linkmode");
                    lserv_action (typeact);
                    msg.set_response ("text/html", Soup.MemoryUse.COPY, get_dm (pathname, html_dm (path), javascr_dm (path), username).data);
                    msg.set_status (Soup.Status.OK, "OK");
                } else if (result.contains ("actiondelete")) {
                    var typeact = result.slice (result.last_index_of ("+") + 1, result.last_index_of ("=")).split ("linkmode");
                    delete_row (typeact);
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
                if (dlist.size > 0) {
                    dlist.sort (sort_dm);
                    htmlstr = "<div class=\"append\">";
                    dlist.foreach ((row)=> {
                        htmlstr += dm_div (row, "Pause", path);
                        return true;
                    });
                    htmlstr += "</div>";
                }
            } else if (path == "/Paused") {
                var dlist = get_dl_row (StatusMode.PAUSED);
                if (dlist.size > 0) {
                    dlist.sort (sort_dm);
                    htmlstr = "<div class=\"append\">";
                    dlist.foreach ((row)=> {
                        htmlstr += dm_div (row, "Start", path);
                        return true;
                    });
                    htmlstr += "</div>";
                }
            } else if (path == "/Complete") {
                var dlist = get_dl_row (StatusMode.COMPLETE);
                if (dlist.size > 0) {
                    dlist.sort (sort_dm);
                    htmlstr = "<div class=\"append\">";
                    dlist.foreach ((row)=> {
                        htmlstr += dm_div (row, "Complete", path);
                        return true;
                    });
                    htmlstr += "</div>";
                }
            } else if (path == "/Waiting") {
                var dlist = get_dl_row (StatusMode.WAIT);
                if (dlist.size > 0) {
                    dlist.sort (sort_dm);
                    htmlstr = "<div class=\"append\">";
                    dlist.foreach ((row)=> {
                        htmlstr += dm_div (row, "Waiting", path);
                        return true;
                    });
                    htmlstr += "</div>";
                }
            } else if (path == "/Error") {
                var dlist = get_dl_row (StatusMode.ERROR);
                if (dlist.size > 0) {
                    dlist.sort (sort_dm);
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
                script += "<script> function update_progress(){";
                var dlrow = get_dl_row (StatusMode.ACTIVE);
                if (dlrow.size > 0) {
                    dlrow.sort (sort_dm);
                    dlrow.foreach ((row)=> {
                        if (row.linkmode != LinkMode.HLS) {
                            script += @"fetch(\"/Arirow\", {
                                method: \"POST\",
                                body: \"$(row.ariagid)\"
                            }).then(r => r.json()).then(data => {
                                document.getElementById(\"bar$(row.ariagid)\").style.width = (data.fraction * 100) + \"%\";
                                document.getElementById(\"label$(row.ariagid)\").innerText = data.label;
                            }).catch(() => {
                                window.location.reload();
                            });";
                        } else {
                            var check = GLib.Checksum.compute_for_string (ChecksumType.MD5, row.url, row.url.length);
                            script += @"fetch(\"/HLSrow\", {
                                method: \"POST\",
                                body: \"$(check)\"
                            }).then(r => r.json()).then(data => {
                                document.getElementById(\"bar$(check)\").style.width = (data.fraction * 100) + \"%\";
                                document.getElementById(\"label$(check)\").innerText = data.label;
                            }).catch(() => {
                                window.location.reload();
                            });";
                        }
                        return true;
                    });
                }
                script += "} setInterval(update_progress, 1000); </script>";
            }
            return script;
        }

        private void share_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable<string, string>? query) {
            if (bool.parse (get_dbsetting (DBSettings.SWITCHDIR))) {
                if (msg.get_method () == "POST") {
                    var meseg = (string) msg.get_request_body ().data;
                    if (!meseg.contains ("+") && meseg.contains ("sort")) {
                        update_user (username, UserID.SHORTBY, meseg.split ("=")[1]);
                    }
                }
                if (!serverdir.query_exists ()) {
                    msg.set_response ("text/html", Soup.MemoryUse.COPY, get_not_found ().data);
                    msg.set_status (Soup.Status.OK, "OK");
                    return;
                }
                msg.set_status (Soup.Status.OK, _("OK"));
                directory_mode.begin (msg, serverdir, serverdir);
            } else {
                msg.set_response ("text/html", Soup.MemoryUse.COPY, get_not_found ().data);
                msg.set_status (Soup.Status.OK, "OK");
            }
        }

       private string dm_div (DownloadRow? row, string action, string path) {
            double fraction = ((double) row.transferred / (double) row.totalsize);
            var check = GLib.Checksum.compute_for_string (ChecksumType.MD5, row.url, row.url.length);
            var sbuilder = "<div class=\"dm-item\">";
            string mime_class = row.fileordir != null ? get_mime_css (row.fileordir) : "file";
            sbuilder += @"<div class=\"dm-icon $(mime_class)\"></div>";
            sbuilder += "<div class=\"dm-info\">";
            if (row.filename != null) {
                sbuilder += @"<div class=\"dm-name\" title=\"$(row.pathname ?? "")\">$(row.filename)</div>";
            } else {
                sbuilder += "<div class=\"dm-name dm-loading\">Loading information…</div>";
            }
            if (row.totalsize > 0) {
                double pct = fraction * 100.0;
                sbuilder += "<div class=\"dm-progress\"><div class=\"dm-progress-track\">";
                sbuilder += @"<div class=\"dm-progress-fill\" id=\"bar$(row.ariagid)\" style=\"width:$(pct)%\"></div>";
                sbuilder += "</div></div>";
            } else if (row.linkmode == LinkMode.HLS) {
                sbuilder += "<div class=\"dm-progress\"><div class=\"dm-progress-track\">";
                sbuilder += @"<div class=\"dm-progress-fill\" id=\"bar$(check)\" style=\"width:$(row.fraction * 100)%\"></div>";
                sbuilder += "</div></div>";
            } else {
                sbuilder += "<div class=\"dm-progress\"><div class=\"dm-progress-track\">";
                sbuilder += "<div class=\"dm-progress-fill dm-indeterminate\"></div>";
                sbuilder += "</div></div>";
            }
            if (row.labeltransfer != null) {
                if (path == "/Downloading") {
                    string label_id = row.linkmode != LinkMode.HLS ? @"label$(row.ariagid)" : @"label$(check)";
                    sbuilder += @"<div class=\"dm-label\" id=\"$(label_id)\"></div>";
                } else {
                    sbuilder += @"<div class=\"dm-label\">$(row.labeltransfer.to_ascii ())</div>";
                }
            } else {
                sbuilder += "<div class=\"dm-label dm-loading\">Loading file…</div>";
            }
            sbuilder += "</div>";
            sbuilder += "<div class=\"dm-actions\">";
            string del_name  = row.linkmode != LinkMode.HLS ? @"actiondelete $(row.ariagid)linkmodeurl"  : @"actiondelete $(check)linkmodehls";
            string act_name  = row.linkmode != LinkMode.HLS ? @"actiondm $(row.ariagid)linkmodeurl"       : @"actiondm $(check)linkmodehls";
            string act_path  = action != "Complete" ? path : "/Dialog";
            sbuilder += @"<form action=\"$(path)\" method=\"post\">";
            sbuilder += @"<button class=\"dm-btn dm-btn-del\" type=\"submit\" name=\"$(del_name)\" value=\"Delete\" title=\"Delete\">";
            sbuilder += "<svg viewBox=\"0 0 16 16\"><polyline points=\"2,4 14,4\"/><path d=\"M5 4V2h6v2\"/><path d=\"M6 7v5M10 7v5\"/><rect x=\"3\" y=\"4\" width=\"10\" height=\"10\" rx=\"1.5\"/></svg>";
            sbuilder += "</button></form>";
            string act_icon = "";
            string act_class = "dm-btn-act";
            if (action == "Pause") {
                act_icon = "<svg viewBox=\"0 0 16 16\"><rect x=\"4\" y=\"3\" width=\"3\" height=\"10\" rx=\"1\"/><rect x=\"9\" y=\"3\" width=\"3\" height=\"10\" rx=\"1\"/></svg>";
            } else if (action == "Start") {
                act_icon = "<svg viewBox=\"0 0 16 16\"><path d=\"M5 3l8 5-8 5V3z\"/></svg>";
            } else if (action == "Complete") {
                act_icon = "<svg viewBox=\"0 0 16 16\"><polyline points=\"3,8 7,12 13,4\"/></svg>";
                act_class = "dm-btn-done";
            } else if (action == "Waiting") {
                act_icon = "<svg viewBox=\"0 0 16 16\"><circle cx=\"8\" cy=\"8\" r=\"6\"/><polyline points=\"8,5 8,8 10,10\"/></svg>";
                act_class = "dm-btn-wait";
            } else if (action == "Error") {
                act_icon = "<svg viewBox=\"0 0 16 16\"><circle cx=\"8\" cy=\"8\" r=\"6\"/><line x1=\"8\" y1=\"5\" x2=\"8\" y2=\"9\"/><circle cx=\"8\" cy=\"11\" r=\"0.5\" fill=\"currentColor\"/></svg>";
                act_class = "dm-btn-err";
            }
            sbuilder += @"<form action=\"$(act_path)\" method=\"post\">";
            sbuilder += @"<button class=\"dm-btn $(act_class)\" type=\"submit\" name=\"$(act_name)\" value=\"$(action)\" title=\"$(action)\">";
            sbuilder += act_icon;
            sbuilder += "</button></form>";
            sbuilder += "</div>";
            sbuilder += "</div>\n";
            return sbuilder;
        }

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
                fsorter.date = info.get_access_date_time ().to_string ();
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
            } else if (fileordir) {
                sbuilder += @"<a class=\"icon folder\" href=\"$(GLib.Uri.unescape_string (path))\"></a>";
            } else {
                sbuilder += @"<a class=\"icon $(get_mime_css (mime))\" href=\"$(GLib.Uri.unescape_string (path))\"></a>";
            }
            if (fileinfo != null) {
                string href_path   = GLib.Uri.unescape_string (path);
                string link_target;
                var basename = File.new_for_path (path).get_basename ().down ();
                bool open_in_player = !fileordir && (mimeisplay (mime) || nameisplay (basename));
                if (open_in_player) {
                    link_target = "/Player?path=" + GLib.Uri.escape_string (href_path, "", true);
                } else {
                    link_target = href_path;
                }
                sbuilder += @"<div class=\"col-name\"><a title=\"$(fileinfo.get_name ())\" href=\"$(link_target)\">$(fileinfo.get_name ())</a></div>";

                if (goback) {
                    sbuilder += "<div class=\"col-type\">—</div>";
                } else if (fileordir) {
                    sbuilder += "<div class=\"col-type\">Folder</div>";
                } else {
                    var type_label = mime.replace ("application/", "").replace ("image/", "").replace ("video/", "").replace ("audio/", "").replace ("text/", "").up ();
                    if (type_label.length > 10) {
                        type_label = type_label.substring (0, 10);
                    }
                    sbuilder += @"<div class=\"col-type\">$(type_label)</div>";
                }

                if (!fileordir) {
                    sbuilder += @"<div class=\"col-size\">$(GLib.format_size (size).to_ascii ())</div>";
                } else {
                    authenti.add_path (path);
                    sbuilder += @"<div class=\"col-size\">$(infolder != 0 ? infolder.to_string () + " items" : "Empty")</div>";
                }

                sbuilder += @"<div class=\"col-date\">$(fileinfo.get_access_date_time ().format ("%b %d, %Y  %I:%M %p"))</div>";
            } else {
                sbuilder += "<div class=\"col-name\"><a href=\"" + GLib.Uri.unescape_string (path) + "\">Go Up</a></div>";
                sbuilder += "<div class=\"col-type\">—</div>";
                sbuilder += "<div class=\"col-size\">—</div>";
                sbuilder += "<div class=\"col-date\">—</div>";
            }
            sbuilder += "</div>\n";
            return sbuilder;
        }

        private void player_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable<string, string>? query) {
            if (username == null) {
                msg.set_redirect (Soup.Status.TEMPORARY_REDIRECT, "/Home");
                return;
            }
            string? file_path = null;
            if (query != null) {
                file_path = query.get ("path");
            }
            if (file_path == null || file_path == "") {
                msg.set_status (Soup.Status.BAD_REQUEST, "BAD");
                return;
            }
            var file = File.new_for_path (file_path);
            if (!file.query_exists ()) {
                file = File.new_for_path (serverdir.get_path () + file_path);
            }
            if (!file.query_exists ()) {
                msg.set_status (Soup.Status.NOT_FOUND, "NOT FOUND");
                return;
            }
            try {
                FileInfo info = file.query_info ("standard::*", GLib.FileQueryInfoFlags.NOFOLLOW_SYMLINKS);
                var mime = info.get_content_type ();
                var filename = info.get_name ();
                var resolved_path = file.get_path ();
                string html;
                if (mime.has_prefix ("image/")) {
                    html = get_image_page (file_path, filename, mime);
                } else if (mime == "application/pdf") {
                    html = get_pdf_page (file_path, filename);
                } else if (((is_text_mime (mime) || is_text_ext (filename))) && (!filename.has_suffix (".ts") && !filename.has_suffix (".m3u8"))) {
                    html = get_text_page (file_path, filename, mime, msg);
                } else if (filename.down ().has_suffix (".torrent")) {
                    uint8[] content;
                    file.load_contents (null, out content, null);
                    html = get_torrent_page (resolved_path, filename, content);
                } else if (mime_is_doc (mime) || name_is_doc (filename.down ())) {
                    html = get_word_page (file_path, filename);
                } else if (is_excel_ext (filename)) {
                    html = get_excel_page (resolved_path, filename);
                } else if (is_archive_mime (mime) || is_archive_ext (filename)) {
                    html = get_archive_page (file_path, filename, mime);
                } else if (mime.has_prefix ("audio/") || is_audio_ext (filename)) {
                    html = get_audio_page (resolved_path, filename, mime);
                } else if (is_pptx_ext (filename)) {
                    html = get_pptx_page (resolved_path, filename);
                } else {
                    html = get_video_page (file_path, filename, mime);
                }
                msg.set_response ("text/html", Soup.MemoryUse.COPY, html.data);
                msg.set_status (Soup.Status.OK, "OK");
            } catch (Error e) {
                msg.set_status (Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }

        private void rawori_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable<string, string>? query) {
            string? file_path = null;
            if (query != null) {
                file_path = query.get ("path");
            }
            if (file_path == null || file_path == "") {
                msg.set_status (Soup.Status.BAD_REQUEST, "Bad Request");
                return;
            }
            var file = File.new_for_path (file_path);
            if (!file.query_exists ()) {
                file = File.new_for_path (serverdir.get_path () + file_path);
            }
            if (!file.query_exists ()) {
                msg.set_status (Soup.Status.NOT_FOUND, "Not Found");
                return;
            }
            open_file.begin (msg, file);
        }

        private void rawpix_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable<string, string>? query) {
            string? file_path = null;
            if (query != null) {
                file_path = query.get ("path");
            }
            if (file_path == null || file_path == "") {
                msg.set_status (Soup.Status.BAD_REQUEST, "Bad Request");
                return;
            }
            var file = File.new_for_path (file_path);
            if (!file.query_exists ()) {
                file = File.new_for_path (serverdir.get_path () + file_path);
            }
            if (!file.query_exists ()) {
                msg.set_status (Soup.Status.NOT_FOUND, "Not Found");
                return;
            }
            try {
                var pixbuf = new Gdk.Pixbuf.from_file (file.get_path ());
                uint8[] png_data;
                pixbuf.save_to_buffer (out png_data, "png");
                var res_headers = msg.get_response_headers ();
                res_headers.set_content_type ("image/png", null);
                res_headers.set_content_length (png_data.length);
                msg.set_status (Soup.Status.OK, "OK");
                msg.set_response ("image/png", Soup.MemoryUse.COPY, png_data);
            } catch (Error e) {
                msg.set_status (Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }

        private void dir_list_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable<string, string>? query) {
            file_in_dir.begin (server, msg, path, query, ServerType.AUDIO);
        }

        private void dir_list_video_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable<string, string>? query) {
            file_in_dir.begin (server, msg, path, query, ServerType.VIDEO);
        }

        private void dir_list_image_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable<string, string>? query) {
            file_in_dir.begin (server, msg, path, query, ServerType.IMG);
        }

        private async void file_in_dir (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable<string, string>? query, ServerType servtype) throws Error {
            if (username == null) {
                msg.set_redirect (Soup.Status.TEMPORARY_REDIRECT, "/Home");
                return;
            }
            if (query == null) {
                msg.set_status (400, "");
                return;
            }
            var dir_path = query.get ("path");
            if (dir_path == null) {
                msg.set_status (400, "");
                return;
            }
            var dir = File.new_for_path (dir_path);
            if (!dir.query_exists ()) {
                dir = File.new_for_path (serverdir.get_path () + dir_path);
            } else if (dir.query_exists () && dir.get_path () == "/") {
                dir = File.new_for_path (serverdir.get_path () + dir_path);
            }
            if (!dir.query_exists ()) {
                msg.set_status (404, "");
                return;
            }
            var filesorters = new Gee.ArrayList<FSorter?> ();
            var json  = new StringBuilder ();
            json.append ("[");
            bool first = true;
            GLib.FileEnumerator enumerator = dir.enumerate_children ("*", GLib.FileQueryInfoFlags.NOFOLLOW_SYMLINKS);
            GLib.FileInfo fi;
            while (enumerator.iterate (out fi, null) && fi != null) {
                if (fi.get_is_hidden ()) {
                    continue;
                }
                var mime = fi.get_content_type () ?? "";
                var name = fi.get_name ();
                var fsorter = FSorter ();
                fsorter.name = name;
                fsorter.mimetype = mime;
                fsorter.fileordir = false;
                fsorter.size = fi.get_size ();
                fsorter.fileindir = 0;
                fsorter.fileinfo = fi;
                fsorter.date = fi.get_access_date_time ().to_string ();
                if (servtype == ServerType.IMG) {
                    bool is_img = mime.has_prefix ("image/");
                    if (is_img) {
                        filesorters.add (fsorter);
                    }
                } else if (servtype == ServerType.VIDEO) {
                    bool is_video = mime.has_prefix ("video/") || is_video_ext (name);
                    if (is_video) {
                        filesorters.add (fsorter);
                    }
                } else {
                    bool is_audio = mime.has_prefix ("audio/") || is_audio_ext (name);
                    if (is_audio) {
                        filesorters.add (fsorter);
                    }
                }
            }
            filesorters.sort ((GLib.CompareDataFunc) sort_sfile);
            foreach (var filesr in filesorters) {
                if (!first) {
                    json.append (",");
                }
                first = false;
                var fpath = GLib.Path.build_filename (dir.get_path (), filesr.name);
                var enc = GLib.Uri.escape_string (fpath, "", true);
                json.append ("{\"name\":\"" + filesr.name.replace ("\\","\\\\").replace ("\"","\\\"") + "\",\"path\":\"" + enc + "\"}");
            }
            json.append ("]");
            msg.set_response ("application/json", Soup.MemoryUse.COPY, json.str.data);
            msg.set_status (200, "OK");
        }

        private void torrent_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable<string, string>? query) {
            if (username == null) {
                msg.set_status (Soup.Status.UNAUTHORIZED, "Unauthorized");
                return;
            }
            if (msg.get_request_headers ().get_content_type (null) == Soup.FORM_MIME_TYPE_MULTIPART) {
                var multipart = new Soup.Multipart.from_message (msg.get_request_headers () , msg.get_request_body ().flatten ());
                Soup.MessageHeaders headers;
                GLib.Bytes body;
                multipart.get_part (0, out headers, out body);
                GLib.HashTable<string, string> params;
                headers.get_content_disposition (null, out params);
                string filename = params.get ("filename");
                if (filename != null && filename != "") {
                    if (filename.down ().has_suffix (".torrent")) {
                        var html = get_torrent_page (path, filename, body.get_data ());
                        msg.set_response ("text/html", Soup.MemoryUse.COPY, html.data);
                        msg.set_status (Soup.Status.OK, "OK");
                    }
                }
            } else {
                msg.set_status (Soup.Status.INTERNAL_SERVER_ERROR, "Error");
            }
        }

        private void pdfjs_lib_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable<string, string>? query) {
            serve_pdfjs_file.begin (msg, file_config (".pdf.min.js"), "https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.min.js", "application/javascript");
        }
        private void pdfjs_worker_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable<string, string>? query) {
            serve_pdfjs_file.begin (msg, file_config (".pdf.worker.min.js"), "https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.worker.min.js", "application/javascript");
        }
        private void mammoth_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable<string, string>? query) {
            serve_pdfjs_file.begin (msg, file_config (".mammoth.browser.min.js"), "https://cdnjs.cloudflare.com/ajax/libs/mammoth/1.6.0/mammoth.browser.min.js", "application/javascript");
        }
        private void sheetjs_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable<string, string>? query) {
            serve_pdfjs_file.begin (msg, file_config (".xlsx.full.min.js"), "https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js", "application/javascript");
        }
        private void libarchive_js_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable<string, string>? query) {
            serve_pdfjs_file.begin (msg, file_config (".libarchive.js"), "https://unpkg.com/libarchive.js/dist/libarchive.js", "application/javascript");
        }
        private void worker_archive_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable<string, string>? query) {
            serve_pdfjs_file.begin (msg, file_config (".worker-bundle.js"), "https://unpkg.com/libarchive.js/dist/worker-bundle.js", "application/javascript");
        }
        private void play_hls_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable<string, string>? query) {
            serve_pdfjs_file.begin (msg, file_config (".hls.min.js"), "https://cdnjs.cloudflare.com/ajax/libs/hls.js/1.5.13/hls.min.js", "application/javascript");
        }
        private void play_mpeg_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable<string, string>? query) {
            serve_pdfjs_file.begin (msg, file_config (".mpegts.min.js"), "https://cdn.jsdelivr.net/npm/mpegts.js@1.8.0/dist/mpegts.min.js", "application/javascript");
        }
        private void play_mpg_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable<string, string>? query) {
            serve_pdfjs_file.begin (msg, file_config (".mpeg.play.js"), "https://cdn.jsdelivr.net/npm/jsmpeg@1.0.0/jsmpg.min.js", "application/javascript");
        }
        private void jsmediatags_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable<string, string>? query) {
            serve_pdfjs_file.begin (msg, file_config (".jsmediatags.min.js"), "https://cdnjs.cloudflare.com/ajax/libs/jsmediatags/3.9.5/jsmediatags.min.js", "application/javascript");
        }
        private void jsjzip_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable<string, string>? query) {
            serve_pdfjs_file.begin (msg, file_config (".jszip.min.js"), "https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js", "application/javascript");
        }
        private void wasm_archive_handler (Soup.Server server, Soup.ServerMessage msg, string path, GLib.HashTable<string, string>? query) {
            serve_pdfjs_file.begin (msg, file_config (".libarchive.wasm"), "https://cdn.jsdelivr.net/npm/libarchive.js@2.0.2/dist/libarchive.wasm", "application/wasm");
        }

        private async void serve_pdfjs_file (Soup.ServerMessage msg, string file_path, string fallback_url, string content_type) throws Error {
            var file = File.new_for_path (file_path);
            if (file.query_exists ()) {
                uint8[] data;
                file.load_contents (null, out data, null);
                msg.set_response (content_type, Soup.MemoryUse.COPY, data);
                msg.set_status (200, "OK");
            } else {
                fetch_data.begin (fallback_url, file_path);
                msg.set_redirect (Soup.Status.TEMPORARY_REDIRECT, fallback_url);
            }
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

        public string get_address () {
            var uris = this.get_uris ();
            if (uris != null && uris.length () > 0) {
                var uri = uris.nth_data (0);
                string host = uri.get_host ();
                int port = uri.get_port ();
                if (host == "0.0.0.0" || host == "::") {
                    host = get_local_address ();
                }
                return @"$(uri.get_scheme ())://$(host):$(port)";
            }
            return @"http://$(get_local_address ())";
        }
    }
}