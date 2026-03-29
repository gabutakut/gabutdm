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
        var dot = file_path.last_index_of (".");
        var srt_path = dot >= 0 ? file_path.substring (0, dot) + ".srt" : file_path + ".srt";
        var srt_src = "/Rawori?path=" + GLib.Uri.escape_string (srt_path, "", true);
        var dir_path = Path.get_dirname (file_path);
        var file = File.new_for_path (file_path);
        if (file.query_exists ()) {
            dir_path = file.get_path ();
        }
        var firststr = """<!DOCTYPE html>
        <html lang="en">
        <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>%s</title>
        <style>
        *{margin:0;padding:0;box-sizing:border-box;}
        body{background:#0a0a0a;color:#fff;font-family:Inter,system-ui,sans-serif;min-height:100vh;display:flex;flex-direction:column;align-items:center;}
        header{width:100%%;background:#111;padding:12px 20px;display:flex;align-items:center;gap:10px;border-bottom:1px solid #222;}
        header a{color:#888;text-decoration:none;font-size:13px;transition:color 0.15s;}
        header a:hover{color:#fff;}
        header span{color:#fff;font-size:14px;font-weight:500;flex:1;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
        .wrap{width:100%%;max-width:960px;padding:28px 16px;}
        .player{position:relative;width:100%%;aspect-ratio:16/9;background:#000;border-radius:20px;overflow:hidden;cursor:pointer;}
        video{width:100%%;height:100%%;object-fit:contain;display:block;}
        .scrim{position:absolute;inset:0;background:linear-gradient(to top,rgba(0,0,0,0.65) 0%%,rgba(0,0,0,0.2) 40%%,transparent 70%%);opacity:0;transition:opacity 0.3s;pointer-events:none;}
        .player:hover .scrim,.player.paused .scrim{opacity:1;}

        /* Subtitle */
        .subtitle-wrap{position:absolute;bottom:70px;left:0;right:0;display:flex;justify-content:center;pointer-events:none;z-index:10;}
        .subtitle-text{
        background:rgba(0,0,0,0.72);padding:4px 14px;border-radius:6px;
        font-size:18px;font-weight:500;color:#fff;text-align:center;
        text-shadow:0 1px 3px rgba(0,0,0,0.8);line-height:1.4;
        max-width:80%%;word-break:break-word;
        display:none;
        }
        .subtitle-text.show{display:block;}

        /* Big center controls */
        .bigplay{position:absolute;top:50%%;left:50%%;transform:translate(-50%%,-50%%);display:flex;align-items:center;gap:16px;opacity:0;transition:opacity 0.2s;pointer-events:none;}
        .player.paused .bigplay,.player.playing:hover .bigplay{opacity:1;}
        .player.playing .bigplay{opacity:0;}
        .big-btn{width:52px;height:52px;background:rgba(255,255,255,0.12);backdrop-filter:blur(12px);border-radius:50%%;display:flex;align-items:center;justify-content:center;border:1px solid rgba(255,255,255,0.2);cursor:pointer;pointer-events:auto;transition:background 0.15s,transform 0.1s;}
        .big-btn:hover{background:rgba(255,255,255,0.22);}
        .big-btn:active{transform:scale(0.88);}
        .big-btn svg{width:22px;height:22px;fill:#fff;}
        .big-play-btn{width:64px;height:64px;}
        .big-play-btn svg{width:26px;height:26px;}

        /* Controls bar */
        .controls{position:absolute;bottom:14px;left:14px;right:14px;background:rgba(255,255,255,0.1);backdrop-filter:blur(16px) saturate(1.5);border:1px solid rgba(255,255,255,0.12);border-radius:999px;padding:5px 8px;display:flex;align-items:center;gap:4px;opacity:0;transform:translateY(6px) scale(0.97);transition:opacity 0.25s,transform 0.25s;box-shadow:0 0 0 1px rgba(0,0,0,0.2),0 4px 16px rgba(0,0,0,0.3);}
        .player:hover .controls,.player.paused .controls{opacity:1;transform:translateY(0) scale(1);}
        .btn{width:34px;height:34px;border-radius:50%%;border:none;background:transparent;color:#fff;display:grid;place-items:center;cursor:pointer;flex-shrink:0;transition:background 0.15s,transform 0.1s;}
        .btn:hover{background:rgba(255,255,255,0.12);}
        .btn:active{transform:scale(0.88);}
        .btn svg{width:18px;height:18px;fill:#fff;display:block;}
        .time-group{flex:1;display:flex;align-items:center;gap:8px;padding:0 4px;min-width:0;}
        .time-label{font-size:12px;font-variant-numeric:tabular-nums;color:rgba(255,255,255,0.9);white-space:nowrap;flex-shrink:0;text-shadow:0 1px 2px rgba(0,0,0,0.4);}
        .progress-wrap{flex:1;height:20px;display:flex;align-items:center;cursor:pointer;position:relative;}
        .progress-track{width:100%%;height:4px;background:rgba(255,255,255,0.2);border-radius:999px;overflow:hidden;position:relative;transition:height 0.15s;}
        .progress-wrap:hover .progress-track{height:6px;}
        .progress-buffer{position:absolute;left:0;top:0;bottom:0;background:rgba(255,255,255,0.15);border-radius:inherit;width:0;transition:width 0.3s;}
        .progress-fill{position:absolute;left:0;top:0;bottom:0;background:#fff;border-radius:inherit;width:0;}
        .progress-thumb{position:absolute;top:50%%;transform:translate(-50%%,-50%%);width:12px;height:12px;background:#fff;border-radius:50%%;opacity:0;transition:opacity 0.15s;pointer-events:none;box-shadow:0 1px 4px rgba(0,0,0,0.4);}
        .progress-wrap:hover .progress-thumb{opacity:1;}
        .vol-wrap{display:flex;align-items:center;gap:4px;overflow:hidden;max-width:0;transition:max-width 0.25s;}
        .vol-group:hover .vol-wrap{max-width:80px;}
        input[type=range]{-webkit-appearance:none;width:64px;height:4px;background:rgba(255,255,255,0.3);border-radius:999px;outline:none;cursor:pointer;}
        input[type=range]::-webkit-slider-thumb{-webkit-appearance:none;width:12px;height:12px;background:#fff;border-radius:50%%;cursor:pointer;}
        .speed-btn{font-size:12px;font-weight:500;width:auto;padding:0 8px;border-radius:999px;font-variant-numeric:tabular-nums;}
        .adj-btn{font-size:11px;font-weight:600;padding:0 8px;border-radius:999px;background:transparent;border:none;color:rgba(255,255,255,0.6);cursor:pointer;white-space:nowrap;}
        .adj-btn:hover{color:#fff;background:rgba(255,255,255,0.1);}

        /* Codec badge */
        .codec-badge{position:absolute;top:12px;left:12px;background:rgba(0,0,0,0.55);backdrop-filter:blur(8px);border:0.5px solid rgba(255,255,255,0.15);border-radius:6px;font-size:10px;font-weight:600;letter-spacing:0.06em;color:rgba(255,255,255,0.6);padding:3px 8px;pointer-events:none;opacity:0;transition:opacity 0.3s;}
        .player:hover .codec-badge{opacity:1;}

        /* Error */
        .err-overlay{display:none;position:absolute;inset:0;background:rgba(0,0,0,0.75);backdrop-filter:blur(8px);flex-direction:column;align-items:center;justify-content:center;gap:10px;}
        .err-overlay.show{display:flex;}
        .err-icon{width:48px;height:48px;border-radius:50%%;background:rgba(248,113,113,0.15);display:flex;align-items:center;justify-content:center;}
        .err-icon svg{width:24px;height:24px;stroke:#f87171;fill:none;stroke-width:2;stroke-linecap:round;}
        .err-msg{font-size:13px;color:rgba(255,255,255,0.5);text-align:center;max-width:280px;line-height:1.5;}

        /* ── Adjustment Popup ── */
        .adj-overlay{display:none;position:fixed;inset:0;z-index:300;background:rgba(0,0,0,0.6);backdrop-filter:none; backdrop-filter: none; align-items:flex-end;justify-content:center;padding:0 0 16px;}
        .adj-overlay.open{display:flex;}
        .adj-card{background:#161616;border:0.5px solid rgba(255,255,255,0.1);border-radius:20px 20px 16px 16px;width:100%%;max-width:480px;padding:18px 22px 22px;box-shadow:0 -8px 40px rgba(0,0,0,0.5);animation:adjIn 0.25s cubic-bezier(0.34,1.56,0.64,1) both;}
        @keyframes adjIn{from{opacity:0;transform:translateY(30px);}to{opacity:1;transform:translateY(0);}}
        .adj-header{display:flex;align-items:center;margin-bottom:16px;}
        .adj-title{font-size:14px;font-weight:700;color:#fff;flex:1;}
        .adj-close{width:26px;height:26px;border-radius:50%%;border:none;background:rgba(255,255,255,0.08);color:rgba(255,255,255,0.5);font-size:13px;cursor:pointer;display:grid;place-items:center;}
        .adj-close:hover{background:rgba(255,255,255,0.14);}
        .adj-rows{display:flex;flex-direction:column;gap:14px;}
        .adj-row{display:flex;align-items:center;gap:12px;}
        .adj-lbl{font-size:11px;font-weight:600;color:rgba(255,255,255,0.4);text-transform:uppercase;letter-spacing:0.06em;min-width:72px;}
        .adj-val{font-size:11px;font-weight:700;color:#a78bfa;min-width:36px;text-align:right;font-variant-numeric:tabular-nums;}
        input[type=range].aslider{flex:1;-webkit-appearance:none;height:4px;background:rgba(255,255,255,0.12);border-radius:999px;outline:none;cursor:pointer;}
        input[type=range].aslider::-webkit-slider-thumb{-webkit-appearance:none;width:14px;height:14px;background:linear-gradient(135deg,#a78bfa,#60a5fa);border-radius:50%%;cursor:pointer;box-shadow:0 1px 6px rgba(167,139,250,0.4);}
        .adj-reset{width:100%%;margin-top:6px;padding:9px;background:rgba(255,255,255,0.05);border:0.5px solid rgba(255,255,255,0.1);border-radius:10px;color:rgba(255,255,255,0.4);font-size:12px;font-family:inherit;cursor:pointer;transition:background 0.15s;}
        .adj-reset:hover{background:rgba(255,255,255,0.1);color:#fff;}
        .player.hide-ui .controls,
        .player.hide-ui .bigplay,
        .player.hide-ui .scrim {
        opacity: 0 !important;
        pointer-events: none;
        transition: opacity 0.3s;
        }
        .player,
        .player * {
        -webkit-tap-highlight-color: transparent;
        }
        .player.hide-ui {
        cursor: none;
        }
        .player {
        user-select: none;
        -webkit-user-select: none;
        }
        /* Tabs */
        .adj-tabs{display:flex;gap:6px;margin-bottom:16px;}
        .adj-tab{
        flex:1;padding:8px;border-radius:10px;
        border:0.5px solid rgba(255,255,255,0.1);
        background:rgba(255,255,255,0.05);
        color:rgba(255,255,255,0.4);
        font-size:12px;font-weight:600;font-family:inherit;
        cursor:pointer;transition:all 0.15s;
        }
        .adj-tab:hover{background:rgba(255,255,255,0.1);color:#fff;}
        .adj-tab.active{background:rgba(167,139,250,0.15);border-color:rgba(167,139,250,0.35);color:#a78bfa;}

        /* EQ in popup */
        .eq-presets{display:flex;gap:6px;flex-wrap:wrap;margin-bottom:14px;}
        .preset-btn{padding:4px 10px;border-radius:999px;font-size:11px;font-weight:600;border:0.5px solid rgba(255,255,255,0.1);background:rgba(255,255,255,0.05);color:rgba(255,255,255,0.5);cursor:pointer;font-family:inherit;transition:all 0.15s;}
        .preset-btn:hover{background:rgba(255,255,255,0.1);color:#fff;}
        .preset-btn.active{background:rgba(167,139,250,0.2);border-color:rgba(167,139,250,0.4);color:#a78bfa;}
        .dolby-row{display:flex;align-items:center;gap:12px;margin-bottom:14px;padding:10px 14px;background:rgba(96,165,250,0.06);border:0.5px solid rgba(96,165,250,0.15);border-radius:12px;}
        .dolby-info{flex:1;}
        .dolby-title{font-size:12px;font-weight:600;color:#fff;}
        .dolby-sub{font-size:10px;color:rgba(255,255,255,0.3);margin-top:2px;}
        .toggle{width:42px;height:24px;border-radius:999px;background:rgba(255,255,255,0.1);border:none;cursor:pointer;position:relative;transition:background 0.2s;flex-shrink:0;}
        .toggle::after{content:'';position:absolute;top:3px;left:3px;width:18px;height:18px;border-radius:50%;background:#fff;transition:transform 0.2s;box-shadow:0 1px 4px rgba(0,0,0,0.3);}
        .toggle.on{background:linear-gradient(135deg,#60a5fa,#a78bfa);}
        .toggle.on::after{transform:translateX(18px);}
        .eq-sliders{display:grid;grid-template-columns:repeat(7,1fr);gap:6px;margin-bottom:14px;}
        .eq-band{display:flex;flex-direction:column;align-items:center;gap:4px;}
        .eq-band-label{font-size:9px;color:rgba(255,255,255,0.3);text-align:center;}
        .eq-band-val{font-size:9px;font-weight:600;color:#a78bfa;min-width:28px;text-align:center;}
        input[type=range].vert{-webkit-appearance:slider-vertical;writing-mode:vertical-lr;direction:rtl;width:24px;height:80px;background:rgba(255,255,255,0.1);border-radius:999px;cursor:pointer;outline:none;}
        input[type=range].vert::-webkit-slider-thumb{-webkit-appearance:none;width:14px;height:14px;background:linear-gradient(135deg,#a78bfa,#60a5fa);border-radius:50%;cursor:pointer;}
        .big-sliders{display:grid;grid-template-columns:1fr 1fr 1fr;gap:10px;margin-bottom:12px;}
        .big-band{display:flex;flex-direction:column;gap:6px;}
        .big-band-label{font-size:10px;font-weight:600;color:rgba(255,255,255,0.5);text-align:center;}
        .big-band-val{font-size:11px;font-weight:700;color:#a78bfa;text-align:center;font-variant-numeric:tabular-nums;}
        input[type=range].horiz{width:100%;-webkit-appearance:none;height:4px;background:rgba(255,255,255,0.12);border-radius:999px;outline:none;cursor:pointer;}
        input[type=range].horiz::-webkit-slider-thumb{-webkit-appearance:none;width:14px;height:14px;background:linear-gradient(135deg,#a78bfa,#60a5fa);border-radius:50%;cursor:pointer;}

        .seek-indicator{
        position:absolute;
        top:50%;
        transform:translateY(-50%);
        font-size:28px;
        font-weight:bold;
        color:#fff;
        opacity:0;
        pointer-events:none;
        transition:opacity 0.2s, transform 0.2s;
        }
        .seek-indicator.left { left:20px; }
        .seek-indicator.right { right:20px; }

        .seek-indicator.show {
        opacity:1;
        transform:translateY(-50%) scale(1.2);
        }

        .player.holding-speed::after{
        content:'2×';
        position:absolute;
        top:20px;
        left:50%;
        transform:translateX(-50%);
        background:rgba(0,0,0,0.6);
        padding:6px 12px;
        border-radius:8px;
        font-size:14px;
        font-weight:600;
        pointer-events:none;
        }
        </style>
        </head>
        <body>
        <header>
        <a href="javascript:history.back()">&#8592; Back</a>
        <span class="hd-title" id="title-download"></span>
        <a id="btn-download" href=# download
                style="color:#a78bfa;text-decoration:none;font-size:13px;flex-shrink:0;display:flex;align-items:center;gap:5px;">
               <svg width="15" height="15" viewBox="0 0 15 15" fill="none" stroke="#a78bfa" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><polyline points="7.5,2 7.5,10"/><polyline points="4,7 7.5,11 11,7"/><line x1="2" y1="13.5" x2="13" y2="13.5"/></svg>
            Download
        </a>
        </header>
        <div class="wrap">
        <div class="player paused" id="player">
            <video id="vid" preload="auto" crossorigin="anonymous"></video>
            <div class="codec-badge" id="codecBadge"></div>
            <div class="seek-indicator" id="seek-indicator"></div>
            <!-- Subtitle -->
            <div class="subtitle-wrap">
            <div class="subtitle-text" id="subtitle-text"></div>
            </div>

        <!-- Adjustment Popup -->
        <div class="adj-overlay" id="adj-overlay" onclick="adjBg(event)">
        <div class="adj-card">
        <div class="adj-header">
            <div class="adj-title">🎛 Settings</div>
            <button class="adj-close" onclick="adjClose()">✕</button>
        </div>

        <!-- Tabs -->
        <div class="adj-tabs">
            <button class="adj-tab active" id="tab-video" onclick="switchTab('video')">🎨 Video</button>
            <button class="adj-tab" id="tab-audio" onclick="switchTab('audio')">🎧 Audio EQ</button>
        </div>

        <!-- Video Tab -->
        <div id="panel-video">
            <div class="adj-rows">
            <div class="adj-row">
                <span class="adj-lbl">Subtitle</span>
                <input type="range" class="aslider" id="sl-subsize" min="12" max="40" step="1" value="18">
                <span class="adj-val" id="val-subsize">18px</span>
            </div>
            <div class="adj-row">
                <span class="adj-lbl">Brightness</span>
                <input type="range" class="aslider" id="sl-brightness" min="0" max="2" step="0.01" value="1">
                <span class="adj-val" id="val-brightness">1.00</span>
            </div>
            <div class="adj-row">
                <span class="adj-lbl">Contrast</span>
                <input type="range" class="aslider" id="sl-contrast" min="0" max="2" step="0.01" value="1">
                <span class="adj-val" id="val-contrast">1.00</span>
            </div>
            <div class="adj-row">
                <span class="adj-lbl">Saturation</span>
                <input type="range" class="aslider" id="sl-saturate" min="0" max="3" step="0.01" value="1">
                <span class="adj-val" id="val-saturate">1.00</span>
            </div>
            <div class="adj-row">
                <span class="adj-lbl">Hue</span>
                <input type="range" class="aslider" id="sl-hue" min="0" max="360" step="1" value="0">
                <span class="adj-val" id="val-hue">0°</span>
            </div>
            <div class="adj-row">
                <span class="adj-lbl">Gamma</span>
                <input type="range" class="aslider" id="sl-gamma" min="0.1" max="3" step="0.01" value="1">
                <span class="adj-val" id="val-gamma">1.00</span>
            </div>
            <div class="adj-row">
                <span class="adj-lbl">Blur</span>
                <input type="range" class="aslider" id="sl-blur" min="0" max="5" step="0.1" value="0">
                <span class="adj-val" id="val-blur">0</span>
            </div>
            </div>
            <button class="adj-reset" onclick="resetAdj()">Reset Video</button>
        </div>

        <!-- Audio EQ Tab -->
        <div id="panel-audio" style="display:none;">
            <!-- Presets -->
            <div class="eq-presets" id="eq-presets">
            <button class="preset-btn active" data-preset="flat">Flat</button>
            <button class="preset-btn" data-preset="bass">Bass Boost</button>
            <button class="preset-btn" data-preset="treble">Treble</button>
            <button class="preset-btn" data-preset="vocal">Vocal</button>
            <button class="preset-btn" data-preset="rock">Rock</button>
            <button class="preset-btn" data-preset="pop">Pop</button>
            <button class="preset-btn" data-preset="jazz">Jazz</button>
            <button class="preset-btn" data-preset="classical">Classical</button>
            </div>
            <!-- Dolby -->
            <div class="dolby-row">
            <div class="dolby-info">
                <div class="dolby-title">🔊 Dolby Surround</div>
                <div class="dolby-sub">Simulated via convolver + stereo spread</div>
            </div>
            <button class="toggle" id="dolby-toggle" onclick="toggleDolby()"></button>
            </div>
            <!-- 7-band -->
            <div class="eq-sliders" id="eq-sliders"></div>
            <!-- Bass/Mid/Treble -->
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
            <button class="adj-reset" onclick="resetEQ()">Reset EQ</button>
        </div>
        </div>
        </div>

            <div class="scrim"></div>

            <!-- Big center controls -->
            <div class="bigplay" id="bigplay">
            <div class="big-btn" id="big-prev" title="Previous">
                <svg viewBox="0 0 20 20"><polygon points="16,4 6,10 16,16"/><rect x="3" y="4" width="2.5" height="12" rx="1"/></svg>
            </div>
            <div class="big-btn big-play-btn" id="big-play">
                <svg id="big-ico-play" viewBox="0 0 24 24"><polygon points="6,4 20,12 6,20"/></svg>
                <svg id="big-ico-pause" viewBox="0 0 24 24" style="display:none"><rect x="5" y="4" width="4" height="16" rx="1.5"/><rect x="15" y="4" width="4" height="16" rx="1.5"/></svg>
            </div>
            <div class="big-btn" id="big-next" title="Next">
                <svg viewBox="0 0 20 20"><polygon points="4,4 14,10 4,16"/><rect x="14.5" y="4" width="2.5" height="12" rx="1"/></svg>
            </div>
            </div>

            <div class="err-overlay" id="errOverlay">
            <div class="err-icon"><svg viewBox="0 0 24 24"><path d="M12 9v4m0 4h.01M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/></svg></div>
            <div class="err-msg" id="errMsg">Format tidak didukung</div>
            </div>

            <div class="controls" id="controls">
            <button class="btn" id="playbtn">
                <svg id="ico-play" viewBox="0 0 18 18"><path d="M14 10.7L6 15.7a2 2 0 01-3-1.7V4A2 2 0 016 2.3L14 7.3a2 2 0 010 3.4z"/></svg>
                <svg id="ico-pause" viewBox="0 0 18 18" style="display:none"><rect x="2" y="2" width="5" height="14" rx="1.75"/><rect x="11" y="2" width="5" height="14" rx="1.75"/></svg>
            </button>
            <button class="btn" id="seekback">
                <svg viewBox="0 0 18 18"><path d="M1 9a8 8 0 102.3-5.7L2 2v5h5L5.7 5.7A6 6 0 111 9"/><text x="5.5" y="13" font-size="5.5" font-family="sans-serif" font-weight="500" fill="#fff">10</text></svg>
            </button>
            <button class="btn" id="seekfwd">
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
                <button class="btn" id="mutebtn">
                <svg id="ico-vol" viewBox="0 0 18 18"><path d="M.7 6h3l4.1-3.9c.5-.4 1.2 0 1.2.6V15.3c0 .6-.7.9-1.2.6L3.7 12H.7c-.4 0-.7-.3-.7-.8V6.8C0 6.3.3 6 .7 6zm10.6.6a.9.9 0 011.3 0c1.2 1.2 1.5 2.2 1.5 3.2 0 1-.3 2-.9 2.7l-1.3-1.3c.3-.4.5-1 .5-1.4 0-.7-.2-1.3-.8-1.8a.9.9 0 010-1.4z" transform="scale(0.9)"/></svg>
                <svg id="ico-mute" viewBox="0 0 18 18" style="display:none"><path d="M.7 6h3l4.1-3.9c.5-.4 1.2 0 1.2.6V15.3c0 .6-.7.9-1.2.6L3.7 12H.7c-.4 0-.7-.3-.7-.8V6.8C0 6.3.3 6 .7 6zm14.5 1.4a1 1 0 00-1.4 0c-.4.4-.4 1 0 1.4L15.1 10l-1.3 1.2a1 1 0 001.4 1.4L16.5 11l1.3 1.4a1 1 0 001.4-1.4L17.9 10l1.3-1.2a1 1 0 00-1.4-1.4L16.5 9l-1.3-1.6z" transform="scale(0.9)"/></svg>
                </button>
                <div class="vol-wrap">
                <input type="range" id="vol" min="0" max="1" step="0.05" value="1">
                </div>
            </div>
            <button class="btn speed-btn" id="speedbtn">1&#xD7;</button>
            <button class="btn adj-btn" id="adj-open-btn" title="Adjustment">⬛ Adj</button>
            <button class="btn" id="fsbtn">
                <svg id="ico-fs" viewBox="0 0 18 18"><path d="M9.57 3.62A1 1 0 008.65 3H4c-.55 0-1 .45-1 1v4.65A1 1 0 004.71 9.7l4.65-4.65a1 1 0 00.22-1.43zm4.81 4.81a1 1 0 00-1.09.22L8.64 13.3a1 1 0 00.71 1.7H14c.55 0 1-.45 1-1V9.35a1 1 0 00-.62-.92z"/></svg>
                <svg id="ico-exfs" viewBox="0 0 18 18" style="display:none"><path d="M7.88 1.93a.99.99 0 00-1.09.22L2.15 6.79A1 1 0 002.85 8.5H7.5c.55 0 1-.45 1-1V2.85a1 1 0 00-.62-.92zm7.26 7.57H10.5c-.55 0-1 .45-1 1v4.65a1 1 0 001.71.71l4.65-4.65a1 1 0 00-.72-1.71z"/></svg>
            </button>
            </div>
        </div>
        </div>

        <script>
        const SRC      = "%s";
        const MIME     = "%s";
        const SRT_URL  = "%s";
        const DIR_PATH = "%s";
        const CUR_FILE = "%s";
        """.printf (filename, encoded_path, mime, srt_src, dir_path, GLib.Path.get_basename (file_path));
        var seconstr = """
        const vid      = document.getElementById('vid');
        const player   = document.getElementById('player');
        const badge    = document.getElementById('codecBadge');
        const errOv    = document.getElementById('errOverlay');
        const errMsg   = document.getElementById('errMsg');
        const subEl    = document.getElementById('subtitle-text');

        let hls = null;
        let mpegPlayer = null;
        let jsmpegPlayer = null;
        let canvasEl = null;
        let urlvid = SRC;

        // ── Playlist ──
        let playlist = [], curIdx = -1;
        (async()=>{
        try {
            const resp = await fetch('/DirListVideo?path=' + encodeURIComponent(DIR_PATH));
            const list = await resp.json();
            playlist   = list;
            curIdx     = list.findIndex(f => f.name === CUR_FILE);
            if (curIdx >= 0) {
            updateDownload(playlist[curIdx]);
            }
            updateNavBtns();
        } catch(e){ console.log('DirListVideo err',e); }
        })();

        function updateNavBtns(){
        document.getElementById('big-prev').style.opacity = curIdx<=0?'0.3':'1';
        document.getElementById('big-next').style.opacity = curIdx>=playlist.length-1?'0.3':'1';
        }
        function playIdx(idx){
        if(idx<0||idx>=playlist.length) return;

        resetPlayer();
        curIdx=idx;
        const f=playlist[idx];
        updateDownload(f);

        urlvid = '/Rawori?path=' + (f.path);
        startPlayer ();

        history.replaceState(null,'','/Player?path='+f.path);
        updateNavBtns();
        // Load subtitle baru
        const srtUrl='/Rawori?path='+f.path.replace(/%2F|[^%]/gi,c=>c).replace(/\.[^.]*$/,'')+'.srt';
        loadSRT('/Rawori?path='+decodeURIComponent(f.path).replace(/\.[^.]*$/,'')+'.srt');
        // Update title
        document.querySelector('header span').textContent=f.name;
        }

        // ── Codec fallback ──
        function loadScript(url,cb,errcb){const s=document.createElement('script');s.src=url;s.onload=cb;s.onerror=()=>{if(errcb)errcb();else showError('Gagal load: '+url);};document.head.appendChild(s);}
        function setBadge(l,c){badge.textContent=l;badge.style.color=c||'rgba(255,255,255,0.6)';}
        function showError(msg){errMsg.textContent=msg;errOv.classList.add('show');}

        function tryMpeg1(){
        setBadge('MPEG-1 · jsmpeg','#a78bfa');vid.style.display='none';
        canvasEl=document.createElement('canvas');canvasEl.style.cssText='max-width:100%%;max-height:100%%;display:block;margin:auto;background:#000;';
        player.insertBefore(canvasEl,vid);
        loadScript('/Mpegplayjs',()=>{
            jsmpegPlayer=new jsmpeg(urlvid,{canvasEl,autoplay:true,audio:true});
            canvasEl.addEventListener('click',()=>jsmpegPlayer.pause?jsmpegPlayer.pause():null);
        },()=>showError('Semua codec gagal'));
        }
        function tryMpegts(){
        loadScript('/Mpegjs',()=>{
            if(!mpegts.isSupported()){tryHls();return;}
            setBadge('mpegts.js','#fb923c');
            mpegPlayer=mpegts.createPlayer({type:'mpegts',url:urlvid,isLive:false});
            mpegPlayer.attachMediaElement(vid);mpegPlayer.load();mpegPlayer.play();
            mpegPlayer.on(mpegts.Events.ERROR,()=>tryHls());
        },()=>tryHls());
        }
        function tryHls(){
        loadScript('/Hlsjs',()=>{
            if(!Hls.isSupported()){tryMpeg1();return;}
            setBadge('HLS · hls.js','#60a5fa');
            hls=new Hls();hls.loadSource(urlvid);hls.attachMedia(vid);
            hls.on(Hls.Events.MANIFEST_PARSED,()=>vid.play());
            hls.on(Hls.Events.ERROR,(_,d)=>{if(d.fatal){hls.destroy();tryMpeg1();}});
        },()=>tryMpeg1());
        }
        function startPlayer(){
        setBadge('Native','rgba(255,255,255,0.5)');vid.src=urlvid;
        vid.addEventListener('error',()=>{vid.removeAttribute('src');vid.load();tryMpegts();},{once:true});
        vid.play().catch(()=>{});
        }
        startPlayer();

        function resetPlayer() {
        // destroy hls
        if (hls) {
            hls.destroy();
            hls = null;
        }

        // destroy mpegts
        if (mpegPlayer) {
            mpegPlayer.destroy();
            mpegPlayer = null;
        }

        // destroy jsmpeg
        if (jsmpegPlayer) {
            jsmpegPlayer.destroy && jsmpegPlayer.destroy();
            jsmpegPlayer = null;
        }

        // remove canvas
        if (canvasEl) {
            canvasEl.remove();
            canvasEl = null;
        }

        // reset video
        vid.pause();
        vid.removeAttribute('src');
        vid.load();
        vid.style.display = 'block';
        }

        // ── dobletap seeker ──
        let lastTapTime = 0;
        let tapTimeout = null;

        player.addEventListener('touchend', function(e) {
        if (e.target.closest('.controls') || e.target.closest('.adj-overlay')) return;

        const now = Date.now();
        const tapDelay = now - lastTapTime;

        const rect = player.getBoundingClientRect();
        const x = e.changedTouches[0].clientX - rect.left;
        const width = rect.width;

        // double tap
        if (tapDelay < 300 && tapDelay > 0) {
            clearTimeout(tapTimeout);

            if (x < width * 0.4) {
            // kiri
            vid.currentTime = Math.max(0, vid.currentTime - 10);
            showSeekIndicator('left');
            } 
            else if (x > width * 0.6) {
            // kanan
            vid.currentTime = Math.min(vid.duration, vid.currentTime + 10);
            showSeekIndicator('right');
            }

        } else {
            // single tap → do nothing
            tapTimeout = setTimeout(() => {}, 300);
        }

        lastTapTime = now;
        });
        function showSeekIndicator(dir){
        const el = document.getElementById('seek-indicator');
        if(!el) return;

        el.className = 'seek-indicator ' + dir + ' show';
        el.textContent = dir === 'left' ? '10s' : '10s';

        setTimeout(()=>{
            el.classList.remove('show');
        }, 300);
        }

        // ── Subtitle SRT parser ──
        let srtCues = [];
        async function loadSRT(url){
        srtCues=[];
        try{
            const resp=await fetch(url);
            if(!resp.ok) return;
            const text=await resp.text();
            const blocks=text.replace(/\r\n/g,'\n').split(/\n\n+/);
            blocks.forEach(block=>{
            const lines=block.trim().split('\n');
            if(lines.length<3) return;
            const timeMatch=lines[1].match(/(\d+):(\d+):(\d+)[,.](\d+)\s*-->\s*(\d+):(\d+):(\d+)[,.](\d+)/);
            if(!timeMatch) return;
            const toSec=(h,m,s,ms)=>parseInt(h)*3600+parseInt(m)*60+parseInt(s)+parseInt(ms)/1000;
            const start=toSec(timeMatch[1],timeMatch[2],timeMatch[3],timeMatch[4]);
            const end  =toSec(timeMatch[5],timeMatch[6],timeMatch[7],timeMatch[8]);
            const text2=lines.slice(2).join('\n').replace(/<[^>]+>/g,'');
            srtCues.push({start,end,text:text2});
            });
        }catch(e){console.log('SRT err',e);}
        }
        loadSRT(SRT_URL);

        function syncSubtitle(t){
        const cue=srtCues.find(c=>t>=c.start&&t<=c.end);
        if(cue){subEl.textContent=cue.text;subEl.classList.add('show');}
        else{subEl.classList.remove('show');}
        }
        
        let holdSpeed = false;
        let holdTimer = null;
        let prevSpeed = 1;
        let holding = false;

        // deteksi area kiri / kanan
        function isSideHold(e) {
        const rect = player.getBoundingClientRect();
        const x = (e.touches ? e.touches[0].clientX : e.clientX) - rect.left;
        return (x < rect.width * 0.3 || x > rect.width * 0.7);
        }

        // START HOLD
        function startHold(e) {
        // ❌ blok kalau klik UI
        if (e.target.closest('.controls') || e.target.closest('.adj-overlay')) return;

        // ❌ hanya area kiri kanan
        if (!isSideHold(e)) return;

        holding = true;

        // 🔥 cegah klik / context menu
        e.preventDefault();

        holdTimer = setTimeout(() => {
            if (!holding) return;

            holdSpeed = true;
            prevSpeed = vid.playbackRate;

            vid.playbackRate = 2.0;
            player.classList.add('holding-speed');
        }, 200);
        }

        // END HOLD
        function endHold() {
        holding = false;

        if (holdTimer) {
            clearTimeout(holdTimer);
            holdTimer = null;
        }

        if (holdSpeed) {
            vid.playbackRate = prevSpeed;
            holdSpeed = false;
        }

        // 🔥 paksa hilang
        player.classList.remove('holding-speed');
        }

        // mouse
        player.addEventListener('mousedown', startHold);
        document.addEventListener('mouseup', endHold);
        document.addEventListener('mouseleave', endHold);

        // touch (HP)
        player.addEventListener('touchstart', startHold, { passive:false });
        document.addEventListener('touchend', endHold);
        document.addEventListener('touchcancel', endHold);

        // 🔥 cegah context menu (INI YANG BIKIN POPUP DOWNLOAD)
        player.addEventListener('contextmenu', e => e.preventDefault());

        // ── Video Adjustment ──
        const adjState={subsize: 18,brightness:1,contrast:1,saturate:1,hue:0,gamma:1,blur:0};
        function applyAdj(){
        subEl.style.fontSize = adjState.subsize + 'px';
        vid.style.filter=`brightness(${adjState.brightness}) contrast(${adjState.contrast}) saturate(${adjState.saturate}) hue-rotate(${adjState.hue}deg) blur(${adjState.blur}px) brightness(${1/Math.max(adjState.gamma,0.1)})`;
        }

        const adjSliders={
        'subsize': { unit:'px', dec:0 },
        'brightness':{unit:'',dec:2},
        'contrast':  {unit:'',dec:2},
        'saturate':  {unit:'',dec:2},
        'hue':       {unit:'°',dec:0},
        'gamma':     {unit:'',dec:2},
        'blur':      {unit:'',dec:1},
        };
        Object.keys(adjSliders).forEach(k=>{
        const sl=document.getElementById('sl-'+k);
        const vl=document.getElementById('val-'+k);
        sl.addEventListener('input',()=>{
            const v=parseFloat(sl.value);
            adjState[k]=v;
            const cfg=adjSliders[k];
            vl.textContent=v.toFixed(cfg.dec)+cfg.unit;
            applyAdj();
        });
        });

        function resetAdj(){
        const defaults={subsize: 18,brightness:1,contrast:1,saturate:1,hue:0,gamma:1,blur:0};
        Object.keys(defaults).forEach(k=>{
            adjState[k]=defaults[k];
            document.getElementById('sl-'+k).value=defaults[k];
            const cfg=adjSliders[k];
            document.getElementById('val-'+k).textContent=defaults[k].toFixed(cfg.dec)+cfg.unit;
        });
        applyAdj();
        }
        
        function adjOpen(){
        document.getElementById('adj-overlay').classList.add('open');
        player.classList.add('lock-click');
        }

        function adjClose(){
        document.getElementById('adj-overlay').classList.remove('open');
        player.classList.remove('lock-click');
        }
        function adjBg(e){if(e.target===document.getElementById('adj-overlay'))adjClose();}
        document.getElementById('adj-open-btn').addEventListener('click',adjOpen);
        let hideTimer = null;

        function showControls() {
        player.classList.remove('hide-ui');

        // reset timer
        if (hideTimer) clearTimeout(hideTimer);

        hideTimer = setTimeout(() => {
            player.classList.add('hide-ui');
        }, 5000); // 5 detik
        }

        // trigger saat mouse gerak
        player.addEventListener('mousemove', showControls);
        player.addEventListener('click', showControls);

        // saat fullscreen juga aktif
        document.addEventListener('fullscreenchange', showControls);

        // start pertama
        showControls();
        // ── Player controls ──
        const playbtn=document.getElementById('playbtn');
        const icoPlay=document.getElementById('ico-play');
        const icoPause=document.getElementById('ico-pause');
        const bigIcoPlay=document.getElementById('big-ico-play');
        const bigIcoPause=document.getElementById('big-ico-pause');
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

        const speeds=[0.5,0.75,1,1.25,1.5,2];let speedIdx=2;
        function fmt(s){
        s=Math.floor(s||0);
        return Math.floor(s/60)+':'+String(s%60).padStart(2,'0');
        }
        function updatePlay(){
        const p=vid.paused;
        icoPlay.style.display=p?'':'none';icoPause.style.display=p?'none':'';
        bigIcoPlay.style.display=p?'':'none';bigIcoPause.style.display=p?'none':'';
        player.classList.toggle('paused',p);player.classList.toggle('playing',!p);
        }
        function updateMute(){icoVol.style.display=vid.muted?'none':'';icoMute.style.display=vid.muted?'':'none';}
        document.querySelectorAll('.adj-card, .adj-card *').forEach(el=>{
        el.addEventListener('click', e => {
        // hanya blok kalau bukan preset
        if (!e.target.closest('.preset-btn')) {
            e.stopPropagation();
        }
        });
        el.addEventListener('mousedown', e => e.stopPropagation());
        });
        vid.addEventListener('timeupdate',()=>{
        if (!vid.duration) return;

        const pct = (vid.currentTime / vid.duration) * 100;

        fill.style.width = pct + '%';
        thumb.style.left = pct + '%';
        cur.textContent = fmt(vid.currentTime);

        syncSubtitle(vid.currentTime);
        });
        vid.addEventListener('durationchange',()=>{dur.textContent=fmt(vid.duration);});
        vid.addEventListener('progress',()=>{if(vid.buffered.length)buf.style.width=(vid.buffered.end(vid.buffered.length-1)/vid.duration*100)+'%';});
        vid.addEventListener('play',updatePlay);vid.addEventListener('pause',updatePlay);
        vid.addEventListener('ended',()=>{
        updatePlay();
        if(curIdx>=0&&curIdx<playlist.length-1) playIdx(curIdx+1);
        });

        // Big play button
        document.getElementById('big-play').addEventListener('click',e=>{e.stopPropagation();vid.paused?vid.play():vid.pause();});
        document.getElementById('big-prev').addEventListener('click',e=>{e.stopPropagation();if(curIdx>0)playIdx(curIdx-1);});
        document.getElementById('big-next').addEventListener('click',e=>{e.stopPropagation();if(curIdx<playlist.length-1)playIdx(curIdx+1);});

        document.getElementById('controls').addEventListener('click',e=>e.stopPropagation());

        playbtn.addEventListener('click',()=>{vid.paused?vid.play():vid.pause();});
        document.getElementById('seekback').addEventListener('click',()=>{vid.currentTime=Math.max(0,vid.currentTime-10);});
        document.getElementById('seekfwd').addEventListener('click',()=>{vid.currentTime=Math.min(vid.duration,vid.currentTime+10);});

        prog.addEventListener('click',e=>{const r=prog.getBoundingClientRect();vid.currentTime=((e.clientX-r.left)/r.width)*vid.duration;});
        let dragging=false;
        prog.addEventListener('mousedown',()=>{dragging=true;});
        document.addEventListener('mousemove',e=>{if(!dragging)return;const r=prog.getBoundingClientRect();vid.currentTime=Math.max(0,Math.min(1,(e.clientX-r.left)/r.width))*vid.duration;});
        document.addEventListener('mouseup',()=>{dragging=false;});

        vol.addEventListener('input',()=>{vid.volume=vol.value;vid.muted=vol.value==0;updateMute();});
        mutebtn.addEventListener('click',()=>{vid.muted=!vid.muted;if(vid.muted)vol.value=0;else{if(vol.value==0)vol.value=1;vid.volume=vol.value;}updateMute();});
        speedbtn.addEventListener('click',()=>{speedIdx=(speedIdx+1)%speeds.length;vid.playbackRate=speeds[speedIdx];speedbtn.textContent=speeds[speedIdx]+'\u00D7';});
        fsbtn.addEventListener('click',()=>{if(!document.fullscreenElement)player.requestFullscreen();else document.exitFullscreen();});
        document.addEventListener('fullscreenchange',()=>{const fs=!!document.fullscreenElement;icoFs.style.display=fs?'none':'';icoExfs.style.display=fs?'':'none';});
        document.addEventListener('keydown',e=>{
        if(['INPUT','TEXTAREA'].includes(document.activeElement.tagName))return;
        if(e.key==='Escape')adjClose();
        if(e.key===' '||e.key==='k'){e.preventDefault();vid.paused?vid.play():vid.pause();}
        if(e.key==='ArrowLeft'&&!e.ctrlKey)vid.currentTime=Math.max(0,vid.currentTime-5);
        if(e.key==='ArrowRight'&&!e.ctrlKey)vid.currentTime=Math.min(vid.duration,vid.currentTime+5);
        if(e.key==='ArrowLeft'&&e.ctrlKey){if(curIdx>0)playIdx(curIdx-1);}
        if(e.key==='ArrowRight'&&e.ctrlKey){if(curIdx<playlist.length-1)playIdx(curIdx+1);}
        if(e.key==='ArrowUp'){vid.volume=Math.min(1,vid.volume+0.1);vol.value=vid.volume;}
        if(e.key==='ArrowDown'){vid.volume=Math.max(0,vid.volume-0.1);vol.value=vid.volume;}
        if(e.key==='f')fsbtn.click();
        if(e.key==='m')mutebtn.click();
        });
        const btnDownload = document.getElementById('btn-download');
        const ttlDownload = document.getElementById('title-download');

        function updateDownload(f) {
        if (!f) return;

        const url = '/Rawori?path=' + (f.path);
        btnDownload.href = url;
        btnDownload.download = f.name;
        ttlDownload.innerText = f.name;
        }
        // ── Tab switch ──
        function switchTab(tab) {
        document.getElementById('panel-video').style.display = tab==='video' ? '' : 'none';
        document.getElementById('panel-audio').style.display = tab==='audio' ? '' : 'none';
        document.getElementById('tab-video').classList.toggle('active', tab==='video');
        document.getElementById('tab-audio').classList.toggle('active', tab==='audio');
        if (tab==='audio') initAudio();
        }

        // ── Web Audio EQ ──
        let audioCtx, analyser, vidSource, gainNode;
        let eqFilters = [];
        let bassFilter, midFilter, trebleFilter;
        let dolbyConvolver, dolbyGain, dolbyEnabled=false, dolbyConnected=false;
        let audioConnected = false;

        const BANDS       = [60,170,350,1000,3500,10000,16000];
        const BAND_LABELS = ['60','170','350','1k','3.5k','10k','16k'];
        const PRESETS = {
        flat:[0,0,0,0,0,0,0], bass:[8,6,4,0,0,0,0], treble:[0,0,0,0,4,6,8],
        vocal:[-2,-2,4,6,4,-2,-2], rock:[6,4,2,0,2,4,6], pop:[-2,2,4,4,2,-2,-4],
        jazz:[4,2,0,2,4,4,2], classical:[4,4,2,0,0,2,4],
        };

        async function initAudio() {
        if (audioConnected) {
            if (audioCtx && audioCtx.state === 'suspended') {
            await audioCtx.resume();
            }
            return;
        }

        audioCtx = new (window.AudioContext || window.webkitAudioContext)();

        if (audioCtx.state === 'suspended') {
            await audioCtx.resume();
        }

        analyser = audioCtx.createAnalyser();
        analyser.fftSize = 128;
        analyser.smoothingTimeConstant = 0.8;

        gainNode = audioCtx.createGain();
        gainNode.gain.value = 0.85;

        vidSource = audioCtx.createMediaElementSource(vid);

        eqFilters = BANDS.map((freq, i) => {
            const f = audioCtx.createBiquadFilter();
            f.type = i === 0 ? 'lowshelf' : i === BANDS.length - 1 ? 'highshelf' : 'peaking';
            f.frequency.value = freq;
            f.Q.value = 1;
            f.gain.value = 0;
            return f;
        });

        bassFilter = audioCtx.createBiquadFilter();
        bassFilter.type = 'lowshelf';
        bassFilter.frequency.value = 200;

        midFilter = audioCtx.createBiquadFilter();
        midFilter.type = 'peaking';
        midFilter.frequency.value = 1000;
        midFilter.Q.value = 0.8;

        trebleFilter = audioCtx.createBiquadFilter();
        trebleFilter.type = 'highshelf';
        trebleFilter.frequency.value = 4000;

        let prev = vidSource;

        [...eqFilters, bassFilter, midFilter, trebleFilter].forEach(f => {
            prev.connect(f);
            prev = f;
        });

        prev.connect(gainNode);
        gainNode.connect(analyser);
        analyser.connect(audioCtx.destination);

        audioConnected = true;
        buildSliders();
        }
        function makeDolbyIR() {
        const sr=audioCtx.sampleRate, len=Math.floor(sr*2.5);
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

        function connectDolbyChain() {
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

        function toggleDolby() {
        dolbyEnabled=!dolbyEnabled;
        document.getElementById('dolby-toggle').classList.toggle('on',dolbyEnabled);
        if(audioConnected){connectDolbyChain();dolbyGain.gain.setTargetAtTime(dolbyEnabled?0.6:0,audioCtx.currentTime,0.08);}
        }

        function buildSliders() {
        const wrap=document.getElementById('eq-sliders'); wrap.innerHTML='';
        BANDS.forEach((freq,i)=>{
            const div=document.createElement('div'); div.className='eq-band';
            const val=document.createElement('div'); val.className='eq-band-val';val.id='eqv'+i;val.textContent='0';
            const sl=document.createElement('input'); sl.type='range';sl.className='vert';
            sl.min=-12;sl.max=12;sl.step=0.5;sl.value=0;sl.id='eqs'+i;
            sl.addEventListener('input',()=>{
            const v=parseFloat(sl.value);val.textContent=(v>0?'+':'')+v;
            if(audioConnected)eqFilters[i].gain.value=v;
            clearPresetActive();
            });
            const lbl=document.createElement('div');lbl.className='eq-band-label';lbl.textContent=BAND_LABELS[i];
            div.appendChild(val);div.appendChild(sl);div.appendChild(lbl);wrap.appendChild(div);
        });
        }

        document.getElementById('sl-bass').addEventListener('input',function(){
        document.getElementById('val-bass').textContent=(this.value>0?'+':'')+this.value+' dB';
        if(audioConnected)bassFilter.gain.value=parseFloat(this.value);clearPresetActive();
        });
        document.getElementById('sl-mid').addEventListener('input',function(){
        document.getElementById('val-mid').textContent=(this.value>0?'+':'')+this.value+' dB';
        if(audioConnected)midFilter.gain.value=parseFloat(this.value);clearPresetActive();
        });
        document.getElementById('sl-treble').addEventListener('input',function(){
        document.getElementById('val-treble').textContent=(this.value>0?'+':'')+this.value+' dB';
        if(audioConnected)trebleFilter.gain.value=parseFloat(this.value);clearPresetActive();
        });

        document.querySelectorAll('.preset-btn').forEach(btn=>{
            btn.addEventListener('click', async (e)=>{
            e.stopPropagation(); // optional

            await initAudio();

            const key = btn.dataset.preset?.trim();
            const vals = PRESETS[key];

            console.log('preset:', key);
            console.log('vals:', vals);

            if (!vals) return;

            vals.forEach((v,i)=>{
            const sl=document.getElementById('eqs'+i);
            const vl=document.getElementById('eqv'+i);

            if(sl){
                sl.value = v;
                vl.textContent = (v>0?'+':'')+v;
                eqFilters[i].gain.setValueAtTime(v, audioCtx.currentTime);
            }
            });

            document.querySelectorAll('.preset-btn').forEach(b=>b.classList.remove('active'));
            btn.classList.add('active');
        });
        });
        function clearPresetActive(){document.querySelectorAll('.preset-btn').forEach(b=>b.classList.remove('active'));}

        function resetEQ(){
        BANDS.forEach((_,i)=>{
            const sl=document.getElementById('eqs'+i),vl=document.getElementById('eqv'+i);
            if(sl){sl.value=0;vl.textContent='0';if(audioConnected)eqFilters[i].gain.value=0;}
        });
        ['bass','mid','treble'].forEach(k=>{
            document.getElementById('sl-'+k).value=0;
            document.getElementById('val-'+k).textContent='0 dB';
        });
        if(audioConnected){bassFilter.gain.value=0;midFilter.gain.value=0;trebleFilter.gain.value=0;}
        document.querySelectorAll('.preset-btn').forEach(b=>b.classList.remove('active'));
        document.querySelector('[data-preset=flat]')?.classList.add('active');
        }
        </script>
        </body>
        </html>""";
        return firststr + seconstr;
    }
}