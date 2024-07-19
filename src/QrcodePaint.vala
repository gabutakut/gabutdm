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
    public class QrcodePaint : GdmPaint {
        private string _qrstr;
        public string qrstr {
            get {
                return _qrstr;
            }
            set {
                _qrstr = value;
                queue_draw ();
            }
        }

        protected override void on_snapshot (Gtk.Snapshot snapshot, double width, double height) {
            var qrencode = new Qrencode.QRcode.encodeData (qrstr.length, qrstr.data, 1, Qrencode.EcLevel.M);
            int qrenwidth = qrencode.width;
            var limitsize = (qrenwidth < 29? 1.3 : 0);
            var grect = Graphene.Rect ();
            grect.init (0, 0, (float) width, (float)height);
            Cairo.Context cr = snapshot.append_cairo (grect);
            cr.set_source_rgb (1.0, 1.0, 1.0);
            cr.rectangle (0, 0, width, height);
            cr.fill ();
            char* qrentdata = qrencode.data;
            for (int y = 0; y < qrenwidth; y++) {
                for (int x = 0; x < qrenwidth; x++) {
                    double rectx = 13 + x * (8 + limitsize);
                    double recty = 13 + y * (8 + limitsize);
                    int digit_ornot = 0;
                    digit_ornot += (*qrentdata & 1);
                    if (digit_ornot == 1) {
                        cr.set_source_rgb (0.0, 0.0, 0.0);
                    } else {
                        cr.set_source_rgb (1.0, 1.0, 1.0);
                    }
                    cr.rectangle (rectx, recty, (8 + limitsize), (8 + limitsize));
                    cr.fill ();
                    qrentdata++;
                }
            }
        }
    }
}