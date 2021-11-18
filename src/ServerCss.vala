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
    public class ServerCss {
        public abstract const string get_css = "
            html {
                background: transparent;
            }
            body {
                background: linear-gradient(60deg, #8cd42e, rgb(16, 148, 34));
                color: white;
                width: 100%;
            }
            *{box-sizing: border-box}
            #Downloading {
                background-color: transparent;
            }
            #Paused {
                background-color: transparent;
            }
            #Complete {
                background-color: transparent;
            }
            #Waiting {
                background-color: transparent;
            }
            #Error {
                background-color: transparent;
            }
            form.files input[type=file] {
                font-size: 20px;
                float: left;
                width: 80%;
                height: 45px;
            }
            form.files button {
                width: 20%;
            }
            progress {
                width: 100%;
            }
            #labelsend {
                color: white;
            }
            form.text input[type=text] {
                font-size: 20px;
                float: left;
                width: 80%;
                height: 45px;
            }
            form.text button {
                width: 20%;
            }
            #metadata {
                color: white;
            }
            #progresslabel {
                color: white;
            }
            #labelsend {
                color: white;
            }
            h1{
                font-weight: 100;
                font-size: 40px;
                text-transform: uppercase;
                color: #fff;
                letter-spacing: 10px;
            }
            h2{
                font-weight: 100;
                font-size: 40px;
                text-transform: uppercase;
                color: #fff;
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
            .wrapper{
                padding: 75px 0px;
            }
            .overlay {
                position: fixed;
                width: 100%;
                height: 100%;
                top: 0;
                left: 0;
                z-index: 9999;
                display: none;
                background: linear-gradient(50deg, #8cd42e, rgb(16, 148, 34));
            }
            .overlay nav {
                text-align: center;
                position: relative;
                top: 50%;
                height: 60%;
                font-size: 54px;
                -webkit-transform: translateY(-50%);
                transform: translateY(-50%);
            }
            .overlay ul {
                list-style: none;
                padding: 0;
                margin: 0 auto;
                display: inline-block;
                height: 100%;
                position: relative;
            }
            .overlay ul li {
                display: block;
                height: 20%;
                height: calc(100% / 5);
                min-height: 54px;
            }
            .overlay ul li a {
                font-weight: 300;
                display: block;
                color: #fff;
                -webkit-transition: color 0.2s;
                transition: color 0.2s;
            }
            .overlay ul li a:hover,
            .overlay ul li a:focus {
                color: #e3fcb1;
            }
            .overlay-content {
                position: relative;
                top: 50%;
                width: 80%;
                text-align: center;
                margin-top: 30px;
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
            .overlay .closebtn:hover {
                color: #ccc;
            }
            .overlay button {
                float: left;
                width: 20%;
                padding: 15px;
                background: #ddd;
                font-size: 17px;
                border: none;
                cursor: pointer;
            }
            .header{
                height: 10vh;
                background: transparent;
                padding: 5px 0px;
                content: \"\";
            }
            #logo {
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
            }
            .header img{
                width: 100%;
            }
            .top-bar{
                width: 100%;
            }
            .fixed {
                position: fixed;
                background: transparent;
                top: 0;
                z-index: 99;
                transition: 1s;
            }
            .fixed .nav-button{
                margin: 15px 0px;
            }
            .nav-button{
                max-width: 600px;
                margin: 35px 0px;
            }
            .nav-button button{
                border: none;
                outline: none;
                display: inline-block;
                color: #fff;
                border-radius: 0px;
                cursor: pointer;
                background-color: transparent;
                float: right;
                font-size: 42px;
                padding: 0px 12px;
            }
            .starting img{
                margin-top: 10px;
            }
            .starting video{
                margin-top: 50px;
            }
            .starting audio{
                margin-top: 110px;
            }
            .banner-text{
                margin-top: 100px;
            }
            .starting p{
                padding: 20px 0px;
                color: #fff;
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
        ";
    }
}