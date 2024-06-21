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
    public string get_complete (DownloadRow row) {
        return @"
        <html>
        <head>
            <title>Download Complete</title>
        </head>
        <body>
        <style>
            $(get_gbt_css ())
        </style>
        <div class=\"container\">
            <div class=\"card\">
                <div class=\"path\"><h4 class=\"dialog complete\">$(row.url)</h4></div>
                <div class=\"row\"><div class=\"col-md-6 text-center align-self-center\"><bigicon class=\"icon $(get_mime_css (row.fileordir))\"></div>
                    <div class=\"col-md-6 info dialog complete\">
                        <div class=\"row title\">
                            <div class=\"col\"><h2>$(row.filename)</h2></div>
                            <div class=\"col\"><h4>Size:$(GLib.format_size (row.totalsize, GLib.FormatSizeFlags.LONG_FORMAT).to_ascii ())</h4></div>
                            <div class=\"col\"><h4>Transfered:$(GLib.format_size (row.transferred, GLib.FormatSizeFlags.LONG_FORMAT).to_ascii ())</h4></div>
                            <div class=\"col\"><h4>Type:$(row.fileordir)</h4></div>
                            <div class=\"col\"><h4>Path:$(row.pathname)</h4></div>
                            <div class=\"col\"><h4>Status:Complete</h4></div>
                            <div class=\"col text-right align-self-center\"><form action=\"/Complete\" method=\"get\"><input type=\"submit\" value=\"Back to DM\" class=\"btn btn-primary btn-lg active\"/></form></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <style>
            $(get_css(file_config (".bootstrap.min.css")))
        </style>
        <style>
            body{
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 0.8rem;
            }
            .card{
                max-width: 1200px;
                width: 100%;
                padding: 4rem;
                background: #2C3539;
                color: white;
                box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19)
            }
            @media(max-width:800px){
                .card{
                    width: 100%;
                    padding: 1.5rem
                }
            }
            .row{
                margin: 0
            }
            .path{
                color: grey;
                margin-bottom: 1rem
            }
            .info{
                padding: 6vh 0vh
            }

            @media(max-width:800px){
                .info{
                    padding: 0
                }
            }
            bigicon{
                height: fit-content;
                width: 75%;
                padding: 1rem
            }
            @media(max-width:800px){
                bigicon{
                    padding: 2.5rem 0
                }
            }
            .dialog.complete {
                flex: 1;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }
        </style>
        </body>
        </html>
    ";
    }
}