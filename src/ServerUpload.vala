/*
* Copyright (c) {2021} torikulhabib (https://github.com/gabutakut)
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
    public class ServerUpload : GLib.Object {
        public string get_upload () {
            return @"
                <html>
                <head>
                <style>
                    $(ServerCss.get_css);
                </style>
                <style>
                    $(get_css(create_folder (".bootstrap.min.css")));
                </style>
                    <title>Share File To Computer</title>
                </head>
                <body>
                <div class=\"container\">
                    <div class=\"navigation\" id=\"navigation-scroll\">
                        <div class=\"row\">
                            <div class=\"col-md-11 col-xs-10\">
                                <a href=\"/\"><span id=\"logo\"><strong class=\"strong\">G</strong>ABUT</span></a>
                                </div>
                                <div class=\"col-md-1 col-xs-2\">
                                    <p class=\"nav-button\">
                                    <button id=\"trigger-overlay\" onclick=\"openMenu()\" type=\"button\">
                                    <b class=\"openBtn\">Open</b>
                            </div>
                        </div>
                    </div>
                </div>
                <section id=\"header\" class=\"header\">
                    <div class=\"top-bar\">
                        <div class=\"container\">
                            <div class=\"starting\">
                                <div class=\"row\">
                                    <div class=\"col-md-6\">
                                        <div id=\"imgdata\"></div>
                                        <div id=\"videodata\"></div>
                                        <div id=\"audiodata\"></div>
                                        <div id=\"pdfdata\"></div>
                                        <div class=\"banner-text\"></div>
                                    </div>
                                    <div class=\"col-md-6\">
                                        <div class=\"banner-text\">
                                        <h2><div class=\"fadeInLeft animated\" id=\"labelsend\">Send File to Gabut</div></h2>
                                        <form class=\"files fadeInLeft animated\"  action=\"/Upload\" method=\"post\" enctype=\"multipart/form-data\">
                                            <input class=\"form-control\" type=\"file\" id=\"uploader\" name=\"file[]\"/>
                                            <button class=\"btn btn-primary btn-lg active\">Send</button>
                                        </form>
                                        <div id=\"prgdata\"></div>
                                        <label id=\"progresslabel\" for=\"progress\"></label>
                                        <div id=\"metadata\"></div>
                                        <div class=\"banner-text\">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
                <div id=\"myOverlay\" class=\"overlay animated fadeInDownBig\">
                    <span class=\"closebtn\" onclick=\"closeMenu()\" title=\"Close Overlay\">x</span>
                    <div class=\"overlay-content\">
                        <nav>
                        <ul>
                            <li class=\"hideit\"><a href=\"/\">Home</a></li>
                        </ul>
                    </nav>
                    </div>
                </div>
                <script>
                    const fileUploader = document.getElementById(\"uploader\");
                    fileUploader.addEventListener(\"change\", (event) => {
                        const reader = new FileReader();
                        const files = event.target.files;
                        const file = files[0];
                        reader.readAsDataURL(file);
                        if (event.loaded && event.total) {
                            const percent = (event.loaded / event.total) * 100;
                            progress.value = percent;
                        }
                        removeAllChildNodes(prgdata);
                        const prg = document.createElement('progress');
                        prg.setAttribute('value','0');
                        prg.setAttribute('max','100');
                        prg.id = \"progress\";
                        prgdata.appendChild(prg);
                        reader.addEventListener(\"progress\", (event) => {
                            if (event.loaded && event.total) {
                                const percent = (event.loaded / event.total) * 100;
                                progress.value = percent;
                                document.getElementById(\"progresslabel\").innerHTML = Math.round(percent) + \"%\";
                                if (percent === 100) {
                                    for (const file of files) {
                                        const name = file.name;
                                        const type = file.type;
                                        const size = file.size;
                                        const lastModified = file.lastModified;
                                        const msg = `File Name: $(set_dollar ("{name}")) <br/>
                                                File Size: $(set_dollar ("{returnFileSize (size)}")) <br/>
                                                File type: $(set_dollar ("{type}")) <br/>
                                                File Last Modified: $(set_dollar ("{new Date(lastModified)}"))`;
                                        metadata.innerHTML = msg;
                                        removeAllChildNodes(imgdata);
                                        removeAllChildNodes(videodata);
                                        removeAllChildNodes(audiodata);
                                        removeAllChildNodes(pdfdata);
                                        if (file.type == 'image/png' || file.type == 'image/jpeg') {
                                            const img = document.createElement('img');
                                            imgdata.appendChild(img);
                                            img.src = URL.createObjectURL(file);
                                            img.alt = file.name;
                                            img.className = \"img-rounded\";
                                        }
                                        if (file.type == 'video/mp4' || file.type == 'video/mpeg' || file.type == 'video/x-matroska' || file.type == 'video/x-flv' || file.type == 'video/webm') {
                                            const vdo = document.createElement('video');
                                            vdo.setAttribute('controls','true');
                                            vdo.setAttribute('width','550');
                                            vdo.setAttribute('height','300');
                                            vdo.id = \"vdosrc\";
                                            videodata.appendChild(vdo);
                                            const vsrc = document.createElement('source');
                                            vdosrc.appendChild(vsrc);
                                            vsrc.src = URL.createObjectURL(file);
                                            vsrc.type = file.type;
                                        }
                                        if (file.type == 'audio/mpeg' || file.type == 'audio/x-m4a' || file.type == 'audio/flac' || file.type == 'audio/ogg' || file.type == 'audio/wav') {
                                            const ado = document.createElement('audio');
                                            ado.setAttribute('controls','true');
                                            ado.id = \"adosrc\";
                                            audiodata.appendChild(ado);
                                            const vsrc = document.createElement('source');
                                            adosrc.appendChild(vsrc);
                                            vsrc.src = URL.createObjectURL(file);
                                            vsrc.type = file.type;
                                        }
                                        if (file.type == 'application/pdf') {
                                            const pdf = document.createElement('object');
                                            pdf.setAttribute('height','500px');
                                            pdf.setAttribute('width','100%');
                                            pdf.data = URL.createObjectURL(file);
                                            pdf.type = file.type;
                                            pdfdata.appendChild(pdf);
                                        }
                                    }
                                }
                            }
                        });
                    });
                    function returnFileSize(number) {
                        if (number < 1024) {
                            return number + 'bytes';
                        } else if (number >= 1024 && number < 1048576) {
                            return (number / 1024).toFixed(2) + 'KB';
                        } else if (number >= 1048576) {
                            return (number / 1048576).toFixed(2) + 'MB';
                        }
                    }
                    function removeAllChildNodes(parent) {
                        while (parent.firstChild) {
                            parent.removeChild(parent.firstChild);
                        }
                    }
                    function openMenu() {
                        document.getElementById(\"myOverlay\").style.display = \"block\";
                    }
                    function closeMenu() {
                        document.getElementById(\"myOverlay\").style.display = \"none\";
                    }
                </script>
                </body>
                </html>
            ";
        }
    }
}