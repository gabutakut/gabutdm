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

        private bool _square_mode = false;
        public bool square_mode {
            get {
                return _square_mode;
            }
            set {
                _square_mode = value;
                queue_draw ();
            }
        }

        private Gtk.IconPaintable? _icon_paintable;
        public Gtk.IconPaintable? icon_paintable {
            get {
                return _icon_paintable;
            }
            set {
                _icon_paintable = value;
                queue_draw ();
            }
        }
        public double icon_ratio = 0.4;
        public Gtk.IconPaintable? badge_paintable { get; set; }
        public double badge_ratio = 0.35;

        private BadgePosition _badge_position = BadgePosition.BOTTOM_RIGHT;
        public BadgePosition badge_position {
            get {
                return _badge_position;
            }
            set {
                _badge_position = value;
                queue_draw ();
            }
        }
        private double _line_width_ratio = 1.0;
        public double line_width_ratio {
            get { return _line_width_ratio; }
            set {
                _line_width_ratio = value.clamp (0.1, 1.0);
                queue_draw ();
            }
        }
        public Gdk.RGBA badge_bg_color = { 0.0f, 1.0f, 0.0f, 0.95f };
        public bool badge_show_bg = false;

        protected override void on_snapshot (Gtk.Snapshot snapshot, double width, double height) {
            if (_square_mode) {
                draw_square_progress (snapshot, width, height);
            } else {
                draw_circle_progress (snapshot, width, height);
            }
        }

        private void draw_circle_progress (Gtk.Snapshot snapshot, double width, double height) {
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

        private void draw_square_progress (Gtk.Snapshot snapshot, double width, double height) {
            var grect = Graphene.Rect ();
            grect.init (0, 0, (float) width, (float) height);
            var cr = snapshot.append_cairo (grect);
            double base_stroke = width * 0.06;
            double stroke_w = double.max (1.5, base_stroke * line_width_ratio.clamp (0.1, 1.0));
            double half_sw = stroke_w / 2.0;
            double x0 = half_sw;
            double y0 = half_sw;
            double bw = width - stroke_w;
            double bh = height - stroke_w;
            double perimeter = 2.0 * (bw + bh);
            double done_len = progress * perimeter;
            double left_len = perimeter - done_len;
            cr.set_line_width (stroke_w);
            cr.set_line_cap (Cairo.LineCap.BUTT);
            double cx = x0 + bw / 2.0;
            double[] px = { cx, y0, x0 + bw, y0, x0 + bw, y0 + bh, x0, y0 + bh, x0, y0, cx, y0};
            double[] seg_len = { bw / 2.0, bh, bw, bh, bw / 2.0 };
            cr.set_source_rgba (0.0, 1.0, 0.0, 1.0);
            draw_square_arc (cr, px, seg_len, done_len);
            cr.set_source_rgba (1.0, 0.0, 0.0, 0.95);
            draw_square_arc (cr, px, seg_len, left_len, done_len);
            if (icon_paintable != null) {
                double ratio = icon_ratio.clamp (0.1, 0.7);
                double icon_size = double.min (bw, bh) * ratio;
                double icon_x = (width - icon_size) / 2.0;
                double icon_y = (height - icon_size) / 2.0;
                snapshot.save ();
                snapshot.translate (Graphene.Point () {
                    x = (float) icon_x,
                    y = (float) icon_y
                });
                snapshot.scale ((float)(icon_size / icon_paintable.get_intrinsic_width ()), (float)(icon_size / icon_paintable.get_intrinsic_height ()));
                icon_paintable.snapshot (snapshot, icon_paintable.get_intrinsic_width (), icon_paintable.get_intrinsic_height ());
                snapshot.restore ();
                if (badge_paintable != null) {
                    draw_badge (snapshot, icon_x, icon_y, icon_size);
                }
            }
        }

        private void draw_badge (Gtk.Snapshot snapshot, double icon_x, double icon_y, double icon_size) {
            double badge_size = icon_size * badge_ratio.clamp (0.2, 0.6);
            double badge_radius = badge_size / 2.0;
            double center_x, center_y;
            switch (_badge_position) {
                case BadgePosition.BOTTOM_RIGHT:
                    center_x = icon_x + icon_size - badge_radius * 0.6;
                    center_y = icon_y + icon_size - badge_radius * 0.6;
                    break;
                case BadgePosition.BOTTOM_LEFT:
                    center_x = icon_x + badge_radius * 0.6;
                    center_y = icon_y + icon_size - badge_radius * 0.6;
                    break;
                case BadgePosition.TOP_RIGHT:
                    center_x = icon_x + icon_size - badge_radius * 0.6;
                    center_y = icon_y + badge_radius * 0.6;
                    break;
                case BadgePosition.TOP_LEFT:
                default:
                    center_x = icon_x + badge_radius * 0.6;
                    center_y = icon_y + badge_radius * 0.6;
                    break;
            }
            if (badge_show_bg) {
                var bg_rect = Graphene.Rect ();
                double bg_pad = badge_radius * 1.3;
                bg_rect.init ((float)(center_x - bg_pad), (float)(center_y - bg_pad), (float)(bg_pad * 2), (float)(bg_pad * 2));
                var bg_cr = snapshot.append_cairo (bg_rect);
                bg_cr.set_source_rgba (badge_bg_color.red, badge_bg_color.green, badge_bg_color.blue, badge_bg_color.alpha);
                bg_cr.arc (center_x, center_y, bg_pad, 0, 2 * GLib.Math.PI);
                bg_cr.fill ();
                bg_cr.set_source_rgba (0.0, 0.0, 0.0, 0.15);
                bg_cr.set_line_width (1.0);
                bg_cr.arc (center_x, center_y, bg_pad - 0.5, 0, 2 * GLib.Math.PI);
                bg_cr.stroke ();
            }
            double bx = center_x - badge_radius;
            double by = center_y - badge_radius;
            snapshot.save ();
            snapshot.translate (Graphene.Point () {
                x = (float) bx,
                y = (float) by
            });
            snapshot.scale ((float)(badge_size / badge_paintable.get_intrinsic_width ()), (float)(badge_size / badge_paintable.get_intrinsic_height ()));
            badge_paintable.snapshot (snapshot, badge_paintable.get_intrinsic_width (), badge_paintable.get_intrinsic_height ());
            snapshot.restore ();
        }

        private void draw_square_arc (Cairo.Context cr, double[] pts, double[] segs, double draw_len, double start_offset = 0.0) {
            if (draw_len <= 0) {
                return;
            }
            double remaining_skip = start_offset;
            double remaining_draw = draw_len;
            bool started = false;
            for (int i = 0; i < segs.length && remaining_draw > 0; i++) {
                double seg = segs[i];
                if (remaining_skip >= seg) {
                    remaining_skip -= seg;
                    continue;
                }
                double seg_start = remaining_skip;
                remaining_skip = 0;
                double ax = pts[i * 2];
                double ay = pts[i * 2 + 1];
                double bx = pts[(i + 1) * 2];
                double by = pts[(i + 1) * 2 + 1];
                double t0 = seg_start / seg;
                double sx = ax + t0 * (bx - ax);
                double sy = ay + t0 * (by - ay);
                double available = seg - seg_start;
                double draw_here = double.min (available, remaining_draw);
                double t1 = (seg_start + draw_here) / seg;
                double ex = ax + t1 * (bx - ax);
                double ey = ay + t1 * (by - ay);
                if (!started) {
                    cr.move_to (sx, sy);
                    started = true;
                } else {
                    cr.line_to (sx, sy);
                }
                cr.line_to (ex, ey);
                remaining_draw -= draw_here;
            }
            if (started) {
                cr.stroke ();
            }
        }
    }
}