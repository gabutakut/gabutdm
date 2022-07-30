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
    public class DeAscending : Gtk.FlowBoxChild {
        public DeAscend deascend { get; private set; }
        private Gtk.CheckButton cheked;

        private bool _activebtn;
        public bool activebtn {
            get {
                return _activebtn;
            }
            set {
                _activebtn = value;
                cheked.active = _activebtn;
            }
        }

        public DeAscending (DeAscend deascend) {
            this.deascend = deascend;
            halign = Gtk.Align.CENTER;
            var title = new Gtk.Label (deascend.get_name ()) {
                halign = Gtk.Align.CENTER,
                wrap_mode = Pango.WrapMode.WORD_CHAR,
                attributes = set_attribute (Pango.Weight.BOLD),
                margin_top = 6,
                margin_bottom = 6,
                margin_start = 12,
                margin_end = 12,
                width_request = 100
            };
            cheked = new Gtk.CheckButton () {
                halign = Gtk.Align.CENTER,
                margin_start = 6,
                active = false
            };
            var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            box.append (cheked);
            box.append (title);
            child = box;
            show ();
        }
    }
}
