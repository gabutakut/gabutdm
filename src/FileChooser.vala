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
    public class FileChooser : Gtk.FileChooserDialog {
        public FileChooser (Gtk.Application application) {
            Object (application: application,
                    title: _("Open"),
                    action: Gtk.FileChooserAction.OPEN,
                    deletable: false
            );
        }

        construct {
            var torrent = new Gtk.FileFilter ();
            torrent.set_filter_name (_("Torrent"));
            torrent.add_mime_type ("application/x-bittorrent");
            var metalink = new Gtk.FileFilter ();
            metalink.set_filter_name (_("Metalink"));
            metalink.add_pattern ("application/metalink+xml");

            add_filter (torrent);
            add_filter (metalink);
            move_widget (this);

            add_button (_("Cancel"), Gtk.ResponseType.CANCEL);
            var suggested_button = add_button (_("Open"), Gtk.ResponseType.ACCEPT);
            suggested_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        }
    }
}
