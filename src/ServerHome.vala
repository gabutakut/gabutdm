/*
* Copyright (c) {2024} torikulhabib (https://github.com/gabutakut)
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
        return @"
        <html>
        <head>
            <title>Welcome to Gabut Akut</title>
        </head>
        <body>
        <style>
            $(get_gbt_css ())
        </style>
        <div class=\"container\">
            <div class=\"row\">
                <div class=\"col-md-11 col-xs-10\"><a href=\"/\"><span class=\"logo\"><strong class=\"strong\">G</strong>ABUT</span></a></div>
                <div class=\"col-md-1 col-xs-2\">
                    <p class=\"nav-button\">
                    <button id=\"trigger-overlay\" onclick=\"openMenu()\" type=\"button\">
                    <i class=\"icon open\"></i>
                </div>
            </div>
        </div>
        <div class=\"container\">
            <div class=\"starting\">
                <div class=\"row\">
                    <div class=\"col-md-6\">
                        <h2 class=\"animated fadeInLeft\"><strong class=\"strong\">Download Manger</strong><br></h2>
                        <p class=\"animated fadeInLeft\">
                            Gabut download manager support Metallink Magnetlink Torrent URIs with simple and modern style.
                            Gabut runing with the Aria2 RPC method.
                        </p>
                        <a href=\"/Downloading\" class=\"btn btn-primary btn-lg active animated fadeInLeft\" id=\"buttongo\">
                        <strong>Download</strong>
                        <br/>Manager </a>
                    </div>
                    <div class=\"col-md-6\">
                        <h2 class=\"animated fadeInLeft\"><strong class=\"strong\">File Transfer</strong><br></h2>
                        <p class=\"animated fadeInLeft\">
                            Gabut File Trensfer is options to Send file on your smartphone or other pc to send file to this manager or explore your file share.
                        </p>
                        <a align=\"end\" href=\"/Upload\" class=\"btn btn-primary btn-lg active animated fadeInLeft\" id=\"buttongo\">
                        <strong>File</strong>
                        <br/>Transfer </a>
                        <a align=\"start\" href=\"/Home\" class=\"btn btn-primary btn-lg active animated fadeInLeft\" id=\"buttongo\">
                        <strong>File</strong>
                        <br/>Sharing </a>
                    </div>
                </div>
            </div>
        </div>
        <div id=\"myOverlay\" class=\"overlay animated fadeInDownBig\">
            <span class=\"closebtn\" onclick=\"closeMenu()\" title=\"Close Overlay\"> <i class=\"icon closew\"></i></span>
            <div class=\"overlay-content\">
                <nav>
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
        <style>
            $(get_css(file_config (".bootstrap.min.css")))
        </style>
        </body>
        </html>
        ";
    }
}