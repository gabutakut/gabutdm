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
    public string get_not_found () {
        return @"
        <html>
        <head>
            <title>Not Found</title>
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
                <p class=\"zoom-area\"><b>Gabut</b> Sharing is disabled, activate check sharing button</p>
                    <section class=\"error-container\">
                        <span>4</span>
                        <span><span class=\"screen-reader-text\">0</span></span>
                        <span>4</span>
                    </section>
                </div>
            </div>
        </div>
        <div id=\"myOverlay\" class=\"overlay animated fadeInDownBig\">
            <span class=\"closebtn\" onclick=\"closeMenu()\" title=\"Close\"> <i class=\"icon closew\"></i></span>
            <div class=\"overlay-content\">
                <nav>
                </nav>
            </div>
        </div>
        <style>
            $(get_css(file_config (".bootstrap.min.css")))
        </style>
        <style>
            .error-container {
                text-align: center;
                font-size: 180px;
                font-family: 'Catamaran', sans-serif;
                font-weight: 800;
                margin: 20px 15px;
            }
            .error-container > span {
                display: inline-block;
                line-height: 0.7;
                position: relative;
                color: #FFB485;
            }
            .error-container > span {
                display: inline-block;
                position: relative;
                vertical-align: middle;
            }
            .error-container > span:nth-of-type(1) {
                color: #D1F2A5;
                animation: colordancing 4s infinite;
            }
            .error-container > span:nth-of-type(3) {
                color: #F56991;
                animation: colordancing2 4s infinite;
            }
            .error-container > span:nth-of-type(2) {
                width: 120px;
                height: 120px;
                border-radius: 999px;
            }
            .error-container > span:nth-of-type(2):before,
            .error-container > span:nth-of-type(2):after {
                border-radius: 0%;
                content:\"\";
                position: absolute;
                top: 0; left: 0;
                width: inherit; height: inherit;
                border-radius: 999px;
                    box-shadow: inset 30px 0 0 rgba(209, 242, 165, 0.4),
                                inset 0 30px 0 rgba(239, 250, 180, 0.4),
                                inset -30px 0 0 rgba(255, 196, 140, 0.4),	
                                inset 0 -30px 0 rgba(245, 105, 145, 0.4);
                animation: shadowsdancing 4s infinite;
            }
            .error-container > span:nth-of-type(2):before {
                -webkit-transform: rotate(45deg);
                -moz-transform: rotate(45deg);
                        transform: rotate(45deg);
            }
            .screen-reader-text {
                position: absolute;
                top: -9999em;
                left: -9999em;
            }
            @keyframes shadowsdancing {
                0% {
                    box-shadow: inset 30px 0 0 rgba(209, 242, 165, 0.4),
                                inset 0 30px 0 rgba(239, 250, 180, 0.4),
                                inset -30px 0 0 rgba(255, 196, 140, 0.4),	
                                inset 0 -30px 0 rgba(245, 105, 145, 0.4);
                }
                25% {
                    box-shadow: inset 30px 0 0 rgba(245, 105, 145, 0.4),
                                inset 0 30px 0 rgba(209, 242, 165, 0.4),
                                inset -30px 0 0 rgba(239, 250, 180, 0.4),	
                                inset 0 -30px 0 rgba(255, 196, 140, 0.4);
                }
                50% {
                    box-shadow: inset 30px 0 0 rgba(255, 196, 140, 0.4),
                                inset 0 30px 0 rgba(245, 105, 145, 0.4),
                                inset -30px 0 0 rgba(209, 242, 165, 0.4),	
                                inset 0 -30px 0 rgba(239, 250, 180, 0.4);
                }
                75% {
                box-shadow: inset 30px 0 0 rgba(239, 250, 180, 0.4),
                                inset 0 30px 0 rgba(255, 196, 140, 0.4),
                                inset -30px 0 0 rgba(245, 105, 145, 0.4),	
                                inset 0 -30px 0 rgba(209, 242, 165, 0.4);
                }
                100% {
                    box-shadow: inset 30px 0 0 rgba(209, 242, 165, 0.4),
                                inset 0 30px 0 rgba(239, 250, 180, 0.4),
                                inset -30px 0 0 rgba(255, 196, 140, 0.4),	
                                inset 0 -30px 0 rgba(245, 105, 145, 0.4);
                }
            }
            @keyframes colordancing {
                0% {
                    color: #D1F2A5;
                }
                25% {
                    color: #F56991;
                }
                50% {
                    color: #FFC48C;
                }
                75% {
                    color: #EFFAB4;
                }
                100% {
                    color: #D1F2A5;
                }
            }
            @keyframes colordancing2 {
                0% {
                    color: #FFC48C;
                }
                25% {
                    color: #EFFAB4;
                }
                50% {
                    color: #D1F2A5;
                }
                75% {
                    color: #F56991;
                }
                100% {
                    color: #FFC48C;
                }
            }
            .zoom-area { 
                max-width: 520px;
                margin: 30px auto 30px;
                font-size: 20px;
                text-align: center;
            }
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