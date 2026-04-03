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
    private string get_archive_page (string file_path, string filename, string mime) {
        var raw_src = "/Rawori?path=" + GLib.Uri.escape_string (file_path, "", true);
        var escaped_filename = GLib.Markup.escape_text (filename);
        return """<!DOCTYPE html>
        <html lang="id">
        <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>""" + escaped_filename + """</title>
        <style>
            * { margin:0; padding:0; box-sizing:border-box; }
            body { background:#0a0a0a; color:#eee; font-family:system-ui, sans-serif; min-height:100vh; }
            header { position:sticky; top:0; background:rgba(20,20,20,0.9); backdrop-filter:blur(10px); border-bottom:1px solid #333; padding:12px 20px; display:flex; align-items:center; gap:12px; z-index:100; }
            .main { padding:20px; max-width:800px; margin:0 auto; }
            .card { background:#161616; border:1px solid #222; border-radius:12px; padding:16px; display:flex; align-items:center; gap:15px; margin-bottom:20px; }
            .btn-dl { background:#fb923c; color:#000; padding:8px 16px; border-radius:20px; text-decoration:none; font-size:12px; font-weight:bold; margin-left:auto; }
            .arc-list { background:#111; border:1px solid #222; border-radius:8px; overflow:hidden; }
            .arc-row { display:flex; padding:12px; border-bottom:1px solid #222; font-size:13px; align-items:center; }
            .arc-info { flex:1; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
            .loading { padding:40px; text-align:center; color:#666; }
            .spinner { width:24px; height:24px; border:2px solid #333; border-top-color:#fb923c; border-radius:50%; animation:spin .8s linear infinite; margin:0 auto 10px; }
            @keyframes spin { to { transform:rotate(360deg); } }
            .error-box { background:rgba(255,0,0,0.1); border:1px solid rgba(255,0,0,0.2); color:#ff8888; padding:15px; border-radius:8px; font-size:13px; }
        </style>
        </head>
        <body>
        <header>
        <a href="javascript:history.back()" style="color:#888;text-decoration:none;font-size:13px;flex-shrink:0;">&#8592; Back</a>
        <div style="font-size:14px;font-weight:500;flex:1;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">""" + escaped_filename + """</div>
        <span style="font-size:10px;font-weight:600;background:rgba(251,146,60,0.15);color:#fb923c;border-radius:999px;padding:2px 10px;flex-shrink:0;">Archive</span>
        </header>
            <div class="main">
                <div class="card">
                    <div style="font-size:30px;">📦</div>
                    <div>
                        <div style="font-weight:600;">""" + escaped_filename + """</div>
                        <div id="stat" style="font-size:12px; color:#666;">Menyiapkan engine...</div>
                    </div>
                    <a href='""" + raw_src + """' class="btn-dl" download= '""" + escaped_filename + """'>Download</a>
                </div>
                <div id="content">
                    <div class="arc-list" id="list">
                        <div class="loading">
                            <div class="spinner"></div>
                            <div id="status-text">Memproses Archive...</div>
                        </div>
                    </div>
                </div>
            </div>
        <script src="/LibarchiveJs"></script>
        <script type="module">
            const libarchiveMod = await import('/LibarchiveJs');
            const Archive = libarchiveMod.Archive || libarchiveMod.default?.Archive;
            (async () => {
            const list = document.getElementById('list');
            const stat = document.getElementById('stat');
            const statusText = document.getElementById('status-text');
            let currentPath = "";
            function render(allEntries){
                list.innerHTML = '';
                if (currentPath !== "") {
                    const back = document.createElement('div');
                    back.className = 'arc-row';
                    back.style.cursor = 'pointer';
                    back.innerHTML = '⬅️ .. (Back)';
                    back.onclick = () => {
                        const idx = currentPath.lastIndexOf('/');
                        currentPath = idx === -1 ? "" : currentPath.substring(0, idx);
                        render(allEntries);
                    };
                    list.appendChild(back);
                }
                let items = allEntries.filter(e => e.dir === currentPath);
                items.sort((a,b)=>{
                    if (a.isDir !== b.isDir) return a.isDir ? -1 : 1;
                    return a.name.localeCompare(b.name);
                });
                if (!items.length){
                    list.innerHTML += '<div class="loading">Folder kosong</div>';
                    return;
                }
                items.forEach(item=>{
                    const row = document.createElement('div');
                    row.className = 'arc-row';
                    row.innerHTML = `
                        <div style="margin-right:10px;">
                            ${item.isDir ? '📁' : '📄'}
                        </div>
                        <div style="flex:1">${item.name}</div>
                        <div style="font-size:11px;color:#777">
                            ${item.isDir ? 'DIR' : item.size}
                        </div>
                    `;
                    if (item.isDir){
                        row.style.cursor = 'pointer';
                        row.onclick = ()=>{
                            currentPath = item.path;
                            render(allEntries);
                        };
                    }
                    list.appendChild(row);
                });
            }
            try {
                statusText.textContent = 'Loading...';
                const wRes = await fetch('/WorkerarchiveJs');
                let wCode = await wRes.text();
                const origin = location.origin;
                wCode = wCode.replace(/libarchive\.wasm/g, origin + '/WasmarchiveJs');
                wCode = wCode.replace(/import\.meta\.url/g, `"${origin}/"`);
                const blob = new Blob([wCode], { type:'application/javascript' });
                const workerUrl = URL.createObjectURL(blob);
                Archive.init({
                    workerUrl,
                    getWorker: () => new Worker(workerUrl, { type:'module' })
                });
                const fileUrl = document.querySelector('.btn-dl').getAttribute('href');
                const fBlob = await (await fetch(fileUrl)).blob();
                const arc = await Archive.open(fBlob);
                const rawEntries = await arc.getFilesArray();
                const map = new Map();
                rawEntries.forEach(entry=>{
                    const fileObj = entry.file;
                    if (!fileObj || !fileObj._path) return;
                    const fullPath = fileObj._path.replace(/\/+$/,'');
                    const parts = fullPath.split('/');
                    for (let i=0;i<parts.length-1;i++){
                        const folderPath = parts.slice(0,i+1).join('/');
                        const parent = parts.slice(0,i).join('/');
                        if (!map.has(folderPath)){
                            map.set(folderPath,{
                                name: parts[i],
                                path: folderPath,
                                dir: parent,
                                size:0,
                                isDir:true
                            });
                        }
                    }
                    const name = parts[parts.length-1];
                    const dir  = parts.slice(0,-1).join('/');
                    map.set(fullPath,{
                        name,
                        path: fullPath,
                        dir,
                        size: fileObj._size || 0,
                        isDir:false
                    });
                });
                const allEntries = Array.from(map.values());
                stat.textContent = rawEntries.length + ' file';
                statusText.textContent = 'Selesai';
                render(allEntries);
            } catch(e){
                console.error(e);
                list.innerHTML = `<div class="error-box">${e.message}</div>`;
            }
        })();
        </script>
        </body>
        </html>""";
    }
}