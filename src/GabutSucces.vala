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
    public class GabutSucces : GLib.Object {
        Gee.HashMap<InfoSucces, string> succeshash;

        construct {
            succeshash = new Gee.HashMap<InfoSucces, string> ();
        }

        public void set_info (string data, InfoSucces succes) {
            succeshash[succes] = data;
        }

        public string get_info () {
            var builder = new StringBuilder ();
            if (succeshash.has_key (InfoSucces.ADDRESS)) {
                builder.append (succeshash.get (InfoSucces.ADDRESS));
            } else {
                builder.append ("");
            }
            builder.append ("<gabut>");
            if (succeshash.has_key (InfoSucces.FILEPATH)) {
                builder.append (succeshash.get (InfoSucces.FILEPATH));
            } else {
                builder.append ("");
            }
            builder.append ("<gabut>");
            if (succeshash.has_key (InfoSucces.FILESIZE)) {
                builder.append (succeshash.get (InfoSucces.FILESIZE));
            } else {
                builder.append ("");
            }
            builder.append ("<gabut>");
            if (succeshash.has_key (InfoSucces.ICONNAME)) {
                builder.append (succeshash.get (InfoSucces.ICONNAME));
            } else {
                builder.append ("");
            }
            return builder.str;
        }
    }
}