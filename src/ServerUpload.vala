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
    public string get_upload () {
        return """<!DOCTYPE html>
        <html lang="en">
        <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Share File To Computer</title>
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
        width:550px;height:550px;border-radius:50%;
        background:radial-gradient(circle,rgba(52,211,153,0.07) 0%,transparent 70%);
        top:-180px;right:-180px;
        animation:glowdrift1 13s ease-in-out infinite alternate;
        }
        .bg-glow::after{
        content:'';position:absolute;
        width:480px;height:480px;border-radius:50%;
        background:radial-gradient(circle,rgba(96,165,250,0.06) 0%,transparent 70%);
        bottom:-160px;left:-160px;
        animation:glowdrift2 15s ease-in-out infinite alternate;
        }
        @keyframes glowdrift1{
        from{transform:translate(0,0) scale(1);}
        to  {transform:translate(-50px,60px) scale(1.15);}
        }
        @keyframes glowdrift2{
        from{transform:translate(0,0) scale(1);}
        to  {transform:translate(60px,-50px) scale(1.2);}
        }
        /* ── Header ── */
        header{
        width:100%;
        background:rgba(10,10,10,0.85);
        backdrop-filter:blur(24px) saturate(1.8);
        -webkit-backdrop-filter:blur(24px) saturate(1.8);
        padding:0 20px;height:52px;
        display:flex;align-items:center;gap:10px;
        border-bottom:0.5px solid rgba(255,255,255,0.07);
        flex-shrink:0;position:sticky;top:0;z-index:100;
        }
        header a{color:#888;text-decoration:none;font-size:13px;transition:color 0.15s;}
        header a:hover{color:#fff;}
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
        .hd-title{color:#fff;font-size:14px;font-weight:500;flex:1;}
        /* ── Wrap ── */
        .wrap{
        flex:1;display:flex;flex-direction:column;
        align-items:center;padding:32px 16px;gap:20px;
        max-width:800px;margin:0 auto;width:100%;
        position:relative;z-index:1;
        }
        /* ── Dropzone ── */
        .dropzone-area{
        width:100%;min-height:200px;
        border:1.5px dashed rgba(255,255,255,0.15);
        border-radius:20px;
        background:rgba(255,255,255,0.03);
        backdrop-filter:blur(8px);
        -webkit-backdrop-filter:blur(8px);
        display:flex;flex-direction:column;
        align-items:center;justify-content:center;
        gap:12px;cursor:pointer;
        transition:border-color 0.2s,background 0.2s;
        padding:40px 20px;position:relative;
        }
        .dropzone-area:hover,.dropzone-area.dragover{
        border-color:rgba(255,255,255,0.4);
        background:rgba(255,255,255,0.07);
        }
        .dropzone-area.dragover{
        border-color:rgba(52,211,153,0.6);
        background:rgba(52,211,153,0.05);
        }
        .dz-icon svg{
        width:48px;height:48px;stroke:rgba(255,255,255,0.25);fill:none;
        stroke-width:1.2;stroke-linecap:round;stroke-linejoin:round;
        }
        .dz-hint{color:rgba(255,255,255,0.4);font-size:14px;text-align:center;}
        .dz-hint strong{color:rgba(255,255,255,0.75);}
        .dz-input{display:none;}
        /* ── File list ── */
        .file-list{width:100%;display:flex;flex-direction:column;gap:8px;}
        .file-item{
        background:rgba(255,255,255,0.04);
        border:0.5px solid rgba(255,255,255,0.08);
        border-radius:14px;padding:12px 16px;
        display:flex;align-items:center;gap:12px;
        backdrop-filter:blur(8px);-webkit-backdrop-filter:blur(8px);
        transition:background 0.15s;
        }
        .file-item:hover{background:rgba(255,255,255,0.07);}
        .file-icon{flex-shrink:0;}
        .file-icon svg{
        width:20px;height:20px;stroke:rgba(255,255,255,0.4);fill:none;
        stroke-width:1.6;stroke-linecap:round;stroke-linejoin:round;
        }
        .file-info{flex:1;min-width:0;}
        .file-name{
        font-size:13px;font-weight:500;color:#fff;
        overflow:hidden;text-overflow:ellipsis;white-space:nowrap;
        }
        .file-size{font-size:11px;color:rgba(255,255,255,0.35);margin-top:2px;}
        .file-status{font-size:11px;flex-shrink:0;font-variant-numeric:tabular-nums;}
        .file-status.waiting  {color:rgba(255,255,255,0.3);}
        .file-status.uploading{color:#60a5fa;}
        .file-status.done     {color:#4ade80;}
        .file-status.error    {color:#f87171;}
        .file-progress{
        width:100%;height:3px;
        background:rgba(255,255,255,0.08);
        border-radius:999px;margin-top:8px;overflow:hidden;
        }
        .file-progress-fill{
        height:100%;width:0;border-radius:999px;
        background:rgba(255,255,255,0.7);
        transition:width 0.2s;
        }
        .file-progress-fill.done {background:#4ade80;}
        .file-progress-fill.error{background:#f87171;}
        .file-remove{
        width:24px;height:24px;border-radius:50%;border:none;
        background:transparent;color:rgba(255,255,255,0.25);
        display:grid;place-items:center;cursor:pointer;flex-shrink:0;
        transition:background 0.15s,color 0.15s;
        }
        .file-remove:hover{background:rgba(255,255,255,0.1);color:#fff;}
        .file-remove svg{
        width:14px;height:14px;stroke:currentColor;fill:none;
        stroke-width:2;stroke-linecap:round;
        }
        /* ── Bottom bar ── */
        .bottom-bar{
        width:100%;display:flex;align-items:center;gap:12px;
        padding:4px 0;
        }
        .summary{flex:1;font-size:13px;color:rgba(255,255,255,0.35);}
        .btn-upload{
        background:rgba(255,255,255,0.1);
        backdrop-filter:blur(16px) saturate(1.5);
        -webkit-backdrop-filter:blur(16px) saturate(1.5);
        border:0.5px solid rgba(255,255,255,0.18);
        border-radius:999px;padding:10px 24px;
        color:#fff;font-size:13px;font-weight:500;
        cursor:pointer;flex-shrink:0;
        transition:background 0.15s,transform 0.1s;
        box-shadow:0 0 0 1px rgba(0,0,0,0.2),0 4px 16px rgba(0,0,0,0.3);
        }
        .btn-upload:hover{background:rgba(255,255,255,0.18);}
        .btn-upload:active{transform:scale(0.97);}
        .btn-upload:disabled{opacity:0.35;cursor:not-allowed;}
        .btn-clear{
        background:transparent;
        border:0.5px solid rgba(255,255,255,0.1);
        border-radius:999px;padding:10px 20px;
        color:rgba(255,255,255,0.45);font-size:13px;
        cursor:pointer;flex-shrink:0;
        transition:background 0.15s,color 0.15s;
        }
        .btn-clear:hover{background:rgba(255,255,255,0.06);color:#fff;}
        </style>
        </head>
        <body>
        <div class="bg-glow"></div>
        <header>
        <a href="/">&#8592; Back</a>
        <span class="hd-title">Share Files To Computer</span>
        </header>
        <div class="wrap">
        <div class="dropzone-area" id="dz-area">
            <div class="dz-icon">
            <svg viewBox="0 0 48 48">
                <polyline points="44,30 44,42 4,42 4,30"/>
                <polyline points="16,18 24,10 32,18"/>
                <line x1="24" y1="10" x2="24" y2="32"/>
            </svg>
            </div>
            <div class="dz-hint"><strong>Click to select</strong> or drag &amp; drop files here</div>
            <div class="dz-hint" style="font-size:12px;">Any file type &bull; No size limit</div>
            <input type="file" id="dz-input" class="dz-input" multiple>
        </div>
        <div class="file-list" id="file-list"></div>
        <div class="bottom-bar" id="bottom-bar" style="display:none;">
            <span class="summary" id="summary">0 files</span>
            <button class="btn-clear" id="btn-clear">Clear</button>
            <button class="btn-upload" id="btn-upload">Upload All</button>
        </div>
        </div>
        <script>
        const dzArea   =document.getElementById('dz-area');
        const dzInput  =document.getElementById('dz-input');
        const fileList =document.getElementById('file-list');
        const bottomBar=document.getElementById('bottom-bar');
        const summary  =document.getElementById('summary');
        const btnUpload=document.getElementById('btn-upload');
        const btnClear =document.getElementById('btn-clear');

        let files=[],uid=0;

        function fmtSize(b){
        if(b<1024) return b+' B';
        if(b<1048576) return (b/1024).toFixed(1)+' KB';
        if(b<1073741824) return (b/1048576).toFixed(1)+' MB';
        return (b/1073741824).toFixed(2)+' GB';
        }
        function escHtml(s){
        return s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
        }

        function addFiles(newFiles){
        Array.from(newFiles).forEach(f=>{
            const id=++uid;
            const item=document.createElement('div');
            item.className='file-item';
            item.id='fi-'+id;
            item.innerHTML=
            '<div class="file-icon"><svg viewBox="0 0 18 18"><path d="M4 2h7l4 4v10a1 1 0 01-1 1H4a1 1 0 01-1-1V3a1 1 0 011-1z"/><polyline points="11,2 11,6 15,6"/></svg></div>'+
            '<div class="file-info">'+
                '<div class="file-name">'+escHtml(f.name)+'</div>'+
                '<div class="file-size">'+fmtSize(f.size)+'</div>'+
                '<div class="file-progress"><div class="file-progress-fill" id="bar-'+id+'"></div></div>'+
            '</div>'+
            '<span class="file-status waiting" id="st-'+id+'">Waiting</span>'+
            '<button class="file-remove" id="rm-'+id+'" title="Remove">'+
                '<svg viewBox="0 0 14 14"><line x1="2" y1="2" x2="12" y2="12"/><line x1="12" y1="2" x2="2" y2="12"/></svg>'+
            '</button>';
            fileList.appendChild(item);
            document.getElementById('rm-'+id).addEventListener('click',()=>removeFile(id));
            files.push({
            id,file:f,
            statusEl:document.getElementById('st-'+id),
            barEl:   document.getElementById('bar-'+id),
            itemEl:  item,
            state:   'waiting'
            });
        });
        updateBar();
        }

        function removeFile(id){
        files=files.filter(f=>{ if(f.id===id){f.itemEl.remove();return false;} return true; });
        updateBar();
        }

        function updateBar(){
        const waiting=files.filter(f=>f.state==='waiting').length;
        const total=files.length;
        if(total===0){bottomBar.style.display='none';return;}
        bottomBar.style.display='flex';
        const done=total-waiting;
        summary.textContent=total+' file'+(total>1?'s':'')+(done>0?' \u2022 '+done+' done':'');
        btnUpload.disabled=waiting===0;
        }

        async function uploadFile(entry){
        entry.state='uploading';
        entry.statusEl.className='file-status uploading';
        entry.statusEl.textContent='0%';
        entry.barEl.style.width='0%';
        return new Promise(resolve=>{
            const xhr=new XMLHttpRequest();
            const fd=new FormData();
            fd.append('file',entry.file);
            xhr.upload.addEventListener('progress',e=>{
            if(!e.lengthComputable)return;
            const pct=Math.round(e.loaded/e.total*100);
            entry.barEl.style.width=pct+'%';
            entry.statusEl.textContent=pct+'%';
            });
            xhr.addEventListener('load',()=>{
            if(xhr.status>=200&&xhr.status<300){
                entry.state='done';
                entry.statusEl.className='file-status done';
                entry.statusEl.textContent='Done';
                entry.barEl.className='file-progress-fill done';
                entry.barEl.style.width='100%';
            } else {
                entry.state='error';
                entry.statusEl.className='file-status error';
                entry.statusEl.textContent='Error';
                entry.barEl.className='file-progress-fill error';
            }
            document.getElementById('rm-'+entry.id).style.display='none';
            resolve();
            });
            xhr.addEventListener('error',()=>{
            entry.state='error';
            entry.statusEl.className='file-status error';
            entry.statusEl.textContent='Error';
            entry.barEl.className='file-progress-fill error';
            resolve();
            });
            xhr.open('POST','/Upload');
            xhr.send(fd);
        });
        }

        btnUpload.addEventListener('click',async()=>{
        btnUpload.disabled=true;
        btnClear.disabled=true;
        const queue=files.filter(f=>f.state==='waiting');
        for(const entry of queue){
            await uploadFile(entry);
            updateBar();
        }
        btnClear.disabled=false;
        updateBar();
        });

        btnClear.addEventListener('click',()=>{
        files.forEach(f=>f.itemEl.remove());
        files=[];
        updateBar();
        });

        dzArea.addEventListener('click',()=>dzInput.click());
        dzInput.addEventListener('change',()=>{addFiles(dzInput.files);dzInput.value='';});
        dzArea.addEventListener('dragover', e=>{e.preventDefault();dzArea.classList.add('dragover');});
        dzArea.addEventListener('dragleave',()=>dzArea.classList.remove('dragover'));
        dzArea.addEventListener('drop',e=>{
        e.preventDefault();
        dzArea.classList.remove('dragover');
        addFiles(e.dataTransfer.files);
        });
        </script>
        </body>
        </html>""";
    }
}