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
    public class GabutScreen : Gtk.DrawingArea {
        public delegate void DnDScreenCallback ();
        public delegate void DnDFilesCallback (string uris);

        private DropState _state = DropState.IDLE;
        public DropState drop_state {
            get { return _state; }
            set {
                _state = value;
                target_overlay = (value != DropState.IDLE) ? 1.0 : 0.0;
                queue_draw ();
            }
        }

        private double _fraction = 0.0;
        public double fraction {
            get { return _fraction; }
            set {
                _fraction = value;
                queue_draw ();
            }
        }

        private string _status_text = "Drop files here";
        public string status_text {
            get { return _status_text; }
            set {
                _status_text = value;
                queue_draw ();
            }
        }
        private double anim_tick = 0.0;
        private double ring_angle = 0.0;
        private double pulse_scale = 1.0;
        private bool pulse_grow = true;
        private double arrow_y = 0.0;
        private double overlay_alpha = 0.0;
        private double target_overlay = 0.0;
        private double drop_flash = 0.0;

        private struct Particle {
            public double x;
            public double y;
            public double vx;
            public double vy;
            public double alpha;
            public double size;
            public double life;
            public double max_life;
            public int kind;
        }

        private struct Stream {
            public double offset;
            public double speed;
            public double alpha;
            public double width;
            public double y;
        }

        private const int MAX_P = 80;
        private const int NUM_S = 14;
        private Particle[] particles;
        private Stream[] streams;

        public GabutScreen () {
            Object (hexpand: true, vexpand: true, can_focus: false);
        }

        construct {
            particles = new Particle[MAX_P];
            for (int i = 0; i < MAX_P; i++) {
                spawn_particle (ref particles[i], true, 520, 320);
            }
            streams = new Stream[NUM_S];
            for (int i = 0; i < NUM_S; i++) {
                streams[i].offset = GLib.Random.double_range (0, 520);
                streams[i].speed = GLib.Random.double_range (1.2, 3.8);
                streams[i].alpha = GLib.Random.double_range (0.06, 0.22);
                streams[i].width = GLib.Random.double_range (25, 80);
                streams[i].y = GLib.Random.double_range (0.45, 0.90);
            }

            set_draw_func (on_draw);

            GLib.Timeout.add (20, () => {
                anim_tick += 0.032;
                ring_angle += 0.022;
                arrow_y = Math.sin (anim_tick * 3.5) * 6.0;
                if (pulse_grow) {
                    pulse_scale += 0.0025;
                    if (pulse_scale >= 1.055) {
                        pulse_grow = false;
                    }
                } else {
                    pulse_scale -= 0.0025;
                    if (pulse_scale <= 0.945) {
                        pulse_grow = true;
                    }
                }
                double step = 0.07;
                if (overlay_alpha < target_overlay) {
                    overlay_alpha += step;
                    if (overlay_alpha > target_overlay) {
                        overlay_alpha = target_overlay;
                    }
                } else if (overlay_alpha > target_overlay) {
                    overlay_alpha -= step;
                    if (overlay_alpha < target_overlay) {
                        overlay_alpha = target_overlay;
                    }
                }
                if (drop_flash > 0) {
                    drop_flash -= 0.035;
                }
                int w = get_width ();
                int h = get_height ();
                double cx = (w > 0) ? w / 2.0 : 260.0;
                double cy = (h > 0) ? h / 2.0 - 30.0 : 130.0;
                for (int i = 0; i < MAX_P; i++) {
                    if (_state == DropState.HOVERING || _state == DropState.PROCESSING) {
                        double dx = cx - particles[i].x;
                        double dy = cy - particles[i].y;
                        double d = Math.sqrt (dx * dx + dy * dy) + 1.0;
                        particles[i].vx += (dx / d) * 0.045;
                        particles[i].vy += (dy / d) * 0.045;
                        particles[i].vx *= 0.96;
                        particles[i].vy *= 0.96;
                    }
                    particles[i].x += particles[i].vx;
                    particles[i].y += particles[i].vy;
                    particles[i].life += 1.0;
                    particles[i].alpha = 1.0 - (particles[i].life / particles[i].max_life);
                    if (particles[i].life >= particles[i].max_life) {
                        spawn_particle (ref particles[i], false, w > 0 ? w : 520, h > 0 ? h : 320);
                    }
                }
                double max_x = (w > 0) ? w + 100.0 : 620.0;
                for (int i = 0; i < NUM_S; i++) {
                    streams[i].offset += streams[i].speed;
                    if (streams[i].offset > max_x) {
                        streams[i].offset = -streams[i].width;
                    }
                }
                if (overlay_alpha > 0.0 || target_overlay > 0.0) {
                    queue_draw ();
                }
                return true;
            });
        }

        private void spawn_particle (ref Particle p, bool random_pos, int w, int h) {
            double cx = w / 2.0;
            double cy = h / 2.0 - 30.0;
            if (random_pos) {
                p.x = GLib.Random.double_range (0, w);
                p.y = GLib.Random.double_range (0, h);
            } else {
                int edge = (int) GLib.Random.double_range (0, 4);
                switch (edge) {
                    case 0: p.x = GLib.Random.double_range (0, w); p.y = -8; break;
                    case 1: p.x = -8; p.y = GLib.Random.double_range (0, h); break;
                    case 2: p.x = w + 8; p.y = GLib.Random.double_range (0, h); break;
                    default: p.x = GLib.Random.double_range (0, w); p.y = h + 8; break;
                }
            }
            double dx = cx - p.x + GLib.Random.double_range (-30, 30);
            double dy = cy - p.y + GLib.Random.double_range (-15, 15);
            double d  = Math.sqrt (dx * dx + dy * dy) + 0.01;
            double sp = GLib.Random.double_range (0.3, 1.3);
            p.vx = (dx / d) * sp;
            p.vy = (dy / d) * sp;
            p.alpha = 1.0;
            p.size = GLib.Random.double_range (1.5, 3.8);
            p.max_life = GLib.Random.double_range (55, 130);
            p.life = 0;
            p.kind = (int) GLib.Random.double_range (0, 3);
        }

        private void on_draw (Gtk.DrawingArea area, Cairo.Context cr, int w, int h) {
            if (overlay_alpha <= 0.01 && target_overlay <= 0.0) {
                return;
            }
            double cx = w / 2.0;
            double cy = h / 2.0 - 30.0;
            cr.push_group ();
            draw_background (cr, w, h, cx, cy);
            draw_streams (cr, w, h);
            draw_outer_halo (cr, cx, cy);
            draw_particles (cr);
            draw_deco_ring (cr, cx, cy);

            switch (_state) {
                case DropState.HOVERING:
                    draw_drop_zone (cr, cx, cy, w, h);
                    draw_hover_label (cr, cx, cy);
                    break;
                case DropState.PROCESSING:
                case DropState.DONE:
                    draw_processing_icon (cr, cx, cy);
                    break;
                default:
                    break;
            }
            draw_status_bar (cr, w, h);
            cr.pop_group_to_source ();
            cr.paint_with_alpha (overlay_alpha);
        }

        private void draw_background (Cairo.Context cr, int w, int h, double cx, double cy) {
            var bg = new Cairo.Pattern.radial (cx, cy, 0, cx, cy, w * 0.8);
            bg.add_color_stop_rgba (0.0, 0.06, 0.04, 0.10, 0.92);
            bg.add_color_stop_rgba (0.5, 0.03, 0.02, 0.06, 0.95);
            bg.add_color_stop_rgba (1.0, 0.01, 0.01, 0.02, 0.97);
            cr.set_source (bg);
            cr.rectangle (0, 0, w, h);
            cr.fill ();
            cr.set_source_rgba (0.5, 0.0, 0.8, 0.018);
            for (int y = 0; y < h; y += 4) {
                cr.rectangle (0, y, w, 1);
            }
            cr.fill ();
        }

        private void draw_streams (Cairo.Context cr, int w, int h) {
            for (int i = 0; i < NUM_S; i++) {
                var s = streams[i];
                double y = h * s.y;
                double r = (i % 2 == 0) ? 0.63 : 1.0;
                double b = (i % 2 == 0) ? 0.90 : 0.03;
                var gr = new Cairo.Pattern.linear (s.offset, 0, s.offset + s.width, 0);
                gr.add_color_stop_rgba (0.0, r, 0, b, 0.0);
                gr.add_color_stop_rgba (0.4, r, 0, b, s.alpha);
                gr.add_color_stop_rgba (0.7, r, 0, b, s.alpha * 0.5);
                gr.add_color_stop_rgba (1.0, r, 0, b, 0.0);
                cr.set_source (gr);
                cr.rectangle (s.offset, y, s.width, 2.0);
                cr.fill ();
            }
        }

        private void draw_outer_halo (Cairo.Context cr, double cx, double cy) {
            double pulse = 52 + Math.sin (anim_tick * 1.3) * 7;
            var halo = new Cairo.Pattern.radial (cx, cy, 0, cx, cy, pulse * 2.4);
            double a = 0.14 * pulse_scale;
            halo.add_color_stop_rgba (0.00, 0.63, 0.0, 0.9, a * 1.4);
            halo.add_color_stop_rgba (0.35, 0.63, 0.0, 0.9, a * 0.6);
            halo.add_color_stop_rgba (0.60, 1.0,  0.1, 0.0, a * 0.3);
            halo.add_color_stop_rgba (1.00, 0.0,  0.0, 0.0, 0.0);
            cr.set_source (halo);
            cr.arc (cx, cy, pulse * 2.4, 0, 2 * Math.PI);
            cr.fill ();
        }

        private void draw_particles (Cairo.Context cr) {
            for (int i = 0; i < MAX_P; i++) {
                var p = particles[i];
                if (p.alpha <= 0) {
                    continue;
                }
                double a = p.alpha * 0.80;
                switch (p.kind) {
                    case 0: {
                        var g = new Cairo.Pattern.radial (p.x, p.y, 0, p.x, p.y, p.size * 2.2);
                        if (i % 3 == 0) {
                            g.add_color_stop_rgba (0, 0.88, 0.77, 0.14, a);
                            g.add_color_stop_rgba (1, 0.88, 0.77, 0.14, 0);
                        } else if (i % 3 == 1) {
                            g.add_color_stop_rgba (0, 0.63, 0.0,  0.9,  a);
                            g.add_color_stop_rgba (1, 0.63, 0.0,  0.9,  0);
                        } else {
                            g.add_color_stop_rgba (0, 1.0,  0.14, 0.03, a);
                            g.add_color_stop_rgba (1, 1.0,  0.14, 0.03, 0);
                        }
                        cr.set_source (g);
                        cr.arc (p.x, p.y, p.size * 2.2, 0, 2 * Math.PI);
                        cr.fill ();
                        break;
                    }
                    case 1:
                        cr.set_source_rgba (0.88, 0.77, 0.14, a * 0.65);
                        cr.set_line_width (1.0);
                        cr.move_to (p.x, p.y);
                        cr.line_to (p.x - p.vx * 5, p.y - p.vy * 5);
                        cr.stroke ();
                        break;
                    default:
                        cr.set_source_rgba (0.63, 0.0, 0.9, a * 0.5);
                        cr.rectangle (p.x - p.size / 2, p.y - p.size / 2, p.size, p.size);
                        cr.fill ();
                        break;
                }
            }
        }

        private void draw_deco_ring (Cairo.Context cr, double cx, double cy) {
            double R = 70.0 * pulse_scale;
            cr.save ();
            cr.translate (cx, cy);
            cr.rotate (ring_angle);
            cr.set_line_width (2.0);
            for (int i = 0; i < 12; i++) {
                double a1 = i * 2 * Math.PI / 12;
                double a2 = a1 + Math.PI / 12 * 0.55;
                double br = 0.4 + 0.6 * Math.sin (anim_tick * 2.5 + i * 0.9);
                if (i % 3 == 0) {
                    cr.set_source_rgba (0.88, 0.77, 0.14, br * 0.75);
                } else if (i % 3 == 1) {
                    cr.set_source_rgba (0.63, 0.0,  0.9,  br * 0.75);
                } else {
                    cr.set_source_rgba (1.0,  0.14, 0.03, br * 0.75);
                }
                cr.arc (0, 0, R, a1, a2);
                cr.stroke ();
            }
            cr.rotate (-ring_angle * 1.7);
            cr.set_line_width (1.2);
            for (int i = 0; i < 8; i++) {
                double a1 = i * 2 * Math.PI / 8;
                double a2 = a1 + Math.PI / 8 * 0.4;
                cr.set_source_rgba (0.88, 0.77, 0.14, 0.35);
                cr.arc (0, 0, R - 8, a1, a2);
                cr.stroke ();
            }
            cr.restore ();
        }

        private void draw_drop_zone (Cairo.Context cr, double cx, double cy, int w, int h) {
            double r = 68.0 * pulse_scale;
            cr.save ();
            var glow = new Cairo.Pattern.radial (cx, cy, 0, cx, cy, r);
            glow.add_color_stop_rgba (0.0, 0.63, 0.0, 0.9, 0.14);
            glow.add_color_stop_rgba (0.6, 0.63, 0.0, 0.9, 0.06);
            glow.add_color_stop_rgba (1.0, 0.0,  0.0, 0.0, 0.0);
            cr.set_source (glow);
            cr.arc (cx, cy, r, 0, 2 * Math.PI);
            cr.fill ();
            double dash_unit = 2 * Math.PI * r / 24;
            cr.set_line_width (2.5);
            double[] dashes = { dash_unit * 0.6, dash_unit * 0.4 };
            cr.set_dash (dashes, ring_angle * 25);
            double ba = 0.65 + 0.35 * Math.sin (anim_tick * 2.0);
            var bp = new Cairo.Pattern.linear (cx - r, cy, cx + r, cy);
            bp.add_color_stop_rgba (0.0, 0.88, 0.77, 0.14, ba);
            bp.add_color_stop_rgba (0.5, 0.95, 0.92, 1.00, ba);
            bp.add_color_stop_rgba (1.0, 1.00, 0.14, 0.03, ba);
            cr.set_source (bp);
            cr.arc (cx, cy, r, 0, 2 * Math.PI);
            cr.stroke ();
            double[] empty = {};
            cr.set_dash (empty, 0);
            for (int li = 0; li < 3; li++) {
                double la = 0.40 - li * 0.10;
                cr.set_source_rgba (0.88, 0.77, 0.14, la);
                cr.set_line_width (1.5);
                cr.move_to (cx - 10, cy - 32 - li * 7 + arrow_y);
                cr.line_to (cx + 10, cy - 32 - li * 7 + arrow_y);
                cr.stroke ();
            }
            double aa = 0.80 + 0.20 * Math.sin (anim_tick * 3.5);
            cr.set_source_rgba (0.95, 0.92, 1.0, aa);
            cr.set_line_width (3.2);
            cr.set_line_cap (Cairo.LineCap.ROUND);
            cr.set_line_join (Cairo.LineJoin.ROUND);
            cr.move_to (cx, cy - 18 + arrow_y);
            cr.line_to (cx, cy + 12 + arrow_y);
            cr.stroke ();
            cr.move_to (cx - 15, cy - 2 + arrow_y);
            cr.line_to (cx, cy + 15 + arrow_y);
            cr.line_to (cx + 15, cy - 2 + arrow_y);
            cr.stroke ();
            if (drop_flash > 0) {
                var flash = new Cairo.Pattern.radial (cx, cy, r * 0.4, cx, cy, r * 1.9);
                flash.add_color_stop_rgba (0.0, 1.0, 1.0, 1.0, drop_flash * 0.45);
                flash.add_color_stop_rgba (1.0, 1.0, 1.0, 1.0, 0.0);
                cr.set_source (flash);
                cr.arc (cx, cy, r * 1.9, 0, 2 * Math.PI);
                cr.fill ();
            }
            cr.restore ();
        }

        private void draw_hover_label (Cairo.Context cr, double cx, double cy) {
            string text = _("Drop files here");
            cr.save ();
            var layout = Pango.cairo_create_layout (cr);
            layout.set_font_description (Pango.FontDescription.from_string ("Sans Bold 12"));
            layout.set_text (text, -1);
            int pw, ph;
            layout.get_pixel_size (out pw, out ph);
            double tx = cx - pw / 2.0;
            double ty = cy + 86.0;
            cr.move_to (tx + 1.0, ty + 1.5);
            cr.set_source_rgba (0.0, 0.0, 0.0, 0.55);
            Pango.cairo_show_layout (cr, layout);
            cr.move_to (tx, ty);
            cr.set_source_rgba (0.88, 0.77, 0.14, 0.30);
            Pango.cairo_show_layout (cr, layout);
            var tg = new Cairo.Pattern.linear (tx, 0, tx + pw, 0);
            tg.add_color_stop_rgb (0.0, 0.88, 0.77, 0.14);
            tg.add_color_stop_rgb (0.5, 0.95, 0.92, 1.00);
            tg.add_color_stop_rgb (1.0, 1.00, 0.14, 0.03);
            cr.move_to (tx, ty);
            cr.set_source (tg);
            Pango.cairo_show_layout (cr, layout);
            cr.restore ();
        }

        private void draw_processing_icon (Cairo.Context cr, double cx, double cy) {
            double r = 55.0 * pulse_scale;
            cr.save ();
            cr.set_line_cap (Cairo.LineCap.ROUND);
            var glow = new Cairo.Pattern.radial (cx, cy, 0, cx, cy, r * 0.8);
            double ga = 0.10 + 0.08 * Math.sin (anim_tick * 3.0);
            glow.add_color_stop_rgba (0.0, 0.88, 0.77, 0.14, ga);
            glow.add_color_stop_rgba (1.0, 0.0,  0.0,  0.0,  0.0);
            cr.set_source (glow);
            cr.arc (cx, cy, r * 0.8, 0, 2 * Math.PI);
            cr.fill ();
            cr.set_line_width (4.5);
            double sa = ring_angle * 3.0;
            cr.set_source_rgba (0.88, 0.77, 0.14, 0.92);
            cr.arc (cx, cy, r * 0.65, sa,               sa + Math.PI * 1.2);
            cr.stroke ();
            cr.set_source_rgba (0.63, 0.0, 0.9, 0.80);
            cr.arc (cx, cy, r * 0.65, sa + Math.PI * 1.4, sa + Math.PI * 2.2);
            cr.stroke ();
            cr.set_line_width (2.0);
            cr.set_source_rgba (1.0, 0.14, 0.03, 0.55);
            cr.arc (cx, cy, r * 0.42, -sa * 1.5, -sa * 1.5 + Math.PI * 0.9);
            cr.stroke ();
            cr.restore ();
        }

        private void draw_status_bar (Cairo.Context cr, int w, int h) {
            double margin = 20.0;
            double bar_h = 6.0;
            double bar_y = h - margin - bar_h;
            double bar_w = w - margin * 2;
            double lbl_y = bar_y - 18.0;
            cr.save ();
            var layout = Pango.cairo_create_layout (cr);
            layout.set_font_description (Pango.FontDescription.from_string ("Monospace Medium 8"));
            layout.set_text (status_text, -1);
            layout.set_width ((int)(bar_w * Pango.SCALE));
            layout.set_ellipsize (Pango.EllipsizeMode.END);
            cr.move_to (margin + 1, lbl_y + 1);
            cr.set_source_rgba (0.0, 0.0, 0.0, 0.5);
            Pango.cairo_show_layout (cr, layout);
            int tw, th;
            layout.get_pixel_size (out tw, out th);
            var tg = new Cairo.Pattern.linear (margin, 0, margin + tw, 0);
            tg.add_color_stop_rgb (0.0, 0.88, 0.77, 0.14);
            tg.add_color_stop_rgb (0.5, 0.78, 0.86, 1.00);
            tg.add_color_stop_rgb (1.0, 1.00, 0.14, 0.03);
            cr.move_to (margin, lbl_y);
            cr.set_source (tg);
            Pango.cairo_show_layout (cr, layout);
            cr.restore ();
            double radius = bar_h / 2.0;
            cr.save ();
            rounded_rect (cr, margin, bar_y, bar_w, bar_h, radius);
            cr.set_source_rgba (0.05, 0.10, 0.20, 0.75);
            cr.fill ();
            rounded_rect (cr, margin, bar_y, bar_w, bar_h, radius);
            cr.set_source_rgba (0.4, 0.2, 0.6, 0.4);
            cr.set_line_width (0.8);
            cr.stroke ();
            if (_fraction > 0.0) {
                double fill_w = bar_w * _fraction;
                cr.save ();
                cr.rectangle (margin, bar_y, fill_w, bar_h);
                cr.clip ();
                rounded_rect (cr, margin, bar_y, bar_w, bar_h, radius);
                var pg = new Cairo.Pattern.linear (margin, 0, margin + bar_w, 0);
                pg.add_color_stop_rgb (0.0, 0.63, 0.0,  0.90);
                pg.add_color_stop_rgb (0.5, 0.88, 0.50, 0.14);
                pg.add_color_stop_rgb (1.0, 1.0,  0.14, 0.03);
                cr.set_source (pg);
                cr.fill ();
                rounded_rect (cr, margin, bar_y, fill_w, bar_h / 2.0, radius);
                cr.set_source_rgba (1.0, 1.0, 1.0, 0.18);
                cr.fill ();
                cr.restore ();
            }
            if (_fraction > 0.0 && _fraction < 1.0) {
                double edge_x  = margin + bar_w * _fraction;
                double edge_cy = bar_y + bar_h / 2.0;
                double ga = 0.5 + 0.5 * Math.sin (anim_tick * 6.0);
                var eg = new Cairo.Pattern.radial (edge_x, edge_cy, 0, edge_x, edge_cy, 8);
                eg.add_color_stop_rgba (0.0, 1.0, 0.9, 0.4, ga * 0.9);
                eg.add_color_stop_rgba (1.0, 1.0, 0.9, 0.4, 0.0);
                cr.set_source (eg);
                cr.arc (edge_x, edge_cy, 8, 0, 2 * Math.PI);
                cr.fill ();
            }
            cr.restore ();
        }

        private void rounded_rect (Cairo.Context cr, double x, double y, double w, double h, double r) {
            cr.new_path ();
            cr.arc (x + r, y + r, r, Math.PI, 3 * Math.PI / 2);
            cr.arc (x + w - r, y + r, r, 3 * Math.PI / 2, 0);
            cr.arc (x + w - r, y + h - r, r, 0, Math.PI / 2);
            cr.arc (x + r, y + h - r, r, Math.PI / 2, Math.PI);
            cr.close_path ();
        }

        public void on_drag_enter () {
            if (_state == DropState.IDLE || _state == DropState.DONE) {
                fraction = 0.0;
                status_text = _("Drop files here");
                drop_state = DropState.HOVERING;
            }
        }

        public void on_drag_leave () {
            if (_state == DropState.HOVERING) {
                drop_state = DropState.IDLE;
            }
        }

        public void on_drop (string urisi, DnDFilesCallback ucallback) {
            if (_state == DropState.PROCESSING) {
                return;
            }
            drop_flash = 1.0;
            fraction = 0.0;
            status_text = _("Processing…");
            drop_state = DropState.PROCESSING;
            if (urisi.contains ("\n")) {
                var uris = urisi.split ("\n");
                int xs = 0;
                var lent = uris.length;
                GLib.Timeout.add (500, () => {
                    var uri = uris[xs];
                    xs++;
                    var fraction = (double) xs / (double) lent;
                    update_progress (fraction, _("Loading… %d/%d %s").printf (xs, lent, sanitize_utf8 (uri).make_valid ()));
                    if (xs >= lent) {
                        status_text = _("Completed!");
                        fraction = 1.0;
                        GLib.Timeout.add (1000, () => {
                            drop_state = DropState.IDLE;
                            target_overlay = 0.0;
                            if (ucallback != null) {
                                ucallback (urisi);
                            }
                            return false;
                        });
                        return false;
                    }
                    return true;
                });
            } else {
                update_progress (1.0, sanitize_utf8 (urisi).make_valid ());
                status_text = _("Completed!");
                fraction = 1.0;
                GLib.Timeout.add (1000, () => {
                    drop_state = DropState.IDLE;
                    target_overlay = 0.0;
                    if (ucallback != null) {
                        ucallback (urisi);
                    }
                    return false;
                });
            }
        }

        public void processing_dl (string info, DnDScreenCallback callback) {
            if (_state == DropState.PROCESSING) {
                return;
            }
            drop_flash = 1.0;
            fraction = 0.0;
            status_text = info;
            drop_state = DropState.PROCESSING;
            GLib.Timeout.add (1000, () => {
                if (callback != null) {
                    callback ();
                }
                return false;
            });
        }

        public void update_progress (double frac, string label) {
            fraction = frac;
            status_text = label;
        }

        public void status_dm (string info) {
            status_text = info;
            fraction = 1.0;
            GLib.Timeout.add (1000, () => {
                drop_state = DropState.IDLE;
                target_overlay = 0.0;
                return false;
            });
        }

        public void sts_finish (DnDScreenCallback callback) {
            status_text = _("Done!  ✓");
            fraction = 1.0;
            GLib.Timeout.add (1000, () => {
                drop_state = DropState.IDLE;
                target_overlay = 0.0;
                if (callback != null) {
                    callback ();
                }
                return false;
            });
        }
    }
}