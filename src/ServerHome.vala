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
    public class ServerHome : GLib.Object {
        public string get_home () {
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
                                    </button>
                                </div>
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
                                        <div class=\"banner-text\"></div>
                                        <h2 class=\"animated fadeInLeft\"><strong class=\"strong\" id=\"labelsend\">Download Manger</strong><br></h2>
                                        <p class=\"animated fadeInLeft\">
                                            Gabut download manager support Metallink Magnetlink Torrent URIs with simple and modern style.
                                            Gabut runing with the Aria2 RPC method.
                                        </p>
                                        <a href=\"/Downloading\" class=\"btn btn-primary btn-lg active animated fadeInLeft\" id=\"buttongo\">
                                        <strong>Download</strong>
                                        <br/>Manager </a>
                                        <div class=\"banner-text\"></div>
                                    </div>
                                    <div class=\"col-md-6\">
                                        <div class=\"banner-text\"></div>
                                        <h2 class=\"animated fadeInLeft\"><strong class=\"strong\" id=\"labelsend\">File Transfer</strong><br></h2>
                                        <p class=\"animated fadeInLeft\">
                                            Gabut File Trensfer is options to Send file on your smartphone or other pc to send file to this manager.
                                        </p>
                                        <a align=\"end\" href=\"/Upload\" class=\"btn btn-primary btn-lg active animated fadeInLeft\" id=\"buttongo\">
                                        <strong>File</strong>
                                        <br/>Transfer </a>
                                        <div class=\"banner-text\"></div>
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
                            <li class=\"hideit\"><a href=\"/Downloading\">Downloading</a></li>
                            <li class=\"hideit\"><a href=\"/Paused\">Paused</a></li>
                            <li class=\"hideit\"><a href=\"/Complete\">Complete</a></li>
                            <li class=\"hideit\"><a href=\"/Waiting\">Waiting</a></li>
                            <li class=\"hideit\"><a href=\"/Error\">Error</a></li>
                        </ul>
                    </nav>
                    </div>
                </div>
                <script>
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