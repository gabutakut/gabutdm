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
            get_style_context ().add_class (Gtk.STYLE_CLASS_VIEW);

            title_label = new Gtk.Label (null);
            title_label.hexpand = true;
            title_label.get_style_context ().add_class ("h2");
            title_label.max_width_chars = 75;
            title_label.wrap = true;
            title_label.wrap_mode = Pango.WrapMode.WORD_CHAR;
            title_label.xalign = 0;

            description_label = new Gtk.Label (null);
            description_label.hexpand = true;
            description_label.max_width_chars = 75;
            description_label.wrap = true;
            description_label.use_markup = true;
            description_label.xalign = 0;
            description_label.valign = Gtk.Align.START;

            image = new Gtk.Image ();
            image.margin_top = 6;
            image.valign = Gtk.Align.START;

            var layout = new Gtk.Grid ();
            layout.column_spacing = 12;
            layout.row_spacing = 6;
            layout.halign = Gtk.Align.CENTER;
            layout.valign = Gtk.Align.CENTER;
            layout.vexpand = true;
            layout.margin = 24;

            layout.attach (image, 1, 1, 1, 2);
            layout.attach (title_label, 2, 1, 1, 1);
            layout.attach (description_label, 2, 2, 1, 1);

            add (layout);
        }
    }
}
