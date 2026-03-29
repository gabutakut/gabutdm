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
    public class TorrentParser : GLib.Object {
        private static int file_counter = 0;

        public static TorrentInfo? parse_file(string filepath) {
            try {
                uint8[] contents;
                GLib.FileUtils.get_data(filepath, out contents);
                return parsetorrent (contents);
            } catch (GLib.Error e) {
                return null;
            }
        }

        public static TorrentInfo? parsetorrent (uint8[] contents) {
            BencodeParser parser = new BencodeParser(contents);
            BencodeValue? root = parser.parse();

            if (root == null || root.value_type != BencodeValue.Type.DICT) {
                return null;
            }
            TorrentInfo info = new TorrentInfo();
            info.bencode_data = root.copy();

            BencodeValue? announce_val = root.dict_get("announce");
            if (announce_val != null) {
                string? announce_str = announce_val.get_string();
                if (announce_str != null) {
                    info.announce_list.add(announce_str);
                }
            }

            BencodeValue? announce_list_val = root.dict_get("announce-list");
            if (announce_list_val != null && announce_list_val.value_type == BencodeValue.Type.LIST) {
                foreach (BencodeValue tier in announce_list_val.list_value) {
                    if (tier.value_type == BencodeValue.Type.LIST) {
                        foreach (BencodeValue url in tier.list_value) {
                            if (url.value_type == BencodeValue.Type.STRING) {
                                string? url_str = url.get_string();
                                if (url_str != null && !info.announce_list.contains(url_str)) {
                                    info.announce_list.add(url_str);
                                }
                            }
                        }
                    }
                }
            }

            BencodeValue? comment_val = root.dict_get("comment");
            if (comment_val != null) {
                string? comment_str = comment_val.get_string();
                if (comment_str != null) {
                    info.comment = comment_str;
                }
            }

            BencodeValue? date_val = root.dict_get("creation date");
            if (date_val != null) {
                info.creation_date = date_val.get_int();
            }

            BencodeValue? created_by_val = root.dict_get("created by");
            if (created_by_val != null) {
                string? created_by_str = created_by_val.get_string();
                if (created_by_str != null) {
                    info.created_by = created_by_str;
                }
            }

            BencodeValue? info_dict = root.dict_get("info");
            if (info_dict == null || info_dict.value_type != BencodeValue.Type.DICT) {
                return null;
            }

            BencodeValue? name_val = info_dict.dict_get("name");
            if (name_val != null) {
                string? name_str = name_val.get_string();
                if (name_str != null) {
                    info.name = name_str;
                }
            }

            BencodeValue? files_val = info_dict.dict_get("files");

            file_counter = 0;
            if (files_val != null && files_val.value_type == BencodeValue.Type.LIST) {
                build_file_tree_with_parents(files_val, info);
                info.file_count = count_files(info.files);
                info.total_size = calculate_total_size(info.files);
            } else {
                BencodeValue? length_val = info_dict.dict_get("length");
                if (length_val != null) {
                    info.total_size = length_val.get_int();
                    info.file_count = 1;
                    TrFileInfo file_info = new TrFileInfo();
                    file_info.path = info.name;
                    file_info.size = info.total_size;
                    file_info.is_folder = false;
                    file_info.selected = true;
                    file_info.index = file_counter++;
                    info.files.add(file_info);
                }
            }
            BencodeValue? pieces_val = info_dict.dict_get ("pieces");
            if (pieces_val != null) {
                var pieces_bytes = pieces_val.get_bytes ();
                info.num_pieces  = (int) (pieces_bytes.length / 20);
            }

            BencodeValue? piece_length_val = info_dict.dict_get ("piece length");
            if (piece_length_val != null) {
                info.piece_length = piece_length_val.get_int ();
            }

            BencodeValue? private_val = info_dict.dict_get ("private");
            if (private_val != null) {
                info.trprivate = private_val.get_int ();
            }
            return info;
        }
        
        private static void build_file_tree_with_parents(BencodeValue files_val, TorrentInfo info) {
            Gee.ArrayList<TrFileInfo> root_files = new Gee.ArrayList<TrFileInfo>();
            foreach (BencodeValue file_val in files_val.list_value) {
                if (file_val.value_type != BencodeValue.Type.DICT) {
                    continue;
                }
                BencodeValue? length_val = file_val.dict_get("length");
                BencodeValue? path_val = file_val.dict_get("path");
                
                if (path_val == null || path_val.value_type != BencodeValue.Type.LIST) {
                    continue;
                }
                string[] path_parts = {};
                foreach (BencodeValue part in path_val.list_value) {
                    if (part.value_type == BencodeValue.Type.STRING) {
                        string? part_str = part.get_string();
                        if (part_str != null) {
                            path_parts += part_str;
                        }
                    }
                }
                
                if (path_parts.length == 0) {
                    continue;
                }
                TrFileInfo file_info = new TrFileInfo();
                if (length_val != null) {
                    file_info.size = length_val.get_int();
                }
                file_info.is_folder = false;
                file_info.path = path_parts[path_parts.length - 1];
                file_info.selected = true;
                file_info.bencode_file_data = file_val.copy();
                file_info.bencode_path_parts = path_parts;
                file_info.index = file_counter++;
                
                Gee.ArrayList<TrFileInfo> current_level = root_files;
                TrFileInfo? current_parent = null;
                
                for (int i = 0; i < path_parts.length - 1; i++) {
                    string folder_name = path_parts[i];
                    TrFileInfo? existing_folder = null;
                    
                    foreach (TrFileInfo item in current_level) {
                        if (item.is_folder && item.path == folder_name) {
                            existing_folder = item;
                            break;
                        }
                    }
                    if (existing_folder == null) {
                        TrFileInfo new_folder = new TrFileInfo();
                        new_folder.path = folder_name;
                        new_folder.is_folder = true;
                        new_folder.size = 0;
                        new_folder.parent = current_parent;
                        current_level.add(new_folder);
                        existing_folder = new_folder;
                    }
                    current_parent = existing_folder;
                    current_level = existing_folder.children;
                }
                file_info.parent = current_parent;
                current_level.add(file_info);
            }
            info.files = root_files;
        }
        
        private static int count_files(Gee.ArrayList<TrFileInfo> files) {
            int count = 0;
            foreach (TrFileInfo file in files) {
                if (file.is_folder) {
                    count += count_files(file.children);
                } else {
                    count++;
                }
            }
            return count;
        }
        
        private static int64 calculate_total_size(Gee.ArrayList<TrFileInfo> files) {
            int64 total = 0;
            foreach (TrFileInfo file in files) {
                if (file.is_folder) {
                    int64 folder_size = calculate_total_size(file.children);
                    file.size = folder_size;
                    total += folder_size;
                } else {
                    total += file.size;
                }
            }
            return total;
        }
        
        private static Gee.ArrayList<BencodeValue> collect_selected_file_data(Gee.ArrayList<TrFileInfo> files) {
            var result = new Gee.ArrayList<BencodeValue>();
            foreach (TrFileInfo file in files) {
                if (file.is_folder) {
                    result.add_all(collect_selected_file_data(file.children));
                } else if (file.selected && file.bencode_file_data != null) {
                    result.add(file.bencode_file_data);
                }
            }
            return result;
        }

        public static Gee.HashSet<int> parse_selected_indices(string s) {
            var set = new Gee.HashSet<int>();
            if (s == null || s.strip() == "") {
                return set;
            }
            foreach (string part in s.split(",")) {
                int v = int.parse(part.strip());
                if (v > 0) {
                    set.add(v - 1);
                }
            }
            return set;
        }

        public static void apply_selection_to_files(Gee.ArrayList<TrFileInfo> files, Gee.Set<int> selected_indices) {
            foreach (TrFileInfo file in files) {
                if (file.is_folder) {
                    apply_selection_to_files(file.children, selected_indices);
                } else {
                    file.selected = selected_indices.contains(file.index);
                }
            }
        }

        public static uint8[] save_torrent_with_selection(TorrentInfo info) {
            if (info.bencode_data == null) {
                return new uint8[0];
            }
            BencodeValue modified_data = info.bencode_data.copy();
                BencodeValue? info_dict = modified_data.dict_get("info");
            if (info_dict == null || info_dict.value_type != BencodeValue.Type.DICT) {
                return new uint8[0];
            }

            BencodeValue? files_val = info_dict.dict_get("files");    
            if (files_val != null && files_val.value_type == BencodeValue.Type.LIST) {
                var new_files_list = new BencodeValue.list();
                var selected_file_data = collect_selected_file_data(info.files);
                foreach (BencodeValue file_data in selected_file_data) {
                    if (file_data != null) {
                        new_files_list.list_value.add(file_data.copy());
                    }
                }
                if (new_files_list.list_value.size == 0) {
                    return new uint8[0];
                }
                info_dict.dict_set("files", new_files_list);
                int64 new_total_size = 0;
                foreach (BencodeValue file in new_files_list.list_value) {
                    BencodeValue? length_val = file.dict_get("length");
                    if (length_val != null) {
                        new_total_size += length_val.get_int();
                    }
                }
                uint8[] encoded_bytes = BencodeParser.encode_to_bytes(modified_data);
                return encoded_bytes; 
            } else {
                bool single_file_selected = false;
                foreach (TrFileInfo file in info.files) {
                    if (!file.is_folder && file.selected) {
                        single_file_selected = true;
                        break;
                    }
                }
                if (!single_file_selected) {
                    return new uint8[0];
                }
                uint8[] encoded_bytes = BencodeParser.encode_to_bytes(modified_data);
                return encoded_bytes;
            }
        }

        public static string generate_magnet (TorrentInfo info) {
            if (info.bencode_data == null) {
                return "";
            }
            BencodeValue? info_dict = info.bencode_data.dict_get("info");
            if (info_dict == null) {
                return "";
            }
            uint8[] info_bytes = BencodeParser.encode_to_bytes(info_dict);
            var checksum = new GLib.Checksum(GLib.ChecksumType.SHA1);
            checksum.update(info_bytes, info_bytes.length);
            string infohash = checksum.get_string();
            string magnet = "magnet:?xt=urn:btih:" + infohash;
            if (info.name != "") {
                magnet += "&dn=" + Uri.escape_string(info.name);
            }
            foreach (string tr in info.announce_list){
                magnet += "&tr=" + Uri.escape_string(tr);
            }
            return magnet;
        }

        private static void collect_selected_file_indices(Gee.ArrayList<TrFileInfo> files, Gee.ArrayList<int> result) {
            foreach (TrFileInfo file in files) {
                if (file.is_folder) {
                    collect_selected_file_indices(file.children, result);
                } else if (file.selected && file.index >= 0) {
                    result.add(file.index);
                }
            }
        }
        
        public static string selected_options(TorrentInfo info) {
            var selected_indices = new Gee.ArrayList<int>();
            collect_selected_file_indices(info.files, selected_indices);
            if (selected_indices.size == 0) {
                return "";
            }
            selected_indices.sort();
            string indices_str = "";
            bool first = true;
            foreach (int idx in selected_indices) {
                if (!first) {
                    indices_str += ",";
                }
                indices_str += (idx + 1).to_string();
                first = false;
            }
            return "%s".printf(indices_str);
        }
    }
}