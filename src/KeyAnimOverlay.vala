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
    public class KeyAnimOverlay : Gtk.DrawingArea {
        private struct KeyBadge {
            public string text;
            public double x;
            public double y;
            public double alpha;
            public double scale;
            public double life;
            public double max_life;
            public bool active;
            public int hue;
        }
        private const int MAX_BADGES = 8;
        private KeyBadge[] badges;
        private double tick = 0.0;

        public KeyAnimOverlay () {
            Object (hexpand: true, vexpand: true, can_focus: false);
        }

        construct {
            badges = new KeyBadge[MAX_BADGES];
            set_draw_func (on_draw);
            GLib.Timeout.add (15, () => {
                tick += 0.05;
                bool any = false;
                bool any_just_died = false;
                for (int i = 0; i < MAX_BADGES; i++) {
                    if (!badges[i].active) {
                        continue;
                    }
                    badges[i].life += 1.0;
                    badges[i].y -= 1.4;
                    double t = badges[i].life / badges[i].max_life;
                    if (t < 0.15) {
                        badges[i].scale = 0.55 + (t / 0.15) * 0.60;
                    } else if (t < 0.28) {
                        badges[i].scale = 1.15 - ((t - 0.15) / 0.13) * 0.18;
                    } else {
                        badges[i].scale = 0.97;
                    }
                    badges[i].alpha = (t < 0.6) ? 1.0 : 1.0 - ((t - 0.6) / 0.4);
                    if (badges[i].life >= badges[i].max_life) {
                        badges[i].active = false;
                        any_just_died = true;
                    } else {
                        any = true;
                    }
                }
                if (any || any_just_died) {
                    queue_draw ();
                }
                return true;
            });
        }

        public void trigger (uint keyval, Gdk.ModifierType mods) {
            var sb = new StringBuilder ();
            if (Gdk.ModifierType.CONTROL_MASK in mods) {
                sb.append ("Ctrl+");
            }
            if (Gdk.ModifierType.SHIFT_MASK in mods) {
                sb.append ("Shift+");
            }
            if (Gdk.ModifierType.ALT_MASK in mods) {
                sb.append ("Alt+");
            }
            unowned string? name = Gdk.keyval_name (keyval);
            if (name == null || name == "Control" || name == "Shift" || name == "Alt"  || name == "Super") {
                return;
            }
            sb.append (name.up ());
            if (sb.str.length == 0) {
                return;
            }
            int slot = -1;
            double oldest = -1;
            for (int i = 0; i < MAX_BADGES; i++) {
                if (!badges[i].active) {
                    slot = i;
                    break;
                }
                if (badges[i].life > oldest) {
                    oldest = badges[i].life; slot = i;
                }
            }

            int w = get_width  ();
            int h = get_height ();
            double cx = (w > 0) ? w / 2.0 : 200.0;
            double base_y = (h > 0) ? h * 0.72 : 200.0;
            badges[slot].text = sb.str;
            badges[slot].x = cx + GLib.Random.double_range (-48, 48);
            badges[slot].y = base_y;
            badges[slot].alpha = 0.0;
            badges[slot].scale = 0.55;
            badges[slot].life = 0;
            badges[slot].max_life = 82;
            badges[slot].active = true;
            badges[slot].hue = choose_hue (keyval, mods);
            queue_draw ();
        }

        private int choose_hue (uint keyval, Gdk.ModifierType mods) {
            bool has_ctrl = Gdk.ModifierType.CONTROL_MASK in mods;
            bool has_shift = Gdk.ModifierType.SHIFT_MASK in mods;
            bool has_alt = Gdk.ModifierType.ALT_MASK in mods;
            if (has_alt) {
                return 2;
            }
            if (has_shift && has_ctrl) {
                return 1;
            }
            if (has_ctrl) {
                return 0;
            }
            return (int)(keyval % 3);
        }

        private void on_draw (Gtk.DrawingArea area, Cairo.Context cr, int w, int h) {
            cr.set_operator (Cairo.Operator.CLEAR);
            cr.paint ();
            cr.set_operator (Cairo.Operator.OVER);
            for (int i = 0; i < MAX_BADGES; i++) {
                if (!badges[i].active || badges[i].alpha <= 0.02) {
                    continue;
                }
                draw_badge (cr, ref badges[i]);
            }
        }

        private void draw_badge (Cairo.Context cr, ref KeyBadge b) {
            cr.save ();
            var layout = Pango.cairo_create_layout (cr);
            layout.set_font_description (Pango.FontDescription.from_string ("Monospace Bold 18"));
            layout.set_text (b.text, -1);
            int tw, th;
            layout.get_pixel_size (out tw, out th);
            double pad_x = 15.0;
            double pad_y = 7.0;
            double bw = tw + pad_x * 2;
            double bh = th + pad_y * 2;
            double bx = b.x - bw / 2.0;
            double by = b.y - bh / 2.0;
            double r = 7.0;
            double a = b.alpha;
            cr.translate (b.x, b.y);
            cr.scale (b.scale, b.scale);
            cr.translate (-b.x, -b.y);
            double br, bg, bb, er, eg, eb, lr, lg, lb;
            switch (b.hue) {
                case 1:
                    br = 0.12; bg = 0.09; bb = 0.00;
                    er = 0.94; eg = 0.79; eb = 0.27;
                    lr = 1.00; lg = 0.95; lb = 0.60;
                    break;
                case 2:
                    br = 0.14; bg = 0.05; bb = 0.02;
                    er = 1.00; eg = 0.42; eb = 0.20;
                    lr = 1.00; lg = 0.65; lb = 0.35;
                    break;
                default:
                    br = 0.10; bg = 0.05; bb = 0.18;
                    er = 0.77; eg = 0.50; eb = 1.00;
                    lr = 0.90; lg = 0.72; lb = 1.00;
                    break;
            }
            cr.set_source_rgba (0, 0, 0, a * 0.38);
            rounded_rect (cr, bx + 2, by + 4, bw, bh, r);
            cr.fill ();
            var bg_pat = new Cairo.Pattern.linear (bx, by, bx, by + bh);
            bg_pat.add_color_stop_rgba (0.0, br * 1.9, bg * 1.9, bb * 1.9, a * 0.93);
            bg_pat.add_color_stop_rgba (1.0, br, bg, bb, a * 0.90);
            cr.set_source (bg_pat);
            rounded_rect (cr, bx, by, bw, bh, r);
            cr.fill ();
            cr.save ();
            cr.rectangle (bx + 1, by + 1, bw - 2, bh * 0.42);
            cr.clip ();
            cr.set_source_rgba (1, 1, 1, a * 0.11);
            rounded_rect (cr, bx, by, bw, bh, r);
            cr.fill ();
            cr.restore ();
            cr.set_line_width (1.4);
            cr.set_source_rgba (er, eg, eb, a * 0.85);
            rounded_rect (cr, bx, by, bw, bh, r);
            cr.stroke ();
            var halo = new Cairo.Pattern.radial (b.x, b.y, 0, b.x, b.y, bw * 0.85);
            halo.add_color_stop_rgba (0.0, er, eg, eb, a * 0.10);
            halo.add_color_stop_rgba (1.0, er, eg, eb, 0.0);
            cr.set_source (halo);
            cr.arc (b.x, b.y, bw * 0.85, 0, 2 * Math.PI);
            cr.fill ();
            double tx = bx + pad_x;
            double ty = by + pad_y;
            var tg = new Cairo.Pattern.linear (tx, 0, tx + tw, 0);
            tg.add_color_stop_rgb (0.0, lr, lg, lb);
            tg.add_color_stop_rgb (1.0, er, eg, eb);
            cr.move_to (tx, ty);
            cr.set_source (tg);
            Pango.cairo_show_layout (cr, layout);
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
    }
}