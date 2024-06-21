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
                    image.set_from_icon_name (value);
                    image.show ();
                } else {
                    image.hide ();
                }
            }
        }

        private Gtk.Label title_label;
        private Gtk.Label description_label;
        private Gtk.Image image;

        public AlertView (string title, string description, string icon_name) {
            Object (title: title, description: description, icon_name: icon_name, column_spacing: 12, row_spacing: 6, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER,vexpand: true);
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
                valign = Gtk.Align.START,
                icon_size = Gtk.IconSize.LARGE,
                pixel_size = 64
            };
            attach (image, 1, 1, 1, 2);
            attach (title_label, 2, 1, 1, 1);
            attach (description_label, 2, 2, 1, 1);
        }
    }
}
