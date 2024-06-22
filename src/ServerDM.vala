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
    public string get_dm (string pathname, string htmlstr, string javascr, string username) {
        string errordm = "<div align=\"center\"><a class=\"icon error\"></a><h1>Nothing Error file Download</h1></div>";
        string activedm = "<div align=\"center\"><a class=\"icon playing\"></a><h1>Nothing Active file Download</h1></div>";
        string pauseddm = "<div align=\"center\"><a class=\"icon paused\"></a><h1>Nothing Paused file Download</h1></div>";
        string waitdm = "<div align=\"center\"><a class=\"icon waiting\"></a><h1>No Waiting file Download</h1></div>";
        string completedm = "<div align=\"center\"><a class=\"icon complete\"></a><h1>Nothing Complete file Download</h1></div>";
        if (pathname == "Downloading") {
            if (htmlstr != "") {
                activedm = htmlstr;
            }
        } else if (pathname == "Paused") {
            if (htmlstr != "") {
                pauseddm = htmlstr;
            }
        } else if (pathname == "Complete") {
            if (htmlstr != "") {
                completedm = htmlstr;
            }
        } else if (pathname == "Waiting") {
            if (htmlstr != "") {
                waitdm = htmlstr;
            }
        } else if (pathname == "Error") {
            if (htmlstr != "") {
                errordm = htmlstr;
            }
        }
        return @"
        <html>
        <head>
            <title>Gabut Download Manager</title>
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
        <header>
            <button class=\"tablink btn btn-primary btn-lg active\" onclick=\"openPage(\'Downloading\', this, \'#165391\')\"id=\"downloading\">Downloading</button>
            <button class=\"tablink btn btn-primary btn-lg active\" onclick=\"openPage(\'Paused\', this, \'#165391\')\"id=\"paused\">Paused</button>
            <button class=\"tablink btn btn-primary btn-lg active\" onclick=\"openPage(\'Complete\', this, \'#165391\')\"id=\"complete\">Complete</button>
            <button class=\"tablink btn btn-primary btn-lg active\" onclick=\"openPage(\'Waiting\', this, \'#165391\')\"id=\"waiting\">Waiting</button>
            <button class=\"tablink btn btn-primary btn-lg active\" onclick=\"openPage(\'Error\', this, \'#165391\')\"id=\"error\">Error</button>
        </header>
        <div id=\"Downloading\" class=\"tabcontent\">
            $(activedm)
        </div>
        <div id=\"Paused\" class=\"tabcontent\">
            $(pauseddm)
        </div>
        <div id=\"Complete\" class=\"tabcontent\">
            $(completedm)
        </div>
        <div id=\"Waiting\" class=\"tabcontent\">
            $(waitdm)
        </div>
        <div id=\"Error\" class=\"tabcontent\">
            $(errordm)
        </div>
        <div id=\"myOverlay\" class=\"overlay animated fadeInDownBig\">
            <span class=\"closebtn\" onclick=\"closeMenu()\" title=\"Close Overlay\"> <i class=\"icon closew\"></i></span>
        <div class=\"overlay-content\">
            <nav>
                <form action=\"/$(pathname)\" method=\"POST\">
                    <select name=\"sort\">
                        <option $(get_shorted (0, username))Sort By Name</option>
                        <option $(get_shorted (1, username))Sort By Size</option>
                        <option $(get_shorted (2, username))Sort By Type</option>
                        <option $(get_shorted (3, username))Sort By Date</option>
                    </select>
                    <input type=\"submit\" class=\"btn btn-primary btn-lg active\" value=\"Submit\">
                </form>
                <h2 class=\"metadata\">Insert address</h2>
                <form class=\"text\" action=\"/$(pathname)\" method=\"post\" enctype=\"text/plain\">
                    <input class=\"form-control\" type=\"text\" placeholder=\"Paste Here..\" name=\"gabutlink\">
                    <button class=\"btn btn-primary btn-lg active\">Open</button>
                </form>
                <h2 class=\"metadata\">Torrent or Metalink</h2>
                <form class=\"files\"  action=\"/$(pathname)\" method=\"post\" enctype=\"multipart/form-data\">
                    <input class=\"form-control\" type=\"file\" id=\"uploader\" name=\"file[]\" accept=\".torrent, application/x-bittorrent, .metalink, application/metalink+xml\"/>
                    <button class=\"btn btn-primary btn-lg active\">Open</button>
                </form>
            </nav>
        </div>
        $(javascr)
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
        <script>
            if ( window.history.replaceState ) {
                window.history.replaceState( null, null, window.location.href );
            }
        </script>
        <style>
            $(get_css(file_config (".bootstrap.min.css")))
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