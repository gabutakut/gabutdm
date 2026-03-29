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
    private string get_audio_page (string file_path, string filename, string mime) {
        var encoded_path = GLib.Uri.escape_string (file_path, "/", true);
        var raw_src = "/Rawori?path=" + GLib.Uri.escape_string (file_path, "", true);
        var dot = file_path.last_index_of (".");
        var lrc_path = dot >= 0 ? file_path.substring (0, dot) + ".lrc" : file_path + ".lrc";
        var lrc_src = "/Rawori?path=" + GLib.Uri.escape_string (lrc_path, "", true);
        return """<!DOCTYPE html>
        <html lang="en">
        <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>%s</title>
        <style>
        *{margin:0;padding:0;box-sizing:border-box;}
        body{background:#0a0a0a;color:#fff;font-family:Inter,system-ui,sans-serif;min-height:100vh;display:flex;flex-direction:column;overflow-x:hidden;}
        .bg-glow{position:fixed;inset:0;z-index:0;pointer-events:none;overflow:hidden;}
        .bg-glow::before{content:'';position:absolute;width:600px;height:600px;border-radius:50%%;background:radial-gradient(circle,rgba(167,139,250,0.1) 0%%,transparent 70%%);top:-200px;right:-200px;animation:gd1 14s ease-in-out infinite alternate;}
        .bg-glow::after{content:'';position:absolute;width:500px;height:500px;border-radius:50%%;background:radial-gradient(circle,rgba(96,165,250,0.07) 0%%,transparent 70%%);bottom:-180px;left:-180px;animation:gd2 16s ease-in-out infinite alternate;}
        @keyframes gd1{from{transform:translate(0,0) scale(1);}to{transform:translate(-50px,60px) scale(1.2);}}
        @keyframes gd2{from{transform:translate(0,0) scale(1);}to{transform:translate(60px,-50px) scale(1.15);}}
        header{width:100%%;position:sticky;top:0;z-index:100;background:rgba(10,10,10,0.88);backdrop-filter:blur(24px) saturate(1.8);-webkit-backdrop-filter:blur(24px) saturate(1.8);border-bottom:0.5px solid rgba(255,255,255,0.07);padding:0 20px;height:52px;display:flex;align-items:center;gap:10px;}
        header a{color:#888;text-decoration:none;font-size:13px;flex-shrink:0;}
        header a:hover{color:#fff;}
        .hd-title{color:#fff;font-size:14px;font-weight:500;flex:1;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
        .main{flex:1;display:flex;flex-direction:column;align-items:center;justify-content:center;padding:24px 20px 32px;position:relative;z-index:1;gap:16px;}

        /* Art */
        .art-wrap{width:190px;height:190px;border-radius:20px;background:rgba(167,139,250,0.1);border:0.5px solid rgba(167,139,250,0.2);display:flex;align-items:center;justify-content:center;box-shadow:0 20px 60px rgba(0,0,0,0.5);animation:float 4s ease-in-out infinite;position:relative;overflow:hidden;flex-shrink:0;}
        @keyframes float{0%%,100%%{transform:translateY(0);}50%%{transform:translateY(-6px);}}
        .art-wrap.playing{animation:float 4s ease-in-out infinite,pulse-ring 2s ease-in-out infinite;}
        @keyframes pulse-ring{0%%{box-shadow:0 20px 60px rgba(0,0,0,0.5),0 0 0 0 rgba(167,139,250,0.3);}70%%{box-shadow:0 20px 60px rgba(0,0,0,0.5),0 0 0 20px rgba(167,139,250,0);}100%%{box-shadow:0 20px 60px rgba(0,0,0,0.5),0 0 0 0 rgba(167,139,250,0);}}
        .art-img{width:100%%;height:100%%;object-fit:cover;display:none;}
        .art-icon{width:64px;height:64px;fill:none;stroke:rgba(167,139,250,0.5);stroke-width:1.2;stroke-linecap:round;}
        .art-wrap.playing::after{content:'';position:absolute;inset:0;pointer-events:none;background:conic-gradient(rgba(167,139,250,0.05) 0deg,transparent 90deg,rgba(96,165,250,0.05) 180deg,transparent 270deg);animation:spin-slow 8s linear infinite;}
        @keyframes spin-slow{to{transform:rotate(360deg);}}

        /* EQ canvas */
        .eq-wrap{width:100%%;max-width:480px;height:56px;border-radius:14px;overflow:hidden;background:rgba(255,255,255,0.02);border:0.5px solid rgba(255,255,255,0.06);}
        #eq-canvas{width:100%%;height:100%%;display:block;}

        /* Track info */
        .track-info{text-align:center;}
        .track-title{font-size:17px;font-weight:700;color:#fff;margin-bottom:4px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;max-width:400px;}
        .track-artist{font-size:13px;color:rgba(167,139,250,0.8);margin-bottom:2px;}
        .track-album{font-size:12px;color:rgba(255,255,255,0.3);}
        .track-mime{font-size:11px;color:rgba(255,255,255,0.2);text-transform:uppercase;letter-spacing:0.08em;margin-top:4px;}

        /* Player card */
        .player-card{width:100%%;max-width:480px;background:rgba(255,255,255,0.04);border:0.5px solid rgba(255,255,255,0.08);border-radius:24px;padding:20px 20px 16px;display:flex;flex-direction:column;gap:14px;}
        .progress-wrap{display:flex;align-items:center;gap:10px;}
        .time-lbl{font-size:12px;color:rgba(255,255,255,0.4);font-variant-numeric:tabular-nums;flex-shrink:0;min-width:36px;}
        .time-lbl.end{text-align:right;}
        .progress-track{flex:1;height:4px;border-radius:999px;background:rgba(255,255,255,0.1);position:relative;cursor:pointer;transition:height 0.1s;}
        .progress-track:hover{height:6px;}
        .progress-buf{position:absolute;top:0;left:0;bottom:0;background:rgba(255,255,255,0.08);border-radius:inherit;}
        .progress-fill{position:absolute;top:0;left:0;bottom:0;background:linear-gradient(90deg,#a78bfa,#60a5fa);border-radius:inherit;width:0;}
        .progress-thumb{position:absolute;top:50%%;transform:translate(-50%%,-50%%);width:14px;height:14px;border-radius:50%%;background:#fff;box-shadow:0 2px 8px rgba(0,0,0,0.4);opacity:0;transition:opacity 0.15s;pointer-events:none;}
        .progress-track:hover .progress-thumb{opacity:1;}
        .btn-row{display:flex;align-items:center;justify-content:center;gap:8px;}
        .btn{border:none;background:transparent;color:#fff;display:grid;place-items:center;cursor:pointer;transition:background 0.15s,transform 0.1s;border-radius:50%%;-webkit-tap-highlight-color:transparent;}
        .btn:active{transform:scale(0.88);}
        .btn svg{fill:none;stroke:#fff;stroke-linecap:round;stroke-linejoin:round;display:block;}
        .btn-sm{width:36px;height:36px;}
        .btn-sm svg{width:16px;height:16px;stroke-width:1.8;}
        .btn-sm:hover{background:rgba(255,255,255,0.08);}
        .btn-md{width:44px;height:44px;}
        .btn-md svg{width:20px;height:20px;stroke-width:1.7;}
        .btn-md:hover{background:rgba(255,255,255,0.08);}
        .btn-play{width:58px;height:58px;background:linear-gradient(135deg,#a78bfa,#60a5fa);box-shadow:0 8px 24px rgba(167,139,250,0.35);}
        .btn-play svg{width:24px;height:24px;stroke-width:0;}
        .btn-play:hover{box-shadow:0 8px 32px rgba(167,139,250,0.5);}
        .btn-play:active{transform:scale(0.92);}
        .vol-row{display:flex;align-items:center;gap:10px;}
        .vol-row svg{width:16px;height:16px;fill:none;stroke:rgba(255,255,255,0.35);stroke-width:1.8;stroke-linecap:round;flex-shrink:0;cursor:pointer;}
        input[type=range]{flex:1;-webkit-appearance:none;height:4px;background:rgba(255,255,255,0.12);border-radius:999px;outline:none;cursor:pointer;}
        input[type=range]::-webkit-slider-thumb{-webkit-appearance:none;width:14px;height:14px;background:#fff;border-radius:50%%;cursor:pointer;box-shadow:0 1px 4px rgba(0,0,0,0.3);}
        .speed-btn{font-size:12px;font-weight:600;padding:4px 10px;border-radius:999px;background:rgba(255,255,255,0.06);border:0.5px solid rgba(255,255,255,0.1);color:rgba(255,255,255,0.6);font-family:inherit;cursor:pointer;transition:background 0.15s,color 0.15s;font-variant-numeric:tabular-nums;}
        .speed-btn:hover{background:rgba(255,255,255,0.1);color:#fff;}
        .eq-btn{font-size:12px;font-weight:600;padding:4px 12px;border-radius:999px;background:rgba(167,139,250,0.1);border:0.5px solid rgba(167,139,250,0.25);color:#a78bfa;font-family:inherit;cursor:pointer;transition:background 0.15s;white-space:nowrap;}
        .eq-btn:hover{background:rgba(167,139,250,0.18);}
        .eq-btn.active{background:rgba(167,139,250,0.25);border-color:rgba(167,139,250,0.5);}

        /* ── EQ Popup ── */
        .eq-overlay{display:none;position:fixed;inset:0;z-index:200;background:rgba(0,0,0,0.65);backdrop-filter:blur(16px);-webkit-backdrop-filter:blur(16px);align-items:flex-end;justify-content:center;padding:0 0 20px;}
        .eq-overlay.open{display:flex;}
        .eq-card{background:#161616;border:0.5px solid rgba(255,255,255,0.1);border-radius:24px 24px 20px 20px;width:100%%;max-width:480px;padding:20px 24px 24px;box-shadow:0 -8px 40px rgba(0,0,0,0.5);animation:eqIn 0.28s cubic-bezier(0.34,1.56,0.64,1) both;}
        @keyframes eqIn{from{opacity:0;transform:translateY(40px);}to{opacity:1;transform:translateY(0);}}
        .eq-header{display:flex;align-items:center;margin-bottom:20px;}
        .eq-title{font-size:15px;font-weight:700;color:#fff;flex:1;}
        .eq-close{width:28px;height:28px;border-radius:50%%;border:none;background:rgba(255,255,255,0.08);color:rgba(255,255,255,0.5);font-size:14px;cursor:pointer;display:grid;place-items:center;}
        .eq-close:hover{background:rgba(255,255,255,0.14);}

        /* Preset buttons */
        .eq-presets{display:flex;gap:6px;flex-wrap:wrap;margin-bottom:18px;}
        .preset-btn{padding:5px 12px;border-radius:999px;font-size:11px;font-weight:600;border:0.5px solid rgba(255,255,255,0.1);background:rgba(255,255,255,0.05);color:rgba(255,255,255,0.5);cursor:pointer;font-family:inherit;transition:all 0.15s;}
        .preset-btn:hover{background:rgba(255,255,255,0.1);color:#fff;}
        .preset-btn.active{background:rgba(167,139,250,0.2);border-color:rgba(167,139,250,0.4);color:#a78bfa;}

        /* Dolby toggle */
        .dolby-row{display:flex;align-items:center;gap:12px;margin-bottom:18px;padding:12px 16px;background:rgba(96,165,250,0.06);border:0.5px solid rgba(96,165,250,0.15);border-radius:14px;}
        .dolby-info{flex:1;}
        .dolby-title{font-size:13px;font-weight:600;color:#fff;}
        .dolby-sub{font-size:11px;color:rgba(255,255,255,0.3);margin-top:2px;}
        .toggle{width:42px;height:24px;border-radius:999px;background:rgba(255,255,255,0.1);border:none;cursor:pointer;position:relative;transition:background 0.2s;flex-shrink:0;}
        .toggle::after{content:'';position:absolute;top:3px;left:3px;width:18px;height:18px;border-radius:50%%;background:#fff;transition:transform 0.2s;box-shadow:0 1px 4px rgba(0,0,0,0.3);}
        .toggle.on{background:linear-gradient(135deg,#60a5fa,#a78bfa);}
        .toggle.on::after{transform:translateX(18px);}

        /* EQ Sliders */
        .eq-sliders{display:grid;grid-template-columns:repeat(7,1fr);gap:8px;margin-bottom:16px;}
        .eq-band{display:flex;flex-direction:column;align-items:center;gap:6px;}
        .eq-band-label{font-size:10px;color:rgba(255,255,255,0.3);text-align:center;}
        .eq-band-val{font-size:10px;font-weight:600;color:#a78bfa;font-variant-numeric:tabular-nums;min-width:32px;text-align:center;}
        input[type=range].vert{
        -webkit-appearance:slider-vertical;
        writing-mode:vertical-lr;
        direction:rtl;
        width:28px;height:100px;
        background:rgba(255,255,255,0.1);
        border-radius:999px;
        cursor:pointer;outline:none;
        }
        input[type=range].vert::-webkit-slider-thumb{-webkit-appearance:none;width:16px;height:16px;background:linear-gradient(135deg,#a78bfa,#60a5fa);border-radius:50%%;cursor:pointer;box-shadow:0 1px 6px rgba(167,139,250,0.5);}

        /* Bass/Treble big sliders */
        .big-sliders{display:grid;grid-template-columns:1fr 1fr 1fr;gap:12px;}
        .big-band{display:flex;flex-direction:column;gap:8px;}
        .big-band-label{font-size:11px;font-weight:600;color:rgba(255,255,255,0.5);text-align:center;}
        .big-band-val{font-size:12px;font-weight:700;color:#a78bfa;text-align:center;font-variant-numeric:tabular-nums;}
        input[type=range].horiz{width:100%%;-webkit-appearance:none;height:4px;background:rgba(255,255,255,0.12);border-radius:999px;outline:none;cursor:pointer;}
        input[type=range].horiz::-webkit-slider-thumb{-webkit-appearance:none;width:16px;height:16px;background:linear-gradient(135deg,#a78bfa,#60a5fa);border-radius:50%%;cursor:pointer;box-shadow:0 1px 6px rgba(167,139,250,0.4);}

        .eq-reset{width:100%%;padding:10px;background:rgba(255,255,255,0.05);border:0.5px solid rgba(255,255,255,0.1);border-radius:12px;color:rgba(255,255,255,0.5);font-size:13px;font-family:inherit;cursor:pointer;transition:background 0.15s;}
        .eq-reset:hover{background:rgba(255,255,255,0.1);color:#fff;}
        .ctrl-row{display:flex;align-items:center;gap:8px;}
        .repeat-btn{width:32px;height:32px;border-radius:50%%;border:none;background:transparent;display:grid;place-items:center;cursor:pointer;transition:background 0.15s;-webkit-tap-highlight-color:transparent;}
        .repeat-btn:hover{background:rgba(255,255,255,0.08);}
        /* ── Lyrics ── */
        .lrc-wrap{
        width:100%%;max-width:480px;
        position:relative;
        }
        .lrc-toggle{
        position:absolute;top:0;right:0;
        font-size:11px;font-weight:600;
        padding:3px 10px;border-radius:999px;
        background:rgba(167,139,250,0.1);
        border:0.5px solid rgba(167,139,250,0.25);
        color:#a78bfa;cursor:pointer;font-family:inherit;
        transition:background 0.15s;z-index:2;
        }
        .lrc-toggle:hover{background:rgba(167,139,250,0.2);}

        /* Scroll mode */
        .lrc-scroll{
        height:150px;overflow:hidden;
        border-radius:16px;
        background:rgba(255,255,255,0.02);
        border:0.5px solid rgba(255,255,255,0.06);
        position:relative;
        }
        .lrc-scroll::before,.lrc-scroll::after{
        content:'';position:absolute;left:0;right:0;height:48px;z-index:1;pointer-events:none;
        }
        .lrc-scroll::before{top:0;background:linear-gradient(to bottom,rgba(10,10,10,0.9),transparent);}
        .lrc-scroll::after{bottom:0;background:linear-gradient(to top,rgba(10,10,10,0.9),transparent);}
        .lrc-inner{
        padding:72px 0;
        display:flex;flex-direction:column;align-items:center;gap:6px;
        transition:transform 0.4s cubic-bezier(0.25,0.46,0.45,0.94);
        }
        .lrc-line{
        font-size:13px;color:rgba(255,255,255,0.25);
        text-align:center;padding:2px 20px;
        transition:color 0.3s,font-size 0.3s,font-weight 0.3s;
        line-height:1.5;width:100%%;
        }
        .lrc-line.active{
        color:#fff;font-size:15px;font-weight:600;
        }
        .lrc-line.prev{color:rgba(167,139,250,0.5);}

        /* Karaoke mode */
        .lrc-karaoke{
        display:none;
        height:140px;
        border-radius:16px;
        background:rgba(255,255,255,0.02);
        border:0.5px solid rgba(255,255,255,0.06);
        flex-direction:column;align-items:center;justify-content:center;
        gap:12px;padding:16px 20px;text-align:center;
        position:relative;overflow:hidden;
        }
        .lrc-karaoke::before{
        content:'';position:absolute;inset:0;
        background:radial-gradient(ellipse at center,rgba(167,139,250,0.06) 0%%,transparent 70%%);
        pointer-events:none;
        }
        .lrc-cur{
        font-size:22px;font-weight:800;
        background:linear-gradient(90deg,#a78bfa,#60a5fa);
        -webkit-background-clip:text;-webkit-text-fill-color:transparent;
        background-clip:text;
        line-height:1.3;
        animation:fadeIn 0.3s ease;
        }
        .lrc-nxt{
        font-size:14px;color:rgba(255,255,255,0.3);
        line-height:1.4;
        animation:fadeIn 0.3s ease;
        }
        @keyframes fadeIn{from{opacity:0;transform:translateY(6px);}to{opacity:1;transform:translateY(0);}}
        .lrc-empty{
        font-size:13px;color:rgba(255,255,255,0.15);
        text-align:center;padding:20px;
        }
        .bg-cover{
        position:fixed;
        inset:0;
        z-index:0;
        pointer-events:none;

        background-size:cover;
        background-position:center;

        filter:blur(40px) brightness(0.6);
        transform:scale(1.1); /* biar blur ga kepotong */

        opacity:0;
        transition:opacity 0.5s ease;
        }
        </style>
        </head>
        <body>
        <div class="bg-glow"></div>
        <div class="bg-cover" id="bg-cover"></div>
        <header>
        <a href="javascript:history.back()">&#8592; Back</a>
        <span class="hd-title" id="title-download"></span>
        <a id="btn-download" href="#" download
               style="color:#a78bfa;text-decoration:none;font-size:13px;flex-shrink:0;display:flex;align-items:center;gap:5px;">
               <svg width="15" height="15" viewBox="0 0 15 15" fill="none" stroke="#a78bfa" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><polyline points="7.5,2 7.5,10"/><polyline points="4,7 7.5,11 11,7"/><line x1="2" y1="13.5" x2="13" y2="13.5"/></svg>
            Download
        </a>
        </header>
        <div class="main">
        <div class="art-wrap" id="art">
            <img class="art-img" id="art-img" alt="cover">
            <svg class="art-icon" id="art-icon" viewBox="0 0 64 64">
            <circle cx="32" cy="32" r="28" stroke-width="1"/>
            <circle cx="32" cy="32" r="9" stroke-width="1"/>
            <path d="M24 18v-5l18-4v5" stroke-width="1.2"/>
            <line x1="24" y1="18" x2="24" y2="32" stroke-width="1.2"/>
            <line x1="42" y1="13" x2="42" y2="27" stroke-width="1.2"/>
            </svg>
        </div>
        <div class="track-info">
            <div class="track-title" id="track-title">%s</div>
            <div class="track-artist" id="track-artist" style="display:none"></div>
            <div class="track-album"  id="track-album"  style="display:none"></div>
            <div class="track-mime">%s</div>
        </div>
        <div class="eq-wrap">
            <canvas id="eq-canvas"></canvas>
        </div>
        <!-- Lyrics -->
        <div class="lrc-wrap" id="lrc-wrap" style="display:none;">
        <button class="lrc-toggle" id="lrc-toggle-btn" onclick="toggleLrcMode()">≡ Scroll</button>

        <!-- Scroll mode -->
        <div class="lrc-scroll" id="lrc-scroll">
            <div class="lrc-inner" id="lrc-inner">
            <div class="lrc-empty">Loading lyrics…</div>
            </div>
        </div>

        <!-- Karaoke mode -->
        <div class="lrc-karaoke" id="lrc-karaoke">
            <div class="lrc-cur" id="lrc-cur">♪</div>
            <div class="lrc-nxt" id="lrc-nxt"></div>
        </div>
        </div>
        <div class="player-card">
            <div class="progress-wrap">
            <span class="time-lbl" id="cur">0:00</span>
            <div class="progress-track" id="prog">
                <div class="progress-buf" id="buf"></div>
                <div class="progress-fill" id="fill"></div>
                <div class="progress-thumb" id="thumb"></div>
            </div>
            <span class="time-lbl end" id="dur">0:00</span>
            </div>
            <div class="btn-row">
            <button class="btn btn-sm" id="btn-back">
                <svg viewBox="0 0 18 18"><path d="M2 9a7 7 0 106-6"/><polyline points="1,5 2,9 6,8"/><text x="5" y="13" font-size="5" font-family="sans-serif" font-weight="600" fill="#fff" stroke="none">10</text></svg>
            </button>
            <button class="btn btn-md" id="btn-prev">
                <svg viewBox="0 0 20 20"><polygon points="16,4 6,10 16,16" fill="#fff" stroke="none"/><rect x="3" y="4" width="2.5" height="12" rx="1" fill="#fff" stroke="none"/></svg>
            </button>
            <button class="btn btn-play" id="btn-play">
                <svg viewBox="0 0 24 24" id="ico-play"><polygon points="6,4 20,12 6,20" fill="#fff"/></svg>
                <svg viewBox="0 0 24 24" id="ico-pause" style="display:none"><rect x="5" y="4" width="4" height="16" rx="1.5" fill="#fff"/><rect x="15" y="4" width="4" height="16" rx="1.5" fill="#fff"/></svg>
            </button>
            <button class="btn btn-md" id="btn-next">
                <svg viewBox="0 0 20 20"><polygon points="4,4 14,10 4,16" fill="#fff" stroke="none"/><rect x="14.5" y="4" width="2.5" height="12" rx="1" fill="#fff" stroke="none"/></svg>
            </button>
            <button class="btn btn-sm" id="btn-fwd">
                <svg viewBox="0 0 18 18"><path d="M16 9a7 7 0 11-6-6"/><polyline points="17,5 16,9 12,8"/><text x="5" y="13" font-size="5" font-family="sans-serif" font-weight="600" fill="#fff" stroke="none">10</text></svg>
            </button>
            </div>
            <div class="vol-row">
            <svg viewBox="0 0 18 18" id="ico-vol"><path d="M1 6.5h3l4-3.5v12L4 11.5H1z"/><path d="M12 5a5 5 0 010 8M10 7a2.5 2.5 0 010 4"/></svg>
            <svg viewBox="0 0 18 18" id="ico-mute" style="display:none"><path d="M1 6.5h3l4-3.5v12L4 11.5H1z"/><line x1="13" y1="6" x2="17" y2="12"/><line x1="17" y1="6" x2="13" y2="12"/></svg>
            <input type="range" id="vol" min="0" max="1" step="0.02" value="1">
            </div>
            <div class="ctrl-row">
            <button class="speed-btn" id="speed-btn">1×</button>
            <button class="eq-btn" id="eq-open-btn">🎛 EQ</button>
            <div style="flex:1"></div>
            <button class="repeat-btn" id="btn-repeat" title="Repeat" onclick="cycleRepeat()">
                <svg id="ico-repeat-none" viewBox="0 0 18 18" width="16" height="16" fill="none" stroke="rgba(255,255,255,0.3)" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round">
                <polyline points="2,10 2,14 6,14"/><polyline points="16,8 16,4 12,4"/>
                <path d="M16 4a7 7 0 01-13 3M2 14a7 7 0 0113-3"/>
                </svg>
                <svg id="ico-repeat-all" viewBox="0 0 18 18" width="16" height="16" fill="none" stroke="#a78bfa" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" style="display:none">
                <polyline points="2,10 2,14 6,14"/><polyline points="16,8 16,4 12,4"/>
                <path d="M16 4a7 7 0 01-13 3M2 14a7 7 0 0113-3"/>
                </svg>
                <svg id="ico-repeat-one" viewBox="0 0 18 18" width="16" height="16" fill="none" stroke="#a78bfa" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" style="display:none">
                <polyline points="2,10 2,14 6,14"/><polyline points="16,8 16,4 12,4"/>
                <path d="M16 4a7 7 0 01-13 3M2 14a7 7 0 0113-3"/>
                <text x="9" y="11" font-size="5.5" font-family="sans-serif" font-weight="800" fill="#a78bfa" stroke="none" text-anchor="middle">1</text>
                </svg>
            </button>
            </div>
        </div>
        </div>

        <!-- EQ Popup -->
        <div class="eq-overlay" id="eq-overlay" onclick="eqBg(event)">
        <div class="eq-card">
            <div class="eq-header">
            <div class="eq-title">🎛 Equalizer</div>
            <button class="eq-close" onclick="eqClose()">✕</button>
            </div>

            <!-- Presets -->
            <div class="eq-presets" id="eq-presets">
            <button class="preset-btn active" data-preset="flat">Flat</button>
            <button class="preset-btn" data-preset="bass">Bass Boost</button>
            <button class="preset-btn" data-preset="treble">Treble Boost</button>
            <button class="preset-btn" data-preset="vocal">Vocal</button>
            <button class="preset-btn" data-preset="rock">Rock</button>
            <button class="preset-btn" data-preset="pop">Pop</button>
            <button class="preset-btn" data-preset="jazz">Jazz</button>
            <button class="preset-btn" data-preset="classical">Classical</button>
            </div>

            <!-- Dolby Surround -->
            <div class="dolby-row">
            <div class="dolby-info">
                <div class="dolby-title">🔊 Dolby Surround</div>
                <div class="dolby-sub">Simulated surround via convolver + stereo spread</div>
            </div>
            <button class="toggle" id="dolby-toggle" onclick="toggleDolby()"></button>
            </div>

            <!-- 7-band EQ sliders -->
            <div class="eq-sliders" id="eq-sliders">
            <!-- generated by JS -->
            </div>

            <!-- Bass / Mid / Treble -->
            <div class="big-sliders">
            <div class="big-band">
                <div class="big-band-label">Bass</div>
                <div class="big-band-val" id="val-bass">0 dB</div>
                <input type="range" class="horiz" id="sl-bass" min="-12" max="12" step="0.5" value="0">
            </div>
            <div class="big-band">
                <div class="big-band-label">Mid</div>
                <div class="big-band-val" id="val-mid">0 dB</div>
                <input type="range" class="horiz" id="sl-mid" min="-12" max="12" step="0.5" value="0">
            </div>
            <div class="big-band">
                <div class="big-band-label">Treble</div>
                <div class="big-band-val" id="val-treble">0 dB</div>
                <input type="range" class="horiz" id="sl-treble" min="-12" max="12" step="0.5" value="0">
            </div>
            </div>

            <br>
            <button class="eq-reset" onclick="resetEQ()">Reset All</button>
        </div>
        </div>

        <audio id="aud" preload="auto" crossorigin="anonymous">
        <source src="%s" type="%s">
        </audio>

        <script>
        const aud      = document.getElementById('aud');
        const art      = document.getElementById('art');
        const artImg   = document.getElementById('art-img');
        const artIcon  = document.getElementById('art-icon');
        const btnPlay  = document.getElementById('btn-play');
        const icoPlay  = document.getElementById('ico-play');
        const icoPause = document.getElementById('ico-pause');
        const curEl    = document.getElementById('cur');
        const durEl    = document.getElementById('dur');
        const fill     = document.getElementById('fill');
        const buf      = document.getElementById('buf');
        const prog     = document.getElementById('prog');
        const volEl    = document.getElementById('vol');
        const icoVol   = document.getElementById('ico-vol');
        const icoMute  = document.getElementById('ico-mute');
        const speedBtn = document.getElementById('speed-btn');
        const canvas   = document.getElementById('eq-canvas');
        const ctx2d    = canvas.getContext('2d');
        const eqOpenBtn= document.getElementById('eq-open-btn');
        const thumb    = document.getElementById('thumb');

        const FILE_URL = '%s';
        const speeds   = [0.5,0.75,1,1.25,1.5,2];
        let   speedIdx = 2;

        // ── Playlist ──
        let playlist    = [];
        let curIdx      = -1;
        // repeat: 0=none 1=all 2=one
        let repeatMode  = 0;

        // Ambil dir dari FILE_URL
        (async () => {
        try {
            const u    = new URL(FILE_URL, location.origin);
            const fpath= decodeURIComponent(u.searchParams.get('path') || '');
            const dir  = fpath.substring(0, fpath.lastIndexOf('/'));
            const resp = await fetch('/DirList?path=' + encodeURIComponent(dir));
            const list = await resp.json();
            playlist   = list;
            const base = fpath.split('/').pop();
            curIdx     = list.findIndex(f => f.name === base);
            if (curIdx >= 0) {
            updateDownload(playlist[curIdx]);
            }
            updateNavBtns();
        } catch(e) { console.log('DirList err', e); }
        })();

        function updateNavBtns() {
        document.getElementById('btn-prev').disabled = curIdx <= 0 && repeatMode === 0;
        document.getElementById('btn-next').disabled = curIdx >= playlist.length-1 && repeatMode === 0;
        }

        function playIdx(idx) {
        if (idx < 0 || idx >= playlist.length) return;
        curIdx = idx;
        const f = playlist[idx];
        const src = '/Rawori?path=' + f.path;
        aud.src = src;
        aud.load();
        aud.play();
        document.getElementById('track-title').textContent = f.name.replace(/\.[^.]+$/, '');
        artImg.style.display = 'none';
        artIcon.style.display = '';
        loadTags(src);
        updateNavBtns();
        // Update URL tanpa reload
        history.replaceState(null, '', '/Player?path=' + f.path);
        }

        function loadTags(src) {
        if (typeof jsmediatags === 'undefined') return;
        fetch(src).then(r=>r.blob()).then(blob=>{
            jsmediatags.read(blob, {
            onSuccess: (tag) => {
                const t = tag.tags;
                if(t.artist){const e=document.getElementById('track-artist');e.textContent=t.artist;e.style.display='';}
                if(t.album) {const e=document.getElementById('track-album'); e.textContent=t.album; e.style.display='';}
                if(t.title) document.getElementById('track-title').textContent=t.title;
                if(t.picture){
                const p=t.picture,u8=new Uint8Array(p.data),b=new Blob([u8],{type:p.format||'image/jpeg'});
                artImg.src=URL.createObjectURL(b);artImg.style.display='block';artIcon.style.display='none';
                const bg = document.getElementById('bg-cover');
                const urlImg = URL.createObjectURL(b);

                bg.style.backgroundImage = `url(${urlImg})`;
                bg.style.opacity = 1;
                                } else {
                const bg = document.getElementById('bg-cover');
                bg.style.opacity = 0;
                }
            }, onError:()=>{}
            });
        }).catch(()=>{});
        }

        // ── Repeat ──
        function cycleRepeat() {
        repeatMode = (repeatMode + 1) %% 3;
        document.getElementById('ico-repeat-none').style.display = repeatMode===0?'':'none';
        document.getElementById('ico-repeat-all').style.display  = repeatMode===1?'':'none';
        document.getElementById('ico-repeat-one').style.display  = repeatMode===2?'':'none';
        updateNavBtns();
        }

        // ── Canvas resize ──
        function resizeCanvas(){canvas.width=canvas.offsetWidth*devicePixelRatio;canvas.height=canvas.offsetHeight*devicePixelRatio;}
        resizeCanvas();window.addEventListener('resize',resizeCanvas);

        function fmt(s){s=Math.floor(s||0);return Math.floor(s/60)+':'+String(s%%60).padStart(2,'0');}

        // ── Web Audio ──
        let audioCtx,analyser,source,gainNode;
        let eqFilters=[];
        let bassFilter,midFilter,trebleFilter;
        let dolbyConvolver,dolbyGain,dolbyEnabled=false,dolbyConnected=false;
        let connected=false;

        const BANDS       = [60,170,350,1000,3500,10000,16000];
        const BAND_LABELS = ['60','170','350','1k','3.5k','10k','16k'];
        const PRESETS = {
        flat:[0,0,0,0,0,0,0],bass:[8,6,4,0,0,0,0],treble:[0,0,0,0,4,6,8],
        vocal:[-2,-2,4,6,4,-2,-2],rock:[6,4,2,0,2,4,6],pop:[-2,2,4,4,2,-2,-4],
        jazz:[4,2,0,2,4,4,2],classical:[4,4,2,0,0,2,4],
        };

        function initAudio(){
        if(connected) return;

        audioCtx = new (window.AudioContext || window.webkitAudioContext)();

        analyser = audioCtx.createAnalyser();
        analyser.fftSize = 128;
        analyser.smoothingTimeConstant = 0.8;

        source   = audioCtx.createMediaElementSource(aud);
        gainNode = audioCtx.createGain();

        // =============================
        // 🎛 EQ FILTERS (punya kamu)
        // =============================
        eqFilters = BANDS.map((freq,i)=>{
            const f = audioCtx.createBiquadFilter();
            f.type = i===0 ? 'lowshelf' : i===BANDS.length-1 ? 'highshelf' : 'peaking';
            f.frequency.value = freq;
            f.Q.value = 1;
            f.gain.value = 0;
            return f;
        });

        bassFilter   = audioCtx.createBiquadFilter();
        bassFilter.type = 'lowshelf';
        bassFilter.frequency.value = 200;

        midFilter = audioCtx.createBiquadFilter();
        midFilter.type = 'peaking';
        midFilter.frequency.value = 1000;
        midFilter.Q.value = 0.8;

        trebleFilter = audioCtx.createBiquadFilter();
        trebleFilter.type = 'highshelf';
        trebleFilter.frequency.value = 4000;

        // =============================
        // 🔊 FILTER TAMBAHAN (ANTI GREG)
        // =============================

        // 🔹 Highpass (buang noise bawah)
        const highpass = audioCtx.createBiquadFilter();
        highpass.type = "highpass";
        highpass.frequency.value = 80;

        // 🔹 Lowpass (buang noise atas)
        const lowpass = audioCtx.createBiquadFilter();
        lowpass.type = "lowpass";
        lowpass.frequency.value = 12000;

        // 🔹 Compressor (anti pecah)
        const compressor = audioCtx.createDynamicsCompressor();
        compressor.threshold.value = -18;
        compressor.knee.value = 20;
        compressor.ratio.value = 4;
        compressor.attack.value = 0.003;
        compressor.release.value = 0.25;

        // 🔹 Volume limit (anti clipping)
        gainNode.gain.value = 0.8;

        // =============================
        // 🔗 CHAIN AUDIO (RAPI!)
        // =============================

        let prev = source;

        // EQ chain
        [...eqFilters, bassFilter, midFilter, trebleFilter].forEach(f => {
            prev.connect(f);
            prev = f;
        });

        // filter tambahan
        prev.connect(highpass);
        prev = highpass;

        prev.connect(gainNode);
        prev = gainNode;

        prev.connect(lowpass);
        prev = lowpass;

        prev.connect(compressor);
        prev = compressor;

        // output
        prev.connect(analyser);
        analyser.connect(audioCtx.destination);

        connected = true;
        drawEQ();
        }

        function makeDolbyIR(){
        const sr=audioCtx.sampleRate,len=Math.floor(sr*2.5);
        const ir=audioCtx.createBuffer(2,len,sr);
        for(let c=0;c<2;c++){
            const d=ir.getChannelData(c);
            for(let i=0;i<len;i++){
            const ed=Math.exp(-i/(sr*0.05)),ld=Math.exp(-i/(sr*0.6)),n=(Math.random()*2-1);
            const ph=c===0?Math.sin(i*0.003)*Math.cos(i*0.0007):Math.cos(i*0.003)*Math.sin(i*0.0007);
            d[i]=n*ed*0.6+n*ld*0.4*ph;
            }
        }
        dolbyConvolver.buffer=ir;
        }

        function connectDolbyChain(){
        if(dolbyConnected) return;
        const sp=audioCtx.createChannelSplitter(2),mg=audioCtx.createChannelMerger(2);
        const mG=audioCtx.createGain();mG.gain.value=1;
        const sG=audioCtx.createGain();sG.gain.value=2.2;
        const inv=audioCtx.createGain();inv.gain.value=-1;
        gainNode.connect(sp);sp.connect(mG,0);sp.connect(sG,0);sp.connect(inv,1);inv.connect(sG);
        mG.connect(mg,0,0);mG.connect(mg,0,1);sG.connect(mg,0,0);
        mg.connect(dolbyGain);
        gainNode.connect(dolbyConvolver);dolbyConvolver.connect(dolbyGain);
        dolbyGain.connect(audioCtx.destination);
        dolbyConnected=true;
        }

        function toggleDolby(){
        dolbyEnabled=!dolbyEnabled;
        document.getElementById('dolby-toggle').classList.toggle('on',dolbyEnabled);
        if(connected){connectDolbyChain();dolbyGain.gain.setTargetAtTime(dolbyEnabled?0.6:0,audioCtx.currentTime,0.08);}
        }

        function buildSliders(){
        const wrap=document.getElementById('eq-sliders');wrap.innerHTML='';
        BANDS.forEach((freq,i)=>{
            const div=document.createElement('div');div.className='eq-band';
            const val=document.createElement('div');val.className='eq-band-val';val.id='eqv'+i;val.textContent='0';
            const sl=document.createElement('input');sl.type='range';sl.className='vert';
            sl.min=-12;sl.max=12;sl.step=0.5;sl.value=0;sl.id='eqs'+i;
            sl.addEventListener('input',()=>{const v=parseFloat(sl.value);val.textContent=(v>0?'+':'')+v;if(connected)eqFilters[i].gain.value=v;clearPresetActive();});
            const lbl=document.createElement('div');lbl.className='eq-band-label';lbl.textContent=BAND_LABELS[i];
            div.appendChild(val);div.appendChild(sl);div.appendChild(lbl);wrap.appendChild(div);
        });
        }
        buildSliders();

        document.getElementById('sl-bass').addEventListener('input',function(){
        document.getElementById('val-bass').textContent=(this.value>0?'+':'')+this.value+' dB';
        if(connected)bassFilter.gain.value=parseFloat(this.value);clearPresetActive();
        });
        document.getElementById('sl-mid').addEventListener('input',function(){
        document.getElementById('val-mid').textContent=(this.value>0?'+':'')+this.value+' dB';
        if(connected)midFilter.gain.value=parseFloat(this.value);clearPresetActive();
        });
        document.getElementById('sl-treble').addEventListener('input',function(){
        document.getElementById('val-treble').textContent=(this.value>0?'+':'')+this.value+' dB';
        if(connected)trebleFilter.gain.value=parseFloat(this.value);clearPresetActive();
        });

        document.getElementById('eq-presets').addEventListener('click',e=>{
        const btn=e.target.closest('.preset-btn');if(!btn)return;
        const vals=PRESETS[btn.dataset.preset];
        vals.forEach((v,i)=>{const sl=document.getElementById('eqs'+i),vl=document.getElementById('eqv'+i);sl.value=v;vl.textContent=(v>0?'+':'')+v;if(connected)eqFilters[i].gain.value=v;});
        document.querySelectorAll('.preset-btn').forEach(b=>b.classList.remove('active'));btn.classList.add('active');
        });

        function clearPresetActive(){document.querySelectorAll('.preset-btn').forEach(b=>b.classList.remove('active'));}

        function resetEQ(){
        BANDS.forEach((_,i)=>{document.getElementById('eqs'+i).value=0;document.getElementById('eqv'+i).textContent='0';if(connected)eqFilters[i].gain.value=0;});
        ['bass','mid','treble'].forEach(k=>{document.getElementById('sl-'+k).value=0;document.getElementById('val-'+k).textContent='0 dB';});
        if(connected){bassFilter.gain.value=0;midFilter.gain.value=0;trebleFilter.gain.value=0;}
        document.querySelectorAll('.preset-btn').forEach(b=>b.classList.remove('active'));
        document.querySelector('[data-preset=flat]').classList.add('active');
        }

        function eqOpen(){document.getElementById('eq-overlay').classList.add('open');document.body.style.overflow='hidden';eqOpenBtn.classList.add('active');}
        function eqClose(){document.getElementById('eq-overlay').classList.remove('open');document.body.style.overflow='';eqOpenBtn.classList.remove('active');}
        function eqBg(e){if(e.target===document.getElementById('eq-overlay'))eqClose();}
        eqOpenBtn.addEventListener('click',eqOpen);

        function drawEQ(){
        requestAnimationFrame(drawEQ);
        const W=canvas.width,H=canvas.height;ctx2d.clearRect(0,0,W,H);
        if(!analyser||aud.paused){
            ctx2d.strokeStyle='rgba(167,139,250,0.2)';ctx2d.lineWidth=1.5;
            ctx2d.beginPath();ctx2d.moveTo(0,H/2);ctx2d.lineTo(W,H/2);ctx2d.stroke();return;
        }
        const bufLen=analyser.frequencyBinCount,data=new Uint8Array(bufLen);
        analyser.getByteFrequencyData(data);
        const barW=(W/bufLen)*1.8,gap=2*devicePixelRatio;let x=0;
        for(let i=0;i<bufLen;i++){
            const v=data[i]/255,barH=v*H*0.85;
            const g=ctx2d.createLinearGradient(0,H,0,H-barH);
            g.addColorStop(0,'rgba(96,165,250,0.9)');g.addColorStop(0.5,'rgba(167,139,250,0.9)');g.addColorStop(1,'rgba(232,121,249,0.9)');
            ctx2d.fillStyle=g;const r=Math.min(barW/2,3*devicePixelRatio);
            ctx2d.beginPath();ctx2d.roundRect?ctx2d.roundRect(x,H-barH,barW-gap,barH,r):ctx2d.rect(x,H-barH,barW-gap,barH);ctx2d.fill();x+=barW;
        }
        }
        drawEQ();

        // ── Cover art load awal ──
        (async()=>{
        try{
            await new Promise((res,rej)=>{const s=document.createElement('script');s.src='/JsMediaTags';s.onload=res;s.onerror=rej;document.head.appendChild(s);});
            loadTags(FILE_URL);
        }catch(e){console.log('jsmediatags',e);}
        })();

        // ── Player ──
        function updatePlay(){
        const p=!aud.paused;
        icoPlay.style.display=p?'none':'';icoPause.style.display=p?'':'none';
        p?art.classList.add('playing'):art.classList.remove('playing');
        if(p&&audioCtx?.state==='suspended')audioCtx.resume();
        }

        // ── On ended — handle repeat ──
        aud.addEventListener('ended',()=>{
        if(repeatMode===2){ aud.currentTime=0;aud.play();return; }
        if(repeatMode===1){
            const next=(curIdx+1)%%playlist.length;
            playlist.length>0?playIdx(next):(() => {aud.currentTime=0;aud.play();})();return;
        }
        // repeatMode===0
        if(curIdx>=0&&curIdx<playlist.length-1) playIdx(curIdx+1);
        updatePlay();
        });

        aud.addEventListener('timeupdate',()=>{const pct=(aud.currentTime/aud.duration*100)||0;fill.style.width=pct+'%%';thumb.style.left=pct+'%%';curEl.textContent=fmt(aud.currentTime);});
        aud.addEventListener('durationchange',()=>{durEl.textContent=fmt(aud.duration);});
        aud.addEventListener('progress',()=>{if(aud.buffered.length)buf.style.width=(aud.buffered.end(aud.buffered.length-1)/aud.duration*100)+'%%';});
        aud.addEventListener('play',updatePlay);aud.addEventListener('pause',updatePlay);

        btnPlay.addEventListener('click',()=>{initAudio();aud.paused?aud.play():aud.pause();});

        prog.addEventListener('click',e=>{const r=prog.getBoundingClientRect();aud.currentTime=((e.clientX-r.left)/r.width)*aud.duration;});
        let drag=false;
        prog.addEventListener('mousedown',()=>{drag=true;});
        document.addEventListener('mousemove',e=>{if(!drag)return;const r=prog.getBoundingClientRect();aud.currentTime=Math.max(0,Math.min(1,(e.clientX-r.left)/r.width))*aud.duration;});
        document.addEventListener('mouseup',()=>{drag=false;});
        prog.addEventListener('touchstart',e=>{const r=prog.getBoundingClientRect();aud.currentTime=((e.touches[0].clientX-r.left)/r.width)*aud.duration;},{passive:true});
        prog.addEventListener('touchmove',e=>{const r=prog.getBoundingClientRect();aud.currentTime=Math.max(0,Math.min(1,(e.touches[0].clientX-r.left)/r.width))*aud.duration;},{passive:true});

        document.getElementById('btn-back').addEventListener('click',()=>{aud.currentTime=Math.max(0,aud.currentTime-10);});
        document.getElementById('btn-fwd').addEventListener('click',()=>{aud.currentTime=Math.min(aud.duration,aud.currentTime+10);});

        document.getElementById('btn-prev').addEventListener('click',()=>{
        initAudio();
        if(playlist.length>0&&curIdx>0) playIdx(curIdx-1);
        else if(repeatMode===1&&playlist.length>0) playIdx(playlist.length-1);
        else { aud.currentTime=0; }
        });
        document.getElementById('btn-next').addEventListener('click',()=>{
        initAudio();
        if(playlist.length>0&&curIdx<playlist.length-1) playIdx(curIdx+1);
        else if(repeatMode===1&&playlist.length>0) playIdx(0);
        });

        volEl.addEventListener('input',()=>{aud.volume=volEl.value;aud.muted=volEl.value==0;updateMute();});
        function updateMute(){icoVol.style.display=aud.muted?'none':'';icoMute.style.display=aud.muted?'':'none';}
        icoVol.addEventListener('click',()=>{aud.muted=true;volEl.value=0;updateMute();});
        icoMute.addEventListener('click',()=>{aud.muted=false;volEl.value=1;aud.volume=1;updateMute();});

        speedBtn.addEventListener('click',()=>{speedIdx=(speedIdx+1)%%speeds.length;aud.playbackRate=speeds[speedIdx];speedBtn.textContent=speeds[speedIdx]+'\u00D7';});

        document.addEventListener('keydown',e=>{
        if(['INPUT','TEXTAREA'].includes(document.activeElement.tagName))return;
        if(e.key==='Escape')eqClose();
        if(e.key===' '||e.key==='k'){e.preventDefault();initAudio();aud.paused?aud.play():aud.pause();}
        if(e.key==='ArrowLeft') aud.currentTime=Math.max(0,aud.currentTime-5);
        if(e.key==='ArrowRight')aud.currentTime=Math.min(aud.duration,aud.currentTime+5);
        if(e.key==='ArrowUp')  {aud.volume=Math.min(1,aud.volume+0.1);volEl.value=aud.volume;}
        if(e.key==='ArrowDown'){aud.volume=Math.max(0,aud.volume-0.1);volEl.value=aud.volume;}
        if(e.key==='m'){aud.muted=!aud.muted;volEl.value=aud.muted?0:1;updateMute();}
        if(e.key==='ArrowRight'&&e.ctrlKey){document.getElementById('btn-next').click();}
        if(e.key==='ArrowLeft'&&e.ctrlKey){document.getElementById('btn-prev').click();}
        });
        // ── LRC ──
        const LRC_URL   = '%s';
        let lrcLines    = []; // [{time, text}]
        let lrcMode     = 0;  // 0=scroll 1=karaoke
        let lrcCurIdx   = -1;

        // Parse LRC
        async function loadLRC(url) {
        try {
            const resp = await fetch(url);
            if (!resp.ok) return;
            const text = await resp.text();
            const lines = [];
            text.split('\n').forEach(line => {
            const m = line.match(/\[(\d+):(\d+)[\.\:](\d+)\](.*)/);
            if (!m) return;
            const t = parseInt(m[1])*60 + parseInt(m[2]) + parseInt(m[3])/100;
            const txt = m[4].trim();
            if (txt) lines.push({ time: t, text: txt });
            });
            lines.sort((a,b) => a.time - b.time);
            lrcLines = lines;
            if (lines.length > 0) {
            document.getElementById('lrc-wrap').style.display = '';
            renderScrollLRC(-1);
            }
        } catch(e) { console.log('LRC load err', e); }
        }

        // Render scroll mode
        function renderScrollLRC(activeIdx) {
        const inner = document.getElementById('lrc-inner');
        inner.innerHTML = '';
        if (lrcLines.length === 0) {
            inner.innerHTML = '<div class="lrc-empty">No lyrics</div>';
            return;
        }
        lrcLines.forEach((l, i) => {
            const div = document.createElement('div');
            div.className = 'lrc-line' +
            (i === activeIdx ? ' active' : '') +
            (i === activeIdx - 1 ? ' prev' : '');
            div.textContent = l.text;
            div.dataset.idx = i;
            inner.appendChild(div);
        });
        scrollToLRC(activeIdx);
        }

        function scrollToLRC(idx) {
        if (idx < 0) return;
        const inner   = document.getElementById('lrc-inner');
        const scroll  = document.getElementById('lrc-scroll');
        const lineH   = 28;
        const offset  = idx * lineH;
        const center  = scroll.offsetHeight / 2 - 72;
        inner.style.transform = `translateY(${-offset + center}px)`;
        }

        // Update karaoke mode
        function updateKaraoke(idx) {
        const cur = document.getElementById('lrc-cur');
        const nxt = document.getElementById('lrc-nxt');
        if (idx < 0 || lrcLines.length === 0) {
            cur.textContent = '♪';
            nxt.textContent = '';
            return;
        }
        const curText = lrcLines[idx]?.text || '';
        const nxtText = lrcLines[idx+1]?.text || '';
        if (cur.textContent !== curText) {
            cur.style.animation = 'none';
            cur.offsetHeight; // reflow
            cur.style.animation = '';
            cur.textContent = curText;
        }
        if (nxt.textContent !== nxtText) {
            nxt.style.animation = 'none';
            nxt.offsetHeight;
            nxt.style.animation = '';
            nxt.textContent = nxtText;
        }
        }

        // Sync lyrics dengan timeupdate
        function syncLRC(currentTime) {
        if (lrcLines.length === 0) return;
        let idx = -1;
        for (let i = 0; i < lrcLines.length; i++) {
            if (lrcLines[i].time <= currentTime) idx = i;
            else break;
        }
        if (idx === lrcCurIdx) return;
        lrcCurIdx = idx;
        if (lrcMode === 0) {
            // Update scroll mode — hanya update class
            document.querySelectorAll('.lrc-line').forEach((el, i) => {
            el.className = 'lrc-line' +
                (i === idx ? ' active' : '') +
                (i === idx - 1 ? ' prev' : '');
            });
            scrollToLRC(idx);
        } else {
            updateKaraoke(idx);
        }
        }

        // Toggle mode scroll / karaoke
        function toggleLrcMode() {
        lrcMode = lrcMode === 0 ? 1 : 0;
        const btn    = document.getElementById('lrc-toggle-btn');
        const scroll = document.getElementById('lrc-scroll');
        const kar    = document.getElementById('lrc-karaoke');
        if (lrcMode === 0) {
            btn.textContent = '≡ Scroll';
            scroll.style.display = '';
            kar.style.display    = 'none';
            renderScrollLRC(lrcCurIdx);
        } else {
            btn.textContent = '⬛ Karaoke';
            scroll.style.display = 'none';
            kar.style.display    = 'flex';
            updateKaraoke(lrcCurIdx);
        }
        }

        // Hook ke timeupdate
        aud.addEventListener('timeupdate', () => {
        const pct = (aud.currentTime/aud.duration*100)||0;
        fill.style.width=pct+'%%';thumb.style.left=pct+'%%';curEl.textContent=fmt(aud.currentTime);
        syncLRC(aud.currentTime);
        });

        // Load LRC saat init
        loadLRC(LRC_URL);

        // Reload LRC saat ganti track
        const _origPlayIdx = playIdx;
        window.playIdx = async function(idx) {
        _origPlayIdx(idx);

        if (!playlist[idx]) return;

        // 🔥 RESET TOTAL
        lrcLines = [];
        lrcCurIdx = -1;

        const wrap = document.getElementById('lrc-wrap');
        wrap.style.display = 'none';

        const inner = document.getElementById('lrc-inner');
        inner.innerHTML = '<div class="lrc-empty">Loading lyrics…</div>';

        // 🔥 URL LRC CLEAN (INI JUGA BUG DI KAMU)
        const lrcUrl = '/Rawori?path=' +
            playlist[idx].path.replace(/\.[^.]+$/, '.lrc');

        await loadLRC(lrcUrl);

        // 🔥 PAKSA SYNC SETELAH LOAD
        if (lrcLines.length > 0) {
            syncLRC(aud.currentTime);
        }
        };
        const btnDownload = document.getElementById('btn-download');
        const ttlDownload = document.getElementById('title-download');

        // setiap audio berubah → update link download
        function updateDownload(f) {
        if (!f) return;

        const url = '/Rawori?path=' + (f.path);
        btnDownload.href = url;
        btnDownload.download = f.name;
        ttlDownload.innerText = f.name;
        }

        // saat pertama load

        // kalau kamu ganti lagu (playIdx)
        function playIdx(idx) {
        if (idx < 0 || idx >= playlist.length) return;

        curIdx = idx;
        const f = playlist[idx];
        updateDownload(f);
        const src = '/Rawori?path=' + f.path;
        artImg.style.display = 'none';
        artIcon.style.display = '';
        const bg = document.getElementById('bg-cover');
        bg.style.opacity = 0;
        aud.src = src;
        aud.load();
        aud.play();

        document.getElementById('track-title').textContent =
            f.name.replace(/\.[^.]+$/, '');

        artImg.style.display = 'none';
        artIcon.style.display = '';
        loadTags(src);
        updateNavBtns();

        history.replaceState(null, '', '/Player?path=' + f.path);
        }
        </script>
        </body>
        </html>""".printf (filename, filename, mime, encoded_path, mime, raw_src, lrc_src);
    }
}