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
    public class SuccesDialog : Gtk.Dialog {
        private Gtk.Image icon_image;
        private Gtk.Label filesizelabel;
        private MediaEntry address;
        private MediaEntry directory;
        public string datastr;

        construct {
            resizable = false;
            use_header_bar = 1;
            icon_image = new Gtk.Image () {
                valign = Gtk.Align.START,
                halign = Gtk.Align.END,
                icon_size = Gtk.IconSize.LARGE,
                pixel_size = 64
            };

            var icon_badge = new Gtk.Image () {
                halign = Gtk.Align.END,
                valign = Gtk.Align.END,
                gicon = new ThemedIcon ("com.github.gabutakut.gabutdm.complete"),
                icon_size = Gtk.IconSize.LARGE
            };

            var overlay = new Gtk.Overlay () {
                child = icon_image
            };
            overlay.add_overlay (icon_badge);

            var primarylabel = new Gtk.Label ("Download Complete") {
                ellipsize = Pango.EllipsizeMode.END,
                max_width_chars = 45,
                use_markup = true,
                wrap = true,
                xalign = 0,
                attributes = set_attribute (Pango.Weight.ULTRABOLD, 1.6)
            };

            filesizelabel = new Gtk.Label (null) {
                ellipsize = Pango.EllipsizeMode.END,
                max_width_chars = 45,
                use_markup = true,
                wrap = true,
                xalign = 0,
                attributes = set_attribute (Pango.Weight.SEMIBOLD, 1.1)
            };

            var header_grid = new Gtk.Grid () {
                column_spacing = 0,
                hexpand = true,
                halign = Gtk.Align.START,
                valign = Gtk.Align.CENTER
            };
            header_grid.attach (overlay, 0, 0, 1, 2);
            header_grid.attach (primarylabel, 1, 0, 1, 1);
            header_grid.attach (filesizelabel, 1, 1, 1, 1);

            var header = get_header_bar ();
            header.title_widget = header_grid;
            header.decoration_layout = "none";

            address = new MediaEntry.info ("com.github.gabutakut.gabutdm.insertlink", "com.github.gabutakut.gabutdm.complete") {
                hexpand = true,
                width_request = 450
            };

            directory = new MediaEntry.info ("folder", "com.github.gabutakut.gabutdm.complete") {
                hexpand = true,
                width_request = 450
            };

            var dontshow = new Gtk.CheckButton.with_label (_("Don't open this dialog when download complete")) {
                margin_top = 5,
                margin_bottom = 5,
                active = !bool.parse (get_dbsetting (DBSettings.DIALOGNOTIF))
            };
            ((Gtk.Label) dontshow.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            dontshow.toggled.connect (()=> {
                set_dbsetting (DBSettings.DIALOGNOTIF, (!dontshow.active).to_string ());
            });
            var dialogmain = new Gtk.Grid () {
                height_request = 130,
                width_request = 500,
                halign = Gtk.Align.START
            };
            dialogmain.attach (headerlabel (_("Address:"), 300), 1, 1, 1, 1);
            dialogmain.attach (address, 1, 2, 1, 1);
            dialogmain.attach (headerlabel (_("Directory:"), 300), 1, 3, 1, 1);
            dialogmain.attach (directory, 1, 4, 1, 1);
            dialogmain.attach (dontshow, 1, 5, 1, 1);

            var open_file = new Gtk.Button.with_label (_("Open File")) {
                width_request = 120,
                height_request = 25
            };
            ((Gtk.Label) open_file.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            open_file.clicked.connect (()=> {
                open_fileman.begin (File.new_for_path (info_succes (datastr, InfoSucces.FILEPATH)).get_uri ());
                close ();
            });
            var close_button = new Gtk.Button.with_label (_("Close")) {
                width_request = 120,
                height_request = 25
            };
            ((Gtk.Label) close_button.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            close_button.clicked.connect (()=> {
                close ();
            });

            var open_folder = new Gtk.Button.with_label (_("Open Folder")) {
                width_request = 120,
                height_request = 25
            };
            ((Gtk.Label) open_folder.get_last_child ()).attributes = set_attribute (Pango.Weight.SEMIBOLD);
            open_folder.clicked.connect (()=> {
                var file = File.new_for_path (info_succes (datastr, InfoSucces.FILEPATH));
                if (info_succes (datastr, InfoSucces.ICONNAME) == "inode/directory") {
                    open_fileman.begin (file.get_uri ());
                } else {
                    open_fileman.begin (file.get_parent ().get_uri ());
                }
                close ();
            });

            var box_action = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
            box_action.append (open_file);
            box_action.append (open_folder);

            var centerbox = new Gtk.CenterBox () {
                margin_top = 10,
                margin_bottom = 10
            };
            centerbox.set_start_widget (box_action);
            centerbox.set_end_widget (close_button);
            var area = get_content_area ();
            area.margin_start = 10;
            area.margin_end = 10;
            area.halign = Gtk.Align.CENTER;
            area.append (dialogmain);
            area.append (centerbox);
        }

        public override void show () {
            base.show ();
            address.text = info_succes (datastr, InfoSucces.ADDRESS);
            directory.text = File.new_for_path (info_succes (datastr, InfoSucces.FILEPATH)).get_path ();
            filesizelabel.label = _("Downloaded %s").printf (format_size (int64.parse (info_succes (datastr, InfoSucces.FILESIZE)), GLib.FormatSizeFlags.LONG_FORMAT));
            icon_image.gicon = GLib.ContentType.get_icon (info_succes (datastr, InfoSucces.ICONNAME));
        }
    }
}