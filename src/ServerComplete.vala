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
    public string get_complete (DownloadRow row) {
        string mime_class = row.fileordir != null ? get_mime_css (row.fileordir) : "file";
        string filename = row.filename != null ? row.filename : "Unknown file";
        string pathname = row.pathname != null ? row.pathname : "—";
        string filetype = row.fileordir != null ? row.fileordir : "—";
        string totalsize = GLib.format_size (row.totalsize, GLib.FormatSizeFlags.LONG_FORMAT).to_ascii ();
        string transferred = GLib.format_size (row.transferred, GLib.FormatSizeFlags.LONG_FORMAT).to_ascii ();

        bool is_viewable = row.fileordir != null && (row.fileordir.has_prefix ("video/") || row.fileordir.has_prefix ("image/")) || row.fileordir.has_prefix ("audio/");
        string open_btn = "";
        if (is_viewable && row.pathname != null) {
            string rel_path  = row.pathname;
            string encoded = GLib.Uri.escape_string (rel_path, "/", true);
            string icon_svg;
            string btn_label;
            if (row.fileordir.has_prefix ("video/")) {
                icon_svg  = "<svg viewBox='0 0 14 14'><rect x='1' y='2' width='9' height='10' rx='1.2'/><path d='M10 5l3-2v8l-3-2z'/></svg>";
                btn_label = "Open Video";
            } else if (row.fileordir.has_prefix ("audio/")){
                icon_svg  = "<svg viewBox='0 0 14 14'><rect x='1' y='1' width='12' height='12' rx='1.2'/><path d='M6 2l6 2v3l-6-2v6a2 2 0 11-1.5-1.94V4.5z'/></svg>";
                btn_label = "Open Audio";
            } else {
                icon_svg  = "<svg viewBox='0 0 14 14'><rect x='1' y='1' width='12' height='12' rx='1.5'/><circle cx='4.5' cy='4.5' r='1.2'/><path d='M1 9.5l3-3 2.5 2.5 2-2 3.5 3'/></svg>";
                btn_label = "Open Image";
            }
            open_btn = """<a class="btn-open" href="/Player?path=""" + encoded + """"  >""" + icon_svg + btn_label + """</a>""";
        }

        return """<!DOCTYPE html>
        <html lang="en">
        <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Download Complete</title>
        <style>
        *{margin:0;padding:0;box-sizing:border-box;}
        body{
        background:#0a0a0a;color:#fff;
        font-family:Inter,system-ui,sans-serif;
        min-height:100vh;display:flex;flex-direction:column;
        overflow-x:hidden;
        }
        .bg-glow{position:fixed;inset:0;z-index:0;pointer-events:none;overflow:hidden;}
        .bg-glow::before{
        content:'';position:absolute;
        width:600px;height:600px;border-radius:50%;
        background:radial-gradient(circle,rgba(52,211,153,0.08) 0%,transparent 70%);
        top:-200px;right:-200px;
        animation:glowdrift1 13s ease-in-out infinite alternate;
        }
        .bg-glow::after{
        content:'';position:absolute;
        width:500px;height:500px;border-radius:50%;
        background:radial-gradient(circle,rgba(96,165,250,0.06) 0%,transparent 70%);
        bottom:-180px;left:-180px;
        animation:glowdrift2 15s ease-in-out infinite alternate;
        }
        @keyframes glowdrift1{from{transform:translate(0,0) scale(1);}to{transform:translate(-50px,60px) scale(1.15);}}
        @keyframes glowdrift2{from{transform:translate(0,0) scale(1);}to{transform:translate(60px,-50px) scale(1.2);}}
        header{
        position:sticky;top:0;z-index:100;width:100%;
        background:rgba(10,10,10,0.88);
        backdrop-filter:blur(24px) saturate(1.8);
        -webkit-backdrop-filter:blur(24px) saturate(1.8);
        border-bottom:0.5px solid rgba(255,255,255,0.07);
        padding:0 20px;height:52px;
        display:flex;align-items:center;gap:12px;
        }
        .logo{text-decoration:none;font-size:17px;font-weight:800;color:#fff;letter-spacing:-0.5px;}
        .logo em{
        font-style:normal;
        background:linear-gradient(135deg,#fff 40%,rgba(255,255,255,0.45));
        -webkit-background-clip:text;-webkit-text-fill-color:transparent;
        background-clip:text;
        }
        .page{
        flex:1;display:flex;align-items:center;justify-content:center;
        padding:32px 20px;position:relative;z-index:1;
        }
        .card{
        width:100%;max-width:680px;
        background:rgba(255,255,255,0.03);
        border:0.5px solid rgba(255,255,255,0.09);
        border-radius:24px;overflow:hidden;
        backdrop-filter:blur(12px);-webkit-backdrop-filter:blur(12px);
        animation:fadeUp 0.35s cubic-bezier(0.25,0.46,0.45,0.94) both;
        }
        @keyframes fadeUp{from{opacity:0;transform:translateY(20px);}to{opacity:1;transform:translateY(0);}}
        .card-banner{
        background:rgba(52,211,153,0.08);
        border-bottom:0.5px solid rgba(52,211,153,0.15);
        padding:20px 24px;
        display:flex;align-items:center;gap:14px;
        }
        .banner-icon{
        width:44px;height:44px;border-radius:14px;
        background:rgba(52,211,153,0.15);
        display:flex;align-items:center;justify-content:center;flex-shrink:0;
        }
        .banner-icon svg{width:22px;height:22px;stroke:#34d399;fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round;}
        .banner-title{font-size:16px;font-weight:600;color:#34d399;}
        .banner-url{font-size:11px;color:rgba(255,255,255,0.3);overflow:hidden;text-overflow:ellipsis;white-space:nowrap;margin-top:2px;}
        .card-body{padding:20px 24px;display:flex;flex-direction:column;gap:0;}
        .file-row{
        display:flex;align-items:center;gap:16px;
        padding-bottom:20px;border-bottom:0.5px solid rgba(255,255,255,0.07);margin-bottom:20px;
        }
        .file-icon{width:56px;height:56px;border-radius:16px;flex-shrink:0;display:flex;align-items:center;justify-content:center;}
        .file-icon::before{
        content:'';display:block;width:28px;height:28px;
        mask-size:contain;mask-repeat:no-repeat;mask-position:center;
        -webkit-mask-size:contain;-webkit-mask-repeat:no-repeat;-webkit-mask-position:center;
        }
        .file-icon.video {background:rgba(251,146,60,0.12);}
        .file-icon.video::before{background:#fb923c;mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Crect x='1' y='3' width='10' height='10' rx='1.5'/%3E%3Cpath d='M11 6l4-2v8l-4-2z'/%3E%3C/svg%3E");-webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Crect x='1' y='3' width='10' height='10' rx='1.5'/%3E%3Cpath d='M11 6l4-2v8l-4-2z'/%3E%3C/svg%3E");}
        .file-icon.audio {background:rgba(167,139,250,0.12);}
        .file-icon.audio::before{background:#a78bfa;mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M6 2l6 2v3l-6-2v6a2 2 0 11-1.5-1.94V4.5z'/%3E%3C/svg%3E");-webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M6 2l6 2v3l-6-2v6a2 2 0 11-1.5-1.94V4.5z'/%3E%3C/svg%3E");}
        .file-icon.image {background:rgba(52,211,153,0.12);}
        .file-icon.image::before{background:#34d399;mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Crect x='1' y='1' width='14' height='14' rx='2' fill='none' stroke='%23000' stroke-width='1.2'/%3E%3Ccircle cx='5.5' cy='5.5' r='1.5'/%3E%3Cpath d='M1 11l4-4 3 3 2-2 4 4'/%3E%3C/svg%3E");-webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Crect x='1' y='1' width='14' height='14' rx='2' fill='none' stroke='%23000' stroke-width='1.2'/%3E%3Ccircle cx='5.5' cy='5.5' r='1.5'/%3E%3Cpath d='M1 11l4-4 3 3 2-2 4 4'/%3E%3C/svg%3E");}
        .file-icon.archive{background:rgba(251,146,60,0.12);}
        .file-icon.archive::before{background:#fb923c;mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Crect x='1' y='1' width='14' height='4' rx='1'/%3E%3Crect x='1' y='6' width='14' height='9' rx='1'/%3E%3C/svg%3E");-webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Crect x='1' y='1' width='14' height='4' rx='1'/%3E%3Crect x='1' y='6' width='14' height='9' rx='1'/%3E%3C/svg%3E");}
        .file-icon.pdf   {background:rgba(248,113,113,0.12);}
        .file-icon.pdf::before{background:#f87171;mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M4 0h5.5L13 3.5V14a2 2 0 01-2 2H4a2 2 0 01-2-2V2a2 2 0 012-2z'/%3E%3C/svg%3E");-webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M4 0h5.5L13 3.5V14a2 2 0 01-2 2H4a2 2 0 01-2-2V2a2 2 0 012-2z'/%3E%3C/svg%3E");}
        .file-icon.file  {background:rgba(255,255,255,0.06);}
        .file-icon.file::before{background:rgba(255,255,255,0.4);mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M4 1.5A1.5 1.5 0 015.5 0h5.086a1.5 1.5 0 011.06.44l2.915 2.914A1.5 1.5 0 0115 4.414V14.5A1.5 1.5 0 0113.5 16h-8A1.5 1.5 0 014 14.5z'/%3E%3C/svg%3E");-webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M4 1.5A1.5 1.5 0 015.5 0h5.086a1.5 1.5 0 011.06.44l2.915 2.914A1.5 1.5 0 0115 4.414V14.5A1.5 1.5 0 0113.5 16h-8A1.5 1.5 0 014 14.5z'/%3E%3C/svg%3E");}
        .file-name{font-size:15px;font-weight:600;color:#fff;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
        .file-meta{font-size:12px;color:rgba(255,255,255,0.35);margin-top:3px;}
        .info-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:20px;}
        .info-cell{background:rgba(255,255,255,0.03);border:0.5px solid rgba(255,255,255,0.07);border-radius:12px;padding:12px 14px;}
        .info-label{font-size:10px;font-weight:600;color:rgba(255,255,255,0.25);text-transform:uppercase;letter-spacing:0.07em;margin-bottom:4px;}
        .info-value{font-size:13px;font-weight:500;color:#fff;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
        .info-cell.full{grid-column:1/-1;}
        .info-cell.status .info-value{color:#34d399;}

        /* ── Button row ── */
        .btn-row{display:flex;gap:10px;}
        .btn-back,.btn-open{
        flex:1;
        display:inline-flex;align-items:center;justify-content:center;gap:8px;
        padding:11px;
        border-radius:12px;
        font-size:13px;font-weight:500;font-family:inherit;
        cursor:pointer;text-decoration:none;
        transition:background 0.15s,transform 0.1s;
        }
        .btn-back{
        background:rgba(255,255,255,0.08);
        border:0.5px solid rgba(255,255,255,0.12);
        color:#fff;
        }
        .btn-back:hover{background:rgba(255,255,255,0.14);}
        .btn-back:active{transform:scale(0.98);}
        .btn-back svg,.btn-open svg{
        width:14px;height:14px;fill:none;stroke:currentColor;
        stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round;display:block;
        }
        .btn-open{
        background:rgba(96,165,250,0.12);
        border:0.5px solid rgba(96,165,250,0.25);
        color:#60a5fa;
        }
        .btn-open:hover{background:rgba(96,165,250,0.2);}
        .btn-open:active{transform:scale(0.98);}

        @media(max-width:480px){
        .info-grid{grid-template-columns:1fr;}
        .info-cell.full{grid-column:1;}
        .card-banner,.card-body{padding:16px;}
        .btn-row{flex-direction:column;}
        }
        </style>
        </head>
        <body>
        <div class="bg-glow"></div>
        <header>
        <a class="logo" href="/"><em>G</em>ABUT</a>
        </header>
        <div class="page">
        <div class="card">
            <div class="card-banner">
            <div class="banner-icon">
                <svg viewBox="0 0 22 22"><polyline points="4,12 9,17 18,6"/></svg>
            </div>
            <div style="flex:1;min-width:0;">
                <div class="banner-title">Download Complete</div>
                <div class="banner-url">""" + row.url + """</div>
            </div>
            </div>
            <div class="card-body">
            <div class="file-row">
                <div class="file-icon """ + mime_class + """"></div>
                <div style="flex:1;min-width:0;">
                <div class="file-name">""" + filename + """</div>
                <div class="file-meta">""" + filetype + """</div>
                </div>
            </div>
            <div class="info-grid">
                <div class="info-cell">
                <div class="info-label">Total Size</div>
                <div class="info-value">""" + totalsize + """</div>
                </div>
                <div class="info-cell">
                <div class="info-label">Transferred</div>
                <div class="info-value">""" + transferred + """</div>
                </div>
                <div class="info-cell full">
                <div class="info-label">Save Path</div>
                <div class="info-value">""" + pathname + """</div>
                </div>
                <div class="info-cell status full">
                <div class="info-label">Status</div>
                <div class="info-value">Complete</div>
                </div>
            </div>
            <div class="btn-row">
                <form action="/Complete" method="get" style="flex:1;">
                <button class="btn-back" type="submit" style="width:100%;">
                    <svg viewBox="0 0 14 14"><polyline points="9,2 4,7 9,12"/></svg>
                    Back to DM
                </button>
                </form>
                """ + open_btn + """
            </div>
            </div>
        </div>
        </div>
        </body>
        </html>""";
    }
}