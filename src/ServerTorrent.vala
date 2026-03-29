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
    private string get_torrent_page (string file_path, string filename, uint8[] contents) {
        TorrentInfo? info = TorrentParser.parsetorrent (contents);
        if (info == null) {
            return get_not_found ();
        }
        var files = new Gee.ArrayList<TorrentFile?> ();
        server_torr_files (info.files, files);
        var comment = info.comment;
        var created_by = info.created_by;
        string created_at = "";
        var cd = info.creation_date;
        if (cd > 0) {
            var dt = new GLib.DateTime.from_unix_local (cd);
            created_at = dt.format ("%B %d, %Y %H:%M");
        }
        var name = info.name;
        var total_size = info.total_size;
        int num_pieces = info.num_pieces;
        bool is_private = info.trprivate == 1;
        var piece_len = info.piece_length;

        var raw_src = "/Rawori?path=" + GLib.Uri.escape_string (file_path, "", true);
        var size_str = GLib.format_size (total_size).to_ascii ();

        var file_rows = new StringBuilder ();
        foreach (var f in files) {
            if (f == null) {
                continue;
            };
            var fclass = get_mime_css_from_name (f.name);
            var fbase  = Path.get_basename (f.name);
            var fdir   = Path.get_dirname (f.name);
            if (fdir == ".") {
                fdir = "";
            }
            file_rows.append (@"<div class=\"arc-row\"><div class=\"arc-icon $(fclass)\"></div><div class=\"arc-name\"><span class=\"arc-basename\">$(GLib.Markup.escape_text (fbase))</span>");
            if (fdir != "") {
                file_rows.append (@"<span class=\"arc-dir\">$(GLib.Markup.escape_text (fdir))</span>");
            }
            file_rows.append (@"</div><span class=\"arc-fsize\">$(GLib.format_size (f.size).to_ascii ())</span></div>\n");
        }

        var tracker_rows = new StringBuilder ();
        var seen = new Gee.HashSet<string> ();
        foreach (string t in info.announce_list) {
            if (t == "" || seen.contains (t)) {
                continue;
            }
            seen.add (t);
            tracker_rows.append (@"<div class=\"trk-row\"><span class=\"trk-dot\"></span><span class=\"trk-url\">$(GLib.Markup.escape_text (t))</span></div>\n");
        }

        return """<!DOCTYPE html>
        <html lang="en">
        <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>""" + GLib.Markup.escape_text (filename) + """</title>
        <style>
        *{margin:0;padding:0;box-sizing:border-box;}
        body{
        background:#0a0a0a;color:#fff;
        font-family:Inter,system-ui,sans-serif;
        min-height:100vh;display:flex;flex-direction:column;
        overflow-x:hidden;
        }
        .bg-glow{position:fixed;inset:0;z-index:0;pointer-events:none;overflow:hidden;}
        .bg-glow::before{content:'';position:absolute;width:500px;height:500px;border-radius:50%;background:radial-gradient(circle,rgba(52,211,153,0.07) 0%,transparent 70%);top:-180px;right:-180px;animation:gd1 13s ease-in-out infinite alternate;}
        .bg-glow::after{content:'';position:absolute;width:450px;height:450px;border-radius:50%;background:radial-gradient(circle,rgba(96,165,250,0.06) 0%,transparent 70%);bottom:-160px;left:-160px;animation:gd2 15s ease-in-out infinite alternate;}
        @keyframes gd1{from{transform:translate(0,0) scale(1);}to{transform:translate(-40px,50px) scale(1.15);}}
        @keyframes gd2{from{transform:translate(0,0) scale(1);}to{transform:translate(50px,-40px) scale(1.2);}}
        header{
        position:sticky;top:0;z-index:100;width:100%;
        background:rgba(10,10,10,0.88);
        backdrop-filter:blur(24px) saturate(1.8);
        -webkit-backdrop-filter:blur(24px) saturate(1.8);
        border-bottom:0.5px solid rgba(255,255,255,0.07);
        padding:0 20px;height:52px;
        display:flex;align-items:center;gap:10px;
        }
        header a{color:#888;text-decoration:none;font-size:13px;flex-shrink:0;}
        header a:hover{color:#fff;}
        .hd-title{color:#fff;font-size:14px;font-weight:500;flex:1;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
        .trk-badge{font-size:10px;font-weight:600;background:rgba(52,211,153,0.15);color:#34d399;border-radius:999px;padding:2px 10px;flex-shrink:0;}
        .main{flex:1;padding:16px 20px;max-width:960px;width:100%;margin:0 auto;position:relative;z-index:1;display:flex;flex-direction:column;gap:16px;}

        /* Info card */
        .info-card{
        background:rgba(255,255,255,0.03);border:0.5px solid rgba(255,255,255,0.08);
        border-radius:18px;overflow:hidden;
        }
        .info-banner{
        background:rgba(52,211,153,0.07);
        border-bottom:0.5px solid rgba(52,211,153,0.12);
        padding:18px 20px;display:flex;align-items:center;gap:14px;
        }
        .banner-icon{
        width:46px;height:46px;border-radius:14px;
        background:rgba(52,211,153,0.15);
        display:flex;align-items:center;justify-content:center;flex-shrink:0;
        }
        .banner-icon svg{width:22px;height:22px;stroke:#34d399;fill:none;stroke-width:1.6;stroke-linecap:round;stroke-linejoin:round;}
        .banner-name{font-size:15px;font-weight:600;color:#fff;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
        .banner-sub{font-size:12px;color:rgba(255,255,255,0.35);margin-top:3px;}
        .banner-actions{margin-left:auto;display:flex;gap:8px;flex-shrink:0;}
        .btn-action{
        display:inline-flex;align-items:center;gap:6px;
        border-radius:999px;padding:8px 16px;
        font-size:12px;font-weight:500;font-family:inherit;
        cursor:pointer;text-decoration:none;flex-shrink:0;
        transition:background 0.15s;border:0.5px solid;
        }
        .btn-dl{background:rgba(52,211,153,0.1);border-color:rgba(52,211,153,0.25);color:#34d399;}
        .btn-dl:hover{background:rgba(52,211,153,0.18);}
        .btn-dl svg{width:13px;height:13px;stroke:currentColor;fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round;}
        .info-grid{
        display:grid;grid-template-columns:1fr 1fr;
        gap:0;
        }
        .info-cell{
        padding:14px 20px;
        border-bottom:0.5px solid rgba(255,255,255,0.05);
        border-right:0.5px solid rgba(255,255,255,0.05);
        }
        .info-cell:nth-child(even){border-right:none;}
        .info-cell:nth-last-child(-n+2){border-bottom:none;}
        .info-label{font-size:10px;font-weight:600;color:rgba(255,255,255,0.25);text-transform:uppercase;letter-spacing:0.07em;margin-bottom:5px;}
        .info-value{font-size:13px;font-weight:500;color:#fff;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
        .info-value.green{color:#34d399;}
        .info-value.red{color:#f87171;}
        .info-cell.full{grid-column:1/-1;border-right:none;}

        /* Section */
        .section-title{
        font-size:11px;font-weight:600;color:rgba(255,255,255,0.3);
        text-transform:uppercase;letter-spacing:0.07em;
        margin-bottom:8px;display:flex;align-items:center;gap:8px;
        }
        .section-title span{
        background:rgba(255,255,255,0.08);border-radius:999px;
        padding:1px 8px;font-size:11px;color:rgba(255,255,255,0.4);
        }

        /* File list */
        .arc-list{background:rgba(255,255,255,0.02);border:0.5px solid rgba(255,255,255,0.07);border-radius:14px;overflow:hidden;}
        .arc-row{display:flex;align-items:center;gap:10px;padding:9px 14px;border-bottom:0.5px solid rgba(255,255,255,0.04);transition:background 0.1s;}
        .arc-row:last-child{border-bottom:none;}
        .arc-row:hover{background:rgba(255,255,255,0.04);}
        .arc-row.hidden{display:none;}
        .arc-icon{width:26px;height:26px;border-radius:7px;flex-shrink:0;display:flex;align-items:center;justify-content:center;}
        .arc-icon::before{content:'';display:block;width:14px;height:14px;mask-size:contain;mask-repeat:no-repeat;mask-position:center;-webkit-mask-size:contain;-webkit-mask-repeat:no-repeat;-webkit-mask-position:center;}
        .arc-icon.folder{background:rgba(96,165,250,0.12);}
        .arc-icon.folder::before{background:#60a5fa;mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M1 3.5A1.5 1.5 0 012.5 2h3.086a1.5 1.5 0 011.06.44l.915.914A1.5 1.5 0 008.62 4H13.5A1.5 1.5 0 0115 5.5v7A1.5 1.5 0 0113.5 14h-11A1.5 1.5 0 011 12.5z'/%3E%3C/svg%3E");-webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M1 3.5A1.5 1.5 0 012.5 2h3.086a1.5 1.5 0 011.06.44l.915.914A1.5 1.5 0 008.62 4H13.5A1.5 1.5 0 0115 5.5v7A1.5 1.5 0 0113.5 14h-11A1.5 1.5 0 011 12.5z'/%3E%3C/svg%3E");}
        .arc-icon.video{background:rgba(251,146,60,0.12);}
        .arc-icon.video::before{background:#fb923c;mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Crect x='1' y='3' width='10' height='10' rx='1.5'/%3E%3Cpath d='M11 6l4-2v8l-4-2z'/%3E%3C/svg%3E");-webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Crect x='1' y='3' width='10' height='10' rx='1.5'/%3E%3Cpath d='M11 6l4-2v8l-4-2z'/%3E%3C/svg%3E");}
        .arc-icon.image{background:rgba(52,211,153,0.12);}
        .arc-icon.image::before{background:#34d399;mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Crect x='1' y='1' width='14' height='14' rx='2' fill='none' stroke='%23000' stroke-width='1.2'/%3E%3Ccircle cx='5.5' cy='5.5' r='1.5'/%3E%3Cpath d='M1 11l4-4 3 3 2-2 4 4'/%3E%3C/svg%3E");-webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Crect x='1' y='1' width='14' height='14' rx='2' fill='none' stroke='%23000' stroke-width='1.2'/%3E%3Ccircle cx='5.5' cy='5.5' r='1.5'/%3E%3Cpath d='M1 11l4-4 3 3 2-2 4 4'/%3E%3C/svg%3E");}
        .arc-icon.audio{background:rgba(167,139,250,0.12);}
        .arc-icon.audio::before{background:#a78bfa;mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M6 2l6 2v3l-6-2v6a2 2 0 11-1.5-1.94V4.5z'/%3E%3C/svg%3E");-webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M6 2l6 2v3l-6-2v6a2 2 0 11-1.5-1.94V4.5z'/%3E%3C/svg%3E");}
        .arc-icon.pdf{background:rgba(248,113,113,0.12);}
        .arc-icon.pdf::before{background:#f87171;mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M4 0h5.5L13 3.5V14a2 2 0 01-2 2H4a2 2 0 01-2-2V2a2 2 0 012-2z'/%3E%3C/svg%3E");-webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M4 0h5.5L13 3.5V14a2 2 0 01-2 2H4a2 2 0 01-2-2V2a2 2 0 012-2z'/%3E%3C/svg%3E");}
        .arc-icon.code{background:rgba(251,191,36,0.12);}
        .arc-icon.code::before{background:#fbbf24;mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='none'%3E%3Cpath d='M5 4L1 8l4 4M11 4l4 4-4 4M9 2l-2 12' stroke='%23000' stroke-width='1.4' stroke-linecap='round'/%3E%3C/svg%3E");-webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='none'%3E%3Cpath d='M5 4L1 8l4 4M11 4l4 4-4 4M9 2l-2 12' stroke='%23000' stroke-width='1.4' stroke-linecap='round'/%3E%3C/svg%3E");}
        .arc-icon.text{background:rgba(148,163,184,0.1);}
        .arc-icon.text::before{background:rgba(148,163,184,0.7);mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='none'%3E%3Cpath d='M2 4h12M2 7h12M2 10h8' stroke='%23000' stroke-width='1.4' stroke-linecap='round'/%3E%3C/svg%3E");-webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='none'%3E%3Cpath d='M2 4h12M2 7h12M2 10h8' stroke='%23000' stroke-width='1.4' stroke-linecap='round'/%3E%3C/svg%3E");}
        .arc-icon.file{background:rgba(255,255,255,0.06);}
        .arc-icon.file::before{background:rgba(255,255,255,0.35);mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M4 1.5A1.5 1.5 0 015.5 0h5.086a1.5 1.5 0 011.06.44l2.915 2.914A1.5 1.5 0 0115 4.414V14.5A1.5 1.5 0 0113.5 16h-8A1.5 1.5 0 014 14.5z'/%3E%3C/svg%3E");-webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M4 1.5A1.5 1.5 0 015.5 0h5.086a1.5 1.5 0 011.06.44l2.915 2.914A1.5 1.5 0 0115 4.414V14.5A1.5 1.5 0 0113.5 16h-8A1.5 1.5 0 014 14.5z'/%3E%3C/svg%3E");}
        .arc-name{flex:1;min-width:0;}
        .arc-basename{font-size:13px;color:#fff;display:block;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
        .arc-dir{font-size:11px;color:rgba(255,255,255,0.3);display:block;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
        .arc-fsize{font-size:11px;color:rgba(255,255,255,0.3);flex-shrink:0;font-variant-numeric:tabular-nums;}
        /* Ganti kedua .trk-list jadi satu ini saja */
        .trk-list{
        background:rgba(255,255,255,0.02);
        border:0.5px solid rgba(255,255,255,0.07);
        border-radius:14px;
        overflow:hidden;
        max-height:100px;
        overflow-y:auto;
        }
        .trk-list::-webkit-scrollbar{width:4px;}
        .trk-list::-webkit-scrollbar-track{background:transparent;}
        .trk-list::-webkit-scrollbar-thumb{background:rgba(255,255,255,0.12);border-radius:999px;}
        .trk-list::-webkit-scrollbar-thumb:hover{background:rgba(255,255,255,0.22);}
        .trk-row{display:flex;align-items:center;gap:10px;padding:9px 14px;border-bottom:0.5px solid rgba(255,255,255,0.04);}
        .trk-row:last-child{border-bottom:none;}
        .trk-dot{width:6px;height:6px;border-radius:50%;background:#34d399;flex-shrink:0;}
        .trk-url{font-size:12px;color:rgba(255,255,255,0.5);overflow:hidden;text-overflow:ellipsis;white-space:nowrap;font-family:monospace;}
        .arc-list{
        background:rgba(255,255,255,0.02);
        border:0.5px solid rgba(255,255,255,0.07);
        border-radius:14px;
        overflow:hidden;
        max-height:150px;
        overflow-y:auto;
        }
        .arc-list::-webkit-scrollbar{width:4px;}
        .arc-list::-webkit-scrollbar-track{background:transparent;}
        .arc-list::-webkit-scrollbar-thumb{background:rgba(255,255,255,0.12);border-radius:999px;}
        .arc-list::-webkit-scrollbar-thumb:hover{background:rgba(255,255,255,0.22);}
        /* Search */
        .search-wrap{position:relative;margin-bottom:8px;}
        .search-wrap svg{position:absolute;left:12px;top:50%;transform:translateY(-50%);width:14px;height:14px;stroke:rgba(255,255,255,0.3);fill:none;stroke-width:1.7;stroke-linecap:round;pointer-events:none;}
        #search{width:100%;padding:8px 12px 8px 34px;background:rgba(255,255,255,0.05);border:0.5px solid rgba(255,255,255,0.1);border-radius:10px;color:#fff;font-size:13px;font-family:inherit;transition:border-color 0.15s;}
        #search:focus{outline:none;border-color:rgba(255,255,255,0.25);}
        #search::placeholder{color:rgba(255,255,255,0.2);}
        .no-result{display:none;padding:28px;text-align:center;font-size:13px;color:rgba(255,255,255,0.25);}
        @media(max-width:480px){
        .info-grid{grid-template-columns:1fr;}
        .info-cell:nth-child(even){border-right:none;}
        .info-cell.full{grid-column:1;}
        .info-banner{flex-direction:column;align-items:flex-start;gap:12px;}
        .banner-actions{margin-left:0;width:100%;}
        .btn-action{width:100%;justify-content:center;}
        }
        .info-banner{
        background:rgba(52,211,153,0.07);
        border-bottom:0.5px solid rgba(52,211,153,0.12);
        padding:18px 20px;display:flex;align-items:center;gap:14px;
        flex-direction:row;
        }
        .banner-actions{margin-left:auto;display:flex;gap:8px;flex-shrink:0;}
        </style>
        </head>
        <body>
        <div class="bg-glow"></div>
        <header>
        <a href="javascript:history.back()">&#8592; Back</a>
        <span class="hd-title">""" + GLib.Markup.escape_text (filename) + """</span>
        <span class="trk-badge">Torrent</span>
        </header>
        <div class="main">
        <!-- Info card -->
        <div class="info-card">
            <div class="info-banner">
            <div class="banner-icon">
                <svg viewBox="0 0 22 22"><circle cx="11" cy="11" r="9"/><polyline points="11,7 11,11 14,14"/><path d="M7 3.5A9 9 0 0117 6"/></svg>
            </div>
            <div style="flex:1;min-width:0;">
                <div class="banner-name">""" + GLib.Markup.escape_text (name != "" ? name : filename) + """</div>
            </div>
        <div class="banner-actions">
                <button class="btn-action btn-dl" id="btn-add-dm" onclick="addToDM()">
                <svg viewBox="0 0 13 13"><polyline points="6.5,2 6.5,9"/><polyline points="3,6 6.5,10 10,6"/><line x1="2" y1="12" x2="11" y2="12"/></svg>
                Add to Download
                </button>
            </div>
            </div>
            <div class="info-grid">
            <div class="info-cell">
                <div class="info-label">Total Size</div>
                <div class="info-value">""" + size_str + """</div>
            </div>
            <div class="info-cell">
                <div class="info-label">Files</div>
                <div class="info-value">""" + files.size.to_string () + """</div>
            </div>
            <div class="info-cell">
                <div class="info-label">Piece Size</div>
                <div class="info-value">""" + (piece_len > 0 ? GLib.format_size (piece_len).to_ascii () : "—") + """</div>
            </div>
            <div class="info-cell">
                <div class="info-label">Pieces</div>
                <div class="info-value">""" + (num_pieces > 0 ? num_pieces.to_string () : "—") + """</div>
            </div>
            <div class="info-cell">
                <div class="info-label">Private</div>
                <div class="info-value """ + (is_private ? "red" : "green") + """">""" + (is_private ? "Yes" : "No") + """</div>
            </div>
            <div class="info-cell">
                <div class="info-label">Created</div>
                <div class="info-value">""" + (created_at != "" ? created_at : "—") + """</div>
            </div>""" +
            (created_by != "" ? """<div class="info-cell full"><div class="info-label">Created By</div><div class="info-value">""" + GLib.Markup.escape_text (created_by) + """</div></div>""" : "") +
            (comment != "" ? """<div class="info-cell full"><div class="info-label">Comment</div><div class="info-value">""" + GLib.Markup.escape_text (comment) + """</div></div>""" : "") +
            """
            </div>
        </div>

        <!-- File list -->
        <div>
            <div class="section-title">Files <span>""" + files.size.to_string () + """</span></div>
            <div class="search-wrap">
            <svg viewBox="0 0 14 14"><circle cx="6" cy="6" r="4"/><line x1="9" y1="9" x2="13" y2="13"/></svg>
            <input type="text" id="search" placeholder="Search files…" autocomplete="off">
            </div>
            <div class="arc-list" id="arc-list">
        """ + file_rows.str + """
            </div>
            <div class="no-result" id="no-result">No files match</div>
        </div>

        <!-- Trackers -->
        <div>
            <div class="section-title">Trackers <span>""" + seen.size.to_string () + """</span></div>
            <div class="trk-list">
        """ + tracker_rows.str + """
            </div>
        </div>
        </div>
        <script>
        if (window.self !== window.top) {
        // Sembunyikan back link
        const backLink = document.querySelector('header a');
        if (backLink) backLink.style.display = 'none';
        // Sembunyikan title
        const title = document.querySelector('.hd-title');
        if (title) title.style.display = 'none';
        // Sembunyikan tombol Add
        const actions = document.querySelector('.banner-actions');
        if (actions) actions.style.display = 'none';
        }
        document.getElementById('btn-add-dm').addEventListener('click', async function() {
        const btn = this;
        btn.textContent = 'Adding…';
        btn.disabled = true;
        btn.style.opacity = '0.6';
        try {
            const resp = await fetch('""" + raw_src + """');
            const blob = await resp.blob();
            const file = new File([blob], '""" + GLib.Markup.escape_text (filename) + """', { type: 'application/x-bittorrent' });
            const fd   = new FormData();
            fd.append('file[]', file);
            const post = await fetch('/Downloading', { method: 'POST', body: fd });
            if (post.ok || post.status < 400) {
            btn.textContent = '✓ Added!';
            btn.style.background = 'rgba(52,211,153,0.25)';
            btn.style.borderColor = 'rgba(52,211,153,0.4)';
            btn.style.color = '#34d399';
            setTimeout(() => window.parent.postMessage('torrent-added', '*'), 600);
            } else {
            throw new Error('HTTP ' + post.status);
            }
        } catch (e) {
            btn.textContent = 'Failed';
            btn.style.background = 'rgba(248,113,113,0.15)';
            btn.style.color = '#f87171';
            btn.style.borderColor = 'rgba(248,113,113,0.3)';
            btn.disabled = false;
            btn.style.opacity = '1';
        }
        });
        const searchEl = document.getElementById('search');
        const arcList  = document.getElementById('arc-list');
        const noResult = document.getElementById('no-result');
        if (searchEl && arcList) {
        searchEl.addEventListener('input', () => {
            const q = searchEl.value.toLowerCase();
            let count = 0;
            arcList.querySelectorAll('.arc-row').forEach(row => {
            const name = (row.querySelector('.arc-basename')?.textContent || '').toLowerCase();
            const dir  = (row.querySelector('.arc-dir')?.textContent || '').toLowerCase();
            const match = !q || name.includes(q) || dir.includes(q);
            row.classList.toggle('hidden', !match);
            if (match) count++;
            });
            noResult.style.display = (count === 0 && q) ? 'block' : 'none';
        });
        searchEl.addEventListener('keydown', e => {
            if (e.key === 'Escape') { searchEl.value = ''; searchEl.dispatchEvent(new Event('input')); }
        });
        }
        </script>
        </body>
        </html>""";
    }
}