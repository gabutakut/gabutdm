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
    public class ChecksumType : Gtk.FlowBoxChild {
        public AriaChecksumTypes checksums { get; private set; }

        public ChecksumType (AriaChecksumTypes checksums) {
            this.checksums = checksums;
            halign = Gtk.Align.CENTER;
            var title = new Gtk.Label (checksums.to_string ().up ().replace ("=", "").replace ("-", "")) {
                halign = Gtk.Align.CENTER,
                wrap_mode = Pango.WrapMode.WORD_CHAR,
                attributes = set_attribute (Pango.Weight.BOLD),
                margin_top = 6,
                margin_bottom = 6,
                margin_start = 16,
                margin_end = 16,
                width_request = 124
            };
            child = title;
            show ();
        }
    }
}