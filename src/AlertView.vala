namespace Gabut {
    public class AlertView : Gtk.Grid {
        public string title {
            get {
                return title_label.label;
            }
            set {
                title_label.label = value;
            }
        }

        public string description {
            get {
                return description_label.label;
            }
            set {
                description_label.label = value;
            }
        }

        public string icon_name {
            owned get {
                return image.icon_name ?? "";
            }
            set {
                if (value != null && value != "") {
                    image.set_from_icon_name (value, Gtk.IconSize.DIALOG);
                    image.no_show_all = false;
                    image.show ();
                } else {
                    image.no_show_all = true;
                    image.hide ();
                }
            }
        }

        private Gtk.Label title_label;
        private Gtk.Label description_label;
        private Gtk.Image image;

        public AlertView (string title, string description, string icon_name) {
            Object (title: title, description: description, icon_name: icon_name);
        }

        construct {
            title_label = new Gtk.Label (null) {
                max_width_chars = 75,
                wrap = true,
                hexpand = true,
                wrap_mode = Pango.WrapMode.WORD_CHAR,
                xalign = 0,
                attributes = set_attribute (Pango.Weight.BOLD, 2)
            };

            description_label = new Gtk.Label (null) {
                hexpand = true,
                max_width_chars = 75,
                wrap = true,
                use_markup = true,
                xalign = 0,
                valign = Gtk.Align.START,
                attributes = set_attribute (Pango.Weight.SEMIBOLD, 1.1)
            };

            image = new Gtk.Image () {
                margin_top = 6,
                valign = Gtk.Align.START
            };

            var layout = new Gtk.Grid () {
                column_spacing = 12,
                row_spacing = 6,
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER,
                vexpand = true,
                margin = 24
            };

            layout.attach (image, 1, 1, 1, 2);
            layout.attach (title_label, 2, 1, 1, 1);
            layout.attach (description_label, 2, 2, 1, 1);

            add (layout);
        }
    }
}
