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
    private string get_image_page (string file_path, string filename, string mime) {
        var raw_ori  = "/Rawori?path=" + GLib.Uri.escape_string (file_path, "", true);
        var raw_pix  = "/Rawpix?path=" + GLib.Uri.escape_string (file_path, "", true);
        var dir_path = Path.get_dirname (file_path);
        var file = File.new_for_path (file_path);
        if (file.query_exists ()) {
            dir_path = file.get_path ();
        }
        var cur_file = Path.get_basename (file_path);
        return """<!DOCTYPE html>
        <html lang="en">
        <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <title>%s</title>
        <style>
        *{margin:0;padding:0;box-sizing:border-box;}
        body{
        background:#0a0a0a;color:#fff;
        font-family:Inter,system-ui,sans-serif;
        height:100vh;height:100dvh;
        display:flex;flex-direction:column;
        overflow:hidden;user-select:none;-webkit-user-select:none;
        }
        header{
        width:100%%;background:#111;padding:10px 16px;
        display:flex;align-items:center;gap:10px;
        border-bottom:1px solid #222;flex-shrink:0;z-index:10;
        }
        header a{color:#888;text-decoration:none;font-size:13px;flex-shrink:0;}
        header a:hover{color:#fff;}
        .hd-title{color:#fff;font-size:14px;font-weight:500;flex:1;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
        .hd-zoom{color:#888;font-size:12px;font-variant-numeric:tabular-nums;flex-shrink:0;min-width:40px;text-align:right;}
        .player{
        flex:1;position:relative;overflow:hidden;
        display:flex;align-items:center;justify-content:center;
        cursor:grab;background:#000;min-height:0;
        }
        .player.grabbing{cursor:grabbing;}
        .img-wrap{position:absolute;transform-origin:center center;will-change:transform;}
        .img-wrap::before{
        content:'';position:absolute;inset:0;z-index:-1;
        background-image:
            linear-gradient(45deg,#1a1a1a 25%%,transparent 25%%),
            linear-gradient(-45deg,#1a1a1a 25%%,transparent 25%%),
            linear-gradient(45deg,transparent 75%%,#1a1a1a 75%%),
            linear-gradient(-45deg,transparent 75%%,#1a1a1a 75%%);
        background-size:16px 16px;
        background-position:0 0,0 8px,8px -8px,-8px 0;
        }
        .img-wrap img{display:block;max-width:none;pointer-events:none;-webkit-user-drag:none;}
        .controls{
        position:absolute;
        bottom:max(12px,env(safe-area-inset-bottom,12px));
        left:50%%;transform:translateX(-50%%);
        width:calc(100%% - 24px);max-width:560px;
        background:rgba(255,255,255,0.1);
        backdrop-filter:blur(16px) saturate(1.5);
        -webkit-backdrop-filter:blur(16px) saturate(1.5);
        border:1px solid rgba(255,255,255,0.12);
        border-radius:999px;padding:4px 6px;
        display:flex;align-items:center;justify-content:center;gap:0;
        box-shadow:0 0 0 1px rgba(0,0,0,0.25),0 4px 20px rgba(0,0,0,0.4);
        z-index:100;opacity:1;transition:opacity 0.25s;pointer-events:auto;
        }
        .controls.hidden{opacity:0;pointer-events:none;}
        .btn{
        width:34px;height:34px;border-radius:50%%;border:none;
        background:transparent;color:#fff;
        display:grid;place-items:center;
        cursor:pointer;flex-shrink:0;
        transition:background 0.15s,transform 0.1s;
        position:relative;-webkit-tap-highlight-color:transparent;
        }
        .btn:hover{background:rgba(255,255,255,0.12);}
        .btn:active{background:rgba(255,255,255,0.2);transform:scale(0.88);}
        .btn svg{width:16px;height:16px;fill:none;stroke:#fff;stroke-width:1.7;stroke-linecap:round;stroke-linejoin:round;display:block;pointer-events:none;}
        @media(hover:hover){
        .btn::after{
            content:attr(title);
            position:absolute;bottom:calc(100%% + 10px);left:50%%;
            transform:translateX(-50%%);
            background:rgba(20,20,20,0.92);
            border:1px solid rgba(255,255,255,0.1);
            border-radius:999px;padding:4px 10px;
            font-size:11px;white-space:nowrap;color:#fff;
            pointer-events:none;opacity:0;transition:opacity 0.15s;
        }
        .btn:hover::after{opacity:1;}
        }
        .btn.active-mode{background:rgba(96,165,250,0.2);border:1px solid rgba(96,165,250,0.3);}
        .sep{width:1px;height:18px;background:rgba(255,255,255,0.15);margin:0 2px;flex-shrink:0;}
        @media(max-width:420px){
        .btn{width:28px;height:28px;}
        .btn svg{width:14px;height:14px;}
        .sep{margin:0 1px;}
        }

        /* ── Source dialog ── */
        .src-overlay{
        display:none;position:fixed;inset:0;z-index:300;
        background:rgba(0,0,0,0.7);
        backdrop-filter:blur(16px);-webkit-backdrop-filter:blur(16px);
        align-items:center;justify-content:center;padding:20px;
        }
        .src-overlay.open{display:flex;}
        .src-card{
        background:#161616;
        border:0.5px solid rgba(255,255,255,0.1);
        border-radius:20px;width:100%%;max-width:300px;
        padding:24px 20px 20px;
        display:flex;flex-direction:column;align-items:center;gap:12px;
        box-shadow:0 32px 64px rgba(0,0,0,0.7);
        animation:srcIn 0.22s cubic-bezier(0.34,1.56,0.64,1) both;
        }
        @keyframes srcIn{
        from{opacity:0;transform:scale(0.88) translateY(10px);}
        to  {opacity:1;transform:scale(1) translateY(0);}
        }
        .src-title{font-size:15px;font-weight:700;color:#fff;}
        .src-sub{font-size:12px;color:rgba(255,255,255,0.3);text-align:center;line-height:1.6;}
        .src-btns{display:flex;flex-direction:column;gap:8px;width:100%%;}
        .src-btn{
        width:100%%;padding:12px 16px;
        border-radius:12px;border:0.5px solid rgba(255,255,255,0.1);
        background:rgba(255,255,255,0.05);
        color:#fff;font-size:13px;font-weight:500;font-family:inherit;
        cursor:pointer;text-align:left;
        display:flex;align-items:center;gap:12px;
        transition:background 0.15s,border-color 0.15s;
        }
        .src-btn:hover{background:rgba(255,255,255,0.1);border-color:rgba(255,255,255,0.2);}
        .src-btn:active{transform:scale(0.98);}
        .src-btn.active{
        background:rgba(96,165,250,0.12);
        border-color:rgba(96,165,250,0.3);
        }
        .src-btn svg{
        width:18px;height:18px;flex-shrink:0;fill:none;
        stroke:currentColor;stroke-width:1.6;
        stroke-linecap:round;stroke-linejoin:round;
        }
        .src-btn.ori{color:#34d399;}
        .src-btn.pix{color:#60a5fa;}
        .src-btn-label{display:flex;flex-direction:column;gap:2px;}
        .src-btn-title{font-size:13px;font-weight:600;}
        .src-btn-desc{font-size:11px;opacity:0.5;font-weight:400;}
        .src-cancel{
        width:100%%;padding:10px;
        background:transparent;border:0.5px solid rgba(255,255,255,0.08);
        border-radius:10px;color:rgba(255,255,255,0.4);
        font-size:13px;font-family:inherit;cursor:pointer;
        transition:background 0.15s;
        }
        .src-cancel:hover{background:rgba(255,255,255,0.06);}
        /* mode badge di header */
        .mode-badge{
        font-size:10px;font-weight:600;
        padding:2px 8px;border-radius:999px;
        flex-shrink:0;
        }
        .mode-badge.ori{background:rgba(52,211,153,0.15);color:#34d399;}
        .mode-badge.pix{background:rgba(96,165,250,0.15);color:#60a5fa;}
        </style>
        </head>
        <body>
        <header>
        <a href="javascript:history.back()">&#8592; Back</a>
        <span class="hd-title">%s</span>
        <span class="mode-badge ori" id="mode-badge">Original</span>
        <span class="hd-zoom" id="zlbl">100%%</span>
        <a id="btn-download" href=# download
            style="color:#a78bfa;text-decoration:none;font-size:13px;flex-shrink:0;display:flex;align-items:center;gap:5px;">
            <svg width="15" height="15" viewBox="0 0 15 15" fill="none" stroke="#a78bfa" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><polyline points="7.5,2 7.5,10"/><polyline points="4,7 7.5,11 11,7"/><line x1="2" y1="13.5" x2="13" y2="13.5"/></svg>
            Download
        </a>
        </header>
        <div class="player" id="player">
        <div class="img-wrap" id="img-wrap">
            <img id="img" src="%s" alt="%s" draggable="false">
        </div>
        <div class="controls" id="controls">
            <button class="btn" id="btn-prev" title="Previous image">
            <svg viewBox="0 0 18 18"><polyline points="11,4 6,9 11,14"/></svg>
            </button>
            <button class="btn" id="btn-next" title="Next image">
            <svg viewBox="0 0 18 18"><polyline points="7,4 12,9 7,14"/></svg>
            </button>
            <button class="btn" id="btn-zi" title="Zoom in">
            <svg viewBox="0 0 18 18"><circle cx="8" cy="8" r="5.5"/><line x1="12.5" y1="12.5" x2="16" y2="16"/><line x1="8" y1="5.5" x2="8" y2="10.5"/><line x1="5.5" y1="8" x2="10.5" y2="8"/></svg>
            </button>
            <button class="btn" id="btn-zo" title="Zoom out">
            <svg viewBox="0 0 18 18"><circle cx="8" cy="8" r="5.5"/><line x1="12.5" y1="12.5" x2="16" y2="16"/><line x1="5.5" y1="8" x2="10.5" y2="8"/></svg>
            </button>
            <button class="btn" id="btn-fit" title="Fit">
            <svg viewBox="0 0 18 18"><polyline points="2,6 2,2 6,2"/><polyline points="12,2 16,2 16,6"/><polyline points="16,12 16,16 12,16"/><polyline points="6,16 2,16 2,12"/></svg>
            </button>
            <button class="btn" id="btn-orig" title="1:1">
            <svg viewBox="0 0 18 18"><rect x="2" y="2" width="14" height="14" rx="2"/><text x="9" y="12" font-size="6.5" font-family="sans-serif" font-weight="600" fill="#fff" stroke="none" text-anchor="middle">1:1</text></svg>
            </button>
            <button class="btn" id="btn-rl" title="Rotate left">
            <svg viewBox="0 0 18 18"><path d="M3 9a6 6 0 106-6"/><polyline points="1,5 3,9 7,7"/></svg>
            </button>
            <button class="btn" id="btn-rr" title="Rotate right">
            <svg viewBox="0 0 18 18"><path d="M15 9a6 6 0 11-6-6"/><polyline points="17,5 15,9 11,7"/></svg>
            </button>
            <button class="btn" id="btn-fh" title="Flip H">
            <svg viewBox="0 0 18 18"><line x1="9" y1="2" x2="9" y2="16"/><polyline points="5,5 2,9 5,13"/><polyline points="13,5 16,9 13,13"/></svg>
            </button>
            <button class="btn" id="btn-fv" title="Flip V">
            <svg viewBox="0 0 18 18"><line x1="2" y1="9" x2="16" y2="9"/><polyline points="5,5 9,2 13,5"/><polyline points="5,13 9,16 13,13"/></svg>
            </button>
            <button class="btn" id="btn-res" title="Reset">
            <svg viewBox="0 0 18 18"><path d="M3 9a6 6 0 106-6"/><polyline points="1,5 3,9 7,7"/></svg>
            </button>
            <button class="btn" id="btn-src" title="Image source">
            <svg viewBox="0 0 18 18"><circle cx="9" cy="9" r="7"/><line x1="9" y1="6" x2="9" y2="9"/><circle cx="9" cy="12" r="0.8" fill="#fff" stroke="none"/></svg>
            </button>
            <button class="btn" id="btn-fs" title="Fullscreen">
            <svg id="ico-fs" viewBox="0 0 18 18"><polyline points="2,6 2,2 6,2"/><polyline points="12,2 16,2 16,6"/><polyline points="16,12 16,16 12,16"/><polyline points="6,16 2,16 2,12"/></svg>
            <svg id="ico-exfs" viewBox="0 0 18 18" style="display:none"><polyline points="6,2 2,2 2,6"/><polyline points="12,2 16,2 16,6"/><polyline points="16,16 12,12"/><polyline points="2,16 6,12"/><polyline points="6,6 2,2"/><polyline points="12,6 16,2"/><polyline points="16,12 16,16 12,16"/><polyline points="2,12 2,16 6,16"/></svg>
            </button>
        </div>
        </div>

        <!-- Source dialog -->
        <div class="src-overlay" id="src-overlay" onclick="srcBg(event)">
        <div class="src-card">
            <div class="src-title">Image Source</div>
            <div class="src-sub">Choose how the image is rendered</div>
            <div class="src-btns">
            <button class="src-btn ori" id="src-ori" onclick="setSource('ori')">
                <svg viewBox="0 0 18 18"><rect x="1" y="1" width="16" height="16" rx="2"/><circle cx="6" cy="6" r="1.5" fill="#34d399" stroke="none"/><path d="M1 12l4-4 3 3 3-3 5 5"/></svg>
                <div class="src-btn-label">
                <div class="src-btn-title">Original</div>
                <div class="src-btn-desc">Serve file as-is, no processing</div>
                </div>
            </button>
            <button class="src-btn pix" id="src-pix" onclick="setSource('pix')">
                <svg viewBox="0 0 18 18"><rect x="1" y="1" width="16" height="16" rx="2"/><path d="M5 9a4 4 0 018 0"/><circle cx="9" cy="9" r="2" fill="#60a5fa" stroke="none"/></svg>
                <div class="src-btn-label">
                <div class="src-btn-title">Pixbuf</div>
                <div class="src-btn-desc">Convert via GDK Pixbuf (compatible)</div>
                </div>
            </button>
            <button class="src-cancel" onclick="srcClose()">Cancel</button>
            </div>
        </div>
        </div>

        <script>
        const player=document.getElementById('player');
        const wrap  =document.getElementById('img-wrap');
        const img   =document.getElementById('img');
        const zlbl  =document.getElementById('zlbl');
        const ctrl  =document.getElementById('controls');
        const badge =document.getElementById('mode-badge');

        let scale=1,rot=0,flipH=1,flipV=1,tx=0,ty=0;

        let URL_ORI_CUR = '%s';
        let URL_PIX_CUR = '%s';
        let currentSrc  = 'ori';

        function setSource(mode) {
        currentSrc = mode;
        const newSrc = mode === 'ori' ? URL_ORI_CUR : URL_PIX_CUR;
        scale=1;rot=0;flipH=1;flipV=1;tx=0;ty=0;
        img.src = newSrc;
        badge.textContent = mode === 'ori' ? 'Original' : 'Pixbuf';
        badge.className   = 'mode-badge ' + mode;
        document.getElementById('src-ori').classList.toggle('active', mode === 'ori');
        document.getElementById('src-pix').classList.toggle('active', mode === 'pix');
        srcClose();
        }

        // Init active state
        document.getElementById('src-ori').classList.add('active');

        // ── Source dialog ──
        function srcOpen(){
        document.getElementById('src-overlay').classList.add('open');
        document.body.style.overflow='hidden';
        }
        function srcClose(){
        document.getElementById('src-overlay').classList.remove('open');
        document.body.style.overflow='';
        }
        function srcBg(e){
        if(e.target===document.getElementById('src-overlay')) srcClose();
        }
        document.getElementById('btn-src').addEventListener('click', srcOpen);

        // ── Controls show/hide ──
        const isTouch=window.matchMedia('(hover:none)').matches;
        let hideTimer=null;
        function showCtrl(){
        if(isTouch)return;
        ctrl.classList.remove('hidden');
        clearTimeout(hideTimer);
        hideTimer=setTimeout(()=>ctrl.classList.add('hidden'),2500);
        }
        if(!isTouch){
        player.addEventListener('mousemove',showCtrl);
        ctrl.addEventListener('mouseenter',()=>{ clearTimeout(hideTimer);ctrl.classList.remove('hidden'); });
        ctrl.addEventListener('mouseleave',showCtrl);
        }

        function applyT(animate){
        wrap.style.transition=animate?'transform 0.25s cubic-bezier(0.25,0.46,0.45,0.94)':'none';
        wrap.style.transform=
            'translate('+tx+'px,'+ty+'px)'+
            ' rotate('+rot+'deg)'+
            ' scaleX('+(scale*flipH)+')'+
            ' scaleY('+(scale*flipV)+')';
        zlbl.textContent=Math.round(scale*100)+'%%';
        }
        function calcFit(){
        return Math.min(
            (player.clientWidth -40)/img.naturalWidth,
            (player.clientHeight-40)/img.naturalHeight,
            1);
        }
        function fitImage(animate){ scale=calcFit();tx=0;ty=0;applyT(animate); }

        img.addEventListener('load',()=>fitImage(false));
        if(img.complete&&img.naturalWidth) fitImage(false);

        function zoomAt(factor,cx,cy){
        const ns=Math.min(10,Math.max(0.05,scale*factor));
        const r=ns/scale;
        tx=cx+(tx-cx)*r;ty=cy+(ty-cy)*r;
        scale=ns;applyT(false);
        }
        function centerZoom(f){ zoomAt(f,0,0); }

        document.getElementById('btn-zi').addEventListener('click',  ()=>centerZoom(1.15));
        document.getElementById('btn-zo').addEventListener('click',  ()=>centerZoom(0.85));
        document.getElementById('btn-fit').addEventListener('click', ()=>fitImage(true));
        document.getElementById('btn-orig').addEventListener('click',()=>{ scale=1;tx=0;ty=0;applyT(true); });
        document.getElementById('btn-rl').addEventListener('click',  ()=>{ rot-=90;applyT(true); });
        document.getElementById('btn-rr').addEventListener('click',  ()=>{ rot+=90;applyT(true); });
        document.getElementById('btn-fh').addEventListener('click',  ()=>{ flipH*=-1;applyT(true); });
        document.getElementById('btn-fv').addEventListener('click',  ()=>{ flipV*=-1;applyT(true); });
        document.getElementById('btn-res').addEventListener('click', ()=>{ rot=0;flipH=1;flipV=1;fitImage(true); });

        player.addEventListener('wheel',(e)=>{
        e.preventDefault();
        const r=player.getBoundingClientRect();
        zoomAt(e.deltaY<0?1.15:0.85,
            e.clientX-r.left-r.width/2,
            e.clientY-r.top-r.height/2);
        showCtrl();
        },{passive:false});

        let panning=false,panX=0,panY=0;
        player.addEventListener('mousedown',(e)=>{
        if(e.button!==0||e.target.closest('#controls'))return;
        panning=true;panX=e.clientX-tx;panY=e.clientY-ty;
        player.classList.add('grabbing');
        });
        document.addEventListener('mousemove',(e)=>{
        if(!panning)return;
        tx=e.clientX-panX;ty=e.clientY-panY;applyT(false);
        });
        document.addEventListener('mouseup',()=>{ panning=false;player.classList.remove('grabbing'); });

        let t1x=0,t1y=0,tPanning=false,lastDist=0;
        player.addEventListener('touchstart',(e)=>{
        if(e.touches.length===1&&!e.target.closest('#controls')){
            tPanning=true;t1x=e.touches[0].clientX-tx;t1y=e.touches[0].clientY-ty;
        } else if(e.touches.length===2){
            tPanning=false;
            lastDist=Math.hypot(e.touches[0].clientX-e.touches[1].clientX,e.touches[0].clientY-e.touches[1].clientY);
        }
        },{passive:true});
        player.addEventListener('touchmove',(e)=>{
        e.preventDefault();
        if(e.touches.length===1&&tPanning){
            tx=e.touches[0].clientX-t1x;ty=e.touches[0].clientY-t1y;applyT(false);
        } else if(e.touches.length===2){
            const d=Math.hypot(e.touches[0].clientX-e.touches[1].clientX,e.touches[0].clientY-e.touches[1].clientY);
            const r=player.getBoundingClientRect();
            zoomAt(d/lastDist,
            (e.touches[0].clientX+e.touches[1].clientX)/2-r.left-r.width/2,
            (e.touches[0].clientY+e.touches[1].clientY)/2-r.top-r.height/2);
            lastDist=d;
        }
        },{passive:false});
        player.addEventListener('touchend',()=>{ tPanning=false; });

        const btnFs=document.getElementById('btn-fs');
        const icoFs=document.getElementById('ico-fs');
        const icoEx=document.getElementById('ico-exfs');
        btnFs.addEventListener('click',()=>{
        if(!document.fullscreenElement) document.documentElement.requestFullscreen();
        else document.exitFullscreen();
        });
        document.addEventListener('fullscreenchange',()=>{
        const fs=!!document.fullscreenElement;
        icoFs.style.display=fs?'none':'';
        icoEx.style.display=fs?'':'none';
        setTimeout(()=>fitImage(true),50);
        });

        document.addEventListener('keydown',(e)=>{
        if(['INPUT','TEXTAREA'].includes(document.activeElement.tagName))return;
        if(e.key==='Escape') srcClose();
        showCtrl();
        if(e.key==='+'||e.key==='=') centerZoom(1.15);
        if(e.key==='-')              centerZoom(0.85);
        if(e.key==='0')              fitImage(true);
        if(e.key==='1')              { scale=1;tx=0;ty=0;applyT(true); }
        if(e.key==='r')              { rot+=90;applyT(true); }
        if(e.key==='R')              { rot-=90;applyT(true); }
        if(e.key==='h')              { flipH*=-1;applyT(true); }
        if(e.key==='v')              { flipV*=-1;applyT(true); }
        if(e.key==='f')              btnFs.click();
        if(e.key==='ArrowLeft')      { tx-=40;applyT(false); }
        if(e.key==='ArrowRight')     { tx+=40;applyT(false); }
        if(e.key==='ArrowUp')        { ty-=40;applyT(false); }
        if(e.key==='ArrowDown')      { ty+=40;applyT(false); }
        });

        window.addEventListener('resize',()=>fitImage(false));
        // ── Playlist ──
        const DIR_PATH = '%s';
        const CUR_FILE = '%s';
        let playlist = [], curIdx = -1;

        (async () => {
        try {
            const resp = await fetch('/DirListImage?path=' + encodeURIComponent(DIR_PATH));
            const list = await resp.json();
            playlist   = list;
            curIdx     = list.findIndex(f => f.name === CUR_FILE);
            updateNavBtns();
        } catch(e) { console.log('DirListImage err', e); }
        })();

        function updateNavBtns() {
        const prevBtn = document.getElementById('btn-prev');
        const nextBtn = document.getElementById('btn-next');
        if (prevBtn) prevBtn.style.opacity = curIdx <= 0 ? '0.3' : '1';
        if (nextBtn) nextBtn.style.opacity = curIdx >= playlist.length - 1 ? '0.3' : '1';
        }
        const btnDownload = document.getElementById('btn-download');
        function loadImage(idx) {
        if (idx < 0 || idx >= playlist.length) return;
        curIdx = idx;
        const f = playlist[idx];

        // Update kedua URL sesuai file baru
        URL_ORI_CUR = '/Rawori?path=' + f.path;
        URL_PIX_CUR = '/Rawpix?path=' + f.path;

        // Reset transform
        scale=1;rot=0;flipH=1;flipV=1;tx=0;ty=0;

        // Load sesuai mode yang sedang aktif
        img.src = currentSrc === 'ori' ? URL_ORI_CUR : URL_PIX_CUR;

        document.querySelector('.hd-title').textContent = f.name;
        const url = '/Rawori?path=' + (f.path);
        btnDownload.href = url;
        btnDownload.download = f.name;
        history.replaceState(null, '', '/Player?path=' + f.path);
        updateNavBtns();
        }
        btnDownload.href = URL_ORI_CUR;
        btnDownload.download = document.querySelector('.hd-title').textContent;
        document.getElementById('btn-prev').addEventListener('click', () => {
        if (curIdx > 0) loadImage(curIdx - 1);
        });
        document.getElementById('btn-next').addEventListener('click', () => {
        if (curIdx < playlist.length - 1) loadImage(curIdx + 1);
        });

        // Keyboard prev/next
        // Tambah di keydown yang sudah ada
        document.addEventListener('keydown', (e) => {
        if (['INPUT','TEXTAREA'].includes(document.activeElement.tagName)) return;
        if (e.key === 'ArrowLeft'  && e.ctrlKey) { e.preventDefault(); if(curIdx>0) loadImage(curIdx-1); }
        if (e.key === 'ArrowRight' && e.ctrlKey) { e.preventDefault(); if(curIdx<playlist.length-1) loadImage(curIdx+1); }
        // Swipe touch next/prev
        });
        </script>
        </body>
        </html>""".printf (filename, filename, raw_ori, filename, raw_ori, raw_pix, dir_path, cur_file);
    }
}