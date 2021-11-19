/*
* Copyright (c) {2021} torikulhabib (https://github.com/gabutakut)
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
        public string first_label { get; construct; }
        public string second_label { get; construct; }
        public signal void tooltip_notify (string text);
        public MediaEntry (string first_label, string second_label, bool second = true) {
            Object (
                first_label: first_label,
                second_label: second_label,
                secondary_icon_activatable: second
            );
        }

        construct {
            primary_icon_name = first_label;
            primary_icon_tooltip_text = _("Copy");
            secondary_icon_name = second_label;
            secondary_icon_tooltip_text = _("Paste");
            hexpand = true;
            icon_press.connect ((pos, event) => {
                Gtk.Clipboard clipboard = Gtk.Clipboard.get_for_display (get_display (), Gdk.SELECTION_CLIPBOARD);
                if (pos == Gtk.EntryIconPosition.PRIMARY) {
                    clipboard.set_text (text, text.length);
                    tooltip_notify (primary_icon_tooltip_text);
                }
                if (pos == Gtk.EntryIconPosition.SECONDARY) {
                    text = clipboard.wait_for_text ().strip ();
                    tooltip_notify (secondary_icon_tooltip_text);
                }
            });
            activates_default = true;
        }
    }
}
