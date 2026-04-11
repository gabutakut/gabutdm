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
    public class BencodeValue : GLib.Object {
        public BTType value_type { get; set; }
        public int64 int_value { get; set; }
        public string str_value = "";
        public uint8[] bytes_value;
        public Gee.ArrayList<BencodeValue> list_value { get; set; }
        public GLib.HashTable<string, BencodeValue> dict_value { get; set; }

        construct {
            list_value = new Gee.ArrayList<BencodeValue> ();
            dict_value = new GLib.HashTable<string, BencodeValue>(GLib.str_hash, GLib.str_equal);
        }

        public BencodeValue.integer(int64 val) {
            value_type = BTType.INTEGER;
            int_value = val;
        }

        public BencodeValue.string(string val) {
            value_type = BTType.STRING;
            str_value = val;
            bytes_value = val.data;
        }

        public BencodeValue.bytes(uint8[] val) {
            value_type = BTType.STRING;
            bytes_value = val;
            str_value = (string)val;
        }

        public BencodeValue.list() {
            value_type = BTType.LIST;
        }

        public BencodeValue.dict() {
            value_type = BTType.DICT;
        }

        public BencodeValue copy() {
            BencodeValue copy = new BencodeValue();
            copy.value_type = this.value_type;
            switch (this.value_type) {
                case BTType.INTEGER:
                    copy.int_value = this.int_value;
                    break;
                case BTType.STRING:
                    copy.str_value = this.str_value;
                    copy.bytes_value = this.bytes_value;
                    break;
                case BTType.LIST:
                    foreach (var item in this.list_value) {
                        copy.list_value.add(item.copy());
                    }
                    break;
                case BTType.DICT:
                    var iter = GLib.HashTableIter<string, BencodeValue>(this.dict_value);
                    string key;
                    BencodeValue val;
                    while (iter.next(out key, out val)) {
                        copy.dict_value.insert(key, val.copy());
                    }
                    break;
            }
            return copy;
        }

        public string? get_string() {
            if (value_type != BTType.STRING) {
                return null;
            }
            return str_value;
        }

        public int64 get_int() {
            if (value_type != BTType.INTEGER) {
                return 0;
            }
            return int_value;
        }

        public uint8[] get_bytes() {
            if (value_type != BTType.STRING) {
                return new uint8[0];
            }
            return bytes_value;
        }

        public BencodeValue? dict_get(string key) {
            if (value_type != BTType.DICT) {
                return null;
            }
            return dict_value.lookup(key);
        }

        public void dict_set(string key, BencodeValue value) {
            if (value_type != BTType.DICT) {
                return;
            }
            dict_value.insert(key, value);
        }

        public bool dict_remove(string key) {
            if (value_type != BTType.DICT) {
                return false;
            }
            return dict_value.remove(key);
        }
    }
}