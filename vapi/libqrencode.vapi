/*
* Copyright (c) {2026} torikulhabib (https://github.com/gabutakut)
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

[CCode (cprefix = "QR_", lower_case_cprefix = "QR_", cheader_filename = "qrencode.h")]
namespace QRCode {
    [CCode (cname = "QRcode", free_function = "QRcode_free")]
    [Compact]
    public class Code {
        public int version;
        public int width;
        [CCode (array_length = false)]
        public uint8[] data;
    }
    
    [CCode (cname = "QRcode_encodeString")]
    public unowned QRCode.Code encode_string(string text, int version, int level, int hint, int casesensitive);
    
    [CCode (cname = "QRcode_APIVersion")]
    public static void api_version(out int major, out int minor, out int micro);
    
    [CCode (cname = "QRcode_APIVersionString")]
    public unowned string api_version_string();
    
    [CCode (cname = "QRcode_clearCache")]
    public void clear_cache();
    
    [CCode (cname = "QR_ECLEVEL_L")]
    public const int ECLEVEL_L;
    [CCode (cname = "QR_ECLEVEL_M")]
    public const int ECLEVEL_M;
    [CCode (cname = "QR_ECLEVEL_Q")]
    public const int ECLEVEL_Q;
    [CCode (cname = "QR_ECLEVEL_H")]
    public const int ECLEVEL_H;
    
    [CCode (cname = "QR_MODE_NUL")]
    public const int MODE_NUL;
    [CCode (cname = "QR_MODE_NUM")]
    public const int MODE_NUM;
    [CCode (cname = "QR_MODE_AN")]
    public const int MODE_AN;
    [CCode (cname = "QR_MODE_8")]
    public const int MODE_8;
    [CCode (cname = "QR_MODE_KANJI")]
    public const int MODE_KANJI;
    [CCode (cname = "QR_MODE_STRUCTURE")]
    public const int MODE_STRUCTURE;
    [CCode (cname = "QR_MODE_ECI")]
    public const int MODE_ECI;
    [CCode (cname = "QR_MODE_FNC1FIRST")]
    public const int MODE_FNC1FIRST;
    [CCode (cname = "QR_MODE_FNC1SECOND")]
    public const int MODE_FNC1SECOND;
}