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
    public class SuccesDialog : Gtk.Dialog {
        private Gtk.Image icon_image;
        private Gtk.Label filesizelabel;
        private MediaEntry address;
        private MediaEntry directory;
        public string datastr;

        public SuccesDialog (Gtk.Application application) {
            Object (application: application,
                    resizable: false,
                    use_header_bar: 1
            );
        }

        construct {
            icon_image = new Gtk.Image () {
                valign = Gtk.Align.START,
                halign = Gtk.Align.END,
                icon_size = Gtk.IconSize.LARGE,
                pixel_size = 64
            };

            var icon_badge = new Gtk.Image () {
                halign = Gtk.Align.END,
                valign = Gtk.Align.END,
                gicon = new ThemedIcon ("process-completed"),
                icon_size = Gtk.IconSize.LARGE
            };

            var overlay = new Gtk.Overlay ();
            overlay.set_child (icon_image);
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
            header.set_title_widget (header_grid);
            header.decoration_layout = "none";

            address = new MediaEntry ("insert-link", "process-completed") {
                primary_icon_tooltip_text = "",
                secondary_icon_tooltip_text = "",
                hexpand = true,
                width_request = 450,
                sensitive = false
            };

            directory = new MediaEntry ("folder", "process-completed") {
                primary_icon_tooltip_text = "",
                secondary_icon_tooltip_text = "",
                hexpand = true,
                width_request = 450,
                sensitive = false
            };

            var dontshow = new Gtk.CheckButton.with_label (_("Don't open this dialog when download complete")) {
                margin_top = 5,
                margin_bottom = 5,
                active = !bool.parse (get_dbsetting (DBSettings.DIALOGNOTIF))
            };
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
            open_file.clicked.connect (()=> {
                string[] datastrs = datastr.split ("<gabut>");
                open_fileman.begin (File.new_for_path (datastrs[1]).get_uri ());
                close ();
            });
            var close_button = new Gtk.Button.with_label (_("Close")) {
                width_request = 120,
                height_request = 25
            };
            close_button.clicked.connect (()=> {
                close ();
            });

            var open_folder = new Gtk.Button.with_label (_("Open Folder")) {
                width_request = 120,
                height_request = 25
            };
            open_folder.clicked.connect (()=> {
                string[] datastrs = datastr.split ("<gabut>");
                var file = File.new_for_path (datastrs[1]);
                if (datastrs[3] == "inode/directory") {
                    open_fileman.begin (file.get_uri ());
                } else {
                    open_fileman.begin (file.get_parent ().get_uri ());
                }
                close ();
            });

            var box_action = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5) {
                margin_bottom = 10,
                halign = Gtk.Align.END,
                hexpand = true
            };
            box_action.append (open_file);
            box_action.append (open_folder);
            box_action.append (close_button);

            var maingrid = new Gtk.Grid () {
                orientation = Gtk.Orientation.VERTICAL,
                halign = Gtk.Align.CENTER,
                margin_start = 10,
                margin_end = 10,
                hexpand = true
            };
            maingrid.attach (dialogmain, 0, 0);
            maingrid.attach (box_action, 0, 1);
            set_child (maingrid);
        }

        public void set_dialog (string datastr) {
            this.datastr = datastr;
            string[] datastrs = datastr.split ("<gabut>");
            address.text = datastrs[0];
            File file = File.new_for_path (datastrs[1]);
            directory.text = file.get_path ();
            filesizelabel.label = _("Downloaded %s").printf (format_size (int64.parse (datastrs[2]), GLib.FormatSizeFlags.LONG_FORMAT));
            icon_image.gicon = GLib.ContentType.get_icon (datastrs[3]);
        }
    }
}
