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
    public class SplashScreen : Gtk.Window {
        public signal void preparing ();
        public signal void open_files (string uris);
        public bool is_processing = false;

        private string _status_text = "Initializing…";
        public string status_text {
            get {
                return _status_text;
            }
            set {
                _status_text = value;
                drawing.queue_draw ();
            }
        }
        private string _title_text = _("Gabut Download Manager");
        public string title_text {
            get {
                return _title_text;
            }
            set {
                _title_text = value;
                drawing.queue_draw ();
            }
        }
        private double fraction = 0.0;
        private double anim_tick = 0.0;
        private double ring_angle = 0.0;
        private double pulse_scale = 1.0;
        private bool pulse_grow = true;
        private bool pulse_str = true;

        private Gtk.DrawingArea drawing;

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
        private Stream[] streams;
        private const int NUM_S = 14;
        private Particle[] particles;
        private const int MAX_P = 70;

        public SplashScreen (Gtk.Application app) {
            Object (application: app, decorated: false, resizable: false, default_width: 520, default_height: 320);
        }

        construct {
            particles = new Particle[MAX_P];
            for (int i = 0; i < MAX_P; i++) {
                spawn_particle (ref particles[i], true);
            }
            streams = new Stream[NUM_S];
            for (int i = 0; i < NUM_S; i++) {
                streams[i].offset = GLib.Random.double_range (0, 520);
                streams[i].speed = GLib.Random.double_range (1.2, 3.8);
                streams[i].alpha = GLib.Random.double_range (0.06, 0.22);
                streams[i].width = GLib.Random.double_range (25, 80);
                streams[i].y = GLib.Random.double_range (0.45, 0.90);
            }

            drawing = new Gtk.DrawingArea ();
            drawing.set_draw_func (on_draw);
            set_child (drawing);

            GLib.Timeout.add (16, () => {
                anim_tick += 0.032;
                ring_angle += 0.022;
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
                for (int i = 0; i < MAX_P; i++) {
                    particles[i].x += particles[i].vx;
                    particles[i].y += particles[i].vy;
                    particles[i].life += 1.0;
                    particles[i].alpha = 1.0 - (particles[i].life / particles[i].max_life);
                    if (particles[i].life >= particles[i].max_life) {
                        spawn_particle (ref particles[i], false);
                    }
                }
                for (int i = 0; i < NUM_S; i++) {
                    streams[i].offset += streams[i].speed;
                    if (streams[i].offset > 620) {
                        streams[i].offset = -streams[i].width;
                    }
                }
                drawing.queue_draw ();
                return pulse_str;
            });
            set_opacity (0.0);
            fade_in ();
        }

        private void spawn_particle (ref Particle p, bool random_pos) {
            double cx = 260.0, cy = 132.0;
            if (random_pos) {
                p.x = GLib.Random.double_range (0, 520);
                p.y = GLib.Random.double_range (0, 220);
            } else {
                int edge = (int) GLib.Random.double_range (0, 3);
                switch (edge) {
                    case 0: p.x = GLib.Random.double_range (0, 520); p.y = -8;  break;
                    case 1: p.x = -8; p.y = GLib.Random.double_range (0, cy); break;
                    default: p.x = 528; p.y = GLib.Random.double_range (0, cy); break;
                }
            }
            double dx = cx - p.x + GLib.Random.double_range (-30, 30);
            double dy = cy - p.y + GLib.Random.double_range (-15, 15);
            double d  = Math.sqrt (dx * dx + dy * dy);
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
            double cx = w / 2.0, cy = h / 2.0 - 30;
            draw_background (cr, w, h, cx, cy);
            draw_streams (cr, w, h);
            draw_outer_halo (cr, cx, cy);
            draw_particles (cr);
            draw_deco_ring (cr, cx, cy);
            if (is_processing) {
                draw_processing_icon (cr, cx, cy);
            } else {
                draw_icon (cr, cx, cy);
            }
            draw_appname (cr, cx, cy);
            draw_status_bar (cr, w, h);
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

        private void draw_background (Cairo.Context cr, int w, int h, double cx, double cy) {
            var bg = new Cairo.Pattern.radial (cx, cy, 0, cx, cy, w * 0.8);
            bg.add_color_stop_rgb (0.0, 0.06, 0.04, 0.10);
            bg.add_color_stop_rgb (0.5, 0.03, 0.02, 0.06);
            bg.add_color_stop_rgb (1.0, 0.01, 0.01, 0.02);
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
                double g = 0.0;
                double b = (i % 2 == 0) ? 0.90 : 0.03;
                var gr = new Cairo.Pattern.linear (s.offset, 0, s.offset + s.width, 0);
                gr.add_color_stop_rgba (0.0, r, g, b, 0.0);
                gr.add_color_stop_rgba (0.4, r, g, b, s.alpha);
                gr.add_color_stop_rgba (0.7, r, g, b, s.alpha * 0.5);
                gr.add_color_stop_rgba (1.0, r, g, b, 0.0);
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
                case 0:
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
            double R = 58.0 * pulse_scale;
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

        private void draw_icon (Cairo.Context cr, double cx, double cy) {
            double icon_px = 100.0 * pulse_scale;
            double sc = icon_px / 128.0;
            cr.save ();
            cr.translate (cx, cy);
            cr.scale (sc, sc);
            cr.translate (-64.0, -64.0);
            var m = Cairo.Matrix (2.1134425, 0, 0, 2.1134425, -4.5131611, -3.6917453);
            cr.transform (m);
            double ga = 0.28 + 0.18 * Math.sin (anim_tick * 2.2);
            for (int gi = 3; gi >= 1; gi--) {
                cr.set_source_rgba (0.882, 0.773, 0.145, ga / gi * 0.9);
                cr.set_line_width (3.336 + gi * 3.0);
                cr.arc (32.77874, 30.010742, 11.237741, 0, 2 * Math.PI);
                cr.stroke ();
                cr.set_source_rgba (0.635, 0.0, 0.898, ga / gi * 0.7);
                path_purple (cr);
                cr.fill ();
                cr.set_source_rgba (1.0, 0.141, 0.031, ga / gi * 0.7);
                path_red (cr);
                cr.fill ();
            }
            cr.set_source_rgba (0.0, 0.0, 0.0, 0.28);
            cr.save ();
            cr.scale (1.0, 0.3);
            cr.arc (30.0, 185.0, 24.0, 0, 2 * Math.PI);
            cr.fill ();
            cr.restore ();
            cr.set_line_width (3.336);
            cr.set_source_rgb (0.882, 0.773, 0.145);
            cr.arc (32.77874, 30.010742, 11.237741, 0, 2 * Math.PI);
            cr.stroke ();
            double sh1 = ring_angle * 3.0;
            cr.set_line_width (2.2);
            cr.set_source_rgba (1.0, 0.97, 0.7, 0.75);
            cr.arc (32.77874, 30.010742, 11.237741, sh1, sh1 + Math.PI * 0.42);
            cr.stroke ();
            cr.set_source_rgb (0.635, 0.0, 0.898);
            path_purple (cr);
            cr.fill ();
            cr.set_source_rgba (1.0, 0.7, 1.0, 0.20);
            path_purple (cr);
            cr.fill ();
            cr.set_source_rgb (1.0, 0.141, 0.031);
            path_red (cr);
            cr.fill ();
            cr.set_source_rgba (1.0, 0.8, 0.7, 0.20);
            path_red (cr);
            cr.fill ();
            cr.restore ();
        }

        private void path_purple (Cairo.Context cr) {
            cr.new_path ();
            cr.move_to (32.404297, 3.0390625);
            cr.curve_to (31.9282, 3.0495397, 31.446002, 3.0769148, 30.955078, 3.1230469);
            cr.curve_to (18.272629, 4.3148135, 13.463706, 10.327696, 12.326172, 12.056641);
            cr.line_to (6.8203125, 8.0800781);
            cr.line_to (5.3300781, 22.636719);
            cr.line_to (3.8378906, 37.193359);
            cr.line_to (17.191406, 31.205078);
            cr.line_to (30.542969, 25.21875);
            cr.line_to (22.009766, 19.052734);
            cr.curve_to (22.167785, 16.965632, 23.539175, 7.9904606, 35.529297, 8.3066406);
            cr.curve_to (47.526707, 8.6230142, 54.791016, 18.990234, 54.791016, 18.990234);
            cr.rel_curve_to (0.0, 0.0, -7.627716, -16.2759644, -22.386719, -15.9511715);
            cr.close_path ();
        }

        private void path_red (Cairo.Context cr) {
            cr.new_path ();
            cr.move_to (60.544922, 24.013672);
            cr.rel_line_to (-13.210938, 6.291016);
            cr.rel_line_to (-13.210937, 6.291015);
            cr.rel_line_to ( 6.982422, 4.806641);
            cr.curve_to (41.052686, 42.722531, 40.243102, 52.679833, 27.572266, 52.345703);
            cr.curve_to (15.574856, 52.029328, 8.3125, 41.662109, 8.3125, 41.662109);
            cr.rel_curve_to ( 0.0, 0.0, 8.126359, 17.345365, 23.835938, 15.869141);
            cr.rel_curve_to (14.165601, -1.331141, 18.501169, -8.643982, 18.867187, -9.306641);
            cr.rel_line_to ( 7.214844, 4.964844);
            cr.rel_line_to ( 1.158203, -14.587891);
            cr.close_path ();
        }

        private void draw_appname (Cairo.Context cr, double cx, double cy) {
            cr.save ();
            var layout = Pango.cairo_create_layout (cr);
            var desc = Pango.FontDescription.from_string ("Sans Bold 14");
            layout.set_font_description (desc);
            layout.set_text (_title_text, -1);
            int pw, ph;
            layout.get_pixel_size (out pw, out ph);
            double tx = cx - pw / 2.0;
            double ty = cy + 72;
            cr.move_to (tx + 1.0, ty + 1.5);
            cr.set_source_rgba (0.0, 0.0, 0.0, 0.55);
            Pango.cairo_show_layout (cr, layout);
            cr.move_to (tx, ty);
            cr.set_source_rgba (0.88, 0.77, 0.14, 0.32);
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

        private void draw_status_bar (Cairo.Context cr, int w, int h) {
            double margin = 20.0;
            double bar_h = 6.0;
            double bar_y = h - margin - bar_h;
            double bar_w = w - margin * 2;
            double lbl_y = bar_y - 18.0;
            cr.save ();
            var layout = Pango.cairo_create_layout (cr);
            var desc = Pango.FontDescription.from_string ("Monospace Medium 8");
            layout.set_font_description (desc);
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
            if (fraction > 0.0) {
                double fill_w = bar_w * fraction;
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

            if (fraction > 0.0 && fraction < 1.0) {
                double edge_x = margin + bar_w * fraction;
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

        public override bool close_request () {
            pulse_str = false;
            return base.close_request ();
        }

        private void fade_in () {
            GLib.Timeout.add (50, () => {
                double op = get_opacity () + 0.04;
                if (op >= 1.0) {
                    set_opacity (1.0);
                    preparing ();
                    return false;
                }
                set_opacity (op);
                return true;
            });
        }

        private void fade_out (string uris = "") {
            GLib.Timeout.add (50, () => {
                double op = get_opacity () - 0.04;
                if (op <= 0.0) {
                    if (uris != "") {
                        open_files (uris);
                    }
                    close ();
                    return false;
                }
                set_opacity (op);
                return true;
            });
        }

        public void simulate_loading (GabutWindow? gabutwindow) {
            var rows = get_download ();
            var lent = rows.length ();
            if (lent < 1) {
                status_dm ("Ready!  ✓");
                return;
            }
            int x = 0;
            GLib.Idle.add (() => {
                var row = rows.nth_data (x);
                if (!gabutwindow.get_exist (row.url)) {
                    if (row.linkmode != LinkMode.HLS) {
                        gabutwindow.on_append (row);
                        row.notify_property ("status");
                    } else {
                        string useragent = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36";
                        if (row.hashoption.has_key (AriaOptions.USER_AGENT.to_string ())) {
                            useragent = row.hashoption.@get (AriaOptions.USER_AGENT.to_string ());
                        }
                        row.pathname = row.filepath;
                        gabutwindow.append_hls (row, row.url, row.filename, row.filepath, useragent);
                    }
                }
                x++;
                fraction = (double)(x / (double) lent);
                status_text = "Loading… %d/%u %s".printf (x, lent, row.filename);
                if (x >= lent) {
                    status_dm ("Ready!  ✓");
                    return false;
                }
                return true;
            });
        }

        public void save_all_download (GabutWindow? gabutwindow) {
            var downloads = new GLib.List<DownloadRow> ();
            var models = gabutwindow.list_box.observe_children ();
            var countr = gabutwindow.count_rows_only ();
            var maxsize = models.get_n_items ();
            int x = 0;
            if (countr < 1) {
                status_dm ("Good bye!  ✓");
                return;
            }
            GLib.Idle.add (() => {
                var rchild = (Gtk.Widget) models.get_item (x);
                if (rchild is Gtk.ListBoxRow) {
                    var row = (DownloadRow) rchild;
                    if (row.url == "") {
                        return true;
                    }
                    status_text = "Saving… %d/%u %s".printf (x, countr, row.filename);
                    if (!db_option_exist (row.url)) {
                        set_dboptions (row.url, row.hashoption);
                    } else {
                        update_optionts (row.url, row.hashoption);
                    }
                    downloads.append (row);
                }
                x++;
                fraction = (double)(x / (double) maxsize);
                if (x >= maxsize) {
                    set_download (downloads);
                    status_dm ("Saved!  ✓");
                    return false;
                }
                return true;
            });
        }

        public void prosessing_files (string dict) {
            var uris = dict.split ("\n");
            var urislent = uris.length;
            int x = 0;
            var paths = "";
            GLib.Timeout.add (500, () => {
                var uri = uris[x];
                x++;
                status_text = "Processing… %d/%u %s".printf (x, urislent, uri);
                if (GLib.FileUtils.test (uri, GLib.FileTest.EXISTS)) {
                    var file = File.new_for_path (uri);
                    paths += file.get_path () + "\n";
                } else {
                    paths = uri;
                }
                fraction = (double)(x / (double) urislent);
                if (x >= urislent) {
                    status_dm ("Completed!  ✓", paths);
                    return false;
                }
                return true;
            });
        }

        public void status_dm (string info, string uris = "") {
            status_text = info;
            GLib.Timeout.add (1500, () => {
                fade_out (uris);
                return false;
            });
        }
    }
}