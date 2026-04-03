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
    public string get_home (string? username, bool registed) {
        string auth_button;
        if (registed) {
            auth_button = """
            <a class="drop-item" href="/logout">
                <svg viewBox="0 0 22 22">
                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
                <polyline points="16,17 21,12 16,7"/>
                <line x1="21" y1="12" x2="9" y2="12"/>
                </svg>
                Log Out
            </a>
            """;
        } else {
            username = _("Guest");
            auth_button = """
            <a class="drop-item" href="/login">
                <svg viewBox="0 0 22 22">
                <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/>
                <polyline points="10,17 15,12 10,7"/>
                <line x1="15" y1="12" x2="3" y2="12"/>
                </svg>
                Login
            </a>
            """;
        }
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
        .bg-glow{position:fixed;inset:0;z-index:0;pointer-events:none;overflow:hidden;}
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
        header{
        position:sticky;top:0;z-index:100;width:100%;
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
        .user-wrap{position:relative;}
        .user-btn{
        display:flex;align-items:center;gap:8px;
        background:rgba(255,255,255,0.06);
        border:0.5px solid rgba(255,255,255,0.12);
        border-radius:999px;padding:5px 12px 5px 6px;
        cursor:pointer;color:#fff;
        font-size:13px;font-weight:500;
        transition:background 0.15s;
        user-select:none;
        }
        .user-btn:hover{background:rgba(255,255,255,0.10);}
        .user-avatar{
        width:28px;height:28px;border-radius:50%;
        background:rgba(96,165,250,0.18);
        border:0.5px solid rgba(96,165,250,0.3);
        display:flex;align-items:center;justify-content:center;
        flex-shrink:0;
        }
        .user-avatar svg{
        width:15px;height:15px;fill:none;stroke:#60a5fa;
        stroke-width:1.7;stroke-linecap:round;stroke-linejoin:round;
        }
        .user-name{
        max-width:120px;overflow:hidden;
        text-overflow:ellipsis;white-space:nowrap;
        color:rgba(255,255,255,0.8);
        }
        .chevron{
        width:12px;height:12px;fill:none;stroke:rgba(255,255,255,0.4);
        stroke-width:2;stroke-linecap:round;stroke-linejoin:round;
        transition:transform 0.2s;
        }
        .dropdown{
        display:none;
        position:absolute;top:calc(100% + 8px);right:0;
        background:rgba(18,18,18,0.95);
        border:0.5px solid rgba(255,255,255,0.10);
        border-radius:14px;padding:6px;
        min-width:180px;
        backdrop-filter:blur(20px);
        -webkit-backdrop-filter:blur(20px);
        box-shadow:0 16px 40px rgba(0,0,0,0.5);
        animation:dropIn 0.15s cubic-bezier(0.25,0.46,0.45,0.94) both;
        }
        @keyframes dropIn{
        from{opacity:0;transform:translateY(-6px);}
        to  {opacity:1;transform:translateY(0);}
        }
        .dropdown.open{display:block;}
        .drop-info{
        padding:8px 12px 10px;
        border-bottom:0.5px solid rgba(255,255,255,0.07);
        margin-bottom:4px;
        }
        .drop-info-label{
        font-size:11px;color:rgba(255,255,255,0.3);
        letter-spacing:0.04em;margin-bottom:2px;
        }
        .drop-info-name{
        font-size:13px;font-weight:600;color:#fff;
        }
        .drop-item{
        display:flex;align-items:center;gap:10px;
        padding:9px 12px;border-radius:9px;
        color:rgba(255,255,255,0.65);font-size:13px;
        text-decoration:none;
        transition:background 0.12s,color 0.12s;
        cursor:pointer;
        }
        .drop-item:hover{
        background:rgba(239,68,68,0.12);color:#fca5a5;
        }
        .drop-item svg{
        width:14px;height:14px;fill:none;
        stroke:currentColor;stroke-width:1.8;
        stroke-linecap:round;stroke-linejoin:round;
        flex-shrink:0;
        }
        .hero{
        flex:1;display:flex;flex-direction:column;
        align-items:center;justify-content:center;
        padding:60px 24px 80px;
        position:relative;z-index:1;gap:16px;
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
        background:#4ade80;box-shadow:0 0 6px #4ade80;flex-shrink:0;
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
        .cards{
        display:grid;
        grid-template-columns:repeat(auto-fit,minmax(260px,1fr));
        gap:16px;width:100%;max-width:860px;margin-top:16px;
        animation:fadeUp 0.5s 0.26s cubic-bezier(0.25,0.46,0.45,0.94) both;
        }
        .card{
        background:rgba(255,255,255,0.04);
        border:0.5px solid rgba(255,255,255,0.09);
        border-radius:20px;padding:24px;
        display:flex;flex-direction:column;gap:12px;
        backdrop-filter:blur(12px);-webkit-backdrop-filter:blur(12px);
        transition:background 0.2s,border-color 0.2s,transform 0.2s;cursor:default;
        }
        .card:hover{
        background:rgba(255,255,255,0.07);
        border-color:rgba(255,255,255,0.15);
        transform:translateY(-2px);
        }
        .card-icon{
        width:44px;height:44px;border-radius:14px;
        display:flex;align-items:center;justify-content:center;flex-shrink:0;
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
        transition:background 0.15s,transform 0.1s;margin-top:4px;
        }
        .card-btn:hover{background:rgba(255,255,255,0.16);}
        .card-btn:active{transform:scale(0.97);}
        .card-btn svg{
        width:13px;height:13px;stroke:#fff;fill:none;
        stroke-width:2;stroke-linecap:round;stroke-linejoin:round;
        }
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
        <!-- User menu -->
        <div class="user-wrap" id="userWrap">
            <div class="user-btn" id="userBtn">
            <div class="user-avatar">
                <svg viewBox="0 0 22 22">
                <circle cx="11" cy="8" r="4"/>
                <path d="M3 20c0-4 3.6-7 8-7s8 3 8 7"/>
                </svg>
            </div>
            <span class="user-name" id="userName">""" + username + """</span>
            <svg class="chevron" id="chevron" viewBox="0 0 12 12">
                <polyline points="2,4 6,8 10,4"/>
            </svg>
            </div>
            <div class="dropdown" id="dropdown">
                <div class="drop-info">
                    <div class="drop-info-label">Account</div>
                    <div class="drop-info-name">""" + username + """</div>
                </div>
                """ + auth_button + """
            </div>
        </div>
        </header>
        <div class="hero">
        <div class="hero-badge"><span></span> Running</div>
        <h1 class="hero-title"><em>Gabut</em> Akut</h1>
        <p class="hero-sub">Gabut Download manager &amp; file transfer solution with a simple and modern interface.</p>
        <div class="cards">
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
        <script>
        var btn = document.getElementById('userBtn');
        var dd  = document.getElementById('dropdown');
        var chv = document.getElementById('chevron');
        btn.addEventListener('click', function(e){
        e.stopPropagation();
        var open = dd.classList.toggle('open');
        chv.style.transform = open ? 'rotate(180deg)' : 'rotate(0deg)';
        });
        document.addEventListener('click', function(){
        dd.classList.remove('open');
        chv.style.transform = 'rotate(0deg)';
        });
        </script>
        </body>
        </html>""";
    }
}