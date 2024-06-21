/*
* Copyright (c) {2024} torikulhabib (https://github.com/gabutakut)
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
    private class MediaEntry : Gtk.Entry {
        public enum EntryType {
            STANDARD,
            WITHSIGNAL,
            INFO
        }
        public signal void pclicked ();
        public signal void sclicked ();
        private Gdk.Clipboard clipboard;
        public EntryType entrytype { get; construct; }

        public MediaEntry (string first_label, string second_label) {
            Object (
                entrytype: EntryType.STANDARD,
                secondary_icon_activatable: true,
                primary_icon_name: first_label,
                secondary_icon_name: second_label,
                primary_icon_tooltip_text: _("Copy"),
                secondary_icon_tooltip_text: _("Paste"),
                hexpand: true,
                activates_default: true
            );
        }

        public MediaEntry.activable (string first_label, string second_label) {
            Object (
                entrytype: EntryType.WITHSIGNAL,
                secondary_icon_activatable: true,
                primary_icon_name: first_label,
                secondary_icon_name: second_label,
                hexpand: true,
                activates_default: true
            );
        }

        public MediaEntry.info (string first_label, string second_label) {
            Object (
                entrytype: EntryType.INFO,
                secondary_icon_activatable: false,
                primary_icon_activatable: false,
                primary_icon_name: first_label,
                secondary_icon_name: second_label,
                editable: false,
                hexpand: true,
                activates_default: false
            );
        }

        construct {
            icon_press.connect ((pos) => {
                switch (entrytype) {
                    case EntryType.WITHSIGNAL:
                        if (pos == Gtk.EntryIconPosition.PRIMARY) {
                            pclicked ();
                        }
                        if (pos == Gtk.EntryIconPosition.SECONDARY) {
                            sclicked ();
                        }
                        break;
                    default:
                        clipboard = get_display ().get_clipboard ();
                        if (pos == Gtk.EntryIconPosition.PRIMARY) {
                            clipboard.set_text (text);
                        }
                        if (pos == Gtk.EntryIconPosition.SECONDARY) {
                            get_value.begin ();
                        }
                        break;
                }
            });
        }

        private async void get_value () throws Error {
            unowned GLib.Value? value = yield clipboard.read_value_async (GLib.Type.STRING, GLib.Priority.DEFAULT, null);
            text = value.get_string ();
        }
    }
}