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
    public string get_dm (string pathname, string htmlstr) {
        return @"
        <html>
        <head>
            <title>Gabut Download Manager</title>
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
                        <i class=\"icon open\"></i>
                    </div>
                </div>
            </div>
        </div>
        <header>
            <button class=\"tablink btn btn-primary btn-lg active\" onclick=\"openPage(\'Downloading\', this, \'#165391\')\"id=\"downloading\">Downloading</button>
            <button class=\"tablink btn btn-primary btn-lg active\" onclick=\"openPage(\'Paused\', this, \'#165391\')\"id=\"paused\">Paused</button>
            <button class=\"tablink btn btn-primary btn-lg active\" onclick=\"openPage(\'Complete\', this, \'#165391\')\"id=\"complete\">Complete</button>
            <button class=\"tablink btn btn-primary btn-lg active\" onclick=\"openPage(\'Waiting\', this, \'#165391\')\"id=\"waiting\">Waiting</button>
            <button class=\"tablink btn btn-primary btn-lg active\" onclick=\"openPage(\'Error\', this, \'#165391\')\"id=\"error\">Error</button>
        </header>
        <div id=\"Downloading\" class=\"tabcontent\">
            $(htmlstr)
        </div>

        <div id=\"Paused\" class=\"tabcontent\">
            $(htmlstr)
        </div>
    
        <div id=\"Complete\" class=\"tabcontent\">
            $(htmlstr)
        </div>

        <div id=\"Waiting\" class=\"tabcontent\">
            $(htmlstr)
        </div>

        <div id=\"Error\" class=\"tabcontent\">
            $(htmlstr)
        </div>
        <div id=\"myOverlay\" class=\"overlay animated fadeInDownBig\">
            <span class=\"closebtn\" onclick=\"closeMenu()\" title=\"Close Overlay\"> <i class=\"icon closew\"></i></span>
        <div class=\"overlay-content\">
                <nav>
                <ul>
                <h2 id=\"metadata\">Insert address</h2>
                <form class=\"text\" action=\"$(pathname)\" method=\"post\" enctype=\"text/plain\">
                    <input class=\"form-control\" type=\"text\" placeholder=\"Paste Here..\" name=\"gabutlink\">
                    <button class=\"btn btn-primary btn-lg active\">Open</button>
                </form>
                <h2 id=\"metadata\">Torrent or Metalink</h2>
                <form class=\"files\"  action=\"$(pathname)\" method=\"post\" enctype=\"multipart/form-data\">
                    <input class=\"form-control\" type=\"file\" id=\"uploader\" name=\"file[]\" accept=\".torrent, application/x-bittorrent, .metalink, application/metalink+xml\"/>
                    <button class=\"btn btn-primary btn-lg active\">Open</button>
                </form>
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
            function openPage(pageName, elmnt, color) {
                var i, tabcontent, tablinks;
                tabcontent = document.getElementsByClassName (\"tabcontent\");
                for (i = 0; i < tabcontent.length; i++) {
                    tabcontent[i].style.display = \"none\";
                }
                tablinks = document.getElementsByClassName (\"tablink\");
                for (i = 0; i < tablinks.length; i++) {
                    tablinks[i].style.backgroundColor = \"transparent\";
                }
                document.getElementById (pageName).style.display = \"block\";
                elmnt.style.backgroundColor = color;
                if (pageName != \'$(pathname)\') {
                    window.location.href='/' + pageName;
                }
            }
            document.getElementById (\"$(pathname.down ())\").click();
        </script>
        <style>
            $(get_gbt_css ());
        </style>
        <style>
            $(get_css(file_config (".bootstrap.min.css")));
        </style>
        <style>
            .tablink {
                color: white;
                float: left;
                border: none;
                outline: none;
                cursor: pointer;
                padding: 14px 16px;
                font-size: 14px;
                width: 20%;
            }
            .tabcontent {
                color: white;
                display: none;
                padding: 100px 20px;
            }
        </style>
        </body>
        </html>
        ";
    }
}
