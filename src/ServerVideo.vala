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
    private string get_video_page (string file_path, string filename, string mime) {
        var encoded_path = GLib.Uri.escape_string (file_path, "/", true);
        return """<!DOCTYPE html>
        <html lang="en">
        <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>%s</title>
        <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background: #0a0a0a;
            color: #fff;
            font-family: Inter, system-ui, sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        header {
            width: 100%%;
            background: #111;
            padding: 12px 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            border-bottom: 1px solid #222;
        }
        header a { color: #888; text-decoration: none; font-size: 13px; transition: color 0.15s; }
        header a:hover { color: #fff; }
        header span { color: #fff; font-size: 14px; font-weight: 500; flex: 1; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .wrap { width: 100%%; max-width: 960px; padding: 28px 16px; }
        .player {
            position: relative;
            width: 100%%;
            aspect-ratio: 16/9;
            background: #000;
            border-radius: 20px;
            overflow: hidden;
            cursor: pointer;
        }
        video { width: 100%%; height: 100%%; object-fit: contain; display: block; }
        .scrim {
            position: absolute; inset: 0;
            background: linear-gradient(to top, rgba(0,0,0,0.65) 0%%, rgba(0,0,0,0.2) 40%%, transparent 70%%);
            opacity: 0; transition: opacity 0.3s; pointer-events: none;
        }
        .player:hover .scrim, .player.paused .scrim { opacity: 1; }
        .bigplay {
            position: absolute; top: 50%%; left: 50%%;
            transform: translate(-50%%, -50%%);
            width: 64px; height: 64px;
            background: rgba(255,255,255,0.15);
            backdrop-filter: blur(12px);
            border-radius: 50%%;
            display: flex; align-items: center; justify-content: center;
            opacity: 0;
            transition: opacity 0.2s, transform 0.2s;
            pointer-events: none;
            border: 1px solid rgba(255,255,255,0.2);
        }
        .bigplay svg { width: 24px; height: 24px; fill: #fff; }
        .bigplay .ico-play { display: block; margin-left: 3px; }
        .bigplay .ico-pause { display: none; }
        .player.paused .bigplay { opacity: 1; }
        .player.playing .bigplay { opacity: 0; }
        .player.playing:hover .bigplay { opacity: 1; }
        .player.playing .bigplay .ico-play { display: none; }
        .player.playing .bigplay .ico-pause { display: block; }
        .controls {
            position: absolute; bottom: 14px; left: 14px; right: 14px;
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(16px) saturate(1.5);
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 999px;
            padding: 5px 8px;
            display: flex; align-items: center; gap: 4px;
            opacity: 0;
            transform: translateY(6px) scale(0.97);
            transition: opacity 0.25s, transform 0.25s;
            box-shadow: 0 0 0 1px rgba(0,0,0,0.2), 0 4px 16px rgba(0,0,0,0.3);
        }
        .player:hover .controls, .player.paused .controls {
            opacity: 1; transform: translateY(0) scale(1);
        }
        .btn {
            width: 34px; height: 34px;
            border-radius: 50%%; border: none;
            background: transparent; color: #fff;
            display: grid; place-items: center;
            cursor: pointer; flex-shrink: 0;
            transition: background 0.15s, transform 0.1s;
        }
        .btn:hover { background: rgba(255,255,255,0.12); }
        .btn:active { transform: scale(0.88); }
        .btn svg { width: 18px; height: 18px; fill: #fff; display: block; }
        .time-group {
            flex: 1; display: flex; align-items: center;
            gap: 8px; padding: 0 4px; min-width: 0;
        }
        .time-label {
            font-size: 12px; font-variant-numeric: tabular-nums;
            color: rgba(255,255,255,0.9); white-space: nowrap;
            flex-shrink: 0; text-shadow: 0 1px 2px rgba(0,0,0,0.4);
        }
        .progress-wrap {
            flex: 1; height: 20px; display: flex;
            align-items: center; cursor: pointer; position: relative;
        }
        .progress-track {
            width: 100%%; height: 4px;
            background: rgba(255,255,255,0.2);
            border-radius: 999px; overflow: hidden;
            position: relative; transition: height 0.15s;
        }
        .progress-wrap:hover .progress-track { height: 6px; }
        .progress-buffer {
            position: absolute; left: 0; top: 0; bottom: 0;
            background: rgba(255,255,255,0.15);
            border-radius: inherit; width: 0; transition: width 0.3s;
        }
        .progress-fill {
            position: absolute; left: 0; top: 0; bottom: 0;
            background: #fff; border-radius: inherit; width: 0;
        }
        .progress-thumb {
            position: absolute; top: 50%%;
            transform: translate(-50%%, -50%%);
            width: 12px; height: 12px;
            background: #fff; border-radius: 50%%;
            opacity: 0; transition: opacity 0.15s;
            pointer-events: none;
            box-shadow: 0 1px 4px rgba(0,0,0,0.4);
        }
        .progress-wrap:hover .progress-thumb { opacity: 1; }
        .vol-wrap {
            display: flex; align-items: center; gap: 4px;
            overflow: hidden; max-width: 0; transition: max-width 0.25s;
        }
        .vol-group:hover .vol-wrap { max-width: 80px; }
        input[type=range] {
            -webkit-appearance: none; width: 64px; height: 4px;
            background: rgba(255,255,255,0.3);
            border-radius: 999px; outline: none; cursor: pointer;
        }
        input[type=range]::-webkit-slider-thumb {
            -webkit-appearance: none; width: 12px; height: 12px;
            background: #fff; border-radius: 50%%; cursor: pointer;
        }
        .speed-btn {
            font-size: 12px; font-weight: 500;
            width: auto; padding: 0 8px;
            border-radius: 999px; font-variant-numeric: tabular-nums;
        }
        </style>
        </head>
        <body>
        <header>
        <a href="javascript:history.back()">&#8592; Back</a>
        <span>%s</span>
        </header>
        <div class="wrap">
        <div class="player paused" id="player">
            <video id="vid" preload="auto">
            <source src="%s" type="%s">
            </video>
            <div class="scrim"></div>
            <div class="bigplay">
            <svg class="ico-play" viewBox="0 0 18 18"><path d="M14 10.7L6 15.7a2 2 0 01-3-1.7V4A2 2 0 016 2.3L14 7.3a2 2 0 010 3.4z"/></svg>
            <svg class="ico-pause" viewBox="0 0 18 18"><rect x="2" y="2" width="5" height="14" rx="1.75"/><rect x="11" y="2" width="5" height="14" rx="1.75"/></svg>
            </div>
            <div class="controls" id="controls">
            <button class="btn" id="playbtn" title="Play">
                <svg id="ico-play" viewBox="0 0 18 18"><path d="M14 10.7L6 15.7a2 2 0 01-3-1.7V4A2 2 0 016 2.3L14 7.3a2 2 0 010 3.4z"/></svg>
                <svg id="ico-pause" viewBox="0 0 18 18" style="display:none"><rect x="2" y="2" width="5" height="14" rx="1.75"/><rect x="11" y="2" width="5" height="14" rx="1.75"/></svg>
            </button>
            <button class="btn" id="seekback" title="-10s">
                <svg viewBox="0 0 18 18"><path d="M1 9a8 8 0 102.3-5.7L2 2v5h5L5.7 5.7A6 6 0 111 9"/><text x="5.5" y="13" font-size="5.5" font-family="sans-serif" font-weight="500" fill="#fff">10</text></svg>
            </button>
            <button class="btn" id="seekfwd" title="+10s">
                <svg viewBox="0 0 18 18"><path d="M17 9a8 8 0 11-2.3-5.7L16 2v5h-5l1.3-1.3A6 6 0 1017 9"/><text x="5.5" y="13" font-size="5.5" font-family="sans-serif" font-weight="500" fill="#fff">10</text></svg>
            </button>
            <div class="time-group">
                <span class="time-label" id="cur">0:00</span>
                <div class="progress-wrap" id="prog">
                <div class="progress-track">
                <div class="progress-buffer" id="buf"></div>
                <div class="progress-fill" id="fill"></div>
                </div>
                <div class="progress-thumb" id="thumb"></div>
                </div>
                <span class="time-label" id="dur">0:00</span>
            </div>
            <div class="vol-group" style="display:flex;align-items:center;">
                <button class="btn" id="mutebtn" title="Mute">
                <svg id="ico-vol" viewBox="0 0 18 18"><path d="M.7 6h3l4.1-3.9c.5-.4 1.2 0 1.2.6V15.3c0 .6-.7.9-1.2.6L3.7 12H.7c-.4 0-.7-.3-.7-.8V6.8C0 6.3.3 6 .7 6zm10.6.6a.9.9 0 011.3 0c1.2 1.2 1.5 2.2 1.5 3.2 0 1-.3 2-.9 2.7l-1.3-1.3c.3-.4.5-1 .5-1.4 0-.7-.2-1.3-.8-1.8a.9.9 0 010-1.4z" transform="scale(0.9)"/></svg>
                <svg id="ico-mute" viewBox="0 0 18 18" style="display:none"><path d="M.7 6h3l4.1-3.9c.5-.4 1.2 0 1.2.6V15.3c0 .6-.7.9-1.2.6L3.7 12H.7c-.4 0-.7-.3-.7-.8V6.8C0 6.3.3 6 .7 6zm14.5 1.4a1 1 0 00-1.4 0c-.4.4-.4 1 0 1.4L15.1 10l-1.3 1.2a1 1 0 001.4 1.4L16.5 11l1.3 1.4a1 1 0 001.4-1.4L17.9 10l1.3-1.2a1 1 0 00-1.4-1.4L16.5 9l-1.3-1.6z" transform="scale(0.9)"/></svg>
                </button>
                <div class="vol-wrap">
                <input type="range" id="vol" min="0" max="1" step="0.05" value="1">
                </div>
            </div>
            <button class="btn speed-btn" id="speedbtn">1&#xD7;</button>
            <button class="btn" id="fsbtn" title="Fullscreen">
                <svg id="ico-fs" viewBox="0 0 18 18"><path d="M9.57 3.62A1 1 0 008.65 3H4c-.55 0-1 .45-1 1v4.65A1 1 0 004.71 9.7l4.65-4.65a1 1 0 00.22-1.43zm4.81 4.81a1 1 0 00-1.09.22L8.64 13.3a1 1 0 00.71 1.7H14c.55 0 1-.45 1-1V9.35a1 1 0 00-.62-.92z"/></svg>
                <svg id="ico-exfs" viewBox="0 0 18 18" style="display:none"><path d="M7.88 1.93a.99.99 0 00-1.09.22L2.15 6.79A1 1 0 002.85 8.5H7.5c.55 0 1-.45 1-1V2.85a1 1 0 00-.62-.92zm7.26 7.57H10.5c-.55 0-1 .45-1 1v4.65a1 1 0 001.71.71l4.65-4.65a1 1 0 00-.72-1.71z"/></svg>
            </button>
            </div>
        </div>
        </div>
        <script>
        const vid=document.getElementById('vid');
        const player=document.getElementById('player');
        const playbtn=document.getElementById('playbtn');
        const icoPlay=document.getElementById('ico-play');
        const icoPause=document.getElementById('ico-pause');
        const bigIcoPlay=document.querySelector('.bigplay .ico-play');
        const bigIcoPause=document.querySelector('.bigplay .ico-pause');
        const cur=document.getElementById('cur');
        const dur=document.getElementById('dur');
        const fill=document.getElementById('fill');
        const buf=document.getElementById('buf');
        const thumb=document.getElementById('thumb');
        const prog=document.getElementById('prog');
        const vol=document.getElementById('vol');
        const mutebtn=document.getElementById('mutebtn');
        const icoVol=document.getElementById('ico-vol');
        const icoMute=document.getElementById('ico-mute');
        const speedbtn=document.getElementById('speedbtn');
        const fsbtn=document.getElementById('fsbtn');
        const icoFs=document.getElementById('ico-fs');
        const icoExfs=document.getElementById('ico-exfs');

        const speeds=[0.5,0.75,1,1.25,1.5,2];
        let speedIdx=2;

        function fmt(s){
        s=Math.floor(s||0);
        const m=Math.floor(s/60);
        const ss=String(s%%60).padStart(2,'0');
        return m+':'+ss;
        }

        function updatePlay(){
        if(vid.paused){
            icoPlay.style.display=''; icoPause.style.display='none';
            bigIcoPlay.style.display='block'; bigIcoPause.style.display='none';
            player.classList.add('paused');
            player.classList.remove('playing');
        } else {
            icoPlay.style.display='none'; icoPause.style.display='';
            bigIcoPlay.style.display='none'; bigIcoPause.style.display='block';
            player.classList.remove('paused');
            player.classList.add('playing');
        }
        }

        vid.addEventListener('timeupdate',()=>{
        const pct=(vid.currentTime/vid.duration*100)||0;
        fill.style.width=pct+'%%';
        thumb.style.left=pct+'%%';
        cur.textContent=fmt(vid.currentTime);
        });
        vid.addEventListener('durationchange',()=>{ dur.textContent=fmt(vid.duration); });
        vid.addEventListener('progress',()=>{
        if(vid.buffered.length){
            buf.style.width=(vid.buffered.end(vid.buffered.length-1)/vid.duration*100)+'%%';
        }
        });
        vid.addEventListener('play', updatePlay);
        vid.addEventListener('pause', updatePlay);
        vid.addEventListener('ended',()=>{
        player.classList.add('paused');
        player.classList.remove('playing');
        icoPlay.style.display=''; icoPause.style.display='none';
        bigIcoPlay.style.display='block'; bigIcoPause.style.display='none';
        });

        player.addEventListener('click',(e)=>{
        if(e.target.closest('#controls')) return;
        vid.paused ? vid.play() : vid.pause();
        });
        playbtn.addEventListener('click',()=>{ vid.paused ? vid.play() : vid.pause(); });
        document.getElementById('seekback').addEventListener('click',()=>{ vid.currentTime=Math.max(0,vid.currentTime-10); });
        document.getElementById('seekfwd').addEventListener('click',()=>{ vid.currentTime=Math.min(vid.duration,vid.currentTime+10); });

        prog.addEventListener('click',(e)=>{
        const r=prog.getBoundingClientRect();
        vid.currentTime=((e.clientX-r.left)/r.width)*vid.duration;
        });
        let dragging=false;
        prog.addEventListener('mousedown',()=>{ dragging=true; });
        document.addEventListener('mousemove',(e)=>{
        if(!dragging) return;
        const r=prog.getBoundingClientRect();
        const pct=Math.max(0,Math.min(1,(e.clientX-r.left)/r.width));
        vid.currentTime=pct*vid.duration;
        });
        document.addEventListener('mouseup',()=>{ dragging=false; });

        vol.addEventListener('input',()=>{ vid.volume=vol.value; vid.muted=vol.value==0; updateMute(); });
        mutebtn.addEventListener('click',()=>{
        vid.muted=!vid.muted;
        if(vid.muted) vol.value=0;
        else { if(vol.value==0) vol.value=1; vid.volume=vol.value; }
        updateMute();
        });
        function updateMute(){ icoVol.style.display=vid.muted?'none':''; icoMute.style.display=vid.muted?'':'none'; }

        speedbtn.addEventListener('click',()=>{
        speedIdx=(speedIdx+1)%%speeds.length;
        vid.playbackRate=speeds[speedIdx];
        speedbtn.textContent=speeds[speedIdx]+'\u00D7';
        });

        fsbtn.addEventListener('click',()=>{
        if(!document.fullscreenElement){ player.requestFullscreen(); }
        else { document.exitFullscreen(); }
        });
        document.addEventListener('fullscreenchange',()=>{
        const fs=!!document.fullscreenElement;
        icoFs.style.display=fs?'none':'';
        icoExfs.style.display=fs?'':'none';
        });

        document.addEventListener('keydown',(e)=>{
        if(['INPUT','TEXTAREA'].includes(document.activeElement.tagName)) return;
        if(e.key===' '||e.key==='k'){ e.preventDefault(); vid.paused?vid.play():vid.pause(); }
        if(e.key==='ArrowLeft') vid.currentTime=Math.max(0,vid.currentTime-5);
        if(e.key==='ArrowRight') vid.currentTime=Math.min(vid.duration,vid.currentTime+5);
        if(e.key==='ArrowUp'){ vid.volume=Math.min(1,vid.volume+0.1); vol.value=vid.volume; }
        if(e.key==='ArrowDown'){ vid.volume=Math.max(0,vid.volume-0.1); vol.value=vid.volume; }
        if(e.key==='f') fsbtn.click();
        if(e.key==='m') mutebtn.click();
        });
        </script>
        </body>
        </html>""".printf (filename, filename, encoded_path, mime);
    }
}