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
    public class HLSLBox : GLib.Object {
        public signal void full_progress (string progrs);
        public signal void simple_progress (string progrs);
        public signal void update_conn (string active);
        public signal void bitfield_update (string bitf, int piece);
        public Gee.ArrayList<SegmentDownloader> downloaders;
        public Gee.ArrayList<string> segment_urls;
        public Gee.ArrayList<string> files;
        public Gtk.ListBox hls_list_box;
        public bool merged_ts { get; set; default = false;}
        public bool processing { get; set; default = false;}
        public string output_dir = "";
        public string fileordir;
        public string filename;
        public string mp4path;
        public double progressmerg { get; set; }
        public int totalcomp { get; set; }
        public int selected { get; set; default = 0;}
        public int status { get; set; default = StatusMode.WAIT;}
        public int64 timeadded { get; set; }
        public int64 total_dl { get; set; }
        public string useragent;
        private int active_downloaders = 0;
        private int idle_time = 0;
        private int view_time = 0;
        private uint queue_timeout_id = 0;
        private bool verify_download = false;

        construct {
            files = new Gee.ArrayList<string>();
            downloaders = new Gee.ArrayList<SegmentDownloader>();
            segment_urls = new Gee.ArrayList<string>();
            hls_list_box = new Gtk.ListBox () {
                activate_on_single_click = false,
                selection_mode = Gtk.SelectionMode.MULTIPLE
            };
            hls_list_box.row_activated.connect ((row) => {
                if (row.is_selected ()) {
                    hls_list_box.unselect_row (row);
                } else {
                    hls_list_box.select_row (row);
                }
            });
            hls_list_box.set_visible (true);
            notify["selected"].connect (filter_view);
        }

        public void append_row (HLSRow row) {
            hls_list_box.append(row);
            files.add(GLib.Path.build_filename(output_dir, row.filename));
            row.start_button.clicked.connect(()=> {
                foreach (var dld in downloaders) {
                    if (dld.index == row.index) {
                        if (row.status == StatusMode.ACTIVE || row.status == StatusMode.WAIT) {
                            dld.stop();
                        } else if (row.status == StatusMode.ERROR) {
                            dld.on_wait ();
                        } else {
                            dld.start_download();
                        }
                    }
                }
                if (active_downloaders > 0 && active_downloaders <= hlsparalell_dld) {
                    active_downloaders--;
                }
                if (!processing) {
                    status = StatusMode.ACTIVE;
                    processing = true;
                    update_quee ();
                }
            });
        }

        public void load_downloader () {
            downloaders.clear ();
            for (int i = 0; i < segment_urls.size; i++) {
                string url = segment_urls[i];
                var output_file = GLib.Path.build_filename(output_dir, "segment_%05d.ts".printf(i));
                var downloader = new SegmentDownloader(i, url, output_file, useragent);
                downloader.status_changed.connect((idx, status, info)=> {
                    MainContext.get_thread_default ().invoke (()=> {
                        update_file_status(idx, downloader.status, downloader.total_size, downloader.progress_percent, info);
                        return false;
                    });
                });
                downloader.finished.connect((idx, success, info)=> {
                    MainContext.get_thread_default ().invoke (() => {
                        if (active_downloaders > 0 && active_downloaders <= hlsparalell_dld) {
                            active_downloaders--;
                        }
                        if (success) {
                            update_file_status(idx, StatusMode.COMPLETE, downloader.total_size, 1.0, info);
                        } else {
                            update_file_status(idx, StatusMode.ERROR, downloader.total_size, 0, info);
                        }
                        active_downloaders = find_active ();
                        return false;
                    });
                });
                downloader.forcewait.connect((idx, info)=> {
                    MainContext.get_thread_default ().invoke (() => {
                        if (active_downloaders > 0 && active_downloaders <= hlsparalell_dld) {
                            active_downloaders--;
                        }
                        update_file_status(idx, StatusMode.WAIT, downloader.total_size, downloader.progress_percent, info);
                        active_downloaders = find_active ();
                        downloaders.sort((a, b)=> {
                            return a.index - b.index;
                        });
                        return false;
                    });
                });
                downloader.progress.connect((idx, current, total, info) => {
                    MainContext.get_thread_default ().invoke (()=> {
                        update_file_status(idx, downloader.status, downloader.total_size, downloader.progress_percent, info);
                        return false;
                    });
                });
                downloaders.add(downloader);
                downloaders.sort((a, b)=> {
                    return a.index - b.index;
                });
                update_file_status(i, StatusMode.WAIT, downloader.total_size, 0, "IDLE");
            }
        }

        public void on_wait_download () {
            on_stop_download ();
            status = StatusMode.WAIT;
        }

        public void on_start_download () {
            if (segment_urls.size == 0) {
                return;
            }
            if (processing && merged_ts) {
                return;
            }
            active_downloaders = 0;
            status = StatusMode.ACTIVE;
            foreach (var downloader in downloaders) {
                if (downloader.status != StatusMode.COMPLETE) {
                    downloader.idle_dl ();
                }
            }
            processing = true;
            update_quee ();
        }

        private void update_quee () {
            if (queue_timeout_id == 0) {
                queue_timeout_id = GLib.Timeout.add( 10, ()=> {
                    if (active_downloaders < hlsparalell_dld) {
                        var downloader = find_waiting_downloader();
                        if (downloader != null) {
                            active_downloaders++;
                            if (find_active () < active_downloaders) {
                                downloader.start_download();
                            }
                        }
                    }
                    if (active_downloaders > hlsparalell_dld) {
                        var downloader = find_active_downloader();
                        if (downloader != null) {
                            if (find_active () > active_downloaders) {
                                downloader.on_wait ();
                            }
                        }
                    }
                    if (idle_time > 15) {
                        process_download_queue ();
                        idle_time = 0;
                    }
                    if (view_time > 50) {
                        filter_view ();
                        view_time = 0;
                    }
                    view_time++;
                    idle_time++;
                    return processing;
                });
            }
        }

        private void process_download_queue () {
            if (!processing) {
                return;
            }
            bitfield_update (get_bitfield_hex (), downloaders.size);
            totalcomp = find_complete ();
            progressmerg = (double) totalcomp / (double) segment_urls.size;
            string firstp = "%s - %s - ".printf( GLib.format_size(find_totaldl ()), GLib.format_size (estimate_total_size ()));
            string centp = "%d of %d - E: %d - ".printf(totalcomp, segment_urls.size, find_failed ());
            string endp = "D: %s %s".printf( find_speed(), calculate_eta ());
            full_progress (firstp + centp + endp);
            simple_progress (firstp + endp);
            update_conn (active_downloaders.to_string());
            if (totalcomp + find_failed () == segment_urls.size && segment_urls.size > 0) {
                if (find_active () < 1 && find_waiting () < 1) {
                    remove_quee ();
                    if (find_failed () > 0 || totalcomp < downloaders.size) {
                        status = StatusMode.ERROR;
                    } else {
                        finish_processing();
                    }
                }
            }
        }

        public int64 estimate_total_size() {
            int64 completed_segments = 0;
            int64 completed_tsize = 0;
            foreach (var downloader in downloaders) {
                if (downloader.status == StatusMode.COMPLETE) {
                    completed_tsize += downloader.total_size;
                    completed_segments++;
                }
            }
            if (completed_segments == 0) {
                return 0;
            }
            int64 avg_segment_size = completed_tsize / completed_segments;
            return avg_segment_size * segment_urls.size;
        }

        private string calculate_eta () {
            int64 completed_segments = 0;
            int64 completed_tsize = 0;
            foreach (var downloader in downloaders) {
                if (downloader.status == StatusMode.COMPLETE) {
                    completed_tsize += downloader.total_size;
                    completed_segments++;
                }
            }
            int remaining_segments = segment_urls.size - (int) completed_segments;
            if (completed_segments == 0) {
                return "";
            }
            int64 avg_size = completed_tsize / completed_segments;
            int64 estimated_remaining_bytes = avg_size * remaining_segments;
            int64 speed = (int64) find_speed_sample ();
            if (speed <= 0) {
                return "";
            }
            int64 seconds = estimated_remaining_bytes / speed;
            return "- %s".printf (format_time ((int)seconds));
        }

        private SegmentDownloader? find_waiting_downloader () {
            foreach (var downloader in downloaders) {
                if (!downloader.completed && !downloader.processing && downloader.status == StatusMode.WAIT) {
                    return downloader;
                }
            }
            return null;
        }

        private SegmentDownloader? find_active_downloader () {
            foreach (var downloader in downloaders) {
                if (downloader.processing && downloader.status == StatusMode.ACTIVE) {
                    return downloader;
                }
            }
            return null;
        }

        private int? find_active () {
            int count = 0;
            foreach (var downloader in downloaders) {
                if (downloader.status == StatusMode.ACTIVE) {
                    count++;
                }
            }
            return count;
        }

        public int? find_waiting () {
            int count = 0;
            foreach (var downloader in downloaders) {
                if (downloader.status == StatusMode.WAIT) {
                    count++;
                }
            }
            return count;
        }

        private int? find_complete () {
            int count = 0;
            foreach (var downloader in downloaders) {
                if (downloader.status == StatusMode.COMPLETE) {
                    count++;
                }
            }
            return count;
        }

        private int? find_failed () {
            int count = 0;
            foreach (var downloader in downloaders) {
                if (downloader.status == StatusMode.ERROR) {
                    count++;
                }
            }
            return count;
        }

        public double? find_speed_sample () {
            double total_speed_bytes = 0;
            foreach (var downloader in downloaders) {
                if (downloader.status == StatusMode.ACTIVE) {
                    total_speed_bytes += downloader.sample_speed ();
                }
            }
            return total_speed_bytes;
        }

        public string? find_speed () {
            double total_speed_bytes = 0;
            foreach (var downloader in downloaders) {
                if (downloader.status == StatusMode.ACTIVE) {
                    total_speed_bytes += downloader.sample_speed ();
                }
            }
            return GLib.format_size((int64)total_speed_bytes);
        }

        public int64? find_totaldl () {
            total_dl = 0;
            foreach (var downloader in downloaders) {
                total_dl += downloader.total_size;
            }
            return total_dl;
        }

        private string get_bitfield_hex() {
            if (this.downloaders.size == 0) {
                return "00";
            }
            int total_segments = this.downloaders.size;
            int num_bytes = (total_segments + 7) / 8;
            uint8[] bitfield = new uint8[num_bytes];
            for (int i = 0; i < total_segments; i++) {
                var downloader = this.downloaders.get(i);
                if (downloader.completed && downloader.success) {
                    int byte_index = i / 8;
                    int bit_index = 7 - (i % 8);
                    bitfield[byte_index] |= (uint8)(1 << bit_index);
                }
            }
            var hex_str = new GLib.StringBuilder("");
            for (int i = 0; i < num_bytes; i++) {
                hex_str.append("%02x".printf(bitfield[i]));
            }
            return hex_str.str;
        }

        private void remove_quee () {
            processing = false;
            if (queue_timeout_id > 0) {
                GLib.Source.remove(queue_timeout_id);
                queue_timeout_id = 0;
            }
            active_downloaders = 0;
        }

        private void finish_processing() {
            foreach (var downloader in downloaders) {
                downloader.cleanup_stream();
            }
            if (verify_download) {
                status = StatusMode.MERGE;
                merge_files ();
            } else {
                verify_download = true;
                on_start_download ();
                status = StatusMode.VERIFY;
            }
        }

        public void on_stop_download() {
            remove_quee ();
            foreach (var downloader in downloaders) {
                downloader.stop ();
            }
            verify_download = false;
            status = StatusMode.PAUSED;
        }

        public void filter_view() {
            hls_list_box.set_filter_func ((item) => {
                switch (selected) {
                    case 1:
                    return ((HLSRow) item).status == StatusMode.ACTIVE;
                    case 2:
                    return ((HLSRow) item).status == StatusMode.PAUSED;
                    case 3:
                    return ((HLSRow) item).status == StatusMode.COMPLETE;
                    case 4:
                    return ((HLSRow) item).status == StatusMode.WAIT;
                    case 5:
                    return ((HLSRow) item).status == StatusMode.ERROR;
                    default:
                    return true;
                }
            });
        }

        private void update_file_status(int index, int status, int64 filesize, double progress, string info) {
            var row = hls_list_box.get_row_at_index(index);
            if (row == null) {
                return;
            }
            var row_widget = row as HLSRow;
            if (row_widget == null) {
                return;
            }
            row_widget.update_status(status, filesize, info, progress);
        }

        public void merge_files () {
            string[] file_list = files.to_array();
            if (file_list.length == 0) {
                return;
            }
            if (merged_ts || processing || totalcomp <= 2) {
                return;
            }
            merged_ts = true;
            var filepath = GLib.File.new_for_path(output_dir);
            var output_path = GLib.Path.build_filename(filepath.get_parent().get_path(), filename);
            mp4path = sanitize_output_path (ext_filename (output_path));
            var ffmpeg = new Ffmpeg.Merger();
            new Thread<void>("merworker-%u".printf (filename.hash ()), () => {
                int result = ffmpeg.merge_files(file_list, file_list.length, mp4path);
                MainContext.default ().invoke (() => {
                    if (result < 0) {
                        simple_progress (_("Merged Error"));
                        status = StatusMode.ERROR;
                        merged_ts = false;
                    }
                    return false;
                });
            });
            GLib.Timeout.add(100, () => {
                progressmerg = (double) ffmpeg.get_last_progress();
                string hex_bitfield = ffmpeg.hex_bitfield();
                simple_progress ("Merging... %d%s".printf((int)(progressmerg * 100), "%"));
                bitfield_update (hex_bitfield, file_list.length);
                if (progressmerg >= 1.0) {
                    try {
                        GLib.File file = GLib.File.new_for_path(mp4path);
                        var info = file.query_info(GLib.FileAttribute.STANDARD_SIZE, GLib.FileQueryInfoFlags.NONE);
                        simple_progress (_("%s").printf(GLib.format_size(info.get_size())));
                        if (totalcomp >= segment_urls.size) {
                            filename = file.get_basename ();
                        }
                        status = StatusMode.COMPLETE;
                        merged_ts = false;
                    } catch (GLib.Error e) {
                        ffmpeg = null;
                    } finally {
                        ffmpeg = null;
                        if (totalcomp < segment_urls.size) {
                            status = StatusMode.PAUSED;
                        }
                    }
                    return false;
                }
                return merged_ts; 
            });
        }
    }
}