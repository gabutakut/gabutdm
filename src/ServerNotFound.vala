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
    public string get_not_found () {
        return """<!DOCTYPE html>
        <html lang="en">
        <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Not Found</title>
        <style>
        *{margin:0;padding:0;box-sizing:border-box;}
        body{
        background:#0a0a0a;color:#fff;
        font-family:Inter,system-ui,sans-serif;
        min-height:100vh;display:flex;flex-direction:column;
        overflow:hidden;
        }
        header{
        width:100%;background:#111;padding:12px 20px;
        display:flex;align-items:center;gap:10px;
        border-bottom:1px solid #222;flex-shrink:0;
        }
        header a{text-decoration:none;}
        .logo{font-size:17px;font-weight:800;color:#fff;letter-spacing:-0.5px;}
        .logo em{
        font-style:normal;
        background:linear-gradient(135deg,#fff 40%,rgba(255,255,255,0.45));
        -webkit-background-clip:text;-webkit-text-fill-color:transparent;
        background-clip:text;
        }
        .page{
        flex:1;display:flex;flex-direction:column;
        align-items:center;justify-content:center;
        padding:40px 20px;gap:32px;
        position:relative;
        }
        .err-number{
        display:flex;align-items:center;justify-content:center;
        gap:8px;line-height:1;
        font-size:clamp(100px,22vw,200px);
        font-weight:900;letter-spacing:-8px;
        user-select:none;
        }
        .n4-left{
        color:#D1F2A5;
        animation:colorA 4s infinite;
        text-shadow:0 0 80px rgba(209,242,165,0.25);
        }
        .n4-right{
        color:#F56991;
        animation:colorB 4s infinite;
        text-shadow:0 0 80px rgba(245,105,145,0.25);
        }
        .circle{
        width:clamp(80px,14vw,130px);
        height:clamp(80px,14vw,130px);
        border-radius:50%;
        position:relative;
        flex-shrink:0;
        animation:spin 8s linear infinite;
        }
        .circle::before,.circle::after{
        content:'';
        position:absolute;inset:0;
        border-radius:50%;
        animation:shadowsdancing 4s infinite;
        }
        .circle::before{transform:rotate(45deg);}
        .err-msg{
        display:flex;flex-direction:column;align-items:center;gap:10px;
        text-align:center;max-width:420px;
        }
        .err-title{
        font-size:20px;font-weight:600;color:#fff;
        }
        .err-sub{
        font-size:14px;color:rgba(255,255,255,0.4);line-height:1.6;
        }
        .btn-back{
        display:inline-flex;align-items:center;gap:8px;
        background:rgba(255,255,255,0.08);
        border:0.5px solid rgba(255,255,255,0.15);
        border-radius:999px;padding:10px 22px;
        color:#fff;font-size:13px;font-weight:500;
        text-decoration:none;
        transition:background 0.15s,transform 0.1s;
        box-shadow:0 0 0 1px rgba(0,0,0,0.2),0 4px 16px rgba(0,0,0,0.3);
        }
        .btn-back:hover{background:rgba(255,255,255,0.15);}
        .btn-back:active{transform:scale(0.97);}
        .btn-back svg{
        width:14px;height:14px;stroke:#fff;fill:none;
        stroke-width:2;stroke-linecap:round;stroke-linejoin:round;
        }
        .glow{
        position:absolute;
        border-radius:50%;
        filter:blur(80px);
        pointer-events:none;
        opacity:0.12;
        animation:glowpulse 6s ease-in-out infinite alternate;
        }
        .glow-a{
        width:400px;height:400px;
        background:#D1F2A5;
        top:-100px;left:-100px;
        }
        .glow-b{
        width:350px;height:350px;
        background:#F56991;
        bottom:-80px;right:-80px;
        animation-delay:2s;
        }
        @keyframes colorA{
        0%  {color:#D1F2A5;}
        25% {color:#F56991;}
        50% {color:#FFC48C;}
        75% {color:#EFFAB4;}
        100%{color:#D1F2A5;}
        }
        @keyframes colorB{
        0%  {color:#FFC48C;}
        25% {color:#EFFAB4;}
        50% {color:#D1F2A5;}
        75% {color:#F56991;}
        100%{color:#FFC48C;}
        }
        @keyframes shadowsdancing{
        0%  {box-shadow:inset 30px 0 0 rgba(209,242,165,0.5),inset 0 30px 0 rgba(239,250,180,0.5),inset -30px 0 0 rgba(255,196,140,0.5),inset 0 -30px 0 rgba(245,105,145,0.5);}
        25% {box-shadow:inset 30px 0 0 rgba(245,105,145,0.5),inset 0 30px 0 rgba(209,242,165,0.5),inset -30px 0 0 rgba(239,250,180,0.5),inset 0 -30px 0 rgba(255,196,140,0.5);}
        50% {box-shadow:inset 30px 0 0 rgba(255,196,140,0.5),inset 0 30px 0 rgba(245,105,145,0.5),inset -30px 0 0 rgba(209,242,165,0.5),inset 0 -30px 0 rgba(239,250,180,0.5);}
        75% {box-shadow:inset 30px 0 0 rgba(239,250,180,0.5),inset 0 30px 0 rgba(255,196,140,0.5),inset -30px 0 0 rgba(245,105,145,0.5),inset 0 -30px 0 rgba(209,242,165,0.5);}
        100%{box-shadow:inset 30px 0 0 rgba(209,242,165,0.5),inset 0 30px 0 rgba(239,250,180,0.5),inset -30px 0 0 rgba(255,196,140,0.5),inset 0 -30px 0 rgba(245,105,145,0.5);}
        }
        @keyframes spin{
        from{transform:rotate(0deg);}
        to  {transform:rotate(360deg);}
        }
        @keyframes glowpulse{
        from{opacity:0.08;transform:scale(1);}
        to  {opacity:0.18;transform:scale(1.15);}
        }
        @keyframes fadeUp{
        from{opacity:0;transform:translateY(20px);}
        to  {opacity:1;transform:translateY(0);}
        }
        .err-number{animation:fadeUp 0.5s cubic-bezier(0.25,0.46,0.45,0.94) both;}
        .err-msg   {animation:fadeUp 0.5s 0.15s cubic-bezier(0.25,0.46,0.45,0.94) both;}
        .btn-back  {animation:fadeUp 0.5s 0.28s cubic-bezier(0.25,0.46,0.45,0.94) both;}
        </style>
        </head>
        <body>
        <header>
        <a href="/Home"><span class="logo"><em>G</em>ABUT</span></a>
        </header>
        <div class="page">
        <!-- background glow -->
        <div class="glow glow-a"></div>
        <div class="glow glow-b"></div>
        <!-- 404 -->
        <div class="err-number">
            <span class="n4-left">4</span>
            <div class="circle"></div>
            <span class="n4-right">4</span>
        </div>
        <!-- message -->
        <div class="err-msg">
            <div class="err-title">Page not found</div>
            <div class="err-sub">The page you are looking for doesn't exist or sharing is currently disabled.</div>
        </div>
        <!-- back button -->
        <a href="/" class="btn-back">
            <svg viewBox="0 0 14 14"><polyline points="9,2 4,7 9,12"/></svg>
            Back to Home
        </a>
        </div>
        </body>
        </html>""";
    }
}