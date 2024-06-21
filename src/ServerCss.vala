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
    public string get_gbt_css () {
        return "
        html {
            background: transparent;
        }
        body {
            background-color: #335B67;
            background: -ms-radial-gradient(ellipse at center,  #335B67 0%, #2C3E50 100%) fixed no-repeat;
            background: -moz-radial-gradient(ellipse at center,  #335B67 0%, #2C3E50 100%) fixed no-repeat;
            background: -o-radial-gradient(ellipse at center, #335B67 0%, #2C3E50 100%) fixed no-repeat;
            background: -webkit-gradient(radial, center center, 0, center center, 497, color-stop(0, #335B67), color-stop(1, #2C3E50));
            background: -webkit-radial-gradient(ellipse at center,  #335B67 0%, #2C3E50 100%) fixed no-repeat;
            background: radial-gradient(ellipse at center, #335B67 0%, #2C3E50 100%) fixed no-repeat;
            margin: 0px;
            width: 100%;
            height: 100%;
        }
        form.files input[type=file] {
            font-size: 20px;
            float: left;
            width: 75%;
            height: 46px;
        }
        form.files button {
            width: 25%;
        }
        form.text input[type=text] {
            font-size: 20px;
            float: left;
            width: 75%;
            height: 46px;
        }
        form.text button {
            width: 25%;
        }
        .metadata {
            color: white;
            font-size: 20px;
            text-align: start;
        }
        a:link {
            color: white;
        }
        a:visited {
            color: white;
        }
        a:hover {
            color: white;
        }
        a:active {
            color: white;
        }
        h1{
            font-weight: 100;
            font-size: 40px;
            text-transform: uppercase;
            color: white;
            letter-spacing: 10px;
        }
        h2{
            font-weight: 100;
            font-size: 40px;
            text-transform: uppercase;
            color: white;
        }
        ul{
            list-style: none;
        }
        #trigger-overlay:hover, a:focus, a:hover {
            color: inherit;
            text-decoration: none;
            transition: .8s;
        }
        p{
            font-size: 16px;
        }
        .button.buttonx {
            height: 50%;
        }
        .overlay {
            position: fixed;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            z-index: 9999;
            display: none;
            background-color: #335B67;
            background: -ms-radial-gradient(ellipse at center,  #335B67 0%, #2C3E50 100%) fixed no-repeat;
            background: -moz-radial-gradient(ellipse at center,  #335B67 0%, #2C3E50 100%) fixed no-repeat;
            background: -o-radial-gradient(ellipse at center, #335B67 0%, #2C3E50 100%) fixed no-repeat;
            background: -webkit-gradient(radial, center center, 0, center center, 497, color-stop(0, #335B67), color-stop(1, #2C3E50));
            background: -webkit-radial-gradient(ellipse at center,  #335B67 0%, #2C3E50 100%) fixed no-repeat;
            background: radial-gradient(ellipse at center, #335B67 0%, #2C3E50 100%) fixed no-repeat;
        }
        .overlay nav {
            text-align: center;
            position: relative;
            top: 50%;
            height: 50%;
            font-size: 40px;
            -webkit-transform: translateY(-50%);
            transform: translateY(-50%);
            list-style: none;
            padding: 0;
            margin: 0 auto;
            display: inline-block;
        }
        .overlay-content {
            position: relative;
            top: 10%;
            width: 100%;
            height: 54%;
            text-align: center;
            margin: auto;
        }
        .overlay .closebtn {
            position: absolute;
            top: 20px;
            right: 45px;
            font-size: 60px;
            cursor: pointer;
            color: white;
        }
        .logo {
            font-size: 80px;
            letter-spacing: 10px;
            font-weight: 100;
            color: white;
            display: inline-block;
            padding: 0px;
            float: left;
        }
        .strong{
            font-weight: 400;
            color: white;
        }
        .nav-button{
            max-width: 600px;
            margin: 35px 0px;
        }
        .nav-button button{
            border: none;
            outline: none;
            display: inline-block;
            color: white;
            border-radius: 0px;
            cursor: pointer;
            background-color: transparent;
            float: right;
            padding: 0px 12px;
        }
        header {
            background: transparent;
            color: white;
            position: sticky;
            top: 0;
            padding: 20px 0 10px;
        }
        .shortfd {
            color: white;
            font-size: 28px;
        }
        .append {
            color: white;
            display: flex;
            flex-direction: column;
            margin-bottom: 24px;
        }
        .append .item {
            align-items: center;
            padding: 6px 10px;
            display: flex;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .append .item:hover {
            background: linear-gradient (60deg, rgb(16, 138, 44), rgb(16, 148, 34));
            border-radius: 4px;
        }
        .item > div {
            padding: 0 8px;
        }
        .item > div:first-child {
            padding-left: 0px;
        }
        .item > div:last-child {
            padding-right: 0px;
        }
        .item .icon {
            width: 48px;
        }
        .item .name {
            flex: 1;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .item .size {
            flex-basis: 10%;
            text-align: end;
        }
        .item .modified {
            flex-basis: 10%;
            text-align: end;
        }
        .item .deleteb {
            flex-basis: 10%;
            text-align: end;
        }
        .item .button {
            flex-basis: 10%;
            text-align: end;
        }
        .item .icon.folder {
            .icon.folder;
        }
        .item .icon.up {
            .icon.up;
        }
        .item .icon.file {
            .icon.file;
        }
        .item .icon.text {
            .icon.text;
        }
        .item .icon.audio {
            .icon.audio;
        }
        .item .icon.image {
            .icon.image;
        }
        .item .icon.video {
            .icon.video;
        }
        .item .icon.pdf {
            .icon.pdf;
        }
        .item .icon.archive {
            .icon.archive;
        }
        .item .icon.code {
            .icon.code;
        }
        .item .icon.font {
            .icon.font;
        }
        .item .icon.po {
            .icon.po;
        }
        .icon.playing {
            content: url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='128' height='128' fill='%237fc736' class='bi bi-play-circle-fill' viewBox='0 0 16 16'%3E%3Cpath d='M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zM6.79 5.093A.5.5 0 0 0 6 5.5v5a.5.5 0 0 0 .79.407l3.5-2.5a.5.5 0 0 0 0-.814l-3.5-2.5z'/%3E%3C/svg%3E\");
        }
        .icon.paused {
            content: url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='128' height='128' fill='%235595e0' class='bi bi-pause-circle-fill' viewBox='0 0 16 16'%3E%3Cpath d='M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zM6.25 5C5.56 5 5 5.56 5 6.25v3.5a1.25 1.25 0 1 0 2.5 0v-3.5C7.5 5.56 6.94 5 6.25 5zm3.5 0c-.69 0-1.25.56-1.25 1.25v3.5a1.25 1.25 0 1 0 2.5 0v-3.5C11 5.56 10.44 5 9.75 5z'/%3E%3C/svg%3E\");
        }
        .icon.waiting {
            content: url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='128' height='128' fill='white' class='bi bi-stopwatch-fill' viewBox='0 0 16 16'%3E%3Cpath d='M6.5 0a.5.5 0 0 0 0 1H7v1.07A7.001 7.001 0 0 0 8 16a7 7 0 0 0 5.29-11.584.531.531 0 0 0 .013-.012l.354-.354.353.354a.5.5 0 1 0 .707-.707l-1.414-1.415a.5.5 0 1 0-.707.707l.354.354-.354.354a.717.717 0 0 0-.012.012A6.973 6.973 0 0 0 9 2.071V1h.5a.5.5 0 0 0 0-1h-3zm2 5.6V9a.5.5 0 0 1-.5.5H4.5a.5.5 0 0 1 0-1h3V5.6a.5.5 0 1 1 1 0z'/%3E%3C/svg%3E\");
        }
        .icon.complete {
            content: url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='128' height='128' fill='green' class='bi bi-check-circle-fill' viewBox='0 0 16 16'%3E%3Cpath d='M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z'/%3E%3C/svg%3E\");
        }
        .icon.error {
            content: url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='128' height='128' fill='red' class='bi bi-x-octagon-fill' viewBox='0 0 16 16'%3E%3Cpath d='M11.46.146A.5.5 0 0 0 11.107 0H4.893a.5.5 0 0 0-.353.146L.146 4.54A.5.5 0 0 0 0 4.893v6.214a.5.5 0 0 0 .146.353l4.394 4.394a.5.5 0 0 0 .353.146h6.214a.5.5 0 0 0 .353-.146l4.394-4.394a.5.5 0 0 0 .146-.353V4.893a.5.5 0 0 0-.146-.353L11.46.146zm-6.106 4.5L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 1 1 .708-.708z'/%3E%3C/svg%3E\");
        }
        .icon.closew {
            content: url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='48' height='48' fill='white' class='bi bi-x-circle' viewBox='0 0 16 16'%3E%3Cpath d='M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z'/%3E%3Cpath d='M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z'/%3E%3C/svg%3E\");
        }
        .icon.open {
            content: url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='48' height='48' fill='white' class='bi bi-window-plus' viewBox='0 0 16 16'%3E%3Cpath d='M2.5 5a.5.5 0 1 0 0-1 .5.5 0 0 0 0 1ZM4 5a.5.5 0 1 0 0-1 .5.5 0 0 0 0 1Zm2-.5a.5.5 0 1 1-1 0 .5.5 0 0 1 1 0Z'/%3E%3Cpath d='M0 4a2 2 0 0 1 2-2h11a2 2 0 0 1 2 2v4a.5.5 0 0 1-1 0V7H1v5a1 1 0 0 0 1 1h5.5a.5.5 0 0 1 0 1H2a2 2 0 0 1-2-2V4Zm1 2h13V4a1 1 0 0 0-1-1H2a1 1 0 0 0-1 1v2Z'/%3E%3Cpath d='M16 12.5a3.5 3.5 0 1 1-7 0 3.5 3.5 0 0 1 7 0Zm-3.5-2a.5.5 0 0 0-.5.5v1h-1a.5.5 0 0 0 0 1h1v1a.5.5 0 0 0 1 0v-1h1a.5.5 0 0 0 0-1h-1v-1a.5.5 0 0 0-.5-.5Z'/%3E%3C/svg%3E\");
        }
        .icon.myhome {
            content: url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='32' height='32' fill='white' class='bi bi-house-heart-fill' viewBox='0 0 18 11'%3E%3Cpath d='M7.293 1.5a1 1 0 0 1 1.414 0L11 3.793V2.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v3.293l2.354 2.353a.5.5 0 0 1-.708.707L8 2.207 1.354 8.853a.5.5 0 1 1-.708-.707L7.293 1.5Z'/%3E%3Cpath d='m14 9.293-6-6-6 6V13.5A1.5 1.5 0 0 0 3.5 15h9a1.5 1.5 0 0 0 1.5-1.5V9.293Zm-6-.811c1.664-1.673 5.825 1.254 0 5.018-5.825-3.764-1.664-6.691 0-5.018Z'/%3E%3C/svg%3E\");
        }
        .icon.folder {
            content: url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='128' height='128' fill='Cyan' class='bi bi-folder-fill' viewBox='0 0 16 16'%3E%3Cpath d='M9.828 3h3.982a2 2 0 0 1 1.992 2.181l-.637 7A2 2 0 0 1 13.174 14H2.825a2 2 0 0 1-1.991-1.819l-.637-7a1.99 1.99 0 0 1 .342-1.31L.5 3a2 2 0 0 1 2-2h3.672a2 2 0 0 1 1.414.586l.828.828A2 2 0 0 0 9.828 3zm-8.322.12C1.72 3.042 1.95 3 2.19 3h5.396l-.707-.707A1 1 0 0 0 6.172 2H2.5a1 1 0 0 0-1 .981l.006.139z'/%3E%3C/svg%3E\");
        }
        .icon.up {
            content: url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='128' height='128' fill='Cyan' class='bi bi-cloud-arrow-up-fill' viewBox='0 0 16 16'%3E%3Cpath d='M8 2a5.53 5.53 0 0 0-3.594 1.342c-.766.66-1.321 1.52-1.464 2.383C1.266 6.095 0 7.555 0 9.318 0 11.366 1.708 13 3.781 13h8.906C14.502 13 16 11.57 16 9.773c0-1.636-1.242-2.969-2.834-3.194C12.923 3.999 10.69 2 8 2zm2.354 5.146a.5.5 0 0 1-.708.708L8.5 6.707V10.5a.5.5 0 0 1-1 0V6.707L6.354 7.854a.5.5 0 1 1-.708-.708l2-2a.5.5 0 0 1 .708 0l2 2z'/%3E%3C/svg%3E\");
        }
        .icon.file {
            content: url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='128' height='128' fill='%235a697f' class='bi bi-gear-fill' viewBox='0 0 16 16'%3E%3Cpath d='M9.405 1.05c-.413-1.4-2.397-1.4-2.81 0l-.1.34a1.464 1.464 0 0 1-2.105.872l-.31-.17c-1.283-.698-2.686.705-1.987 1.987l.169.311c.446.82.023 1.841-.872 2.105l-.34.1c-1.4.413-1.4 2.397 0 2.81l.34.1a1.464 1.464 0 0 1 .872 2.105l-.17.31c-.698 1.283.705 2.686 1.987 1.987l.311-.169a1.464 1.464 0 0 1 2.105.872l.1.34c.413 1.4 2.397 1.4 2.81 0l.1-.34a1.464 1.464 0 0 1 2.105-.872l.31.17c1.283.698 2.686-.705 1.987-1.987l-.169-.311a1.464 1.464 0 0 1 .872-2.105l.34-.1c1.4-.413 1.4-2.397 0-2.81l-.34-.1a1.464 1.464 0 0 1-.872-2.105l.17-.31c.698-1.283-.705-2.686-1.987-1.987l-.311.169a1.464 1.464 0 0 1-2.105-.872l-.1-.34zM8 10.93a2.929 2.929 0 1 1 0-5.86 2.929 2.929 0 0 1 0 5.858z'/%3E%3C/svg%3E\");
        }
        .icon.text {
            content: url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='128' height='128' fill='Silver' class='bi bi-file-text-fill' viewBox='0 0 16 16'%3E%3Cpath d='M12 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2zM5 4h6a.5.5 0 0 1 0 1H5a.5.5 0 0 1 0-1zm-.5 2.5A.5.5 0 0 1 5 6h6a.5.5 0 0 1 0 1H5a.5.5 0 0 1-.5-.5zM5 8h6a.5.5 0 0 1 0 1H5a.5.5 0 0 1 0-1zm0 2h3a.5.5 0 0 1 0 1H5a.5.5 0 0 1 0-1z'/%3E%3C/svg%3E\");
        }
        .icon.audio {
            content: url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='128' height='128' fill='Orange' class='bi bi-file-earmark-music-fill' viewBox='0 0 16 16'%3E%3Cpath d='M9.293 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V4.707A1 1 0 0 0 13.707 4L10 .293A1 1 0 0 0 9.293 0zM9.5 3.5v-2l3 3h-2a1 1 0 0 1-1-1zM11 6.64v1.75l-2 .5v3.61c0 .495-.301.883-.662 1.123C7.974 13.866 7.499 14 7 14c-.5 0-.974-.134-1.338-.377-.36-.24-.662-.628-.662-1.123s.301-.883.662-1.123C6.026 11.134 6.501 11 7 11c.356 0 .7.068 1 .196V6.89a1 1 0 0 1 .757-.97l1-.25A1 1 0 0 1 11 6.64z'/%3E%3C/svg%3E\");
        }
        .icon.image {
            content: url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='128' height='128' fill='LightBlue' class='bi bi-image-fill' viewBox='0 0 16 16'%3E%3Cpath d='M.002 3a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2h-12a2 2 0 0 1-2-2V3zm1 9v1a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V9.5l-3.777-1.947a.5.5 0 0 0-.577.093l-3.71 3.71-2.66-1.772a.5.5 0 0 0-.63.062L1.002 12zm5-6.5a1.5 1.5 0 1 0-3 0 1.5 1.5 0 0 0 3 0z'/%3E%3C/svg%3E\");
        }
        .icon.video {
            content: url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='128' height='128' fill='Pink' class='bi bi-film' viewBox='0 0 16 16'%3E%3Cpath d='M0 1a1 1 0 0 1 1-1h14a1 1 0 0 1 1 1v14a1 1 0 0 1-1 1H1a1 1 0 0 1-1-1V1zm4 0v6h8V1H4zm8 8H4v6h8V9zM1 1v2h2V1H1zm2 3H1v2h2V4zM1 7v2h2V7H1zm2 3H1v2h2v-2zm-2 3v2h2v-2H1zM15 1h-2v2h2V1zm-2 3v2h2V4h-2zm2 3h-2v2h2V7zm-2 3v2h2v-2h-2zm2 3h-2v2h2v-2z'/%3E%3C/svg%3E\");
        }
        .icon.pdf {
            content: url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='128' height='128' fill='%23d6393e' class='bi bi-file-pdf-fill' viewBox='0 0 16 16'%3E%3Cpath d='M5.523 10.424c.14-.082.293-.162.459-.238a7.878 7.878 0 0 1-.45.606c-.28.337-.498.516-.635.572a.266.266 0 0 1-.035.012.282.282 0 0 1-.026-.044c-.056-.11-.054-.216.04-.36.106-.165.319-.354.647-.548zm2.455-1.647c-.119.025-.237.05-.356.078a21.035 21.035 0 0 0 .5-1.05 11.96 11.96 0 0 0 .51.858c-.217.032-.436.07-.654.114zm2.525.939a3.888 3.888 0 0 1-.435-.41c.228.005.434.022.612.054.317.057.466.147.518.209a.095.095 0 0 1 .026.064.436.436 0 0 1-.06.2.307.307 0 0 1-.094.124.107.107 0 0 1-.069.015c-.09-.003-.258-.066-.498-.256zM8.278 4.97c-.04.244-.108.524-.2.829a4.86 4.86 0 0 1-.089-.346c-.076-.353-.087-.63-.046-.822.038-.177.11-.248.196-.283a.517.517 0 0 1 .145-.04c.013.03.028.092.032.198.005.122-.007.277-.038.465z'/%3E%3Cpath fill-rule='evenodd' d='M4 0h8a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V2a2 2 0 0 1 2-2zm.165 11.668c.09.18.23.343.438.419.207.075.412.04.58-.03.318-.13.635-.436.926-.786.333-.401.683-.927 1.021-1.51a11.64 11.64 0 0 1 1.997-.406c.3.383.61.713.91.95.28.22.603.403.934.417a.856.856 0 0 0 .51-.138c.155-.101.27-.247.354-.416.09-.181.145-.37.138-.563a.844.844 0 0 0-.2-.518c-.226-.27-.596-.4-.96-.465a5.76 5.76 0 0 0-1.335-.05 10.954 10.954 0 0 1-.98-1.686c.25-.66.437-1.284.52-1.794.036-.218.055-.426.048-.614a1.238 1.238 0 0 0-.127-.538.7.7 0 0 0-.477-.365c-.202-.043-.41 0-.601.077-.377.15-.576.47-.651.823-.073.34-.04.736.046 1.136.088.406.238.848.43 1.295a19.707 19.707 0 0 1-1.062 2.227 7.662 7.662 0 0 0-1.482.645c-.37.22-.699.48-.897.787-.21.326-.275.714-.08 1.103z'/%3E%3C/svg%3E\");
        }
        .icon.archive {
            content: url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='128' height='128' fill='%23dbb478' class='bi bi-file-earmark-zip-fill' viewBox='0 0 16 16'%3E%3Cpath d='M5.5 9.438V8.5h1v.938a1 1 0 0 0 .03.243l.4 1.598-.93.62-.93-.62.4-1.598a1 1 0 0 0 .03-.243z'/%3E%3Cpath d='M9.293 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V4.707A1 1 0 0 0 13.707 4L10 .293A1 1 0 0 0 9.293 0zM9.5 3.5v-2l3 3h-2a1 1 0 0 1-1-1zm-4-.5V2h-1V1H6v1h1v1H6v1h1v1H6v1h1v1H5.5V6h-1V5h1V4h-1V3h1zm0 4.5h1a1 1 0 0 1 1 1v.938l.4 1.599a1 1 0 0 1-.416 1.074l-.93.62a1 1 0 0 1-1.109 0l-.93-.62a1 1 0 0 1-.415-1.074l.4-1.599V8.5a1 1 0 0 1 1-1z'/%3E%3C/svg%3E\");
        }
        .icon.code {
            content: url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='128' height='128' fill='white' class='bi bi-code-slash' viewBox='0 0 16 16'%3E%3Cpath d='M10.478 1.647a.5.5 0 1 0-.956-.294l-4 13a.5.5 0 0 0 .956.294l4-13zM4.854 4.146a.5.5 0 0 1 0 .708L1.707 8l3.147 3.146a.5.5 0 0 1-.708.708l-3.5-3.5a.5.5 0 0 1 0-.708l3.5-3.5a.5.5 0 0 1 .708 0zm6.292 0a.5.5 0 0 0 0 .708L14.293 8l-3.147 3.146a.5.5 0 0 0 .708.708l3.5-3.5a.5.5 0 0 0 0-.708l-3.5-3.5a.5.5 0 0 0-.708 0z'/%3E%3C/svg%3E\");
        }
        .icon.font {
            content: url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='128' height='128' fill='white' class='bi bi-file-earmark-font' viewBox='0 0 16 16'%3E%3Cpath d='M10.943 6H5.057L5 8h.5c.18-1.096.356-1.192 1.694-1.235l.293-.01v5.09c0 .47-.1.582-.898.655v.5H9.41v-.5c-.803-.073-.903-.184-.903-.654V6.755l.298.01c1.338.043 1.514.14 1.694 1.235h.5l-.057-2z'/%3E%3Cpath d='M14 4.5V14a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V2a2 2 0 0 1 2-2h5.5L14 4.5zm-3 0A1.5 1.5 0 0 1 9.5 3V1H4a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V4.5h-2z'/%3E%3C/svg%3E\");
        }
        .icon.po {
            content: url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='128' height='128' fill='white' class='bi bi-translate' viewBox='0 0 16 16'%3E%3Cpath d='M4.545 6.714 4.11 8H3l1.862-5h1.284L8 8H6.833l-.435-1.286H4.545zm1.634-.736L5.5 3.956h-.049l-.679 2.022H6.18z'/%3E%3Cpath d='M0 2a2 2 0 0 1 2-2h7a2 2 0 0 1 2 2v3h3a2 2 0 0 1 2 2v7a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2v-3H2a2 2 0 0 1-2-2V2zm2-1a1 1 0 0 0-1 1v7a1 1 0 0 0 1 1h7a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H2zm7.138 9.995c.193.301.402.583.63.846-.748.575-1.673 1.001-2.768 1.292.178.217.451.635.555.867 1.125-.359 2.08-.844 2.886-1.494.777.665 1.739 1.165 2.93 1.472.133-.254.414-.673.629-.89-1.125-.253-2.057-.694-2.82-1.284.681-.747 1.222-1.651 1.621-2.757H14V8h-3v1.047h.765c-.318.844-.74 1.546-1.272 2.13a6.066 6.066 0 0 1-.415-.492 1.988 1.988 0 0 1-.94.31z'/%3E%3C/svg%3E\");
        }
        .starting p{
            padding: 20px 0px;
            color: white;
            line-height: 30px;
        }
        .animated {
            -webkit-animation-duration: 1s;
            animation-duration: 1s;
            -webkit-animation-fill-mode: both;
            animation-fill-mode: both;
        }
        .animated.infinite {
            -webkit-animation-iteration-count: infinite;
            animation-iteration-count: infinite;
        }
        .animated.hinge {
            -webkit-animation-duration: 2s;
            animation-duration: 2s;
        }
        @-webkit-keyframes fadeInDownBig {
            0% {
                opacity: 0;
                -webkit-transform: translate3d(0, -2000px, 0);
                transform: translate3d(0, -2000px, 0);
            }
            100% {
                opacity: 1;
                -webkit-transform: none;
                transform: none;
            }
        }
        @keyframes fadeInDownBig {
            0% {
                opacity: 0;
                -webkit-transform: translate3d(0, -2000px, 0);
                -ms-transform: translate3d(0, -2000px, 0);
                transform: translate3d(0, -2000px, 0);
            }
            100% {
                opacity: 1;
                -webkit-transform: none;
                -ms-transform: none;
                transform: none;
            }
        }
        .fadeInDownBig {
            -webkit-animation-name: fadeInDownBig;
            animation-name: fadeInDownBig;
        }
        @-webkit-keyframes fadeInLeft {
            0% {
                opacity: 0;
                -webkit-transform: translate3d(-100%, 0, 0);
                transform: translate3d(-100%, 0, 0);
            }
            100% {
                opacity: 1;
                -webkit-transform: none;
                transform: none;
            }
        }
        @keyframes fadeInLeft {
            0% {
                opacity: 0;
                -webkit-transform: translate3d(-100%, 0, 0);
                -ms-transform: translate3d(-100%, 0, 0);
                transform: translate3d(-100%, 0, 0);
            }
            100% {
                opacity: 1;
                -webkit-transform: none;
                -ms-transform: none;
                transform: none;
            }
        }
        .fadeInLeft {
            -webkit-animation-name: fadeInLeft;
            animation-name: fadeInLeft;
        }
        @-webkit-keyframes fadeInRight {
            0% {
              opacity: 0;
              -webkit-transform: translate3d(100%, 0, 0);
              transform: translate3d(100%, 0, 0);
            }
            100% {
              opacity: 1;
              -webkit-transform: none;
              transform: none;
            }
        }
        @keyframes fadeInRight {
            0% {
              opacity: 0;
              -webkit-transform: translate3d(100%, 0, 0);
              -ms-transform: translate3d(100%, 0, 0);
              transform: translate3d(100%, 0, 0);
            }
            100% {
              opacity: 1;
              -webkit-transform: none;
              -ms-transform: none;
              transform: none;
            }
        }
        .fadeInRight {
            -webkit-animation-name: fadeInRight;
            animation-name: fadeInRight;
        }
        @-webkit-keyframes fadeInRightBig {
            0% {
              opacity: 0;
              -webkit-transform: translate3d(2000px, 0, 0);
              transform: translate3d(2000px, 0, 0);
            }
            100% {
              opacity: 1;
              -webkit-transform: none;
              transform: none;
            }
        }";
    }
}