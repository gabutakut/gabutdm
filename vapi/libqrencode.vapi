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

namespace Qrencode {
    [CCode (cheader_filename = "qrencode.h", cname = "QRcode", unref_function = "QRcode_free")]
    public class QRcode {
        [CCode (cname = "QRcode_encodeInput")]
        public QRcode.encodeInput (QRinput input);
        [CCode (cname = "QRcode_encodeString")]
        public QRcode.encodeString (string string, int version, EcLevel level, Mode hint, int casesensitive);
        [CCode (cname = "QRcode_encodeString8bit")]
        public QRcode.encodeString8bit (string string, int version, EcLevel level);
        [CCode (cname = "QRcode_encodeStringMQR")]
        public QRcode.encodeStringMQR (string string, int version, EcLevel level, Mode hint, int casesensitive);
        [CCode (cname = "QRcode_encodeString8bitMQR")]
        public QRcode.encodeString8bitMQR (string string, int version, EcLevel level);
        [CCode (cname = "QRcode_encodeData")]
        public QRcode.encodeData (int size, char* data, int version, EcLevel level);
        [CCode (cname = "QRcode_encodeDataMQR")]
        public QRcode.encodeDataMQR (int size, char* data, int version, EcLevel level);
        [CCode (cname = "QRcode_encodeStringStructured")]
        public static QRcodeList encodeStringStructured(string string, int version, EcLevel level, Mode hint, int casesensitive);
        [CCode (cname = "QRcode_encodeString8bitStructured")]
        public static QRcodeList encodeString8bitStructured (string string, int version, EcLevel level);
        [CCode (cname = "QRcode_encodeDataStructured")]
        public static int encodeDataStructured (int size, string data, int version, EcLevel level);
        public int version;
        public int width;
        public char* data;
    }

    [CCode (cheader_filename = "qrencode.h", cname = "QRinput", unref_function = "QRinput_free")]
    public class QRinput {
        [CCode (cname = "QRinput_new")]
        public QRinput ();
        [CCode (cname = "QRinput_new2")]
        public QRinput.new2 (int version, EcLevel level);
        [CCode (cname = "QRinput_newMQR")]
        public QRinput.MQR (int version, EcLevel level);
        [CCode (cname = "QRinput_append")]
        public int append (Mode mode, int size, char* data);
        [CCode (cname = "QRinput_appendECIheader")]
        public int appendECIheader (int ecinum);
        [CCode (cname = "QRinput_getVersion")]
        public int getVersion ();
        [CCode (cname = "QRinput_setVersion")]
        public int setVersion (int version);
        [CCode (cname = "QRinput_getErrorCorrectionLevel")]
        public EcLevel getErrorCorrectionLevel ();
        [CCode (cname = "QRinput_setErrorCorrectionLevel")]
        public int setErrorCorrectionLevel (EcLevel level);
        [CCode (cname = "QRinput_setVersionAndErrorCorrectionLevel")]
        public int setVersionAndErrorCorrectionLevel (int version, EcLevel level);
        [CCode (cname = "QRinput_check")]
        public static int check (Mode mode, int size, char* data);
        [CCode (cname = "QRinput_splitQRinputToStruct")]
        public QRinputStruct splitQRinputToStruct ();
        [CCode (cname = "QRinput_setFNC1First")]
        public int setFNC1First ();
        [CCode (cname = "QRinput_setFNC1Second")]
        public int setFNC1Second(string appid);
    }

    [CCode (cheader_filename = "qrencode.h", cname = "QRinput_Struct", unref_function = "QRinput_Struct_free")]
    public class QRinputStruct {
        [CCode (cname = "QRinput_Struct_new")]
        public QRinputStruct ();
        [CCode (cname = "QRinput_Struct_setParity")]
        public void setParity(string parity);
        [CCode (cname = "QRinput_Struct_appendInput")]
        public int appendInput (QRinput input);
        [CCode (cname = "QRinput_Struct_insertStructuredAppendHeaders")]
        public int insertStructuredAppendHeaders ();
        [CCode (cname = "QRcode_encodeInputStructured")]
        public QRcodeList encodeInputStructured (int version);
    }

    [CCode (cheader_filename = "qrencode.h", cname = "QRcode_List", unref_function = "QRcode_List_free")]
    public class QRcodeList {
        [CCode (cname = "QRcode_List_size")]
        public int List_size ();
        public QRcode code;
        public QRcodeList next;
    }

    [CCode (cheader_filename = "qrencode.h", cname="QRecLevel")]
    public enum EcLevel {
        [CCode (cname="QR_ECLEVEL_L")]
        L,
        [CCode (cname="QR_ECLEVEL_M")]
        M,
        [CCode (cname="QR_ECLEVEL_Q")]
        Q,
        [CCode (cname="QR_ECLEVEL_H")]
        H
    }

    [CCode (cheader_filename = "qrencode.h", cname="QRencodeMode")]
    public enum Mode {
        [CCode (cname="QR_MODE_NUL")]
        NUL,
        [CCode (cname="QR_MODE_NUM")]
        NUM,
        [CCode (cname="QR_MODE_AN")]
        AN,
        [CCode (cname="QR_MODE_8")]
        B8,
        [CCode (cname="QR_MODE_KANJI")]
        KANJI,
        [CCode (cname="QR_MODE_STRUCTURE")]
        STRUCTURE
    }
}

