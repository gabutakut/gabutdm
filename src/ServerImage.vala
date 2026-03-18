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
        var encoded_path = GLib.Uri.escape_string (file_path, "/", true);
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
        overflow:hidden;user-select:none;
        -webkit-user-select:none;
        }
        header{
        width:100%%;background:#111;padding:10px 16px;
        display:flex;align-items:center;gap:10px;
        border-bottom:1px solid #222;flex-shrink:0;z-index:10;
        }
        header a{color:#888;text-decoration:none;font-size:13px;flex-shrink:0;}
        header a:hover{color:#fff;}
        .hd-title{
        color:#fff;font-size:14px;font-weight:500;
        flex:1;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;
        }
        .hd-zoom{
        color:#888;font-size:12px;font-variant-numeric:tabular-nums;
        flex-shrink:0;min-width:40px;text-align:right;
        }
        .player{
        flex:1;position:relative;overflow:hidden;
        display:flex;align-items:center;justify-content:center;
        cursor:grab;background:#000;
        /* pastikan player tidak overflow header */
        min-height:0;
        }
        .player.grabbing{cursor:grabbing;}
        .img-wrap{
        position:absolute;transform-origin:center center;will-change:transform;
        }
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

        /* Controls */
        .controls{
        position:absolute;
        bottom:max(12px, env(safe-area-inset-bottom, 12px));
        left:50%%;
        transform:translateX(-50%%);
        width:calc(100%% - 24px);
        max-width:540px;
        background:rgba(255,255,255,0.1);
        backdrop-filter:blur(16px) saturate(1.5);
        -webkit-backdrop-filter:blur(16px) saturate(1.5);
        border:1px solid rgba(255,255,255,0.12);
        border-radius:999px;
        padding:4px 6px;
        display:flex;
        align-items:center;
        justify-content:center;
        gap:0;
        box-shadow:0 0 0 1px rgba(0,0,0,0.25),0 4px 20px rgba(0,0,0,0.4);
        z-index:100;
        /* default selalu show */
        opacity:1;
        transition:opacity 0.25s;
        pointer-events:auto;
        }
        .controls.hidden{
        opacity:0;
        pointer-events:none;
        }
        .btn{
        width:34px;height:34px;border-radius:50%%;border:none;
        background:transparent;color:#fff;
        display:grid;place-items:center;
        cursor:pointer;flex-shrink:0;
        transition:background 0.15s,transform 0.1s;
        position:relative;
        -webkit-tap-highlight-color:transparent;
        }
        .btn:hover{background:rgba(255,255,255,0.12);}
        .btn:active{
        background:rgba(255,255,255,0.2);
        transform:scale(0.88);
        }
        .btn svg{
        width:16px;height:16px;fill:none;stroke:#fff;
        stroke-width:1.7;stroke-linecap:round;stroke-linejoin:round;
        display:block;pointer-events:none;
        }
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
        .sep{
        width:1px;height:18px;
        background:rgba(255,255,255,0.15);
        margin:0 2px;flex-shrink:0;
        }
        /* mobile kecilkan tombol */
        @media(max-width:420px){
        .btn{width:28px;height:28px;}
        .btn svg{width:14px;height:14px;}
        .sep{margin:0 1px;}
        }
        </style>
        </head>
        <body>
        <header>
        <a href="javascript:history.back()">&#8592; Back</a>
        <span class="hd-title">%s</span>
        <span class="hd-zoom" id="zlbl">100%%</span>
        </header>
        <div class="player" id="player">
        <div class="img-wrap" id="img-wrap">
            <img id="img" src="%s" alt="%s" draggable="false">
        </div>
        <div class="controls" id="controls">
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
            <div class="sep"></div>
            <button class="btn" id="btn-rl" title="Rotate left">
            <svg viewBox="0 0 18 18"><path d="M3 9a6 6 0 106-6"/><polyline points="1,5 3,9 7,7"/></svg>
            </button>
            <button class="btn" id="btn-rr" title="Rotate right">
            <svg viewBox="0 0 18 18"><path d="M15 9a6 6 0 11-6-6"/><polyline points="17,5 15,9 11,7"/></svg>
            </button>
            <div class="sep"></div>
            <button class="btn" id="btn-fh" title="Flip H">
            <svg viewBox="0 0 18 18"><line x1="9" y1="2" x2="9" y2="16"/><polyline points="5,5 2,9 5,13"/><polyline points="13,5 16,9 13,13"/></svg>
            </button>
            <button class="btn" id="btn-fv" title="Flip V">
            <svg viewBox="0 0 18 18"><line x1="2" y1="9" x2="16" y2="9"/><polyline points="5,5 9,2 13,5"/><polyline points="5,13 9,16 13,13"/></svg>
            </button>
            <div class="sep"></div>
            <button class="btn" id="btn-res" title="Reset">
            <svg viewBox="0 0 18 18"><path d="M3 9a6 6 0 106-6"/><polyline points="1,5 3,9 7,7"/></svg>
            </button>
            <button class="btn" id="btn-fs" title="Fullscreen">
            <svg id="ico-fs" viewBox="0 0 18 18"><polyline points="2,6 2,2 6,2"/><polyline points="12,2 16,2 16,6"/><polyline points="16,12 16,16 12,16"/><polyline points="6,16 2,16 2,12"/></svg>
            <svg id="ico-exfs" viewBox="0 0 18 18" style="display:none"><polyline points="6,2 2,2 2,6"/><polyline points="12,2 16,2 16,6"/><polyline points="16,16 12,12"/><polyline points="2,16 6,12"/><polyline points="6,6 2,2"/><polyline points="12,6 16,2"/><polyline points="16,12 16,16 12,16"/><polyline points="2,12 2,16 6,16"/></svg>
            </button>
        </div>
        </div>
        <script>
        const player=document.getElementById('player');
        const wrap  =document.getElementById('img-wrap');
        const img   =document.getElementById('img');
        const zlbl  =document.getElementById('zlbl');
        const ctrl  =document.getElementById('controls');

        let scale=1,rot=0,flipH=1,flipV=1,tx=0,ty=0;

        /* ── touch device = selalu tampil, desktop = auto hide ── */
        const isTouch = window.matchMedia('(hover:none)').matches;
        let hideTimer=null;

        function showCtrl(){
        if(isTouch) return; /* touch: selalu tampil, skip */
        ctrl.classList.remove('hidden');
        clearTimeout(hideTimer);
        hideTimer=setTimeout(()=>ctrl.classList.add('hidden'), 2500);
        }
        /* desktop hover agar tidak hilang saat di atas tombol */
        if(!isTouch){
        player.addEventListener('mousemove', showCtrl);
        ctrl.addEventListener('mouseenter',()=>{ clearTimeout(hideTimer); ctrl.classList.remove('hidden'); });
        ctrl.addEventListener('mouseleave', showCtrl);
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

        /* wheel zoom (desktop) */
        player.addEventListener('wheel',(e)=>{
        e.preventDefault();
        const r=player.getBoundingClientRect();
        zoomAt(e.deltaY<0?1.15:0.85,
            e.clientX-r.left-r.width/2,
            e.clientY-r.top-r.height/2);
        showCtrl();
        },{passive:false});

        /* pan mouse */
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

        /* touch: pan 1 jari + pinch 2 jari */
        let t1x=0,t1y=0,tPanning=false,lastDist=0;
        player.addEventListener('touchstart',(e)=>{
        if(e.touches.length===1&&!e.target.closest('#controls')){
            tPanning=true;
            t1x=e.touches[0].clientX-tx;
            t1y=e.touches[0].clientY-ty;
        } else if(e.touches.length===2){
            tPanning=false;
            lastDist=Math.hypot(
            e.touches[0].clientX-e.touches[1].clientX,
            e.touches[0].clientY-e.touches[1].clientY);
        }
        },{passive:true});

        player.addEventListener('touchmove',(e)=>{
        e.preventDefault();
        if(e.touches.length===1&&tPanning){
            tx=e.touches[0].clientX-t1x;
            ty=e.touches[0].clientY-t1y;
            applyT(false);
        } else if(e.touches.length===2){
            const d=Math.hypot(
            e.touches[0].clientX-e.touches[1].clientX,
            e.touches[0].clientY-e.touches[1].clientY);
            const r=player.getBoundingClientRect();
            zoomAt(d/lastDist,
            (e.touches[0].clientX+e.touches[1].clientX)/2-r.left-r.width/2,
            (e.touches[0].clientY+e.touches[1].clientY)/2-r.top-r.height/2);
            lastDist=d;
        }
        },{passive:false});

        player.addEventListener('touchend',()=>{ tPanning=false; });

        /* fullscreen */
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

        /* keyboard */
        document.addEventListener('keydown',(e)=>{
        if(['INPUT','TEXTAREA'].includes(document.activeElement.tagName))return;
        showCtrl();
        if(e.key==='+'||e.key==='=') centerZoom(1.15);
        if(e.key==='-')         centerZoom(0.85);
        if(e.key==='0')         fitImage(true);
        if(e.key==='1')         { scale=1;tx=0;ty=0;applyT(true); }
        if(e.key==='r')         { rot+=90;applyT(true); }
        if(e.key==='R')         { rot-=90;applyT(true); }
        if(e.key==='h')         { flipH*=-1;applyT(true); }
        if(e.key==='v')         { flipV*=-1;applyT(true); }
        if(e.key==='f')         btnFs.click();
        if(e.key==='ArrowLeft')      { tx-=40;applyT(false); }
        if(e.key==='ArrowRight')     { tx+=40;applyT(false); }
        if(e.key==='ArrowUp')        { ty-=40;applyT(false); }
        if(e.key==='ArrowDown')      { ty+=40;applyT(false); }
        });

        window.addEventListener('resize',()=>fitImage(false));
        </script>
        </body>
        </html>""".printf (filename, filename, encoded_path, filename);
    }
}