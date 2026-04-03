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
    private string get_excel_page (string file_path, string filename) {
        var raw_src = "/Rawori?path=" + GLib.Uri.escape_string (file_path, "", true);
        var lower = filename.down ();
        var badge = lower.has_suffix (".xlsm") ? "XLSM" : lower.has_suffix (".xls") ? "XLS" : "XLSX";
        return """<!DOCTYPE html>
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
        width:100%;background:rgba(10,10,10,0.92);
        backdrop-filter:blur(20px);-webkit-backdrop-filter:blur(20px);
        padding:0 16px;height:52px;
        display:flex;align-items:center;gap:10px;
        border-bottom:0.5px solid rgba(255,255,255,0.08);flex-shrink:0;
        }
        header a{color:#888;text-decoration:none;font-size:13px;}
        header a:hover{color:#fff;}
        .hd-title{color:#fff;font-size:14px;font-weight:500;flex:1;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
        .xl-badge{font-size:10px;font-weight:600;background:rgba(52,211,153,0.15);color:#34d399;border-radius:999px;padding:2px 10px;flex-shrink:0;}
        .sheet-tabs{
        display:flex;align-items:center;gap:0;
        background:#111;border-bottom:0.5px solid rgba(255,255,255,0.08);
        padding:0 12px;overflow-x:auto;flex-shrink:0;
        scrollbar-width:none;
        }
        .sheet-tabs::-webkit-scrollbar{display:none;}
        .sheet-tab{
        padding:8px 16px;font-size:12px;font-weight:500;
        color:rgba(255,255,255,0.35);cursor:pointer;
        border-bottom:2px solid transparent;white-space:nowrap;
        transition:color 0.15s,border-color 0.15s;
        -webkit-tap-highlight-color:transparent;
        }
        .sheet-tab:hover{color:rgba(255,255,255,0.7);}
        .sheet-tab.active{color:#34d399;border-bottom-color:#34d399;}
        .viewer{
        flex:1;overflow:auto;min-height:0;
        background:#0d0d0d;
        }
        .viewer::-webkit-scrollbar{width:8px;height:8px;}
        .viewer::-webkit-scrollbar-track{background:transparent;}
        .viewer::-webkit-scrollbar-thumb{background:rgba(255,255,255,0.1);border-radius:999px;}
        .viewer::-webkit-scrollbar-thumb:hover{background:rgba(255,255,255,0.2);}
        .tbl-wrap{
        min-width:100%;
        }
        table{
        border-collapse:collapse;
        font-size:13px;
        white-space:nowrap;
        }
        thead th{
        position:sticky;top:0;z-index:10;
        background:#161616;
        color:rgba(255,255,255,0.35);
        font-size:11px;font-weight:600;
        padding:6px 12px;
        border-bottom:1px solid rgba(255,255,255,0.08);
        border-right:0.5px solid rgba(255,255,255,0.06);
        text-align:center;min-width:80px;
        }
        thead th.row-num{
        position:sticky;top:0;left:0;z-index:20;
        min-width:48px;background:#161616;
        }
        tbody td{
        padding:6px 12px;
        border-right:0.5px solid rgba(255,255,255,0.06);
        border-bottom:0.5px solid rgba(255,255,255,0.04);
        color:#e0e0e0;
        max-width:280px;
        overflow:hidden;text-overflow:ellipsis;
        }
        tbody td.row-num{
        position:sticky;left:0;z-index:5;
        background:#111;
        color:rgba(255,255,255,0.2);
        font-size:11px;text-align:center;
        border-right:1px solid rgba(255,255,255,0.1);
        min-width:48px;
        }
        tbody tr:hover td{background:rgba(255,255,255,0.03);}
        tbody tr:hover td.row-num{background:#151515;}
        .loading{
        display:flex;flex-direction:column;align-items:center;justify-content:center;
        gap:14px;flex:1;color:rgba(255,255,255,0.3);font-size:13px;
        }
        .spinner{
        width:32px;height:32px;border-radius:50%;
        border:2.5px solid rgba(255,255,255,0.08);
        border-top-color:rgba(52,211,153,0.6);
        animation:spin 0.8s linear infinite;
        }
        @keyframes spin{to{transform:rotate(360deg);}}
        .empty{
        padding:40px;text-align:center;
        color:rgba(255,255,255,0.2);font-size:13px;
        }
        .controls{
        position:fixed;
        bottom:max(16px,env(safe-area-inset-bottom,16px));
        right:20px;
        background:rgba(20,20,20,0.92);
        backdrop-filter:blur(16px);-webkit-backdrop-filter:blur(16px);
        border:0.5px solid rgba(255,255,255,0.12);
        border-radius:999px;padding:4px 6px;
        display:flex;align-items:center;gap:2px;
        box-shadow:0 4px 16px rgba(0,0,0,0.5);z-index:100;
        }
        .btn{
        width:32px;height:32px;border-radius:50%;border:none;
        background:transparent;color:#fff;
        display:grid;place-items:center;cursor:pointer;
        transition:background 0.15s,transform 0.1s;
        text-decoration:none;-webkit-tap-highlight-color:transparent;
        }
        .btn:hover{background:rgba(255,255,255,0.1);}
        .btn:active{transform:scale(0.88);}
        .btn svg{width:15px;height:15px;fill:none;stroke:#fff;stroke-width:1.7;stroke-linecap:round;stroke-linejoin:round;}
        .sep{width:1px;height:18px;background:rgba(255,255,255,0.12);margin:0 2px;}
        .info-bar{
        background:#111;border-top:0.5px solid rgba(255,255,255,0.06);
        padding:4px 16px;font-size:11px;color:rgba(255,255,255,0.25);
        display:flex;gap:16px;flex-shrink:0;
        }
        @media print {
        body{background:#fff !important;height:auto !important;}
        header,.controls,.sheet-tabs,.info-bar{display:none !important;}
        .viewer{overflow:visible !important;height:auto !important;}
        tbody td{color:#000 !important;border-color:#ccc !important;}
        thead th{color:#555 !important;background:#f5f5f5 !important;border-color:#ccc !important;}
        tbody td.row-num,thead th.row-num{display:none;}
        tbody tr:hover td{background:transparent !important;}
        }
        </style>
        </head>
        <body>
        <header>
        <a href="javascript:history.back()">&#8592; Back</a>
        <span class="hd-title">""" + GLib.Markup.escape_text (filename) + """</span>
        <span class="xl-badge">""" + badge + """</span>
        </header>
        <div class="sheet-tabs" id="sheet-tabs"></div>
        <div class="viewer" id="viewer">
        <div class="loading" id="loading">
            <div class="spinner"></div>Loading spreadsheet…
        </div>
        </div>
        <div class="info-bar" id="info-bar"></div>
        <div class="controls">
        <button class="btn" id="btn-print" title="Print">
            <svg viewBox="0 0 16 16"><path d="M4 6V2h8v4"/><rect x="2" y="6" width="12" height="7" rx="1"/><rect x="4" y="10" width="8" height="4" fill="none"/><circle cx="12" cy="9" r="0.8" fill="#fff" stroke="none"/></svg>
        </button>
        <div class="sep"></div>
        <a class="btn" href='""" + raw_src + """' download = '""" + GLib.Markup.escape_text (filename) + """' title="Download">
            <svg viewBox="0 0 16 16"><polyline points="8,2 8,11"/><polyline points="4,8 8,12 12,8"/><line x1="2" y1="14" x2="14" y2="14"/></svg>
        </a>
        </div>
        <script>
        (async () => {
        const FILE_URL  = '""" + raw_src + """';
        const viewer    = document.getElementById('viewer');
        const loading   = document.getElementById('loading');
        const tabsEl    = document.getElementById('sheet-tabs');
        const infoBar   = document.getElementById('info-bar');
        await new Promise((res, rej) => {
            const s = document.createElement('script');
            s.src = '/SheetJs';
            s.onload = res;
            s.onerror = rej;
            document.head.appendChild(s);
        });
        let workbook = null;
        let currentSheet = 0;
        try {
            const resp = await fetch(FILE_URL);
            const buf  = await resp.arrayBuffer();
            workbook   = XLSX.read(buf, { type: 'array', cellStyles: true, cellDates: true });
            loading.remove();
            renderTabs();
            renderSheet(0);
        } catch (e) {
            loading.innerHTML = '<div style="color:#f87171;font-size:13px;">Failed to load file</div>';
            console.error(e);
        }
        function renderTabs() {
            tabsEl.innerHTML = '';
            workbook.SheetNames.forEach((name, i) => {
            const tab = document.createElement('div');
            tab.className = 'sheet-tab' + (i === 0 ? ' active' : '');
            tab.textContent = name;
            tab.addEventListener('click', () => {
                document.querySelectorAll('.sheet-tab').forEach(t => t.classList.remove('active'));
                tab.classList.add('active');
                renderSheet(i);
            });
            tabsEl.appendChild(tab);
            });
        }
        function renderSheet(idx) {
            currentSheet = idx;
            const sheetName = workbook.SheetNames[idx];
            const sheet = workbook.Sheets[sheetName];
            const range = XLSX.utils.decode_range(sheet['!ref'] || 'A1');
            const rows = XLSX.utils.sheet_to_json(sheet, {
            header: 1,
            raw: false,
            defval: ''
            });
            if (rows.length === 0) {
            viewer.innerHTML = '<div class="empty">This sheet is empty</div>';
            infoBar.textContent = sheetName + ' — 0 rows';
            return;
            }
            const maxCols = rows.reduce((m, r) => Math.max(m, r.length), 0);
            const dataRows = rows.length;
            const colHeaders = Array.from({ length: maxCols }, (_, i) => {
            let col = '';
            let n   = i;
            do {
                col = String.fromCharCode(65 + (n % 26)) + col;
                n   = Math.floor(n / 26) - 1;
            } while (n >= 0);
            return col;
            });
            const sb = ['<div class="tbl-wrap"><table>'];
            sb.push('<thead><tr>');
            sb.push('<th class="row-num">#</th>');
            colHeaders.forEach(h => sb.push('<th>' + h + '</th>'));
            sb.push('</tr></thead>');
            sb.push('<tbody>');
            rows.forEach((row, ri) => {
            sb.push('<tr>');
            sb.push('<td class="row-num">' + (ri + 1) + '</td>');
            for (let ci = 0; ci < maxCols; ci++) {
                const val = row[ci] ?? '';
                const escaped = String(val)
                .replace(/&/g,'&amp;')
                .replace(/</g,'&lt;')
                .replace(/>/g,'&gt;');
                sb.push('<td title="' + escaped + '">' + escaped + '</td>');
            }
            sb.push('</tr>');
            });
            sb.push('</tbody></table></div>');
            viewer.innerHTML = sb.join('');
            infoBar.textContent = sheetName + ' — ' + dataRows + ' rows × ' + maxCols + ' cols';
        }
        document.getElementById('btn-print').addEventListener('click', () => {
            window.print();
        });
        document.addEventListener('keydown', e => {
            if ((e.ctrlKey || e.metaKey) && e.key === 'p') {
            e.preventDefault();
            document.getElementById('btn-print').click();
            }
        });
        })();
        </script>
        </body>
        </html>""";
    }
}