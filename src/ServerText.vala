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
    private string get_text_page (string file_path, string filename, string mime, Soup.ServerMessage msg) {
        string content = "";
        string errmsg = "";
        int64 filesize = 0;
        int line_count = 0;
        bool truncated = false;
        try {
            var file = File.new_for_path (file_path);
            if (!file.query_exists ()) {
                file = File.new_for_path (serverdir.get_path () + file_path);
            }
            if (!file.query_exists ()) {
                return get_not_found ();
            } else {
                var info  = file.query_info ("standard::size", FileQueryInfoFlags.NONE);
                filesize = info.get_size ();
                uint8[] contents;
                GLib.FileUtils.get_data(file.get_path (), out contents);
                content = ((string) contents).make_valid ();
                line_count = content.split ("\n").length;
            }
        } catch (Error e) {
            return get_not_found ();
        }

        var lang = get_lang_from_ext (filename);
        var size_str = GLib.format_size (filesize).to_ascii ();
        var raw_src = "/Rawori?path=" + GLib.Uri.escape_string (file_path, "", true);

        var json_lines = new StringBuilder ();
        json_lines.append ("const rawLines=[");
        var lines = content.split ("\n");
        bool first = true;
        foreach (var line in lines) {
            if (!first) {
                json_lines.append (",");
            }
            first = false;
            var safe = line.replace ("\\", "\\\\").replace ("\"", "\\\"").replace ("\r", "").replace ("\t", "\\t");
            json_lines.append ("\"" + safe + "\"");
        }
        json_lines.append ("];");
        var html = new StringBuilder ();
        html.append ("""<!DOCTYPE html>
        <html lang="en">
        <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>""" + GLib.Markup.escape_text (filename) + """</title>
        <style>
        *{margin:0;padding:0;box-sizing:border-box;}
        body{
        background:#0d0d0d;color:#fff;
        font-family:Inter,system-ui,sans-serif;
        height:100vh;height:100dvh;
        display:flex;flex-direction:column;overflow:hidden;
        }
        header{
        position:sticky;top:0;z-index:100;width:100%;
        background:rgba(13,13,13,0.92);
        backdrop-filter:blur(24px) saturate(1.8);
        -webkit-backdrop-filter:blur(24px) saturate(1.8);
        border-bottom:0.5px solid rgba(255,255,255,0.07);
        padding:0 16px;height:52px;
        display:flex;align-items:center;gap:10px;
        }
        header a{color:#888;text-decoration:none;font-size:13px;flex-shrink:0;}
        header a:hover{color:#fff;}
        .hd-title{color:#fff;font-size:14px;font-weight:500;flex:1;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
        .hd-meta{color:rgba(255,255,255,0.3);font-size:11px;flex-shrink:0;white-space:nowrap;}
        .lang-badge{
        font-size:10px;font-weight:600;
        background:rgba(251,191,36,0.15);color:#fbbf24;
        border-radius:999px;padding:2px 10px;flex-shrink:0;
        text-transform:uppercase;letter-spacing:0.04em;
        }
        .toolbar{
        background:#111;border-bottom:0.5px solid rgba(255,255,255,0.06);
        padding:6px 16px;display:flex;align-items:center;gap:8px;flex-shrink:0;
        }
        .tb-btn{
        display:inline-flex;align-items:center;gap:5px;
        background:rgba(255,255,255,0.06);border:0.5px solid rgba(255,255,255,0.09);
        border-radius:8px;padding:5px 12px;
        color:rgba(255,255,255,0.6);font-size:12px;font-weight:500;font-family:inherit;
        cursor:pointer;transition:background 0.15s,color 0.15s;
        text-decoration:none;
        }
        .tb-btn:hover{background:rgba(255,255,255,0.1);color:#fff;}
        .tb-btn:active{transform:scale(0.97);}
        .tb-btn.active{background:rgba(251,191,36,0.12);border-color:rgba(251,191,36,0.2);color:#fbbf24;}
        .tb-btn svg{width:13px;height:13px;fill:none;stroke:currentColor;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round;}
        .tb-spacer{flex:1;}
        .tb-search{
        display:flex;align-items:center;gap:6px;
        background:rgba(255,255,255,0.05);border:0.5px solid rgba(255,255,255,0.1);
        border-radius:8px;padding:4px 10px;transition:border-color 0.15s;
        }
        .tb-search:focus-within{border-color:rgba(255,255,255,0.25);}
        .tb-search svg{width:13px;height:13px;stroke:rgba(255,255,255,0.3);fill:none;stroke-width:1.7;stroke-linecap:round;flex-shrink:0;}
        #search-input{
        background:transparent;border:none;outline:none;
        color:#fff;font-size:12px;font-family:inherit;width:140px;
        }
        #search-input::placeholder{color:rgba(255,255,255,0.2);}
        #search-count{font-size:11px;color:rgba(255,255,255,0.3);flex-shrink:0;}
        .code-wrap{
        flex:1;overflow:auto;min-height:0;
        }
        .code-wrap::-webkit-scrollbar{width:8px;height:8px;}
        .code-wrap::-webkit-scrollbar-track{background:transparent;}
        .code-wrap::-webkit-scrollbar-thumb{background:rgba(255,255,255,0.1);border-radius:999px;}
        .code-wrap::-webkit-scrollbar-thumb:hover{background:rgba(255,255,255,0.2);}
        table.code-table{
        border-collapse:collapse;width:100%;
        font-family:'JetBrains Mono','Fira Code',Consolas,monospace;
        font-size:13px;line-height:1.6;
        }
        td.ln{
        user-select:none;-webkit-user-select:none;
        color:rgba(255,255,255,0.2);text-align:right;
        padding:0 14px 0 16px;
        border-right:1px solid rgba(255,255,255,0.06);
        white-space:nowrap;vertical-align:top;
        font-size:12px;min-width:48px;
        background:#111;position:sticky;left:0;
        }
        td.lc{
        padding:0 20px 0 16px;
        white-space:pre;color:#d4d4d4;vertical-align:top;
        }
        tr:hover td.lc{background:rgba(255,255,255,0.03);}
        tr:hover td.ln{background:#151515;}
        .hl{background:rgba(251,191,36,0.3);border-radius:2px;}
        .hl.cur{background:rgba(251,191,36,0.75);color:#0d0d0d;border-radius:2px;}
        .trunc-bar{
        background:rgba(251,146,60,0.1);border-top:0.5px solid rgba(251,146,60,0.2);
        padding:8px 16px;font-size:12px;color:rgba(251,146,60,0.85);
        display:flex;align-items:center;gap:8px;flex-shrink:0;
        }
        .trunc-bar svg{width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:1.6;flex-shrink:0;}
        .wrap-mode td.lc{white-space:pre-wrap;word-break:break-all;}
        </style>
        </head>
        <body>
        <header>
        <a href="javascript:history.back()">&#8592; Back</a>
        <span class="hd-title">""" + GLib.Markup.escape_text (filename) + """</span>
        <span class="hd-meta">""" + line_count.to_string () + " lines · " + size_str + """</span>
        <span class="lang-badge">""" + lang + """</span>
        </header>
        <div class="toolbar">
        <button class="tb-btn" id="btn-wrap">
            <svg viewBox="0 0 14 14"><path d="M2 4h10M2 7h7a2 2 0 010 4H8"/><polyline points="6,9 8,11 6,13"/></svg>
            Wrap
        </button>
        <a class="tb-btn" href='""" + raw_src + """' download = '""" + GLib.Markup.escape_text (filename) + """'>
            <svg viewBox="0 0 14 14"><polyline points="7,2 7,10"/><polyline points="3,7 7,11 11,7"/><line x1="2" y1="13" x2="12" y2="13"/></svg>
            Download
        </a>
        <div class="tb-spacer"></div>
        <div class="tb-search">
            <svg viewBox="0 0 14 14"><circle cx="6" cy="6" r="4"/><line x1="9" y1="9" x2="13" y2="13"/></svg>
            <input type="text" id="search-input" placeholder="Find…">
            <span id="search-count"></span>
        </div>
        <button class="tb-btn" id="btn-prev">
            <svg viewBox="0 0 14 14"><polyline points="10,10 7,6 4,10"/></svg>
        </button>
        <button class="tb-btn" id="btn-next">
            <svg viewBox="0 0 14 14"><polyline points="4,4 7,8 10,4"/></svg>
        </button>
        </div>""");

        if (errmsg != "") {
            html.append ("<div style='padding:20px;color:#f87171;font-size:13px;'>Error: " + GLib.Markup.escape_text (errmsg) + "</div>");
        }

        html.append ("""<div class="code-wrap"><table class="code-table"><tbody id="code-body"></tbody></table></div>""");
        if (truncated) {
            html.append ("""<div class="trunc-bar">
            <svg viewBox="0 0 18 18"><path d="M9 2L2 15h14z"/><line x1="9" y1="8" x2="9" y2="11"/><circle cx="9" cy="13.5" r="0.5" fill="currentColor" stroke="none"/></svg>
            File too large — showing first 2 MB.
            <a style="color:#fb923c;margin-left:4px;" href='""" + raw_src + """' download = '""" + GLib.Markup.escape_text (filename) + """'>Download full file</a>
            </div>""");
        }
        html.append ("<script>\n");
        html.append (json_lines.str);
        html.append ("""
        const tbody   = document.getElementById('code-body');
        const wrapBtn = document.getElementById('btn-wrap');
        const searchEl= document.getElementById('search-input');
        const searchCt= document.getElementById('search-count');
        (function(){
        const frag = document.createDocumentFragment();
        rawLines.forEach((line, i) => {
            const tr  = document.createElement('tr');
            const ln  = document.createElement('td');
            const lc  = document.createElement('td');
            ln.className = 'ln'; ln.textContent = i + 1;
            lc.className = 'lc'; lc.textContent = line || ' ';
            tr.appendChild(ln); tr.appendChild(lc);
            frag.appendChild(tr);
        });
        tbody.appendChild(frag);
        })();
        let wrapOn = false;
        wrapBtn.addEventListener('click', () => {
        wrapOn = !wrapOn;
        document.querySelector('.code-table').classList.toggle('wrap-mode', wrapOn);
        wrapBtn.classList.toggle('active', wrapOn);
        });
        let matches=[], cur=-1;
        function clearHL(){
        document.querySelectorAll('.hl').forEach(el=>{
            const t=document.createTextNode(el.textContent);
            el.parentNode.replaceChild(t,el);
        });
        tbody.querySelectorAll('td.lc').forEach(td=>td.normalize());
        matches=[]; cur=-1; searchCt.textContent='';
        }
        function doSearch(q){
        clearHL();
        if(!q) return;
        const re=new RegExp(q.replace(/[.*+?^${}()|[\]\\]/g,'\\$&'),'gi');
        tbody.querySelectorAll('td.lc').forEach(td=>{
            const text=td.textContent;
            if(!re.test(text)) return;
            re.lastIndex=0;
            const html=text.replace(re,m=>`<span class="hl">${m}</span>`);
            td.innerHTML=html;
            td.querySelectorAll('.hl').forEach(el=>matches.push(el));
        });
        if(matches.length){ cur=0; matches[0].classList.add('cur'); matches[0].scrollIntoView({block:'center',behavior:'smooth'}); }
        searchCt.textContent=matches.length?(cur+1)+'/'+matches.length:'0';
        }
        function moveCur(dir){
        if(!matches.length) return;
        matches[cur].classList.remove('cur');
        cur=(cur+dir+matches.length)%matches.length;
        matches[cur].classList.add('cur');
        matches[cur].scrollIntoView({block:'center',behavior:'smooth'});
        searchCt.textContent=(cur+1)+'/'+matches.length;
        }
        let st;
        searchEl.addEventListener('input',()=>{ clearTimeout(st); st=setTimeout(()=>doSearch(searchEl.value),200); });
        searchEl.addEventListener('keydown',e=>{
        if(e.key==='Enter'){ e.shiftKey?moveCur(-1):moveCur(1); }
        if(e.key==='Escape'){ searchEl.value=''; clearHL(); }
        });
        document.getElementById('btn-next').addEventListener('click',()=>moveCur(1));
        document.getElementById('btn-prev').addEventListener('click',()=>moveCur(-1));
        document.addEventListener('keydown',e=>{
        if(document.activeElement===searchEl) return;
        if((e.ctrlKey||e.metaKey)&&e.key==='f'){ e.preventDefault(); searchEl.focus(); searchEl.select(); }
        });
        </script>
        </body>
        </html>""");
        return html.str;
    }
}