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
    public string get_share (string path, string share, string opcl, string username) {
        if (path == "/") {
            path = "/Home";
        }
        string head = """<!DOCTYPE html>
        <html lang="en">
        <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>File Sharing</title>
        <style>
        *{margin:0;padding:0;box-sizing:border-box;}
        body{
        background:#0a0a0a;color:#fff;
        font-family:Inter,system-ui,sans-serif;
        min-height:100vh;display:flex;flex-direction:column;
        font-size:14px;line-height:1.5;
        overflow-x:hidden;
        }
        .bg-glow{
        position:fixed;inset:0;z-index:0;
        pointer-events:none;overflow:hidden;
        }
        .bg-glow::before{
        content:'';position:absolute;
        width:600px;height:600px;border-radius:50%;
        background:radial-gradient(circle,rgba(96,165,250,0.07) 0%,transparent 70%);
        top:-200px;left:-200px;
        animation:glowdrift1 12s ease-in-out infinite alternate;
        }
        .bg-glow::after{
        content:'';position:absolute;
        width:500px;height:500px;border-radius:50%;
        background:radial-gradient(circle,rgba(167,139,250,0.06) 0%,transparent 70%);
        bottom:-150px;right:-150px;
        animation:glowdrift2 14s ease-in-out infinite alternate;
        }
        @keyframes glowdrift1{
        from{transform:translate(0,0) scale(1);}
        to  {transform:translate(60px,40px) scale(1.15);}
        }
        @keyframes glowdrift2{
        from{transform:translate(0,0) scale(1);}
        to  {transform:translate(-50px,-60px) scale(1.2);}
        }
        header{
        position:sticky;top:0;z-index:100;
        width:100%;
        background:rgba(10,10,10,0.85);
        backdrop-filter:blur(24px) saturate(1.8);
        -webkit-backdrop-filter:blur(24px) saturate(1.8);
        border-bottom:0.5px solid rgba(255,255,255,0.07);
        padding:0 20px;height:52px;
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
        .icon-btn{
        width:34px;height:34px;border-radius:10px;
        background:rgba(255,255,255,0.06);
        border:0.5px solid rgba(255,255,255,0.1);
        color:#fff;display:grid;place-items:center;
        cursor:pointer;transition:all 0.15s;flex-shrink:0;
        }
        .icon-btn:hover{background:rgba(255,255,255,0.12);border-color:rgba(255,255,255,0.2);}
        .icon-btn:active{transform:scale(0.92);}
        .icon-btn svg{width:16px;height:16px;stroke:#bbb;fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round;}
        .main{flex:1;padding:0 20px 20px;max-width:1280px;width:100%;margin:0 auto;position:relative;z-index:1;}
        .col-header{
        display:grid;
        grid-template-columns:40px 1fr 110px 100px 170px;
        align-items:center;
        padding:0 12px;height:34px;
        background:rgba(255,255,255,0.03);
        border-bottom:0.5px solid rgba(255,255,255,0.07);
        position:sticky;top:52px;z-index:10;
        backdrop-filter:blur(8px);
        -webkit-backdrop-filter:blur(8px);
        }
        .col-header span{
        font-size:11px;font-weight:600;
        color:rgba(255,255,255,0.3);
        text-transform:uppercase;letter-spacing:0.06em;
        }
        .col-header .ch-type,
        .col-header .ch-size,
        .col-header .ch-date{text-align:right;}
        .append > header{
        display:flex;align-items:center;flex-wrap:wrap;
        gap:2px;padding:14px 0 10px;
        background:transparent;border:none;
        position:static;height:auto;
        backdrop-filter:none;-webkit-backdrop-filter:none;
        }
        a.shortfd{
        font-size:13px;color:rgba(255,255,255,0.45);
        text-decoration:none;padding:3px 6px;border-radius:6px;
        transition:color 0.15s,background 0.15s;white-space:nowrap;
        }
        a.shortfd:hover{color:#fff;background:rgba(255,255,255,0.08);}
        a.icon.myhome{
        display:inline-flex;align-items:center;justify-content:center;
        width:26px;height:26px;border-radius:7px;
        background:rgba(255,255,255,0.07);
        text-decoration:none;margin-right:2px;transition:background 0.15s;
        }
        a.icon.myhome:hover{background:rgba(255,255,255,0.13);}
        a.icon.myhome::before{
        content:'';display:block;width:14px;height:14px;
        background:rgba(255,255,255,0.6);
        mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M2 6.5L8 2l6 4.5V14a1 1 0 01-1 1H3a1 1 0 01-1-1z'/%3E%3C/svg%3E");
        -webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M2 6.5L8 2l6 4.5V14a1 1 0 01-1 1H3a1 1 0 01-1-1z'/%3E%3C/svg%3E");
        mask-size:contain;mask-repeat:no-repeat;mask-position:center;
        -webkit-mask-size:contain;-webkit-mask-repeat:no-repeat;-webkit-mask-position:center;
        }
        .append{
        background:rgba(255,255,255,0.02);
        border:0.5px solid rgba(255,255,255,0.08);
        border-radius:16px;overflow:hidden;margin-bottom:12px;
        }
        .item{
        display:grid;
        grid-template-columns:40px 1fr 110px 100px 170px;
        align-items:center;
        padding:0 12px;height:46px;
        border-bottom:0.5px solid rgba(255,255,255,0.05);
        transition:background 0.1s;
        }
        .item:last-child{border-bottom:none;}
        .item:hover{background:rgba(255,255,255,0.05);}
        .item:active{background:rgba(255,255,255,0.08);}
        a.icon{
        display:flex;align-items:center;justify-content:center;
        width:28px;height:28px;border-radius:7px;
        text-decoration:none;flex-shrink:0;font-size:0;
        }
        a.icon::before{
        content:'';display:block;width:16px;height:16px;
        mask-size:contain;mask-repeat:no-repeat;mask-position:center;
        -webkit-mask-size:contain;-webkit-mask-repeat:no-repeat;-webkit-mask-position:center;
        }
        a.icon.folder{background:rgba(96,165,250,0.15);}
        a.icon.folder::before{background:#60a5fa;mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M1 3.5A1.5 1.5 0 012.5 2h3.086a1.5 1.5 0 011.06.44l.915.914A1.5 1.5 0 008.62 4H13.5A1.5 1.5 0 0115 5.5v7A1.5 1.5 0 0113.5 14h-11A1.5 1.5 0 011 12.5z'/%3E%3C/svg%3E");-webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M1 3.5A1.5 1.5 0 012.5 2h3.086a1.5 1.5 0 011.06.44l.915.914A1.5 1.5 0 008.62 4H13.5A1.5 1.5 0 0115 5.5v7A1.5 1.5 0 0113.5 14h-11A1.5 1.5 0 011 12.5z'/%3E%3C/svg%3E");}
        a.icon.up{background:rgba(255,255,255,0.06);}
        a.icon.up::before{background:rgba(255,255,255,0.4);mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='none'%3E%3Cpath d='M8 13V3M4 7l4-4 4 4' stroke='white' stroke-width='1.5' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E");-webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='none'%3E%3Cpath d='M8 13V3M4 7l4-4 4 4' stroke='white' stroke-width='1.5' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E");}
        a.icon.image{background:rgba(52,211,153,0.12);}
        a.icon.image::before{background:#34d399;mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Crect x='1' y='1' width='14' height='14' rx='2' fill='none' stroke='%23000' stroke-width='1.2'/%3E%3Ccircle cx='5.5' cy='5.5' r='1.5'/%3E%3Cpath d='M1 11l4-4 3 3 2-2 4 4'/%3E%3C/svg%3E");-webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Crect x='1' y='1' width='14' height='14' rx='2' fill='none' stroke='%23000' stroke-width='1.2'/%3E%3Ccircle cx='5.5' cy='5.5' r='1.5'/%3E%3Cpath d='M1 11l4-4 3 3 2-2 4 4'/%3E%3C/svg%3E");}
        a.icon.video{background:rgba(251,146,60,0.12);}
        a.icon.video::before{background:#fb923c;mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Crect x='1' y='3' width='10' height='10' rx='1.5'/%3E%3Cpath d='M11 6l4-2v8l-4-2z'/%3E%3C/svg%3E");-webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Crect x='1' y='3' width='10' height='10' rx='1.5'/%3E%3Cpath d='M11 6l4-2v8l-4-2z'/%3E%3C/svg%3E");}
        a.icon.audio{background:rgba(167,139,250,0.12);}
        a.icon.audio::before{background:#a78bfa;mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M6 2l6 2v3l-6-2v6a2 2 0 11-1.5-1.94V4.5z'/%3E%3C/svg%3E");-webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M6 2l6 2v3l-6-2v6a2 2 0 11-1.5-1.94V4.5z'/%3E%3C/svg%3E");}
        a.icon.code{background:rgba(251,191,36,0.12);}
        a.icon.code::before{background:#fbbf24;mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='none'%3E%3Cpath d='M5 4L1 8l4 4M11 4l4 4-4 4M9 2l-2 12' stroke='%23000' stroke-width='1.4' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E");-webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='none'%3E%3Cpath d='M5 4L1 8l4 4M11 4l4 4-4 4M9 2l-2 12' stroke='%23000' stroke-width='1.4' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E");}
        a.icon.pdf{background:rgba(248,113,113,0.12);}
        a.icon.pdf::before{background:#f87171;mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M4 0h5.5L13 3.5V14a2 2 0 01-2 2H4a2 2 0 01-2-2V2a2 2 0 012-2z'/%3E%3Cpath d='M9 0v4h4' fill='none'/%3E%3C/svg%3E");-webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M4 0h5.5L13 3.5V14a2 2 0 01-2 2H4a2 2 0 01-2-2V2a2 2 0 012-2z'/%3E%3Cpath d='M9 0v4h4' fill='none'/%3E%3C/svg%3E");}
        a.icon.archive{background:rgba(251,146,60,0.12);}
        a.icon.archive::before{background:#fb923c;mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Crect x='1' y='1' width='14' height='4' rx='1'/%3E%3Crect x='1' y='6' width='14' height='9' rx='1'/%3E%3Cpath d='M6 9h4M8 8v2' stroke='white' stroke-width='1' fill='none'/%3E%3C/svg%3E");-webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Crect x='1' y='1' width='14' height='4' rx='1'/%3E%3Crect x='1' y='6' width='14' height='9' rx='1'/%3E%3Cpath d='M6 9h4M8 8v2' stroke='white' stroke-width='1' fill='none'/%3E%3C/svg%3E");}
        a.icon.text{background:rgba(148,163,184,0.1);}
        a.icon.text::before{background:rgba(148,163,184,0.7);mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='none'%3E%3Cpath d='M2 4h12M2 7h12M2 10h8' stroke='%23000' stroke-width='1.4' stroke-linecap='round'/%3E%3C/svg%3E");-webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='none'%3E%3Cpath d='M2 4h12M2 7h12M2 10h8' stroke='%23000' stroke-width='1.4' stroke-linecap='round'/%3E%3C/svg%3E");}
        a.icon.font{background:rgba(196,181,253,0.1);}
        a.icon.font::before{background:rgba(196,181,253,0.6);mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M2 13L6 3h1l4 10M4 9h5' stroke='%23000' stroke-width='1.4' fill='none' stroke-linecap='round'/%3E%3Cpath d='M11 7c.5-1 1.5-1.5 2.5-1s1.5 1 1.5 2v4' stroke='%23000' stroke-width='1.3' fill='none' stroke-linecap='round'/%3E%3Cellipse cx='13' cy='12' rx='1.5' ry='1'/%3E%3C/svg%3E");-webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M2 13L6 3h1l4 10M4 9h5' stroke='%23000' stroke-width='1.4' fill='none' stroke-linecap='round'/%3E%3Cpath d='M11 7c.5-1 1.5-1.5 2.5-1s1.5 1 1.5 2v4' stroke='%23000' stroke-width='1.3' fill='none' stroke-linecap='round'/%3E%3Cellipse cx='13' cy='12' rx='1.5' ry='1'/%3E%3C/svg%3E");}
        a.icon.po{background:rgba(255,255,255,0.06);}
        a.icon.po::before,a.icon.file::before{background:rgba(255,255,255,0.35);mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M4 1.5A1.5 1.5 0 015.5 0h5.086a1.5 1.5 0 011.06.44l2.915 2.914A1.5 1.5 0 0115 4.414V14.5A1.5 1.5 0 0113.5 16h-8A1.5 1.5 0 014 14.5zM10.5 1v3a.5.5 0 00.5.5h3z'/%3E%3C/svg%3E");-webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M4 1.5A1.5 1.5 0 015.5 0h5.086a1.5 1.5 0 011.06.44l2.915 2.914A1.5 1.5 0 0115 4.414V14.5A1.5 1.5 0 0113.5 16h-8A1.5 1.5 0 014 14.5zM10.5 1v3a.5.5 0 00.5.5h3z'/%3E%3C/svg%3E");}
        a.icon.file{background:rgba(255,255,255,0.06);}
        .col-name{font-size:13px;color:#fff;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;padding:0 8px;}
        .col-name a{color:#fff;text-decoration:none;display:block;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;transition:color 0.15s;}
        .col-name a:hover{color:#60a5fa;}
        .col-type{font-size:11px;font-weight:500;color:rgba(255,255,255,0.3);text-align:right;text-transform:uppercase;letter-spacing:0.04em;padding-right:8px;}
        .col-size{font-size:12px;color:rgba(255,255,255,0.4);text-align:right;font-variant-numeric:tabular-nums;padding-right:8px;}
        .col-date{font-size:11px;color:rgba(255,255,255,0.3);text-align:right;font-variant-numeric:tabular-nums;white-space:nowrap;}
        @keyframes fadeInRight{from{opacity:0;transform:translateX(20px);}to{opacity:1;transform:translateX(0);}}
        @keyframes fadeInLeft {from{opacity:0;transform:translateX(-20px);}to{opacity:1;transform:translateX(0);}}
        .fadeInRight{animation:fadeInRight 0.24s cubic-bezier(0.25,0.46,0.45,0.94) both;}
        .fadeInLeft {animation:fadeInLeft  0.24s cubic-bezier(0.25,0.46,0.45,0.94) both;}
        .overlay{display:none;position:fixed;inset:0;z-index:200;background:rgba(0,0,0,0.65);backdrop-filter:blur(12px) saturate(1.4);-webkit-backdrop-filter:blur(12px) saturate(1.4);align-items:flex-start;justify-content:center;padding-top:72px;}
        .overlay.open{display:flex;}
        .ov-card{background:#161616;border:0.5px solid rgba(255,255,255,0.12);border-radius:18px;width:92%;max-width:320px;box-shadow:0 32px 64px rgba(0,0,0,0.6);animation:ovIn 0.22s cubic-bezier(0.34,1.56,0.64,1) both;overflow:hidden;}
        @keyframes ovIn{from{opacity:0;transform:scale(0.93) translateY(-10px);}to{opacity:1;transform:scale(1) translateY(0);}}
        .ov-header{padding:14px 16px 12px;display:flex;align-items:center;border-bottom:0.5px solid rgba(255,255,255,0.07);}
        .ov-title{flex:1;font-size:13px;font-weight:600;color:rgba(255,255,255,0.85);}
        .ov-close{width:24px;height:24px;border-radius:7px;border:none;background:rgba(255,255,255,0.07);display:grid;place-items:center;cursor:pointer;transition:background 0.15s;}
        .ov-close:hover{background:rgba(255,255,255,0.14);}
        .ov-close svg{width:11px;height:11px;stroke:#aaa;fill:none;stroke-width:2.2;stroke-linecap:round;}
        .ov-body{padding:14px 16px 18px;display:flex;flex-direction:column;gap:10px;}
        .field-label{font-size:10px;font-weight:600;color:rgba(255,255,255,0.3);text-transform:uppercase;letter-spacing:0.07em;margin-bottom:6px;}
        .select-wrap{position:relative;}
        .select-wrap::after{content:'';pointer-events:none;position:absolute;right:11px;top:50%;transform:translateY(-50%);border-left:4px solid transparent;border-right:4px solid transparent;border-top:5px solid rgba(255,255,255,0.35);}
        select{width:100%;padding:9px 32px 9px 12px;background:rgba(255,255,255,0.05);border:0.5px solid rgba(255,255,255,0.1);border-radius:10px;color:#fff;font-size:13px;font-family:inherit;appearance:none;-webkit-appearance:none;cursor:pointer;transition:border-color 0.15s,background 0.15s;}
        select:hover{background:rgba(255,255,255,0.08);border-color:rgba(255,255,255,0.2);}
        select:focus{outline:none;border-color:rgba(255,255,255,0.3);}
        select option{background:#1e1e1e;color:#fff;}
        .btn-apply{width:100%;padding:10px;background:rgba(255,255,255,0.1);border:0.5px solid rgba(255,255,255,0.15);border-radius:10px;color:#fff;font-size:13px;font-weight:500;font-family:inherit;cursor:pointer;transition:background 0.15s,transform 0.1s;}
        .btn-apply:hover{background:rgba(255,255,255,0.17);}
        .btn-apply:active{transform:scale(0.97);}
        @media(max-width:600px){
        .item,.col-header{grid-template-columns:36px 1fr 80px 0 0;}
        .col-type,.col-date{display:none;}
        }
        </style>
        </head>
        <body>
        <div class="bg-glow"></div>
        <header>
        <a class="logo" href="/"><em>G</em>ABUT</a>
        <div class="spacer"></div>
        <button class="icon-btn" onclick="openMenu()" title="Sort">
            <svg viewBox="0 0 16 16">
            <line x1="2" y1="4"  x2="14" y2="4"/>
            <line x1="4" y1="8"  x2="14" y2="8"/>
            <line x1="6" y1="12" x2="14" y2="12"/>
            </svg>
        </button>
        </header>
        <div class="main">
        <div class="col-header">
            <span></span>
            <span class="ch-name">Name</span>
            <span class="ch-type">Type</span>
            <span class="ch-size">Size</span>
            <span class="ch-date">Date Modified</span>
        </div>
        <div class=""";
            string mid = """">
            """;
            string overlay_form = """
        </div>
        </div>
        <div class="overlay" id="myOverlay" onclick="overlayBg(event)">
        <div class="ov-card">
            <div class="ov-header">
            <span class="ov-title">Sort Files</span>
            <button class="ov-close" onclick="closeMenu()">
                <svg viewBox="0 0 12 12"><line x1="1" y1="1" x2="11" y2="11"/><line x1="11" y1="1" x2="1" y2="11"/></svg>
            </button>
            </div>
            <div class="ov-body">
            <form style="display:flex;flex-direction:column;gap:10px;" action="%s" method="POST">
                <div>
                <div class="field-label">Sort by</div>
                <div class="select-wrap">
                    <select name="sort">
                    <option %s>Name</option>
                    <option %s>Size</option>
                    <option %s>Type</option>
                    <option %s>Date</option>
                    </select>
                </div>
                </div>
                <input type="submit" class="btn-apply" value="Apply">
            </form>
            </div>
        </div>
        </div>
        <script>
        function openMenu(){
        document.getElementById('myOverlay').classList.add('open');
        document.body.style.overflow='hidden';
        }
        function closeMenu(){
        document.getElementById('myOverlay').classList.remove('open');
        document.body.style.overflow='';
        }
        function overlayBg(e){
        if(e.target===document.getElementById('myOverlay')) closeMenu();
        }
        document.addEventListener('keydown',e=>{ if(e.key==='Escape') closeMenu(); });
        </script>
        </body>
        </html>""".printf (path, get_shorted (0, username), get_shorted (1, username), get_shorted (2, username), get_shorted (3, username));
        return head + opcl + mid + share + overlay_form;
    }
}