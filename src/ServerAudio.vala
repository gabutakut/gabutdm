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
        <title id="title-download">%s</title>
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
        .art-wrap{width:190px;height:190px;border-radius:20px;background:rgba(167,139,250,0.1);border:0.5px solid rgba(167,139,250,0.2);display:flex;align-items:center;justify-content:center;box-shadow:0 20px 60px rgba(0,0,0,0.5);animation:float 4s ease-in-out infinite;position:relative;overflow:hidden;flex-shrink:0;}
        @keyframes float{0%%,100%%{transform:translateY(0);}50%%{transform:translateY(-6px);}}
        .art-wrap.playing{animation:float 4s ease-in-out infinite,pulse-ring 2s ease-in-out infinite;}
        @keyframes pulse-ring{0%%{box-shadow:0 20px 60px rgba(0,0,0,0.5),0 0 0 0 rgba(167,139,250,0.3);}70%%{box-shadow:0 20px 60px rgba(0,0,0,0.5),0 0 0 20px rgba(167,139,250,0);}100%%{box-shadow:0 20px 60px rgba(0,0,0,0.5),0 0 0 0 rgba(167,139,250,0);}}
        .art-img{width:100%%;height:100%%;object-fit:cover;display:none;}
        .art-icon{width:64px;height:64px;fill:none;stroke:rgba(167,139,250,0.5);stroke-width:1.2;stroke-linecap:round;}
        .art-wrap.playing::after{content:'';position:absolute;inset:0;pointer-events:none;background:conic-gradient(rgba(167,139,250,0.05) 0deg,transparent 90deg,rgba(96,165,250,0.05) 180deg,transparent 270deg);animation:spin-slow 8s linear infinite;}
        @keyframes spin-slow{to{transform:rotate(360deg);}}
        .eq-wrap{width:100%%;max-width:480px;height:56px;border-radius:14px;overflow:hidden;background:rgba(255,255,255,0.02);border:0.5px solid rgba(255,255,255,0.06);}
        #eq-canvas{width:100%%;height:100%%;display:block;}
        .track-info{text-align:center;}
        .track-title{font-size:17px;font-weight:700;color:#fff;margin-bottom:4px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;max-width:400px;}
        .track-artist{font-size:13px;color:rgba(167,139,250,0.8);margin-bottom:2px;}
        .track-album{font-size:12px;color:rgba(255,255,255,0.3);}
        .track-mime{font-size:11px;color:rgba(255,255,255,0.2);text-transform:uppercase;letter-spacing:0.08em;margin-top:4px;}
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
        .eq-overlay{display:none;position:fixed;inset:0;z-index:200;background:rgba(0,0,0,0.65);backdrop-filter:blur(16px);-webkit-backdrop-filter:blur(16px);align-items:flex-end;justify-content:center;padding:0 0 20px;}
        .eq-overlay.open{display:flex;}
        .eq-card{background:#161616;border:0.5px solid rgba(255,255,255,0.1);border-radius:24px 24px 20px 20px;width:100%%;max-width:480px;padding:20px 24px 24px;box-shadow:0 -8px 40px rgba(0,0,0,0.5);animation:eqIn 0.28s cubic-bezier(0.34,1.56,0.64,1) both;}
        @keyframes eqIn{from{opacity:0;transform:translateY(40px);}to{opacity:1;transform:translateY(0);}}
        .eq-header{display:flex;align-items:center;margin-bottom:20px;}
        .eq-title{font-size:15px;font-weight:700;color:#fff;flex:1;}
        .eq-close{width:28px;height:28px;border-radius:50%%;border:none;background:rgba(255,255,255,0.08);color:rgba(255,255,255,0.5);font-size:14px;cursor:pointer;display:grid;place-items:center;}
        .eq-close:hover{background:rgba(255,255,255,0.14);}
        .eq-presets{display:flex;gap:6px;flex-wrap:wrap;margin-bottom:18px;}
        .preset-btn{padding:5px 12px;border-radius:999px;font-size:11px;font-weight:600;border:0.5px solid rgba(255,255,255,0.1);background:rgba(255,255,255,0.05);color:rgba(255,255,255,0.5);cursor:pointer;font-family:inherit;transition:all 0.15s;}
        .preset-btn:hover{background:rgba(255,255,255,0.1);color:#fff;}
        .preset-btn.active{background:rgba(167,139,250,0.2);border-color:rgba(167,139,250,0.4);color:#a78bfa;}
        .dolby-row{display:flex;align-items:center;gap:12px;margin-bottom:18px;padding:12px 16px;background:rgba(96,165,250,0.06);border:0.5px solid rgba(96,165,250,0.15);border-radius:14px;}
        .dolby-info{flex:1;}
        .dolby-title{font-size:13px;font-weight:600;color:#fff;}
        .dolby-sub{font-size:11px;color:rgba(255,255,255,0.3);margin-top:2px;}
        .toggle{width:42px;height:24px;border-radius:999px;background:rgba(255,255,255,0.1);border:none;cursor:pointer;position:relative;transition:background 0.2s;flex-shrink:0;}
        .toggle::after{content:'';position:absolute;top:3px;left:3px;width:18px;height:18px;border-radius:50%%;background:#fff;transition:transform 0.2s;box-shadow:0 1px 4px rgba(0,0,0,0.3);}
        .toggle.on{background:linear-gradient(135deg,#60a5fa,#a78bfa);}
        .toggle.on::after{transform:translateX(18px);}
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
        .lrc-scroll{
        height:150px;overflow:hidden;
        border-radius:16px;
        background:rgba(255,255,255,0.01);
        border:0.5px solid rgba(255,255,255,0.01);
        position:relative;
        }
        .lrc-scroll::before,.lrc-scroll::after{
        content:'';position:absolute;left:0;right:0;height:48px;z-index:1;pointer-events:none;
        }
        .lrc-scroll::before{top:0;background:linear-gradient(to bottom,rgba(10,10,10,0.01),transparent);}
        .lrc-scroll::after{bottom:0;background:linear-gradient(to top,rgba(10,10,10,0.01),transparent);}
        .lrc-inner{
        padding:0px 0;
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
        .lrcdl-overlay{display:none;position:fixed;inset:0;z-index:300;background:rgba(0,0,0,0.72);backdrop-filter:blur(20px);-webkit-backdrop-filter:blur(20px);align-items:center;justify-content:center;padding:20px;}
        .lrcdl-overlay.open{display:flex;}
        .lrcdl-card{background:#161616;border:0.5px solid rgba(255,255,255,0.1);border-radius:24px;width:100%;max-width:520px;max-height:82vh;display:flex;flex-direction:column;box-shadow:0 24px 64px rgba(0,0,0,0.6);animation:eqIn 0.28s cubic-bezier(0.34,1.56,0.64,1) both;}
        .lrcdl-header{padding:18px 20px 0;display:flex;align-items:center;gap:10px;flex-shrink:0;}
        .lrcdl-title{font-size:15px;font-weight:700;color:#fff;flex:1;}
        .lrcdl-close{width:28px;height:28px;border-radius:50%;border:none;background:rgba(255,255,255,0.08);color:rgba(255,255,255,0.5);font-size:14px;cursor:pointer;display:grid;place-items:center;}
        .lrcdl-close:hover{background:rgba(255,255,255,0.14);}
        .lrcdl-searchrow{padding:12px 20px 0;display:flex;gap:8px;flex-shrink:0;}
        .lrcdl-inp{flex:1;background:rgba(255,255,255,0.07);border:0.5px solid rgba(255,255,255,0.12);border-radius:12px;padding:9px 14px;color:#fff;font-size:13px;font-family:inherit;outline:none;transition:border-color 0.15s;}
        .lrcdl-inp:focus{border-color:rgba(167,139,250,0.5);}
        .lrcdl-inp::placeholder{color:rgba(255,255,255,0.25);}
        .lrcdl-go{padding:9px 18px;background:linear-gradient(135deg,#a78bfa,#60a5fa);border:none;border-radius:12px;color:#fff;font-size:13px;font-weight:600;font-family:inherit;cursor:pointer;white-space:nowrap;transition:opacity 0.15s;}
        .lrcdl-go:hover{opacity:0.88;}
        .lrcdl-engines{padding:10px 20px 0;display:flex;gap:6px;flex-wrap:wrap;flex-shrink:0;}
        .lrcdl-eng-btn{padding:4px 12px;border-radius:999px;font-size:11px;font-weight:600;border:0.5px solid rgba(255,255,255,0.1);background:rgba(255,255,255,0.04);color:rgba(255,255,255,0.4);cursor:pointer;font-family:inherit;transition:all 0.15s;}
        .lrcdl-eng-btn.on{background:rgba(167,139,250,0.18);border-color:rgba(167,139,250,0.4);color:#a78bfa;}
        .lrcdl-status{padding:8px 20px 4px;font-size:11px;color:rgba(255,255,255,0.28);min-height:22px;flex-shrink:0;}
        .lrcdl-results{overflow-y:auto;padding:0 20px 20px;display:flex;flex-direction:column;gap:7px;}
        .lrcdl-item{background:rgba(255,255,255,0.04);border:0.5px solid rgba(255,255,255,0.07);border-radius:14px;padding:11px 14px;display:flex;align-items:center;gap:10px;transition:background 0.15s;}
        .lrcdl-item:hover{background:rgba(255,255,255,0.08);}
        .lrcdl-item-info{flex:1;overflow:hidden;}
        .lrcdl-item-title{font-size:13px;font-weight:600;color:#fff;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
        .lrcdl-item-artist{font-size:11px;color:rgba(255,255,255,0.38);margin-top:2px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
        .lrcdl-badge{font-size:10px;font-weight:700;padding:2px 8px;border-radius:999px;white-space:nowrap;flex-shrink:0;letter-spacing:0.03em;}
        .badge-netease{background:rgba(255,100,80,0.15);color:#ff7b6b;border:0.5px solid rgba(255,100,80,0.2);}
        .badge-megalobiz{background:rgba(96,165,250,0.15);color:#60a5fa;border:0.5px solid rgba(96,165,250,0.2);}
        .badge-s4songs{background:rgba(52,211,153,0.15);color:#34d399;border:0.5px solid rgba(52,211,153,0.2);}
        .lrcdl-apply{padding:5px 14px;background:rgba(167,139,250,0.12);border:0.5px solid rgba(167,139,250,0.28);border-radius:999px;color:#a78bfa;font-size:12px;font-weight:600;font-family:inherit;cursor:pointer;white-space:nowrap;transition:background 0.15s;flex-shrink:0;}
        .lrcdl-apply:hover{background:rgba(167,139,250,0.24);}
        .lrcdl-apply:disabled{opacity:0.5;cursor:default;}
        .lrcdl-empty{text-align:center;padding:36px 20px;color:rgba(255,255,255,0.18);font-size:13px;line-height:1.7;}
        .lrcdl-spinner{display:inline-block;width:14px;height:14px;border:2px solid rgba(167,139,250,0.3);border-top-color:#a78bfa;border-radius:50%;animation:spin-slow 0.7s linear infinite;vertical-align:middle;margin-right:6px;}
        .badge-lrclib{background:rgba(167,139,250,0.15);color:#a78bfa;border:0.5px solid rgba(167,139,250,0.3);}
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
        <button class="lrc-toggle" id="lrc-toggle-btn" onclick="toggleLrcMode()">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                <rect x="4" y="6" width="16" height="2"/>
                <rect x="4" y="11" width="16" height="2"/>
                <rect x="4" y="16" width="10" height="2"/>
            </svg>
        </button>
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
            <button class="eq-btn" id="eq-open-btn">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                    <!-- slider 1 -->
                    <line x1="6" y1="4" x2="6" y2="20" stroke="currentColor" stroke-width="2"/>
                    <circle cx="6" cy="10" r="2"/>
                    <!-- slider 2 -->
                    <line x1="12" y1="4" x2="12" y2="20" stroke="currentColor" stroke-width="2"/>
                    <circle cx="12" cy="14" r="2"/>
                    <!-- slider 3 -->
                    <line x1="18" y1="4" x2="18" y2="20" stroke="currentColor" stroke-width="2"/>
                    <circle cx="18" cy="8" r="2"/>
                </svg>
            </button>
            <button class="eq-btn" id="lrcdl-open-btn" onclick="lrcdlOpen()">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                    <circle cx="11" cy="11" r="6" stroke="currentColor" stroke-width="2" fill="none"/>
                    <line x1="16" y1="16" x2="21" y2="21" stroke="currentColor" stroke-width="2"/>
                </svg>
            </button>
            <div style="flex:1"></div>
            <button class="speed-btn" id="cf-btn" title="Crossfade" onclick="toggleCrossfade()">
                <svg id="ico-cf-off" viewBox="0 0 18 18" width="14" height="14"
                fill="none" stroke="rgba(255,255,255,0.3)" stroke-width="1.6"
                stroke-linecap="round" stroke-linejoin="round">
                    <path d="M4 7c4 0 4 10 8 10s4-10 8-10"/>
                    <line x1="4" y1="17" x2="8" y2="17"/>
                    <line x1="16" y1="7" x2="20" y2="7"/>
                </svg>
                <!-- ON -->
                <svg id="ico-cf-on" viewBox="0 0 18 18" width="14" height="14"
                fill="none" stroke="#a78bfa" stroke-width="2"
                stroke-linecap="round" stroke-linejoin="round"
                style="display:none">
                    <path d="M4 7c4 0 4 10 8 10s4-10 8-10"/>
                    <path d="M4 17c4 0 4-10 8-10s4 10 8 10"/>
                </svg>
            </button>
            <button class="repeat-btn" id="btn-repeat" title="Repeat" onclick="cycleRepeat()">
                <!--REPEAT OFF -->
                <svg id="ico-repeat-none" viewBox="0 0 24 24" width="16" height="16"
                fill="none" stroke="rgba(255,255,255,0.25)" stroke-width="1.5"
                stroke-linecap="round" stroke-linejoin="round">
                    <path d="M3 12a9 9 0 0 1 15-6"/>
                    <polyline points="18 3 18 9 12 9"/>
                    <path d="M21 12a9 9 0 0 1-15 6"/>
                    <polyline points="6 21 6 15 12 15"/>
                </svg>
                <!-- REPEAT ALL -->
                <svg id="ico-repeat-all" viewBox="0 0 24 24" width="16" height="16"
                fill="none" stroke="#a78bfa" stroke-width="2"
                stroke-linecap="round" stroke-linejoin="round" style="display:none">
                    <path d="M3 12a9 9 0 0 1 15-6"/>
                    <polyline points="18 3 18 9 12 9"/>
                    <path d="M21 12a9 9 0 0 1-15 6"/>
                    <polyline points="6 21 6 15 12 15"/>
                </svg>
                <!-- REPEAT ONE -->
                <svg id="ico-repeat-one" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="#a78bfa" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display:none">
                    <path d="M3 12a9 9 0 0 1 15-6"/>
                    <polyline points="18 3 18 9 12 9"/>
                    <path d="M21 12a9 9 0 0 1-15 6"/>
                    <polyline points="6 21 6 15 12 15"/>
                    <circle cx="12" cy="12" r="4" fill="#a78bfa" stroke="none"/>
                    <text x="12" y="13.5" font-size="6" font-weight="bold" fill="white" text-anchor="middle">1</text>
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
        const aud = document.getElementById('aud');
        const art = document.getElementById('art');
        const artImg = document.getElementById('art-img');
        const artIcon = document.getElementById('art-icon');
        const btnPlay = document.getElementById('btn-play');
        const icoPlay = document.getElementById('ico-play');
        const icoPause = document.getElementById('ico-pause');
        const curEl = document.getElementById('cur');
        const durEl = document.getElementById('dur');
        const fill = document.getElementById('fill');
        const buf = document.getElementById('buf');
        const prog = document.getElementById('prog');
        const volEl = document.getElementById('vol');
        const icoVol = document.getElementById('ico-vol');
        const icoMute = document.getElementById('ico-mute');
        const speedBtn = document.getElementById('speed-btn');
        const canvas = document.getElementById('eq-canvas');
        const ctx2d = canvas.getContext('2d');
        const eqOpenBtn= document.getElementById('eq-open-btn');
        const thumb = document.getElementById('thumb');
        const FILE_URL = '%s';
        const speeds = [0.5,0.75,1,1.25,1.5,2];
        let speedIdx = 2;
        let playlist = [];
        let curIdx = -1;
        let repeatMode = 0;
        (async () => {
        try {
            const u = new URL(FILE_URL, location.origin);
            const fpath= decodeURIComponent(u.searchParams.get('path') || '');
            const dir = fpath.substring(0, fpath.lastIndexOf('/'));
            const resp = await fetch('/DirList?path=' + encodeURIComponent(dir));
            const list = await resp.json();
            playlist = list;
            const base = fpath.split('/').pop();
            curIdx = list.findIndex(f => f.name === base);
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
        updateMediaSession ();
        updateNavBtns();
        history.replaceState(null, '', '/Player?path=' + f.path);
        }
        function loadTags(src) {
        if (typeof jsmediatags === 'undefined') return;
        fetch(src).then(r=>r.blob()).then(blob=>{
            jsmediatags.read(blob, {
            onSuccess: (tag) => {
                const t = tag.tags;
                const artistEl = document.getElementById('track-artist');
                const albumEl  = document.getElementById('track-album');
                if (t.artist && t.artist.trim() !== '') {
                artistEl.textContent = t.artist;
                artistEl.style.display = '';
                } else {
                artistEl.textContent = '';
                artistEl.style.display = 'none';
                }
                if (t.album && t.album.trim() !== '') {
                albumEl.textContent = t.album;
                albumEl.style.display = '';
                } else {
                albumEl.textContent = '';
                albumEl.style.display = 'none';
                }
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
                updateMediaSession ();
            }, onError:()=>{}
            });
        }).catch(()=>{});
        }
        function cycleRepeat() {
        repeatMode = (repeatMode + 1) %% 3;
        document.getElementById('ico-repeat-none').style.display = repeatMode===0?'':'none';
        document.getElementById('ico-repeat-all').style.display  = repeatMode===1?'':'none';
        document.getElementById('ico-repeat-one').style.display  = repeatMode===2?'':'none';
        updateNavBtns();
        }
        function resizeCanvas(){canvas.width=canvas.offsetWidth*devicePixelRatio;canvas.height=canvas.offsetHeight*devicePixelRatio;}
        resizeCanvas();window.addEventListener('resize',resizeCanvas);
        function fmt(s){
        s = Math.floor(s || 0);
        const h = Math.floor(s / 3600);
        const m = Math.floor((s % 3600) / 60);
        const sec = s % 60;
        return h > 0
            ? h + ':' + String(m).padStart(2,'0') + ':' + String(sec).padStart(2,'0')
            : m + ':' + String(sec).padStart(2,'0');
        }
        let audioCtx,analyser,source,gainNode;
        let eqFilters=[];
        let bassFilter,midFilter,trebleFilter;
        let dolbyConvolver,dolbyGain,dolbyEnabled=false,dolbyConnected=false;
        let connected=false;
        const BANDS = [60,170,350,1000,3500,10000,16000];
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
        const highpass = audioCtx.createBiquadFilter();
        highpass.type = "highpass";
        highpass.frequency.value = 80;
        const lowpass = audioCtx.createBiquadFilter();
        lowpass.type = "lowpass";
        lowpass.frequency.value = 12000;
        const compressor = audioCtx.createDynamicsCompressor();
        compressor.threshold.value = -18;
        compressor.knee.value = 20;
        compressor.ratio.value = 4;
        compressor.attack.value = 0.003;
        compressor.release.value = 0.25;
        gainNode.gain.value = 0.8;
        let prev = source;
        [...eqFilters, bassFilter, midFilter, trebleFilter].forEach(f => {
            prev.connect(f);
            prev = f;
        });
        prev.connect(highpass);
        prev = highpass;
        prev.connect(gainNode);
        prev = gainNode;
        prev.connect(lowpass);
        prev = lowpass;
        prev.connect(compressor);
        prev = compressor;
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
        (async()=>{
        try{
            await new Promise((res,rej)=>{const s=document.createElement('script');s.src='/JsMediaTags';s.onload=res;s.onerror=rej;document.head.appendChild(s);});
            loadTags(FILE_URL);
        }catch(e){console.log('jsmediatags',e);}
        })();
        function updatePlay(){
        const p=!aud.paused;
        icoPlay.style.display=p?'none':'';icoPause.style.display=p?'':'none';
        p?art.classList.add('playing'):art.classList.remove('playing');
        if(p&&audioCtx?.state==='suspended')audioCtx.resume();
        }
        aud.addEventListener('ended',()=>{
        if(repeatMode===2){ aud.currentTime=0;aud.play();return; }
        if(repeatMode===1){
            const next=(curIdx+1)%%playlist.length;
            playlist.length>0?playIdx(next):(() => {aud.currentTime=0;aud.play();})();return;
        }
        if(curIdx>=0&&curIdx<playlist.length-1) playIdx(curIdx+1);
        updatePlay();
        });
        aud.addEventListener('timeupdate',()=>{const pct=(aud.currentTime/aud.duration*100)||0;fill.style.width=pct+'%%';thumb.style.left=pct+'%%';curEl.textContent=fmt(aud.currentTime);});
        aud.addEventListener('durationchange',()=>{durEl.textContent=fmt(aud.duration);});
        aud.addEventListener('progress',()=>{if(aud.buffered.length)buf.style.width=(aud.buffered.end(aud.buffered.length-1)/aud.duration*100)+'%%';});
        aud.addEventListener('play',  () => { updatePlay(); navigator.mediaSession && (navigator.mediaSession.playbackState = 'playing'); });
        aud.addEventListener('pause', () => { updatePlay(); navigator.mediaSession && (navigator.mediaSession.playbackState = 'paused');  });
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
        const LRC_URL = '%s';
        let lrcLines = [];
        let lrcMode = 0;
        let lrcCurIdx = -1;
        async function loadLRC(url) {
        try {
            const resp = await fetch(url);
            if (!resp.ok) return;
            const text = await resp.text();
            const lines = [];
            text.split('\n').forEach(line => {
            const txt = line.replace(/\[\d+:\d+(?:[.:]\d+)?\]/g, '').trim();
            if (!txt) return;
            const tagRe = /\[(\d+):(\d+)(?:[.:](\d+))?\]/g;
            let m;
            while ((m = tagRe.exec(line)) !== null) {
                const min = parseInt(m[1]);
                const sec = parseInt(m[2]);
                let frac = 0;
                if (m[3]) {
                frac = m[3].length <= 2
                    ? parseInt(m[3]) / 100
                    : parseInt(m[3]) / 1000;
                }
                lines.push({ time: min * 60 + sec + frac, text: txt });
            }
            });
            lines.sort((a, b) => a.time - b.time);
            lrcLines = lines;
            if (lines.length > 0) {
            document.getElementById('lrc-wrap').style.display = '';
            renderScrollLRC(-1);
            }
        } catch(e) { console.log('LRC load err', e); }
        }
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
            const inner = document.getElementById('lrc-inner');
            const container = document.getElementById('lrc-scroll');
            const el = inner.querySelector(`[data-idx="${idx}"]`);
            if (!el) return;
            const offset = el.offsetTop - container.clientHeight / 2;
            inner.style.transform = `translateY(${-offset}px)`;
        }
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
            cur.offsetHeight;
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
        function toggleLrcMode() {
        lrcMode = lrcMode === 0 ? 1 : 0;
        const btn    = document.getElementById('lrc-toggle-btn');
        const scroll = document.getElementById('lrc-scroll');
        const kar    = document.getElementById('lrc-karaoke');
        if (lrcMode === 0) {
            btn.innerHTML = `
            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                <rect x="4" y="6" width="16" height="2"/>
                <rect x="4" y="11" width="16" height="2"/>
                <rect x="4" y="16" width="10" height="2"/>
            </svg>`;
            scroll.style.display = '';
            kar.style.display    = 'none';
            renderScrollLRC(lrcCurIdx);
        } else {
            btn.innerHTML = `
            <svg width="12" height="12" viewBox="0 0 24 24" fill="currentColor">
                <!-- Mic -->
                <path d="M12 14a3 3 0 0 0 3-3V6a3 3 0 1 0-6 0v5a3 3 0 0 0 3 3zm5-3a5 5 0 0 1-10 0H5a7 7 0 0 0 6 6.93V21h2v-3.07A7 7 0 0 0 19 11h-2z"/>
                <path d="M19 5v6.5a1.5 1.5 0 1 1-1-1.41V6h-2V5h3z"/>
            </svg>`;
            scroll.style.display = 'none';
            kar.style.display    = 'flex';
            updateKaraoke(lrcCurIdx);
        }
        }
        aud.addEventListener('timeupdate', () => {
        updatePositionState ();
        const pct = (aud.currentTime / aud.duration * 100) || 0;
        fill.style.width  = pct + '%%';
        thumb.style.left  = pct + '%%';
        curEl.textContent = fmt(aud.currentTime);
        syncLRC(aud.currentTime);
        if (crossfadeEnabled && !isCrossfading && !aud.paused &&
            aud.duration > 0 && isFinite(aud.duration)) {
            const rem = aud.duration - aud.currentTime;
            if (rem > 0 && rem <= crossfadeDuration) {
            triggerCrossfade();
            }
        }
        });
        loadLRC(LRC_URL);
        const _origPlayIdx = playIdx;
        window.playIdx = async function(idx) {
        _origPlayIdx(idx);
        if (!playlist[idx]) return;
        lrcLines = [];
        lrcCurIdx = -1;
        const wrap = document.getElementById('lrc-wrap');
        wrap.style.display = 'none';
        const inner = document.getElementById('lrc-inner');
        inner.innerHTML = '<div class="lrc-empty">Loading lyrics…</div>';
        const lrcUrl = '/Rawori?path=' + playlist[idx].path.replace(/\.[^.]+$/, '.lrc');
        await loadLRC(lrcUrl);
        if (lrcLines.length > 0) {
            syncLRC(aud.currentTime);
        }
        };
        const btnDownload = document.getElementById('btn-download');
        const ttlDownload = document.getElementById('title-download');
        function updateDownload(f) {
        if (!f) return;
        const url = '/Rawori?path=' + (f.path);
        btnDownload.href = url;
        btnDownload.download = f.name;
        ttlDownload.innerText = f.name;
        }
        let fpath = '';
        function playIdx(idx) {
        if (idx < 0 || idx >= playlist.length) return;
        curIdx = idx;
        const f = playlist[idx];
        updateDownload(f);
        fpath = f.path;
        const src = '/Rawori?path=' + f.path;
        artImg.style.display = 'none';
        artIcon.style.display = '';
        const bg = document.getElementById('bg-cover');
        bg.style.opacity = 0;
        aud.src = src;
        aud.load();
        aud.play();
        document.getElementById('track-title').textContent = f.name.replace(/\.[^.]+$/, '');
        artImg.style.display = 'none';
        artIcon.style.display = '';
        loadTags(src);
        updateNavBtns();
        history.replaceState(null, '', '/Player?path=' + f.path);
        updateMediaSession ();
        }
        let crossfadeEnabled = false;
        let crossfadeDuration = 25;
        let isCrossfading = false;
        let cfTimer = null;
        const audX = new Audio();
        audX.preload = 'auto';
        function toggleCrossfade() {
            crossfadeEnabled = !crossfadeEnabled;
            const btn = document.getElementById('cf-btn');
            const off = document.getElementById('ico-cf-off');
            const on  = document.getElementById('ico-cf-on');
            if (crossfadeEnabled) {
                off.style.display = 'none';
                on.style.display = '';
                btn.classList.add('active');
            } else {
                off.style.display = '';
                on.style.display = 'none';
                btn.classList.remove('active');
            }
        }
        function getCfNextIdx() {
        if (repeatMode === 2) return curIdx;
        if (playlist.length === 0) return -1;
        if (curIdx < playlist.length - 1) return curIdx + 1;
        if (repeatMode === 1) return 0;
        return -1;
        }
        function triggerCrossfade() {
        const nxt = getCfNextIdx();
        if (nxt < 0) return;
        isCrossfading = true;
        const f = playlist[nxt];
        audX.src = '/Rawori?path=' + f.path;
        audX.currentTime = 0;
        audX.volume = 0;
        audX.play().catch(() => {});
        const origVol = aud.volume || 1;
        const STEPS = 50;
        const ivMs = (crossfadeDuration * 1000) / STEPS;
        let step = 0;
        clearInterval(cfTimer);
        cfTimer = setInterval(() => {
            step++;
            const p = step / STEPS;
            aud.volume = Math.max(0, origVol * (1 - p));
            audX.volume = Math.min(origVol, origVol * p);
            if (step >= STEPS) {
            clearInterval(cfTimer);
            finalizeCrossfade(nxt, origVol);
            }
        }, ivMs);
        }
        function finalizeCrossfade(nxtIdx, origVol) {
        const f = playlist[nxtIdx];
        const src = '/Rawori?path=' + f.path;
        aud.src = src;
        aud.currentTime = audX.currentTime;
        aud.volume = origVol;
        aud.play().catch(() => {});
        audX.pause();
        audX.src = '';
        curIdx = nxtIdx;
        isCrossfading = false;
        document.getElementById('track-title').textContent = f.name.replace(/\.[^.]+$/, '');
        ['track-artist', 'track-album'].forEach(id => {
            const el = document.getElementById(id);
            el.style.display = 'none';
            el.textContent   = '';
        });
        artImg.style.display = 'none';
        artIcon.style.display = '';
        document.getElementById('bg-cover').style.opacity = 0;
        updateDownload(f);
        loadTags(src);
        updateMediaSession ();
        updateNavBtns();
        history.replaceState(null, '', '/Player?path=' + f.path);
        lrcLines  = [];
        lrcCurIdx = -1;
        document.getElementById('lrc-wrap').style.display = 'none';
        document.getElementById('lrc-inner').innerHTML = '<div class="lrc-empty">Loading lyrics…</div>';
        loadLRC('/Rawori?path=' + f.path.replace(/\.[^.]+$/, '.lrc'));
        }
        function updateMediaSession() {
        if (!('mediaSession' in navigator)) return;
        const f = playlist[curIdx];
        const title = f
            ? f.name.replace(/\.[^.]+$/, '')
            : document.getElementById('track-title').textContent;
        const artist = document.getElementById('track-artist').textContent || '';
        const album  = document.getElementById('track-album').textContent  || '';
        const artwork = [];
        if (artImg.src && artImg.style.display !== 'none') {
            artwork.push({ src: artImg.src, sizes: '512x512', type: 'image/jpeg' });
        }
        navigator.mediaSession.metadata = new MediaMetadata({
            title, artist, album,
            artwork: artwork.length ? artwork : [
            { src: 'data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg"/>', sizes: '1x1' }
            ]
        });
        navigator.mediaSession.setActionHandler('play',  () => { aud.play(); });
        navigator.mediaSession.setActionHandler('pause', () => { aud.pause(); });
        navigator.mediaSession.setActionHandler('stop',  () => { aud.pause(); aud.currentTime = 0; });
        navigator.mediaSession.setActionHandler('previoustrack', () => {
            initAudio();
            if (playlist.length > 0 && curIdx > 0) playIdx(curIdx - 1);
            else if (repeatMode === 1 && playlist.length > 0) playIdx(playlist.length - 1);
            else { aud.currentTime = 0; }
        });
        navigator.mediaSession.setActionHandler('nexttrack', () => {
            initAudio();
            if (playlist.length > 0 && curIdx < playlist.length - 1) playIdx(curIdx + 1);
            else if (repeatMode === 1 && playlist.length > 0) playIdx(0);
        });
        navigator.mediaSession.setActionHandler('seekbackward', (d) => {
            aud.currentTime = Math.max(0, aud.currentTime - (d.seekOffset ?? 10));
        });
        navigator.mediaSession.setActionHandler('seekforward', (d) => {
            aud.currentTime = Math.min(aud.duration, aud.currentTime + (d.seekOffset ?? 10));
        });
        navigator.mediaSession.setActionHandler('seekto', (d) => {
            if (d.seekTime != null) aud.currentTime = d.seekTime;
        });
        }
        function updatePositionState() {
        if (!('mediaSession' in navigator)) return;
        if (!aud.duration || !isFinite(aud.duration)) return;
        try {
            navigator.mediaSession.setPositionState({
            duration: aud.duration,
            playbackRate: aud.playbackRate,
            position: aud.currentTime,
            });
        } catch (_) {}
        }
        const PROXIES = [
        url => `https://api.allorigins.win/get?url=${encodeURIComponent(url)}`,
        url => `https://api.codetabs.com/v1/proxy?quest=${encodeURIComponent(url)}`,
        url => `https://thingproxy.freeboard.io/fetch/${url}`,
        ];
        async function lrcdlFetch(url, isJson = false) {
        try {
            const r = await fetch(url, { headers: { 'User-Agent': 'Mozilla/5.0' } });
            if (r.ok) return isJson ? r.json() : r.text();
        } catch (_) {}
        for (const proxyFn of PROXIES) {
            try {
            const r = await fetch(proxyFn(url));
            if (!r.ok) continue;
            const j = await r.json();
            const text = j.contents ?? j;
            if (typeof text === 'string') {
                return isJson ? JSON.parse(text) : text;
            }
            return isJson ? text : JSON.stringify(text);
            } catch (_) {}
        }
        throw new Error('All proxies failed for: ' + url);
        }
        const EngineLrclib = {
        async search(title, artist) {
            try {
            const params = new URLSearchParams({ track_name: title });
            if (artist) params.set('artist_name', artist);
            const d = await fetch(`https://lrclib.net/api/search?${params}`).then(r => r.json());
            if (!Array.isArray(d)) return [];
            return d.slice(0, 12).map(s => ({
                title:  s.trackName  || title,
                artist: s.artistName || artist,
                id:     String(s.id),
                engine: 'lrclib',
                hasSynced: !!s.syncedLyrics,
            }));
            } catch { return []; }
        },
        async download(id) {
            try {
            const d = await fetch(`https://lrclib.net/api/get/${id}`).then(r => r.json());
            return d.syncedLyrics || d.plainLyrics || null;
            } catch { return null; }
        }
        };
        const EngineNetease = {
        async search(title, artist) {
            try {
            const q = [title, artist].filter(Boolean).join(' ');
            const d = await lrcdlFetch(`http://music.163.com/api/search/get?s=${encodeURIComponent(q)}&type=1`, true);
            if (d.code !== 200 || !d.result?.songs) return [];
            return d.result.songs.slice(0, 8).map(s => ({
                title:  s.name,
                artist: s.artists?.[0]?.name || '',
                id:     String(s.id),
                engine: 'netease'
            }));
            } catch { return []; }
        },
        async download(id) {
            try {
            const d = await lrcdlFetch(`http://music.163.com/api/song/lyric?id=${id}&lv=-1&kv=-1&tv=-1`, true);
            return (d.code === 200 && d.lrc?.lyric) ? d.lrc.lyric : null;
            } catch { return null; }
        }
        };
        const EngineMegalobiz = {
        async search(title, artist) {
            try {
            const q = [title, artist].filter(Boolean).join(' ');
            const html = await lrcdlFetch(
                `https://www.megalobiz.com/search/all?qry=${encodeURIComponent(q)}`);
            const results = [];
            const re = /<a class="entity_name"[^>]*?name="(.*?)"[^>]*?href="(\/lrc\/maker\/[^"]+)"/g;
            let m;
            while ((m = re.exec(html)) !== null && results.length < 8) {
                const raw = m[1];
                let rtitle = title, rartist = raw;
                if (/\bby\b/i.test(raw)) {
                const p = raw.split(/\s+by\s+/i);
                rtitle = p[0].trim(); rartist = p[1]?.trim() || raw;
                }
                results.push({ title: rtitle, artist: rartist, id: m[2], engine: 'megalobiz' });
            }
            return results;
            } catch { return []; }
        },
        async download(path) {
            try {
            const html = await lrcdlFetch(`https://www.megalobiz.com${path}`);
            const m = /lyrics_details[\s\S]*?<span[^>]*>([\s\S]*?)<\/span>/.exec(html);
            if (!m) return null;
            return m[1].split('<br>').map(l => l.replace(/<[^>]+>/g, '').trim()).join('\n');
            } catch { return null; }
        }
        };
        const EngineS4Songs = {
        async search(title, artist) {
            try {
            const q = [title, artist].filter(Boolean).join(' ');
            const html = await lrcdlFetch(`https://www.rentanadviser.com/en/subtitles/subtitles4songs.aspx?q=${encodeURIComponent(q)}`);
            const results = [];
            const re = /href="getsubtitle\.aspx\?([^"]*artist=([^&"]+)[^"]*song=([^&"]+)[^"]*)"/gi;
            let m;
            while ((m = re.exec(html)) !== null && results.length < 8) {
                const full   = m[1];
                const rartist = decodeURIComponent(m[2].replace(/\+/g,' '));
                const rtitle  = decodeURIComponent(m[3].replace(/\+/g,' '));
                const dlUrl   = `https://www.rentanadviser.com/en/subtitles/getsubtitle.aspx?${full}&type=lrc`;
                if (!results.find(r => r.id === dlUrl))
                results.push({ title: rtitle, artist: rartist, id: dlUrl, engine: 's4songs' });
            }
            return results;
            } catch { return []; }
        },
        async download(url) {
            try {
            const html = await lrcdlFetch(url);
            const flat = html.replace(/[\r\n]/g,'');
            const m = /lbllyrics[^>]*>[^<]*<h3>[^<]*<\/h3>([\s\S]*?)<\/span>/.exec(flat);
            if (!m) return null;
            return m[1]
                .replace(/RentAnAdviser\.com/gi,'')
                .split('<br />')
                .map(l => l.replace(/<[^>]+>/g,'').trim())
                .join('\n');
            } catch { return null; }
        }
        };
        const LRCDL_ENGINES = {
        lrclib:    { obj: EngineLrclib,    name: 'LRCLib',    badge: 'badge-lrclib' },
        netease:   { obj: EngineNetease,   name: 'NetEase',   badge: 'badge-netease' },
        megalobiz: { obj: EngineMegalobiz, name: 'MegaLobiz', badge: 'badge-megalobiz' },
        s4songs:   { obj: EngineS4Songs,   name: 'S4Songs',   badge: 'badge-s4songs' },
        };
        let lrcdlEnginesOn = new Set(['lrclib', 'netease', 'megalobiz', 's4songs']);
        function lrcdlOpen() {
        const t = document.getElementById('track-title').textContent.trim();
        const a = document.getElementById('track-artist').textContent.trim();
        document.getElementById('lrcdl-title').value  = t;
        document.getElementById('lrcdl-artist').value = a;
        document.getElementById('lrcdl-overlay').classList.add('open');
        document.body.style.overflow = 'hidden';
        setTimeout(() => document.getElementById('lrcdl-title').focus(), 80);
        }
        function lrcdlClose() {
        document.getElementById('lrcdl-overlay').classList.remove('open');
        document.body.style.overflow = '';
        }
        function lrcdlBg(e) {
        if (e.target === document.getElementById('lrcdl-overlay')) lrcdlClose();
        }
        function toggleLrcdlEng(btn) {
        const eng = btn.dataset.eng;
        lrcdlEnginesOn.has(eng) ? lrcdlEnginesOn.delete(eng) : lrcdlEnginesOn.add(eng);
        btn.classList.toggle('on', lrcdlEnginesOn.has(eng));
        }
        async function lrcdlSearch() {
        const title  = document.getElementById('lrcdl-title').value.trim();
        const artist = document.getElementById('lrcdl-artist').value.trim();
        if (!title) return;
        if (!lrcdlEnginesOn.size) {
            document.getElementById('lrcdl-status').textContent = '⚠ Pilih minimal 1 engine!';
            return;
        }
        const statusEl  = document.getElementById('lrcdl-status');
        const resultsEl = document.getElementById('lrcdl-results');
        statusEl.innerHTML = '<span class="lrcdl-spinner"></span>Searching…';
        resultsEl.innerHTML = '';
        let total = 0;
        const promises = [...lrcdlEnginesOn].map(key => {
            const eng = LRCDL_ENGINES[key];
            return eng.obj.search(title, artist).then(list => {
            list.forEach(item => {
                total++;
                resultsEl.appendChild(lrcdlMakeItem(item));
            });
            statusEl.innerHTML = `<span class="lrcdl-spinner"></span>Found ${total} so far…`;
            }).catch(() => {});
        });
        await Promise.all(promises);
        if (total === 0) {
            resultsEl.innerHTML = '<div class="lrcdl-empty">😔 Tidak ada hasil.<br><span style="font-size:11px">Coba kata kunci lain atau aktifkan lebih banyak engine.</span></div>';
            statusEl.textContent = 'No results found.';
        } else {
            statusEl.textContent = `✓ ${total} result(s) found`;
        }
        }
        function lrcdlMakeItem(r) {
        const eng  = LRCDL_ENGINES[r.engine];
        const synced = r.hasSynced === false ? ' ⚠ plain' : '';
        const div  = document.createElement('div');
        div.className = 'lrcdl-item';
        div.innerHTML = `
            <div class="lrcdl-item-info">
            <div class="lrcdl-item-title">${_esc(r.title)}</div>
            <div class="lrcdl-item-artist">${_esc(r.artist) || '—'}</div>
            </div>
            <span class="lrcdl-badge ${eng.badge}">${eng.name}${synced}</span>
            <button class="lrcdl-apply" data-engine="${r.engine}" data-id="${_escAttr(r.id)}">Apply</button>
        `;
        div.querySelector('.lrcdl-apply').addEventListener('click', function() {
            lrcdlApply(this, r.engine, r.id);
        });
        return div;
        }
        async function lrcdlApply(btn, engineKey, id) {
        btn.textContent = '…';
        btn.disabled    = true;
        try {
            const lrcText = await LRCDL_ENGINES[engineKey].obj.download(id);
            if (!lrcText) {
            btn.textContent = '✗ Failed';
            setTimeout(() => { btn.textContent = 'Apply'; btn.disabled = false; }, 2000);
            return;
            }
            lrcLines  = [];
            lrcCurIdx = -1;
            const lines = [];
            lrcText.split('\n').forEach(line => {
            const txt = line.replace(/\[\d+:\d+(?:[.:]\d+)?\]/g, '').trim();
            if (!txt) return;
            const tagRe = /\[(\d+):(\d+)(?:[.:](\d+))?\]/g;
            let m;
            while ((m = tagRe.exec(line)) !== null) {
                const min = parseInt(m[1]), sec = parseInt(m[2]);
                let frac = m[3] ? (m[3].length <= 2 ? parseInt(m[3])/100 : parseInt(m[3])/1000) : 0;
                lines.push({ time: min*60 + sec + frac, text: txt });
            }
            });
            lines.sort((a,b) => a.time - b.time);
            lrcLines = lines;
            if (lrcLines.length > 0) {
            document.getElementById('lrc-wrap').style.display = '';
            renderScrollLRC(-1);
            syncLRC(aud.currentTime);
            }
            let fullPath = new URL(btnDownload.href).searchParams.get('path');
            if (!fullPath) return;
            let lrcPath = fullPath.replace(/\.[^/.]+$/, "") + ".lrc";
            await fetch('/Toserver', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    path: lrcPath,
                    lrc: lrcText
                })
            });
            btn.textContent = '✓ Applied!';
            setTimeout(() => lrcdlClose(), 900);
        } catch(e) {
            console.error(e);
            btn.textContent = '✗ Error';
            setTimeout(() => { btn.textContent = 'Apply'; btn.disabled = false; }, 2000);
        }
        }
        function _esc(s) {
        return String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
        }
        function _escAttr(s) { return String(s||'').replace(/'/g,'&apos;'); }
        document.addEventListener('keydown', e => {
        if (['INPUT','TEXTAREA'].includes(document.activeElement.tagName)) return;
        if (e.key === 'l' || e.key === 'L') lrcdlOpen();
        });
        </script>
        <div class="lrcdl-overlay" id="lrcdl-overlay" onclick="lrcdlBg(event)">
        <div class="lrcdl-card">
            <div class="lrcdl-header">
            <div class="lrcdl-title">🔍 Find Lyrics (.lrc)</div>
            <button class="lrcdl-close" onclick="lrcdlClose()">✕</button>
            </div>
            <!-- 2 input: title + artist -->
            <div class="lrcdl-searchrow">
            <input class="lrcdl-inp" id="lrcdl-title"  placeholder="Song title…"
                    onkeydown="if(event.key==='Enter')lrcdlSearch()" style="flex:1.4">
            <input class="lrcdl-inp" id="lrcdl-artist" placeholder="Artist (optional)…"
                    onkeydown="if(event.key==='Enter')lrcdlSearch()" style="flex:1">
            <button class="lrcdl-go" onclick="lrcdlSearch()">Search</button>
            </div>
            <div class="lrcdl-engines">
            <button class="lrcdl-eng-btn on" data-eng="lrclib"    onclick="toggleLrcdlEng(this)">⭐ LRCLib</button>
            <button class="lrcdl-eng-btn on" data-eng="netease"   onclick="toggleLrcdlEng(this)">🎵 NetEase</button>
            <button class="lrcdl-eng-btn on" data-eng="megalobiz" onclick="toggleLrcdlEng(this)">🌐 MegaLobiz</button>
            <button class="lrcdl-eng-btn on" data-eng="s4songs"   onclick="toggleLrcdlEng(this)">🎤 S4Songs</button>
            </div>
            <div class="lrcdl-status" id="lrcdl-status">Masukkan judul lagu lalu klik Search ↑</div>
            <div class="lrcdl-results" id="lrcdl-results">
            <div class="lrcdl-empty">🎶 Hasil pencarian muncul di sini<br>
                <span style="font-size:11px;color:rgba(255,255,255,0.12)">
                LRCLib · NetEase · MegaLobiz · Subtitles4Songs
                </span>
            </div>
            </div>
        </div>
        </div>
        </body>
        </html>""".printf (filename, filename, mime, encoded_path, mime, raw_src, lrc_src);
    }
}