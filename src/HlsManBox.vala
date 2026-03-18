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
    public class HlsManBox : GLib.Object {
        public signal void update_progress (string progrs);
        public signal void update_conn (string active);
        public signal void bitfield_update (string bitf, int piece);
        public Gee.ArrayList<HLSLBox> hlsdlboxs;
        public bool processing { get; set; default = false;}
        public int active_hlsrow = 0;
        private uint queue_timeout_id = 0;

        construct {
            hlsdlboxs = new Gee.ArrayList<HLSLBox>();
        }

        public void append_hlsbox (HLSLBox hlslbox) {
            hlsdlboxs.add (hlslbox);
            hlslbox.notify["status"].connect (()=> {
                if (hlslbox.status == StatusMode.PAUSED || hlslbox.status == StatusMode.COMPLETE || hlslbox.status == StatusMode.MERGE) {
                    if (active_hlsrow > 0 && active_hlsrow <= hlsparallel_active) {
                        active_hlsrow--;
                    }
                }
            });
        }

        public void remove_hlsbox (HLSLBox hlslbox) {
            hlsdlboxs.remove (hlslbox);
        }

        public void on_start_download () {
            if (processing) {
                foreach (var hlsdlbox in hlsdlboxs) {
                    if (hlsdlbox.status == StatusMode.PAUSED || hlsdlbox.status == StatusMode.ERROR) {
                        hlsdlbox.on_wait_download ();
                    }
                }
                return;
            }
            foreach (var hlsdlbox in hlsdlboxs) {
                if (hlsdlbox.status != StatusMode.COMPLETE) {
                    hlsdlbox.on_wait_download ();
                }
            }
            processing = true;
            active_hlsrow = 0;
            update_quee ();
        }

        public void update_quee () {
            if (queue_timeout_id == 0) {
                queue_timeout_id = GLib.Timeout.add(500, () => {
                    active_hlsrow = find_active ();
                    if (active_hlsrow < hlsparallel_active) {
                        var hlsdlbox = find_waiting_hlsboxs();
                        if (hlsdlbox != null) {
                            active_hlsrow++;
                            if (find_active () < active_hlsrow) {
                                hlsdlbox.on_start_download ();
                            }
                        }
                    }
                    if (active_hlsrow > hlsparallel_active) {
                        var hlsdlbox = find_active_hlsboxs();
                        if (hlsdlbox != null) {
                            if (find_active () > active_hlsrow) {
                                active_hlsrow--;
                                hlsdlbox.on_wait_download ();
                            }
                        }
                    }
                    process_hls_queue ();
                    return processing;
                });
            }
        }

        public void process_hls_queue () {
            if (!processing) {
                return;
            }
            if (find_active () < 1 && find_waiting () < 1) {
                processing = false;
                if (queue_timeout_id > 0) {
                    GLib.Source.remove(queue_timeout_id);
                    queue_timeout_id = 0;
                }
            }
        }

        private HLSLBox? find_waiting_hlsboxs () {
            foreach (var hlsdlbox in hlsdlboxs) {
                if (!hlsdlbox.processing && hlsdlbox.status == StatusMode.WAIT) {
                    return hlsdlbox;
                }
            }
            return null;
        }

        private HLSLBox? find_active_hlsboxs () {
            foreach (var hlsdlbox in hlsdlboxs) {
                if (hlsdlbox.processing && hlsdlbox.status == StatusMode.ACTIVE) {
                    return hlsdlbox;
                }
            }
            return null;
        }

        public double find_progress () {
            double totalfile = 0.0;
            double totalcomp = 0.0;
            foreach (var hlsdlbox in hlsdlboxs) {
                if (hlsdlbox.status == StatusMode.ACTIVE || hlsdlbox.status == StatusMode.VERIFY) {
                    totalfile += hlsdlbox.segment_urls.size;
                    totalcomp += hlsdlbox.totalcomp;
                }
            }
            return totalcomp / totalfile;
        }

        public int? find_active () {
            int count = 0;
            foreach (var hlsdlbox in hlsdlboxs) {
                if (hlsdlbox.status == StatusMode.ACTIVE) {
                    count++;
                }
            }
            return count;
        }

        public int? find_complete () {
            int count = 0;
            foreach (var hlsdlbox in hlsdlboxs) {
                if (hlsdlbox.status == StatusMode.COMPLETE) {
                    count++;
                }
            }
            return count;
        }

        public int? find_waiting () {
            int count = 0;
            foreach (var hlsdlbox in hlsdlboxs) {
                if (hlsdlbox.status == StatusMode.WAIT) {
                    count++;
                }
            }
            return count;
        }

        public int64? find_speed () {
            double total_speed_bytes = 0;
            foreach (var hlsdlbox in hlsdlboxs) {
                if (hlsdlbox.status == StatusMode.ACTIVE) {
                  total_speed_bytes += hlsdlbox.find_speed_sample ();
                }
            }
            return (int64)total_speed_bytes;
        }

        public void on_stop_download() {
            processing = false;
            if (queue_timeout_id > 0) {
                GLib.Source.remove(queue_timeout_id);
            }
            queue_timeout_id = 0;
            foreach (var hlsdlbox in hlsdlboxs) {
                if (hlsdlbox.status != StatusMode.COMPLETE) {
                    hlsdlbox.on_stop_download();
                }
            }
        }
    }
}