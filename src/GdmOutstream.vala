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
	public class GdmOutstream : GLib.OutputStream {
		public MemoryInputStream stream;

		public GdmOutstream () {
			stream = new MemoryInputStream ();
		}

		public override ssize_t write (uint8[] buffer, Cancellable? cancellable = null) throws IOError {
			var byte = new GLib.Bytes (buffer);
			stream.add_bytes (byte);
			return (ssize_t) byte.get_size ();
		}

		public override bool close (Cancellable? cancellable = null) throws IOError {
			return stream.close ();
		}
	}
}