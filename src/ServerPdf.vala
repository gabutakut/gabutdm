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
    private string get_pdf_page (string file_path, string filename) {
        var raw_src = "/Rawori?path=" + GLib.Uri.escape_string (file_path, "", true);
        string? html = """<!DOCTYPE html>
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
        .hd-info{color:rgba(255,255,255,0.3);font-size:12px;flex-shrink:0;}
        .viewer{
        flex:1;overflow-y:auto;overflow-x:hidden;
        display:flex;flex-direction:column;align-items:center;
        gap:10px;padding:16px 12px;min-height:0;
        }
        .viewer::-webkit-scrollbar{width:6px;}
        .viewer::-webkit-scrollbar-track{background:transparent;}
        .viewer::-webkit-scrollbar-thumb{background:rgba(255,255,255,0.12);border-radius:999px;}
        canvas{
        display:block;background:#fff;
        box-shadow:0 4px 24px rgba(0,0,0,0.5);
        border-radius:3px;max-width:100%;
        }
        .loading{
        flex:1;display:flex;flex-direction:column;
        align-items:center;justify-content:center;gap:14px;
        color:rgba(255,255,255,0.35);font-size:13px;
        }
        .spinner{
        width:32px;height:32px;border-radius:50%;
        border:2.5px solid rgba(255,255,255,0.08);
        border-top-color:rgba(255,255,255,0.5);
        animation:spin 0.8s linear infinite;
        }
        @keyframes spin{to{transform:rotate(360deg);}}
        .err{
        flex:1;display:none;flex-direction:column;
        align-items:center;justify-content:center;gap:12px;
        color:rgba(255,255,255,0.35);font-size:13px;text-align:center;padding:24px;
        }
        .controls{
        position:fixed;
        bottom:max(16px,env(safe-area-inset-bottom,16px));
        left:50%;transform:translateX(-50%);
        background:rgba(30,30,30,0.9);
        backdrop-filter:blur(20px) saturate(1.5);
        -webkit-backdrop-filter:blur(20px) saturate(1.5);
        border:0.5px solid rgba(255,255,255,0.12);
        border-radius:999px;padding:5px 8px;
        display:flex;align-items:center;gap:3px;
        box-shadow:0 4px 24px rgba(0,0,0,0.6);z-index:100;
        }
        .btn{
        width:34px;height:34px;border-radius:50%;border:none;
        background:transparent;color:#fff;
        display:grid;place-items:center;cursor:pointer;
        transition:background 0.15s,transform 0.1s;
        -webkit-tap-highlight-color:transparent;
        }
        .btn:hover{background:rgba(255,255,255,0.1);}
        .btn:active{transform:scale(0.88);}
        .btn:disabled{opacity:0.3;cursor:not-allowed;transform:none;}
        .btn svg{width:16px;height:16px;fill:none;stroke:#fff;stroke-width:1.7;stroke-linecap:round;stroke-linejoin:round;}
        .lbl{font-size:12px;color:rgba(255,255,255,0.6);padding:0 4px;white-space:nowrap;font-variant-numeric:tabular-nums;}
        .sep{width:1px;height:18px;background:rgba(255,255,255,0.12);margin:0 2px;}
        </style>
        </head>
        <body>
        <header>
        <a href="javascript:history.back()">&#8592; Back</a>
        <span class="hd-title">""" + GLib.Markup.escape_text (filename) + """</span>
        <span class="hd-info" id="hd-info"></span>
        <a href='"""+ raw_src +"""' download = '""" + GLib.Markup.escape_text (filename) + """' style="color:#a78bfa;text-decoration:none;font-size:13px;flex-shrink:0;display:flex;align-items:center;gap:5px;">
            <svg width="15" height="15" viewBox="0 0 15 15" fill="none" stroke="#a78bfa" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><polyline points="7.5,2 7.5,10"/><polyline points="4,7 7.5,11 11,7"/><line x1="2" y1="13.5" x2="13" y2="13.5"/></svg>
            Download
        </a>
        </header>
        <div class="viewer" id="viewer">
        <div class="loading" id="loading">
            <div class="spinner"></div>Loading PDF…
        </div>
        <div class="err" id="err">
            Failed to load PDF.<br>
            <a style="color:#60a5fa;font-size:12px;margin-top:4px;" href='""" + raw_src + """' download>Download instead</a>
        </div>
        </div>
        <div class="controls">
        <button class="btn" id="btn-prev" disabled>
            <svg viewBox="0 0 18 18"><polyline points="11,4 6,9 11,14"/></svg>
        </button>
        <span class="lbl" id="page-lbl">— / —</span>
        <button class="btn" id="btn-next" disabled>
            <svg viewBox="0 0 18 18"><polyline points="7,4 12,9 7,14"/></svg>
        </button>
        <div class="sep"></div>
        <button class="btn" id="btn-zi">
            <svg viewBox="0 0 18 18"><circle cx="8" cy="8" r="5.5"/><line x1="12.5" y1="12.5" x2="16" y2="16"/><line x1="8" y1="5.5" x2="8" y2="10.5"/><line x1="5.5" y1="8" x2="10.5" y2="8"/></svg>
        </button>
        <span class="lbl" id="zoom-lbl">100%</span>
        <button class="btn" id="btn-zo">
            <svg viewBox="0 0 18 18"><circle cx="8" cy="8" r="5.5"/><line x1="12.5" y1="12.5" x2="16" y2="16"/><line x1="5.5" y1="8" x2="10.5" y2="8"/></svg>
        </button>
        <div class="sep"></div>
        <button class="btn" id="btn-fit">
            <svg viewBox="0 0 18 18"><polyline points="2,6 2,2 6,2"/><polyline points="12,2 16,2 16,6"/><polyline points="16,12 16,16 12,16"/><polyline points="6,16 2,16 2,12"/></svg>
        </button>
        <button class="btn" id="btn-fs">
            <svg id="ico-fs" viewBox="0 0 18 18"><polyline points="2,6 2,2 6,2"/><polyline points="12,2 16,2 16,6"/><polyline points="16,12 16,16 12,16"/><polyline points="6,16 2,16 2,12"/></svg>
            <svg id="ico-ex" viewBox="0 0 18 18" style="display:none"><polyline points="6,2 2,2 2,6"/><polyline points="12,2 16,2 16,6"/><polyline points="16,16 12,12"/><polyline points="2,16 6,12"/></svg>
        </button>
        </div>

        <script>
        (async () => {
        const PDFJS_URL = '/PdfjsLib';
        const WORKER_URL= '/PdfjsWorker';
        const PDF_SRC   = '""" + raw_src + """';
        const viewer   = document.getElementById('viewer');
        const loading  = document.getElementById('loading');
        const errDiv   = document.getElementById('err');
        const pageLbl  = document.getElementById('page-lbl');
        const zoomLbl  = document.getElementById('zoom-lbl');
        const hdInfo   = document.getElementById('hd-info');
        const btnPrev  = document.getElementById('btn-prev');
        const btnNext  = document.getElementById('btn-next');
        await new Promise((res, rej) => {
            const s = document.createElement('script');
            s.src = PDFJS_URL;
            s.onload = res;
            s.onerror = rej;
            document.head.appendChild(s);
        });
        try {
            const wResp = await fetch(WORKER_URL);
            const wText = await wResp.text();
            const wBlob = new Blob([wText], { type: 'application/javascript' });
            pdfjsLib.GlobalWorkerOptions.workerSrc = URL.createObjectURL(wBlob);
        } catch {
            pdfjsLib.GlobalWorkerOptions.workerSrc = WORKER_URL;
        }
        let pdfDoc = null, scale = 1.0, fitScale = 1.0;
        const canvases = [];
        async function fitWidth() {
            if (!pdfDoc) return;
            const page = await pdfDoc.getPage(1);
            const vp = page.getViewport({ scale: 1 });
            fitScale = (viewer.clientWidth - 24) / vp.width;
            scale = fitScale;
            zoomLbl.textContent = Math.round(scale * 100) + '%';
            await rerender();
        }
        async function renderAll() {
            canvases.length = 0;
            Array.from(viewer.children).forEach(c => {
            if (!c.id) viewer.removeChild(c);
            });
            for (let i = 1; i <= pdfDoc.numPages; i++) {
            const page = await pdfDoc.getPage(i);
            const vp   = page.getViewport({ scale });
            const cv   = document.createElement('canvas');
            cv.width   = vp.width;
            cv.height  = vp.height;
            cv.dataset.page = i;
            viewer.appendChild(cv);
            canvases.push(cv);
            await page.render({ canvasContext: cv.getContext('2d'), viewport: vp }).promise;
            }
            updateLabel();
        }
        async function rerender() {
            for (let i = 1; i <= pdfDoc.numPages; i++) {
            const page = await pdfDoc.getPage(i);
            const vp   = page.getViewport({ scale });
            const cv   = canvases[i - 1];
            cv.width   = vp.width;
            cv.height  = vp.height;
            await page.render({ canvasContext: cv.getContext('2d'), viewport: vp }).promise;
            }
            zoomLbl.textContent = Math.round(scale * 100) + '%';
        }
        function currentPage() {
            const mid = viewer.scrollTop + viewer.clientHeight / 2;
            for (const cv of canvases)
            if (cv.offsetTop + cv.offsetHeight >= mid) return +cv.dataset.page;
            return pdfDoc ? pdfDoc.numPages : 1;
        }
        function updateLabel() {
            const cur = currentPage();
            pageLbl.textContent = cur + ' / ' + pdfDoc.numPages;
            btnPrev.disabled = cur <= 1;
            btnNext.disabled = cur >= pdfDoc.numPages;
        }
        function scrollTo(n) {
            const cv = canvases[n - 1];
            if (cv) viewer.scrollTo({ top: cv.offsetTop - 16, behavior: 'smooth' });
        }
        viewer.addEventListener('scroll', updateLabel);
        try {
            const resp = await fetch(PDF_SRC);
            const buf  = await resp.arrayBuffer();
            pdfDoc = await pdfjsLib.getDocument({ data: buf }).promise;
            hdInfo.textContent = pdfDoc.numPages + ' page' + (pdfDoc.numPages > 1 ? 's' : '');
            loading.remove();
            const firstPage = await pdfDoc.getPage(1);
            const vp0 = firstPage.getViewport({ scale: 1 });
            fitScale = (viewer.clientWidth - 24) / vp0.width;
            scale    = fitScale;
            zoomLbl.textContent = Math.round(scale * 100) + '%';
            await renderAll();
            btnPrev.disabled = false;
            btnNext.disabled = pdfDoc.numPages <= 1;
        } catch (e) {
            loading.remove();
            errDiv.style.display = 'flex';
            console.error(e);
        }
        btnPrev.addEventListener('click', () => scrollTo(currentPage() - 1));
        btnNext.addEventListener('click', () => scrollTo(currentPage() + 1));
        document.getElementById('btn-zi').addEventListener('click', async () => {
            scale = Math.min(4, scale + 0.25);
            await rerender();
        });
        document.getElementById('btn-zo').addEventListener('click', async () => {
            scale = Math.max(0.25, scale - 0.25);
            await rerender();
        });
        document.getElementById('btn-fit').addEventListener('click', fitWidth);
        const btnFs = document.getElementById('btn-fs');
        btnFs.addEventListener('click', () => {
            if (!document.fullscreenElement) document.documentElement.requestFullscreen();
            else document.exitFullscreen();
        });
        document.addEventListener('fullscreenchange', () => {
            const fs = !!document.fullscreenElement;
            document.getElementById('ico-fs').style.display = fs ? 'none' : '';
            document.getElementById('ico-ex').style.display = fs ? '' : 'none';
            setTimeout(fitWidth, 100);
        });
        document.addEventListener('keydown', e => {
            if (e.key === 'ArrowLeft'  || e.key === 'ArrowUp')   { e.preventDefault(); btnPrev.click(); }
            if (e.key === 'ArrowRight' || e.key === 'ArrowDown')  { e.preventDefault(); btnNext.click(); }
            if (e.key === '+' || e.key === '=') document.getElementById('btn-zi').click();
            if (e.key === '-')                  document.getElementById('btn-zo').click();
            if (e.key === '0')                  fitWidth();
            if (e.key === 'f')                  btnFs.click();
        });
        window.addEventListener('resize', fitWidth);
        })();
        </script>
        </body>
        </html>""";
        return html;
    }
}