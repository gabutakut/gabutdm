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
    public class BencodeParser : GLib.Object {
        private uint8[] data;
        private int pos;

        public BencodeParser(uint8[] data) {
            this.data = data;
            this.pos = 0;
        }

        public BencodeValue? parse() {
            if (pos >= data.length) {
                return null;
            }
            uint8 c = data[pos];
            if (c == 'i') {
                return parse_int();
            } else if (c == 'l') {
                return parse_list();
            } else if (c == 'd') {
                return parse_dict();
            } else if (c >= '0' && c <= '9') {
                return parse_string();
            }
            return null;
        }

        private BencodeValue? parse_int() {
            pos++;
            int64 value = 0;
            bool negative = false;
            if (pos < data.length && data[pos] == '-') {
                negative = true;
                pos++;
            }
            while (pos < data.length && data[pos] != 'e') {
                value = value * 10 + (data[pos] - '0');
                pos++;
            }
            pos++;
            return new BencodeValue.integer(negative ? -value : value);
        }

        private BencodeValue? parse_string() {
            int64 length = 0;
            while (pos < data.length && data[pos] != ':') {
                length = length * 10 + (data[pos] - '0');
                pos++;
            }
            pos++;
            uint8[] bytes = new uint8[length];
            for (int64 i = 0; i < length && pos < data.length; i++) {
                bytes[i] = data[pos++];
            }
            return new BencodeValue.bytes(bytes);
        }

        private BencodeValue? parse_list() {
            pos++;
            BencodeValue result = new BencodeValue.list();
            while (pos < data.length && data[pos] != 'e') {
                BencodeValue? item = parse();
                if (item != null) {
                    result.list_value.add(item);
                }
            }
            pos++;
            return result;
        }

        private BencodeValue? parse_dict() {
            pos++;
            BencodeValue result = new BencodeValue.dict();
            while (pos < data.length && data[pos] != 'e') {
                BencodeValue? key_val = parse_string();
                BencodeValue? value = parse();

                if (key_val != null && value != null) {
                    string key = key_val.get_string();
                    if (key != null) {
                        result.dict_value.insert(key, value);
                    }
                }
            }
            pos++;
            return result;
        }

        public static uint8[] encode_to_bytes(BencodeValue value) {
            GLib.ByteArray buffer = new GLib.ByteArray();
            encode_value(value, buffer);
            return buffer.data;
        }

        private static void encode_value(BencodeValue value, GLib.ByteArray buffer) {
            switch (value.value_type) {
                case BencodeValue.Type.INTEGER:
                    string int_str = "i" + value.int_value.to_string() + "e";
                    buffer.append((uchar[])int_str.data);
                    break;
                case BencodeValue.Type.STRING:
                    size_t byte_len = value.bytes_value.length;
                    string len_str = "%zu:".printf(byte_len);
                    buffer.append((uchar[])len_str.data);
                    buffer.append(value.bytes_value);
                    break;
                case BencodeValue.Type.LIST:
                    buffer.append({(uint8)'l'});
                    foreach (var item in value.list_value) {
                        encode_value(item, buffer);
                    }
                    buffer.append({(uint8)'e'});
                    break;
                case BencodeValue.Type.DICT:
                    buffer.append({(uint8)'d'});
                    var keys = new Gee.ArrayList<string>();
                    var iter = GLib.HashTableIter<string, BencodeValue>(value.dict_value);
                    string dict_key;
                    BencodeValue dict_val;
                    while (iter.next(out dict_key, out dict_val)) {
                        keys.add(dict_key);
                    }
                    keys.sort();
                    foreach (var sorted_key in keys) {
                        var sorted_val = value.dict_value.lookup(sorted_key);
                        string key_len_str = "%zu:".printf(sorted_key.length);
                        buffer.append((uchar[])key_len_str.data);
                        buffer.append((uchar[])sorted_key.data);
                        encode_value(sorted_val, buffer);
                    }
                    buffer.append({(uint8)'e'});
                    break;
            }
        }

        public static void encode_to_buffer(BencodeValue value, GLib.StringBuilder buffer) {
            uint8[] bytes = encode_to_bytes(value);
            buffer.append_len((string)bytes, bytes.length);
        }
    }
}