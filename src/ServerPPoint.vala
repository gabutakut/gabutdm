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
    private string get_pptx_page (string file_path, string filename) {
        var raw_src = "/Rawori?path=" + GLib.Uri.escape_string (file_path, "", true);
        var lower   = filename.down ();
        var badge   = lower.has_suffix (".ppt") ? "PPT" :
                    lower.has_suffix (".odp") ? "ODP" : "PPTX";
        bool is_old = lower.has_suffix (".ppt");

        if (is_old) {
            return """<!DOCTYPE html>
        <html><head><meta charset="UTF-8"><style>
        *{margin:0;padding:0;box-sizing:border-box;}
        body{background:#0a0a0a;color:#fff;font-family:Inter,system-ui,sans-serif;min-height:100vh;display:flex;flex-direction:column;}
        header{background:#111;padding:10px 16px;display:flex;align-items:center;gap:10px;border-bottom:1px solid #222;}
        header a{color:#888;text-decoration:none;font-size:13px;}header a:hover{color:#fff;}
        .hd-title{color:#fff;font-size:14px;font-weight:500;flex:1;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
        .page{flex:1;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:14px;padding:40px 20px;text-align:center;}
        .err-title{font-size:15px;font-weight:600;}
        .err-sub{font-size:13px;color:rgba(255,255,255,0.35);max-width:320px;line-height:1.6;}
        .btn-dl{display:inline-flex;align-items:center;gap:8px;background:rgba(255,255,255,0.08);border:0.5px solid rgba(255,255,255,0.15);border-radius:999px;padding:10px 22px;color:#fff;font-size:13px;font-weight:500;text-decoration:none;margin-top:4px;}
        </style></head><body>
        <header><a href="javascript:history.back()">&#8592; Back</a>
        <span class="hd-title">""" + GLib.Markup.escape_text (filename) + """</span>
        <span style="font-size:10px;font-weight:600;background:rgba(251,146,60,0.15);color:#fb923c;border-radius:999px;padding:2px 10px;">PPT</span>
        </header>
        <div class="page">
        <div class="err-title">.ppt format tidak didukung di browser</div>
        <div class="err-sub">.ppt (binary format lama) tidak bisa dibaca JS. Gunakan LibreOffice untuk convert ke .pptx terlebih dahulu, atau download filenya.</div>
        <a class="btn-dl" href='""" + raw_src + """' download = '""" + GLib.Markup.escape_text (filename) + """'>Download .ppt</a>
        </div>
        <script>
        </script>
        </body></html>""";
        }

        return """<!DOCTYPE html>
        <html lang="en">
        <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>""" + GLib.Markup.escape_text (filename) + """</title>
        <style>
        *{margin:0;padding:0;box-sizing:border-box;}
        body{background:#111;color:#fff;font-family:Inter,system-ui,sans-serif;height:100vh;height:100dvh;display:flex;flex-direction:column;overflow:hidden;}
        header{width:100%;background:rgba(10,10,10,0.95);backdrop-filter:blur(20px);padding:0 16px;height:52px;display:flex;align-items:center;gap:10px;border-bottom:0.5px solid rgba(255,255,255,0.08);flex-shrink:0;}
        header a{color:#888;text-decoration:none;font-size:13px;}header a:hover{color:#fff;}
        .hd-title{color:#fff;font-size:14px;font-weight:500;flex:1;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
        .badge{font-size:10px;font-weight:600;background:rgba(251,146,60,0.15);color:#fb923c;border-radius:999px;padding:2px 10px;flex-shrink:0;}

        /* Nav bar */
        .nav-bar{background:#0d0d0d;border-bottom:0.5px solid rgba(255,255,255,0.07);padding:6px 16px;display:flex;align-items:center;gap:8px;flex-shrink:0;}
        .nb-btn{width:28px;height:28px;border-radius:7px;border:none;background:rgba(255,255,255,0.06);color:#fff;display:grid;place-items:center;cursor:pointer;transition:background 0.15s;flex-shrink:0;}
        .nb-btn:hover{background:rgba(255,255,255,0.12);}
        .nb-btn:active{transform:scale(0.9);}
        .nb-btn:disabled{opacity:0.3;cursor:not-allowed;}
        .nb-btn svg{width:13px;height:13px;fill:none;stroke:#fff;stroke-width:2;stroke-linecap:round;stroke-linejoin:round;}
        .slide-lbl{font-size:12px;color:rgba(255,255,255,0.45);font-variant-numeric:tabular-nums;min-width:52px;text-align:center;}
        .nb-spacer{flex:1;}
        .nb-info{font-size:11px;color:rgba(255,255,255,0.25);}

        /* Main layout */
        .layout{flex:1;display:flex;min-height:0;}

        /* Thumbnail sidebar */
        .sidebar{width:140px;flex-shrink:0;overflow-y:auto;background:#0a0a0a;border-right:0.5px solid rgba(255,255,255,0.07);padding:8px;display:flex;flex-direction:column;gap:6px;}
        .sidebar::-webkit-scrollbar{width:3px;}
        .sidebar::-webkit-scrollbar-thumb{background:rgba(255,255,255,0.1);border-radius:999px;}
        .thumb{border-radius:6px;overflow:hidden;cursor:pointer;border:1.5px solid transparent;transition:border-color 0.15s;flex-shrink:0;background:#1a1a1a;position:relative;}
        .thumb:hover{border-color:rgba(251,146,60,0.4);}
        .thumb.active{border-color:#fb923c;}
        .thumb-canvas{width:100%;display:block;}
        .thumb-num{position:absolute;bottom:3px;right:5px;font-size:9px;color:rgba(255,255,255,0.5);font-weight:600;}

        /* Main viewer */
        .viewer{flex:1;overflow-y:auto;background:#1a1a1a;display:flex;align-items:flex-start;justify-content:center;padding:20px;}
        .viewer::-webkit-scrollbar{width:6px;}
        .viewer::-webkit-scrollbar-thumb{background:rgba(255,255,255,0.1);border-radius:999px;}

        /* Slide canvas */
        .slide-canvas-wrap{background:#fff;border-radius:8px;box-shadow:0 8px 40px rgba(0,0,0,0.6);overflow:hidden;position:relative;}
        canvas.main-canvas{display:block;}

        /* Loading */
        .loading{display:flex;flex-direction:column;align-items:center;justify-content:center;gap:14px;flex:1;color:rgba(255,255,255,0.3);font-size:13px;}
        .spinner{width:32px;height:32px;border-radius:50%;border:2.5px solid rgba(255,255,255,0.08);border-top-color:#fb923c;animation:spin 0.8s linear infinite;}
        @keyframes spin{to{transform:rotate(360deg);}}

        /* Controls */
        .controls{position:fixed;bottom:max(16px,env(safe-area-inset-bottom,16px));right:20px;background:rgba(15,15,15,0.92);backdrop-filter:blur(16px);border:0.5px solid rgba(255,255,255,0.12);border-radius:999px;padding:4px 6px;display:flex;align-items:center;gap:2px;box-shadow:0 4px 16px rgba(0,0,0,0.5);z-index:100;}
        .cb{width:30px;height:30px;border-radius:50%;border:none;background:transparent;color:#fff;display:grid;place-items:center;cursor:pointer;transition:background 0.15s;text-decoration:none;}
        .cb:hover{background:rgba(255,255,255,0.1);}
        .cb svg{width:14px;height:14px;fill:none;stroke:#fff;stroke-width:1.7;stroke-linecap:round;stroke-linejoin:round;}
        .csep{width:1px;height:14px;background:rgba(255,255,255,0.1);margin:0 1px;}

        /* Fullscreen */
        .fs-ov{display:none;position:fixed;inset:0;z-index:500;background:#000;flex-direction:column;align-items:center;justify-content:center;}
        .fs-ov.open{display:flex;}
        .fs-ov canvas{max-width:100vw;max-height:calc(100vh - 60px);}
        .fs-bar{position:fixed;bottom:16px;left:50%;transform:translateX(-50%);background:rgba(0,0,0,0.75);backdrop-filter:blur(12px);border-radius:999px;padding:6px 14px;display:flex;align-items:center;gap:10px;z-index:501;}
        .fs-close{position:fixed;top:14px;right:14px;z-index:502;background:rgba(0,0,0,0.6);border:none;color:#fff;width:34px;height:34px;border-radius:50%;cursor:pointer;font-size:16px;display:grid;place-items:center;}

        @media(max-width:600px){.sidebar{display:none;}}
        @media print{header,.nav-bar,.controls,.sidebar,.fs-ov{display:none!important;}.layout{display:block;}.viewer{overflow:visible;height:auto;padding:0;}.slide-canvas-wrap{break-inside:avoid;box-shadow:none;}}
        </style>
        </head>
        <body>
        <header>
        <a href="javascript:history.back()">&#8592; Back</a>
        <span class="hd-title">""" + GLib.Markup.escape_text (filename) + """</span>
        <span class="badge">""" + badge + """</span>
        <a href='"""+ raw_src +"""' download = '""" + GLib.Markup.escape_text (filename) + """' style="color:#a78bfa;text-decoration:none;font-size:13px;flex-shrink:0;display:flex;align-items:center;gap:5px;">
            <svg width="15" height="15" viewBox="0 0 15 15" fill="none" stroke="#a78bfa" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><polyline points="7.5,2 7.5,10"/><polyline points="4,7 7.5,11 11,7"/><line x1="2" y1="13.5" x2="13" y2="13.5"/></svg>
            Download
        </a>
        </header>
        <div class="nav-bar">
        <button class="nb-btn" id="nb-prev" disabled><svg viewBox="0 0 14 14"><polyline points="9,2 5,7 9,12"/></svg></button>
        <span class="slide-lbl" id="slide-lbl">— / —</span>
        <button class="nb-btn" id="nb-next"><svg viewBox="0 0 14 14"><polyline points="5,2 9,7 5,12"/></svg></button>
        <div class="nb-spacer"></div>
        <button class="nb-btn" id="nb-zout"><svg viewBox="0 0 14 14"><line x1="2" y1="7" x2="12" y2="7"/></svg></button>
        <span class="slide-lbl" id="zoom-lbl" style="min-width:44px;">100%</span>
        <button class="nb-btn" id="nb-zin"><svg viewBox="0 0 14 14"><line x1="7" y1="2" x2="7" y2="12"/><line x1="2" y1="7" x2="12" y2="7"/></svg></button>
        <div class="nb-spacer"></div>
        <span class="nb-info" id="nb-info"></span>
        </div>
        <div class="layout">
        <div class="sidebar" id="sidebar"></div>
        <div class="viewer" id="viewer">
            <div class="loading" id="loading">
            <div class="spinner"></div>
            Loading presentation…
            </div>
        </div>
        </div>

        <div class="controls">
        <button class="cb" id="cb-print"><svg viewBox="0 0 16 16"><path d="M4 6V2h8v4"/><rect x="2" y="6" width="12" height="7" rx="1"/><rect x="4" y="10" width="8" height="4" fill="none"/></svg></button>
        <div class="csep"></div>
        <a class="cb" href='""" + raw_src + """' download><svg viewBox="0 0 16 16"><polyline points="8,2 8,11"/><polyline points="4,8 8,12 12,8"/><line x1="2" y1="14" x2="14" y2="14"/></svg></a>
        <button class="cb" id="cb-fs"><svg viewBox="0 0 16 16"><polyline points="2,5 2,2 5,2"/><polyline points="11,2 14,2 14,5"/><polyline points="14,11 14,14 11,14"/><polyline points="5,14 2,14 2,11"/></svg></button>
        </div>

        <!-- Fullscreen -->
        <div class="fs-ov" id="fs-ov">
        <button class="fs-close" onclick="document.getElementById('fs-ov').classList.remove('open')">✕</button>
        <canvas id="fs-canvas"></canvas>
        <div class="fs-bar">
            <button class="nb-btn" id="fs-prev"><svg viewBox="0 0 14 14"><polyline points="9,2 5,7 9,12"/></svg></button>
            <span class="slide-lbl" id="fs-lbl">— / —</span>
            <button class="nb-btn" id="fs-next"><svg viewBox="0 0 14 14"><polyline points="5,2 9,7 5,12"/></svg></button>
        </div>
        </div>
        <script>
        (async () => {
        const FILE_URL = '""" + raw_src + """';
        const viewer   = document.getElementById('viewer');
        const sidebar  = document.getElementById('sidebar');
        const loading  = document.getElementById('loading');
        const slideLbl = document.getElementById('slide-lbl');
        const zoomLbl  = document.getElementById('zoom-lbl');
        const nbInfo   = document.getElementById('nb-info');

        let slides   = [];
        let curSlide = 0;
        let zoom     = 1.0;

        // ── Load JSZip ──
        try {
            await new Promise((res,rej)=>{
            const s=document.createElement('script');s.src='/JsZip';s.onload=res;s.onerror=rej;
            document.head.appendChild(s);
            });
        } catch(e) {
            loading.innerHTML = '<div style="color:#f87171;font-size:13px;">Failed to load JSZip</div>';
            return;
        }

        // ── Fetch PPTX ──
        const resp = await fetch(FILE_URL);

        if (!resp.ok) {
        loading.innerHTML = '<div style="color:#f87171">HTTP ' + resp.status + '</div>';
        return;
        }

        const ct = resp.headers.get("content-type") || "";
        if (!ct.includes("application") && !ct.includes("octet-stream")) {
        loading.innerHTML = '<div style="color:#f87171">Invalid content-type: ' + ct + '</div>';
        return;
        }

        const buf = await resp.arrayBuffer();

        // ── Unzip PPTX ──
        let zip;
        try {
            zip = await JSZip.loadAsync(buf);
        } catch(e) {
            loading.innerHTML = '<div style="color:#f87171;font-size:13px;">Not a valid PPTX file</div>';
            return;
        }
        const preview = new TextDecoder().decode(buf.slice(0, 200));
        if (preview.includes("<html")) {
        loading.innerHTML = '<div style="color:#f87171">Server returned HTML, not PPTX</div>';
        return;
        }
        // ── Parse slide count ──
        const slideFiles = Object.keys(zip.files)
            .filter(f => f.match(/^ppt\/slides\/slide\d+\.xml$/))
            .sort((a,b) => {
            const na = parseInt(a.match(/\d+/)[0]);
            const nb = parseInt(b.match(/\d+/)[0]);
            return na - nb;
            });

        if (slideFiles.length === 0) {
            loading.innerHTML = '<div style="color:#f87171;font-size:13px;">No slides found</div>';
            return;
        }

        nbInfo.textContent = slideFiles.length + ' slides';

        // ── Parse slide dimensions from presentation.xml ──
        let slideW = 9144000, slideH = 6858000; // default 10x7.5 inch in EMU
        try {
            const presXml = await zip.file('ppt/presentation.xml')?.async('text');
            if (presXml) {
            const mSz = presXml.match(/p:sldSz[^>]*cx="(\d+)"[^>]*cy="(\d+)"/);
            if (mSz) { slideW = parseInt(mSz[1]); slideH = parseInt(mSz[2]); }
            }
        } catch {}

        const ASPECT = slideW / slideH;
        const PX_W   = 960; // base render width

        // ── Helper: parse color ──
        function parseColor(node) {
            if (!node) return '#000';
            const srgb = node.match(/<a:srgbClr val="([0-9A-Fa-f]{6})"/);
            if (srgb) return '#' + srgb[1];
            const pst = node.match(/<a:prstClr val="([^"]+)"/);
            const MAP = {black:'#000',white:'#fff',red:'#f00',green:'#0f0',blue:'#00f',
                        yellow:'#ff0',cyan:'#0ff',magenta:'#f0f',orange:'#ffa500',
                        darkBlue:'#00008b',darkRed:'#8b0000',darkGreen:'#006400',
                        gray:'#808080',grey:'#808080',lightGray:'#d3d3d3'};
            if (pst && MAP[pst[1]]) return MAP[pst[1]];
            return null;
        }

        // ── Helper: EMU to px ──
        function emu(v) { return (parseInt(v) / slideW) * PX_W; }

        // ── Parse slide XML → draw on canvas ──
        async function parseSlide(idx) {
            const xml = await zip.file(slideFiles[idx]).async('text');

            // Parse slide layout/master for theme colors (simplified)
            let themeColors = { dk1:'#000',lt1:'#fff',dk2:'#1f3864',lt2:'#e7e6e6',
                                acc1:'#4472c4',acc2:'#ed7d31',acc3:'#a9d18e',
                                acc4:'#ffc000',acc5:'#5b9bd5',acc6:'#70ad47' };

            const canvas = document.createElement('canvas');
            canvas.width  = PX_W;
            canvas.height = Math.round(PX_W / ASPECT);
            const ctx = canvas.getContext('2d');

            // Background
            ctx.fillStyle = '#fff';
            ctx.fillRect(0, 0, canvas.width, canvas.height);

            // Parse background color from slide
            const bgMatch = xml.match(/<p:bg>[\s\S]*?<\/p:bg>/);
            if (bgMatch) {
            const bgColor = parseColor(bgMatch[0]);
            if (bgColor) { ctx.fillStyle = bgColor; ctx.fillRect(0,0,canvas.width,canvas.height); }
            }

            // Parse shapes (sp elements)
            const spRegex = /<p:sp>([\s\S]*?)<\/p:sp>/g;
            let spMatch;
            while ((spMatch = spRegex.exec(xml)) !== null) {
            const sp = spMatch[1];

            // Position & size
            const offMatch = sp.match(/a:off x="(-?\d+)" y="(-?\d+)"/);
            const extMatch = sp.match(/a:ext cx="(\d+)" cy="(\d+)"/);
            if (!offMatch || !extMatch) continue;

            const x = emu(offMatch[1]);
            const y = (parseInt(offMatch[2]) / slideH) * canvas.height;
            const w = emu(extMatch[1]);
            const h = (parseInt(extMatch[2]) / slideH) * canvas.height;

            // Fill
            const solidFill = sp.match(/<a:solidFill>([\s\S]*?)<\/a:solidFill>/);
            if (solidFill) {
                const c = parseColor(solidFill[1]);
                if (c) {
                // Opacity
                const lumMod = solidFill[1].match(/lumMod val="(\d+)"/);
                const alpha   = solidFill[1].match(/alpha val="(\d+)"/);
                ctx.globalAlpha = alpha ? parseInt(alpha[1])/100000 : 1;
                ctx.fillStyle   = c;
                ctx.fillRect(x, y, w, h);
                ctx.globalAlpha = 1;
                }
            }

            // Border
            const ln = sp.match(/<a:ln[^>]*>([\s\S]*?)<\/a:ln>/);
            if (ln) {
                const lc = parseColor(ln[1]);
                const wMatch = ln[0].match(/w="(\d+)"/);
                if (lc) {
                ctx.strokeStyle = lc;
                ctx.lineWidth   = wMatch ? Math.max(1, emu(wMatch[1])) : 1;
                ctx.strokeRect(x, y, w, h);
                }
            }

            // Text paragraphs
            const paras = [...sp.matchAll(/<a:p>([\s\S]*?)<\/a:p>/g)];
            let ty = y + 4;
            for (const pm of paras) {
                const para = pm[1];
                // Runs
                const runs = [...para.matchAll(/<a:r>([\s\S]*?)<\/a:r>/g)];
                let tx = x + 4;
                let lineH = 16;

                // Font size
                const szMatch = para.match(/sz="(\d+)"/);
                const fontSize = szMatch ? Math.max(8, emu(parseInt(szMatch[1]) * 127)) : 14;
                const fsMapped = Math.min(fontSize * (canvas.width / PX_W), h * 0.9);
                lineH = fsMapped + 4;

                // Bold
                const bold = para.match(/b="1"/) ? 'bold ' : '';

                ctx.font = bold + Math.round(fsMapped) + 'px Inter,system-ui,sans-serif';

                // Text color
                const rFill = para.match(/<a:solidFill>([\s\S]*?)<\/a:solidFill>/);
                ctx.fillStyle = rFill ? (parseColor(rFill[1]) || '#000') : '#000';

                // Alignment
                const algn = para.match(/algn="([^"]+)"/);
                if (algn) {
                ctx.textAlign = algn[1]==='ctr'?'center':algn[1]==='r'?'right':'left';
                if (algn[1]==='ctr') tx = x + w/2;
                else if (algn[1]==='r') tx = x + w - 4;
                } else {
                ctx.textAlign = 'left';
                }

                let line = '';
                for (const rm of runs) {
                const rXml  = rm[1];
                const tMatch = rXml.match(/<a:t>([\s\S]*?)<\/a:t>/);
                if (!tMatch) continue;
                const text = tMatch[1]
                    .replace(/&amp;/g,'&').replace(/&lt;/g,'<').replace(/&gt;/g,'>').replace(/&quot;/g,'"').replace(/&#xD;/g,'');

                // Per-run color
                const runFill = rXml.match(/<a:solidFill>([\s\S]*?)<\/a:solidFill>/);
                if (runFill) ctx.fillStyle = parseColor(runFill[1]) || ctx.fillStyle;

                // Per-run bold
                const runBold = rXml.match(/b="1"/) ? 'bold ' : '';
                const runSz   = rXml.match(/sz="(\d+)"/);
                const runFs   = runSz ? Math.min(emu(parseInt(runSz[1])*127)*(canvas.width/PX_W), h*0.9) : fsMapped;
                ctx.font = runBold + Math.round(runFs) + 'px Inter,system-ui,sans-serif';

                line += text;
                }

                if (line.trim()) {
                // Clip text to shape bounds
                ctx.save();
                ctx.rect(x, y, w, h);
                ctx.clip();
                ctx.fillText(line, tx, ty + lineH - 4, w - 8);
                ctx.restore();
                }
                ty += lineH;
                if (ty > y + h) break;
            }
            }

            // Parse pic (images)
            const picRegex = /<p:pic>([\s\S]*?)<\/p:pic>/g;
            let picMatch;
            while ((picMatch = picRegex.exec(xml)) !== null) {
            const pic = picMatch[1];
            const offM = pic.match(/a:off x="(-?\d+)" y="(-?\d+)"/);
            const extM = pic.match(/a:ext cx="(\d+)" cy="(\d+)"/);
            const rIdM = pic.match(/r:embed="(rId\d+)"/);
            if (!offM || !extM || !rIdM) continue;

            const px = emu(offM[1]);
            const py = (parseInt(offM[2]) / slideH) * canvas.height;
            const pw = emu(extM[1]);
            const ph = (parseInt(extM[2]) / slideH) * canvas.height;

            // Find image in rels
            try {
                const relsPath = 'ppt/slides/_rels/' + slideFiles[idx].split('/').pop() + '.rels';
                const rels = await zip.file(relsPath)?.async('text');
                if (rels) {
                const imgMatch = rels.match(new RegExp('Id="' + rIdM[1] + '"[^>]*Target="([^"]+)"'));
                if (imgMatch) {
                    let imgPath = imgMatch[1].startsWith('../')
                    ? 'ppt/' + imgMatch[1].substring(3)
                    : 'ppt/slides/' + imgMatch[1];
                    const imgData = await zip.file(imgPath)?.async('base64');
                    if (imgData) {
                    const ext = imgPath.split('.').pop().toLowerCase();
                    const mimeMap = {png:'image/png',jpg:'image/jpeg',jpeg:'image/jpeg',gif:'image/gif',svg:'image/svg+xml',webp:'image/webp'};
                    const imgMime = mimeMap[ext] || 'image/png';
                    await new Promise(res => {
                        const img = new Image();
                        img.onload = () => { ctx.drawImage(img, px, py, pw, ph); res(); };
                        img.onerror = res;
                        img.src = 'data:' + imgMime + ';base64,' + imgData;
                    });
                    }
                }
                }
            } catch {}
            }

            return canvas;
        }

        // ── Render all slides ──
        loading.remove();
        viewer.innerHTML = '';

        const mainWrap = document.createElement('div');
        mainWrap.className = 'slide-canvas-wrap';
        viewer.appendChild(mainWrap);

        const mainCanvas = document.createElement('canvas');
        mainCanvas.className = 'main-canvas';
        mainWrap.appendChild(mainCanvas);

        // Pre-parse all slides
        const slideCanvases = [];
        for (let i = 0; i < slideFiles.length; i++) {
            const c = await parseSlide(i);
            slideCanvases.push(c);

            // Thumbnail
            const thumb = document.createElement('div');
            thumb.className = 'thumb' + (i===0?' active':'');
            thumb.dataset.idx = i;
            const tc = document.createElement('canvas');
            tc.className = 'thumb-canvas';
            const tCtx = tc.getContext('2d');
            tc.width  = 120;
            tc.height = Math.round(120 / ASPECT);
            tCtx.drawImage(c, 0, 0, tc.width, tc.height);
            const tn = document.createElement('span');
            tn.className = 'thumb-num';
            tn.textContent = i + 1;
            thumb.appendChild(tc);
            thumb.appendChild(tn);
            thumb.addEventListener('click', () => showSlide(i));
            sidebar.appendChild(thumb);
        }

        function showSlide(idx) {
            if (idx < 0 || idx >= slideFiles.length) return;
            curSlide = idx;
            const sc = slideCanvases[idx];
            const w  = Math.round(PX_W * zoom);
            const h  = Math.round(w / ASPECT);
            mainCanvas.width  = w;
            mainCanvas.height = h;
            const ctx = mainCanvas.getContext('2d');
            ctx.drawImage(sc, 0, 0, w, h);
            mainCanvas.style.width  = w + 'px';
            mainCanvas.style.height = h + 'px';

            // Update labels
            slideLbl.textContent = (idx+1) + ' / ' + slideFiles.length;
            document.getElementById('nb-prev').disabled = idx <= 0;
            document.getElementById('nb-next').disabled = idx >= slideFiles.length - 1;

            // Thumbnail highlight
            sidebar.querySelectorAll('.thumb').forEach((t,i)=>t.classList.toggle('active',i===idx));
            sidebar.querySelectorAll('.thumb')[idx]?.scrollIntoView({block:'nearest'});

            // Fullscreen update
            const fsCanvas = document.getElementById('fs-canvas');
            const maxW = window.innerWidth;
            const maxH = window.innerHeight - 60;
            const fsW  = Math.min(maxW, maxH * ASPECT);
            const fsH  = fsW / ASPECT;
            fsCanvas.width  = Math.round(fsW);
            fsCanvas.height = Math.round(fsH);
            fsCanvas.getContext('2d').drawImage(sc, 0, 0, fsCanvas.width, fsCanvas.height);
            document.getElementById('fs-lbl').textContent = (idx+1) + ' / ' + slideFiles.length;
            document.getElementById('fs-prev').disabled = idx <= 0;
            document.getElementById('fs-next').disabled = idx >= slideFiles.length - 1;
        }

        showSlide(0);

        // ── Nav ──
        document.getElementById('nb-prev').addEventListener('click', () => showSlide(curSlide-1));
        document.getElementById('nb-next').addEventListener('click', () => showSlide(curSlide+1));
        document.getElementById('fs-prev').addEventListener('click', () => showSlide(curSlide-1));
        document.getElementById('fs-next').addEventListener('click', () => showSlide(curSlide+1));

        // ── Zoom ──
        document.getElementById('nb-zin').addEventListener('click', () => {
            zoom = Math.min(3, zoom + 0.2);
            zoomLbl.textContent = Math.round(zoom*100) + '%';
            showSlide(curSlide);
        });
        document.getElementById('nb-zout').addEventListener('click', () => {
            zoom = Math.max(0.3, zoom - 0.2);
            zoomLbl.textContent = Math.round(zoom*100) + '%';
            showSlide(curSlide);
        });

        // ── Fullscreen ──
        document.getElementById('cb-fs').addEventListener('click', () => {
            document.getElementById('fs-ov').classList.add('open');
            showSlide(curSlide);
        });

        // ── Print ──
        document.getElementById('cb-print').addEventListener('click', () => window.print());

        // ── Keyboard ──
        document.addEventListener('keydown', e => {
            if (e.key==='ArrowLeft'||e.key==='ArrowUp')   showSlide(curSlide-1);
            if (e.key==='ArrowRight'||e.key==='ArrowDown') showSlide(curSlide+1);
            if (e.key==='+') document.getElementById('nb-zin').click();
            if (e.key==='-') document.getElementById('nb-zout').click();
            if (e.key==='Escape') document.getElementById('fs-ov').classList.remove('open');
            if (e.key==='f') document.getElementById('cb-fs').click();
            if (e.key==='p'&&e.ctrlKey){e.preventDefault();window.print();}
        });

        // ── Window resize ──
        window.addEventListener('resize', () => showSlide(curSlide));
        })();
        </script>
        </body>
        </html>""";
    }
}
