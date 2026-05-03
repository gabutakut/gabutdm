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
    public class SegmentDownloader : GLib.Object {
        public signal void finished (int index, bool ok, string info);
        public signal void forcewait (int index, string info);
        public signal void progress (int index, int64 current, int64 total, string info);
        public signal void status_changed (int index, int newstatus, string info);
        public int retry_count { get; set; default = 0; }
        public int status = StatusMode.WAIT;
        public int index { get; construct; }
        private string _url;
        public string url {
            get {
                return _url;
            }
            construct {
                _url = value;
            }
        }
        private string _output_path;
        public string output_path {
            get {
                return _output_path;
            }
            construct {
                _output_path = value;
            }
        }
        private string _useragent;
        public string useragent {
            get {
                return _useragent;
            }
            construct {
                _useragent = value;
            }
        }
        public double progress_percent { get; set; default = 0.0; }
        public bool completed { get; set; default = false; }
        public bool success { get; set; default = false; }
        public bool processing { get; set; default = false; }
        public int64 total_size = 0;
        private string control_path;
        private int64 speedbyte = 0;
        private int num_parts = 1;
        private int max_del_retries = 0;
        private int max_wait_retries = 0;
        private int64 last_speed_time = 0;
        private double download_speed = 0.0;
        private GLib.Cancellable cancellable;
        private int64[] part_progress;
        private Json.Array current_parts_array;
        private GLib.Mutex write_mutex = GLib.Mutex ();
        private GLib.Mutex state_mutex = GLib.Mutex ();
        private GLib.FileIOStream? shared_stream = null;
        private uint size_timeout_id = 0;
        private uint retry_timeout_id = 0;

        public SegmentDownloader (int i, string u, string jsout, string useragent) {
            Object (index: i, url: u, output_path: jsout, useragent: useragent);
        }

        construct {
            this.control_path = output_path + ".json";
            this.part_progress = new int64[num_parts];
            this.cancellable = new GLib.Cancellable ();
        }

        public void start_download () {
            if (completed || processing) {
                return;
            }
            processing = true;
            retry_count++;
            status = StatusMode.WAIT;
            status_changed (index, StatusMode.WAIT, "Waiting");
            new GLib.Thread<void> ("seg-%d-%s".printf(index, output_path.hash().to_string()), () => {
                try {
                    download_with_resume ();
                } catch (Error e) {
                    if (e is GLib.IOError.CANCELLED) {
                        cleanup_stream ();
                    } else if (e is GLib.IOError.CLOSED) {
                        handle_error (e.message);
                    } else {
                        retry_download ();
                    }
                }
            });
        }

        public void stop () {
            if (cancellable != null) {
                cancellable.cancel ();
            }
            processing = false;
            if (size_timeout_id > 0) {
                GLib.Source.remove (size_timeout_id);
                size_timeout_id = 0;
            }
            if (retry_timeout_id > 0) {
                GLib.Source.remove (retry_timeout_id);
                retry_timeout_id = 0;
            }
            status = StatusMode.PAUSED;
            status_changed (index, StatusMode.PAUSED, "Paused");
        }

        public void on_wait () {
            if (max_wait_retries < hls_max_retries) {
                stop ();
                retry_count = 0;
                completed = false;
                total_size = 0;
                forcewait (index, "Waiting");
                status = StatusMode.WAIT;
                status_changed (index, StatusMode.WAIT, "Waiting");
            } else {
                handle_error ("Error max wait");
                return;
            }
            max_wait_retries++;
        }

        public void idle_dl () {
            if (cancellable != null) {
                cancellable.cancel ();
            }
            retry_count = 0;
            total_size = 0;
            max_del_retries = 0;
            max_wait_retries = 0;
            completed = false;
            status = StatusMode.WAIT;
            status_changed (index, StatusMode.WAIT, "Waiting");
        }

        private void download_with_resume () throws Error {
            if (status == StatusMode.ACTIVE) {
                return;
            }
            if (cancellable.is_cancelled ()) {
                cancellable = new GLib.Cancellable ();
            }
            GLib.File file = GLib.File.new_for_path (this.output_path);
            GLib.File control_file = GLib.File.new_for_path (this.control_path);
            if (file.query_exists () && !control_file.query_exists ()) {
                var ffread = new Ffmpeg.Reader ();
                if (ffread.validate_path (file.get_path ()) == 0) {
                    status = StatusMode.COMPLETE;
                    status_changed (index, StatusMode.COMPLETE, "Completed");
                    completed = true;
                    success = true;
                    processing = false;
                    progress_percent = 1.0;
                    var info = file.query_info (GLib.FileAttribute.STANDARD_SIZE, GLib.FileQueryInfoFlags.NONE);
                    this.total_size = info.get_size ();
                    finished (index, true, "Completed");
                } else {
                    file.trash ();
                    on_wait ();
                }
                ffread = null;
                return;
            } else if (!file.query_exists () && control_file.query_exists ()) {
                control_file.delete ();
                on_wait ();
                max_del_retries++;
                return;
            }
            if (max_del_retries > hls_max_retries) {
                retry_count = max_del_retries;
                throw new GLib.IOError.CLOSED ("Error");
            }
            status = StatusMode.ACTIVE;
            status_changed (index, StatusMode.ACTIVE, "on Progress");
            if (control_file.query_exists ()) {
                this.current_parts_array = load_control (out this.total_size);
                download_parse (file);
            } else {
                var msg_get = new Soup.Message ("GET", this.url);
                var reqesthead = msg_get.get_request_headers();
                size_timeout_id = GLib.Timeout.add (10000, () => {
                    if (this.total_size < 1024) {
                        if (!cancellable.is_cancelled ()) {
                            on_wait ();
                        }
                    }
                    size_timeout_id = 0;
                    return GLib.Source.REMOVE;
                });
                if (reqesthead == null) {
                    throw new GLib.IOError.CLOSED ("Header Error");
                }
                msg_get.request_headers.append ("User-Agent",useragent);
                msg_get.request_headers.append ("Accept", "*/*");
                msg_get.request_headers.append ("Accept-Encoding", "identity");
                msg_get.request_headers.append ("Connection", "keep-alive");
                msg_get.request_headers.append ("Range", "bytes=0-0");
                var uri = GLib.Uri.parse (url, GLib.UriFlags.NONE);
                if (uri != null && uri.get_scheme () != null && uri.get_host () != null) {
                    int last_slash = uri.get_path().index_of ("/", 1);
                    msg_get.request_headers.append ("Origin", "%s://%s".printf(uri.get_scheme (), uri.get_host ()));
                    msg_get.request_headers.append("Referer", "%s://%s%s".printf(uri.get_scheme (), uri.get_host (), uri.get_path ().slice (0, last_slash)));
                }
                msg_get.request_headers.remove ("Expect");
                Soup.Session session = new Soup.Session () {
                    timeout = 30,
                    idle_timeout = 30
                };
                var input = session.send (msg_get, cancellable);
                string? cr = msg_get.response_headers.get_one ("Content-Range");
                if (cr != null) {
                    var parts = cr.split("/");
                    if (parts.length == 2) {
                        this.total_size = int64.parse (parts[1]);
                    }
                } else {
                    this.total_size = msg_get.response_headers.get_content_length ();
                }
                if (cancellable != null) {
                    cancellable.cancelled.connect (()=> {
                        try {
                            if (session != null) {
                                session.abort ();
                                session = null;
                            }
                            input.close ();
                        } catch (GLib.Error e) {}
                    });
                }
                if (session != null) {
                    session.abort ();
                    session = null;
                }
                input.close ();
                if (this.total_size >= 1024) {
                    if (size_timeout_id > 0) {
                        GLib.Source.remove(size_timeout_id);
                        size_timeout_id = 0;
                    }
                }
                if (this.total_size < 1024) {
                    throw new GLib.IOError.CLOSED("Size < 1 Kb");
                }
                save_size_state (file);
                download_parse (file);
                msg_get = null;
            }
        }

        private void download_parse (GLib.File file) throws Error {
            if (this.current_parts_array == null) {
                if (size_timeout_id > 0) {
                    GLib.Source.remove (size_timeout_id);
                    size_timeout_id = 0;
                }
                if (!cancellable.is_cancelled ()) {
                    on_wait ();
                }
                return;
            }
            GLib.Timeout.add (500, () => {
                if (status != StatusMode.ACTIVE) {
                    return GLib.Source.REMOVE;
                }
                int64 current_dl = 0;
                for (int i = 0; i < num_parts; i++) {
                    current_dl += part_progress[i];
                }
                if (total_size > 0) {
                    progress_percent = (double)current_dl / (double)total_size;
                    progress (index, current_dl, total_size, "on Progress");
                }
                if (current_dl >= total_size && total_size > 0) {
                    try {
                        var info = file.query_info (GLib.FileAttribute.STANDARD_SIZE, GLib.FileQueryInfoFlags.NONE);
                        if ((int64) info.get_size() >= this.total_size) {
                            var ffread = new Ffmpeg.Reader ();
                            if (ffread.validate_path (file.get_path ()) == 0) {
                                complete_download ();
                            } else {
                                file.trash ();
                                on_wait ();
                                max_del_retries++;
                            }
                            ffread = null;
                            return GLib.Source.REMOVE;
                        }
                    } catch (GLib.Error e) {}
                }
                return processing;
            });
            var threads = new GLib.GenericArray<GLib.Thread<bool>> ();
            for (int i = 0; i < current_parts_array.get_length (); i++) {
                var part_obj = current_parts_array.get_object_element (i);
                if (!part_obj.get_boolean_member ("is_finished")) {
                    var thread = new GLib.Thread<bool> ("part-%d-%d".printf(index, i), () => {
                        try {
                            if (!cancellable.is_cancelled ()) {
                                download_part_sync (part_obj);
                            }
                            return true;
                        } catch (GLib.Error e) {
                            if (!(e is GLib.IOError.CANCELLED)) {
                                handle_error (e.message);
                            }
                            return GLib.Source.REMOVE;
                        }
                    });
                    threads.add (thread);
                }
            }
            bool all_success = true;
            for (int i = 0; i < threads.length; i++) {
                if (!threads[i].join ()) {
                    all_success = false;
                }
            }
            threads = new GLib.GenericArray<GLib.Thread<bool>> ();
            if (all_success && !cancellable.is_cancelled ()) {
                var info = file.query_info (GLib.FileAttribute.STANDARD_SIZE, GLib.FileQueryInfoFlags.NONE);
                if ((int64) info.get_size() >= this.total_size) {
                    var ffread = new Ffmpeg.Reader ();
                    if (ffread.validate_path (file.get_path ()) == 0) {
                        complete_download ();
                    } else {
                        file.trash ();
                        max_del_retries++;
                        throw new GLib.IOError.FAILED ("Not Valid");
                    }
                    ffread = null;
                }
            } else if (!all_success && !cancellable.is_cancelled ()) {
                throw new GLib.IOError.FAILED ("Not Succes");
            }
        }

        public double sample_speed () {
            int64 now = GLib.get_monotonic_time ();
            if (last_speed_time == 0) {
                last_speed_time = now;
                speedbyte = 0;
                return download_speed;
            }
            int64 dt = now - last_speed_time;
            if (dt < 200000) {
                return download_speed;
            }
            double seconds = dt / 1000000.0;
            double instant = speedbyte / seconds;
            download_speed = (download_speed * 0.7) + (instant * 0.3);
            speedbyte = 0;
            last_speed_time = now;
            return download_speed;
        }

        private void save_size_state (GLib.File file) throws GLib.Error {
            state_mutex.lock ();
            try {
                var parent = file.get_parent ();
                if (parent != null && !parent.query_exists ()) {
                    parent.make_directory_with_parents ();
                }
                if (file.query_exists ()) {
                    var info = file.query_info (GLib.FileAttribute.STANDARD_SIZE, GLib.FileQueryInfoFlags.NONE);
                    if ((int64) info.get_size () < this.total_size && this.total_size >= 1024) {
                        var out_stream = file.replace (null, false, GLib.FileCreateFlags.NONE, cancellable);
                        out_stream.truncate (this.total_size, cancellable);
                        out_stream.close ();
                    } else {
                        throw new GLib.IOError.CLOSED ("Size < 1 Kb");
                    }
                } else {
                    if (this.total_size >= 1024) {
                        var out_stream = file.replace (null, false, GLib.FileCreateFlags.NONE, cancellable);
                        out_stream.truncate (this.total_size, cancellable);
                        out_stream.close ();
                    } else {
                        throw new GLib.IOError.CLOSED ("Size < 1 Kb");
                    }
                }
                this.current_parts_array = prepare_new_json (this.total_size);
                if (this.current_parts_array != null) {
                    save_state (this.current_parts_array);
                }
            } finally {
                state_mutex.unlock ();
            }
        }

        private void download_part_sync (Json.Object part_obj) throws GLib.Error {
            int64 id = part_obj.get_int_member("part_id");
            int attempts = 0;
            bool success = false;
            while (attempts < hls_max_retries && !success && !cancellable.is_cancelled()) {
                if (part_obj.get_boolean_member ("is_finished")) {
                    int64 start = part_obj.get_int_member ("start_offset");
                    int64 curr = part_obj.get_int_member ("current_pos");
                    this.part_progress[id] = curr - start;
                    success = true;
                    break;
                }
                try {
                    perform_part_download_sync (part_obj);
                    success = true;
                } catch (GLib.Error e) {
                    if (e is GLib.IOError.CANCELLED) {
                        if (this.current_parts_array != null) {
                            save_state (this.current_parts_array);
                        }
                        cleanup_stream ();
                        break;
                    }
                    attempts++;
                    if (attempts < hls_max_retries) {
                        Thread.usleep (hls_timeout*1000);
                    }
                }
            }
            if (!success && !cancellable.is_cancelled ()) {
                throw new GLib.IOError.FAILED("Max retries Failed");
            }
        }

        private void perform_part_download_sync (Json.Object part_obj) throws GLib.Error {
            Soup.Session session = new Soup.Session () {
                timeout = 30,
                idle_timeout = 30
            };
            int64 id = part_obj.get_int_member ("part_id");
            int64 start_offset = part_obj.get_int_member ("start_offset");
            int64 current_pos = part_obj.get_int_member ("current_pos");
            int64 end_offset = part_obj.get_int_member ("end_offset");
            var msg = new Soup.Message ("GET", this.url);
            msg.request_headers.append ("User-Agent", useragent);
            msg.request_headers.append ("Accept", "*/*");
            msg.request_headers.append ("Accept-Encoding", "identity");
            msg.request_headers.append ("Connection", "keep-alive");
            if (current_pos > 0) {
                string range = "bytes=%lld-%lld".printf((long)current_pos,(long) end_offset);
                msg.request_headers.append ("Range", range);
            }
            var uri = GLib.Uri.parse (url, GLib.UriFlags.NONE);
            if (uri != null && uri.get_scheme () != null && uri.get_host () != null) {
                int last_slash = uri.get_path().index_of ("/", 1);
                msg.request_headers.append ("Origin", "%s://%s".printf(uri.get_scheme (), uri.get_host ()));
                msg.request_headers.append("Referer", "%s://%s%s".printf(uri.get_scheme (), uri.get_host (), uri.get_path ().slice (0, last_slash)));
            }
            msg.request_headers.remove ("Expect");
            GLib.InputStream? input = session.send(msg, cancellable);
            uint status = msg.get_status ();
            bool use_seek = (status == Soup.Status.PARTIAL_CONTENT);
            if (!use_seek) {
                current_pos = 0;
            }
            uint8[] buffer = new uint8[8192 * 2];
            ssize_t bytes;
            int64 part_size = end_offset - start_offset + 1;
            while ((bytes = input.read (buffer, cancellable)) > 0) {
                safe_write(current_pos, buffer, bytes);
                current_pos += bytes;
                part_obj.set_int_member ("current_pos", current_pos);
                speedbyte += bytes;
                int64 written = current_pos - start_offset;
                this.part_progress[id] = written > part_size ? part_size : written;
            }
            if (cancellable != null) {
                cancellable.cancelled.connect (()=> {
                    try {
                        if (session != null) {
                            session.abort ();
                            session = null;
                        }
                        input.close ();
                        msg = null;
                        buffer = null;
                    } catch (GLib.Error e) {}
                });
            }
            part_obj.set_boolean_member ("is_finished", true);
            part_obj.set_int_member ("current_pos", end_offset + 1);
            save_state (this.current_parts_array);
            if (session != null) {
                session.abort ();
                session = null;
            }
            input.close ();
            msg = null;
            buffer = null;
        }

        private void safe_write (int64 pos, uint8[] data, ssize_t size) throws GLib.Error {
            write_mutex.lock ();
            try {
                if (shared_stream == null) {
                    var file = GLib.File.new_for_path (this.output_path);
                    shared_stream = file.open_readwrite ();
                }
                ((GLib.Seekable)shared_stream).seek (pos, GLib.SeekType.SET);
                shared_stream.get_output_stream ().write (data[0:size]);
            } finally {
                write_mutex.unlock ();
            }
        }

        private Json.Array prepare_new_json (int64 size) {
            var arr = new Json.Array ();
            int64 chunk = size / num_parts;
            for (int i = 0; i < num_parts; i++) {
                var obj = new Json.Object ();
                int64 start = i * chunk;
                int64 end = (i == num_parts - 1) ? size - 1 : (start + chunk - 1);
                obj.set_int_member ("part_id", i);
                obj.set_int_member ("start_offset", start);
                obj.set_int_member ("current_pos", start);
                obj.set_int_member ("end_offset", end);
                obj.set_boolean_member ("is_finished", false);
                arr.add_object_element (obj);
            }
            return arr;
        }

        private Json.Array load_control (out int64 size) throws GLib.Error {
            var parser = new Json.Parser ();
            parser.load_from_file (this.control_path);
            var root = parser.get_root ().get_object ();
            size = root.get_int_member ("total_size");
            var parts = root.get_array_member ("parts");
            for (int i = 0; i < parts.get_length(); i++) {
                var part = parts.get_object_element (i);
                int64 start = part.get_int_member ("start_offset");
                int64 curr = part.get_int_member ("current_pos");
                int64 id = part.get_int_member ("part_id");
                if (id < part_progress.length) {
                    part_progress[id] = curr - start;
                }
            }
            return parts;
        }

        private void save_state (Json.Array parts) throws Error {
            var generator = new Json.Generator ();
            var root_obj = new Json.Object ();
            var parts_node = new Json.Node (Json.NodeType.ARRAY);
            parts_node.set_array (parts);
            root_obj.set_member ("parts", parts_node);
            root_obj.set_int_member ("total_size", this.total_size);
            var root_node = new Json.Node (Json.NodeType.OBJECT);
            root_node.set_object (root_obj);
            generator.set_root (root_node);
            generator.pretty = false;
            generator.to_file (this.control_path);
        }

        public void cleanup_stream () {
            if (cancellable != null) {
                cancellable.cancel ();
            }
            processing = false;
            if (shared_stream != null) {
                try {
                    shared_stream.close ();
                } catch (Error e) {
                } finally {
                    shared_stream = null;
                }
            }
        }

        private void handle_error (string mess) {
            processing = false;
            if (cancellable != null) {
                cancellable.cancel ();
            }
            if (size_timeout_id > 0) {
                GLib.Source.remove (size_timeout_id);
                size_timeout_id = 0;
            }
            if (retry_timeout_id > 0) {
                GLib.Source.remove (retry_timeout_id);
                retry_timeout_id = 0;
            }
            if (shared_stream != null) {
                try {
                    shared_stream.close ();
                } catch (Error e) {
                } finally {
                    shared_stream = null;
                }
            }
            completed = true;
            success = false;
            retry_count = 0;
            status = StatusMode.ERROR;
            status_changed (index, StatusMode.ERROR, mess);
            finished (index, false, mess);
        }

        private void retry_download () {
            if (retry_count < hls_max_retries) {
                if (!cancellable.is_cancelled ()) {
                    retry_timeout_id = GLib.Timeout.add(hls_timeout, () => {
                        if (!cancellable.is_cancelled ()) {
                            start_download ();
                        }
                        retry_timeout_id = 0;
                        return GLib.Source.REMOVE;
                    });
                }
            } else {
                handle_error ("Error max Retries");
            }
        }

        private void complete_download () throws Error {
            completed = true;
            success = true;
            processing = false;
            progress_percent = 1.0;
            if (shared_stream != null) {
                shared_stream.close ();
                shared_stream = null;
            }
            var control = GLib.File.new_for_path (this.control_path);
            if (control.query_exists ()) {
                control.delete ();
            }
            status = StatusMode.COMPLETE;
            status_changed (index, StatusMode.COMPLETE, "Completed");
            finished (index, true, "Completed");
        }
    }
}