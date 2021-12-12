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
    private enum DBSettings {
        ID = 0,
        RPCPORT = 1,
        MAXTRIES = 2,
        CONNSERVER = 3,
        TIMEOUT = 4,
        DIR = 5,
        RETRY = 6,
        RPCSIZE = 7,
        BTMAXPEERS = 8,
        DISKCACHE = 9,
        MAXACTIVE = 10,
        BTTIMEOUTTRACK = 11,
        SPLIT = 12,
        MAXOPENFILE = 13,
        DIALOGNOTIF = 14,
        SYSTEMNOTIF = 15,
        ONBACKGROUND = 16,
        IPLOCAL = 17,
        PORTLOCAL = 18,
        SEEDTIME = 19,
        OVERWRITE = 20,
        AUTORENAMING = 21,
        FILEALLOCATION = 22,
        STARTUP = 23;

        public string get_name () {
            switch (this) {
                case RPCPORT:
                    return "rpcport";
                case MAXTRIES:
                    return "maxtries";
                case CONNSERVER:
                    return "connserver";
                case TIMEOUT:
                    return "timeout";
                case DIR:
                    return "dir";
                case RETRY:
                    return "retry";
                case RPCSIZE:
                    return "rpcsize";
                case BTMAXPEERS:
                    return "btmaxpeers";
                case DISKCACHE:
                    return "diskcache";
                case MAXACTIVE:
                    return "maxactive";
                case BTTIMEOUTTRACK:
                    return "bttimeouttrack";
                case SPLIT:
                    return "split";
                case MAXOPENFILE:
                    return "maxopenfile";
                case DIALOGNOTIF:
                    return "dialognotif";
                case SYSTEMNOTIF:
                    return "systemnotif";
                case ONBACKGROUND:
                    return "onbackground";
                case IPLOCAL:
                    return "iplocal";
                case PORTLOCAL:
                    return "portlocal";
                case SEEDTIME:
                    return "seedtime";
                case OVERWRITE:
                    return "overwrite";
                case AUTORENAMING:
                    return "autorenaming";
                case FILEALLOCATION:
                    return "allocation";
                case STARTUP:
                    return "startup";
                default:
                    return "id";
            }
        }
    }

    private enum TellStatus {
        GID = 0,
        STATUS = 1,
        TOTALLENGTH = 2,
        COMPELETEDLENGTH = 3,
        UPLOADLENGTH = 4,
        BITFIELD = 5,
        DOWNLOADSPEED = 6,
        UPLOADSPEED = 7,
        INFOHASH = 8,
        NUMSEEDERS = 9,
        SEEDER = 10,
        PIECELENGTH = 11,
        NUMPIECES = 12,
        CONNECTIONS = 13,
        ERRORCODE = 14,
        ERRORMESSAGE = 15,
        FOLLOWEDBY = 16,
        FOLLOWING = 17,
        BELONGSTO = 18,
        DIR = 19,
        FILES = 20,
        BITTORRENT = 21,
        VERIFIEDLENGTH = 22,
        VERIFYINTEGRITYPENDING = 23;

        public string get_name () {
            switch (this) {
                case STATUS:
                    return "status";
                case TOTALLENGTH:
                    return "totalLength";
                case COMPELETEDLENGTH:
                    return "completedLength";
                case UPLOADLENGTH:
                    return "uploadLength";
                case BITFIELD:
                    return "bitfield";
                case DOWNLOADSPEED:
                    return "downloadSpeed";
                case UPLOADSPEED:
                    return "uploadSpeed";
                case INFOHASH:
                    return "infoHash";
                case NUMSEEDERS:
                    return "numSeeders";
                case SEEDER:
                    return "seeder";
                case PIECELENGTH:
                    return "pieceLength";
                case NUMPIECES:
                    return "numPieces";
                case CONNECTIONS:
                    return "connections";
                case ERRORCODE:
                    return "errorCode";
                case ERRORMESSAGE:
                    return "errorMessage";
                case FOLLOWEDBY:
                    return "followedBy";
                case FOLLOWING:
                    return "following";
                case BELONGSTO:
                    return "belongsTo";
                case DIR:
                    return "dir";
                case FILES:
                    return "files";
                case BITTORRENT:
                    return "bittorrent";
                case VERIFIEDLENGTH:
                    return "verifiedLength";
                case VERIFYINTEGRITYPENDING:
                    return "verifyIntegrityPending";
                default:
                    return "gid";
            }
        }
    }

    private enum TellBittorrent {
        ANNOUNCELIST = 0,
        COMMENT = 1,
        CREATIONDATE = 2,
        MODE = 3,
        NAME = 4;

        public string get_name () {
            switch (this) {
                case COMMENT:
                    return "comment";
                case CREATIONDATE:
                    return "creationDate";
                case MODE:
                    return "mode";
                case NAME:
                    return "name";
                default:
                    return "udp";
            }
        }
    }

    private enum LinkMode {
        METALINK = 0,
        TORRENT = 1,
        URL = 2,
        MAGNETLINK = 3
    }

    private enum StatusMode {
        ACTIVE = 0,
        PAUSED = 1,
        COMPLETE = 2,
        WAIT = 3,
        ERROR = 4,
        NOTHING
    }

    private enum AriaOptions {
        ALLOW_OVERWRITE = 0,
        ALLOW_PIECE_LENGTH_CHANGE = 1,
        ALWAYS_RESUME = 2,
        ASYNC_DNS = 3,
        AUTO_FILE_RENAMING = 4,
        BT_ENABLE_HOOK_AFTER_HASH_CHECK = 5,
        BT_ENABLE_LPD = 6,
        BT_FORCE_ENCRYPTION = 7,
        BT_HASH_CHECK_SEED = 8,
        BT_LOAD_SAVED_METADATA = 9,
        BT_MAX_PEERS = 10,
        BT_METADATA_ONLY = 11,
        BT_MIN_CRYPTO_LEVEL = 12,
        BT_REMOVE_UNSELECTED_FILE = 13,
        BT_REQUEST_PEER_SPEED_LIMIT = 14,
        BT_REQUIRE_CRYPTO = 15,
        BT_SAVE_METADATA = 16,
        BT_SEED_UNVERIFIED = 17,
        BT_STOP_TIMEOUT = 18,
        BT_TRACKER_CONNECT_TIMEOUT = 19,
        BT_TRACKER_INTERVAL = 20,
        BT_TRACKER_TIMEOUT = 21,
        CHECK_INTEGRITY = 22,
        CONDITIONAL_GET = 23,
        CONNECT_TIMEOUT = 24,
        CONTENT_DISPOSITION_DEFAULT_UTF8 = 25,
        CONTINUE = 26,
        DIR = 27,
        DRY_RUN = 28,
        ENABLE_HTTP_KEEP_ALIVE = 29,
        ENABLE_HTTP_PIPELINING = 30,
        ENABLE_MMAP = 31,
        ENABLE_PEER_EXCHANGE = 32,
        FILE_ALLOCATION = 33,
        FOLLOW_METALINK = 34,
        FOLLOW_TORRENT = 35,
        FORCE_SAVE = 36,
        FTP_PASV = 37,
        FTP_REUSE_CONNECTION = 38,
        FTP_TYPE = 39,
        HASH_CHECK_ONLY = 40,
        HTTP_ACCEPT_GZIP = 41,
        HTTP_AUTH_CHALLENGE = 42,
        HTTP_NO_CACHE = 43,
        LOWEST_SPEED_LIMIT = 44,
        MAX_CONNECTION_PER_SERVER = 45,
        MAX_DOWNLOAD_LIMIT = 46,
        MAX_FILE_NOT_FOUND = 47,
        MAX_MMAP_LIMIT = 48,
        MAX_RESUME_FAILURE_TRIES = 49,
        MAX_TRIES = 50,
        MAX_UPLOAD_LIMIT = 51,
        METALINK_ENABLE_UNIQUE_PROTOCOL = 52,
        METALINK_PREFERRED_PROTOCOL = 53,
        MIN_SPLIT_SIZE = 54,
        NO_FILE_ALLOCATION_LIMIT = 55,
        NO_NETRC = 56,
        PARAMETERIZED_URI = 57,
        PAUSE_METADATA = 58,
        PIECE_LENGTH = 59,
        PROXY_METHOD = 60,
        REALTIME_CHUNK_CHECKSUM = 61,
        REMOTE_TIME = 62,
        REMOVE_CONTROL_FILE = 63,
        RETRY_WAIT = 64,
        REUSE_URI = 65,
        RPC_SAVE_UPLOAD_METADATA = 66,
        SAVE_NOT_FOUND = 67,
        SEED_RATIO = 68,
        SPLIT = 69,
        STREAM_PIECE_SELECTOR = 70,
        TIMEOUT = 71,
        URI_SELECTOR = 72,
        USE_HEAD = 73,
        USER_AGENT = 74,
        RPC_LISTEN_PORT = 75,
        RPC_MAX_REQUEST_SIZE = 76,
        OUT = 77,
        COOKIE = 78,
        REFERER = 79,
        PROXY = 80,
        PROXYPORT = 81,
        PROXYUSERNAME = 82,
        PROXYPASSWORD = 83,
        USERNAME = 84,
        PASSWORD = 85,
        MAX_CONCURRENT_DOWNLOADS = 86,
        DISK_CACHE = 87,
        BT_MAX_OPEN_FILES = 88,
        SELECT_FILE = 89,
        HEADER = 90,
        SEED_TIME = 91,
        CHECKSUM = 92;

        public string get_name () {
            switch (this) {
                case ALLOW_PIECE_LENGTH_CHANGE:
                    return "allow-piece-length-change";
                case ALWAYS_RESUME:
                    return "always-resume";
                case ASYNC_DNS:
                    return "async-dns";
                case AUTO_FILE_RENAMING:
                    return "auto-file-renaming";
                case BT_ENABLE_HOOK_AFTER_HASH_CHECK:
                    return "bt-enable-hook-after-hash-check";
                case BT_ENABLE_LPD:
                    return "bt-enable-lpd";
                case BT_FORCE_ENCRYPTION:
                    return "bt-force-encryption";
                case BT_HASH_CHECK_SEED:
                    return "bt-hash-check-seed";
                case BT_LOAD_SAVED_METADATA:
                    return "bt-load-saved-metadata";
                case BT_MAX_PEERS:
                    return "bt-max-peers";
                case BT_METADATA_ONLY:
                    return "bt-metadata-only";
                case BT_MIN_CRYPTO_LEVEL:
                    return "bt-min-crypto-level";
                case BT_REMOVE_UNSELECTED_FILE:
                    return "bt-remove-unselected-file";
                case BT_REQUEST_PEER_SPEED_LIMIT:
                    return "bt-request-peer-speed-limit";
                case BT_REQUIRE_CRYPTO:
                    return "bt-require-crypto";
                case BT_SAVE_METADATA:
                    return "bt-save-metadata";
                case BT_SEED_UNVERIFIED:
                    return "bt-seed-unverified";
                case BT_STOP_TIMEOUT:
                    return "bt-stop-timeout";
                case BT_TRACKER_CONNECT_TIMEOUT:
                    return "bt-tracker-connect-timeout";
                case BT_TRACKER_INTERVAL:
                    return "bt-tracker-interval";
                case BT_TRACKER_TIMEOUT:
                    return "bt-tracker-timeout";
                case CHECK_INTEGRITY:
                    return "check-integrity";
                case CONDITIONAL_GET:
                    return "conditional-get";
                case CONNECT_TIMEOUT:
                    return "connect-timeout";
                case CONTENT_DISPOSITION_DEFAULT_UTF8:
                    return "content-disposition-default-utf8";
                case CONTINUE:
                    return "continue";
                case DIR:
                    return "dir";
                case DRY_RUN:
                    return "dry-run";
                case ENABLE_HTTP_KEEP_ALIVE:
                    return "enable-http-keep-alive";
                case ENABLE_HTTP_PIPELINING:
                    return "enable-http-pipelining";
                case ENABLE_MMAP:
                    return "enable-mmap";
                case ENABLE_PEER_EXCHANGE:
                    return "enable-peer-exchange";
                case FILE_ALLOCATION:
                    return "file-allocation";
                case FOLLOW_METALINK:
                    return "follow-metalink";
                case FOLLOW_TORRENT:
                    return "follow-torrent";
                case FORCE_SAVE:
                    return "force-save";
                case FTP_PASV:
                    return "ftp-pasv";
                case FTP_REUSE_CONNECTION:
                    return "ftp-reuse-connection";
                case FTP_TYPE:
                    return "ftp-type";
                case HASH_CHECK_ONLY:
                    return "hash-check-only";
                case HTTP_ACCEPT_GZIP:
                    return "http-accept-gzip";
                case HTTP_AUTH_CHALLENGE:
                    return "http-auth-challenge";
                case HTTP_NO_CACHE:
                    return "http-no-cache";
                case LOWEST_SPEED_LIMIT:
                    return "lowest-speed-limit";
                case MAX_CONNECTION_PER_SERVER:
                    return "max-connection-per-server";
                case MAX_DOWNLOAD_LIMIT:
                    return "max-download-limit";
                case MAX_FILE_NOT_FOUND:
                    return "max-file-not-found";
                case MAX_MMAP_LIMIT:
                    return "max-mmap-limit";
                case MAX_RESUME_FAILURE_TRIES:
                    return "max-resume-failure-tries";
                case MAX_TRIES:
                    return "max-tries";
                case MAX_UPLOAD_LIMIT:
                    return "max-upload-limit";
                case METALINK_ENABLE_UNIQUE_PROTOCOL:
                    return "metalink-enable-unique-protocol";
                case METALINK_PREFERRED_PROTOCOL:
                    return "metalink-preferred-protocol";
                case MIN_SPLIT_SIZE:
                    return "min-split-size";
                case NO_FILE_ALLOCATION_LIMIT:
                    return "no-file-allocation-limit";
                case NO_NETRC:
                    return "no-netrc";
                case PARAMETERIZED_URI:
                    return "parameterized-uri";
                case PAUSE_METADATA:
                    return "pause-metadata";
                case PIECE_LENGTH:
                    return "piece-length";
                case PROXY_METHOD:
                    return "proxy-method";
                case REALTIME_CHUNK_CHECKSUM:
                    return "realtime-chunk-checksum";
                case REMOTE_TIME:
                    return "remote-time";
                case REMOVE_CONTROL_FILE:
                    return "remove-control-file";
                case RETRY_WAIT:
                    return "retry-wait";
                case REUSE_URI:
                    return "reuse-uri";
                case RPC_SAVE_UPLOAD_METADATA:
                    return "rpc-save-upload-metadata";
                case SAVE_NOT_FOUND:
                    return "save-not-found";
                case SEED_RATIO:
                    return "seed-ratio";
                case SPLIT:
                    return "split";
                case STREAM_PIECE_SELECTOR:
                    return "stream-piece-selector";
                case TIMEOUT:
                    return "timeout";
                case URI_SELECTOR:
                    return "uri-selector";
                case USE_HEAD:
                    return "use-head";
                case USER_AGENT:
                    return "user-agent";
                case RPC_LISTEN_PORT:
                    return "rpc-listen-port";
                case RPC_MAX_REQUEST_SIZE:
                    return "rpc-max-request-size";
                case OUT:
                    return "out";
                case COOKIE:
                    return "load-cookies";
                case REFERER:
                    return "referer";
                case PROXY:
                    return "all-proxy";
                case PROXYPORT:
                    return "all-proxy-port";
                case PROXYUSERNAME:
                    return "all-proxy-user";
                case PROXYPASSWORD:
                    return "all-proxy-passwd";
                case USERNAME:
                    return "user";
                case PASSWORD:
                    return "passwd";
                case MAX_CONCURRENT_DOWNLOADS:
                    return "max-concurrent-downloads";
                case DISK_CACHE:
                    return "disk-cache";
                case BT_MAX_OPEN_FILES:
                    return "bt-max-open-files";
                case SELECT_FILE:
                    return "select-file";
                case HEADER:
                    return "header";
                case SEED_TIME:
                    return "seed-time";
                case CHECKSUM:
                    return "checksum";
                default:
                    return "allow-overwrite";
            }
        }
    }

    private string get_aria_error (int mode) {
        switch (mode) {
            case 1:
                return _("an Unknown error");
            case 2:
                return _("Time out");
            case 3:
                return _("a Resource was not found.");
            case 4:
                return _("a Resource was not found");
            case 5:
                return _("Download speed was too slow.");
            case 6:
                return _("Network Problem");
            case 7:
                return _("Terminate by user");
            case 8:
                return _("Not support resume");
            case 9:
                return _("Not enough disk space");
            case 10:
                return _("Different from one in .aria2 control file");
            case 11:
                return _("was Downloading.");
            case 12:
                return _("was Downloading same info hash torrent.");
            case 13:
                return _("Already existed.");
            case 14:
                return _("Renaming file failed.");
            case 15:
                return _("Could not open existing file");
            case 16:
                return _("Could not create new file.");
            case 17:
                return _("File I/O error occurred.");
            case 18:
                return _("Could not create directory.");
            case 19:
                return _("Name resolution failed.");
            case 20:
                return _("Could not parse Metalink document.");
            case 21:
                return _("FTP command failed.");
            case 22:
                return _("HTTP response header was bad or unexpected.");
            case 23:
                return _("Too many redirects  occurred.");
            case 24:
                return _("HTTP authorization failed.");
            case 25:
                return _("Could not parse bencoded file.");
            case 26:
                return _(".torrent file was corrupted.");
            case 27:
                return _("Magnet URI was bad.");
            case 28:
                return _("Bad/unrecognized.");
            case 29:
                return _("The remote server was unable to handle.");
            case 30:
                return _("Could not parse JSON-RPC request.");
            case 31:
                return _("Reserved.  Not used.");
            case 32:
                return _("Checksum validation failed..");
            default:
                return _("All Downloads Were Successful.");
        }
    }

    private enum TorrentPeers {
        PEERID = 0,
        IP = 1,
        PORT = 2,
        BITFIELD = 3,
        AMCHOKING = 4,
        PEERCHOKING = 5;

        public string get_name () {
            switch (this) {
                case IP:
                    return "ip";
                case PORT:
                    return "port";
                case BITFIELD:
                    return "bitfield";
                case AMCHOKING:
                    return "amChoking";
                case PEERCHOKING:
                    return "peerChoking";
                default:
                    return "peerId";
            }
        }
    }

    private enum AriaGetfiles {
        INDEX = 0,
        PATH = 1,
        LENGTH = 2,
        COMPLETEDLENGTH = 3,
        SELECTED = 4,
        URIS = 5;

        public string get_name () {
            switch (this) {
                case PATH:
                    return "path";
                case LENGTH:
                    return "length";
                case COMPLETEDLENGTH:
                    return "completedlength";
                case URIS:
                    return "uris";
                default:
                    return "index";
            }
        }
    }

    private enum DBDownload {
        ID = 0,
        URL = 1,
        STATUS = 2,
        ARIAGID = 3,
        FILEPATH = 4,
        FILENAME = 5,
        TOTALSIZE = 6,
        TRANSFERRATE = 7,
        TRANSFERRED = 8,
        LINKMODE = 9,
        FILEORDIR = 10;

        public string get_name () {
            switch (this) {
                case URL:
                    return "url";
                case STATUS:
                    return "status";
                case ARIAGID:
                    return "ariagid";
                case FILEPATH:
                    return "filepath";
                case FILENAME:
                    return "filename";
                case TOTALSIZE:
                    return "totalsize";
                case TRANSFERRATE:
                    return "transferrate";
                case LINKMODE:
                    return "linkmode";
                case FILEORDIR:
                    return "fileordir";
                default:
                    return "id";
            }
        }
    }

    private enum DBOption {
        ID = 0,
        URL = 1,
        MAGNETBACKUP = 2,
        TORRENTBACKUP = 3,
        PROXY = 4,
        PROXYPORT = 5,
        PROXYUSERNAME = 6,
        PROXYPASSWORD = 7,
        USER = 8,
        USERPASS = 9,
        DIR = 10,
        COOKIE = 11,
        REFERER = 12,
        USERAGENT = 13,
        OUT = 14,
        PROXYMETHOD = 15,
        SELECTFILE = 16,
        CHECKSUM = 17;

        public string get_name () {
            switch (this) {
                case URL:
                    return "url";
                case MAGNETBACKUP:
                    return "magnetbackup";
                case TORRENTBACKUP:
                    return "torrentbackup";
                case PROXY:
                    return "proxy";
                case PROXYPORT:
                    return "port";
                case PROXYUSERNAME:
                    return "username";
                case PROXYPASSWORD:
                    return "usernamepass";
                case USER:
                    return "user";
                case USERPASS:
                    return "userpass";
                case DIR:
                    return "dir";
                case COOKIE:
                    return "cookie";
                case REFERER:
                    return "referer";
                case USERAGENT:
                    return "useragent";
                case OUT:
                    return "OUT";
                case PROXYMETHOD:
                    return "proxymethod";
                case SELECTFILE:
                    return "selectfile";
                case CHECKSUM:
                    return "checksum";
                default:
                    return "id";
            }
        }
    }

    private enum FileCol {
        SELECTED,
        ROW,
        NAME,
        FILEPATH,
        DOWNLOADED,
        SIZE,
        PERCEN,
        URIS,
        N_COLUMNS
    }

    private enum PostServer {
        ALL,
        URL,
        FILENAME,
        REFERRER,
        MIME,
        FILESIZE,
        RESUMABLE,
        URIS,
        N_COLUMNS
    }

    public enum FileAllocations {
        NONE = 0,
        PREALLOC = 1,
        TRUNC = 2,
        FALLOC = 3;

        public string get_name () {
            switch (this) {
                case PREALLOC:
                    return "Prealloc";
                case TRUNC:
                    return "Trunc";
                case FALLOC:
                    return "Falloc";
                default:
                    return "None";
            }
        }

        public static FileAllocations [] get_all () {
            return { NONE, PREALLOC, TRUNC, FALLOC };
        }
    }

    public enum ProxyMethods {
        GET = 0,
        TUNNEL = 1;

        public string get_name () {
            switch (this) {
                case TUNNEL:
                    return "Tunnel";
                default:
                    return "Get";
            }
        }

        public static ProxyMethods [] get_all () {
            return { GET, TUNNEL };
        }
    }

    public enum AriaChecksumTypes {
        NONE = 0,
        MD5 = 1,
        SHA1 = 2,
        SHA256 = 3,
        SHA384 = 4,
        SHA512 = 5;

        public string get_name () {
            switch (this) {
                case MD5:
                    return "md-5=";
                case SHA1:
                    return "sha-1=";
                case SHA256:
                    return "sha-256=";
                case SHA384:
                    return "sha-384=";
                case SHA512:
                    return "sha-512=";
                default:
                    return "none";
            }
        }

        public static AriaChecksumTypes [] get_all () {
            return { NONE, MD5, SHA1, SHA256, SHA384, SHA512 };
        }
    }

    private enum Target {
        STRING,
        URILIST
    }

    private string aria_listent;

    private void setjsonrpchost () {
        aria_listent = @"http://localhost:$(get_dbsetting(DBSettings.RPCPORT))/jsonrpc";
    }

    private string result_ret (string result) {
        try {
            var parser = new Json.Parser ();
            parser.load_from_data (result);
            return parser.get_root ().get_object ().get_string_member ("result");
        } catch (Error e) {
            GLib.warning (e.message);
        }
        return "";
    }

    private string aria_url (string url, Gee.HashMap<string, string> options) {
        var session = new Soup.Session ();
        var message = new Soup.Message ("POST", aria_listent);
        var stringbuild = new StringBuilder ();
        stringbuild.append (@"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.addUri\", \"params\":[[\"$(url)\"],{");
        uint hasempty = stringbuild.str.hash ();
        options.foreach ((value) => {
            if (hasempty != stringbuild.str.hash ()) {
                stringbuild.append (", ");
            }
            stringbuild.append (@"\"$(value.key)\" : \"$(value.value)\"");
            return true;
        });
        stringbuild.append ("}]}");
        message.set_request (Soup.FORM_MIME_TYPE_MULTIPART, Soup.MemoryUse.COPY, stringbuild.data);
        session.send_message (message);
        string result = (string) message.response_body.flatten ().data;
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        return result_ret (result);
    }

    private string aria_torrent (string torr, Gee.HashMap<string, string> options) {
        var session = new Soup.Session ();
        var message = new Soup.Message ("POST", aria_listent);
        var stringbuild = new StringBuilder ();
        stringbuild.append (@"{\"jsonrpc\":\"2.0\", \"id\":\"asdf\", \"method\":\"aria2.addTorrent\", \"params\":[\"$(torr)\", [\"uris\"], {");
        uint hasempty = stringbuild.str.hash ();
        options.foreach ((value) => {
            if (hasempty != stringbuild.str.hash ()) {
                stringbuild.append (", ");
            }
            stringbuild.append (@"\"$(value.key)\" : \"$(value.value)\"");
            return true;
        });
        stringbuild.append ("}]}");
        message.set_request (Soup.FORM_MIME_TYPE_MULTIPART, Soup.MemoryUse.COPY, stringbuild.data);
        session.send_message (message);
        string result = (string) message.response_body.flatten ().data;
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        return result_ret (result);
    }

    private string aria_metalink (string metal, Gee.HashMap<string, string> options) {
        var session = new Soup.Session ();
        var message = new Soup.Message ("POST", aria_listent);
        var stringbuild = new StringBuilder ();
        stringbuild.append (@"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.addMetalink\", \"params\":[[\"$(metal)\"],{");
        uint hasempty = stringbuild.str.hash ();
        options.foreach ((value) => {
            if (hasempty != stringbuild.str.hash ()) {
                stringbuild.append (", ");
            }
            stringbuild.append (@"\"$(value.key)\" : \"$(value.value)\"");
            return true;
        });
        stringbuild.append ("}]}");
        message.set_request (Soup.FORM_MIME_TYPE_MULTIPART, Soup.MemoryUse.COPY, stringbuild.data);
        session.send_message (message);
        string result = (string) message.response_body.flatten ().data;
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        return result_ret (result);
    }

    private string aria_remove (string gid) {
        var session = new Soup.Session ();
        var message = new Soup.Message ("POST", aria_listent);
        var jsonrpc = @"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.forceRemove\", \"params\":[\"$(gid)\"]}";
        message.set_request (Soup.FORM_MIME_TYPE_MULTIPART, Soup.MemoryUse.COPY, jsonrpc.data);
        session.send_message (message);
        string result = (string) message.response_body.flatten ().data;
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        return result_ret (result);
    }

    private string aria_pause (string gid) {
        var session = new Soup.Session ();
        var message = new Soup.Message ("POST", aria_listent);
        var jsonrpc = @"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.forcePause\", \"params\":[\"$(gid)\"]}";
        message.set_request (Soup.FORM_MIME_TYPE_MULTIPART, Soup.MemoryUse.COPY, jsonrpc.data);
        session.send_message (message);
        string result = (string) message.response_body.flatten ().data;
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        return result_ret (result);
    }

    private string aria_pause_all () {
        var session = new Soup.Session ();
        var message = new Soup.Message ("POST", aria_listent);
        var jsonrpc = "{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.pauseAll\"}";
        message.set_request (Soup.FORM_MIME_TYPE_MULTIPART, Soup.MemoryUse.COPY, jsonrpc.data);
        session.send_message (message);
        string result = (string) message.response_body.flatten ().data;
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        return result_ret (result);
    }

    private string aria_purge_all () {
        var session = new Soup.Session ();
        var message = new Soup.Message ("POST", aria_listent);
        var jsonrpc = "{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.purgeDownloadResult\"}";
        message.set_request (Soup.FORM_MIME_TYPE_MULTIPART, Soup.MemoryUse.COPY, jsonrpc.data);
        session.send_message (message);
        string result = (string) message.response_body.flatten ().data;
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        return result_ret (result);
    }

    private string aria_shutdown () {
        var session = new Soup.Session ();
        var message = new Soup.Message ("POST", aria_listent);
        var jsonrpc = "{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.shutdown\"}";
        message.set_request (Soup.FORM_MIME_TYPE_MULTIPART, Soup.MemoryUse.COPY, jsonrpc.data);
        session.send_message (message);
        string result = (string) message.response_body.flatten ().data;
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        return result_ret (result);
    }

    private string aria_unpause (string gid) {
        var session = new Soup.Session ();
        var message = new Soup.Message ("POST", aria_listent);
        var jsonrpc = @"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.unpause\", \"params\":[\"$(gid)\"]}";
        message.set_request (Soup.FORM_MIME_TYPE_MULTIPART, Soup.MemoryUse.COPY, jsonrpc.data);
        session.send_message (message);
        string result = (string) message.response_body.flatten ().data;
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        return result_ret (result);
    }

    private string aria_get_peers (TorrentPeers peers, string gid) {
        var session = new Soup.Session ();
        var message = new Soup.Message ("POST", aria_listent);
        var jsonrpc = @"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.getPeers\", \"params\":[\"$(gid)\"]}";
        message.set_request (Soup.FORM_MIME_TYPE_MULTIPART, Soup.MemoryUse.COPY, jsonrpc.data);
        session.send_message (message);
        string result = (string) message.response_body.flatten ().data;
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        try {
            MatchInfo match_info;
            Regex regex = new Regex (@"\"$(peers.get_name ())\":\"(.*?)\"");
            regex.match_full (result, -1, 0, 0, out match_info);
            string tellpeers = match_info.fetch (1);
            if (tellpeers != null) {
                return tellpeers;
            }
        } catch (Error e) {
            GLib.warning (e.message);
        }
        return "";
    }

    private string aria_tell_status (string gid, TellStatus type) {
        var session = new Soup.Session ();
        var message = new Soup.Message ("POST", aria_listent);
        var jsonrpc = @"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.tellStatus\", \"params\":[\"$(gid)\", [\"$(gid)\", \"$(type.get_name ())\"]]}";
        message.set_request (Soup.FORM_MIME_TYPE_MULTIPART, Soup.MemoryUse.COPY, jsonrpc.data);
        session.send_message (message);
        string result = (string) message.response_body.flatten ().data;
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        try {
            MatchInfo match_info;
            Regex regex = new Regex (@"\"$(type.get_name ())\":\"(.*?)\"");
            regex.match_full (result, -1, 0, 0, out match_info);
            string tellus = match_info.fetch (1);
            if (tellus != null) {
                return tellus;
            }
        } catch (Error e) {
            GLib.warning (e.message);
        }
        return "";
    }

    private string aria_tell_bittorent (string gid, TellBittorrent tellbit) {
        var session = new Soup.Session ();
        var message = new Soup.Message ("POST", aria_listent);
        var jsonrpc = @"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.tellStatus\", \"params\":[\"$(gid)\", [\"$(gid)\", \"bittorrent\"]]}";
        message.set_request (Soup.FORM_MIME_TYPE_MULTIPART, Soup.MemoryUse.COPY, jsonrpc.data);
        session.send_message (message);
        string result = (string) message.response_body.flatten ().data;
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        try {
            MatchInfo match_info;
            if (tellbit == TellBittorrent.ANNOUNCELIST) {
                Regex regex = new Regex (@"$(tellbit.get_name ()):(.*?)\"");
                regex.match_full (result, -1, 0, 0, out match_info);
                string liststring = "";
                while (match_info.matches ()) {
                    string matchgid = match_info.fetch (0);
                    if (matchgid != null) {
                        liststring += matchgid.replace ("\\/", "/").replace ("\"", "") + "+";
                    }
                    match_info.next ();
                }
                return liststring;
            } else if (tellbit == TellBittorrent.CREATIONDATE) {
                Regex regex = new Regex (@"\"$(tellbit.get_name ())\":([0-9]+)");
                regex.match_full (result, -1, 0, 0, out match_info);
                string namefile = match_info.fetch (1);
                if (namefile != null) {
                    return namefile;
                }
            } else if (tellbit == TellBittorrent.MODE || tellbit == TellBittorrent.COMMENT || tellbit == TellBittorrent.NAME) {
                Regex regex = new Regex (@"\"$(tellbit.get_name ())\":\"(.*?)\"");
                regex.match_full (result, -1, 0, 0, out match_info);
                string namefile = match_info.fetch (1);
                if (namefile != null) {
                    return namefile;
                }
            }
        } catch (Error e) {
            GLib.warning (e.message);
        }
        return "";
    }

    private GLib.List<string> aria_tell_active () {
        var listgid = new GLib.List<string> ();
        var session = new Soup.Session ();
        var message = new Soup.Message ("POST", aria_listent);
        var jsonrpc = "{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.tellActive\"}";
        message.set_request (Soup.FORM_MIME_TYPE_MULTIPART, Soup.MemoryUse.COPY, jsonrpc.data);
        session.send_message (message);
        string result = (string) message.response_body.flatten ().data;
        if (!result.down ().contains ("result") || result == null) {
            return listgid;
        }
        try {
            MatchInfo match_info;
            Regex regex = new Regex ("\"gid\":\"(.*?)\"");
            regex.match_full (result, -1, 0, 0, out match_info);
            while (match_info.matches ()) {
                string matchgid = match_info.fetch (1);
                if (matchgid != null) {
                    listgid.append (matchgid);
                }
                match_info.next ();
            }
        } catch (Error e) {
            GLib.warning (e.message);
        }
        return listgid;
    }

    private string aria_str_files (AriaGetfiles files, string gid) {
        var session = new Soup.Session ();
        var message = new Soup.Message ("POST", aria_listent);
        var jsonrpc = @"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.getFiles\", \"params\":[\"$(gid)\"]}";
        message.set_request (Soup.FORM_MIME_TYPE_MULTIPART, Soup.MemoryUse.COPY, jsonrpc.data);
        session.send_message (message);
        string result = (string) message.response_body.flatten ().data;
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        try {
            MatchInfo match_info;
            if (files != AriaGetfiles.PATH) {
                Regex regex = new Regex (@"\"$(files.get_name ())\":\"(.*?)\"");
                regex.match_full (result, -1, 0, 0, out match_info);
                return match_info.fetch (1);
            } else {
                Regex regex = new Regex (@"\"$(files.get_name ())\":\"(.*?)\"");
                regex.match_full (result, -1, 0, 0, out match_info);
                return match_info.fetch (1).replace ("\\/", "/");
            }
        } catch (Error e) {
            GLib.warning (e.message);
        }
        return "";
    }

    private Gtk.ListStore aria_files_store (string gid) {
        var liststore = new Gtk.ListStore (FileCol.N_COLUMNS, typeof (bool), typeof (string), typeof (string), typeof (string), typeof (string), typeof (string), typeof (int), typeof (string));
        var session = new Soup.Session ();
        var message = new Soup.Message ("POST", aria_listent);
        var jsonrpc = @"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.getFiles\", \"params\":[\"$(gid)\"]}";
        message.set_request (Soup.FORM_MIME_TYPE_MULTIPART, Soup.MemoryUse.COPY, jsonrpc.data);
        session.send_message (message);
        string result = (string) message.response_body.flatten ().data;
        if (!result.down ().contains ("result") || result == null) {
            return liststore;
        }
        string regexstr = "{\"completedLength\":\"(.*?)\".*?\"index\":\"(.*?)\".*?\"length\":\"(.*?)\".*?\"path\":\"(.*?)\".*?\"selected\":\"(.*?)\".*?\"uris\":(.*?)}";
        if (Regex.match_simple (regexstr, result)) {
            try {
                MatchInfo match_info;
                Regex regex = new Regex (regexstr);
                regex.match_full (result, -1, 0, 0, out match_info);
                while (match_info.matches ()) {
                    int64 total = int64.parse (match_info.fetch (3)).abs ();
                    int64 transfer = int64.parse (match_info.fetch (1)).abs ();
                    double fraction = (double) transfer / (double) total;
                    int persen = total == 0 && transfer == 0? 0 : (int) (fraction * 100).abs ();
                    string uris = match_info.fetch (6);
                    string path = match_info.fetch (4);
                    Gtk.TreeIter iter;
                    var file = File.new_for_path (path.contains ("\\/")? path.replace ("\\/", "/") : path);
                    liststore.append (out iter);
                    liststore.set (iter, FileCol.SELECTED, bool.parse (match_info.fetch (5)), FileCol.ROW, match_info.fetch (2), FileCol.NAME, file.get_basename (), FileCol.FILEPATH, file.get_path (), FileCol.DOWNLOADED, format_size (transfer), FileCol.SIZE, format_size (total), FileCol.PERCEN, persen, FileCol.URIS, uris.contains ("\\/")? uris.replace ("\\/", "/") : uris);
                    match_info.next ();
                }
            } catch (Error e) {
                GLib.warning (e.message);
            }
        }
        return liststore;
    }

    private string aria_get_option (string gid, AriaOptions option) {
        var session = new Soup.Session ();
        var message = new Soup.Message ("POST", aria_listent);
        var jsonrpc = @"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.getOption\", \"params\":[\"$(gid)\"]}";
        message.set_request (Soup.FORM_MIME_TYPE_MULTIPART, Soup.MemoryUse.COPY, jsonrpc.data);
        session.send_message (message);
        string result = (string) message.response_body.flatten ().data;
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        try {
            MatchInfo match_info;
            Regex regex = new Regex (@"\"$(option.get_name ())\":\"(.*?)\"");
            regex.match_full (result, -1, 0, 0, out match_info);
            return match_info.fetch (1);
        } catch (Error e) {
            GLib.warning (e.message);
        }
        return "";
    }

    private string aria_set_option (string gid, AriaOptions option, string value) {
        var session = new Soup.Session ();
        var message = new Soup.Message ("POST", aria_listent);
        var jsonrpc = @"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.changeOption\", \"params\":[\"$(gid)\", {\"$(option.get_name ())\":\"$(value)\"}]}";
        message.set_request (Soup.FORM_MIME_TYPE_MULTIPART, Soup.MemoryUse.COPY, jsonrpc.data);
        session.send_message (message);
        string result = (string) message.response_body.flatten ().data;
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        return result_ret (result);
    }

    private string aria_get_globalops (AriaOptions option) {
        var session = new Soup.Session ();
        var message = new Soup.Message ("POST", aria_listent);
        var jsonrpc = "{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.getGlobalOption\"}";
        message.set_request (Soup.FORM_MIME_TYPE_MULTIPART, Soup.MemoryUse.COPY, jsonrpc.data);
        session.send_message (message);
        string result = (string) message.response_body.flatten ().data;
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        try {
            MatchInfo match_info;
            Regex regex = new Regex (@"\"$(option.get_name ())\":\"(.*?)\"");
            regex.match_full (result, -1, 0, 0, out match_info);
            return match_info.fetch (1);
        } catch (Error e) {
            GLib.warning (e.message);
        }
        return "";
    }

    private string aria_set_globalops (AriaOptions option, string value) {
        var session = new Soup.Session ();
        var message = new Soup.Message ("POST", aria_listent);
        var jsonrpc = @"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.changeGlobalOption\", \"params\":[{\"$(option.get_name ())\":\"$(value)\"}]}";
        message.set_request (Soup.FORM_MIME_TYPE_MULTIPART, Soup.MemoryUse.COPY, jsonrpc.data);
        session.send_message (message);
        string result = (string) message.response_body.flatten ().data;
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        return result_ret (result);
    }

    private string aria_deleteresult (string gid) {
        var session = new Soup.Session ();
        var message = new Soup.Message ("POST", aria_listent);
        var jsonrpc = @"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.removeDownloadResult\", \"params\":[\"$(gid)\"]}";
        message.set_request (Soup.FORM_MIME_TYPE_MULTIPART, Soup.MemoryUse.COPY, jsonrpc.data);
        session.send_message (message);
        string result = (string) message.response_body.flatten ().data;
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        return result_ret (result);
    }

    private string aria_geturis (string gid) {
        var session = new Soup.Session ();
        var message = new Soup.Message ("POST", aria_listent);
        var jsonrpc = @"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.getUris\", \"params\":[\"$(gid)\"]}";
        message.set_request (Soup.FORM_MIME_TYPE_MULTIPART, Soup.MemoryUse.COPY, jsonrpc.data);
        session.send_message (message);
        string result = (string) message.response_body.flatten ().data;
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        try {
            MatchInfo match_info;
            Regex regex = new Regex ("\"uri\":\"(.*?)\"");
            regex.match_full (result, -1, 0, 0, out match_info);
            string statusuris = match_info.fetch (1);
            if (statusuris != null) {
                return statusuris.replace ("\\/", "/");
            }
        } catch (Error e) {
            GLib.warning (e.message);
        }
        return "";
    }

    private bool aria_getverion () {
        var session = new Soup.Session ();
        var message = new Soup.Message ("POST", aria_listent);
        var jsonrpc = "{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.getVersion\"}";
        message.set_request (Soup.FORM_MIME_TYPE_MULTIPART, Soup.MemoryUse.COPY, jsonrpc.data);
        session.send_message (message);
        string result = (string) message.response_body.flatten ().data;
        return result.down ().contains ("result");
    }

    private async void open_fileman (string fileuri) throws Error {
        yield AppInfo.launch_default_for_uri_async (fileuri, null);
    }

    private string data_bencoder (GLib.Bytes byte) {
        return Base64.encode (byte.get_data ());
    }

    private int max_exec = 1000;
    private void exec_aria () {
        setjsonrpchost ();
        int start_exec = 0;
        do {
            if (start_exec < max_exec) {
                ensure_run.begin ();
            }
            start_exec++;
        } while (!aria_getverion () && start_exec < max_exec);
        if (aria_getverion ()) {
            set_startup ();
        }
    }

    private async void ensure_run () throws Error {
        SourceFunc callback = ensure_run.callback;
        string rpcport = get_dbsetting (DBSettings.RPCPORT);
        string size_req = get_dbsetting (DBSettings.RPCSIZE);
        string cache = get_dbsetting (DBSettings.DISKCACHE);
        string allocate = get_dbsetting (DBSettings.FILEALLOCATION);
        string[] exec = {"aria2c", "--no-conf", "--enable-rpc", @"--rpc-listen-port=$(rpcport)", @"--rpc-max-request-size=$(size_req)", @"--disk-cache=$(cache)", @"--file-allocation=$(allocate.down ())", "--quiet=true"};
        GLib.SubprocessFlags flags = GLib.SubprocessFlags.STDIN_INHERIT | GLib.SubprocessFlags.STDOUT_SILENCE | GLib.SubprocessFlags.STDERR_MERGE;
        GLib.Subprocess subprocess = new GLib.Subprocess.newv (exec, flags);
        if (yield subprocess.wait_check_async ()) {
            if (subprocess.get_successful ()) {
                if (callback != null) {
                    subprocess.force_exit ();
                    Idle.add ((owned)callback);
                }
            }
        }
        yield;
    }

    private void set_startup () {
        do {
            aria_set_globalops (AriaOptions.MAX_TRIES, get_dbsetting (DBSettings.MAXTRIES));
        } while (get_dbsetting (DBSettings.MAXTRIES) != aria_get_globalops (AriaOptions.MAX_TRIES));
        do {
            aria_set_globalops (AriaOptions.MAX_CONNECTION_PER_SERVER, get_dbsetting (DBSettings.CONNSERVER));
        } while (get_dbsetting (DBSettings.CONNSERVER) != aria_get_globalops (AriaOptions.MAX_CONNECTION_PER_SERVER));
        do {
            aria_set_globalops (AriaOptions.TIMEOUT, get_dbsetting (DBSettings.TIMEOUT));
        } while (get_dbsetting (DBSettings.TIMEOUT) != aria_get_globalops (AriaOptions.TIMEOUT));
        do {
            aria_set_globalops (AriaOptions.RETRY_WAIT, get_dbsetting (DBSettings.RETRY));
        } while (get_dbsetting (DBSettings.RETRY) != aria_get_globalops (AriaOptions.RETRY_WAIT));
        do {
            aria_set_globalops (AriaOptions.DIR, get_dbsetting (DBSettings.DIR));
        } while (get_dbsetting (DBSettings.DIR) != aria_get_globalops (AriaOptions.DIR));
        do {
            aria_set_globalops (AriaOptions.BT_MAX_PEERS, get_dbsetting (DBSettings.BTMAXPEERS));
        } while (get_dbsetting (DBSettings.BTMAXPEERS) != aria_get_globalops (AriaOptions.BT_MAX_PEERS));
        do {
            aria_set_globalops (AriaOptions.BT_TRACKER_TIMEOUT, get_dbsetting (DBSettings.BTTIMEOUTTRACK));
        } while (get_dbsetting (DBSettings.BTTIMEOUTTRACK) != aria_get_globalops (AriaOptions.BT_TRACKER_TIMEOUT));
        do {
            aria_set_globalops (AriaOptions.MAX_CONCURRENT_DOWNLOADS, get_dbsetting (DBSettings.MAXACTIVE));
        } while (get_dbsetting (DBSettings.MAXACTIVE) != aria_get_globalops (AriaOptions.MAX_CONCURRENT_DOWNLOADS));
        do {
            aria_set_globalops (AriaOptions.SPLIT, get_dbsetting (DBSettings.SPLIT));
        } while (get_dbsetting (DBSettings.SPLIT) != aria_get_globalops (AriaOptions.SPLIT));
        do {
            aria_set_globalops (AriaOptions.BT_MAX_OPEN_FILES, get_dbsetting (DBSettings.MAXOPENFILE));
        } while (get_dbsetting (DBSettings.MAXOPENFILE) != aria_get_globalops (AriaOptions.BT_MAX_OPEN_FILES));
        do {
            aria_set_globalops (AriaOptions.SEED_TIME, get_dbsetting (DBSettings.SEEDTIME));
        } while (get_dbsetting (DBSettings.SEEDTIME) != aria_get_globalops (AriaOptions.SEED_TIME));
        do {
            aria_set_globalops (AriaOptions.ALLOW_OVERWRITE, get_dbsetting (DBSettings.OVERWRITE));
        } while (get_dbsetting (DBSettings.OVERWRITE) != aria_get_globalops (AriaOptions.ALLOW_OVERWRITE));
        do {
            aria_set_globalops (AriaOptions.AUTO_FILE_RENAMING, get_dbsetting (DBSettings.AUTORENAMING));
        } while (get_dbsetting (DBSettings.AUTORENAMING) != aria_get_globalops (AriaOptions.AUTO_FILE_RENAMING));
    }

    private async void get_css_online (string url, string filename) throws Error {
        SourceFunc callback = get_css_online.callback;
        var session = new Soup.Session ();
        var msg = new Soup.Message ("GET", url);
        session.send_message (msg);
        session.queue_message (msg, (sess, mess) => {
            if (mess.status_code == 200) {
                try {
                    var file = File.new_for_path (filename);
                    FileOutputStream out_stream = file.create (FileCreateFlags.REPLACE_DESTINATION);
                    out_stream.write (mess.response_body.flatten ().data);
                } catch (Error e) {
                    GLib.warning (e.message);
                }
            }
            if (callback != null) {
                Idle.add ((owned)callback);
            }
        });
        yield;
    }

    private string format_time (int seconds) {
        if (seconds < 0) {
            seconds = 0;
        }
        if (seconds < 60) {
            return ngettext ("%'d second", "%'d seconds left", seconds).printf (seconds);
        }
        int minutes;
        if (seconds < 60 * 60) {
            minutes = (seconds + 30) / 60;
            return ngettext ("%'d minute", "%'d minutes left", minutes).printf (minutes);
        }
        int hours = seconds / (60 * 60);
        if (seconds < 60 * 60 * 4) {
            minutes = (seconds - hours * 60 * 60 + 30) / 60;
            string h = ngettext ("%'u hour", "%'u hours left", hours).printf (hours);
            string m = ngettext ("%'u minute", "%'u minutes left", minutes).printf (minutes);
            return h.concat (", ", m);
        }
        return ngettext ("approximately %'d hour", "approximately %'d hours  left", hours).printf (hours);
    }

    private async void set_badge (int64 count) throws GLib.Error {
        unowned UnityLauncherEntry instance = yield UnityLauncherEntry.get_instance ();
        instance.set_app_property ("count", new GLib.Variant.int64 (count));
    }

    private async void set_badge_visible (bool visible) throws GLib.Error {
        unowned UnityLauncherEntry instance = yield UnityLauncherEntry.get_instance ();
        instance.set_app_property ("count-visible", new GLib.Variant.boolean (visible));
    }
    private async void set_progress (double progress) throws GLib.Error {
        unowned UnityLauncherEntry instance = yield UnityLauncherEntry.get_instance ();
        instance.set_app_property ("progress", new GLib.Variant.double (progress));
    }

    private async void set_progress_visible (bool visible) throws GLib.Error {
        unowned UnityLauncherEntry instance = yield UnityLauncherEntry.get_instance ();
        instance.set_app_property ("progress-visible", new GLib.Variant.boolean (visible));
    }
    private string get_mime_type (File fileinput) {
        if (!fileinput.query_exists ()) {
            return "";
        }
        try {
            FileInfo infos = fileinput.query_info ("standard::*", 0);
            return infos.get_content_type ();
        } catch (Error e) {
            GLib.warning (e.message);
        }
        return "";
    }
    private string get_css (string cssloc) {
        try {
            var file = File.new_for_path (cssloc);
            return (string) file.load_bytes ().get_data ();
        } catch (Error eror) {
            warning ("%s\n", eror.message);
        }
        return "";
    }

    private static string config_folder (string folder) {
        var config_dir = File.new_for_path (GLib.Path.build_path (GLib.Path.DIR_SEPARATOR_S, Environment.get_user_config_dir (), folder));
        if (!config_dir.query_exists ()) {
            try {
                config_dir.make_directory_with_parents ();
            } catch (Error e) {
                warning (e.message);
            }
        }
        return config_dir.get_path ();
    }

    private static File file_start () {
        return File.new_for_path (Path.build_filename (config_folder ("autostart"), Environment.get_application_name () + ".desktop"));
    }
    private async void create_startup () throws Error {
        File file = file_start ();
        if (file.query_exists ()) {
            file.delete ();
        }
        FileOutputStream outstartup = file.create (FileCreateFlags.REPLACE_DESTINATION);
        yield outstartup.write_async ("[Desktop Entry]\n".data);
        yield outstartup.write_async ("Type=Application\n".data);
        yield outstartup.write_async ("Name=Autostart Gabut Download Manager\n".data);
        yield outstartup.write_async ("Comment=Simple and Faster Download Manager\n".data);
        yield outstartup.write_async ("X-GNOME-Autostart-enabled=true\n".data);
        yield outstartup.write_async ("Terminal=false\n".data);
        yield outstartup.write_async ("Categories=Network;P2P;FileTransfer;\n".data);
        yield outstartup.write_async ("NoDisplay=true\n".data);
        yield outstartup.write_async ("Icon=com.github.gabutakut.gabutdm\n".data);
        if (file.get_path ().contains (".var")) {
            yield outstartup.write_async ("Exec=/usr/bin/flatpak run --branch=master --arch=x86_64 --command=com.github.gabutakut.gabutdm --file-forwarding com.github.gabutakut.gabutdm @@u --startingup @@\n".data);
            yield outstartup.write_async ("X-Flatpak=com.github.gabutakut.gabutdm\n".data);
        } else {
            yield outstartup.write_async ("Exec=com.github.gabutakut.gabutdm --startingup\n".data);
        }
    }

    private static string create_folder (string name) {
        return GLib.Path.build_filename (config_folder (Environment.get_application_name ()), Environment.get_application_name () + name);
    }

    private void notify_app (string message, string msg_bd, GLib.Icon iconimg) {
        if (!bool.parse (get_dbsetting (DBSettings.SYSTEMNOTIF))) {
            return;
        }
        var notification = new GLib.Notification (Environment.get_application_name ());
        notification.set_priority (GLib.NotificationPriority.NORMAL);
        notification.set_icon (iconimg);
        notification.set_title (message);
        notification.set_body (msg_bd);
        GabutApp.gabutwindow.application.send_notification (Environment.get_application_name (), notification);
    }

    private void move_widget (Gtk.Widget widget) {
        bool mouse_primary_down = false;
        widget.motion_notify_event.connect ((event) => {
            if (mouse_primary_down) {
                mouse_primary_down = false;
                ((Gtk.Window) widget.get_toplevel ()).begin_move_drag (Gdk.BUTTON_PRIMARY, (int)event.x_root, (int)event.y_root, event.time);
            }
            return false;
        });
        widget.button_press_event.connect ((event) => {
            if (event.button == Gdk.BUTTON_PRIMARY) {
                mouse_primary_down = true;
            }
            return Gdk.EVENT_PROPAGATE;
        });
        widget.button_release_event.connect ((event) => {
            if (event.button == Gdk.BUTTON_PRIMARY) {
                mouse_primary_down = false;
            }
            return false;
        });
    }
    private string set_dollar (string dollar) {
        return "$%s".printf (dollar);
    }

    private File[] run_open_file (Gtk.Window window, bool multi) {
        var filechooser = new Gtk.FileChooserNative (_("Open"), window, Gtk.FileChooserAction.OPEN, _("Open"), _("Cancel"));
        filechooser.select_multiple = multi;

        var torrent = new Gtk.FileFilter ();
        torrent.set_filter_name (_("Torrent"));
        torrent.add_mime_type ("application/x-bittorrent");
        var metalink = new Gtk.FileFilter ();
        metalink.set_filter_name (_("Metalink"));
        metalink.add_pattern ("application/metalink+xml");

        filechooser.add_filter (torrent);
        filechooser.add_filter (metalink);

        File[] files = null;
        if (filechooser.run () == Gtk.ResponseType.ACCEPT) {
            foreach (File item in filechooser.get_files ()) {
                files += item;
            }
        }
        filechooser.destroy ();
        return files;
    }

    private int open_database (out Sqlite.Database db) {
        int opendb = 0;
        if (!File.new_for_path (create_folder (".db")).query_exists ()) {
            opendb = creat_no_exist (out db);
        } else {
            opendb = Sqlite.Database.open (create_folder (".db"), out db);
        }
        return opendb;
    }

    private int creat_no_exist (out Sqlite.Database db) {
        int opendb = Sqlite.Database.open (create_folder (".db"), out db);
        if (opendb != Sqlite.OK) {
            warning ("Can't open database: %s\n", db.errmsg ());
        }
        opendb = table_download (db);
        opendb = table_options (db);
        opendb = table_settings (db);
        return opendb;
    }

    private int table_download (Sqlite.Database db) {
        return db.exec ("CREATE TABLE IF NOT EXISTS download (
            id             INTEGER PRIMARY KEY AUTOINCREMENT,
            url            TEXT    NOT NULL,
            status         INT     NOT NULL,
            ariagid        TEXT    NOT NULL,
            filepath       TEXT    NOT NULL,
            filename       TEXT    NOT NULL,
            totalsize      INT64   NOT NULL,
            transferrate   INT     NOT NULL,
            transferred    INT64   NOT NULL,
            linkmode       INT     NOT NULL,
            fileordir      TEXT    NOT NULL);");
    }

    private int table_options (Sqlite.Database db) {
        return db.exec ("CREATE TABLE IF NOT EXISTS options (
            id             INTEGER PRIMARY KEY AUTOINCREMENT,
            url            TEXT    NOT NULL,
            magnetbackup   TEXT    NOT NULL,
            torrentbackup  TEXT    NOT NULL,
            proxy          TEXT    NOT NULL,
            port           TEXT    NOT NULL,
            username       TEXT    NOT NULL,
            usernamepass   TEXT    NOT NULL,
            user           TEXT    NOT NULL,
            userpass       TEXT    NOT NULL,
            dir            TEXT    NOT NULL,
            cookie         TEXT    NOT NULL,
            referer        TEXT    NOT NULL,
            useragent      TEXT    NOT NULL,
            out            TEXT    NOT NULL,
            proxymethod    TEXT    NOT NULL,
            selectfile     TEXT    NOT NULL,
            checksum       TEXT    NOT NULL);");
    }

    private int table_settings (Sqlite.Database db) {
        string dir = Environment.get_user_special_dir (GLib.UserDirectory.DOWNLOAD).replace ("/", "\\/");
        return db.exec (@"CREATE TABLE IF NOT EXISTS settings (
            id             INTEGER PRIMARY KEY AUTOINCREMENT,
            rpcport        TEXT    NOT NULL,
            maxtries       TEXT    NOT NULL,
            connserver     TEXT    NOT NULL,
            timeout        TEXT    NOT NULL,
            dir            TEXT    NOT NULL,
            retry          TEXT    NOT NULL,
            rpcsize        TEXT    NOT NULL,
            btmaxpeers     TEXT    NOT NULL,
            diskcache      TEXT    NOT NULL,
            maxactive      TEXT    NOT NULL,
            bttimeouttrack TEXT    NOT NULL,
            split          TEXT    NOT NULL,
            maxopenfile    TEXT    NOT NULL,
            dialognotif    TEXT    NOT NULL,
            systemnotif    TEXT    NOT NULL,
            onbackground   TEXT    NOT NULL,
            iplocal        TEXT    NOT NULL,
            portlocal      TEXT    NOT NULL,
            seedtime       TEXT    NOT NULL,
            overwrite      TEXT    NOT NULL,
            autorenaming   TEXT    NOT NULL,
            allocation     TEXT    NOT NULL,
            startup        TEXT    NOT NULL);
            INSERT INTO settings (id, rpcport, maxtries, connserver, timeout, dir, retry, rpcsize, btmaxpeers, diskcache, maxactive, bttimeouttrack, split, maxopenfile, dialognotif, systemnotif, onbackground, iplocal, portlocal, seedtime, overwrite, autorenaming, allocation, startup)
            VALUES (1, \"6807\", \"5\", \"6\", \"60\", \"$(dir)\", \"0\", \"2097152\", \"55\", \"16777216\", \"5\", \"60\", \"5\", \"100\", \"true\", \"true\", \"true\", \"true\", \"2021\", \"0\", \"false\", \"false\", \"None\", \"true\");");
    }

    private void check_table () {
        if ((db_table ("settings") - 1) != DBSettings.STARTUP) {
            if (db_table ("settings") > 0) {
                GabutApp.db.exec ("DROP TABLE settings;");
            }
            table_settings (GabutApp.db);
        }
    }

    private void check_optdown () {
        if ((db_table ("download") - 1) != DBDownload.FILEORDIR) {
            if (db_table ("download") > 0) {
                GabutApp.db.exec ("DROP TABLE download;");
            }
            table_download (GabutApp.db);
        }
        if ((db_table ("options") - 1) != DBOption.CHECKSUM) {
            if (db_table ("options") > 0) {
                GabutApp.db.exec ("DROP TABLE options;");
            }
            table_options (GabutApp.db);
        }
    }

    private int db_table (string opt) {
        int ncols;
        string errmsg;
        int res = GabutApp.db.get_table (@"SELECT * FROM $(opt)", null, null, out ncols, out errmsg);
        if (res != Sqlite.OK) {
            warning ("Error: %s", errmsg);
        }
        return ncols;
    }

    private string get_dbsetting (DBSettings type) {
        Sqlite.Statement stmt;
        int res = GabutApp.db.prepare_v2 ("SELECT * FROM settings WHERE id = ?", -1, out stmt);
        stmt.bind_int (1, 1);
        if ((res = stmt.step ()) == Sqlite.ROW) {
            return stmt.column_text (type);
        }
        return "";
    }

    private string set_dbsetting (DBSettings type, string value) {
        Sqlite.Statement stmt;
        string sql = @"UPDATE settings SET $(type.get_name ()) = \"$(value)\" WHERE id = ?";
        int res = GabutApp.db.prepare_v2 (sql, -1, out stmt);
        res = stmt.bind_int (1, 1);
        if ((res = stmt.step ()) != Sqlite.DONE) {
            warning ("Error: %d: %s", GabutApp.db.errcode (), GabutApp.db.errmsg ());
        }
        stmt.reset ();
        return value;
    }

    private void set_download (GLib.List<DownloadRow> downloads) {
        downloads.foreach ((download)=> {
            if (db_download_exist (download.url)) {
                update_download (download);
                return;
            }
            Sqlite.Statement stmt;
            string sql = "INSERT OR IGNORE INTO download (url, status, ariagid, filepath, filename, totalsize, transferrate, transferred, linkmode, fileordir) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
            int res = GabutApp.db.prepare_v2 (sql, -1, out stmt);
            res = stmt.bind_text (DBDownload.URL, download.url);
            res = stmt.bind_int (DBDownload.STATUS, download.status);
            res = stmt.bind_text (DBDownload.ARIAGID, download.ariagid);
            res = stmt.bind_text (DBDownload.FILEPATH, download.filepath);
            res = stmt.bind_text (DBDownload.FILENAME, download.filename);
            res = stmt.bind_int64 (DBDownload.TOTALSIZE, download.totalsize);
            res = stmt.bind_int (DBDownload.TRANSFERRATE, download.transferrate);
            res = stmt.bind_int64 (DBDownload.TRANSFERRED, download.transferred);
            res = stmt.bind_int (DBDownload.LINKMODE, download.linkmode);
            res = stmt.bind_text (DBDownload.FILEORDIR, download.fileordir == null? "" : download.fileordir);
            if ((res = stmt.step ()) != Sqlite.DONE) {
                warning ("Error: %d: %s", GabutApp.db.errcode (), GabutApp.db.errmsg ());
            }
            stmt.reset ();
        });
    }

    private void update_download (DownloadRow download) {
        Sqlite.Statement stmt;
        var buildstr = new StringBuilder ();
        buildstr.append ("UPDATE download SET");
        uint empty_hash = buildstr.str.hash ();
        int res = GabutApp.db.prepare_v2 ("SELECT * FROM download WHERE url = ?", -1, out stmt);
        res = stmt.bind_text (1, download.url);
        if ((res = stmt.step ()) == Sqlite.ROW) {
            if (stmt.column_int (DBDownload.STATUS) != download.status) {
                buildstr.append (@" $(DBDownload.STATUS.get_name ()) = $(download.status)");
            }
            if (stmt.column_text (DBDownload.ARIAGID) != download.ariagid) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                buildstr.append (@" $(DBDownload.ARIAGID.get_name ()) = \"$(download.ariagid)\"");
            }
            if (stmt.column_text (DBDownload.FILEPATH) != download.filepath) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                buildstr.append (@" $(DBDownload.FILEPATH.get_name ()) = \"$(download.filepath)\"");
            }
            if (stmt.column_text (DBDownload.FILENAME) != download.filename) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                buildstr.append (@" $(DBDownload.FILENAME.get_name ()) = \"$(download.filename)\"");
            }
            if (stmt.column_int (DBDownload.TOTALSIZE) != download.totalsize) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                buildstr.append (@" $(DBDownload.TOTALSIZE.get_name ()) = $(download.totalsize)");
            }
            if (stmt.column_int (DBDownload.TRANSFERRATE) != download.transferrate) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                buildstr.append (@" $(DBDownload.TRANSFERRATE.get_name ()) = $(download.transferrate)");
            }
            if (stmt.column_int (DBDownload.TRANSFERRED) != download.transferred) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                buildstr.append (@" $(DBDownload.TRANSFERRED.get_name ()) = $(download.transferred)");
            }
            if (stmt.column_int (DBDownload.LINKMODE) != download.linkmode) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                buildstr.append (@" $(DBDownload.LINKMODE.get_name ()) = $(download.linkmode)");
            }
            if (stmt.column_text (DBDownload.FILEORDIR) != download.fileordir) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                buildstr.append (@" $(DBDownload.FILEORDIR.get_name ()) = \"$(download.fileordir)\"");
            }
            if (buildstr.str.hash () == empty_hash) {
                return;
            }
        }
        buildstr.append (" WHERE url = ?");
        res = GabutApp.db.prepare_v2 (buildstr.str, -1, out stmt);
        res = stmt.bind_text (1, download.url);
        if ((res = stmt.step ()) != Sqlite.DONE) {
            warning ("Error: %d: %s", GabutApp.db.errcode (), GabutApp.db.errmsg ());
        }
        stmt.reset ();
    }

    private void remove_download (string url) {
        Sqlite.Statement stmt;
        string sql = "DELETE FROM download WHERE url = ?";
        int res = GabutApp.db.prepare_v2 (sql, -1, out stmt);
        res = stmt.bind_text (1, url);
        if ((res = stmt.step ()) != Sqlite.DONE) {
            warning ("Error: %d: %s", GabutApp.db.errcode (), GabutApp.db.errmsg ());
        }
        stmt.reset ();
    }

    private GLib.List<DownloadRow> get_download () {
        var downloads = new GLib.List<DownloadRow> ();
        Sqlite.Statement stmt;
        int res = GabutApp.db.prepare_v2 ("SELECT id, url, status, ariagid, filepath, filename, totalsize, transferrate, transferred, linkmode, fileordir FROM download ORDER BY url;", -1, out stmt);
        if (res != Sqlite.OK) {
            warning ("Error: %d: %s", GabutApp.db.errcode (), GabutApp.db.errmsg ());
        }
        while (stmt.step () == Sqlite.ROW) {
            downloads.append (new DownloadRow (stmt));
        }
        stmt.reset ();
        return downloads;
    }

    private bool db_download_exist (string url) {
        Sqlite.Statement stmt;
        string sql = "SELECT * FROM download WHERE url = ?";
        int res = GabutApp.db.prepare_v2 (sql, -1, out stmt);
        res = stmt.bind_text (1, url);
        if ((res = stmt.step ()) == Sqlite.ROW) {
            return true;
        }
        stmt.reset ();
        return false;
    }

    private Gee.HashMap<string, string> get_dboptions (string url) {
        Gee.HashMap<string, string> hashoption = new Gee.HashMap<string, string> ();
        Sqlite.Statement stmt;
        string sql = "SELECT * FROM options WHERE url = ?";
        int res = GabutApp.db.prepare_v2 (sql, -1, out stmt);
        res = stmt.bind_text (1, url);
        if ((res = stmt.step ()) == Sqlite.ROW) {
            string dir = stmt.column_text (DBOption.DIR);
            if (dir != "") {
                hashoption[AriaOptions.DIR.get_name ()] = dir;
            }
            string cookie = stmt.column_text (DBOption.COOKIE);
            if (cookie != "") {
                hashoption[AriaOptions.COOKIE.get_name ()] = cookie;
            }
            string referer = stmt.column_text (DBOption.REFERER);
            if (referer != "") {
                hashoption[AriaOptions.REFERER.get_name ()] = referer;
            }
            string magnetbackup = stmt.column_text (DBOption.MAGNETBACKUP);
            if (magnetbackup != "") {
                hashoption[AriaOptions.BT_SAVE_METADATA.get_name ()] = magnetbackup;
            }
            string torrent = stmt.column_text (DBOption.TORRENTBACKUP);
            if (torrent != "") {
                hashoption[AriaOptions.RPC_SAVE_UPLOAD_METADATA.get_name ()] = torrent;
            }
            string proxy = stmt.column_text (DBOption.PROXY);
            if (proxy != "") {
                hashoption[AriaOptions.PROXYUSERNAME.get_name ()] = proxy;
            }
            string port = stmt.column_text (DBOption.PROXYPORT);
            if (port != "") {
                hashoption[AriaOptions.PROXYPORT.get_name ()] = port;
            }
            string username = stmt.column_text (DBOption.PROXYUSERNAME);
            if (username != "") {
                hashoption[AriaOptions.PROXYUSERNAME.get_name ()] = username;
            }
            string usernamepass = stmt.column_text (DBOption.PROXYPASSWORD);
            if (usernamepass != "") {
                hashoption[AriaOptions.PROXYPASSWORD.get_name ()] = usernamepass;
            }
            string user = stmt.column_text (DBOption.USER);
            if (user != "") {
                hashoption[AriaOptions.USERNAME.get_name ()] = user;
            }
            string usernpass = stmt.column_text (DBOption.USERPASS);
            if (usernpass != "") {
                hashoption[AriaOptions.PASSWORD.get_name ()] = usernpass;
            }
            string usernpagent = stmt.column_text (DBOption.USERAGENT);
            if (usernpagent != "") {
                hashoption[AriaOptions.USER_AGENT.get_name ()] = usernpagent;
            }
            string outd = stmt.column_text (DBOption.OUT);
            if (outd != "") {
                hashoption[AriaOptions.OUT.get_name ()] = outd;
            }
            string prothod = stmt.column_text (DBOption.PROXYMETHOD);
            if (prothod != "") {
                hashoption[AriaOptions.PROXY_METHOD.get_name ()] = prothod;
            }
            string selectfile = stmt.column_text (DBOption.SELECTFILE);
            if (selectfile != "") {
                hashoption[AriaOptions.SELECT_FILE.get_name ()] = selectfile;
            }
            string checksums = stmt.column_text (DBOption.CHECKSUM);
            if (checksums != "") {
                hashoption[AriaOptions.CHECKSUM.get_name ()] = checksums;
            }
        }
        stmt.reset ();
        return hashoption;
    }

    private void set_dboptions (string url, Gee.HashMap<string, string> hashoptions) {
        Sqlite.Statement stmt;
        string sql = "INSERT OR IGNORE INTO options (url, magnetbackup, torrentbackup, proxy, port, username, usernamepass, user, userpass, dir, cookie, referer, useragent, out, proxymethod, selectfile, checksum) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
        int res = GabutApp.db.prepare_v2 (sql, -1, out stmt);
        res = stmt.bind_text (DBOption.URL, url);
        if (hashoptions.has_key (AriaOptions.BT_SAVE_METADATA.get_name ())) {
            res = stmt.bind_text (DBOption.MAGNETBACKUP, hashoptions.@get (AriaOptions.BT_SAVE_METADATA.get_name ()));
        } else {
            res = stmt.bind_text (DBOption.MAGNETBACKUP, "");
        }
        if (hashoptions.has_key (AriaOptions.RPC_SAVE_UPLOAD_METADATA.get_name ())) {
            res = stmt.bind_text (DBOption.TORRENTBACKUP, hashoptions.@get (AriaOptions.RPC_SAVE_UPLOAD_METADATA.get_name ()));
        } else {
            res = stmt.bind_text (DBOption.TORRENTBACKUP, "");
        }
        if (hashoptions.has_key (AriaOptions.PROXY.get_name ())) {
            res = stmt.bind_text (DBOption.PROXY, hashoptions.@get (AriaOptions.PROXY.get_name ()));
        } else {
            res = stmt.bind_text (DBOption.PROXY, "");
        }
        if (hashoptions.has_key (AriaOptions.PROXYPORT.get_name ())) {
            res = stmt.bind_text (DBOption.PROXYPORT, hashoptions.@get (AriaOptions.PROXYPORT.get_name ()));
        } else {
            res = stmt.bind_text (DBOption.PROXYPORT, "");
        }
        if (hashoptions.has_key (AriaOptions.PROXYUSERNAME.get_name ())) {
            res = stmt.bind_text (DBOption.PROXYUSERNAME, hashoptions.@get (AriaOptions.PROXYUSERNAME.get_name ()));
        } else {
            res = stmt.bind_text (DBOption.PROXYUSERNAME, "");
        }
        if (hashoptions.has_key (AriaOptions.PROXYPASSWORD.get_name ())) {
            res = stmt.bind_text (DBOption.PROXYPASSWORD, hashoptions.@get (AriaOptions.PROXYPASSWORD.get_name ()));
        } else {
            res = stmt.bind_text (DBOption.PROXYPASSWORD, "");
        }
        if (hashoptions.has_key (AriaOptions.USERNAME.get_name ())) {
            res = stmt.bind_text (DBOption.USER, hashoptions.@get (AriaOptions.USERNAME.get_name ()));
        } else {
            res = stmt.bind_text (DBOption.USER, "");
        }
        if (hashoptions.has_key (AriaOptions.PASSWORD.get_name ())) {
            res = stmt.bind_text (DBOption.USERPASS, hashoptions.@get (AriaOptions.PASSWORD.get_name ()));
        } else {
            res = stmt.bind_text (DBOption.USERPASS, "");
        }
        if (hashoptions.has_key (AriaOptions.DIR.get_name ())) {
            res = stmt.bind_text (DBOption.DIR, hashoptions.@get (AriaOptions.DIR.get_name ()));
        } else {
            res = stmt.bind_text (DBOption.DIR, "");
        }
        if (hashoptions.has_key (AriaOptions.COOKIE.get_name ())) {
            res = stmt.bind_text (DBOption.COOKIE, hashoptions.@get (AriaOptions.COOKIE.get_name ()));
        } else {
            res = stmt.bind_text (DBOption.COOKIE, "");
        }
        if (hashoptions.has_key (AriaOptions.REFERER.get_name ())) {
            res = stmt.bind_text (DBOption.REFERER, hashoptions.@get (AriaOptions.REFERER.get_name ()));
        } else {
            res = stmt.bind_text (DBOption.REFERER, "");
        }
        if (hashoptions.has_key (AriaOptions.USER_AGENT.get_name ())) {
            res = stmt.bind_text (DBOption.USERAGENT, hashoptions.@get (AriaOptions.USER_AGENT.get_name ()));
        } else {
            res = stmt.bind_text (DBOption.USERAGENT, "");
        }
        if (hashoptions.has_key (AriaOptions.OUT.get_name ())) {
            res = stmt.bind_text (DBOption.OUT, hashoptions.@get (AriaOptions.OUT.get_name ()));
        } else {
            res = stmt.bind_text (DBOption.OUT, "");
        }
        if (hashoptions.has_key (AriaOptions.PROXY_METHOD.get_name ())) {
            res = stmt.bind_text (DBOption.PROXYMETHOD, hashoptions.@get (AriaOptions.PROXY_METHOD.get_name ()));
        } else {
            res = stmt.bind_text (DBOption.PROXYMETHOD, "");
        }
        if (hashoptions.has_key (AriaOptions.SELECT_FILE.get_name ())) {
            res = stmt.bind_text (DBOption.SELECTFILE, hashoptions.@get (AriaOptions.SELECT_FILE.get_name ()));
        } else {
            res = stmt.bind_text (DBOption.SELECTFILE, "");
        }
        if (hashoptions.has_key (AriaOptions.CHECKSUM.get_name ())) {
            res = stmt.bind_text (DBOption.CHECKSUM, hashoptions.@get (AriaOptions.CHECKSUM.get_name ()));
        } else {
            res = stmt.bind_text (DBOption.CHECKSUM, "");
        }
        if ((res = stmt.step ()) != Sqlite.DONE) {
            warning ("Error: %d: %s", GabutApp.db.errcode (), GabutApp.db.errmsg ());
        }
        stmt.reset ();
    }

    private void remove_dboptions (string url) {
        Sqlite.Statement stmt;
        string sql = "DELETE FROM options WHERE url = ?";
        int res = GabutApp.db.prepare_v2 (sql, -1, out stmt);
        res = stmt.bind_text (1, url);
        if ((res = stmt.step ()) != Sqlite.DONE) {
            warning ("Error: %d: %s", GabutApp.db.errcode (), GabutApp.db.errmsg ());
        }
        stmt.reset ();
    }

    private void update_optionts (string url, Gee.HashMap<string, string> hashoptions) {
        Sqlite.Statement stmt;
        var buildstr = new StringBuilder ();
        buildstr.append ("UPDATE options SET");
        uint empty_hash = buildstr.str.hash ();
        int res = GabutApp.db.prepare_v2 ("SELECT * FROM options WHERE url = ?", -1, out stmt);
        res = stmt.bind_text (1, url);
        if ((res = stmt.step ()) == Sqlite.ROW) {
            if (hashoptions.has_key (AriaOptions.BT_SAVE_METADATA.get_name ())) {
                string magnetbackup = hashoptions.@get (AriaOptions.BT_SAVE_METADATA.get_name ());
                if (stmt.column_text (DBOption.MAGNETBACKUP) != magnetbackup) {
                    buildstr.append (@" $(DBOption.MAGNETBACKUP.get_name ()) = \"$(magnetbackup)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.RPC_SAVE_UPLOAD_METADATA.get_name ())) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                string torrentbackup = hashoptions.@get (AriaOptions.RPC_SAVE_UPLOAD_METADATA.get_name ());
                if (stmt.column_text (DBOption.TORRENTBACKUP) != torrentbackup) {
                    buildstr.append (@" $(DBOption.TORRENTBACKUP.get_name ()) = $(torrentbackup)");
                }
            }
            if (hashoptions.has_key (AriaOptions.PROXY.get_name ())) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                string proxy = hashoptions.@get (AriaOptions.PROXY.get_name ());
                if (stmt.column_text (DBOption.PROXY) != proxy) {
                    buildstr.append (@" $(DBOption.PROXY.get_name ()) = \"$(proxy)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.PROXYPORT.get_name ())) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                string port = hashoptions.@get (AriaOptions.PROXYPORT.get_name ());
                if (stmt.column_text (DBOption.PROXYPORT) != port) {
                    buildstr.append (@" $(DBOption.PROXYPORT.get_name ()) = \"$(port)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.PROXYUSERNAME.get_name ())) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                string username = hashoptions.@get (AriaOptions.PROXYUSERNAME.get_name ());
                if (stmt.column_text (DBOption.PROXYUSERNAME) != username) {
                    buildstr.append (@" $(DBOption.PROXYUSERNAME.get_name ()) = \"$(username)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.PROXYPASSWORD.get_name ())) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                string passwd = hashoptions.@get (AriaOptions.PROXYPASSWORD.get_name ());
                if (stmt.column_text (DBOption.PROXYPASSWORD) != passwd) {
                    buildstr.append (@" $(DBOption.PROXYPASSWORD.get_name ()) = \"$(passwd)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.USERNAME.get_name ())) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                string user = hashoptions.@get (AriaOptions.USERNAME.get_name ());
                if (stmt.column_text (DBOption.USER) != user) {
                    buildstr.append (@" $(DBOption.USER.get_name ()) = \"$(user)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.PASSWORD.get_name ())) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                string userpass = hashoptions.@get (AriaOptions.PASSWORD.get_name ());
                if (stmt.column_text (DBOption.USERPASS) != userpass) {
                    buildstr.append (@" $(DBOption.USERPASS.get_name ()) = \"$(userpass)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.DIR.get_name ())) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                string dir = hashoptions.@get (AriaOptions.DIR.get_name ());
                if (stmt.column_text (DBOption.DIR) != dir) {
                    buildstr.append (@" $(DBOption.DIR.get_name ()) = \"$(dir)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.COOKIE.get_name ())) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                string cookie = hashoptions.@get (AriaOptions.COOKIE.get_name ());
                if (stmt.column_text (DBOption.COOKIE) != cookie) {
                    buildstr.append (@" $(DBOption.COOKIE.get_name ()) = \"$(cookie)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.REFERER.get_name ())) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                string referer = hashoptions.@get (AriaOptions.REFERER.get_name ());
                if (stmt.column_text (DBOption.REFERER) != referer) {
                    buildstr.append (@" $(DBOption.REFERER.get_name ()) = \"$(referer)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.USER_AGENT.get_name ())) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                string useragent = hashoptions.@get (AriaOptions.USER_AGENT.get_name ());
                if (stmt.column_text (DBOption.USERAGENT) != useragent) {
                    buildstr.append (@" $(DBOption.USERAGENT.get_name ()) = \"$(useragent)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.OUT.get_name ())) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                string outf = hashoptions.@get (AriaOptions.OUT.get_name ());
                if (stmt.column_text (DBOption.OUT) != outf) {
                    buildstr.append (@" $(DBOption.OUT.get_name ()) = \"$(outf)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.PROXY_METHOD.get_name ())) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                string proxymethod = hashoptions.@get (AriaOptions.PROXY_METHOD.get_name ());
                if (stmt.column_text (DBOption.PROXYMETHOD) != proxymethod) {
                    buildstr.append (@" $(DBOption.PROXYMETHOD.get_name ()) = \"$(proxymethod)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.SELECT_FILE.get_name ())) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                string selectfile = hashoptions.@get (AriaOptions.SELECT_FILE.get_name ());
                if (stmt.column_text (DBOption.SELECTFILE) != selectfile) {
                    buildstr.append (@" $(DBOption.SELECTFILE.get_name ()) = \"$(selectfile)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.CHECKSUM.get_name ())) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                string checksums = hashoptions.@get (AriaOptions.CHECKSUM.get_name ());
                if (stmt.column_text (DBOption.CHECKSUM) != checksums) {
                    buildstr.append (@" $(DBOption.CHECKSUM.get_name ()) = \"$(checksums)\"");
                }
            }
            if (buildstr.str.hash () == empty_hash) {
                return;
            }
        }
        buildstr.append (" WHERE url = ?");
        res = GabutApp.db.prepare_v2 (buildstr.str, -1, out stmt);
        res = stmt.bind_text (1, url);
        if ((res = stmt.step ()) != Sqlite.DONE) {
            warning ("Error: %d: %s", GabutApp.db.errcode (), GabutApp.db.errmsg ());
        }
        stmt.reset ();
    }

    private bool db_option_exist (string url) {
        Sqlite.Statement stmt;
        string sql = "SELECT * FROM options WHERE url = ?";
        int res = GabutApp.db.prepare_v2 (sql, -1, out stmt);
        res = stmt.bind_text (1, url);
        if ((res = stmt.step ()) == Sqlite.ROW) {
            return true;
        }
        stmt.reset ();
        return false;
    }
}
