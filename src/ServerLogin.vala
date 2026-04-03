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
    public string get_login_page (string error_msg) {
        string err_block = "";
        if (error_msg != "") {
            err_block = "<div style=\"background:rgba(239,68,68,0.12);border:0.5px solid rgba(239,68,68,0.25);
            color:#fca5a5;border-radius:10px;padding:10px 14px;font-size:13px;margin-top:14px;\">" + error_msg + "</div>";
        }
        return """<!DOCTYPE html>
        <html lang="id">
        <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <title>Login — Gabut Akut</title>
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
        display:flex;align-items:center;
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
        .wrap{
        flex:1;display:flex;align-items:center;
        justify-content:center;padding:40px 24px;
        position:relative;z-index:1;
        }
        .card{
        background:rgba(255,255,255,0.04);
        border:0.5px solid rgba(255,255,255,0.10);
        border-radius:20px;padding:2rem;
        width:100%;max-width:360px;
        backdrop-filter:blur(12px);
        -webkit-backdrop-filter:blur(12px);
        animation:fadeUp 0.45s cubic-bezier(0.25,0.46,0.45,0.94) both;
        }
        @keyframes fadeUp{
        from{opacity:0;transform:translateY(18px);}
        to  {opacity:1;transform:translateY(0);}
        }
        .card-icon{
        width:52px;height:52px;border-radius:16px;
        background:rgba(96,165,250,0.12);
        border:0.5px solid rgba(96,165,250,0.25);
        display:flex;align-items:center;justify-content:center;
        margin:0 auto 16px;
        }
        .card-icon svg{
        width:24px;height:24px;fill:none;stroke:#60a5fa;
        stroke-width:1.6;stroke-linecap:round;stroke-linejoin:round;
        }
        h1{
        font-size:18px;font-weight:700;text-align:center;
        color:#fff;letter-spacing:-0.3px;margin-bottom:4px;
        }
        .sub{
        font-size:13px;color:rgba(255,255,255,0.4);
        text-align:center;margin-bottom:1.5rem;
        }
        label{
        font-size:12px;color:rgba(255,255,255,0.5);
        display:block;margin-bottom:6px;letter-spacing:0.03em;
        }
        input[type=text],input[type=password]{
        width:100%;padding:10px 14px;
        background:rgba(255,255,255,0.05);
        border:0.5px solid rgba(255,255,255,0.12);
        border-radius:10px;font-size:14px;
        color:#fff;margin-bottom:14px;
        transition:border-color 0.15s,background 0.15s;
        }
        input[type=text]:focus,input[type=password]:focus{
        outline:none;
        border-color:rgba(96,165,250,0.5);
        background:rgba(255,255,255,0.07);
        }
        input::placeholder{color:rgba(255,255,255,0.2);}
        button{
        width:100%;padding:11px;
        background:rgba(96,165,250,0.18);
        border:0.5px solid rgba(96,165,250,0.35);
        border-radius:10px;color:#93c5fd;
        font-size:14px;font-weight:600;cursor:pointer;
        transition:background 0.15s,transform 0.1s;
        letter-spacing:0.01em;
        }
        button:hover{background:rgba(96,165,250,0.28);}
        button:active{transform:scale(0.98);}
        .badge{
        margin-top:1rem;padding:9px 12px;
        background:rgba(255,255,255,0.03);
        border:0.5px solid rgba(255,255,255,0.08);
        border-radius:10px;font-size:12px;
        color:rgba(255,255,255,0.3);
        }
        code{color:rgba(167,139,250,0.8);font-size:11px;}
        </style>
        </head>
        <body>
        <div class="bg-glow"></div>
        <header>
        <a class="logo" href="/"><em>G</em>ABUT</a>
        </header>
        <div class="wrap">
        <div class="card">
            <div class="card-icon">
            <svg viewBox="0 0 22 22">
                <rect x="3" y="10" width="16" height="11" rx="3"/>
                <path d="M7 10V7a5 5 0 0 1 10 0v3"/>
            </svg>
            </div>
            <h1>Gabut Download Manager</h1>
            <p class="sub">Log in to continue</p>
            <form action="/login" method="POST">
            <label for="u"></label>
            <input id="u" type="text" name="username"
                    placeholder="Username"
                    autocomplete="Username" required>
            <label for="p"></label>
            <input id="p" type="password" name="password"
                    placeholder="Password"
                    autocomplete="current-password" required>
            <button type="submit">Login</button>
            </form>
            """ + err_block + """
            <div class="badge">
            Go to Setting for Autentication User and Pass
            </div>
        </div>
        </div>
        </body>
        </html>""";
    }
}