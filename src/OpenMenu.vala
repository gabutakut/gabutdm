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
    public class OpenMenu : Gtk.FlowBoxChild {
        public OpenMenus openmn { get; private set; }

        public OpenMenu (OpenMenus openmn) {
            this.openmn = openmn;
            var title = new Gtk.Label (openmn.to_string ()) {
                xalign = 0,
                margin_top = 6,
                margin_start = 6,
                margin_bottom = 6,
                width_request = 100,
                valign = Gtk.Align.START,
                wrap_mode = Pango.WrapMode.WORD_CHAR,
                attributes = set_attribute (Pango.Weight.BOLD)
            };
            var imgstatus = new Gtk.Image () {
                valign = Gtk.Align.CENTER,
                halign = Gtk.Align.START,
                gicon = new ThemedIcon (openmn.to_icon ())
            };
            var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            box.append (imgstatus);
            box.append (title);
            child = box;
            show ();
        }
    }
}