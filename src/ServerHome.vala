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
    public string get_home () {
        return """<!DOCTYPE html>
        <html lang="en">
        <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Welcome to Gabut Akut</title>
        <style>
        *{margin:0;padding:0;box-sizing:border-box;}
        body{
        background:#0a0a0a;color:#fff;
        font-family:Inter,system-ui,sans-serif;
        min-height:100vh;display:flex;flex-direction:column;
        overflow-x:hidden;
        }
        /* ── Background glow ── */
        .bg-glow{
        position:fixed;inset:0;z-index:0;pointer-events:none;overflow:hidden;
        }
        .bg-glow::before{
        content:'';position:absolute;
        width:700px;height:700px;border-radius:50%;
        background:radial-gradient(circle,rgba(96,165,250,0.08) 0%,transparent 70%);
        top:-250px;left:-200px;
        animation:glowdrift1 14s ease-in-out infinite alternate;
        }
        .bg-glow::after{
        content:'';position:absolute;
        width:600px;height:600px;border-radius:50%;
        background:radial-gradient(circle,rgba(167,139,250,0.07) 0%,transparent 70%);
        bottom:-200px;right:-200px;
        animation:glowdrift2 16s ease-in-out infinite alternate;
        }
        @keyframes glowdrift1{
        from{transform:translate(0,0) scale(1);}
        to  {transform:translate(70px,50px) scale(1.2);}
        }
        @keyframes glowdrift2{
        from{transform:translate(0,0) scale(1);}
        to  {transform:translate(-60px,-70px) scale(1.15);}
        }

        /* ── Header ── */
        header{
        position:sticky;top:0;z-index:100;
        width:100%;
        background:rgba(10,10,10,0.85);
        backdrop-filter:blur(24px) saturate(1.8);
        -webkit-backdrop-filter:blur(24px) saturate(1.8);
        border-bottom:0.5px solid rgba(255,255,255,0.07);
        padding:0 24px;height:52px;
        display:flex;align-items:center;gap:12px;
        }
        .logo{
        text-decoration:none;font-size:17px;
        font-weight:800;color:#fff;letter-spacing:-0.5px;
        }
        .logo em{
        font-style:normal;
        background:linear-gradient(135deg,#fff 40%,rgba(255,255,255,0.45));
        -webkit-background-clip:text;-webkit-text-fill-color:transparent;
        background-clip:text;
        }
        .spacer{flex:1;}

        /* ── Hero ── */
        .hero{
        flex:1;display:flex;flex-direction:column;
        align-items:center;justify-content:center;
        padding:60px 24px 80px;
        position:relative;z-index:1;
        gap:16px;
        }
        .hero-badge{
        display:inline-flex;align-items:center;gap:6px;
        background:rgba(255,255,255,0.06);
        border:0.5px solid rgba(255,255,255,0.12);
        border-radius:999px;padding:5px 14px;
        font-size:11px;font-weight:500;
        color:rgba(255,255,255,0.5);letter-spacing:0.04em;
        animation:fadeUp 0.5s cubic-bezier(0.25,0.46,0.45,0.94) both;
        }
        .hero-badge span{
        width:6px;height:6px;border-radius:50%;
        background:#4ade80;
        box-shadow:0 0 6px #4ade80;
        flex-shrink:0;
        }
        .hero-title{
        font-size:clamp(36px,7vw,72px);
        font-weight:900;letter-spacing:-2px;
        text-align:center;line-height:1.05;
        animation:fadeUp 0.5s 0.1s cubic-bezier(0.25,0.46,0.45,0.94) both;
        }
        .hero-title em{
        font-style:normal;
        background:linear-gradient(135deg,#fff 30%,rgba(255,255,255,0.4));
        -webkit-background-clip:text;-webkit-text-fill-color:transparent;
        background-clip:text;
        }
        .hero-sub{
        font-size:15px;color:rgba(255,255,255,0.4);
        text-align:center;max-width:420px;line-height:1.7;
        animation:fadeUp 0.5s 0.18s cubic-bezier(0.25,0.46,0.45,0.94) both;
        }

        /* ── Cards ── */
        .cards{
        display:grid;
        grid-template-columns:repeat(auto-fit,minmax(260px,1fr));
        gap:16px;
        width:100%;max-width:860px;
        margin-top:16px;
        animation:fadeUp 0.5s 0.26s cubic-bezier(0.25,0.46,0.45,0.94) both;
        }
        .card{
        background:rgba(255,255,255,0.04);
        border:0.5px solid rgba(255,255,255,0.09);
        border-radius:20px;padding:24px;
        display:flex;flex-direction:column;gap:12px;
        backdrop-filter:blur(12px);-webkit-backdrop-filter:blur(12px);
        transition:background 0.2s,border-color 0.2s,transform 0.2s;
        cursor:default;
        }
        .card:hover{
        background:rgba(255,255,255,0.07);
        border-color:rgba(255,255,255,0.15);
        transform:translateY(-2px);
        }
        .card-icon{
        width:44px;height:44px;border-radius:14px;
        display:flex;align-items:center;justify-content:center;
        flex-shrink:0;
        }
        .card-icon svg{
        width:22px;height:22px;fill:none;
        stroke-width:1.6;stroke-linecap:round;stroke-linejoin:round;
        }
        .card-icon.blue  {background:rgba(96,165,250,0.15);}
        .card-icon.blue svg{stroke:#60a5fa;}
        .card-icon.green {background:rgba(52,211,153,0.12);}
        .card-icon.green svg{stroke:#34d399;}
        .card-icon.purple{background:rgba(167,139,250,0.12);}
        .card-icon.purple svg{stroke:#a78bfa;}
        .card-title{font-size:15px;font-weight:600;color:#fff;}
        .card-desc{font-size:13px;color:rgba(255,255,255,0.4);line-height:1.6;flex:1;}
        .card-btn{
        display:inline-flex;align-items:center;gap:6px;
        background:rgba(255,255,255,0.08);
        border:0.5px solid rgba(255,255,255,0.12);
        border-radius:999px;padding:8px 18px;
        color:#fff;font-size:13px;font-weight:500;
        text-decoration:none;align-self:flex-start;
        transition:background 0.15s,transform 0.1s;
        margin-top:4px;
        }
        .card-btn:hover{background:rgba(255,255,255,0.16);}
        .card-btn:active{transform:scale(0.97);}
        .card-btn svg{
        width:13px;height:13px;stroke:#fff;fill:none;
        stroke-width:2;stroke-linecap:round;stroke-linejoin:round;
        }
        .card-btns{display:flex;gap:8px;flex-wrap:wrap;margin-top:4px;}

        /* ── Animations ── */
        @keyframes fadeUp{
        from{opacity:0;transform:translateY(18px);}
        to  {opacity:1;transform:translateY(0);}
        }
        </style>
        </head>
        <body>
        <div class="bg-glow"></div>
        <header>
        <a class="logo" href="/"><em>G</em>ABUT</a>
        <div class="spacer"></div>
        </header>

        <div class="hero">
        <div class="hero-badge"><span></span> Running</div>
        <h1 class="hero-title"><em>Gabut</em> Akut</h1>
        <p class="hero-sub">Gabut Download manager &amp; file transfer solution with a simple and modern interface.</p>

        <div class="cards">
            <!-- Download Manager -->
            <div class="card">
            <div class="card-icon blue">
                <svg viewBox="0 0 22 22">
                <polyline points="8,12 11,15 14,12"/>
                <line x1="11" y1="4" x2="11" y2="15"/>
                <path d="M4 17h14"/>
                <rect x="2" y="2" width="18" height="18" rx="4" stroke-opacity="0.3"/>
                </svg>
            </div>
            <div class="card-title">Download Manager</div>
            <div class="card-desc">Multi-protocol downloads, Torrent support, HLS/M3U8 support.</div>
            <a href="/Downloading" class="card-btn">
                Open Manager
                <svg viewBox="0 0 13 13"><polyline points="4,2 10,6.5 4,11"/></svg>
            </a>
            </div>

            <!-- File Transfer -->
            <div class="card">
            <div class="card-icon green">
                <svg viewBox="0 0 22 22">
                <polyline points="8,9 11,6 14,9"/>
                <line x1="11" y1="6" x2="11" y2="16"/>
                <path d="M5 19h12"/>
                <rect x="2" y="2" width="18" height="18" rx="4" stroke-opacity="0.3"/>
                </svg>
            </div>
            <div class="card-title">File Transfer</div>
            <div class="card-desc">Send files from your smartphone or another PC to this machine quickly and easily.</div>
            <a href="/Upload" class="card-btn">
                Send Files
                <svg viewBox="0 0 13 13"><polyline points="4,2 10,6.5 4,11"/></svg>
            </a>
            </div>

            <!-- File Sharing -->
            <div class="card">
            <div class="card-icon purple">
                <svg viewBox="0 0 22 22">
                <path d="M3 7h16M3 11h10M3 15h7"/>
                <rect x="2" y="2" width="18" height="18" rx="4" stroke-opacity="0.3"/>
                </svg>
            </div>
            <div class="card-title">File Sharing</div>
            <div class="card-desc">Browse and share files stored on this machine. Access folders and download directly from any device.</div>
            <a href="/Home" class="card-btn">
                Browse Files
                <svg viewBox="0 0 13 13"><polyline points="4,2 10,6.5 4,11"/></svg>
            </a>
            </div>
        </div>
        </div>
        </body>
        </html>""";
    }
}