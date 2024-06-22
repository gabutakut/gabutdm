/*
 *  Copyright 2019 elementary, Inc. (https://elementary.io)
 *
 *  This program or library is free software; you can redistribute it
 *  and/or modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 3 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General
 *  Public License along with this library; if not, write to the
 *  Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 *  Boston, MA 02110-1301 USA.
 */

namespace Gabut {
    [DBus (name = "com.canonical.Unity.LauncherEntry")]
    private class UnityLauncherEntry : GLib.Object {
        public signal void update (string app_uri, GLib.HashTable<string, GLib.Variant> properties);
        internal GLib.HashTable<string, GLib.Variant> properties;
        internal static string app_uri = get_app_id ();
        internal static uint removebus = 0;
        internal static UnityLauncherEntry instance;

        internal static async unowned UnityLauncherEntry get_instance () throws GLib.Error {
            var local_instance = new UnityLauncherEntry ();
            var session_connection = yield GLib.Bus.@get (GLib.BusType.SESSION);
            if (removebus != 0) {
                session_connection.unregister_object (removebus);
            }
            removebus = session_connection.register_object (new GLib.ObjectPath ("/com/canonical/unity/launcherentry/%u".printf (app_uri.hash ())), local_instance);
            instance = local_instance;
            return instance;
        }

        construct {
            properties = new GLib.HashTable<string, GLib.Variant> (str_hash, str_equal);
            properties["urgent"] = new GLib.Variant.boolean (false);
            properties["count"] = new GLib.Variant.int64 (0);
            properties["count-visible"] = new GLib.Variant.boolean (false);
            properties["progress"] = new GLib.Variant.double (0.0);
            properties["progress-visible"] = new GLib.Variant.boolean (false);
            properties["quicklist"] = new GLib.Variant.string ("");
        }

        internal void set_app_property (string property, GLib.Variant var) {
            var updated_properties = new GLib.HashTable<string, GLib.Variant> (str_hash, str_equal);
            updated_properties[property] = var;
            properties[property] = var;
            update (app_uri, updated_properties);
        }

        public GLib.HashTable<string, Variant> query () throws GLib.Error {
            return properties;
        }
    }
}