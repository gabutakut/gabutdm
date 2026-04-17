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
    public class BitfieldWidget : Gtk.DrawingArea {
        public int status;
        public string filename = "";
        public string errorcode = "…";
        public string connectionsdl = "0";
        public string labeltransfer = "-";
        private string bitfield = "";
        private int max_rows;
        private int piece_size;
        private int total_pieces;
        private int visual_boxes_multiplier;
        private int custom_rows;
        private int custom_columns;
        private bool use_custom_grid;
        private bool show_labels;

        private const double TOP_PADDING = 16.0;
        private const double BOTTOM_PADDING = 16.0;
        private const double BOX_PADDING = 4.0;
        private const double TOP_TEXT_MARGIN = 1.0;
        private const double BOTTOM_TEXT_MARGIN = 1.0;
        private const double BOX_SIZE = 7.0;
        private const double BOX_MARGIN = 2.0;
        private const double NO_LABEL_TOP_MARGIN = 1.0;
        private const double NO_LABEL_BOTTOM_MARGIN = 1.0;

        public BitfieldWidget(bool show_labels = true, int max_rows = 3) {
            this.hexpand = true;
            this.vexpand = true;
            this.piece_size = 16;
            this.total_pieces = 0;
            this.visual_boxes_multiplier = 1;
            this.custom_rows = 2;
            this.custom_columns = 50;
            this.use_custom_grid = false;
            this.show_labels = show_labels;
            this.max_rows = max_rows;

            if (show_labels) {
                double row_height = BOX_SIZE + BOX_MARGIN;
                double calculated_height = TOP_PADDING + BOTTOM_PADDING + TOP_TEXT_MARGIN + (BOTTOM_TEXT_MARGIN > 0 ? BOTTOM_TEXT_MARGIN : 0) + (row_height * max_rows) + (2 * BOX_PADDING);
                this.height_request = (int)(calculated_height > (TOP_PADDING + BOTTOM_PADDING) ? calculated_height : (TOP_PADDING + BOTTOM_PADDING));
            } else {
                double row_height = BOX_SIZE + BOX_MARGIN;
                double calculated_height = NO_LABEL_TOP_MARGIN + NO_LABEL_BOTTOM_MARGIN + (row_height * max_rows) + (2 * BOX_PADDING);
                this.height_request = (int)calculated_height;
            }
            set_draw_func(draw_bitfield);
        }

        public void set_bitfield_data(string bitfield_hex, int piece_count) {
            this.bitfield = bitfield_hex;
            this.total_pieces = piece_count;
            queue_draw();
        }

        public void set_visual_boxes_multiplier(int multiplier) {
            if (multiplier >= 1 && multiplier <= 10) {
                this.visual_boxes_multiplier = multiplier;
                queue_draw();
            }
        }

        public int get_visual_boxes_multiplier() {
            return this.visual_boxes_multiplier;
        }

        public void set_custom_grid(int rows, int columns) {
            if (rows >= 1 && rows <= 20 && columns >= 1 && columns <= 200) {
                this.custom_rows = rows;
                this.custom_columns = columns;
                this.use_custom_grid = true;
                queue_draw();
            }
        }

        public void set_custom_grid_simple(int columns) {
            if (columns >= 1 && columns <= 200) {
                this.custom_columns = columns;
                this.custom_rows = this.max_rows;
                this.use_custom_grid = true;
                queue_draw();
            }
        }

        public void reset_to_auto_grid() {
            this.use_custom_grid = false;
            queue_draw();
        }

        public int get_custom_rows() {
            return this.custom_rows;
        }

        public int get_custom_columns() {
            return this.custom_columns;
        }

        public bool get_use_custom_grid() {
            return this.use_custom_grid;
        }

        public void set_show_labels(bool show) {
            this.show_labels = show;
            if (show) {
                double row_height = BOX_SIZE + BOX_MARGIN;
                double calculated_height = TOP_PADDING + BOTTOM_PADDING + TOP_TEXT_MARGIN + (BOTTOM_TEXT_MARGIN > 0 ? BOTTOM_TEXT_MARGIN : 0) + (row_height * max_rows) + (2 * BOX_PADDING);
                this.height_request = (int)(calculated_height > (TOP_PADDING + BOTTOM_PADDING) ? calculated_height : (TOP_PADDING + BOTTOM_PADDING));
            } else {
                double row_height = BOX_SIZE + BOX_MARGIN;
                double calculated_height = NO_LABEL_TOP_MARGIN + NO_LABEL_BOTTOM_MARGIN + (row_height * max_rows) + (2 * BOX_PADDING);
                this.height_request = (int)calculated_height;
            }
            queue_draw();
        }

        public void set_max_rows(int rows) {
            if (rows >= 1 && rows <= 10) {
                this.max_rows = rows;
                if (!show_labels) {
                    double row_height = BOX_SIZE + BOX_MARGIN;
                    double calculated_height = NO_LABEL_TOP_MARGIN + NO_LABEL_BOTTOM_MARGIN + (row_height * rows) + (2 * BOX_PADDING);
                    this.height_request = (int)calculated_height;
                } else {
                    double row_height = BOX_SIZE + BOX_MARGIN;
                    double calculated_height = TOP_PADDING + BOTTOM_PADDING + TOP_TEXT_MARGIN + (BOTTOM_TEXT_MARGIN > 0 ? BOTTOM_TEXT_MARGIN : 0) + (row_height * rows) + (2 * BOX_PADDING);
                    this.height_request = (int)(calculated_height > (TOP_PADDING + BOTTOM_PADDING) ? calculated_height : (TOP_PADDING + BOTTOM_PADDING));
                }
                queue_draw();
            }
        }

        public int get_max_rows() {
            return this.max_rows;
        }

        private string truncate_text_with_ellipsis(Pango.Layout layout, string text, double max_width) {
            string clean_text = sanitize_utf8(text);
            if (clean_text.length == 0) {
                return "";
            }
            layout.set_markup(GLib.Markup.escape_text(clean_text).make_valid(), -1);
            Pango.Rectangle ink_rect, logical_rect;
            layout.get_extents(out ink_rect, out logical_rect);

            double text_width = logical_rect.width / Pango.SCALE;
            if (text_width <= max_width) {
                return clean_text;
            }

            int low = 1;
            int high = clean_text.length;
            int best_length = 0;
            string best_text = "";

            while (low <= high) {
                int mid = (low + high) / 2;
                string test_text = clean_text.substring(0, mid);
                layout.set_markup(GLib.Markup.escape_text (test_text + "…").make_valid (), -1);
                layout.get_extents(out ink_rect, out logical_rect);
                double test_width = logical_rect.width / Pango.SCALE;
                if (test_width <= max_width) {
                    best_length = mid;
                    best_text = test_text;
                    low = mid + 1;
                } else {
                    high = mid - 1;
                }
            }
            if (best_length >= 3) {
                return best_text + "…";
            } else if (clean_text.length >= 3) {
                return clean_text.substring(0, 3) + "…";
            } else {
                return clean_text;
            }
        }

        private void get_smooth_gradient_color(double ratio, out double r, out double g, out double b) {
            if (ratio <= 0.0) {
                r = 1.0; g = 0.0; b = 0.0;
                return;
            }
            if (ratio >= 1.0) {
                r = 0.0; g = 0.6; b = 0.0;
                return;
            }
            if (ratio < 0.2) {
                double t = ratio / 0.2;
                r = 1.0;
                g = 0.0 + (0.3 * t);
                b = 0.0;
            } else if (ratio < 0.4) {
                double t = (ratio - 0.2) / 0.2;
                r = 1.0;
                g = 0.3 + (0.3 * t);
                b = 0.0;
            } else if (ratio < 0.6) {
                double t = (ratio - 0.4) / 0.2;
                r = 1.0;
                g = 0.6 + (0.4 * t);
                b = 0.0;
            } else if (ratio < 0.8) {
                double t = (ratio - 0.6) / 0.2;
                r = 1.0 - (0.7 * t);
                g = 1.0 - (0.2 * t);
                b = 0.0;
            } else {
                double t = (ratio - 0.8) / 0.2;
                r = 0.3 - (0.3 * t);
                g = 0.8 - (0.2 * t);
                b = 0.0;
            }
            r = r.clamp(0.0, 1.0);
            g = g.clamp(0.0, 1.0);
            b = b.clamp(0.0, 1.0);
        }

        private void calculate_grid_dimensions(int width, int height, 
            out double available_width, out double available_height, 
            out double start_x, out double start_y, 
            out int boxes_per_row, out int rows_needed, out int total_visual_boxes) {

            if (show_labels) {
                available_width = width - 2 * BOX_PADDING;
                available_height = (height - TOP_PADDING - BOTTOM_PADDING) - TOP_TEXT_MARGIN - 2 * BOX_PADDING;
                if (BOTTOM_TEXT_MARGIN < 0) {
                    available_height += BOTTOM_TEXT_MARGIN.abs();
                }
                if (available_height < 0) {
                    available_height = 0;
                }
            } else {
                available_width = width - 2 * BOX_PADDING;
                available_height = height - NO_LABEL_TOP_MARGIN - NO_LABEL_BOTTOM_MARGIN - 2 * BOX_PADDING;
                if (available_height < 0) {
                    available_height = 0;
                }
            }

            double total_cell_width = BOX_SIZE + BOX_MARGIN;
            double total_cell_height = BOX_SIZE + BOX_MARGIN;

            if (use_custom_grid) {
                boxes_per_row = custom_columns;
                rows_needed = custom_rows;
                total_visual_boxes = boxes_per_row * rows_needed;
            } else {
                int base_boxes_per_row = (int)(available_width / total_cell_width);
                if (base_boxes_per_row == 0) {
                    base_boxes_per_row = 1;
                }
                boxes_per_row = base_boxes_per_row * visual_boxes_multiplier;
                if (boxes_per_row > 200) {
                    boxes_per_row = 200;
                }
                rows_needed = max_rows.clamp(1, 10);
                total_visual_boxes = boxes_per_row * rows_needed;
                if (total_visual_boxes > 1000) {
                    total_visual_boxes = 1000;
                    rows_needed = 1000 / boxes_per_row;
                    if (1000 % boxes_per_row != 0) {
                        rows_needed += 1;
                    }
                }

                int max_possible_rows = (int)(available_height / total_cell_height);
                if (max_possible_rows > 0) {
                    rows_needed = rows_needed.clamp(1, max_possible_rows);
                }
                total_visual_boxes = boxes_per_row * rows_needed;
            }

            if (show_labels) {
                start_x = BOX_PADDING;
                start_y = TOP_PADDING + TOP_TEXT_MARGIN + BOX_PADDING;
            } else {
                start_x = BOX_PADDING;
                start_y = NO_LABEL_TOP_MARGIN + BOX_PADDING + 1;
            }

            if (boxes_per_row * total_cell_width < available_width) {
                start_x += (available_width - (boxes_per_row * total_cell_width)) / 2;
            }

            if (show_labels) {
                double content_height = rows_needed * total_cell_height;
                double extra_space = available_height - content_height;
                if (extra_space > 0) {
                    start_y += extra_space / 2.0;
                }
                double max_y = TOP_PADDING + TOP_TEXT_MARGIN + available_height;
                double needed_height = rows_needed * total_cell_height;

                if (needed_height < available_height) {
                    start_y += (available_height - needed_height) / 2;
                } else if (start_y + needed_height > max_y) {
                    rows_needed = (int)((max_y - start_y) / total_cell_height);
                    if (rows_needed < 1) {
                        rows_needed = 1;
                    }
                    total_visual_boxes = boxes_per_row * rows_needed;
                }
            } else {
                if (rows_needed * total_cell_height < available_height) {
                    start_y += (available_height - (rows_needed * total_cell_height)) / 2;
                }
            }
        }

        private void draw_labels(Cairo.Context cr, int width, int height) {
            if (!show_labels) {
                return;
            }
            cr.set_source_rgb(0.85, 0.85, 0.85);
            cr.rectangle(0, 0, width, TOP_PADDING);
            cr.fill();
            cr.set_source_rgb(0.7, 0.7, 0.7);
            cr.set_line_width(1.0);
            cr.move_to(0, TOP_PADDING);
            cr.line_to(width, TOP_PADDING);
            cr.stroke();

            double bottom_area_y = height - BOTTOM_PADDING;
            cr.set_source_rgb(0.85, 0.85, 0.85);
            cr.rectangle(0, bottom_area_y, width, BOTTOM_PADDING);
            cr.fill();
            cr.set_source_rgb(0.7, 0.7, 0.7);
            cr.set_line_width(1.0);
            cr.move_to(0, bottom_area_y);
            cr.line_to(width, bottom_area_y);
            cr.stroke();

            cr.set_source_rgb(0.1, 0.1, 0.1);
            var filename_layout = Pango.cairo_create_layout(cr);
            filename_layout.set_font_description(Pango.FontDescription.from_string("Noto Sans Bold 8"));
            double filename_max_width = width - 20;
            string display_filename = truncate_text_with_ellipsis(filename_layout, filename, filename_max_width);
            filename_layout.set_markup(GLib.Markup.escape_text(display_filename).make_valid (), -1);
            Pango.Rectangle ink_rect, logical_rect;
            filename_layout.get_pixel_extents(out ink_rect, out logical_rect);
            double ink_height = ink_rect.height;
            double ink_y = ink_rect.y;
            double safe_padding = 1.5;
            double text_y = ((TOP_PADDING - ink_height) / 2.0) - ink_y + safe_padding;
            cr.move_to(10, text_y);
            Pango.cairo_show_layout(cr, filename_layout);

            cr.set_source_rgb(0.2, 0.2, 0.2);
            var label_layout = Pango.cairo_create_layout(cr);
            label_layout.set_font_description(Pango.FontDescription.from_string("Sans Bold 8"));
            var cn_layout = Pango.cairo_create_layout(cr);
            cn_layout.set_font_description(Pango.FontDescription.from_string("Sans Bold 8"));
            string cn_text = "CN: " + connectionsdl;
            cn_layout.set_text(cn_text, -1);
            cn_layout.get_extents(out ink_rect, out logical_rect);
            double cn_width = logical_rect.width / Pango.SCALE;
            double label_max_width = width - 20 - cn_width;
            string display_label = truncate_text_with_ellipsis(label_layout, labeltransfer, label_max_width);
            label_layout.set_text(display_label, -1);
            label_layout.get_extents(out ink_rect, out logical_rect);
            double label_height = logical_rect.height / Pango.SCALE;
            double bottom_text_y = height - BOTTOM_PADDING + (BOTTOM_PADDING - label_height) / 2;
            cr.move_to(10, bottom_text_y);
            Pango.cairo_show_layout(cr, label_layout);
            cr.move_to(width - cn_width - 10, bottom_text_y);
            Pango.cairo_show_layout(cr, cn_layout);
        }

        private void draw_empty_state(Cairo.Context cr, int width, int height) {
            if (show_labels) {
                if (status == StatusMode.ERROR) cr.set_source_rgb(0.8, 0.2, 0.2);
                else cr.set_source_rgb(0.0, 0.7, 0.0);
                cr.rectangle(0, 0, width, TOP_PADDING);
                cr.fill();
                cr.set_source_rgb(0.7, 0.7, 0.7);
                cr.rectangle(0, TOP_PADDING, width, height - TOP_PADDING - BOTTOM_PADDING);
                cr.fill();
                cr.set_source_rgb(0.6, 0.6, 0.6);
                cr.rectangle(0, height - BOTTOM_PADDING, width, BOTTOM_PADDING);
                cr.fill();
                cr.set_source_rgb(1.0, 1.0, 1.0);
                var main_layout = Pango.cairo_create_layout(cr);
                main_layout.set_font_description(Pango.FontDescription.from_string("Sans Bold 12"));
                main_layout.set_text(errorcode, -1);
                Pango.Rectangle ink_rect, logical_rect;
                main_layout.get_extents(out ink_rect, out logical_rect);
                double text_width = logical_rect.width / Pango.SCALE;
                double text_height = logical_rect.height / Pango.SCALE;
                double text_x = (width - text_width) / 2;
                double text_y = TOP_PADDING + ((height - TOP_PADDING - BOTTOM_PADDING) - text_height) / 2;
                cr.move_to(text_x, text_y);
                Pango.cairo_show_layout(cr, main_layout);
                draw_labels(cr, width, height);
            } else {
                if (status == StatusMode.ERROR) {
                    cr.set_source_rgb(0.8, 0.2, 0.2);
                } else {
                    cr.set_source_rgb(0.0, 0.7, 0.0);
                }
                cr.rectangle(0, 0, width, height);
                cr.fill();
            }
        }

        private void draw_bitfield_boxes(Cairo.Context cr, double start_x, double start_y, int boxes_per_row, int rows_needed, int total_visual_boxes) {
            double total_cell_width = BOX_SIZE + BOX_MARGIN;
            double pieces_per_box_exact = (double)total_pieces / total_visual_boxes;

            int[] hex_values = new int[bitfield.length];
            for (int i = 0; i < bitfield.length; i++) {
                char hex_char = bitfield[i];
                if (hex_char >= '0' && hex_char <= '9') {
                    hex_values[i] = hex_char - '0';
                } else if (hex_char >= 'a' && hex_char <= 'f') {
                    hex_values[i] = hex_char - 'a' + 10;
                } else if (hex_char >= 'A' && hex_char <= 'F') {
                    hex_values[i] = hex_char - 'A' + 10;
                } else {
                    hex_values[i] = 0;
                }
            }

            double accumulated = 0.0;
            int box_index = 0;
            for (int row = 0; row < rows_needed; row++) {
                for (int col = 0; col < boxes_per_row; col++) {
                    if (box_index >= total_visual_boxes) {
                        break;
                    }
                    double x = start_x + col * total_cell_width;
                    double y = start_y + row * (BOX_SIZE + BOX_MARGIN);
                    double box_start = accumulated;
                    double box_end = box_start + pieces_per_box_exact;
                    if (box_end > total_pieces) {
                        box_end = total_pieces;
                    }
                    double total_weight = 0.0;
                    double downloaded_weight = 0.0;
                    int start_piece = (int)box_start;
                    int end_piece = (int)box_end;
                    if (start_piece < total_pieces) {
                        double first_piece_fraction = 1.0 - (box_start - start_piece);
                        total_weight += first_piece_fraction;
                        int hex_index = start_piece / 4;
                        int bit_offset = start_piece % 4;
                        int bit_pos = 3 - bit_offset;
                        if (hex_index < hex_values.length) {
                            int hex_val = hex_values[hex_index];
                            if (((hex_val >> bit_pos) & 1) == 1) {
                                downloaded_weight += first_piece_fraction;
                            }
                        }
                    }
                    for (int p = start_piece + 1; p < end_piece && p < total_pieces; p++) {
                        total_weight += 1.0;
                        int hex_index = p / 4;
                        int bit_offset = p % 4;
                        int bit_pos = 3 - bit_offset;
                        if (hex_index < hex_values.length) {
                            int hex_val = hex_values[hex_index];
                            if (((hex_val >> bit_pos) & 1) == 1) {
                                downloaded_weight += 1.0;
                            }
                        }
                    }
                    if (end_piece < total_pieces && end_piece > start_piece) {
                        double last_piece_fraction = box_end - end_piece;
                        total_weight += last_piece_fraction;
                        int hex_index = end_piece / 4;
                        int bit_offset = end_piece % 4;
                        int bit_pos = 3 - bit_offset;
                        if (hex_index < hex_values.length) {
                            int hex_val = hex_values[hex_index];
                            if (((hex_val >> bit_pos) & 1) == 1) {
                                downloaded_weight += last_piece_fraction;
                            }
                        }
                    }
                    double download_ratio = total_weight > 0.0001 ? downloaded_weight / total_weight : 0.0;
                    double box_r, box_g, box_b;
                    double border_r, border_g, border_b;
                    get_smooth_gradient_color(download_ratio, out box_r, out box_g, out box_b);
                    double border_darken = 0.7;
                    border_r = box_r * border_darken;
                    border_g = box_g * border_darken;
                    border_b = box_b * border_darken;
                    if (border_r < 0.1 && border_g < 0.1 && border_b < 0.1) {
                        border_r = box_r * 0.8;
                        border_g = box_g * 0.8;
                        border_b = box_b * 0.8;
                    }
                    cr.set_source_rgb(box_r, box_g, box_b);
                    cr.rectangle(x, y, BOX_SIZE, BOX_SIZE);
                    cr.fill();
                    cr.set_source_rgb(border_r, border_g, border_b);
                    cr.set_line_width(0.5);
                    cr.rectangle(x, y, BOX_SIZE, BOX_SIZE);
                    cr.stroke();
                    accumulated = box_end;
                    box_index++;
                }
            }
        }

        private void draw_bitfield(Gtk.DrawingArea area, Cairo.Context cr, int width, int height) {
            cr.set_source_rgb(0.95, 0.95, 0.95);
            cr.rectangle(0, 0, width, height);
            cr.fill();
            if (bitfield.length == 0 || total_pieces == 0) {
                draw_empty_state(cr, width, height);
                return;
            }
            if (show_labels) {
                draw_labels(cr, width, height);
            }
            double available_width, available_height, start_x, start_y;
            int boxes_per_row, rows_needed, total_visual_boxes;
            calculate_grid_dimensions(width, height, out available_width, out available_height, out start_x, out start_y, out boxes_per_row, out rows_needed, out total_visual_boxes);
            if (show_labels) {
                double bitfield_area_y = TOP_PADDING;
                double bitfield_area_height = height - TOP_PADDING - BOTTOM_PADDING;
                cr.set_source_rgb(0.98, 0.98, 0.98);
                cr.rectangle(0, bitfield_area_y, width, bitfield_area_height);
                cr.fill();
            } else {
                cr.set_source_rgb(0.98, 0.98, 0.98);
                cr.rectangle(0, 0, width, height);
                cr.fill();
            }
            draw_bitfield_boxes(cr, start_x, start_y, boxes_per_row, rows_needed, total_visual_boxes);
        }
    }
}