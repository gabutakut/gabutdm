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
    public class ProgressPaintable : GdmPaint {
        private double _progress = 0;
        public double progress {
            get {
                return _progress;
            }
            set {
                _progress = value;
                queue_draw ();
            }
        }
        protected override void on_snapshot (Gtk.Snapshot snapshot, double width, double height) {
            var grect = Graphene.Rect ();
            grect.init (-2, -2, (float) (width + 4), (float)(height + 4));
            var cr = snapshot.append_cairo (grect);
            double arc_end = progress * GLib.Math.PI * 2 - GLib.Math.PI / 2;
            cr.translate (width / 2.0, height / 2.0);
            cr.set_source_rgba (0.0, 1.0, 0.0 , 1.0);
            cr.arc (0, 0, width / 2.0 + 1, -GLib.Math.PI / 2, arc_end);
            cr.stroke ();
            cr.set_source_rgba (1.0, 0.5, 0.0, 1.0);
            cr.arc (0, 0, width / 2.0 + 1, arc_end, 3.0 * GLib.Math.PI / 2.0);
            cr.stroke ();
        }
    }
}