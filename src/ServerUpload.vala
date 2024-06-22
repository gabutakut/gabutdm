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
    public string get_upload () {
        return @"
        <html>
        <head>
            <title>Share File To Computer</title>
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
            <div class=\"row\">
                <h2 class=\"strong fadeInLeft animated\">Send Multiple File</h2>
                <form id=\"gabut-dropzone\" action=\"/Upload\" class=\"dropzone fadeInLeft animated\">
                    <div class=\"fallback\">
                        <input name=\"file\" type=\"file\" multiple />
                    </div>
                </form>
            </div>
        </div>
        <div id=\"myOverlay\" class=\"overlay animated fadeInDownBig\">
            <span class=\"closebtn\" onclick=\"closeMenu()\" title=\"Close\"> <i class=\"icon closew\"></i></span>
            <div class=\"overlay-content\">
                <nav>
                    <h2 class=\"metadata\">Open link On Browser PC</h2>
                    <form class=\"text\" action=\"/Upload\" method=\"post\" enctype=\"text/plain\">
                        <input class=\"form-control\" type=\"text\" placeholder=\"Paste Here..\" name=\"openlink\">
                        <button class=\"btn btn-primary btn-lg active\">Open</button>
                    </form>
                </nav>
            </div>
        </div>
        <script>
            $(get_css(file_config (".dropzone.min.js")))
        </script>
        <script>
            Dropzone.options.gabutDropzone = {
                maxFilesize: 50000,
                dictDefaultMessage: \"Drop files here to send\"
            }
        </script>
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
        <style>
            $(get_css(file_config (".dropzone.min.css")))
        </style>
        </body>
        </html>
    ";
    }
}