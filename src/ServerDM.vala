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
    public string get_dm (string pathname, string htmlstr, string javascr, string username) {
        string errordm = "<div class=\"empty-state\"><div class=\"empty-icon ei-error\"></div><div class=\"empty-title\">No Error Downloads</div></div>";
        string activedm = "<div class=\"empty-state\"><div class=\"empty-icon ei-active\"></div><div class=\"empty-title\">No Active Downloads</div></div>";
        string pauseddm = "<div class=\"empty-state\"><div class=\"empty-icon ei-paused\"></div><div class=\"empty-title\">No Paused Downloads</div></div>";
        string waitdm = "<div class=\"empty-state\"><div class=\"empty-icon ei-wait\"></div><div class=\"empty-title\">No Waiting Downloads</div></div>";
        string completedm = "<div class=\"empty-state\"><div class=\"empty-icon ei-done\"></div><div class=\"empty-title\">No Completed Downloads</div></div>";

        if (pathname == "Downloading" && htmlstr != "") activedm = htmlstr;
        else if (pathname == "Paused" && htmlstr != "") pauseddm = htmlstr;
        else if (pathname == "Complete"&& htmlstr != "") completedm = htmlstr;
        else if (pathname == "Waiting" && htmlstr != "") waitdm = htmlstr;
        else if (pathname == "Error" && htmlstr != "") errordm = htmlstr;

        string dialog_html = """
        <div class="cdialog-overlay" id="cdialog" onclick="cdialogBg(event)">
        <div class="cdialog-card">
            <div class="cdialog-icon">
            <svg viewBox="0 0 20 20"><polyline points="2,5 18,5"/><path d="M6 5V3h8v2"/><path d="M4 5l1 12a1 1 0 001 1h8a1 1 0 001-1l1-12"/><line x1="8" y1="9" x2="8" y2="14"/><line x1="12" y1="9" x2="12" y2="14"/></svg>
            </div>
            <div class="cdialog-title">Delete Download?</div>
            <div class="cdialog-sub" id="cdialog-sub"></div>
            <div class="cdialog-btns">
            <button class="cdialog-cancel" onclick="cdialogClose()">Cancel</button>
            <button class="cdialog-confirm" id="cdialog-confirm">Delete</button>
            </div>
        </div>
        </div>
        <style>
        .dm-icon{
        width:36px;height:36px;border-radius:10px;flex-shrink:0;
        display:flex;align-items:center;justify-content:center;
        }
        .dm-icon::before{
        content:'';display:block;width:18px;height:18px;
        mask-size:contain;mask-repeat:no-repeat;mask-position:center;
        -webkit-mask-size:contain;-webkit-mask-repeat:no-repeat;-webkit-mask-position:center;
        }

        /* video */
        .dm-icon.video{background:rgba(251,146,60,0.12);}
        .dm-icon.video::before{background:#fb923c;
        mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Crect x='1' y='3' width='10' height='10' rx='1.5'/%3E%3Cpath d='M11 6l4-2v8l-4-2z'/%3E%3C/svg%3E");
        -webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Crect x='1' y='3' width='10' height='10' rx='1.5'/%3E%3Cpath d='M11 6l4-2v8l-4-2z'/%3E%3C/svg%3E");}

        /* audio */
        .dm-icon.audio{background:rgba(167,139,250,0.12);}
        .dm-icon.audio::before{background:#a78bfa;
        mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M6 2l6 2v3l-6-2v6a2 2 0 11-1.5-1.94V4.5z'/%3E%3C/svg%3E");
        -webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M6 2l6 2v3l-6-2v6a2 2 0 11-1.5-1.94V4.5z'/%3E%3C/svg%3E");}

        /* image */
        .dm-icon.image{background:rgba(52,211,153,0.12);}
        .dm-icon.image::before{background:#34d399;
        mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Crect x='1' y='1' width='14' height='14' rx='2' fill='none' stroke='%23000' stroke-width='1.2'/%3E%3Ccircle cx='5.5' cy='5.5' r='1.5'/%3E%3Cpath d='M1 11l4-4 3 3 2-2 4 4'/%3E%3C/svg%3E");
        -webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Crect x='1' y='1' width='14' height='14' rx='2' fill='none' stroke='%23000' stroke-width='1.2'/%3E%3Ccircle cx='5.5' cy='5.5' r='1.5'/%3E%3Cpath d='M1 11l4-4 3 3 2-2 4 4'/%3E%3C/svg%3E");}

        /* pdf */
        .dm-icon.pdf{background:rgba(248,113,113,0.12);}
        .dm-icon.pdf::before{background:#f87171;
        mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M4 0h5.5L13 3.5V14a2 2 0 01-2 2H4a2 2 0 01-2-2V2a2 2 0 012-2z'/%3E%3C/svg%3E");
        -webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M4 0h5.5L13 3.5V14a2 2 0 01-2 2H4a2 2 0 01-2-2V2a2 2 0 012-2z'/%3E%3C/svg%3E");}

        /* code */
        .dm-icon.code{background:rgba(251,191,36,0.12);}
        .dm-icon.code::before{background:#fbbf24;
        mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='none'%3E%3Cpath d='M5 4L1 8l4 4M11 4l4 4-4 4M9 2l-2 12' stroke='%23000' stroke-width='1.4' stroke-linecap='round'/%3E%3C/svg%3E");
        -webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='none'%3E%3Cpath d='M5 4L1 8l4 4M11 4l4 4-4 4M9 2l-2 12' stroke='%23000' stroke-width='1.4' stroke-linecap='round'/%3E%3C/svg%3E");}

        /* text */
        .dm-icon.text{background:rgba(148,163,184,0.1);}
        .dm-icon.text::before{background:rgba(148,163,184,0.7);
        mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='none'%3E%3Cpath d='M2 4h12M2 7h12M2 10h8' stroke='%23000' stroke-width='1.4' stroke-linecap='round'/%3E%3C/svg%3E");
        -webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='none'%3E%3Cpath d='M2 4h12M2 7h12M2 10h8' stroke='%23000' stroke-width='1.4' stroke-linecap='round'/%3E%3C/svg%3E");}

        /* archive */
        .dm-icon.archive{background:rgba(251,146,60,0.12);}
        .dm-icon.archive::before{background:#fb923c;
        mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Crect x='1' y='1' width='14' height='4' rx='1'/%3E%3Crect x='1' y='6' width='14' height='9' rx='1'/%3E%3Cline x1='6' y1='9.5' x2='10' y2='9.5' stroke='%23000' stroke-width='1.2'/%3E%3C/svg%3E");
        -webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Crect x='1' y='1' width='14' height='4' rx='1'/%3E%3Crect x='1' y='6' width='14' height='9' rx='1'/%3E%3Cline x1='6' y1='9.5' x2='10' y2='9.5' stroke='%23000' stroke-width='1.2'/%3E%3C/svg%3E");}

        /* folder */
        .dm-icon.folder{background:rgba(96,165,250,0.12);}
        .dm-icon.folder::before{background:#60a5fa;
        mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M1 3.5A1.5 1.5 0 012.5 2h3.086a1.5 1.5 0 011.06.44l.915.914A1.5 1.5 0 008.62 4H13.5A1.5 1.5 0 0115 5.5v7A1.5 1.5 0 0113.5 14h-11A1.5 1.5 0 011 12.5z'/%3E%3C/svg%3E");
        -webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M1 3.5A1.5 1.5 0 012.5 2h3.086a1.5 1.5 0 011.06.44l.915.914A1.5 1.5 0 008.62 4H13.5A1.5 1.5 0 0115 5.5v7A1.5 1.5 0 0113.5 14h-11A1.5 1.5 0 011 12.5z'/%3E%3C/svg%3E");}

        /* font */
        .dm-icon.font{background:rgba(232,121,249,0.12);}
        .dm-icon.font::before{background:#e879f9;
        mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='none'%3E%3Cpath d='M3 13L6.5 3l3.5 10M4.5 9.5h4' stroke='%23000' stroke-width='1.4' stroke-linecap='round' stroke-linejoin='round'/%3E%3Cpath d='M10.5 7c0-1.1.9-2 2-2s2 .9 2 2v4' stroke='%23000' stroke-width='1.4' stroke-linecap='round'/%3E%3Ccircle cx='12.5' cy='11' r='2' stroke='%23000' stroke-width='1.2'/%3E%3C/svg%3E");
        -webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='none'%3E%3Cpath d='M3 13L6.5 3l3.5 10M4.5 9.5h4' stroke='%23000' stroke-width='1.4' stroke-linecap='round' stroke-linejoin='round'/%3E%3Cpath d='M10.5 7c0-1.1.9-2 2-2s2 .9 2 2v4' stroke='%23000' stroke-width='1.4' stroke-linecap='round'/%3E%3Ccircle cx='12.5' cy='11' r='2' stroke='%23000' stroke-width='1.2'/%3E%3C/svg%3E");}

        /* po (translation) */
        .dm-icon.po{background:rgba(34,211,238,0.12);}
        .dm-icon.po::before{background:#22d3ee;
        mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='none'%3E%3Crect x='1' y='1' width='14' height='14' rx='2' stroke='%23000' stroke-width='1.2'/%3E%3Cpath d='M4 5h8M4 8h5' stroke='%23000' stroke-width='1.3' stroke-linecap='round'/%3E%3Cpath d='M8 11l1.5 2.5L11 11' stroke='%23000' stroke-width='1.2' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E");
        -webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='none'%3E%3Crect x='1' y='1' width='14' height='14' rx='2' stroke='%23000' stroke-width='1.2'/%3E%3Cpath d='M4 5h8M4 8h5' stroke='%23000' stroke-width='1.3' stroke-linecap='round'/%3E%3Cpath d='M8 11l1.5 2.5L11 11' stroke='%23000' stroke-width='1.2' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E");}

        /* file (default) */
        .dm-icon.file{background:rgba(255,255,255,0.06);}
        .dm-icon.file::before{background:rgba(255,255,255,0.35);
        mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M4 1.5A1.5 1.5 0 015.5 0h5.086a1.5 1.5 0 011.06.44l2.915 2.914A1.5 1.5 0 0115 4.414V14.5A1.5 1.5 0 0113.5 16h-8A1.5 1.5 0 014 14.5z'/%3E%3C/svg%3E");
        -webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M4 1.5A1.5 1.5 0 015.5 0h5.086a1.5 1.5 0 011.06.44l2.915 2.914A1.5 1.5 0 0115 4.414V14.5A1.5 1.5 0 0113.5 16h-8A1.5 1.5 0 014 14.5z'/%3E%3C/svg%3E");}
        .cdialog-overlay{
        display:none;position:fixed;inset:0;z-index:300;
        background:rgba(0,0,0,0.7);
        backdrop-filter:blur(16px) saturate(1.4);
        -webkit-backdrop-filter:blur(16px) saturate(1.4);
        align-items:center;justify-content:center;padding:20px;
        }
        .cdialog-overlay.open{display:flex;}
        .cdialog-card{
        background:#161616;
        border:0.5px solid rgba(255,255,255,0.1);
        border-radius:20px;width:100%;max-width:320px;
        padding:28px 24px 20px;
        display:flex;flex-direction:column;align-items:center;gap:10px;
        box-shadow:0 32px 64px rgba(0,0,0,0.7);
        animation:cdIn 0.22s cubic-bezier(0.34,1.56,0.64,1) both;
        }
        @keyframes cdIn{
        from{opacity:0;transform:scale(0.88) translateY(10px);}
        to  {opacity:1;transform:scale(1) translateY(0);}
        }
        .cdialog-icon{
        width:52px;height:52px;border-radius:16px;
        background:rgba(248,113,113,0.15);color:#f87171;
        display:flex;align-items:center;justify-content:center;
        margin-bottom:4px;
        }
        .cdialog-icon svg{
        width:26px;height:26px;fill:none;stroke:currentColor;
        stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round;
        }
        .cdialog-title{font-size:16px;font-weight:700;color:#fff;text-align:center;}
        .cdialog-sub{
        font-size:13px;color:rgba(255,255,255,0.35);
        text-align:center;line-height:1.6;max-width:240px;
        }
        .cdialog-btns{display:flex;gap:8px;width:100%;margin-top:8px;}
        .cdialog-cancel{
        flex:1;padding:10px;
        background:rgba(255,255,255,0.06);
        border:0.5px solid rgba(255,255,255,0.1);
        border-radius:10px;color:rgba(255,255,255,0.6);
        font-size:13px;font-weight:500;font-family:inherit;
        cursor:pointer;transition:background 0.15s;
        }
        .cdialog-cancel:hover{background:rgba(255,255,255,0.1);}
        .cdialog-confirm{
        flex:1;padding:10px;
        background:rgba(248,113,113,0.9);
        border:0.5px solid rgba(248,113,113,0.5);
        border-radius:10px;color:#fff;
        font-size:13px;font-weight:600;font-family:inherit;
        cursor:pointer;transition:background 0.15s,transform 0.1s;
        }
        .cdialog-confirm:hover{background:#f87171;}
        .cdialog-confirm:active{transform:scale(0.97);}
        </style>
        <script>
        (function(){
        const overlay = document.getElementById('cdialog');
        const subEl   = document.getElementById('cdialog-sub');
        const confirm = document.getElementById('cdialog-confirm');

        let pendingForm    = null;
        let pendingBtnName = '';
        let pendingBtnVal  = '';

        window.cdialogClose = function() {
            overlay.classList.remove('open');
            document.body.style.overflow = '';
            pendingForm = null;
            pendingBtnName = '';
            pendingBtnVal  = '';
        };
        window.cdialogBg = function(e) {
            if (e.target === overlay) cdialogClose();
        };

        confirm.addEventListener('click', () => {
            if (pendingForm) {
            if (pendingBtnName) {
                const hidden = document.createElement('input');
                hidden.type  = 'hidden';
                hidden.name  = pendingBtnName;
                hidden.value = pendingBtnVal;
                pendingForm.appendChild(hidden);
            }
            pendingForm.submit();
            }
            cdialogClose();
        });

        document.addEventListener('keydown', e => {
            if (!overlay.classList.contains('open')) return;
            if (e.key === 'Escape') cdialogClose();
            if (e.key === 'Enter') confirm.click();
        });

        document.addEventListener('DOMContentLoaded', () => {
            document.querySelectorAll('form').forEach(form => {
            const btn = form.querySelector('button[type=submit],input[type=submit]');
            if (!btn) return;
            const val = (btn.value || btn.textContent || '').toLowerCase();
            if (!val.includes('delete')) return;

            form.addEventListener('submit', e => {
                e.preventDefault();
                pendingForm    = form;
                pendingBtnName = btn.name  || '';
                pendingBtnVal  = btn.value || 'Delete';
                const name = form.closest('.dm-item')
                            ?.querySelector('.dm-name')
                            ?.textContent?.trim() || '';
                subEl.textContent = name
                ? '"' + name + '" will be removed from the download list.'
                : 'This item will be removed from the download list.';
                overlay.classList.add('open');
                document.body.style.overflow = 'hidden';
            });
            });
        });
        })();
        </script>
        """;
        string head = """<!DOCTYPE html>
        <html lang="en">
        <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Gabut Download Manager</title>
        <style>
        *{margin:0;padding:0;box-sizing:border-box;}
        body{
        background:#0a0a0a;color:#fff;
        font-family:Inter,system-ui,sans-serif;
        min-height:100vh;display:flex;flex-direction:column;
        overflow-x:hidden;
        }
        .bg-glow{
        position:fixed;inset:0;z-index:0;pointer-events:none;overflow:hidden;
        }
        .bg-glow::before{
        content:'';position:absolute;
        width:600px;height:600px;border-radius:50%;
        background:radial-gradient(circle,rgba(96,165,250,0.08) 0%,transparent 70%);
        top:-200px;left:-200px;
        animation:glowdrift1 14s ease-in-out infinite alternate;
        }
        .bg-glow::after{
        content:'';position:absolute;
        width:500px;height:500px;border-radius:50%;
        background:radial-gradient(circle,rgba(52,211,153,0.06) 0%,transparent 70%);
        bottom:-180px;right:-180px;
        animation:glowdrift2 16s ease-in-out infinite alternate;
        }
        @keyframes glowdrift1{from{transform:translate(0,0) scale(1);}to{transform:translate(60px,50px) scale(1.2);}}
        @keyframes glowdrift2{from{transform:translate(0,0) scale(1);}to{transform:translate(-50px,-60px) scale(1.15);}}

        /* ── Top header ── */
        .topbar{
        position:sticky;top:0;z-index:100;
        width:100%;
        background:rgba(10,10,10,0.88);
        backdrop-filter:blur(24px) saturate(1.8);
        -webkit-backdrop-filter:blur(24px) saturate(1.8);
        border-bottom:0.5px solid rgba(255,255,255,0.07);
        padding:0 20px;height:52px;
        display:flex;align-items:center;gap:12px;
        }
        .logo{text-decoration:none;font-size:17px;font-weight:800;color:#fff;letter-spacing:-0.5px;}
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

        /* ── Tab bar ── */
       .tabbar{
        position:sticky;top:52px;z-index:90;
        background:rgba(10,10,10,0.85);
        backdrop-filter:blur(16px);-webkit-backdrop-filter:blur(16px);
        border-bottom:0.5px solid rgba(255,255,255,0.07);
        padding:8px 20px;
        display:flex;align-items:center;
        gap:4px;
        overflow-x:auto;scrollbar-width:none;
        }
        .tabbar::-webkit-scrollbar{display:none;}
        .tab-btn{
        flex:1;
        min-width:0;
        padding:0 8px;height:34px;
        background:transparent;
        border:0.5px solid transparent;
        border-radius:999px;
        color:rgba(255,255,255,0.35);
        font-size:13px;font-weight:500;font-family:inherit;
        cursor:pointer;flex-shrink:0;
        display:flex;align-items:center;justify-content:center;gap:6px;
        transition:color 0.15s,background 0.15s,border-color 0.15s;
        white-space:nowrap;
        }
        .tab-btn:hover{
        color:rgba(255,255,255,0.75);
        background:rgba(255,255,255,0.06);
        }
        .tab-btn.active{
        color:#fff;
        background:rgba(255,255,255,0.1);
        border-color:rgba(255,255,255,0.12);
        }
        .tab-dot{
        width:6px;height:6px;border-radius:50%;
        background:currentColor;opacity:0.5;
        flex-shrink:0;display:none;
        }
        .tab-btn.active .tab-dot{display:block;opacity:1;}

        /* ── Main content ── */
        .main{
        flex:1;padding:20px;
        max-width:1280px;width:100%;
        margin:0 auto;position:relative;z-index:1;
        }
        .tabcontent{display:none;}
        .tabcontent.active{display:block;}

        /* ── Empty state ── */
        .empty-state{
        display:flex;flex-direction:column;align-items:center;justify-content:center;
        gap:16px;padding:80px 20px;
        }
        .empty-icon{
        width:64px;height:64px;border-radius:18px;
        display:flex;align-items:center;justify-content:center;
        position:relative;
        }
        .empty-icon::before{
        content:'';display:block;width:32px;height:32px;
        mask-size:contain;mask-repeat:no-repeat;mask-position:center;
        -webkit-mask-size:contain;-webkit-mask-repeat:no-repeat;-webkit-mask-position:center;
        }
        .ei-active{background:rgba(96,165,250,0.12);}
        .ei-active::before{
        background:#60a5fa;
        mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none'%3E%3Ccircle cx='12' cy='12' r='10' stroke='%23000' stroke-width='1.5'/%3E%3Cpath d='M10 8l6 4-6 4V8z' fill='%23000'/%3E%3C/svg%3E");
        -webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none'%3E%3Ccircle cx='12' cy='12' r='10' stroke='%23000' stroke-width='1.5'/%3E%3Cpath d='M10 8l6 4-6 4V8z' fill='%23000'/%3E%3C/svg%3E");
        }
        .ei-paused{background:rgba(251,191,36,0.12);}
        .ei-paused::before{
        background:#fbbf24;
        mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none'%3E%3Ccircle cx='12' cy='12' r='10' stroke='%23000' stroke-width='1.5'/%3E%3Crect x='9' y='8' width='2' height='8' rx='1' fill='%23000'/%3E%3Crect x='13' y='8' width='2' height='8' rx='1' fill='%23000'/%3E%3C/svg%3E");
        -webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none'%3E%3Ccircle cx='12' cy='12' r='10' stroke='%23000' stroke-width='1.5'/%3E%3Crect x='9' y='8' width='2' height='8' rx='1' fill='%23000'/%3E%3Crect x='13' y='8' width='2' height='8' rx='1' fill='%23000'/%3E%3C/svg%3E");
        }
        .ei-done{background:rgba(52,211,153,0.12);}
        .ei-done::before{
        background:#34d399;
        mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none'%3E%3Ccircle cx='12' cy='12' r='10' stroke='%23000' stroke-width='1.5'/%3E%3Cpath d='M8 12l3 3 5-5' stroke='%23000' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E");
        -webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none'%3E%3Ccircle cx='12' cy='12' r='10' stroke='%23000' stroke-width='1.5'/%3E%3Cpath d='M8 12l3 3 5-5' stroke='%23000' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E");
        }
        .ei-wait{background:rgba(167,139,250,0.12);}
        .ei-wait::before{
        background:#a78bfa;
        mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none'%3E%3Ccircle cx='12' cy='12' r='10' stroke='%23000' stroke-width='1.5'/%3E%3Cpath d='M12 7v5l3 3' stroke='%23000' stroke-width='1.8' stroke-linecap='round'/%3E%3C/svg%3E");
        -webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none'%3E%3Ccircle cx='12' cy='12' r='10' stroke='%23000' stroke-width='1.5'/%3E%3Cpath d='M12 7v5l3 3' stroke='%23000' stroke-width='1.8' stroke-linecap='round'/%3E%3C/svg%3E");
        }
        .ei-error{background:rgba(248,113,113,0.12);}
        .ei-error::before{
        background:#f87171;
        mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none'%3E%3Ccircle cx='12' cy='12' r='10' stroke='%23000' stroke-width='1.5'/%3E%3Cpath d='M12 8v4M12 16h.01' stroke='%23000' stroke-width='2' stroke-linecap='round'/%3E%3C/svg%3E");
        -webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none'%3E%3Ccircle cx='12' cy='12' r='10' stroke='%23000' stroke-width='1.5'/%3E%3Cpath d='M12 8v4M12 16h.01' stroke='%23000' stroke-width='2' stroke-linecap='round'/%3E%3C/svg%3E");
        }
        .empty-title{font-size:14px;color:rgba(255,255,255,0.3);font-weight:500;}

        /* ── Overlay ── */
        .overlay{
        display:none;position:fixed;inset:0;z-index:200;
        background:rgba(0,0,0,0.65);
        backdrop-filter:blur(12px) saturate(1.4);
        -webkit-backdrop-filter:blur(12px) saturate(1.4);
        align-items:flex-start;justify-content:center;
        padding-top:72px;
        }
        .overlay.open{display:flex;}
        .ov-card{
        background:#161616;
        border:0.5px solid rgba(255,255,255,0.12);
        border-radius:18px;width:92%;max-width:360px;
        box-shadow:0 32px 64px rgba(0,0,0,0.6);
        animation:ovIn 0.22s cubic-bezier(0.34,1.56,0.64,1) both;
        overflow:hidden;
        }
        @keyframes ovIn{from{opacity:0;transform:scale(0.93) translateY(-10px);}to{opacity:1;transform:scale(1) translateY(0);}}
        .ov-header{
        padding:14px 16px 12px;display:flex;align-items:center;
        border-bottom:0.5px solid rgba(255,255,255,0.07);
        }
        .ov-title{flex:1;font-size:13px;font-weight:600;color:rgba(255,255,255,0.85);}
        .ov-close{
        width:24px;height:24px;border-radius:7px;border:none;
        background:rgba(255,255,255,0.07);
        display:grid;place-items:center;cursor:pointer;transition:background 0.15s;
        }
        .ov-close:hover{background:rgba(255,255,255,0.14);}
        .ov-close svg{width:11px;height:11px;stroke:#aaa;fill:none;stroke-width:2.2;stroke-linecap:round;}
        .ov-body{padding:16px;display:flex;flex-direction:column;gap:16px;}
        .ov-section{display:flex;flex-direction:column;gap:8px;}
        .ov-label{
        font-size:10px;font-weight:600;color:rgba(255,255,255,0.3);
        text-transform:uppercase;letter-spacing:0.07em;
        }
        .ov-input{
        width:100%;padding:9px 13px;
        background:rgba(255,255,255,0.05);
        border:0.5px solid rgba(255,255,255,0.1);
        border-radius:10px;color:#fff;
        font-size:13px;font-family:inherit;
        transition:border-color 0.15s,background 0.15s;
        }
        .ov-input:focus{outline:none;border-color:rgba(255,255,255,0.3);background:rgba(255,255,255,0.08);}
        .ov-input::placeholder{color:rgba(255,255,255,0.2);}
        .ov-file{
        width:100%;padding:9px 13px;
        background:rgba(255,255,255,0.05);
        border:0.5px solid rgba(255,255,255,0.1);
        border-radius:10px;color:rgba(255,255,255,0.5);
        font-size:13px;font-family:inherit;cursor:pointer;
        }
        .ov-file::-webkit-file-upload-button{
        background:rgba(255,255,255,0.1);
        border:0.5px solid rgba(255,255,255,0.15);
        border-radius:7px;padding:4px 10px;
        color:#fff;font-size:12px;cursor:pointer;
        margin-right:8px;
        }
        .select-wrap{position:relative;}
        .select-wrap::after{
        content:'';pointer-events:none;
        position:absolute;right:11px;top:50%;transform:translateY(-50%);
        border-left:4px solid transparent;border-right:4px solid transparent;
        border-top:5px solid rgba(255,255,255,0.35);
        }
        select{
        width:100%;padding:9px 32px 9px 12px;
        background:rgba(255,255,255,0.05);
        border:0.5px solid rgba(255,255,255,0.1);
        border-radius:10px;color:#fff;
        font-size:13px;font-family:inherit;
        appearance:none;-webkit-appearance:none;cursor:pointer;
        }
        select:focus{outline:none;border-color:rgba(255,255,255,0.3);}
        select option{background:#1e1e1e;color:#fff;}
        .btn-submit{
        width:100%;padding:10px;
        background:rgba(255,255,255,0.1);
        border:0.5px solid rgba(255,255,255,0.15);
        border-radius:10px;color:#fff;
        font-size:13px;font-weight:500;font-family:inherit;
        cursor:pointer;transition:background 0.15s,transform 0.1s;
        }
        .btn-submit:hover{background:rgba(255,255,255,0.17);}
        .btn-submit:active{transform:scale(0.97);}
        .ov-divider{height:0.5px;background:rgba(255,255,255,0.07);}
        /* ── DM Item row ── */
        .append{
        background:rgba(255,255,255,0.02);
        border:0.5px solid rgba(255,255,255,0.08);
        border-radius:16px;overflow:hidden;margin-bottom:12px;
        }
        .dm-item{
        display:grid;
        grid-template-columns:44px 1fr auto;
        align-items:center;
        gap:12px;
        padding:12px 14px;
        border-bottom:0.5px solid rgba(255,255,255,0.05);
        transition:background 0.1s;
        }
        .dm-item:last-child{border-bottom:none;}
        .dm-item:hover{background:rgba(255,255,255,0.04);}

        /* Icon */
        .dm-icon{
        width:36px;height:36px;border-radius:10px;
        flex-shrink:0;
        mask-size:contain;mask-repeat:no-repeat;mask-position:center;
        -webkit-mask-size:contain;-webkit-mask-repeat:no-repeat;-webkit-mask-position:center;
        }
        .dm-icon::before{
        content:'';display:block;width:18px;height:18px;margin:9px;
        mask-size:contain;mask-repeat:no-repeat;mask-position:center;
        -webkit-mask-size:contain;-webkit-mask-repeat:no-repeat;-webkit-mask-position:center;
        background:rgba(255,255,255,0.35);
        mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M4 1.5A1.5 1.5 0 015.5 0h5.086a1.5 1.5 0 011.06.44l2.915 2.914A1.5 1.5 0 0115 4.414V14.5A1.5 1.5 0 0113.5 16h-8A1.5 1.5 0 014 14.5z'/%3E%3C/svg%3E");
        -webkit-mask-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M4 1.5A1.5 1.5 0 015.5 0h5.086a1.5 1.5 0 011.06.44l2.915 2.914A1.5 1.5 0 0115 4.414V14.5A1.5 1.5 0 0113.5 16h-8A1.5 1.5 0 014 14.5z'/%3E%3C/svg%3E");
        }
        .dm-icon.video{background:rgba(251,146,60,0.12);}
        .dm-icon.video::before{background:#fb923c;}
        .dm-icon.audio{background:rgba(167,139,250,0.12);}
        .dm-icon.audio::before{background:#a78bfa;}
        .dm-icon.image{background:rgba(52,211,153,0.12);}
        .dm-icon.image::before{background:#34d399;}
        .dm-icon.archive{background:rgba(251,146,60,0.12);}
        .dm-icon.archive::before{background:#fb923c;}
        .dm-icon.pdf{background:rgba(248,113,113,0.12);}
        .dm-icon.pdf::before{background:#f87171;}
        .dm-icon.code{background:rgba(251,191,36,0.12);}
        .dm-icon.code::before{background:#fbbf24;}
        .dm-icon.file{background:rgba(255,255,255,0.06);}

        /* Info */
        .dm-info{flex:1;min-width:0;display:flex;flex-direction:column;gap:5px;}
        .dm-name{
        font-size:13px;font-weight:500;color:#fff;
        overflow:hidden;white-space:nowrap;text-overflow:ellipsis;
        }
        .dm-loading{color:rgba(255,255,255,0.3);font-style:italic;}

        /* Progress */
        .dm-progress{width:100%;}
        .dm-progress-track{
        width:100%;height:3px;
        background:rgba(255,255,255,0.08);
        border-radius:999px;overflow:hidden;
        position:relative;
        }
        .dm-progress-fill{
        height:100%;border-radius:999px;
        background:rgba(255,255,255,0.7);
        transition:width 0.4s ease;
        }
        @keyframes indeterminate{
        0%  {left:-40%;width:40%;}
        100%{left:100%;width:40%;}
        }
        .dm-indeterminate{
        position:absolute;
        animation:indeterminate 1.4s linear infinite;
        background:rgba(255,255,255,0.4);
        }
        .dm-label{
        font-size:11px;color:rgba(255,255,255,0.35);
        font-variant-numeric:tabular-nums;
        }

        /* Action buttons */
        .dm-actions{display:flex;align-items:center;gap:6px;flex-shrink:0;}
        .dm-btn{
        width:32px;height:32px;border-radius:9px;border:none;
        display:grid;place-items:center;cursor:pointer;
        transition:background 0.15s,transform 0.1s;flex-shrink:0;
        }
        .dm-btn svg{
        width:14px;height:14px;fill:none;stroke:currentColor;
        stroke-width:1.6;stroke-linecap:round;stroke-linejoin:round;
        display:block;pointer-events:none;
        }
        .dm-btn:active{transform:scale(0.88);}
        .dm-btn-del{background:rgba(248,113,113,0.1);color:#f87171;}
        .dm-btn-del:hover{background:rgba(248,113,113,0.2);}
        .dm-btn-act{background:rgba(96,165,250,0.1);color:#60a5fa;}
        .dm-btn-act:hover{background:rgba(96,165,250,0.2);}
        .dm-btn-done{background:rgba(52,211,153,0.1);color:#34d399;}
        .dm-btn-done:hover{background:rgba(52,211,153,0.2);}
        .dm-btn-wait{background:rgba(167,139,250,0.1);color:#a78bfa;}
        .dm-btn-wait:hover{background:rgba(167,139,250,0.2);}
        .dm-btn-err{background:rgba(248,113,113,0.1);color:#f87171;}
        .dm-btn-err:hover{background:rgba(248,113,113,0.2);}

        @media(max-width:480px){
        .dm-item{grid-template-columns:36px 1fr auto;}
        .dm-btn{width:28px;height:28px;}
        }
        </style>
        </head>
        <body>
        <div class="bg-glow"></div>
        <div class="topbar">
        <a class="logo" href="/"><em>G</em>ABUT</a>
        <div class="spacer"></div>
        <button class="icon-btn" onclick="openMenu()" title="Add Download">
            <svg viewBox="0 0 16 16">
            <line x1="8" y1="2" x2="8" y2="14"/>
            <line x1="2" y1="8" x2="14" y2="8"/>
            </svg>
        </button>
        </div>

        <div class="tabbar">
        <button class="tab-btn" id="tab-Downloading" onclick="openTab('Downloading',this)">
            <div class="tab-dot"></div>Downloading
        </button>
        <button class="tab-btn" id="tab-Paused" onclick="openTab('Paused',this)">
            <div class="tab-dot"></div>Paused
        </button>
        <button class="tab-btn" id="tab-Complete" onclick="openTab('Complete',this)">
            <div class="tab-dot"></div>Complete
        </button>
        <button class="tab-btn" id="tab-Waiting" onclick="openTab('Waiting',this)">
            <div class="tab-dot"></div>Waiting
        </button>
        <button class="tab-btn" id="tab-Error" onclick="openTab('Error',this)">
            <div class="tab-dot"></div>Error
        </button>
        </div>

        <div class="main">
        <div id="Downloading" class="tabcontent">""";

        string mid1 = """</div>
        <div id="Paused" class="tabcontent">""";
        string mid2 = """</div>
        <div id="Complete" class="tabcontent">""";
        string mid3 = """</div>
        <div id="Waiting" class="tabcontent">""";
        string mid4 = """</div>
        <div id="Error" class="tabcontent">""";
        string overlay_form = """</div>
        </div>

        <!-- Overlay -->
        <div class="overlay" id="myOverlay" onclick="overlayBg(event)">
        <div class="ov-card">
            <div class="ov-header">
            <span class="ov-title">Add Download</span>
            <button class="ov-close" onclick="closeMenu()">
                <svg viewBox="0 0 12 12"><line x1="1" y1="1" x2="11" y2="11"/><line x1="11" y1="1" x2="1" y2="11"/></svg>
            </button>
            </div>
            <div class="ov-body">
            <!-- Sort -->
            <div class="ov-section">
                <div class="ov-label">Sort by</div>
                <form style="display:flex;flex-direction:column;gap:8px;" action="/%s" method="POST">
                <div class="select-wrap">
                    <select name="sort">
                    <option %s>Name</option>
                    <option %s>Size</option>
                    <option %s>Type</option>
                    <option %s>Date</option>
                    </select>
                </div>
                <input type="submit" class="btn-submit" value="Apply Sort">
                </form>
            </div>
            <div class="ov-divider"></div>
            <!-- URL -->
            <div class="ov-section">
                <div class="ov-label">Paste URL / Magnet / Metalink</div>
                <form style="display:flex;flex-direction:column;gap:8px;" action="/%s" method="post" enctype="text/plain">
                <input class="ov-input" type="text" placeholder="https:// or magnet:?xt=..." name="gabutlink">
                <input type="submit" class="btn-submit" value="Start Download">
                </form>
            </div>
            <div class="ov-divider"></div>
            <!-- File -->
            <div class="ov-section">
                <div class="ov-label">Torrent or Metalink file</div>
                <form style="display:flex;flex-direction:column;gap:8px;" action="/%s" method="post" enctype="multipart/form-data">
                <input class="ov-file" type="file" id="uploader" name="file[]" accept=".torrent,application/x-bittorrent,.metalink,application/metalink+xml">
                <input type="submit" class="btn-submit" value="Open File">
                </form>
            </div>
            </div>
        </div>
        </div>""".printf (pathname, get_shorted (0, username), get_shorted (1, username), get_shorted (2, username), get_shorted (3, username), pathname, pathname);
        string scripts = """
        <script>
        (function(){
        const uploader = document.getElementById('uploader');
        if (!uploader) return;

        uploader.closest('form').addEventListener('submit', async function(e) {
            const file = uploader.files[0];
            if (!file) return;

            // Hanya intercept .torrent untuk preview
            if (!file.name.toLowerCase().endsWith('.torrent')) return;

            e.preventDefault();

            // Buat overlay loading
            const ov = document.createElement('div');
            ov.style.cssText = 'position:fixed;inset:0;z-index:9999;background:rgba(0,0,0,0.8);backdrop-filter:blur(12px);display:flex;flex-direction:column;align-items:center;justify-content:center;gap:16px;';
            ov.innerHTML = '<div style="width:32px;height:32px;border-radius:50%;border:2.5px solid rgba(255,255,255,0.1);border-top-color:#34d399;animation:spin 0.8s linear infinite;"></div><div style="color:rgba(255,255,255,0.5);font-size:13px;">Loading torrent info…</div>';
            document.body.appendChild(ov);

            try {
            // POST file ke /TorrentPreview
            const fd = new FormData();
            fd.append('file[]', file);
            const resp = await fetch('/TorrentPreview', { method: 'POST', body: fd });
            const html  = await resp.text();

            // Inject hasil HTML ke overlay sebagai full iframe
            ov.innerHTML = '';
            ov.style.cssText = 'position:fixed;inset:0;z-index:9999;display:flex;flex-direction:column;';

            // Top bar — confirm / cancel
            const bar = document.createElement('div');
            bar.style.cssText = 'background:#111;border-bottom:0.5px solid rgba(255,255,255,0.1);padding:10px 20px;display:flex;align-items:center;gap:10px;flex-shrink:0;';
            bar.innerHTML = `
                <span style="color:#fff;font-size:14px;font-weight:500;flex:1;">${file.name}</span>
                <button id="trk-cancel" style="background:rgba(255,255,255,0.06);border:0.5px solid rgba(255,255,255,0.1);border-radius:999px;padding:8px 18px;color:rgba(255,255,255,0.6);font-size:13px;cursor:pointer;font-family:inherit;">Cancel</button>
                <button id="trk-confirm" style="background:rgba(52,211,153,0.15);border:0.5px solid rgba(52,211,153,0.3);border-radius:999px;padding:8px 18px;color:#34d399;font-size:13px;font-weight:600;cursor:pointer;font-family:inherit;">Add to Download</button>
            `;
            ov.appendChild(bar);

            // iframe konten viewer
            const iframe = document.createElement('iframe');
            iframe.style.cssText = 'flex:1;border:none;width:100%;';
            iframe.srcdoc = html;
            ov.appendChild(iframe);

            // Cancel
            bar.querySelector('#trk-cancel').addEventListener('click', () => {
                document.body.removeChild(ov);
                uploader.value = '';
            });

            // Confirm — submit form asli ke DM
            bar.querySelector('#trk-confirm').addEventListener('click', () => {
                document.body.removeChild(ov);
                // Submit form original
                const form = uploader.closest('form');
                const hidden = document.createElement('input');
                hidden.type = 'hidden';
                hidden.name = '__confirmed__';
                hidden.value = '1';
                form.appendChild(hidden);
                form.submit();
            });

            } catch (err) {
            document.body.removeChild(ov);
            console.error('Torrent preview error:', err);
            // Fallback — submit langsung
            uploader.closest('form').submit();
            }
        });

        // Tambah CSS spinner
        if (!document.getElementById('trk-spin-css')) {
            const s = document.createElement('style');
            s.id = 'trk-spin-css';
            s.textContent = '@keyframes spin{to{transform:rotate(360deg);}}';
            document.head.appendChild(s);
        }
        })();
        function openTab(name, el) {
        document.querySelectorAll('.tabcontent').forEach(t=>t.classList.remove('active'));
        document.querySelectorAll('.tab-btn').forEach(b=>b.classList.remove('active'));
        document.getElementById(name).classList.add('active');
        el.classList.add('active');
        if(name !== '""" + pathname + """') window.location.href='/'+name;
        }
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
        document.getElementById('tab-""" + pathname + """').click();
        if(window.history.replaceState) window.history.replaceState(null,null,window.location.href);
        </script>
        """;
        return head + activedm + mid1 + pauseddm + mid2 + completedm + mid3 + waitdm + mid4 + errordm + overlay_form + javascr + scripts + dialog_html + "</body></html>";
    }
}