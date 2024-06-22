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
    public string get_share (string path, string share, string opcl, string username) {
        if (path == "/") {
            path = "/Home";
        }
        return @"
        <html>
        <head>
            <title>File Sharing</title>
        </head>
        <meta http-equiv=\"Content-Type\" content=\"text/html; charset=big5\"/>
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
            <div class=\"active animated $(opcl)\">
                $(share)
            </div>
        </div>
        <div id=\"myOverlay\" class=\"overlay animated fadeInDownBig\">
            <span class=\"closebtn\" onclick=\"closeMenu()\" title=\"Close\"><i class=\"icon closew\"></i></span>
            <div class=\"overlay-content\">
                <nav>
                    <form action=\"$(path)\" method=\"POST\">
                        <select name=\"sort\">
                            <option $(get_shorted (0, username))Sort By Name</option>
                            <option $(get_shorted (1, username))Sort By Size</option>
                            <option $(get_shorted (2, username))Sort By Type</option>
                            <option $(get_shorted (3, username))Sort By Date</option>
                        </select>
                        <input type=\"submit\" class=\"btn btn-primary btn-lg active\" value=\"Submit\">
                    </form>
                </nav>
            </div>
        </div>
        <style>
            $(get_css(file_config (".bootstrap.min.css")))
        </style>
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