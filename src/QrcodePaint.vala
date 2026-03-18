/*
* Copyright (c) {2026} torikulhabib (https://github.com/gabutakut)
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
            get { return _qrstr; }
            set {
                _qrstr = value;
                queue_draw ();
            }
        }

        public Gtk.IconPaintable? icon_paintable { get; set; }
        public double icon_ratio = 0.4;
        protected override void on_snapshot (Gtk.Snapshot snapshot, double width, double height) {
            if (qrstr == null || qrstr == "") {
                return;
            }

            unowned QRCode.Code? qrcode = QRCode.encode_string (qrstr, 0, QRCode.ECLEVEL_H, QRCode.MODE_8, 1);
            if (qrcode == null) {
                return;
            }
            int qr_width = qrcode.width;
            int margin = 2;
            int total = qr_width + margin * 2;

            double scale = ((width < height) ? width : height) / total;
            double offset_x = (width  - total * scale) / 2;
            double offset_y = (height - total * scale) / 2;

            var rect = Graphene.Rect ();
            rect.init (0, 0, (float) width, (float) height);
            Cairo.Context cr = snapshot.append_cairo (rect);

            cr.set_source_rgb (1, 1, 1);
            cr.paint ();

            cr.set_antialias (Cairo.Antialias.NONE);
            cr.set_source_rgb (0, 0, 0);

            bool use_icon = (icon_paintable != null);
            int icon_modules = 0;
            int icon_start = 0;
            if (use_icon) {
                if (icon_ratio > 0.30) {
                    icon_ratio = 0.30;
                }
                icon_modules = (int)(qr_width * icon_ratio);
                if (icon_modules % 2 == 0) {
                    icon_modules++;
                }
                if (icon_modules < 7) {
                    icon_modules = 7;
                }
                icon_start = (qr_width - icon_modules) / 2;
            }
            for (int y = 0; y < qr_width; y++) {
                for (int x = 0; x < qr_width; x++) {
                    if (use_icon && x >= icon_start && x < icon_start + icon_modules && y >= icon_start && y < icon_start + icon_modules) {
                        continue;
                    }
                    if ((qrcode.data[y * qr_width + x] & 1) != 0) {
                        double dx = offset_x + (x + margin) * scale;
                        double dy = offset_y + (y + margin) * scale;
                        cr.rectangle (dx, dy, scale, scale);
                    }
                }
            }
            cr.fill ();
            if (use_icon) {
                double icon_px = icon_modules * scale * 0.85;
                double icon_x = offset_x + (icon_start + margin) * scale + (icon_modules * scale - icon_px) / 2;
                double icon_y = offset_y + (icon_start + margin) * scale + (icon_modules * scale - icon_px) / 2;
                snapshot.save ();
                snapshot.translate (Graphene.Point () {
                    x = (float) icon_x,
                    y = (float) icon_y
                });
                snapshot.scale ((float) (icon_px / icon_paintable.get_intrinsic_width ()), (float) (icon_px / icon_paintable.get_intrinsic_height ()));
                icon_paintable.snapshot (snapshot, icon_paintable.get_intrinsic_width (), icon_paintable.get_intrinsic_height ());
                snapshot.restore ();
            }
        }
    }
}