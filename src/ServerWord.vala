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
    private string get_word_page (string file_path, string filename) {
        var raw_src = "/Rawori?path=" + GLib.Uri.escape_string (file_path, "/", true);
        return """<!DOCTYPE html>
        <html lang="en">
        <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>""" + GLib.Markup.escape_text (filename) + """</title>
        <style>
        *{margin:0;padding:0;box-sizing:border-box;}
        body{
        background:#1a1a1a;color:#fff;
        font-family:Inter,system-ui,sans-serif;
        height:100vh;height:100dvh;
        display:flex;flex-direction:column;overflow:hidden;
        }
        header{
        width:100%;background:rgba(10,10,10,0.92);
        backdrop-filter:blur(20px);-webkit-backdrop-filter:blur(20px);
        padding:0 16px;height:52px;
        display:flex;align-items:center;gap:10px;
        border-bottom:0.5px solid rgba(255,255,255,0.08);flex-shrink:0;
        }
        header a{color:#888;text-decoration:none;font-size:13px;}
        header a:hover{color:#fff;}
        .hd-title{color:#fff;font-size:14px;font-weight:500;flex:1;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
        .doc-badge{font-size:10px;font-weight:600;background:rgba(96,165,250,0.15);color:#60a5fa;border-radius:999px;padding:2px 10px;flex-shrink:0;}
        .viewer{
        flex:1;overflow-y:auto;overflow-x:hidden;
        background:#e8e8e8;min-height:0;
        padding:24px 16px;
        }
        .viewer::-webkit-scrollbar{width:6px;}
        .viewer::-webkit-scrollbar-track{background:transparent;}
        .viewer::-webkit-scrollbar-thumb{background:rgba(0,0,0,0.2);border-radius:999px;}
        .doc-body{
        background:#fff;
        max-width:860px;margin:0 auto;
        padding:48px 56px;
        box-shadow:0 4px 24px rgba(0,0,0,0.15);
        border-radius:4px;
        color:#111;
        font-family:Georgia,serif;
        font-size:15px;
        line-height:1.8;
        min-height:80vh;
        }
        .doc-body h1,.doc-body h2,.doc-body h3,.doc-body h4{
        font-family:Inter,system-ui,sans-serif;
        margin:1.2em 0 0.4em;color:#111;
        }
        .doc-body p{margin:0.6em 0;}
        .doc-body table{border-collapse:collapse;width:100%;margin:1em 0;}
        .doc-body td,.doc-body th{border:1px solid #ccc;padding:6px 10px;font-size:14px;}
        .doc-body th{background:#f5f5f5;font-weight:600;}
        .doc-body img{max-width:100%;height:auto;border-radius:4px;}
        .doc-body ul,.doc-body ol{padding-left:24px;margin:0.6em 0;}
        .doc-body blockquote{border-left:3px solid #ddd;margin:1em 0;padding:0.5em 1em;color:#555;}
        @media(max-width:600px){
        .doc-body{padding:24px 20px;}
        }
        .loading{
        display:flex;flex-direction:column;align-items:center;justify-content:center;
        gap:14px;min-height:60vh;color:rgba(255,255,255,0.3);font-size:13px;
        }
        .spinner{
        width:32px;height:32px;border-radius:50%;
        border:2.5px solid rgba(255,255,255,0.08);
        border-top-color:rgba(255,255,255,0.5);
        animation:spin 0.8s linear infinite;
        }
        @keyframes spin{to{transform:rotate(360deg);}}
        .err{
        display:none;flex-direction:column;align-items:center;justify-content:center;
        gap:12px;min-height:60vh;color:rgba(255,255,255,0.3);font-size:13px;text-align:center;
        }
        .controls{
        position:fixed;
        bottom:max(16px,env(safe-area-inset-bottom,16px));
        right:20px;
        background:rgba(30,30,30,0.9);
        backdrop-filter:blur(16px);-webkit-backdrop-filter:blur(16px);
        border:0.5px solid rgba(255,255,255,0.12);
        border-radius:999px;padding:4px 6px;
        display:flex;align-items:center;gap:2px;
        box-shadow:0 4px 16px rgba(0,0,0,0.4);z-index:100;
        }
        .btn{
        width:32px;height:32px;border-radius:50%;border:none;
        background:transparent;color:#fff;
        display:grid;place-items:center;cursor:pointer;
        transition:background 0.15s,transform 0.1s;
        text-decoration:none;
        }
        .btn:hover{background:rgba(255,255,255,0.1);}
        .btn:active{transform:scale(0.88);}
        .btn svg{width:15px;height:15px;fill:none;stroke:#fff;stroke-width:1.7;stroke-linecap:round;stroke-linejoin:round;}
        @media print {
        body { background: #fff !important; }
        header, .controls { display: none !important; }
        .viewer {
            overflow: visible !important;
            background: #fff !important;
            padding: 0 !important;
        }
        .doc-body {
            box-shadow: none !important;
            border-radius: 0 !important;
            padding: 0 !important;
            max-width: 100% !important;
            min-height: unset !important;
        }
        }
        </style>
        </head>
        <body>
        <header>
        <a href="javascript:history.back()">&#8592; Back</a>
        <span class="hd-title">""" + GLib.Markup.escape_text (filename) + """</span>
        <span class="doc-badge">Word</span>
        </header>
        <div class="viewer" id="viewer">
        <div class="loading" id="loading">
            <div class="spinner"></div>
            Loading document…
        </div>
        <div class="err" id="err">
            Failed to load document.<br>
            <a style="color:#60a5fa;font-size:12px;margin-top:4px;" href='""" + raw_src + """' download = '""" + GLib.Markup.escape_text (filename) + """'>Download instead</a>
        </div>
        </div>
        <div class="controls">
        <button class="btn" id="btn-print" title="Print">
        <svg viewBox="0 0 16 16"><path d="M4 6V2h8v4"/><rect x="2" y="6" width="12" height="7" rx="1"/><rect x="4" y="10" width="8" height="4" fill="white" stroke-width="1.2"/><circle cx="12" cy="9" r="0.8" fill="currentColor" stroke="none"/></svg>
        </button>
        <button class="btn" id="btn-zi" title="Zoom in">
            <svg viewBox="0 0 16 16"><line x1="8" y1="2" x2="8" y2="14"/><line x1="2" y1="8" x2="14" y2="8"/></svg>
        </button>
        <button class="btn" id="btn-zo" title="Zoom out">
            <svg viewBox="0 0 16 16"><line x1="2" y1="8" x2="14" y2="8"/></svg>
        </button>
        <a class="btn" href='""" + raw_src + """' download = '""" + GLib.Markup.escape_text (filename) + """' title="Download">
            <svg viewBox="0 0 16 16"><polyline points="8,2 8,11"/><polyline points="4,8 8,12 12,8"/><line x1="2" y1="14" x2="14" y2="14"/></svg>
        </a>
        <button class="btn" id="btn-fs" title="Fullscreen">
            <svg id="ico-fs" viewBox="0 0 16 16"><polyline points="2,5 2,2 5,2"/><polyline points="11,2 14,2 14,5"/><polyline points="14,11 14,14 11,14"/><polyline points="5,14 2,14 2,11"/></svg>
            <svg id="ico-ex" viewBox="0 0 16 16" style="display:none"><polyline points="5,2 2,2 2,5"/><polyline points="11,2 14,2 14,5"/><polyline points="14,14 11,11"/><polyline points="2,14 5,11"/></svg>
        </button>
        </div>
        <script>
        (async () => {
        const DOC_URL = '""" + raw_src + """';
        await new Promise((res, rej) => {
            const s = document.createElement('script');
            s.src = '/MammothJs';
            s.onload = res;
            s.onerror = rej;
            document.head.appendChild(s);
        });
        const viewer  = document.getElementById('viewer');
        const loading = document.getElementById('loading');
        const errDiv  = document.getElementById('err');
        try {
            const resp = await fetch(DOC_URL);
            const buf  = await resp.arrayBuffer();
            const result = await mammoth.convertToHtml({ arrayBuffer: buf });
            loading.remove();
            const doc = document.createElement('div');
            doc.className = 'doc-body';
            doc.innerHTML = result.value;
            viewer.appendChild(doc);
        } catch (e) {
            loading.remove();
            errDiv.style.display = 'flex';
            console.error(e);
        }
        let zoom = 1.0;
        function applyZoom() {
            const doc = document.querySelector('.doc-body');
            if (!doc) return;
            doc.style.transform       = 'scale(' + zoom + ')';
            doc.style.transformOrigin = 'top center';
            doc.style.marginBottom    = ((zoom - 1) * doc.offsetHeight) + 'px';
        }
        document.getElementById('btn-zi').addEventListener('click', () => { zoom = Math.min(2, zoom + 0.1); applyZoom(); });
        document.getElementById('btn-zo').addEventListener('click', () => { zoom = Math.max(0.5, zoom - 0.1); applyZoom(); });
        const btnFs = document.getElementById('btn-fs');
        btnFs.addEventListener('click', () => {
            if (!document.fullscreenElement) document.documentElement.requestFullscreen();
            else document.exitFullscreen();
        });
        document.addEventListener('fullscreenchange', () => {
            const fs = !!document.fullscreenElement;
            document.getElementById('ico-fs').style.display = fs ? 'none' : '';
            document.getElementById('ico-ex').style.display = fs ? '' : 'none';
        });
        document.addEventListener('keydown', e => {
            if (e.key === '+' || e.key === '=') document.getElementById('btn-zi').click();
            if (e.key === '-')                  document.getElementById('btn-zo').click();
            if (e.key === 'f')                  btnFs.click();
        });
        })();
        document.getElementById('btn-print').addEventListener('click', () => {
        window.print();
        });
        if (e.ctrlKey && e.key === 'p') {
        e.preventDefault();
        document.getElementById('btn-print').click();
        }
        </script>
        </body>
        </html>""";
    }
}