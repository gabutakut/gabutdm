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

        public SplashMode mode = SplashMode.DEFAULT;
        public uint fadein = 10;
        private string _status_text = "Initializing…";
        public string status_text {
            get  { return _status_text; }
            set  {
                _status_text = value;
                drawing.queue_draw ();
            }
        }
        private string _title_text = _("Gabut Download Manager");
        public string title_text {
            get  { return _title_text; }
            set  {
                _title_text = value;
                drawing.queue_draw ();
            }
        }

        public double fraction = 0.0;
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
            Object (application: app, decorated: false, resizable: false, default_width: 520, height_request: 320);
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

            GLib.Timeout.add (14, () => {
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
                    if (particles[i].life >= particles[i].max_life)
                        spawn_particle (ref particles[i], false);
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
                    case 1: p.x = -8;  p.y = GLib.Random.double_range (0, cy);  break;
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
            switch (mode) {
                case SplashMode.PROCESSING:
                    draw_processing_icon (cr, cx, cy);
                    break;
                case SplashMode.SETTING:
                    draw_setting_icon (cr, cx, cy);
                    break;
                case SplashMode.LOCAL_SERVER:
                    draw_local_server_icon (cr, cx, cy);
                    break;
                case SplashMode.OPEN_FILE:
                    draw_open_file_icon (cr, cx, cy);
                    break;
                case SplashMode.INSERT_LINK:
                    draw_insert_link_icon (cr, cx, cy);
                    break;
                case SplashMode.HLS_PROCESSING:
                    draw_hls_icon (cr, cx, cy);
                    break;
                case SplashMode.START:
                    draw_rocket_launch (cr, cx, cy);
                    break;
                case SplashMode.STOP:
                    draw_rocket_land (cr, cx, cy);
                    break;
                case SplashMode.START_ALL:
                    draw_rockets_launch (cr, cx, cy);
                    break;
                case SplashMode.STOP_ALL:
                    draw_rockets_land (cr, cx, cy);
                    break;
                case SplashMode.DIALOG_PROGRESS:
                    draw_dialog_progress (cr, cx, cy);
                    break;
                case SplashMode.PROPERTIES:
                    draw_properties (cr, cx, cy);
                    break;
                case SplashMode.CLIPBOARD:
                    draw_clipboard_icon (cr, cx, cy);
                    break;
                default:
                    draw_icon (cr, cx, cy);
                    break;
            }
            draw_appname    (cr, cx, cy);
            draw_status_bar (cr, w, h);
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
            cr.arc (cx, cy, r * 0.65, sa, sa + Math.PI * 1.2);
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

        private void draw_setting_icon (Cairo.Context cr, double cx, double cy) {
            cr.save ();
            double r1 = 26.0 * pulse_scale;
            double r2 = 15.0 * pulse_scale;
            double gx1 = cx - 13.0, gy1 = cy + 4.0;
            double gx2 = gx1 + r1 + r2 - 2.0, gy2 = cy - 8.0;
            double angle1 =  ring_angle;
            double angle2 = -ring_angle * (r1 / r2);
            double ga = 0.13 + 0.07 * Math.sin (anim_tick * 2.5);
            var glow = new Cairo.Pattern.radial (cx, cy, 0, cx, cy, 58);
            glow.add_color_stop_rgba (0.0, 0.88, 0.77, 0.14, ga * 1.6);
            glow.add_color_stop_rgba (0.5, 0.63, 0.0,  0.90, ga * 0.6);
            glow.add_color_stop_rgba (1.0, 0.0,  0.0,  0.0,  0.0);
            cr.set_source (glow);
            cr.arc (cx, cy, 58, 0, 2 * Math.PI);
            cr.fill ();
            draw_gear (cr, gx1, gy1, r1, 10, angle1, 0.88, 0.77, 0.14);
            draw_gear (cr, gx2, gy2, r2,  6, angle2, 0.63, 0.0,  0.90);
            cr.restore ();
        }

        private void draw_gear (Cairo.Context cr, double gx, double gy, double r, int teeth, double angle, double red, double green, double blue) {
            double tooth_h = r * 0.38;
            double sector  = 2.0 * Math.PI / teeth;
            cr.save ();
            cr.translate (gx, gy);
            cr.rotate (angle);
            var glow = new Cairo.Pattern.radial (0, 0, 0, 0, 0, r + tooth_h);
            glow.add_color_stop_rgba (0.0, red, green, blue, 0.20);
            glow.add_color_stop_rgba (1.0, 0,   0,     0,    0.0);
            cr.set_source (glow);
            cr.arc (0, 0, r + tooth_h, 0, 2 * Math.PI);
            cr.fill ();
            cr.new_path ();
            for (int i = 0; i < teeth; i++) {
                double a = i * sector;
                cr.arc (0, 0, r, a + sector * 0.12, a + sector * 0.38);
                cr.line_to (Math.cos (a + sector * 0.42) * (r + tooth_h), Math.sin (a + sector * 0.42) * (r + tooth_h));
                cr.line_to (Math.cos (a + sector * 0.58) * (r + tooth_h), Math.sin (a + sector * 0.58) * (r + tooth_h));
                cr.line_to (Math.cos (a + sector * 0.62) * r, Math.sin (a + sector * 0.62) * r);
            }
            cr.close_path ();
            var fill_g = new Cairo.Pattern.radial (0, 0, 0, 0, 0, r);
            fill_g.add_color_stop_rgba (0.0, red * 0.35, green * 0.35, blue * 0.35, 0.88);
            fill_g.add_color_stop_rgba (1.0, red * 0.75, green * 0.45, blue * 0.80, 0.92);
            cr.set_source (fill_g);
            cr.fill_preserve ();
            cr.set_source_rgba (red, green, blue, 0.88);
            cr.set_line_width (1.5);
            cr.stroke ();
            cr.set_source_rgba (0.06, 0.03, 0.10, 0.96);
            cr.arc (0, 0, r * 0.28, 0, 2 * Math.PI);
            cr.fill ();
            cr.set_source_rgba (red, green, blue, 0.72);
            cr.set_line_width (1.2);
            cr.arc (0, 0, r * 0.28, 0, 2 * Math.PI);
            cr.stroke ();
            double sh = ring_angle * 2.0;
            cr.set_source_rgba (1.0, 1.0, 0.9, 0.30);
            cr.set_line_width (1.8);
            cr.arc (0, 0, r * 0.65, sh, sh + Math.PI * 0.5);
            cr.stroke ();

            cr.restore ();
        }

        private void draw_local_server_icon (Cairo.Context cr, double cx, double cy) {
            cr.save ();
            for (int i = 1; i <= 4; i++) {
                double phase = anim_tick * 2.2 - i * 0.75;
                double pa = 0.55 * double.max (0.0, Math.sin (phase));
                double radius = (16.0 + i * 14.0) * pulse_scale;
                double t = (double) i / 4.0;
                cr.set_source_rgba (0.0, 0.85 - t * 0.2, 0.45 + t * 0.3, pa * 0.55);
                cr.set_line_width (1.4);
                cr.arc (cx, cy - 6, radius, 0, 2 * Math.PI);
                cr.stroke ();
            }
            double ga = 0.15 + 0.08 * Math.sin (anim_tick * 1.8);
            var glow = new Cairo.Pattern.radial (cx, cy, 0, cx, cy, 52);
            glow.add_color_stop_rgba (0.0, 0.0, 0.85, 0.45, ga * 1.7);
            glow.add_color_stop_rgba (1.0, 0.0, 0.0,  0.0,  0.0);
            cr.set_source (glow);
            cr.arc (cx, cy, 52, 0, 2 * Math.PI);
            cr.fill ();
            double sw = 56, sh = 44;
            double sx = cx - sw / 2.0, sy = cy - sh / 2.0;
            rounded_rect (cr, sx, sy, sw, sh, 5);
            var sbg = new Cairo.Pattern.linear (sx, sy, sx, sy + sh);
            sbg.add_color_stop_rgba (0.0, 0.14, 0.16, 0.28, 0.96);
            sbg.add_color_stop_rgba (1.0, 0.04, 0.05, 0.11, 0.96);
            cr.set_source (sbg);
            cr.fill ();

            rounded_rect (cr, sx, sy, sw, sh, 5);
            cr.set_source_rgba (0.0, 0.85, 0.45, 0.68);
            cr.set_line_width (1.2);
            cr.stroke ();

            for (int i = 0; i < 3; i++) {
                double slot_y = sy + 5.0 + i * 12.0;
                rounded_rect (cr, sx + 6, slot_y, sw - 12, 9, 2);
                cr.set_source_rgba (0.02, 0.02, 0.06, 0.92);
                cr.fill ();
                double frac = 0.25 + 0.55 * (Math.sin (anim_tick * 2.1 + i * 1.15)).abs ();
                rounded_rect (cr, sx + 6, slot_y, (sw - 12) * frac, 9, 2);
                var bar_g = new Cairo.Pattern.linear (sx + 6, 0, sx + 6 + sw, 0);
                bar_g.add_color_stop_rgba (0.0, 0.0, 0.85, 0.45, 0.58);
                bar_g.add_color_stop_rgba (1.0, 0.0, 0.55, 0.85, 0.58);
                cr.set_source (bar_g);
                cr.fill ();
                double led_a = 0.35 + 0.65 * (Math.sin (anim_tick * 3.6 + i * 1.8)).abs ();
                cr.set_source_rgba (0.10, 1.0, 0.35, led_a);
                cr.arc (sx + sw - 10.5, slot_y + 4.5, 2.8, 0, 2 * Math.PI);
                cr.fill ();
            }

            double dot_a = 0.5 + 0.5 * Math.sin (anim_tick * 4.0);
            cr.set_source_rgba (0.0, 1.0, 0.45, dot_a * 0.9);
            cr.arc (cx, sy + sh + 9, 3.5, 0, 2 * Math.PI);
            cr.fill ();
            cr.set_source_rgba (0.0, 1.0, 0.45, dot_a * 0.25);
            cr.arc (cx, sy + sh + 9, 7.5, 0, 2 * Math.PI);
            cr.fill ();

            cr.restore ();
        }

        private void draw_open_file_icon (Cairo.Context cr, double cx, double cy) {
            cr.save ();

            for (int i = 0; i < 6; i++) {
                double orbit = 38.0 + 5.0 * Math.sin (anim_tick * 2.0 + i);
                double phase = anim_tick * 1.7 + i * (2.0 * Math.PI / 6.0);
                double px = cx + Math.cos (phase) * orbit;
                double py = cy + Math.sin (phase) * orbit;
                double pa = 0.40 + 0.50 * Math.sin (anim_tick * 3.0 + i * 1.2);
                double ps = 4.5  + 2.5 * Math.sin (anim_tick * 2.5 + i);

                if (i % 2 == 0) {
                    cr.set_source_rgba (0.88, 0.60, 0.14, pa);
                } else {
                    cr.set_source_rgba (0.63, 0.0,  0.90, pa);
                }
                rounded_rect (cr, px - ps / 2.0, py - ps / 2.0, ps, ps, 1.5);
                cr.fill ();
                cr.set_source_rgba (0.88, 0.60, 0.14, pa * 0.20);
                cr.set_line_width (0.8);
                cr.move_to (px, py);
                cr.line_to (cx, cy);
                cr.stroke ();
            }
            double ga = 0.14 + 0.10 * Math.sin (anim_tick * 2.8);
            var glow = new Cairo.Pattern.radial (cx, cy, 0, cx, cy, 44);
            glow.add_color_stop_rgba (0.0, 0.88, 0.55, 0.0, ga * 1.9);
            glow.add_color_stop_rgba (1.0, 0.0,  0.0,  0.0, 0.0);
            cr.set_source (glow);
            cr.arc (cx, cy, 44, 0, 2 * Math.PI);
            cr.fill ();
            double fw = 36.0, fh = 44.0, fold = 9.0;
            double fx = cx - fw / 2.0, fy = cy - fh / 2.0;
            cr.new_path ();
            cr.move_to (fx, fy + fold);
            cr.line_to (fx + fw - fold, fy);
            cr.line_to (fx + fw, fy + fold);
            cr.line_to (fx + fw, fy + fh);
            cr.line_to (fx, fy + fh);
            cr.close_path ();
            var file_bg = new Cairo.Pattern.linear (fx, fy, fx, fy + fh);
            file_bg.add_color_stop_rgba (0.0, 0.22, 0.14, 0.06, 0.93);
            file_bg.add_color_stop_rgba (1.0, 0.08, 0.05, 0.02, 0.93);
            cr.set_source (file_bg);
            cr.fill_preserve ();
            cr.set_source_rgba (0.88, 0.60, 0.14, 0.82);
            cr.set_line_width (1.5);
            cr.stroke ();
            cr.new_path ();
            cr.move_to (fx + fw - fold, fy);
            cr.line_to (fx + fw - fold, fy + fold);
            cr.line_to (fx + fw, fy + fold);
            cr.set_source_rgba (0.88, 0.60, 0.14, 0.40);
            cr.fill ();
            double ala = 0.65 + 0.35 * Math.sin (anim_tick * 5.0);
            cr.set_source_rgba (1.0, 0.85, 0.25, ala);
            cr.set_line_width (2.8);
            cr.set_line_cap (Cairo.LineCap.ROUND);
            double ax = cx, ay2 = cy + 7.0;
            cr.move_to (ax, cy - 10.0);
            cr.line_to (ax, ay2);
            cr.stroke ();
            cr.move_to (ax - 8.5, ay2 - 8.0);
            cr.line_to (ax, ay2);
            cr.line_to (ax + 8.5, ay2 - 8.0);
            cr.stroke ();
            cr.restore ();
        }

        private void draw_insert_link_icon (Cairo.Context cr, double cx, double cy) {
            cr.save ();
            double ga = 0.12 + 0.08 * Math.sin (anim_tick * 2.4);
            var glow = new Cairo.Pattern.radial (cx, cy, 0, cx, cy, 56);
            glow.add_color_stop_rgba (0.0, 0.10, 0.65, 1.0, ga * 1.8);
            glow.add_color_stop_rgba (0.5, 0.0,  0.35, 0.8, ga * 0.5);
            glow.add_color_stop_rgba (1.0, 0.0,  0.0,  0.0, 0.0);
            cr.set_source (glow);
            cr.arc (cx, cy, 56, 0, 2 * Math.PI);
            cr.fill ();

            double bw = 90.0, bh = 14.0;
            double bx = cx - bw / 2.0, by = cy + 16.0;
            rounded_rect (cr, bx, by, bw, bh, 4);
            cr.set_source_rgba (0.05, 0.08, 0.18, 0.92);
            cr.fill ();
            rounded_rect (cr, bx, by, bw, bh, 4);
            cr.set_source_rgba (0.10, 0.65, 1.0, 0.60);
            cr.set_line_width (1.0);
            cr.stroke ();

            cr.save ();
            cr.rectangle (bx + 4, by, bw - 8, bh);
            cr.clip ();
            var layout = Pango.cairo_create_layout (cr);
            layout.set_font_description (Pango.FontDescription.from_string ("Monospace 6"));
            layout.set_text ("https://allmagneturl.com/", -1);
            int tw, th;
            layout.get_pixel_size (out tw, out th);
            double reveal = Math.fmod (anim_tick * 18.0, tw + 20.0);
            double tx_off = (reveal < bw - 8) ? 0.0 : -(reveal - (bw - 8));
            cr.move_to (bx + 4 + tx_off, by + (bh - th) / 2.0);
            cr.set_source_rgba (0.55, 0.90, 1.0, 0.88);
            Pango.cairo_show_layout (cr, layout);
            cr.restore ();

            double cur_a = (Math.sin (anim_tick * 6.5) > 0.0) ? 0.9 : 0.0;
            cr.set_source_rgba (1.0, 1.0, 1.0, cur_a);
            cr.set_line_width (1.2);
            cr.move_to (bx + bw - 8, by + 3);
            cr.line_to (bx + bw - 8, by + bh - 3);
            cr.stroke ();

            double chain_y = cy - 10.0;
            double travel = Math.fmod (anim_tick * 1.4, Math.PI);
            double merge_gap = 28.0 * Math.cos (travel);

            cr.set_line_cap (Cairo.LineCap.ROUND);

            cr.save ();
            cr.translate (cx - merge_gap - 12, chain_y);
            cr.set_line_width (4.5);
            cr.set_source_rgba (0.10, 0.65, 1.0, 0.92);
            cr.arc (0, 0, 14, Math.PI * 0.5, Math.PI * 1.5);
            cr.stroke ();
            cr.set_source_rgba (0.55, 0.90, 1.0, 0.30);
            cr.set_line_width (2.0);
            cr.arc (0, 0, 14, Math.PI * 0.5, Math.PI * 1.5);
            cr.stroke ();
            cr.restore ();

            cr.save ();
            cr.translate (cx + merge_gap + 12, chain_y);
            cr.set_line_width (4.5);
            cr.set_source_rgba (0.88, 0.50, 1.0, 0.92);
            cr.arc (0, 0, 14, -Math.PI * 0.5, Math.PI * 0.5);
            cr.stroke ();
            cr.set_source_rgba (0.95, 0.80, 1.0, 0.30);
            cr.set_line_width (2.0);
            cr.arc (0, 0, 14, -Math.PI * 0.5, Math.PI * 0.5);
            cr.stroke ();
            cr.restore ();

            if (merge_gap < 6.0) {
                double sa = (1.0 - merge_gap / 6.0) * 0.9;
                var sg = new Cairo.Pattern.radial (cx, chain_y, 0, cx, chain_y, 14);
                sg.add_color_stop_rgba (0.0, 1.0, 0.95, 0.55, sa);
                sg.add_color_stop_rgba (1.0, 0.0, 0.0,  0.0,  0.0);
                cr.set_source (sg);
                cr.arc (cx, chain_y, 14, 0, 2 * Math.PI);
                cr.fill ();
            }

            cr.restore ();
        }

        private void draw_hls_icon (Cairo.Context cr, double cx, double cy) {
            cr.save ();

            double ga = 0.14 + 0.09 * Math.sin (anim_tick * 2.0);
            var glow = new Cairo.Pattern.radial (cx, cy, 0, cx, cy, 58);
            glow.add_color_stop_rgba (0.0, 1.0, 0.25, 0.10, ga * 1.6);
            glow.add_color_stop_rgba (0.5, 0.80, 0.05, 0.40, ga * 0.5);
            glow.add_color_stop_rgba (1.0, 0.0,  0.0,  0.0,  0.0);
            cr.set_source (glow);
            cr.arc (cx, cy, 58, 0, 2 * Math.PI);
            cr.fill ();

            double fs_w = 88.0, fs_h = 36.0;
            double fs_x = cx - fs_w / 2.0, fs_y = cy - fs_h / 2.0 - 8.0;
            double hole_w = 7.0, hole_h = 5.0, hole_gap = 11.5;

            rounded_rect (cr, fs_x, fs_y, fs_w, fs_h, 3);
            cr.set_source_rgba (0.10, 0.05, 0.02, 0.95);
            cr.fill ();
            rounded_rect (cr, fs_x, fs_y, fs_w, fs_h, 3);
            cr.set_source_rgba (1.0, 0.40, 0.05, 0.70);
            cr.set_line_width (1.2);
            cr.stroke ();

            for (int i = 0; i < 7; i++) {
                double hx = fs_x + 4.0 + i * hole_gap;
                rounded_rect (cr, hx, fs_y + 2, hole_w, hole_h, 1.5);
                cr.set_source_rgba (0.0, 0.0, 0.0, 0.85);
                cr.fill ();
                rounded_rect (cr, hx, fs_y + 2, hole_w, hole_h, 1.5);
                cr.set_source_rgba (1.0, 0.40, 0.05, 0.45);
                cr.set_line_width (0.6);
                cr.stroke ();
                rounded_rect (cr, hx, fs_y + fs_h - hole_h - 2, hole_w, hole_h, 1.5);
                cr.set_source_rgba (0.0, 0.0, 0.0, 0.85);
                cr.fill ();
                rounded_rect (cr, hx, fs_y + fs_h - hole_h - 2, hole_w, hole_h, 1.5);
                cr.set_source_rgba (1.0, 0.40, 0.05, 0.45);
                cr.set_line_width (0.6);
                cr.stroke ();
            }

            int n_frames = 5;
            double fw_frame = (fs_w - 8.0) / n_frames;
            double frame_y = fs_y + hole_h + 4.0;
            double frame_h2 = fs_h - (hole_h + 4.0) * 2;
            double scroll_off = Math.fmod (anim_tick * 18.0, fw_frame);

            cr.save ();
            cr.rectangle (fs_x + 4, frame_y, fs_w - 8, frame_h2);
            cr.clip ();

            for (int i = -1; i <= n_frames + 1; i++) {
                double fx2 = fs_x + 4.0 + i * fw_frame - scroll_off;
                double seg_alpha = 0.35 + 0.30 * Math.sin (anim_tick * 1.8 + i * 0.9);
                if (i % 2 == 0) {
                    cr.set_source_rgba (1.0, 0.25, 0.05, seg_alpha * 0.55);
                } else {
                    cr.set_source_rgba (0.80, 0.10, 0.30, seg_alpha * 0.40);
                }
                cr.rectangle (fx2 + 1, frame_y + 1, fw_frame - 2, frame_h2 - 2);
                cr.fill ();

                cr.set_source_rgba (1.0, 0.40, 0.05, 0.35);
                cr.set_line_width (0.8);
                cr.move_to (fx2, frame_y);
                cr.line_to (fx2, frame_y + frame_h2);
                cr.stroke ();
            }

            double scan_x = fs_x + 4.0 + Math.fmod (anim_tick * 28.0, fs_w - 8.0);
            var scan_g = new Cairo.Pattern.linear (scan_x - 6, 0, scan_x + 6, 0);
            scan_g.add_color_stop_rgba (0.0, 1.0, 0.90, 0.40, 0.0);
            scan_g.add_color_stop_rgba (0.5, 1.0, 0.90, 0.40, 0.75);
            scan_g.add_color_stop_rgba (1.0, 1.0, 0.90, 0.40, 0.0);
            cr.set_source (scan_g);
            cr.rectangle (scan_x - 6, frame_y, 12, frame_h2);
            cr.fill ();

            cr.restore ();

            int n_bars = 16;
            double bar_zone_w = 80.0;
            double bar_spacing = bar_zone_w / n_bars;
            double bar_bx = cx - bar_zone_w / 2.0;
            double bar_base  = cy + 26.0;
            double max_bar_h = 14.0;

            for (int i = 0; i < n_bars; i++) {
                double phase = anim_tick * 3.5 + i * 0.45;
                double bh2 = max_bar_h *  (Math.sin (phase)).abs ();
                double bx2 = bar_bx + i * bar_spacing;
                double by2 = bar_base - bh2;
                double t = (double) i / n_bars;
                cr.set_source_rgba (1.0 - t * 0.3, 0.30 + t * 0.40, 0.05 + t * 0.55, 0.80);
                rounded_rect (cr, bx2 + 1, by2, bar_spacing - 2, bh2, 1.2);
                cr.fill ();
            }

            cr.save ();
            var lbl = Pango.cairo_create_layout (cr);
            lbl.set_font_description (Pango.FontDescription.from_string ("Monospace Bold 7"));
            lbl.set_text ("HLS/M3U8", -1);
            int lw, lh;
            lbl.get_pixel_size (out lw, out lh);
            cr.move_to (cx - lw / 2.0 + 1, cy - 5.5 + 1);
            cr.set_source_rgba (0.0, 0.0, 0.0, 0.55);
            Pango.cairo_show_layout (cr, lbl);
            cr.move_to (cx - lw / 2.0, cy - 5.5);
            cr.set_source_rgba (1.0, 0.85, 0.30, 0.92);
            Pango.cairo_show_layout (cr, lbl);
            cr.restore ();
            cr.restore ();
        }

        private void draw_single_rocket (Cairo.Context cr, double scale, double flame_power) {
            cr.save ();
            cr.scale (scale, scale);
            if (flame_power > 0.001) {
                double fp = flame_power;
                double fh = 28.0 * fp;
                var fg1 = new Cairo.Pattern.radial (0, 18, 0, 0, 18 + fh * 0.6, fh * 0.8);
                fg1.add_color_stop_rgba (0.0, 1.0, 0.65, 0.10, 0.90 * fp);
                fg1.add_color_stop_rgba (0.5, 1.0, 0.30, 0.05, 0.55 * fp);
                fg1.add_color_stop_rgba (1.0, 0.8, 0.10, 0.0,  0.0);
                cr.set_source (fg1);
                cr.move_to (-7, 18);
                cr.curve_to (-10, 18 + fh * 0.5, -4, 18 + fh, 0, 18 + fh);
                cr.curve_to  (4,  18 + fh,  10,  18 + fh * 0.5, 7, 18);
                cr.close_path ();
                cr.fill ();
                var fg2 = new Cairo.Pattern.radial (0, 18, 0, 0, 18 + fh * 0.4, fh * 0.4);
                fg2.add_color_stop_rgba (0.0, 1.0, 0.98, 0.80, 0.98 * fp);
                fg2.add_color_stop_rgba (1.0, 1.0, 0.70, 0.10, 0.0);
                cr.set_source (fg2);
                cr.move_to (-4, 18);
                cr.curve_to (-5, 18 + fh * 0.35, 0, 18 + fh * 0.6, 0, 18 + fh * 0.55);
                cr.curve_to  (0, 18 + fh * 0.6, 5, 18 + fh * 0.35, 4, 18);
                cr.close_path ();
                cr.fill ();
            }
            cr.set_source_rgba (0.88, 0.30, 0.10, 0.92);
            cr.new_path ();
            cr.move_to (-6, 10);
            cr.line_to (-14, 20);
            cr.line_to (-6, 18);
            cr.close_path ();
            cr.fill ();
            cr.new_path ();
            cr.move_to (6, 10);
            cr.line_to (14, 20);
            cr.line_to (6, 18);
            cr.close_path ();
            cr.fill ();
            var body_g = new Cairo.Pattern.linear (-8, -22, 8, 18);
            body_g.add_color_stop_rgba (0.0, 0.95, 0.95, 1.00, 0.97);
            body_g.add_color_stop_rgba (0.5, 0.80, 0.82, 0.90, 0.97);
            body_g.add_color_stop_rgba (1.0, 0.55, 0.58, 0.70, 0.97);
            cr.set_source (body_g);
            cr.new_path ();
            cr.move_to (-7, 10);
            cr.line_to (-7, -8);
            cr.curve_to (-7, -22, 7, -22, 7, -8);
            cr.line_to (7, 10);
            cr.arc (0, 10, 7, 0, Math.PI);
            cr.close_path ();
            cr.fill ();
            cr.set_source_rgba (1.0, 1.0, 1.0, 0.30);
            cr.set_line_width (1.2);
            cr.new_path ();
            cr.move_to (-5, 8);
            cr.line_to (-5, -6);
            cr.curve_to (-5, -18, 5, -18, 5, -6);
            cr.line_to (5, 8);
            cr.stroke ();
            cr.set_source_rgba (0.95, 0.20, 0.12, 0.92);
            cr.new_path ();
            cr.move_to (-3.5, -10);
            cr.curve_to (-3.5, -20, 3.5, -20, 3.5, -10);
            cr.line_to (3.5, -8);
            cr.line_to (-3.5, -8);
            cr.close_path ();
            cr.fill ();
            cr.set_source_rgba (0.45, 0.80, 1.0, 0.88);
            cr.arc (0, -2, 4.5, 0, 2 * Math.PI);
            cr.fill ();
            cr.set_source_rgba (1.0, 1.0, 1.0, 0.55);
            cr.arc (-1.2, -3.5, 1.8, 0, 2 * Math.PI);
            cr.fill ();
            cr.restore ();
        }

        private void draw_rocket_launch (Cairo.Context cr, double cx, double cy) {
            cr.save ();
            double ga = 0.14 + 0.08 * Math.sin (anim_tick * 3.5);
            var glow = new Cairo.Pattern.radial (cx, cy + 10, 0, cx, cy + 10, 60);
            glow.add_color_stop_rgba (0.0, 1.0, 0.55, 0.10, ga * 2.0);
            glow.add_color_stop_rgba (0.5, 1.0, 0.25, 0.05, ga * 0.6);
            glow.add_color_stop_rgba (1.0, 0.0, 0.0,  0.0,  0.0);
            cr.set_source (glow);
            cr.arc (cx, cy + 10, 60, 0, 2 * Math.PI);
            cr.fill ();
            cr.set_source_rgba (0.40, 0.35, 0.28, 0.55);
            cr.set_line_width (2.5);
            cr.move_to (cx - 44, cy + 28);
            cr.line_to (cx + 44, cy + 28);
            cr.stroke ();
            cr.set_source_rgba (0.50, 0.45, 0.38, 0.70);
            cr.set_line_width (3.0);
            cr.move_to (cx - 12, cy + 28);
            cr.line_to (cx - 6, cy + 16);
            cr.stroke ();
            cr.move_to (cx + 12, cy + 28);
            cr.line_to (cx + 6, cy + 16);
            cr.stroke ();
            cr.move_to (cx - 6, cy + 16);
            cr.line_to (cx + 6, cy + 16);
            cr.stroke ();
            for (int i = 0; i < 6; i++) {
                double sa  = 0.12 + 0.10 * Math.sin (anim_tick * 2.5 + i * 1.1);
                double sr  = 8.0 + i * 3.5 + 4.0 * Math.sin (anim_tick * 1.8 + i);
                double sxo = (i % 2 == 0 ? -1 : 1) * (5.0 + i * 4.0);
                double syo = cy + 20 + i * 3.0 + 3.0 * Math.sin (anim_tick * 2.0 + i * 0.7);
                cr.set_source_rgba (0.75, 0.72, 0.68, sa);
                cr.arc (cx + sxo, syo, sr, 0, 2 * Math.PI);
                cr.fill ();
            }
            double launch_y = cy - 8.0 - 12.0 * (Math.sin (anim_tick * 2.8)).abs ();
            cr.save ();
            cr.translate (cx, launch_y);
            draw_single_rocket (cr, 1.15, 0.65 + 0.35 * (Math.sin (anim_tick * 4.0)).abs ());
            cr.restore ();
            for (int i = 0; i < 4; i++) {
                double sa2 = (0.45 - i * 0.09) * (Math.sin (anim_tick * 4.0)).abs ();
                double sl  = 8.0 + i * 4.0;
                double sxo = (i % 2 == 0 ? -3.5 : 3.5);
                cr.set_source_rgba (1.0, 0.75, 0.20, sa2);
                cr.set_line_width (1.5 - i * 0.25);
                cr.set_line_cap (Cairo.LineCap.ROUND);
                cr.move_to (cx + sxo, launch_y + 18);
                cr.line_to (cx + sxo, launch_y + 18 + sl);
                cr.stroke ();
            }
            cr.restore ();
        }

        private void draw_rocket_land (Cairo.Context cr, double cx, double cy) {
            cr.save ();
            double ga = 0.10 + 0.06 * Math.sin (anim_tick * 2.2);
            var glow = new Cairo.Pattern.radial (cx, cy, 0, cx, cy, 56);
            glow.add_color_stop_rgba (0.0, 0.25, 0.70, 1.0, ga * 1.6);
            glow.add_color_stop_rgba (1.0, 0.0,  0.0,  0.0, 0.0);
            cr.set_source (glow);
            cr.arc (cx, cy, 56, 0, 2 * Math.PI);
            cr.fill ();
            cr.set_source_rgba (0.40, 0.35, 0.28, 0.50);
            cr.set_line_width (2.0);
            cr.move_to (cx - 44, cy + 28);
            cr.line_to (cx + 44, cy + 28);
            cr.stroke ();
            double leg_alpha = 0.70 + 0.18 * Math.sin (anim_tick * 1.5);
            cr.set_source_rgba (0.60, 0.62, 0.70, leg_alpha);
            cr.set_line_width (2.8);
            cr.set_line_cap (Cairo.LineCap.ROUND);
            cr.move_to (cx - 5, cy + 16);
            cr.line_to (cx - 16, cy + 28);
            cr.stroke ();
            cr.move_to (cx + 5, cy + 16);
            cr.line_to (cx + 16, cy + 28);
            cr.stroke ();
            cr.move_to (cx - 16, cy + 28);
            cr.line_to (cx - 10, cy + 28);
            cr.stroke ();
            cr.move_to (cx + 16, cy + 28);
            cr.line_to (cx + 10, cy + 28);
            cr.stroke ();
            double land_y = cy - 4.0 + 2.5 * Math.sin (anim_tick * 3.2);
            cr.save ();
            cr.translate (cx, land_y);
            draw_single_rocket (cr, 1.10, 0.30 + 0.20 * Math.sin (anim_tick * 6.0));
            cr.restore ();
            for (int i = 0; i < 3; i++) {
                double dr = 10.0 + i * 8.0 + 4.0 * Math.sin (anim_tick * 1.8 + i * 0.9);
                double da = (0.22 - i * 0.06) * double.max (0.0, Math.sin (anim_tick * 1.5 + i));
                cr.set_source_rgba (0.80, 0.78, 0.72, da);
                cr.set_line_width (1.5);
                cr.arc (cx, cy + 28, dr, 0, 2 * Math.PI);
                cr.stroke ();
            }
            cr.restore ();
        }

        private void draw_rockets_launch (Cairo.Context cr, double cx, double cy) {
            cr.save ();
            double ga = 0.16 + 0.10 * Math.sin (anim_tick * 3.0);
            var glow = new Cairo.Pattern.radial (cx, cy + 14, 0, cx, cy + 14, 75);
            glow.add_color_stop_rgba (0.0, 1.0, 0.60, 0.05, ga * 1.8);
            glow.add_color_stop_rgba (0.5, 0.90, 0.25, 0.05, ga * 0.5);
            glow.add_color_stop_rgba (1.0, 0.0,  0.0,  0.0,  0.0);
            cr.set_source (glow);
            cr.arc (cx, cy + 14, 75, 0, 2 * Math.PI);
            cr.fill ();
            cr.set_source_rgba (0.40, 0.35, 0.28, 0.50);
            cr.set_line_width (2.0);
            cr.move_to (cx - 70, cy + 30);
            cr.line_to (cx + 70, cy + 30);
            cr.stroke ();
            double[] r_xo = { -44.0, -22.0, 0.0, 22.0, 44.0 };
            double[] r_phase = { 0.00, 0.55, 1.10, 0.40, 0.85 };
            double[] r_scale = { 0.58, 0.78, 1.00, 0.78, 0.58 };
            for (int i = 0; i < 5; i++) {
                double ly = cy + 2.0 - 14.0 * r_scale[i] * (Math.sin (anim_tick * 2.5 + r_phase[i])).abs ();
                double fp = 0.55 + 0.40 * (Math.sin (anim_tick * 4.0 + r_phase[i])).abs ();
                cr.set_source_rgba (0.78, 0.74, 0.70, (0.10 + 0.07 * Math.sin (anim_tick * 2.0 + r_phase[i])) * r_scale[i]);
                cr.arc (cx + r_xo[i], cy + 24, 9.0 * r_scale[i], 0, 2 * Math.PI);
                cr.fill ();
                cr.save ();
                cr.translate (cx + r_xo[i], ly);
                draw_single_rocket (cr, r_scale[i], fp);
                cr.restore ();
            }
            for (int i = 0; i < 5; i++) {
                cr.set_source_rgba (0.72, 0.70, 0.66, 0.08 + 0.07 * Math.sin (anim_tick * 1.8 + i * 0.9));
                cr.arc (cx + (i % 2 == 0 ? -1 : 1) * i * 9.0, cy + 26, 10.0 + i * 5.0, 0, 2 * Math.PI);
                cr.fill ();
            }
            cr.restore ();
        }

        private void draw_rockets_land (Cairo.Context cr, double cx, double cy) {
            cr.save ();
            double ga = 0.12 + 0.07 * Math.sin (anim_tick * 2.0);
            var glow = new Cairo.Pattern.radial (cx, cy, 0, cx, cy, 72);
            glow.add_color_stop_rgba (0.0, 0.20, 0.65, 1.0, ga * 1.6);
            glow.add_color_stop_rgba (0.5, 0.10, 0.30, 0.70, ga * 0.4);
            glow.add_color_stop_rgba (1.0, 0.0,  0.0,  0.0,  0.0);
            cr.set_source (glow);
            cr.arc (cx, cy, 72, 0, 2 * Math.PI);
            cr.fill ();
            cr.set_source_rgba (0.40, 0.35, 0.28, 0.50);
            cr.set_line_width (2.0);
            cr.move_to (cx - 70, cy + 30);
            cr.line_to (cx + 70, cy + 30);
            cr.stroke ();
            double[] l_xo    = { -44.0, -22.0,  0.0,  22.0, 44.0 };
            double[] l_phase = {  0.20,  0.70,  0.00,  0.50, 1.05 };
            double[] l_scale = {  0.55,  0.75,  0.98,  0.75, 0.55 };
            for (int i = 0; i < 5; i++) {
                double lx  = cx + l_xo[i];
                double sc  = l_scale[i];
                double ly  = cy - 2.0 + 4.0 * sc * Math.sin (anim_tick * 2.8 + l_phase[i]);
                double rbf = 0.20 + 0.18 * Math.sin (anim_tick * 5.0 + l_phase[i]);
                cr.set_source_rgba (0.58, 0.60, 0.68, 0.65 * sc);
                cr.set_line_width (2.0 * sc);
                cr.set_line_cap (Cairo.LineCap.ROUND);
                cr.move_to (lx - 4 * sc, ly + 16 * sc);
                cr.line_to (lx - 12 * sc, cy + 30);
                cr.stroke ();
                cr.move_to (lx + 4 * sc, ly + 16 * sc);
                cr.line_to (lx + 12 * sc, cy + 30);
                cr.stroke ();
                cr.set_source_rgba (0.78, 0.75, 0.70, 0.18 * sc * double.max (0.0, Math.sin (anim_tick * 1.5 + l_phase[i])));
                cr.arc (lx, cy + 30, 10.0 * sc, 0, 2 * Math.PI);
                cr.fill ();
                cr.save ();
                cr.translate (lx, ly);
                draw_single_rocket (cr, sc, rbf);
                cr.restore ();
            }
            cr.restore ();
        }

        private void draw_properties (Cairo.Context cr, double cx, double cy) {
            cr.save ();
            double r = 32.0 * pulse_scale;
            double tooth_h = r * 0.40;
            int teeth = 12;
            double sector = 2.0 * Math.PI / teeth;
            double angle = ring_angle * 1.4;
            double ga = 0.14 + 0.08 * Math.sin (anim_tick * 2.0);
            var glow = new Cairo.Pattern.radial (cx, cy, 0, cx, cy, r + tooth_h + 14);
            glow.add_color_stop_rgba (0.0, 0.88, 0.70, 0.14, ga * 1.8);
            glow.add_color_stop_rgba (0.5, 0.63, 0.10, 0.80, ga * 0.7);
            glow.add_color_stop_rgba (1.0, 0.0,  0.0,  0.0,  0.0);
            cr.set_source (glow);
            cr.arc (cx, cy, r + tooth_h + 14, 0, 2 * Math.PI);
            cr.fill ();
            cr.save ();
            cr.translate (cx, cy);
            cr.rotate (angle);
            var tglow = new Cairo.Pattern.radial (0, 0, r * 0.5, 0, 0, r + tooth_h);
            tglow.add_color_stop_rgba (0.0, 0.88, 0.77, 0.14, 0.0);
            tglow.add_color_stop_rgba (0.7, 0.88, 0.77, 0.14, 0.18 * pulse_scale);
            tglow.add_color_stop_rgba (1.0, 1.0,  0.45, 0.05, 0.0);
            cr.set_source (tglow);
            cr.arc (0, 0, r + tooth_h, 0, 2 * Math.PI);
            cr.fill ();
            cr.new_path ();
            for (int i = 0; i < teeth; i++) {
                double a = i * sector;
                cr.arc (0, 0, r, a + sector * 0.10, a + sector * 0.40);
                cr.line_to (Math.cos (a + sector * 0.44) * (r + tooth_h), Math.sin (a + sector * 0.44) * (r + tooth_h));
                cr.line_to (Math.cos (a + sector * 0.56) * (r + tooth_h), Math.sin (a + sector * 0.56) * (r + tooth_h));
                cr.line_to (Math.cos (a + sector * 0.60) * r, Math.sin (a + sector * 0.60) * r);
            }
            cr.close_path ();
            var fill_g = new Cairo.Pattern.radial (0, 0, r * 0.15, 0, 0, r + tooth_h);
            fill_g.add_color_stop_rgba (0.0, 0.30, 0.20, 0.06, 0.96);
            fill_g.add_color_stop_rgba (0.5, 0.18, 0.12, 0.04, 0.96);
            fill_g.add_color_stop_rgba (1.0, 0.10, 0.06, 0.02, 0.96);
            cr.set_source (fill_g);
            cr.fill_preserve ();
            double rc = 0.5 + 0.5 * Math.sin (anim_tick * 1.8);
            cr.set_source_rgba (0.88 + rc * 0.12, 0.50 + rc * 0.27, 0.05 + rc * 0.85, 0.90);
            cr.set_line_width (1.8);
            cr.stroke ();
            cr.set_line_width (1.0);
            for (int i = 0; i < 6; i++) {
                double sa     = i * Math.PI / 3.0;
                double bright = 0.35 + 0.40 * Math.sin (anim_tick * 2.5 + i * 1.05);
                cr.set_source_rgba (0.88, 0.77, 0.14, bright * 0.55);
                cr.move_to (Math.cos (sa) * r * 0.28, Math.sin (sa) * r * 0.28);
                cr.line_to (Math.cos (sa) * r * 0.82, Math.sin (sa) * r * 0.82);
                cr.stroke ();
            }
            cr.set_source_rgba (0.06, 0.04, 0.10, 0.97);
            cr.arc (0, 0, r * 0.26, 0, 2 * Math.PI);
            cr.fill ();
            var hub_g = new Cairo.Pattern.radial (0, 0, 0, 0, 0, r * 0.26);
            hub_g.add_color_stop_rgba (0.0, 0.88, 0.77, 0.14, 0.0);
            hub_g.add_color_stop_rgba (1.0, 0.88, 0.77, 0.14, 0.85);
            cr.set_source (hub_g);
            cr.set_line_width (1.5);
            cr.arc (0, 0, r * 0.26, 0, 2 * Math.PI);
            cr.stroke ();
            cr.set_source_rgba (0.88, 0.77, 0.14, 0.60);
            cr.arc (0, 0, r * 0.10, 0, 2 * Math.PI);
            cr.fill ();
            double sh = anim_tick * 2.5;
            cr.set_source_rgba (1.0, 0.97, 0.80, 0.55);
            cr.set_line_width (2.2);
            cr.arc (0, 0, r * 0.65, sh, sh + Math.PI * 0.30);
            cr.stroke ();
            cr.set_source_rgba (1.0, 0.60, 0.20, 0.28);
            cr.arc (0, 0, r * 0.65, sh + Math.PI, sh + Math.PI * 1.30);
            cr.stroke ();
            cr.restore ();
            cr.restore ();
        }

        private void draw_dialog_progress (Cairo.Context cr, double cx, double cy) {
            cr.save ();
            double ga = 0.13 + 0.08 * Math.sin (anim_tick * 1.8);
            var glow = new Cairo.Pattern.radial (cx, cy, 0, cx, cy, 58);
            glow.add_color_stop_rgba (0.0, 1.0, 0.75, 0.20, ga * 1.8);
            glow.add_color_stop_rgba (0.5, 0.80, 0.35, 0.05, ga * 0.6);
            glow.add_color_stop_rgba (1.0, 0.0,  0.0,  0.0,  0.0);
            cr.set_source (glow);
            cr.arc (cx, cy, 58, 0, 2 * Math.PI);
            cr.fill ();
            double hg_tilt = 0.08 * Math.sin (anim_tick * 0.7);
            cr.save ();
            cr.translate (cx, cy);
            cr.rotate (hg_tilt);
            double hw = 28.0;
            double hh = 38.0;
            cr.new_path ();
            cr.move_to (-hw, -hh);
            cr.curve_to (-hw, -hh * 0.55, -5, -4,  0,  0);
            cr.curve_to   (5,   4,  hw,  hh * 0.55,  hw,  hh);
            cr.line_to (-hw,  hh);
            cr.curve_to (-hw,  hh * 0.55, -5,  4,  0,  0);
            cr.curve_to   (5,  -4,  hw, -hh * 0.55,  hw, -hh);
            cr.close_path ();
            var glass_g = new Cairo.Pattern.linear (0, -hh, 0, hh);
            glass_g.add_color_stop_rgba (0.0, 0.20, 0.15, 0.05, 0.82);
            glass_g.add_color_stop_rgba (0.5, 0.14, 0.10, 0.03, 0.88);
            glass_g.add_color_stop_rgba (1.0, 0.20, 0.15, 0.05, 0.82);
            cr.set_source (glass_g);
            cr.fill ();
            cr.new_path ();
            cr.move_to (-hw, -hh);
            cr.curve_to (-hw, -hh * 0.55, -5, -4,  0,  0);
            cr.curve_to   (5,   4,  hw,  hh * 0.55,  hw,  hh);
            cr.line_to (-hw,  hh);
            cr.curve_to (-hw,  hh * 0.55, -5,  4,  0,  0);
            cr.curve_to   (5,  -4,  hw, -hh * 0.55,  hw, -hh);
            cr.close_path ();
            cr.set_source_rgba (0.95, 0.75, 0.25, 0.78);
            cr.set_line_width (2.0);
            cr.stroke ();
            double phase = Math.fmod (anim_tick * 0.22, 1.0);
            double upper_fill = 1.0 - phase;
            if (upper_fill > 0.01) {
                cr.save ();
                cr.new_path ();
                cr.move_to (-hw + 1, -hh + 1);
                cr.curve_to (-hw + 1, -hh * 0.55, -4, -5,  0,  0);
                cr.curve_to   (4,   5,  hw - 1,  hh * 0.55,  hw - 1,  hh - 1);
                cr.line_to (-hw + 1,  hh - 1);
                cr.curve_to (-hw + 1,  hh * 0.55, -4,  5,  0,  0);
                cr.curve_to   (4,  -5,  hw - 1, -hh * 0.55,  hw - 1, -hh + 1);
                cr.close_path ();
                cr.clip ();
                double sand_top = -hh + 2;
                double sand_bot = -hh * 0.08;
                double sand_y   = sand_top + (sand_bot - sand_top) * (1.0 - upper_fill);
                double sand_hw2 = hw * ((-sand_y) / hh);
                cr.new_path ();
                cr.move_to (-sand_hw2, sand_y);
                cr.line_to ( sand_hw2, sand_y);
                cr.curve_to  (sand_hw2 * 0.3, sand_y * 0.35, sand_hw2 * 0.3, sand_y * 0.35, 0, 0);
                cr.curve_to (-sand_hw2 * 0.3, sand_y * 0.35, -sand_hw2 * 0.3, sand_y * 0.35, -sand_hw2, sand_y);
                cr.close_path ();
                var sg = new Cairo.Pattern.linear (0, sand_y, 0, 0);
                sg.add_color_stop_rgba (0.0, 0.95, 0.78, 0.22, 0.92);
                sg.add_color_stop_rgba (0.5, 0.88, 0.62, 0.12, 0.90);
                sg.add_color_stop_rgba (1.0, 0.70, 0.42, 0.08, 0.85);
                cr.set_source (sg);
                cr.fill ();
                cr.restore ();
            }
            double lower_fill = phase;
            if (lower_fill > 0.01) {
                cr.save ();
                cr.new_path ();
                cr.move_to (-hw + 1, -hh + 1);
                cr.curve_to (-hw + 1, -hh * 0.55, -4, -5,  0,  0);
                cr.curve_to   (4,   5,  hw - 1,  hh * 0.55,  hw - 1,  hh - 1);
                cr.line_to (-hw + 1,  hh - 1);
                cr.curve_to (-hw + 1,  hh * 0.55, -4,  5,  0,  0);
                cr.curve_to   (4,  -5,  hw - 1, -hh * 0.55,  hw - 1, -hh + 1);
                cr.close_path ();
                cr.clip ();
                double bot      = hh - 2;
                double top_sand = bot - (bot - hh * 0.08) * lower_fill;
                double sw2      = hw * ((bot - top_sand) / (bot - hh * 0.04) * 0.92);
                cr.new_path ();
                cr.move_to (-sw2, top_sand);
                cr.curve_to (-sw2 * 0.5, top_sand - 4, sw2 * 0.5, top_sand - 4, sw2, top_sand);
                cr.line_to  ( sw2, bot);
                cr.line_to  (-sw2, bot);
                cr.close_path ();
                var lg = new Cairo.Pattern.linear (0, top_sand, 0, bot);
                lg.add_color_stop_rgba (0.0, 0.98, 0.82, 0.30, 0.88);
                lg.add_color_stop_rgba (1.0, 0.80, 0.50, 0.08, 0.92);
                cr.set_source (lg);
                cr.fill ();
                cr.restore ();
            }
            double stream_a   = 0.70 + 0.30 * Math.sin (anim_tick * 8.0);
            double stream_len = 8.0  + 4.0 * (Math.sin (anim_tick * 3.5)).abs ();
            var stg = new Cairo.Pattern.linear (0, -2, 0, stream_len + 2);
            stg.add_color_stop_rgba (0.0, 0.98, 0.82, 0.30, stream_a);
            stg.add_color_stop_rgba (1.0, 0.98, 0.82, 0.30, 0.0);
            cr.set_source (stg);
            cr.set_line_width (1.8);
            cr.set_line_cap (Cairo.LineCap.ROUND);
            cr.move_to (0, -1);
            cr.line_to (0, stream_len);
            cr.stroke ();
            for (int i = 0; i < 3; i++) {
                double dot_y = Math.fmod (anim_tick * 35.0 + i * 18.0, 28.0) - 2;
                double dot_a = (1.0 - dot_y / 26.0) * 0.75;
                if (dot_y > 0 && dot_y < 26 && dot_a > 0) {
                    cr.set_source_rgba (0.98, 0.85, 0.35, dot_a);
                    cr.arc (0, dot_y, 1.4, 0, 2 * Math.PI);
                    cr.fill ();
                }
            }
            for (int side = -1; side <= 1; side += 2) {
                double cy2 = side * (hh + 1.5);
                var cap_g = new Cairo.Pattern.linear (-hw - 2, 0, hw + 2, 0);
                cap_g.add_color_stop_rgba (0.0, 0.60, 0.45, 0.10, 0.95);
                cap_g.add_color_stop_rgba (0.5, 0.95, 0.78, 0.28, 0.98);
                cap_g.add_color_stop_rgba (1.0, 0.60, 0.45, 0.10, 0.95);
                cr.set_source (cap_g);
                rounded_rect (cr, -hw - 2, cy2 - 3.5, (hw + 2) * 2, 7.0, 2.5);
                cr.fill ();
                cr.set_source_rgba (1.0, 0.88, 0.40, 0.65);
                cr.set_line_width (0.8);
                rounded_rect (cr, -hw - 2, cy2 - 3.5, (hw + 2) * 2, 7.0, 2.5);
                cr.stroke ();
            }
            cr.new_path ();
            cr.move_to (-hw + 3, -hh + 5);
            cr.curve_to (-hw + 2, -hh * 0.4, -3, -3, 0, 0);
            cr.set_source_rgba (1.0, 1.0, 1.0, 0.18);
            cr.set_line_width (1.5);
            cr.stroke ();
            cr.set_source_rgba (0.95, 0.78, 0.28, 0.45);
            cr.set_line_width (0.8);
            for (int i = 0; i < 8; i++) {
                double tx = -hw - 1.5 + i * ((hw + 2) * 2 / 7.0);
                cr.move_to (tx, -hh - 0.5);
                cr.line_to (tx, -hh - 4.5);
                cr.stroke ();
            }
            cr.restore ();
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
            for (int y = 0; y < h; y += 4) cr.rectangle (0, y, w, 1);
            cr.fill ();
        }

        private void draw_streams (Cairo.Context cr, int w, int h) {
            for (int i = 0; i < NUM_S; i++) {
                var s   = streams[i];
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
                if (p.alpha <= 0) continue;
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

        private void draw_appname (Cairo.Context cr, double cx, double cy) {
            cr.save ();
            var layout = Pango.cairo_create_layout (cr);
            layout.set_font_description (Pango.FontDescription.from_string ("Sans Bold 14"));
            layout.set_text (_title_text, -1);
            int pw, ph;
            layout.get_pixel_size (out pw, out ph);
            double tx = cx - pw / 2.0, ty = cy + 72;
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
            double margin = 20.0, bar_h = 6.0;
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
            cr.rel_line_to (  6.982422, 4.806641);
            cr.curve_to (41.052686, 42.722531, 40.243102, 52.679833, 27.572266, 52.345703);
            cr.curve_to (15.574856, 52.029328, 8.3125, 41.662109, 8.3125, 41.662109);
            cr.rel_curve_to (0.0, 0.0,  8.126359, 17.345365, 23.835938, 15.869141);
            cr.rel_curve_to (14.165601, -1.331141, 18.501169, -8.643982, 18.867187, -9.306641);
            cr.rel_line_to ( 7.214844, 4.964844);
            cr.rel_line_to ( 1.158203, -14.587891);
            cr.close_path ();
        }

        private void rounded_rect (Cairo.Context cr, double x, double y, double w, double h, double r) {
            cr.new_path ();
            cr.arc (x + r, y + r, r, Math.PI, 3 * Math.PI / 2);
            cr.arc (x + w - r, y + r, r, 3 * Math.PI / 2, 0);
            cr.arc (x + w - r, y + h - r, r, 0, Math.PI / 2);
            cr.arc (x + r, y + h - r, r, Math.PI / 2, Math.PI);
            cr.close_path ();
        }

        private void draw_clipboard_icon (Cairo.Context cr, double cx, double cy) {
            cr.save ();
            double ga = 0.12 + 0.08 * Math.sin (anim_tick * 2.2);
            var glow = new Cairo.Pattern.radial (cx, cy, 0, cx, cy, 60);
            glow.add_color_stop_rgba (0.0, 0.20, 0.80, 1.0,  ga * 1.8);
            glow.add_color_stop_rgba (0.5, 0.10, 0.40, 0.75, ga * 0.5);
            glow.add_color_stop_rgba (1.0, 0.0,  0.0,  0.0,  0.0);
            cr.set_source (glow);
            cr.arc (cx, cy, 60, 0, 2 * Math.PI);
            cr.fill ();

            double fly_phase = Math.fmod (anim_tick * 0.75, 2.0 * Math.PI);
            double fly_a = 0.22 + 0.20 * Math.sin (fly_phase);
            double fly_ox = 14.0 * Math.sin (fly_phase * 0.45);
            double fly_oy = -6.0 - 11.0 * (1.0 - Math.cos (fly_phase)) * 0.5;
            double fly_sc = 0.48 + 0.07 * Math.sin (fly_phase);

            cr.save ();
            cr.translate (cx + 24.0 + fly_ox, cy - 14.0 + fly_oy);
            cr.scale (fly_sc, fly_sc);

            rounded_rect (cr, -14.0, 0.0, 28.0, 36.0, 3.5);
            cr.set_source_rgba (0.20, 0.75, 1.0, fly_a * 0.80);
            cr.fill ();
            rounded_rect (cr, -14.0, 0.0, 28.0, 36.0, 3.5);
            cr.set_source_rgba (0.45, 0.90, 1.0, fly_a * 1.3);
            cr.set_line_width (1.8);
            cr.stroke ();

            rounded_rect (cr, -9.0, -5.0, 18.0, 8.0, 2.5);
            cr.set_source_rgba (0.30, 0.65, 0.95, fly_a * 1.2);
            cr.fill ();

            for (int i = 0; i < 3; i++) {
                double glw = (i == 1) ? 18.0 : 24.0;
                rounded_rect (cr, -12.0, 8.0 + i * 8.0, glw, 3.0, 1.2);
                cr.set_source_rgba (0.55, 0.90, 1.0, fly_a * 0.65);
                cr.fill ();
            }
            cr.restore ();

            double cw = 46.0 * pulse_scale;
            double ch = 58.0 * pulse_scale;
            double cbx = cx - cw / 2.0;
            double cby = cy - ch / 2.0 + 5.0;

            cr.save ();
            cr.translate (2.5, 3.5);
            rounded_rect (cr, cbx, cby, cw, ch, 4.5);
            cr.set_source_rgba (0.0, 0.0, 0.0, 0.28);
            cr.fill ();
            cr.restore ();

            rounded_rect (cr, cbx, cby, cw, ch, 4.5);
            var body_g = new Cairo.Pattern.linear (cbx, cby, cbx, cby + ch);
            body_g.add_color_stop_rgba (0.0, 0.11, 0.18, 0.30, 0.96);
            body_g.add_color_stop_rgba (1.0, 0.04, 0.07, 0.14, 0.96);
            cr.set_source (body_g);
            cr.fill ();

            rounded_rect (cr, cbx, cby, cw, ch, 4.5);
            double border_a = 0.50 + 0.38 * Math.sin (anim_tick * 2.6);
            cr.set_source_rgba (0.20, 0.75, 1.0, border_a);
            cr.set_line_width (1.5);
            cr.stroke ();

            double sh_a = 0.12 + 0.10 * Math.sin (anim_tick * 1.5);
            var sh_g = new Cairo.Pattern.linear (cbx, cby, cbx + cw * 0.5, cby);
            sh_g.add_color_stop_rgba (0.0, 1.0, 1.0, 1.0, sh_a);
            sh_g.add_color_stop_rgba (1.0, 1.0, 1.0, 1.0, 0.0);
            cr.save ();
            cr.rectangle (cbx + 1, cby + 1, cw * 0.5, ch - 2);
            cr.clip ();
            rounded_rect (cr, cbx, cby, cw, ch, 4.5);
            cr.set_source (sh_g);
            cr.fill ();
            cr.restore ();

            double clip_w = 20.0;
            double clip_h = 9.0;
            double clip_x = cx - clip_w / 2.0;
            double clip_y = cby - clip_h / 2.0;

            rounded_rect (cr, clip_x, clip_y, clip_w, clip_h, 3.0);
            var clip_g = new Cairo.Pattern.linear (clip_x, clip_y, clip_x, clip_y + clip_h);
            clip_g.add_color_stop_rgba (0.0, 0.32, 0.60, 0.88, 0.98);
            clip_g.add_color_stop_rgba (1.0, 0.14, 0.36, 0.65, 0.98);
            cr.set_source (clip_g);
            cr.fill ();
            rounded_rect (cr, clip_x, clip_y, clip_w, clip_h, 3.0);
            cr.set_source_rgba (0.45, 0.82, 1.0, 0.82);
            cr.set_line_width (1.0);
            cr.stroke ();

            cr.set_source_rgba (0.04, 0.08, 0.16, 0.92);
            cr.arc (cx, clip_y + clip_h / 2.0, 2.8, 0, 2 * Math.PI);
            cr.fill ();
            cr.set_source_rgba (0.20, 0.65, 1.0, 0.50);
            cr.set_line_width (0.8);
            cr.arc (cx, clip_y + clip_h / 2.0, 2.8, 0, 2 * Math.PI);
            cr.stroke ();

            int n_lines = 5;
            double line_x0 = cbx + 6.0;
            double line_area_w = cw - 12.0;
            double line_y0 = cby + 11.0;
            double line_spacing = 8.5;
            double[] line_ratios = { 1.0, 0.72, 0.88, 0.60, 0.80 };

            double reveal = Math.fmod (anim_tick * 0.55, (double)(n_lines) + 0.8);

            for (int i = 0; i < n_lines; i++) {
                double ly = line_y0 + i * line_spacing;
                double lw = line_area_w * line_ratios[i];
                double fill_frac;
                double la;
                if ((double) i < reveal - 1.0) {
                    fill_frac = 1.0;
                    la = 0.72;
                } else if ((double) i < reveal) {
                    fill_frac = reveal - (double) i;
                    la = 0.92;
                } else {
                    fill_frac = 0.0;
                    la = 0.0;
                }
                rounded_rect (cr, line_x0, ly, lw, 3.8, 1.6);
                cr.set_source_rgba (0.08, 0.14, 0.25, 0.55);
                cr.fill ();

                if (fill_frac > 0.01) {
                    double filled_w = lw * fill_frac;
                    cr.save ();
                    cr.rectangle (line_x0, ly, filled_w, 3.8);
                    cr.clip ();
                    rounded_rect (cr, line_x0, ly, lw, 3.8, 1.6);
                    var lg = new Cairo.Pattern.linear (line_x0, 0, line_x0 + lw, 0);
                    lg.add_color_stop_rgba (0.0, 0.18, 0.75, 1.0, la);
                    lg.add_color_stop_rgba (1.0, 0.55, 0.92, 1.0, la * 0.65);
                    cr.set_source (lg);
                    cr.fill ();
                    cr.restore ();
                }
            }

            double cur_idx  = Math.floor (reveal);
            if (cur_idx < n_lines) {
                double cur_frac = reveal - cur_idx;
                double lw_cur = line_area_w * line_ratios[(int) cur_idx];
                double cur_x = line_x0 + lw_cur * cur_frac + 2.0;
                double cur_y = line_y0 + cur_idx * line_spacing;
                double cur_a = (Math.sin (anim_tick * 9.0) > 0.0) ? 0.95 : 0.0;
                cr.set_source_rgba (0.75, 0.96, 1.0, cur_a);
                cr.set_line_width (1.6);
                cr.set_line_cap (Cairo.LineCap.ROUND);
                cr.move_to (cur_x, cur_y - 1.0);
                cr.line_to (cur_x, cur_y + 5.0);
                cr.stroke ();
            }

            for (int i = 0; i < 6; i++) {
                double sp_phase = anim_tick * 1.8 + i * (Math.PI / 3.0);
                double sp_r = 32.0 + 5.0 * Math.sin (sp_phase * 0.65);
                double sp_x = cx + Math.cos (sp_phase) * sp_r;
                double sp_y = cy + Math.sin (sp_phase) * sp_r * 0.55;
                double sp_a = 0.18 + 0.55 * Math.sin (sp_phase * 1.4);
                double sp_size = 1.8 + 1.4 * Math.sin (sp_phase * 1.9);
                double t = (double) i / 6.0;
                cr.set_source_rgba (0.20 + t * 0.30, 0.75 + t * 0.15, 1.0, sp_a * 0.75);
                cr.arc (sp_x, sp_y, sp_size, 0, 2 * Math.PI);
                cr.fill ();
            }

            double check_reveal = reveal / (double) n_lines;
            if (check_reveal > 0.85) {
                double ck_a = (check_reveal - 0.85) / 0.15;
                double ck_a2 = ck_a * (0.70 + 0.25 * Math.sin (anim_tick * 3.5));
                double ck_x = cbx + cw - 8.0;
                double ck_y = cby + ch - 8.0;

                var ck_glow = new Cairo.Pattern.radial (ck_x, ck_y, 0, ck_x, ck_y, 8);
                ck_glow.add_color_stop_rgba (0.0, 0.20, 1.0, 0.55, ck_a2 * 0.80);
                ck_glow.add_color_stop_rgba (1.0, 0.0,  0.0, 0.0,  0.0);
                cr.set_source (ck_glow);
                cr.arc (ck_x, ck_y, 8, 0, 2 * Math.PI);
                cr.fill ();

                cr.set_source_rgba (0.05, 0.12, 0.20, 0.88 * ck_a2);
                cr.arc (ck_x, ck_y, 6.5, 0, 2 * Math.PI);
                cr.fill ();

                cr.set_source_rgba (0.20, 1.0, 0.55, ck_a2);
                cr.set_line_width (1.8);
                cr.set_line_cap (Cairo.LineCap.ROUND);
                cr.set_line_join (Cairo.LineJoin.ROUND);
                cr.move_to (ck_x - 3.5, ck_y);
                cr.line_to (ck_x - 0.8, ck_y + 2.8);
                cr.line_to (ck_x + 3.8, ck_y - 3.2);
                cr.stroke ();
            }
            cr.restore ();
        }

        public override bool close_request () {
            pulse_str = false;
            return base.close_request ();
        }

        private void fade_in () {
            GLib.Timeout.add (fadein, () => {
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
            GLib.Timeout.add (fadein, () => {
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
            if (lent < 1) { status_dm ("Ready!  ✓"); return; }
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
            GLib.Timeout.add (150, () => {
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
            fraction = 1.0;
            status_text = info;
            GLib.Timeout.add (450, () => {
                fade_out (uris);
                return false;
            });
        }
    }
}