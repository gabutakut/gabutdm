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
        STARTUP = 23,
        STYLE = 24,
        UPLOADLIMIT = 25,
        DOWNLOADLIMIT = 26,
        BTLISTENPORT = 27,
        DHTLISTENPORT = 28,
        BTTRACKER = 29,
        BTTRACKEREXC = 30,
        SPLITSIZE = 31,
        LOWESTSPEED = 32,
        URISELECTOR = 33,
        PIECESELECTOR = 34,
        CLIPBOARD = 35,
        SHAREDIR = 36,
        SWITCHDIR = 37,
        SORTBY = 38,
        ASCEDESCEN = 39,
        SHOWTIME = 40,
        SHOWDATE = 41,
        DBUSMENU = 42,
        TDEFAULT = 43,
        NOTIFSOUND = 44,
        MENUINDICATOR = 45,
        LABELMODE = 46,
        THEMESELECT = 47,
        THEMECUSTOM = 48,
        LASTCLIPBOARD = 49,
        OPTIMIZEDOW = 50,
        HLSPARALLELCON = 51,
        HLSACTIVE = 52,
        HLSTIMEOUT = 53,
        HLSRETRIES = 54;

        public string to_string () {
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
                case STYLE:
                    return "style";
                case UPLOADLIMIT:
                    return "uploadlimit";
                case DOWNLOADLIMIT:
                    return "downloadlimit";
                case BTLISTENPORT:
                    return "btlistenport";
                case DHTLISTENPORT:
                    return "dhtlistenport";
                case BTTRACKER:
                    return "bttracker";
                case BTTRACKEREXC:
                    return "bttrackerexc";
                case SPLITSIZE:
                    return "splitsize";
                case LOWESTSPEED:
                    return "lowestspeed";
                case URISELECTOR:
                    return "uriselector";
                case PIECESELECTOR:
                    return "pieceselector";
                case CLIPBOARD:
                    return "clipboard";
                case SHAREDIR:
                    return "sharedir";
                case SWITCHDIR:
                    return "switchdir";
                case SORTBY:
                    return "sortby";
                case ASCEDESCEN:
                    return "ascedescen";
                case SHOWTIME:
                    return "showtime";
                case SHOWDATE:
                    return "showdate";
                case DBUSMENU:
                    return "dbusmenu";
                case TDEFAULT:
                    return "tdefault";
                case NOTIFSOUND:
                    return "notifsound";
                case MENUINDICATOR:
                    return "menuindicator";
                case LABELMODE:
                    return "labelmode";
                case THEMESELECT:
                    return "themeselect";
                case THEMECUSTOM:
                    return "themecustom";
                case LASTCLIPBOARD:
                    return "lastclipboard";
                case OPTIMIZEDOW:
                    return "optimizedow";
                case HLSPARALLELCON:
                    return "hlsparallelcon";
                case HLSACTIVE:
                    return "hlsactive";
                case HLSTIMEOUT:
                    return "hlstimeout";
                case HLSRETRIES:
                    return "hlsretries";
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

        public string to_string () {
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
    }

    private enum LinkMode {
        METALINK = 0,
        TORRENT = 1,
        URL = 2,
        MAGNETLINK = 3,
        HLS = 4
    }

    private enum StatusMode {
        ACTIVE = 0,
        PAUSED = 1,
        COMPLETE = 2,
        WAIT = 3,
        ERROR = 4,
        NOTHING = 5,
        SEED = 6,
        VERIFY = 7,
        MERGE = 8,
        ALL = 9;
    }

    private enum OpenFiles {
        OPENFILES = 0,
        OPENPERDONLOADFOLDER = 1,
        OPENCOOKIES = 2,
        OPENGLOBALFOLDER = 3,
        OPENFOLDERSHARING = 4,
        OPENTEXTONE = 5,
        OPENTEXTTWO = 6
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
        PROXYUSER = 81,
        PROXYPASSWORD = 82,
        MAX_CONCURRENT_DOWNLOADS = 83,
        DISK_CACHE = 84,
        BT_MAX_OPEN_FILES = 85,
        SELECT_FILE = 86,
        HEADER = 87,
        SEED_TIME = 88,
        CHECKSUM = 89,
        MAX_OVERALL_UPLOAD_LIMIT = 90,
        MAX_OVERALL_DOWNLOAD_LIMIT = 91,
        LISTEN_PORT = 92,
        DHT_LISTEN_PORT = 93,
        BT_TRACKER = 94,
        BT_EXCLUDE_TRACKER = 95,
        PEER_AGENT = 96,
        HTTP_USER = 97,
        HTTP_PASSWD = 98,
        FTP_USER = 99,
        FTP_PASSWD = 100,
        FTP_PROXY = 101,
        FTP_PROXY_USER = 102,
        FTP_PROXY_PASSWD = 103,
        HTTP_PROXY = 104,
        HTTP_PROXY_USER = 105,
        HTTP_PROXY_PASSWD = 106,
        HTTPS_PROXY = 107,
        HTTPS_PROXY_USER = 108,
        HTTPS_PROXY_PASSWD = 109,
        OPTIMIZE_CONCURRENT_DOWNLOADS = 110;

        public string to_string () {
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
                case PROXYUSER:
                    return "all-proxy-user";
                case PROXYPASSWORD:
                    return "all-proxy-passwd";
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
                case MAX_OVERALL_UPLOAD_LIMIT:
                    return "max-overall-upload-limit";
                case MAX_OVERALL_DOWNLOAD_LIMIT:
                    return "max-overall-download-limit";
                case LISTEN_PORT:
                    return "listen-port";
                case DHT_LISTEN_PORT:
                    return "dht-listen-port";
                case BT_TRACKER:
                    return "bt-tracker";
                case BT_EXCLUDE_TRACKER:
                    return "bt-exclude-tracker";
                case PEER_AGENT:
                    return "peer-agent";
                case HTTP_USER:
                    return "http-user";
                case HTTP_PASSWD:
                    return "http-passwd";
                case FTP_USER:
                    return "ftp-user";
                case FTP_PASSWD:
                    return "ftp-passwd";
                case FTP_PROXY:
                    return "ftp-proxy";
                case FTP_PROXY_USER:
                    return "ftp-proxy-user";
                case FTP_PROXY_PASSWD:
                    return "ftp-proxy-passwd";
                case HTTP_PROXY:
                    return "http-proxy";
                case HTTP_PROXY_USER:
                    return "http-proxy-user";
                case HTTP_PROXY_PASSWD:
                    return "http-proxy-passwd";
                case HTTPS_PROXY:
                    return "https-proxy";
                case HTTPS_PROXY_USER:
                    return "https-proxy-user";
                case HTTPS_PROXY_PASSWD:
                    return "https-proxy-passwd";
                case OPTIMIZE_CONCURRENT_DOWNLOADS:
                    return "optimize-concurrent-downloads";
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

    private string get_peerid (string mode) {
        switch (mode) {
            case "7T":
                return "aTorrent for Android";
            case "AB":
                return "AnyEvent::BitTorrent";
            case "AG":
            case "A~":
                return "Ares";
            case "AR":
                return "Arctic";
            case "AV":
                return "Avicora";
            case "AT":
                return "Artemis";
            case "AX":
                return "BitPump";
            case "AZ":
                return "Azureus";
            case "BB":
                return "BitBuddy";
            case "BC":
                return "BitComet";
            case "BE":
                return "Baretorrent";
            case "BF":
                return "Bitflu";
            case "BG":
                return "BTG (uses Rasterbar libtorrent)";
            case "BL":
                return "BitCometLite / BitBlinder";
            case "BP":
                return "BitTorrent";
            case "BR":
                return "BitRocket";
            case "BS":
                return "BTSlave";
            case "BT":
                return "BitTorrent";
            case "Bt":
                return "Bt";
            case "BW":
                return "BitWombat";
            case "BX":
                return "Bittorrent X";
            case "CD":
                return "Enhanced CTorrent";
            case "CT":
                return "CTorrent";
            case "DE":
                return "DelugeTorrent";
            case "DP":
                return "Propagate Data Client";
            case "EB":
                return "EBit";
            case "ES":
                return "electric sheep";
            case "FC":
                return "FileCroc";
            case "FD":
                return "Free Download Manager";
            case "FT":
                return "FoxTorrent";
            case "FX":
                return "Freebox BitTorrent";
            case "GS":
                return "GSTorrent";
            case "HK":
                return "Hekate";
            case "HL":
                return "Halite";
            case "HM":
                return "hMule";
            case "HN":
                return "Hydranode";
            case "IL":
                return "iLivid";
            case "JS":
                return "Justseed.it client";
            case "JT":
                return "JavaTorrent";
            case "KG":
                return "KGet";
            case "KT":
                return "KTorrent";
            case "LC":
                return "LeechCraft";
            case "LH":
                return "LH-ABC";
            case "LP":
                return "Lphant";
            case "lt":
            case "LT":
                return "libtorrent";
            case "LW":
                return "LimeWire";
            case "MK":
                return "Meerkat";
            case "MO":
                return "MonoTorrent";
            case "MP":
                return "MooPolice";
            case "MR":
                return "Miro";
            case "MT":
                return "MoonlightTorrent";
            case "NB":
                return "Net::BitTorrent";
            case "NX":
                return "Net Transport";
            case "OS":
                return "OneSwarm";
            case "OT":
                return "OmegaTorrent";
            case "PB":
                return "Protocol::BitTorrent";
            case "PD":
                return "Pando";
            case "PI":
                return "PicoTorrent";
            case "PT":
                return "PHPTracker";
            case "qB":
                return "qBittorrent";
            case "QD":
                return "QQDownload";
            case "QT":
                return "Qt 4 Torrent example";
            case "RT":
                return "Retriever";
            case "RZ":
                return "RezTorrent";
            case "S~":
                return "Shareaza alpha/beta";
            case "SB":
                return "~Swiftbit";
            case "SD":
                return "Thunder";
            case "SM":
                return "SoMud";
            case "SP":
                return "BitSpirit";
            case "SS":
                return "SwarmScope";
            case "ST":
                return "SymTorrent";
            case "st":
                return "sharktorrent";
            case "SZ":
                return "Shareaza";
            case "TB":
                return "Torch";
            case "TE":
                return "terasaur Seed Bank";
            case "TL":
                return "Tribler";
            case "TN":
                return "TorrentDotNET";
            case "TR":
                return "Transmission";
            case "TS":
                return "Torrentstorm";
            case "TT":
                return "TuoTu";
            case "UL":
                return "uLeecher";
            case "UM":
            case "UT":
                return "µTorrent";
            case "VG":
                return "Vagaa";
            case "WD":
                return "WebTorrent Desktop";
            case "WT":
                return "BitLet";
            case "WW":
                return "WebTorrent";
            case "WY":
                return "FireTorrent";
            case "XF":
                return "Xfplay";
            case "XL":
                return "Xunlei";
            case "XS":
                return "XSwifter";
            case "XT":
                return "XanTorrent";
            case "XX":
                return "Xtorrent";
            case "ZT":
                return "ZipTorrent";
            default:
                return "Unknow";
        }
    }

    private enum AriaGetfiles {
        INDEX = 0,
        PATH = 1,
        LENGTH = 2,
        COMPLETEDLENGTH = 3,
        URIS = 4,
        URI = 5;

        public string to_string () {
            switch (this) {
                case PATH:
                    return "path";
                case LENGTH:
                    return "length";
                case COMPLETEDLENGTH:
                    return "completedlength";
                case URIS:
                    return "uris";
                case URI:
                    return "uri";
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
        FILEORDIR = 10,
        LABELTRANSFER = 11,
        TIMEADDED = 12,
        BITFIELD = 13,
        PIECECOUNT = 14,
        ERRORCODE = 15;

        public string to_string () {
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
                case TRANSFERRED:
                    return "transferred";
                case LINKMODE:
                    return "linkmode";
                case FILEORDIR:
                    return "fileordir";
                case LABELTRANSFER:
                    return "labeltransfer";
                case TIMEADDED:
                    return "timeadded";
                case BITFIELD:
                    return "bitfield";
                case PIECECOUNT:
                    return "piececount";
                case ERRORCODE:
                    return "errorcode";
                default:
                    return "id";
            }
        }
    }

    private enum GlobalStat {
        DOWNLOADSPEED = 0,
        UPLOADSPEED = 1,
        NUMACTIVE = 2,
        NUMWAITING = 3,
        NUMSTOPPED = 4,
        NUMSTOPPEDTOTAL = 5
    }

    private enum DBOption {
        ID = 0,
        URL = 1,
        MAGNETBACKUP = 2,
        TORRENTBACKUP = 3,
        PROXY = 4,
        PROXYUSER = 5,
        PROXYPASSWORD = 6,
        HTTPUSR = 7,
        HTTPPASS = 8,
        FTPUSR = 9,
        FTPPASS = 10,
        DIR = 11,
        COOKIE = 12,
        REFERER = 13,
        USERAGENT = 14,
        OUT = 15,
        PROXYMETHOD = 16,
        SELECTFILE = 17,
        CHECKSUM = 18,
        CRYPTOLVL = 19,
        REQUIRECRYP = 20,
        INTEGRITY = 21,
        UNVERIFIED = 22,
        PROXYTYPE = 23,
        SELECTED = 24,
        HEADER = 25;

        public string to_string () {
            switch (this) {
                case URL:
                    return "url";
                case MAGNETBACKUP:
                    return "magnetbackup";
                case TORRENTBACKUP:
                    return "torrentbackup";
                case PROXY:
                    return "proxy";
                case PROXYUSER:
                    return "proxyusr";
                case PROXYPASSWORD:
                    return "proxypass";
                case HTTPUSR:
                    return "httpusr";
                case HTTPPASS:
                    return "httppass";
                case FTPUSR:
                    return "ftpusr";
                case FTPPASS:
                    return "ftppass";
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
                case CRYPTOLVL:
                    return "cryptolvl";
                case REQUIRECRYP:
                    return "requirecryp";
                case INTEGRITY:
                    return "integrity";
                case UNVERIFIED:
                    return "unverified";
                case PROXYTYPE:
                    return "proxytype";
                case SELECTED:
                    return "selected";
                case HEADER:
                    return "header";
                default:
                    return "id";
            }
        }
    }

    private enum PostServer {
        ALL,
        URL,
        FILENAME,
        REFERRER,
        MIME,
        FILESIZE,
        RESUMABLE,
        USERAGENT,
        HEADER,
        N_COLUMNS
    }

    private struct FSorter {
        public string name {get; set;}
        public string mimetype {get; set;}
        public bool fileordir {get; set;}
        public int64 size {get; set;}
        public int fileindir {get; set;}
        public GLib.FileInfo fileinfo {get; set;}
        public string date {get; set;}
    }

    public enum FileAllocations {
        NONE = 0,
        PREALLOC = 1,
        TRUNC = 2,
        FALLOC = 3;

        public string to_string () {
            switch (this) {
                case PREALLOC:
                    return _("Prealloc");
                case TRUNC:
                    return _("Trunc");
                case FALLOC:
                    return _("Falloc");
                default:
                    return _("None");
            }
        }

        public string to_tooltip () {
            switch (this) {
                case PREALLOC:
                    return _("Pre-allocates file space before download begins");
                case TRUNC:
                    return _("Uses ftruncate(2) system call or platform-specific counterpart to truncate a file to a specified length");
                case FALLOC:
                    return _("is your best choice. It allocates large(few GiB) files almost instantly");
                default:
                    return _("Doesn't pre-allocate file space");
            }
        }

        public static FileAllocations [] get_all () {
            return { NONE, PREALLOC, TRUNC, FALLOC };
        }
    }

    public enum ProxyMethods {
        GET = 0,
        TUNNEL = 1;

        public string to_string () {
            switch (this) {
                case TUNNEL:
                    return _("Tunnel");
                default:
                    return _("Get");
            }
        }

        public static ProxyMethods [] get_all () {
            return { GET, TUNNEL };
        }
    }

    public enum BTEncrypts {
        PLAIN = 0,
        ARC4 = 1;

        public string to_string () {
            switch (this) {
                case ARC4:
                    return _("Arc4");
                default:
                    return _("Plain");
            }
        }

        public static BTEncrypts [] get_all () {
            return { PLAIN, ARC4 };
        }
    }

    public enum LoginUsers {
        HTTP = 0,
        FTP = 1;

        public string to_string () {
            switch (this) {
                case FTP:
                    return _("FTP");
                default:
                    return _("HTTP");
            }
        }

        public static LoginUsers [] get_all () {
            return { HTTP, FTP };
        }
    }

    public enum PieceSelectors {
        DEFAULT = 0,
        INORDER = 1,
        RANDOM = 2,
        GEOM = 3;

        public string to_string () {
            switch (this) {
                case INORDER:
                    return _("Inorder");
                case RANDOM:
                    return _("Random");
                case GEOM:
                    return _("Geom");
                default:
                    return _("Default");
            }
        }

        public string to_tooltip () {
            switch (this) {
                case INORDER:
                    return _("Select a piece closest to the beginning of the file");
                case RANDOM:
                    return _("Select a piece randomly");
                case GEOM:
                    return _("When starting to download a file, select a piece closest to the beginning of the file like inorder, but then exponentially increases space between pieces");
                default:
                    return _("Select a piece to reduce the number of connections established");
            }
        }

        public static PieceSelectors [] get_all () {
            return { DEFAULT, INORDER, RANDOM, GEOM };
        }
    }

    public enum UriSelectors {
        FEEDBACK = 0,
        INORDER = 1,
        ADAPTIVE = 2;

        public string to_string () {
            switch (this) {
                case INORDER:
                    return _("Inorder");
                case ADAPTIVE:
                    return _("Adaptive");
                default:
                    return _("Feedback");
            }
        }

        public string to_tooltip () {
            switch (this) {
                case INORDER:
                    return _("URI is tried in the order appeared in the URI list");
                case ADAPTIVE:
                    return _("selects one of the best mirrors for the first and reserved connections.");
                default:
                    return _("Aria2 uses download speed observed in the previous downloads and choose fastest server in the URI list");
            }
        }

        public static UriSelectors [] get_all () {
            return { FEEDBACK, INORDER, ADAPTIVE };
        }
    }

    public enum AriaChecksumTypes {
        NONE = 0,
        MD5 = 1,
        SHA1 = 2,
        SHA256 = 3,
        SHA384 = 4,
        SHA512 = 5;

        public string to_string () {
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

    public enum ProxyTypes {
        ALL = 0,
        HTTP = 1,
        HTTPS = 2,
        FTP = 3;

        public string to_string () {
            switch (this) {
                case HTTP:
                    return _("HTTP");
                case HTTPS:
                    return _("HTTPS");
                case FTP:
                    return _("FTP");
                default:
                    return _("ALL");
            }
        }

        public static ProxyTypes [] get_all () {
            return { ALL, HTTP, HTTPS, FTP };
        }
    }

    public enum SortbyWindow {
        NAME = 0,
        SIZE = 1,
        TYPE = 2,
        TIMEADDED = 3;

        public string to_string () {
            switch (this) {
                case SIZE:
                    return _("Size");
                case TYPE:
                    return _("Type");
                case TIMEADDED:
                    return _("Time Added");
                default:
                    return _("Name");
            }
        }

        public static SortbyWindow [] get_all () {
            return { NAME, SIZE, TYPE, TIMEADDED};
        }
    }

    public enum DownloadMenu {
        SELECTALL = 0,
        OPENFOLDER = 1,
        MOVETOTRASH = 2,
        PROPERTIES = 3;

        public string to_string () {
            switch (this) {
                case OPENFOLDER:
                    return _("Open Folder");
                case MOVETOTRASH:
                    return _("Move to Trash");
                case PROPERTIES:
                    return _("Properties");
                default:
                    return _("Select ALL");
            }
        }

        public string to_tooltip () {
            switch (this) {
                case OPENFOLDER:
                    return _("CTRL + 0");
                case MOVETOTRASH:
                    return _("DEL");
                case PROPERTIES:
                    return _("CTRL + M");
                default:
                    return _("CTRL + A");
            }
        }

        public string to_icon () {
            switch (this) {
                case OPENFOLDER:
                    return "folder-open";
                case MOVETOTRASH:
                    return "user-trash-full";
                case PROPERTIES:
                    return "document-properties";
                default:
                    return "edit-select-all";
            }
        }

        public static DownloadMenu [] get_all () {
            return { SELECTALL, OPENFOLDER, MOVETOTRASH, PROPERTIES};
        }
    }

    public enum OpenMenus {
        ADDURL = 0,
        ADDHLS = 1,
        ADDMAGNET = 2,
        OPENMN = 3;

        public string to_string () {
            switch (this) {
                case ADDHLS:
                    return _("HLS/M3U8");
                case ADDMAGNET:
                    return _("Magnetlink");
                case OPENMN:
                    return _("Torrent");
                default:
                    return _("URL");
            }
        }
        public string to_icon () {
            switch (this) {
                case ADDHLS:
                    return "com.github.gabutakut.gabutdm.hls";
                case ADDMAGNET:
                    return "com.github.gabutakut.gabutdm.magnet";
                case OPENMN:
                    return "com.github.gabutakut.gabutdm.torrent";
                default:
                    return "com.github.gabutakut.gabutdm.uri";
            }
        }
        public static OpenMenus [] get_all () {
            return { ADDURL, ADDHLS, ADDMAGNET, OPENMN};
        }
    }

    public enum DeAscend {
        ASCENDING = 0,
        DESCENDING = 1
    }

    public enum MenuItem {
        VISIBLE = 0,
        ENABLED = 1,
        LABEL = 2,
        ICON_NAME = 3,
        ICON_DATA = 4,
        TOGGLE_TYPE = 5,
        TOGGLE_STATE = 6,
        SHORTCUT = 7,
        CHILD_DISPLAY = 8,
        DISPOSITION = 9,
        ACCESSIBLE_DESC = 10,
        SUBMENU = 11,
        TYPE = 12;

        public string to_string () {
            switch (this) {
                case ENABLED:
                    return "enabled";
                case LABEL:
                    return "label";
                case ICON_NAME:
                    return "icon-name";
                case ICON_DATA:
                    return "icon-data";
                case TOGGLE_TYPE:
                    return "toggle-type";
                case TOGGLE_STATE:
                    return "toggle-state";
                case SHORTCUT:
                    return "shortcut";
                case CHILD_DISPLAY:
                    return "children-display";
                case DISPOSITION:
                    return "disposition";
                case ACCESSIBLE_DESC:
                    return "accessible-desc";
                case SUBMENU:
                    return "submenu";
                case TYPE:
                    return "type";
                default:
                    return "visible";
            }
        }
    }

    public enum InfoSucces {
        ADDRESS = 0,
        FILEPATH = 1,
        FILESIZE = 2,
        ICONNAME = 3
    }

    private struct UsersID {
        public int64 id {get; set;}
        public bool activate {get; set;}
        public string user {get; set;}
        public string passwd {get; set;}
    }

    public enum MyProxy {
        NONE = 0,
        ACTIVE = 1;

        public string to_string () {
            switch (this) {
                case ACTIVE:
                    return _("Proxy");
                default:
                    return _("No Proxy");
            }
        }

        public static MyProxy [] get_all () {
            return { NONE, ACTIVE};
        }
    }

    private struct SavedProxy {
        public int64 id {get; set;}
        public int typepr {get; set;}
        public string host {get; set;}
        public string port {get; set;}
        public string user {get; set;}
        public string passwd {get; set;}
    }

    private enum DBMyproxy {
        ID = 0,
        TYPEPR = 1,
        HOST = 2,
        PORT = 3,
        USER = 4,
        PASSWD = 5;

        public string to_string () {
            switch (this) {
                case TYPEPR:
                    return "typepr";
                case HOST:
                    return "host";
                case PORT:
                    return "port";
                case USER:
                    return "user";
                case PASSWD:
                    return "passwd";
                default:
                    return "id";
            }
        }
    }

    private enum UserID {
        ID = 0,
        ACTIVE = 1,
        USER = 2,
        PASSWD = 3,
        SHORTBY = 4;

        public string get_str () {
            switch (this) {
                case ACTIVE:
                    return "active";
                case USER:
                    return "user";
                case PASSWD:
                    return "passwd";
                case SHORTBY:
                    return "shortby";
                default:
                    return "id";
            }
        }
    }

    public enum DialogType {
        ADDURL,
        ADDTR,
        ADDHLS,
        ADDMAGNET,
        PROPERTY
    }

    public enum EntryType {
        STANDARD,
        WITHSIGNAL,
        INFO
    }

    public struct IncompleteRange {
        public int start;
        public int end;
    }

    private struct TorrentFile {
        public string name;
        public int64  size;
    }

    public enum ServerType {
        IMG,
        VIDEO,
        AUDIO
    }

    private SourceFunc ariacll;
    private Sqlite.Database gabutdb;
    private Aria2.Engine engine;
    private GLib.File serverdir;
    private string aria_listent;
    private bool cliboardmenu;
    private int hlsparalell_dld;
    private int hlsparallel_active;
    private int hls_timeout;
    private int hls_max_retries;

    private void menuglobal () {
        cliboardmenu = bool.parse (get_dbsetting (Gabut.DBSettings.CLIPBOARD));
        hlsparalell_dld = int.parse (get_dbsetting (Gabut.DBSettings.HLSPARALLELCON));
        hlsparallel_active = int.parse (get_dbsetting (Gabut.DBSettings.HLSACTIVE));
        hls_timeout = int.parse (get_dbsetting (Gabut.DBSettings.HLSTIMEOUT));
        hls_max_retries = int.parse (get_dbsetting (Gabut.DBSettings.HLSRETRIES));
        serverdir = File.new_for_path (get_dbsetting (DBSettings.SHAREDIR));
    }

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

    private string get_soupmess (string datas) {
        Soup.Session session = new Soup.Session ();
        try {
            var message = new Soup.Message ("POST", aria_listent);
            message.set_request_body_from_bytes (Soup.FORM_MIME_TYPE_MULTIPART, new GLib.Bytes (datas.data));
            GLib.Bytes bytes = session.send_and_read (message);
            return (string) bytes.get_data ();
        } catch (Error e) {
            GLib.warning (e.message);
            if (session != null) {
                session.abort ();
                session = null;
            }
        } finally {
            if (session != null) {
                session.abort ();
                session = null;
            }
        }
        return "";
    }

    public string[]? get_content_type (string url, string cookie) {
        string[]content = {};
        Soup.Session session = new Soup.Session ();
        try {
            var message = new Soup.Message ("HEAD", url);
            if (cookie != null && cookie != "") {
                message.request_headers.append ("Cookie", cookie);
            }
            var sesc = session.send (message);
            content += message.response_headers.get_content_type (null);
            string sizef = message.response_headers.get_one ("Content-Length");
            content += sizef != null? sizef : "0";
            sesc.close ();
            message = null;
            return content;
        } catch (Error e) {
            GLib.warning (@"Error: $(e.message)");
            if (session != null) {
                session.abort ();
                session = null;
            }
            return content;
        } finally {
            if (session != null) {
                session.abort ();
                session = null;
            }
        }
    }

    private string aria_url (string url, Gee.HashMap<string, string> options, int arpos) {
        var stringbuild = new StringBuilder ();
        stringbuild.append (@"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.addUri\", \"params\":[[\"$(url)\"], {");
        uint hasempty = stringbuild.str.hash ();
        foreach (var value in options) {
            if (hasempty != stringbuild.str.hash ()) {
                stringbuild.append (", ");
            }
            if (value.key == AriaOptions.HEADER.to_string ()) {
                stringbuild.append (@"\"$(value.key)\" : [ \"Cookie: $(value.value)\"]");
            } else {
                stringbuild.append (@"\"$(value.key)\" : \"$(value.value)\"");
            }
        }
        stringbuild.append (@"}, $(arpos)]}");
        string result = get_soupmess (stringbuild.str);
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        return result_ret (result);
    }

    private string aria_torrent (string torr, Gee.HashMap<string, string> options, int arpos) {
        var stringbuild = new StringBuilder ();
        stringbuild.append (@"{\"jsonrpc\":\"2.0\", \"id\":\"asdf\", \"method\":\"aria2.addTorrent\", \"params\":[\"$(torr)\", [\"uris\"], {");
        uint hasempty = stringbuild.str.hash ();
        foreach (var value in options) {
            if (hasempty != stringbuild.str.hash ()) {
                stringbuild.append (", ");
            }
            stringbuild.append (@"\"$(value.key)\" : \"$(value.value)\"");
        }
        stringbuild.append (@"}, $(arpos)]}");
        string result = get_soupmess (stringbuild.str);
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        return result_ret (result);
    }

    private string aria_metalink (string metal, Gee.HashMap<string, string> options, int arpos) {
        var stringbuild = new StringBuilder ();
        stringbuild.append (@"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.addMetalink\", \"params\":[[\"$(metal)\"], {");
        uint hasempty = stringbuild.str.hash ();
        foreach (var value in options) {
            if (hasempty != stringbuild.str.hash ()) {
                stringbuild.append (", ");
            }
            stringbuild.append (@"\"$(value.key)\" : \"$(value.value)\"");
        }
        stringbuild.append (@"}, $(arpos)]}");
        string result = get_soupmess (stringbuild.str);
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        return result_ret (result);
    }

    private string aria_remove (string gid) {
        string result = get_soupmess (@"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.forceRemove\", \"params\":[\"$(gid)\"]}");
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        return result_ret (result);
    }

    private string aria_pause (string gid) {
        string result = get_soupmess (@"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.forcePause\", \"params\":[\"$(gid)\"]}");
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        return result_ret (result);
    }

    private string aria_pause_all ( ) {
        string result = get_soupmess ("{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.pauseAll\"}");
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        return result_ret (result);
    }

    private string aria_unpause (string gid) {
        string result = get_soupmess (@"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.unpause\", \"params\":[\"$(gid)\"]}");
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        return result_ret (result);
    }

    private string aria_position (string gid, int arpos) {
        string result = get_soupmess (@"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.changePosition\", \"params\":[\"$(gid)\", $(arpos), \"POS_SET\"]}");
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        return result_ret (result);
    }

    private Gee.HashMap<string, PeersRow> aria_get_peers (string gid) {
        var liststore = new Gee.HashMap<string, PeersRow> ();
        string aresult = get_soupmess (@"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.getPeers\", \"params\":[\"$(gid)\"]}");
        if (!aresult.down ().contains ("result") || aresult == null) {
            return liststore;
        }
        var parser = new Json.Parser();
        try {
            parser.load_from_data(aresult);
        } catch (Error e) {
            GLib.warning(e.message);
            return liststore;
        }

        var root = parser.get_root().get_object();
        var result = root.get_array_member("result");

        for (uint i = 0; i < result.get_length(); i++) {
            var obj = result.get_object_element(i);
            string ip = obj.get_string_member("ip");
            string port = obj.get_string_member("port");
            string peerid = GLib.Uri.unescape_string (obj.get_string_member("peerId"));
            var peerschoking = bool.parse (obj.get_string_member("peerChoking"))? "com.github.gabutakut.gabutdm.peerchoking" : "com.github.gabutakut.gabutdm.peerchok";
            var seeder = bool.parse (obj.get_string_member("seeder"))? "com.github.gabutakut.gabutdm" : "com.github.gabutakut.gabutdm.seed";
            var amchoking = bool.parse (obj.get_string_member("amChoking"))? "com.github.gabutakut.gabutdm.amchoking" : "com.github.gabutakut.gabutdm.amchok";
            var peersrow = new PeersRow (@"$(ip):$(port)", peerid != "" && peerid != null? get_peerid (peerid.slice (1, 3)) : "Unknow") {
                downloadspeed = GLib.format_size (int64.parse (obj.get_string_member("downloadSpeed"))),
                uploadspeed = GLib.format_size (int64.parse (obj.get_string_member("uploadSpeed"))),
                peerschoking = peerschoking,
                seeder = seeder,
                amchoking = amchoking,
                bitfield = obj.get_string_member("bitfield")
            };
            liststore.set (@"$(ip):$(port)", peersrow);
        }
        return liststore;
    }

    private string aria_tell_status (string gid, TellStatus type) {
        string result = get_soupmess (@"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.tellStatus\", \"params\":[\"$(gid)\", [\"$(gid)\", \"$(type.to_string ())\"]]}");
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        try {
            MatchInfo match_info;
            Regex regex = new Regex (@"\"$(type.to_string ())\":\"(.*?)\"");
            if (regex.match_full (result, -1, 0, 0, out match_info)) {
                string tellus = match_info.fetch (1);
                if (tellus != null) {
                    return tellus;
                }
            }
        } catch (Error e) {
            GLib.warning (e.message);
        }
        return "";
    }

    private string aria_v2_status (string gid) {
        string result = get_soupmess (@"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.tellStatus\", \"params\":[\"$(gid)\"]}");
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        return result;
    }

    private string aria_tell_bittorent (string gid, TellBittorrent tellbit) {
        string json_text = get_soupmess (@"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.tellStatus\", \"params\":[\"$(gid)\", [\"$(gid)\", \"bittorrent\"]]}");
        if (!json_text.down ().contains ("result") || json_text == null) {
            return "";
        }
        var parser = new Json.Parser();
        try {
            parser.load_from_data(json_text);
        } catch (Error e) {
            return "";
        }
        var root = parser.get_root().get_object();
        if (!root.has_member("result")) {
            return "";
        }
        var result = root.get_object_member("result");
        if (!result.has_member("bittorrent")) {
            return "";
        }
        var bt = result.get_object_member("bittorrent");
        if (tellbit == TellBittorrent.NAME) {
            if (bt.has_member("info")) {
                var info = bt.get_object_member("info");
                if (info.has_member("name")) {
                    return info.get_string_member("name");
                } else {
                    return "";
                }
            }
        } else if (tellbit == TellBittorrent.MODE) {
            if (bt.has_member("mode")) {
                return bt.get_string_member("mode");
            } else {
                return "";
            }
        } else if (tellbit == TellBittorrent.COMMENT) {
            if (bt.has_member("comment")) {
                return bt.get_string_member("comment");
            } else {
                return "";
            }
        } else if (tellbit == TellBittorrent.ANNOUNCELIST) {
            if (bt.has_member("announceList")) {
                var sb = new StringBuilder();
                var al = bt.get_array_member("announceList");
                for (uint i = 0; i < al.get_length(); i++) {
                    var tier = al.get_array_element(i);
                    for (uint j = 0; j < tier.get_length(); j++) {
                        sb.append(tier.get_string_element(j)).append("\n");
                    }
                }
                return sb.str.strip();
            } else {
                return "";
            }
        } else if (tellbit == TellBittorrent.CREATIONDATE) {
            if (bt.has_member("creationDate")) {
                int64 ts = bt.get_int_member("creationDate");
                return ts.to_string ();
            } else {
                return "";
            }
        }
        return "";
    }

    private Gee.ArrayList<string> aria_tell_active () {
        var listgid = new Gee.ArrayList<string> ();
        string json_text = get_soupmess ("{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.tellActive\"}");
        if (!json_text.down ().contains ("result") || json_text == null) {
            return listgid;
        }
        var parser = new Json.Parser();
        try {
            parser.load_from_data(json_text);
        } catch (Error e) {
            return listgid;
        }
        var root = parser.get_root().get_object();
        if (!root.has_member("result")) {
            return listgid;
        }
        var result = root.get_array_member("result");
        for (uint i = 0; i < result.get_length(); i++) {
            var obj = result.get_object_element(i);
            if (obj.has_member("gid")) {
                listgid.add (obj.get_string_member("gid"));
            } else {
                return listgid;
            }
        }
        return listgid;
    }

    private int aria_tell_wait () {
        int real_waiting = 0;
        string json_text = get_soupmess ("{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.tellWaiting\", \"params\":[0, 1000]}");
        if (!json_text.down ().contains ("result") || json_text == null) {
            return real_waiting;
        }
        var parser = new Json.Parser();
        try {
            parser.load_from_data(json_text);
        } catch (Error e) {
            return real_waiting;
        }
        var root = parser.get_root().get_object();
        if (!root.has_member("result")) {
            return real_waiting;
        }
        var result = root.get_array_member("result");
        for (uint i = 0; i < result.get_length(); i++) {
            var item = result.get_object_element(i);
            string status = item.get_string_member("status");
            if (status == "waiting") {
                real_waiting++;
            }
        }
        return real_waiting;
    }

    private string aria_files_store (string ariagid) {
        string result =  get_soupmess (@"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.getFiles\", \"params\":[\"$(ariagid)\"]}").strip();
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        return result;
    }

    private Gee.HashMap<int, RowServer> aria_servers_store (string gid) {
        var serverstore = new Gee.HashMap<int, RowServer> ();
        string result = get_soupmess (@"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.getServers\", \"params\":[\"$(gid)\"]}");
        if (!result.down ().contains ("result") || result == null) {
            return serverstore;
        }
        try {
            MatchInfo match_info;
            Regex regex = new Regex ("{\"currentUri\":\"(.*?)\".*?\"downloadSpeed\":\"(.*?)\".*?\"uri\":\"(.*?)\"");
            if (regex.match_full (result, -1, 0, 0, out match_info)) {
                int index = 0;
                while (match_info.matches ()) {
                    var curi = match_info.fetch (1);
                    var serverrow = new RowServer (index) {
                        uriserver = match_info.fetch (3),
                        downloadspeed = GLib.format_size (int64.parse (match_info.fetch (2))),
                        currenturi = curi != null? GLib.Markup.escape_text (curi.replace ("\\/", "/")) : curi
                    };
                    serverstore.set (index, serverrow);
                    index++;
                    match_info.next ();
                }
            }
        } catch (Error e) {
            GLib.warning (e.message);
        }
        return serverstore;
    }

    private string aria_get_option (string gid, AriaOptions option) {
        string result = get_soupmess (@"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.getOption\", \"params\":[\"$(gid)\"]}");
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        try {
            MatchInfo match_info;
            Regex regex = new Regex (@"\"$(option.to_string ())\":\"(.*?)\"");
            if (regex.match_full (result, -1, 0, 0, out match_info)) {
                string ariaopt = match_info.fetch (1);
                if (ariaopt != null) {
                    return ariaopt;
                }
            }
        } catch (Error e) {
            GLib.warning (e.message);
        }
        return "";
    }

    private string aria_set_option (string gid, AriaOptions option, string value) {
        string result = get_soupmess (@"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.changeOption\", \"params\":[\"$(gid)\", {\"$(option.to_string ())\":\"$(value)\"}]}");
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        return result_ret (result);
    }

    private string aria_get_globalops (AriaOptions option) {
        string result = get_soupmess ("{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.getGlobalOption\"}");
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        try {
            MatchInfo match_info;
            Regex regex = new Regex (@"\"$(option.to_string ())\":\"(.*?)\"");
            if (regex.match_full (result, -1, 0, 0, out match_info)) {
                return match_info.fetch (1);
            }
        } catch (Error e) {
            GLib.warning (e.message);
        }
        return "";
    }

    private string aria_v2_globalops () {
        string result = get_soupmess ("{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.getGlobalOption\"}");
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        return result;
    }

    private string aria_set_globalops (AriaOptions option, string value) {
        string result = get_soupmess (@"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.changeGlobalOption\", \"params\":[{\"$(option.to_string ())\":\"$(value)\"}]}");
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        return result_ret (result);
    }

    private string aria_deleteresult (string gid) {
        string result = get_soupmess (@"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.purgeDownloadResult\", \"params\":[\"$(gid)\"]}");
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        return result_ret (result);
    }

    private string[] aria_globalstat ( ) {
        string[] stats = null;
        string result = get_soupmess ("{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.getGlobalStat\"}");
        if (!result.down ().contains ("result") || result == null) {
            return stats;
        }
        int waiting = aria_tell_wait ();
        try {
            var parser = new Json.Parser ();
            parser.load_from_data (result);
            var objres = parser.get_root ().get_object ().get_object_member ("result");
            stats += objres.get_string_member("downloadSpeed");
            stats += objres.get_string_member("uploadSpeed");
            stats += objres.get_string_member("numActive");
            stats += waiting.to_string ();
            stats += objres.get_string_member("numStopped");
            stats += objres.get_string_member("numStoppedTotal");
            return stats;
        } catch (Error e) {
            GLib.warning (e.message);
        }
        return stats;
    }

    public int actwaiting () {
        var global = aria_globalstat ();
        int totalact = int.parse (global[GlobalStat.NUMACTIVE]) + int.parse (global[GlobalStat.NUMWAITING]);
        return totalact;
    }

    private async void open_fileman (string fileuri) throws Error {
        yield AppInfo.launch_default_for_uri_async (fileuri, null);
    }

    private async void start_engine () throws Error {
        if (engine.is_running ()) {
            engine.stop ();
        }
        if (ariacll != null) {
            Idle.add ((owned)ariacll);
        }
        setjsonrpchost ();
        engine.add_option("enable-rpc", "true");
        engine.add_option("rpc-listen-port", get_dbsetting (DBSettings.RPCPORT));
        engine.add_option("check-certificate", "false");
        engine.add_option("rpc-listen-all", "true");
        engine.add_option("rpc-allow-origin-all", "true");
        engine.add_option("quiet", "true");
        engine.add_option("continue", "true");
        engine.add_option("disk-cache", get_dbsetting (DBSettings.DISKCACHE));
        engine.add_option("file-allocation", get_dbsetting (DBSettings.FILEALLOCATION).down ());
        engine.add_option("dht-listen-port", get_dbsetting (DBSettings.DHTLISTENPORT));
        engine.add_option("listen-port", get_dbsetting (DBSettings.BTLISTENPORT));
        engine.add_option("rpc-max-request-size", get_dbsetting (DBSettings.RPCSIZE));
        ariacll = start_engine.callback;
        if (engine.start () == 0) {
            aria_set_globalops(AriaOptions.MAX_CONNECTION_PER_SERVER, get_dbsetting (DBSettings.CONNSERVER));
            aria_set_globalops(AriaOptions.MAX_TRIES, get_dbsetting (DBSettings.MAXTRIES));
            aria_set_globalops(AriaOptions.TIMEOUT, get_dbsetting (DBSettings.TIMEOUT));
            aria_set_globalops(AriaOptions.RETRY_WAIT, get_dbsetting (DBSettings.RETRY));
            aria_set_globalops(AriaOptions.BT_MAX_PEERS, get_dbsetting (DBSettings.BTMAXPEERS));
            aria_set_globalops(AriaOptions.BT_TRACKER_TIMEOUT, get_dbsetting (DBSettings.BTTIMEOUTTRACK));
            aria_set_globalops(AriaOptions.MAX_CONCURRENT_DOWNLOADS, get_dbsetting (DBSettings.MAXACTIVE));
            aria_set_globalops(AriaOptions.SPLIT, get_dbsetting (DBSettings.SPLIT));
            aria_set_globalops(AriaOptions.BT_MAX_OPEN_FILES, get_dbsetting (DBSettings.MAXOPENFILE));
            aria_set_globalops(AriaOptions.SEED_TIME, get_dbsetting (DBSettings.SEEDTIME));
            aria_set_globalops(AriaOptions.ALLOW_OVERWRITE, get_dbsetting (DBSettings.OVERWRITE));
            aria_set_globalops(AriaOptions.AUTO_FILE_RENAMING, get_dbsetting (DBSettings.AUTORENAMING));
            aria_set_globalops(AriaOptions.MAX_OVERALL_UPLOAD_LIMIT, get_dbsetting (DBSettings.UPLOADLIMIT));
            aria_set_globalops(AriaOptions.MAX_OVERALL_DOWNLOAD_LIMIT, get_dbsetting (DBSettings.DOWNLOADLIMIT));
            aria_set_globalops(AriaOptions.BT_TRACKER, get_dbsetting (DBSettings.BTTRACKER));
            aria_set_globalops(AriaOptions.BT_EXCLUDE_TRACKER, get_dbsetting (DBSettings.BTTRACKEREXC));
            aria_set_globalops(AriaOptions.MIN_SPLIT_SIZE, get_dbsetting (DBSettings.SPLITSIZE));
            aria_set_globalops(AriaOptions.LOWEST_SPEED_LIMIT, get_dbsetting (DBSettings.LOWESTSPEED));
            aria_set_globalops(AriaOptions.URI_SELECTOR, get_dbsetting (DBSettings.URISELECTOR));
            aria_set_globalops(AriaOptions.STREAM_PIECE_SELECTOR, get_dbsetting (DBSettings.PIECESELECTOR));
            aria_set_globalops(AriaOptions.OPTIMIZE_CONCURRENT_DOWNLOADS, get_dbsetting (DBSettings.OPTIMIZEDOW));
            aria_set_globalops(AriaOptions.DIR, get_dbsetting (DBSettings.DIR));
            yield;
        }
    }

    private void glob_to_opt (string ariagid) {
        if (get_dbsetting (DBSettings.MAXTRIES) != aria_get_option (ariagid, AriaOptions.MAX_TRIES)) {
            aria_set_option (ariagid, AriaOptions.MAX_TRIES, get_dbsetting (DBSettings.MAXTRIES));
        }
        if (get_dbsetting (DBSettings.CONNSERVER) != aria_get_option (ariagid, AriaOptions.MAX_CONNECTION_PER_SERVER)) {
            aria_set_option (ariagid, AriaOptions.MAX_CONNECTION_PER_SERVER, get_dbsetting (DBSettings.CONNSERVER));
        }
        if (get_dbsetting (DBSettings.TIMEOUT) != aria_get_option (ariagid, AriaOptions.TIMEOUT)) {
            aria_set_option (ariagid, AriaOptions.TIMEOUT, get_dbsetting (DBSettings.TIMEOUT));
        }
        if (get_dbsetting (DBSettings.RETRY) != aria_get_option (ariagid, AriaOptions.RETRY_WAIT)) {
            aria_set_option (ariagid, AriaOptions.RETRY_WAIT, get_dbsetting (DBSettings.RETRY));
        }
        if (get_dbsetting (DBSettings.BTMAXPEERS) != aria_get_option (ariagid, AriaOptions.BT_MAX_PEERS)) {
            aria_set_option (ariagid, AriaOptions.BT_MAX_PEERS, get_dbsetting (DBSettings.BTMAXPEERS));
        }
        if (get_dbsetting (DBSettings.BTTIMEOUTTRACK) != aria_get_option (ariagid, AriaOptions.BT_TRACKER_TIMEOUT)) {
            aria_set_option (ariagid, AriaOptions.BT_TRACKER_TIMEOUT, get_dbsetting (DBSettings.BTTIMEOUTTRACK));
        }
        if (get_dbsetting (DBSettings.SPLIT) != aria_get_option (ariagid, AriaOptions.SPLIT)) {
            aria_set_option (ariagid, AriaOptions.SPLIT, get_dbsetting (DBSettings.SPLIT));
        }
        if (get_dbsetting (DBSettings.SEEDTIME) != aria_get_option (ariagid, AriaOptions.SEED_TIME)) {
            aria_set_option (ariagid, AriaOptions.SEED_TIME, get_dbsetting (DBSettings.SEEDTIME));
        }
        if (get_dbsetting (DBSettings.OVERWRITE) != aria_get_option (ariagid, AriaOptions.ALLOW_OVERWRITE)) {
            aria_set_option (ariagid, AriaOptions.ALLOW_OVERWRITE, get_dbsetting (DBSettings.OVERWRITE));
        }
        if (get_dbsetting (DBSettings.AUTORENAMING) != aria_get_option (ariagid, AriaOptions.AUTO_FILE_RENAMING)) {
            aria_set_option (ariagid, AriaOptions.AUTO_FILE_RENAMING, get_dbsetting (DBSettings.AUTORENAMING));
        }
        if (get_dbsetting (DBSettings.BTTRACKER) != aria_get_option (ariagid, AriaOptions.BT_TRACKER)) {
            aria_set_option (ariagid, AriaOptions.BT_TRACKER, get_dbsetting (DBSettings.BTTRACKER));
        }
        if (get_dbsetting (DBSettings.BTTRACKEREXC) != aria_get_option (ariagid, AriaOptions.BT_EXCLUDE_TRACKER)) {
            aria_set_option (ariagid, AriaOptions.BT_EXCLUDE_TRACKER, get_dbsetting (DBSettings.BTTRACKEREXC));
        }
        if (get_dbsetting (DBSettings.SPLITSIZE) != aria_get_option (ariagid, AriaOptions.MIN_SPLIT_SIZE)) {
            aria_set_option (ariagid, AriaOptions.MIN_SPLIT_SIZE, get_dbsetting (DBSettings.SPLITSIZE));
        }
        if (get_dbsetting (DBSettings.LOWESTSPEED) != aria_get_option (ariagid, AriaOptions.LOWEST_SPEED_LIMIT)) {
            aria_set_option (ariagid, AriaOptions.LOWEST_SPEED_LIMIT, get_dbsetting (DBSettings.LOWESTSPEED));
        }
        if (get_dbsetting (DBSettings.URISELECTOR) != aria_get_option (ariagid, AriaOptions.URI_SELECTOR)){
            aria_set_option (ariagid, AriaOptions.URI_SELECTOR, get_dbsetting (DBSettings.URISELECTOR));
        }
        if (get_dbsetting (DBSettings.PIECESELECTOR) != aria_get_option (ariagid, AriaOptions.STREAM_PIECE_SELECTOR)) {
            aria_set_option (ariagid, AriaOptions.STREAM_PIECE_SELECTOR, get_dbsetting (DBSettings.PIECESELECTOR));
        }
        if (get_dbsetting (DBSettings.OPTIMIZEDOW) != aria_get_option (ariagid, AriaOptions.OPTIMIZE_CONCURRENT_DOWNLOADS)) {
            aria_set_option (ariagid, AriaOptions.OPTIMIZE_CONCURRENT_DOWNLOADS, get_dbsetting (DBSettings.OPTIMIZEDOW));
        }
    }

    private string pharse_tells (string status, TellStatus type) {
        try {
            MatchInfo match_info;
            Regex regex = new Regex (@"\"$(type.to_string ())\":\"(.*?)\"");
            if (regex.match_full (status, -1, 0, 0, out match_info)) {
                string tellus = match_info.fetch (1);
                if (tellus != null) {
                    return tellus;
                }
            }
        } catch (Error e) {
            GLib.warning (e.message);
        }
        return "";
    }

    private string pharse_files (string status, AriaGetfiles files) {
        try {
            MatchInfo match_info;
            Regex regex = new Regex (@"\"$(files.to_string ())\":\"(.*?)\"");
            if (regex.match_full (status, -1, 0, 0, out match_info)) {
                string getfile = match_info.fetch (1);
                if (getfile != "" || getfile != null) {
                    return getfile.contains ("\\/")? getfile.replace ("\\/", "/") : getfile;
                }
            }
        } catch (Error e) {
            GLib.warning (e.message);
        }
        return "";
    }

    private string pharse_options (string status, AriaOptions option) {
        try {
            MatchInfo match_info;
            Regex regex = new Regex (@"\"$(option.to_string ())\":\"(.*?)\"");
            if (regex.match_full (status, -1, 0, 0, out match_info)) {
                return match_info.fetch (1);
            }
        } catch (Error e) {
            GLib.warning (e.message);
        }
        return "";
    }

    public static string sanitize_filename (string name, int max_bytes = 200) {
        if (name == null || name == "") {
            return "output.mp4";
        }
        StringBuilder sb = new StringBuilder ();
        for (int i = 0; i < name.length; i++) {
            char c = name[i];
            if ((int)c < 32 || c == 127 ||
                c == ':' || c == '*' || c == '?' ||
                c == '"' || c == '<' || c == '>' ||
                c == '|' || c == '/' || c == '\\' ||
                c == '\n' || c == '\r' || c == '\t') {
                sb.append_c ('_');
            } else {
                sb.append_c (c);
            }
        }
        string cleaned = sb.str.strip ();
        while (cleaned.length > 0 && (cleaned.has_suffix (" ") || cleaned.has_suffix ("."))) {
            cleaned = cleaned.substring (0, cleaned.length - 1);
        }
        if (cleaned == "") {
            return "output.mp4";
        }
        string ext = ".mp4";
        int dot = cleaned.last_index_of_char ('.');
        if (dot > 0 && (cleaned.length - dot) <= 10) {
            ext = cleaned.substring (dot);
            cleaned = cleaned.substring (0, dot);
        }
        if (cleaned.length > max_bytes) {
            cleaned = cleaned.substring (0, max_bytes);
        }
        return cleaned + ext;
    }

    public static string sanitize_output_path (string full_path, int max_bytes = 200) {
        if (full_path == null || full_path == "") {
            return "output.mp4";
        }
        string dir = GLib.Path.get_dirname (full_path);
        string bases = GLib.Path.get_basename (full_path);
        string safe_name = sanitize_filename (bases, max_bytes);
        if (dir == "." || dir == "") {
            return safe_name;
        }
        return GLib.Path.build_filename (dir, safe_name);
    }

    private GLib.Icon get_icon_for_filename(string filename) {
        if (filename == null || filename == "") {
            return new ThemedIcon ("text-x-generic");
        }
        string? content_type = GLib.ContentType.guess(filename, null, null);
        if (content_type == null) {
            return new ThemedIcon ("text-x-generic");
        }
        return GLib.ContentType.get_icon(content_type);
    }

    private string[] normalize_aria2_path(string full_path, Json.Array result_array) {
        if (full_path == null || full_path == "") {
            return new string[0];
        }
        string path = full_path.replace("\\/", "/");
        if (path.has_prefix("/")) {
            path = path.substring(1);
        }
        string[] parts = path.split("/");
        if (result_array.get_length() == 1) {
            return new string[] { parts[parts.length - 1] };
        }
        Json.Object? first = result_array.get_object_element(0);
        if (first == null) {
            return parts;
        }
        Json.Node? pnode = first.get_member("path");
        if (pnode == null) {
            return parts;
        }
        string base_path = pnode.get_string().replace("\\/", "/");
        if (base_path.has_prefix("/")) {
            base_path = base_path.substring(1);
        }
        string[] bases = base_path.split("/");
        int common_len = bases.length;

        for (uint i = 1; i < result_array.get_length(); i++) {
            Json.Object? obj = result_array.get_object_element(i);
            if (obj == null) {
                continue;
            }
            Json.Node? n = obj.get_member("path");
            if (n == null) {
                continue;
            }
            string cur_path = n.get_string().replace("\\/", "/");
            if (cur_path.has_prefix("/")) {
                cur_path = cur_path.substring(1);
            }
            string[] cur = cur_path.split("/");

            int j = 0;
            while (j < common_len && j < cur.length && bases[j] == cur[j]) {
                j++;
            }
            common_len = j;
        }
        if (common_len < parts.length) {
            int new_len = parts.length - common_len;
            string[] outs = new string[new_len];
            for (int i = 0; i < new_len; i++) {
                outs[i] = parts[common_len + i];
            }
            return outs;
        }
        return new string[] { parts[parts.length - 1] };
    }

    private void move_window (Gtk.Window window, Gtk.Widget widget) {
        Gtk.GestureClick click = new Gtk.GestureClick() {
            button = Gdk.BUTTON_PRIMARY
        };
        double start_x = 0;
        double start_y = 0;
        click.pressed.connect((n, x, y) => {
            start_x = x;
            start_y = y;
        });
        Gtk.GestureDrag drag = new Gtk.GestureDrag();
        drag.drag_begin.connect((x, y) => {
            start_x = x;
            start_y = y;
        });
        drag.drag_update.connect((offset_x, offset_y) => {
            Gdk.Surface surface = window.get_surface();
            if (surface != null) {
                Gdk.Toplevel toplevel = (Gdk.Toplevel)surface;
                toplevel.begin_move(Gdk.Display.get_default().get_default_seat().get_pointer(), 1, (int)(start_x + offset_x), (int)(start_y + offset_y), Gdk.CURRENT_TIME);
            }
        });
        widget.add_controller(click);
        widget.add_controller(drag);
    }

    public string fix_path(string dirty_path) {
        try {
            var regex = new Regex ("\\\\/"); 
            string clean = regex.replace(dirty_path, -1, 0, "/");
            var regex_double = new Regex ("//+");
            clean = regex_double.replace(clean, -1, 0, "/");
            return clean;
        } catch (RegexError e) {
            return dirty_path;
        }
    }

    private int get_container (File file) {
        int n_files = 0;
        try {
            FileEnumerator enumerator = file.enumerate_children ("standard::name,standard::type,standard::is-hidden", FileQueryInfoFlags.NOFOLLOW_SYMLINKS);
            FileInfo info;
            while (enumerator.iterate (out info, null) && info != null) {
                if (info.get_is_hidden ()) {
                    continue;
                }
                n_files++;
            }
        } catch (Error e) {
            GLib.warning (e.message);
        }
        return n_files;
    }

    private async void open_file (Soup.ServerMessage msg, GLib.File file) throws Error {
        var info = file.query_info ("standard::content-type,standard::size", FileQueryInfoFlags.NONE);
        int64 file_size = info.get_size ();
        string mime = info.get_content_type ();
        var headers = msg.get_response_headers ();
        string? range_header = msg.get_request_headers ().get_one ("Range");
        int64 start = 0;
        int64 end = file_size - 1;
        bool is_partial = false;
        if (range_header != null && range_header.has_prefix ("bytes=")) {
            is_partial = true;
            var range_val = range_header.substring (6);
            var parts = range_val.split ("-", 2);
            if (parts.length == 2) {
                if (parts[0] != "") {
                    start = int64.parse (parts[0]);
                }
                if (parts[1] != "") {
                    end = int64.parse (parts[1]);
                } else {
                    end = file_size - 1;
                }
            }
            if (start < 0) {
                start = 0;
            }
            if (end >= file_size) {
                end = file_size - 1;
            }
            if (start > end) {
                start = 0;
            }
        }
        if (is_partial) {
            const int64 MAX_CHUNK = 2 * 1024 * 1024;
            if ((end - start + 1) > MAX_CHUNK) {
                end = start + MAX_CHUNK - 1;
            }
            if (end >= file_size) {
                end = file_size - 1;
            }
            if (start > end) {
                start = 0;
            }
        }
        int64 chunk_size = end - start + 1;
        var input = file.read ();
        ((GLib.Seekable) input).seek (start, GLib.SeekType.SET);
        uint8[] buffer = new uint8[chunk_size];
        size_t bytes_read = 0;
        input.read_all (buffer, out bytes_read);
        input.close ();
        var sparams = new HashTable<string, string> (str_hash, str_equal);
        sparams.insert ("charset", "utf-8");
        headers.set_content_type (mime, sparams);
        headers.set_content_length ((int64) bytes_read);
        headers.replace ("Accept-Ranges", "bytes");
        headers.replace ("Cache-Control", "no-store");
        if (is_partial) {
            headers.set_content_range (start, start + (int64) bytes_read - 1, file_size);
            msg.set_status (Soup.Status.PARTIAL_CONTENT, "Partial Content");
        } else {
            msg.set_status (Soup.Status.OK, "OK");
        }
        msg.set_response (mime, Soup.MemoryUse.COPY, buffer[0:bytes_read]);
    }

    private async void write_file (GLib.Bytes bytes, string filename) throws Error {
        var file = File.new_for_path (filename);
        GLib.FileOutputStream out_stream = yield file.create_async (FileCreateFlags.REPLACE_DESTINATION, GLib.Priority.DEFAULT, null);
        out_stream.write (bytes.get_data ());
        out_stream.close ();
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

    public string info_succes (string data, InfoSucces succes) {
        return data.split ("<gabut>")[succes];
    }

    private string fixtoformat (string input) {
        if (input == null || input.length == 0) {
            return "";
        }
        string cleaned = input.strip ();
        try {
            var regex = new Regex ("\\s+");
            string[] parts = regex.split (cleaned);
            var list = new Gee.ArrayList<string> ();
            foreach (string p in parts) {
                string s = p.strip ();
                if (s != "") {
                    list.add (s);
                }
            }
            return string.joinv (",", list.to_array ());
        } catch (Error e) {
            return cleaned.replace ("\n", ",").replace (" ", "");
        }
    }

    private void set_account (Gtk.Grid usergrid, UsersID user, int rowpos) {
        var user_entry = new MediaEntry.activable ("avatar-default", "process-stop") {
            width_request = 300,
            margin_bottom = 4,
            text = user.user,
            secondary_icon_name = user.activate? "media-playback-start" : "process-stop",
            secondary_icon_tooltip_text = !user.activate? _("Reject") : _("Accept")
        };
        bool activable = user.activate;
        user_entry.icon_press.connect ((icp)=> {
            if (icp == Gtk.EntryIconPosition.SECONDARY) {
                activable = !activable;
                user_entry.secondary_icon_name = activable? "media-playback-start" : "process-stop";
                user_entry.secondary_icon_tooltip_text = !activable? _("Reject") : _("Accept");
                update_user_id (user.id, UserID.ACTIVE, activable.to_string ());               
            }
        });
        user_entry.changed.connect (()=> {
            update_user_id (user.id, UserID.USER, user_entry.text);
        });
        var pass_entry = new MediaEntry.activable ("dialog-password", "com.github.gabutakut.gabutdm.delete") {
            width_request = 300,
            margin_bottom = 4,
            secondary_icon_tooltip_text = _("Delete Authentication"),
            text = user.passwd
        };
        pass_entry.changed.connect (()=> {
            update_user_id (user.id, UserID.PASSWD, pass_entry.text);
        });
        pass_entry.icon_press.connect ((icp)=> {
            if (icp == Gtk.EntryIconPosition.SECONDARY) {
                remove_user (user.id);
                usergrid.remove (user_entry);
                usergrid.remove (pass_entry);
                user_entry.destroy ();
                pass_entry.destroy ();
            }
        });
        usergrid.attach (user_entry, 0, rowpos);
        usergrid.attach (pass_entry, 1, rowpos);
    }

    private string get_shorted (int sort, string username) {
        return int.parse (get_db_user (UserID.SHORTBY, username)) == sort? "selected>" : @"value=\"$(sort)\">";
    }

    private string get_mime_type (File fileinput) {
        if (!fileinput.query_exists ()) {
            return "";
        }
        try {
            FileInfo infos = fileinput.query_info (GLib.FileAttribute.STANDARD_CONTENT_TYPE, GLib.FileQueryInfoFlags.NOFOLLOW_SYMLINKS);
            return infos.get_content_type ();
        } catch (Error e) {
            GLib.warning (e.message);
            return "";
        }
    }

    private string config_folder (string folder) {
        var config_dir = File.new_build_filename (Environment.get_user_config_dir (), folder);
        if (!config_dir.query_exists ()) {
            try {
                config_dir.make_directory_with_parents ();
            } catch (Error e) {
                warning (e.message);
            }
        }
        return config_dir.get_path ();
    }

    private string file_config (string name) {
        return GLib.Path.build_filename (config_folder (Environment.get_application_name ()), Environment.get_application_name () + name);
    }

    private async void fetch_data (string url, string filename) throws Error {
        Soup.Session session = new Soup.Session ();
        try {
            var msg = new Soup.Message ("GET", url);
            var bytes = yield session.send_and_read_async (msg, Soup.MessagePriority.NORMAL, null);
            write_file.begin (bytes, filename);
        } catch (Error e) {
            if (session != null) {
                session.abort ();
                session = null;
            }
            warning (e.message);
        } finally {
            if (session != null) {
                session.abort ();
                session = null;
            }
        }
    }

    private Soup.Message full_message (string method, string url, string useragt) throws Error {
        var message = new Soup.Message(method, url);
        message.request_headers.append("User-Agent", useragt);
        message.request_headers.append("Accept", "*/*");
        message.request_headers.append("Accept-Encoding", "identity");
        message.request_headers.append("Connection", "keep-alive");
        var uri = GLib.Uri.parse(url, GLib.UriFlags.NONE);
        if (uri != null && uri.get_scheme() != null && uri.get_host() != null) {
            message.request_headers.append("Origin", "%s://%s".printf(uri.get_scheme(), uri.get_host()));
            message.request_headers.append("Referer", "%s://%s/".printf(uri.get_scheme(), uri.get_host()));
        }
        return message;
    }

    private string? ext_filename (string uri) {
        string without_ext;
        int last_dot = uri.last_index_of (".", 0);
        int last_slash = uri.last_index_of ("/", 0);

        if (last_dot < last_slash) {
            without_ext = uri;
        } else {
            without_ext = uri.slice (0, last_dot);
        }
        return without_ext + ".mp4";
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
        GLib.Application.get_default ().send_notification (Environment.get_application_name (), notification);
    }

    private Gtk.Widget headerlabel (string label, int wrequest) {
        var hlabel = new Gtk.Label (label) {
            width_request = wrequest,
            attributes = set_attribute (Pango.Weight.SEMIBOLD),
            halign = Gtk.Align.START,
            xalign = 0,
            margin_top = 6,
            margin_bottom = 6
        };
        return hlabel;
    }

    private int sort_a (DeAscend deascending) {
        if (deascending == DeAscend.ASCENDING) {
            return 1;
        } else {
            return -1;
        }
    }

    private int sort_b (DeAscend deascending) {
        if (deascending == DeAscend.DESCENDING) {
            return 1;
        } else {
            return -1;
        }
    }

    private static void play_sound (string canbera) {
        if (!bool.parse (get_dbsetting (DBSettings.NOTIFSOUND))) {
            return;
        }
        Canberra.Context context;
        Canberra.Proplist props;
        Canberra.Context.create (out context);
        Canberra.Proplist.create (out props);
        props.sets (Canberra.PROP_EVENT_ID, canbera);
        props.sets (Canberra.PROP_CANBERRA_CACHE_CONTROL, "permanent");
        props.sets (Canberra.PROP_MEDIA_ROLE, "event");
        context.play_full (0, props);
    }

    private async GLib.File[]? run_open_file (Gtk.Window window, OpenFiles location) throws Error {
        var torrent = new Gtk.FileFilter ();
        torrent.set_filter_name (_("Torrent"));
        torrent.add_mime_type ("application/x-bittorrent");
        var metalink = new Gtk.FileFilter ();
        metalink.set_filter_name (_("Metalink"));
        metalink.add_pattern ("application/metalink+xml");
        metalink.add_pattern ("application/metalink4+xml");
        var lstore = new GLib.ListStore (typeof (Gtk.FileFilter));
        lstore.append (torrent);
        lstore.append (metalink);
        var fdrecently = File.new_for_path (get_db_lastop (location));
        var filechooser = new Gtk.FileDialog () {
            title = _("Open Torrent Or Metalink"),
            accept_label = _("Open"),
            filters = lstore,
            initial_folder = fdrecently.query_exists (null)? fdrecently : null
        };
        var listmodel = yield filechooser.open_multiple (window, null);
        GLib.File[] nfiles = null;
        for (int i = 0; i < listmodel.get_n_items (); i++) {
            nfiles += (File) listmodel.get_item (i);
        }
        if (!db_lastop_exist (location)) {
            add_db_lastop (location, nfiles[0].get_parent ().get_path ());
        } else {
            update_lastop_id (location, nfiles[0].get_parent ().get_path ());
        }
        return nfiles;
    }

    private async GLib.File? run_open_text (Gtk.Window window, OpenFiles location) throws Error {
        var text_filter = new Gtk.FileFilter ();
        text_filter.set_filter_name (_("Text"));
        text_filter.add_mime_type ("text/*");
        var lstore = new GLib.ListStore (typeof (Gtk.FileFilter));
        lstore.append (text_filter);
        var fdrecently = File.new_for_path (get_db_lastop (location));
        var filechooser = new Gtk.FileDialog () {
            title = _("Open Text"),
            accept_label = _("Open"),
            filters = lstore,
            initial_folder = fdrecently.query_exists (null)? fdrecently : null
        };
        var file = yield filechooser.open (window, null);
        if (!db_lastop_exist (location)) {
            add_db_lastop (location, file.get_parent ().get_path ());
        } else {
            update_lastop_id (location, file.get_parent ().get_path ());
        }
        return file;
    }

    private async GLib.File? run_open_fd (Gtk.Window window, OpenFiles location, string path) throws Error {
        var fdrecently = File.new_for_path (path == ""? get_db_lastop (location) : path);
        var filechooser = new Gtk.FileDialog () {
            title = _("Open Folder"),
            accept_label = _("Open"),
            initial_folder = fdrecently.query_exists (null)? fdrecently : null
        };
        var file = yield filechooser.select_folder (window, null);
        if (!db_lastop_exist (location)) {
            add_db_lastop (location, file.get_path ());
        } else {
            update_lastop_id (location, file.get_path ());
        }
        return file;
    }

    private Gtk.Grid button_chooser (GLib.File file, int widtc = 35) {
        var grid = new Gtk.Grid () {
            valign = Gtk.Align.CENTER,
            halign = Gtk.Align.START,
            column_spacing = 5
        };
        var img = new Gtk.Image.from_gicon (GLib.ContentType.get_icon (get_mime_type (file))) {
            icon_size = Gtk.IconSize.NORMAL
        };
        var tittle = new Gtk.Label (file.get_basename ()) {
            wrap_mode = Pango.WrapMode.WORD_CHAR,
            ellipsize = Pango.EllipsizeMode.MIDDLE,
            xalign = 0,
            max_width_chars = widtc,
            attributes = set_attribute (Pango.Weight.BOLD)
        };
        grid.attach (img, 0, 0);
        grid.attach (tittle, 1, 0);
        return grid;
    }

    private bool is_archive_mime (string mime) {
        return mime == "application/zip" ||
            mime == "application/x-zip-compressed" ||
            mime == "application/x-tar" ||
            mime == "application/x-gzip" ||
            mime == "application/gzip" ||
            mime == "application/x-bzip2" ||
            mime == "application/x-xz" ||
            mime == "application/x-7z-compressed" ||
            mime == "application/x-rar" ||
            mime == "application/vnd.rar" ||
            mime == "application/x-rar-compressed";
    }

    private string get_mime_css (string mime) {
        if (mime.contains ("image/")) {
            return "image";
        } else if (mime.contains ("audio/")) {
            return "audio";
        } else if (mime.contains ("script") || mime.contains ("json") || mime.contains ("yaml") || mime.contains ("xml")) {
            return "code";
        } else if (mime.contains ("font/")) {
            return "font";
        } else if (mime.contains ("video/")) {
            return "video";
        } else if (mime.contains ("text/")) {
            return "text";
        } else if (mime.contains ("pdf")) {
            return "pdf";
        } else if (mime.contains ("directory")) {
            return "folder";
        } else if (mime.contains ("translation")) {
            return "po";
        } else if (is_archive_mime (mime)) {
            return "archive";
        } else {
            return "file";
        }
    }

    private bool is_text_mime (string mime) {
        return mime.has_prefix ("text/") || mime == "application/json" || mime == "application/xml" || mime == "application/javascript" || mime == "application/x-shellscript" || mime == "application/x-sh";
    }

    private bool mime_is_doc (string mime) {
        if (mime == "application/msword" || mime == "application/vnd.openxmlformats-officedocument.wordprocessingml.document") {
            return true;
        }
        return false;
    }

    private bool is_text_ext (string filename) {
        var lower = filename.down ();
        return lower.has_suffix (".txt") ||
        lower.has_suffix (".md") ||
        lower.has_suffix (".log") ||
        lower.has_suffix (".json") ||
        lower.has_suffix (".xml") ||
        lower.has_suffix (".yaml") ||
        lower.has_suffix (".yml") ||
        lower.has_suffix (".toml") ||
        lower.has_suffix (".ini") ||
        lower.has_suffix (".conf") ||
        lower.has_suffix (".cfg") ||
        lower.has_suffix (".sh") ||
        lower.has_suffix (".bash") ||
        lower.has_suffix (".py") ||
        lower.has_suffix (".js") ||
        lower.has_suffix (".css") ||
        lower.has_suffix (".html") ||
        lower.has_suffix (".htm") ||
        lower.has_suffix (".c") ||
        lower.has_suffix (".cpp") ||
        lower.has_suffix (".h") ||
        lower.has_suffix (".vala") ||
        lower.has_suffix (".java") ||
        lower.has_suffix (".kt") ||
        lower.has_suffix (".rs") ||
        lower.has_suffix (".go") ||
        lower.has_suffix (".php") ||
        lower.has_suffix (".rb") ||
        lower.has_suffix (".swift")||
        lower.has_suffix (".dart") ||
        lower.has_suffix (".lua") ||
        lower.has_suffix (".sql") ||
        lower.has_suffix (".srt") ||
        lower.has_suffix (".csv");
    }

    private string get_lang_from_ext (string filename) {
        var lower = filename.down ();
        if (lower.has_suffix (".json")) return "json";
        if (lower.has_suffix (".xml") || lower.has_suffix (".html") || lower.has_suffix (".htm")) return "xml";
        if (lower.has_suffix (".yaml") || lower.has_suffix (".yml")) return "yaml";
        if (lower.has_suffix (".md")) return "markdown";
        if (lower.has_suffix (".sh") || lower.has_suffix (".bash")) return "bash";
        if (lower.has_suffix (".py")) return "python";
        if (lower.has_suffix (".js")) return "javascript";
        if (lower.has_suffix (".css")) return "css";
        if (lower.has_suffix (".c") || lower.has_suffix (".h") || lower.has_suffix (".cpp")) return "cpp";
        if (lower.has_suffix (".vala")) return "vala";
        if (lower.has_suffix (".java")) return "java";
        if (lower.has_suffix (".kt")) return "kotlin";
        if (lower.has_suffix (".rs")) return "rust";
        if (lower.has_suffix (".go")) return "go";
        if (lower.has_suffix (".php")) return "php";
        if (lower.has_suffix (".rb")) return "ruby";
        if (lower.has_suffix (".sql")) return "sql";
        if (lower.has_suffix (".toml") || lower.has_suffix (".ini") || lower.has_suffix (".conf") || lower.has_suffix (".cfg")) return "ini";
        return "plaintext";
    }

    private string get_mime_css_from_name (string filename) {
        var lower = filename.down ();
        if (lower.has_suffix (".mp4") || lower.has_suffix (".mkv") ||
            lower.has_suffix (".avi") || lower.has_suffix (".mov") ||
            lower.has_suffix (".webm")) return "video";
        if (lower.has_suffix (".mp3") || lower.has_suffix (".flac") ||
            lower.has_suffix (".ogg") || lower.has_suffix (".wav") ||
            lower.has_suffix (".m4a"))  return "audio";
        if (lower.has_suffix (".jpg") || lower.has_suffix (".jpeg") ||
            lower.has_suffix (".png") || lower.has_suffix (".gif") ||
            lower.has_suffix (".webp") || lower.has_suffix (".svg") ||
            lower.has_suffix (".avif")) return "image";
        if (lower.has_suffix (".pdf"))  return "pdf";
        if (lower.has_suffix (".js") || lower.has_suffix (".ts") ||
            lower.has_suffix (".py") || lower.has_suffix (".vala") ||
            lower.has_suffix (".c") || lower.has_suffix (".cpp") ||
            lower.has_suffix (".json") || lower.has_suffix (".xml") ||
            lower.has_suffix (".yaml") || lower.has_suffix (".html") ||
            lower.has_suffix (".css"))  return "code";
        if (lower.has_suffix (".txt") || lower.has_suffix (".md") ||
            lower.has_suffix (".log"))  return "text";
        return "file";
    }

    private bool is_excel_ext (string filename) {
        var lower = filename.down ();
        return lower.has_suffix (".xlsx") ||
            lower.has_suffix (".xlsm") ||
            lower.has_suffix (".ods") ||
            lower.has_suffix (".xls");
    }

    private bool is_archive_ext (string filename) {
        var lower = filename.down ();
        return lower.has_suffix (".zip") ||
            lower.has_suffix (".tar") ||
            lower.has_suffix (".gz") ||
            lower.has_suffix (".tgz") ||
            lower.has_suffix (".bz2") ||
            lower.has_suffix (".xz") ||
            lower.has_suffix (".7z") ||
            lower.has_suffix (".rar") ||
            lower.has_suffix (".tar.gz") ||
            lower.has_suffix (".tar.bz2") ||
            lower.has_suffix (".tar.xz");
    }

    private bool name_is_doc (string name) {
        if (name.has_suffix (".docx") ||
        name.has_suffix (".doc") ||
        name.has_suffix (".odt")) {
            return true;
        }
        return false;
    }

    private bool is_audio_ext (string filename) {
        var lower = filename.down ();
        return lower.has_suffix (".mp3") ||
            lower.has_suffix (".flac") ||
            lower.has_suffix (".ogg") ||
            lower.has_suffix (".wav") ||
            lower.has_suffix (".m4a") ||
            lower.has_suffix (".aac") ||
            lower.has_suffix (".opus") ||
            lower.has_suffix (".wma");
    }

    private bool is_video_ext (string filename) {
        var lower = filename.down ();
        return lower.has_suffix (".mp4") ||
            lower.has_suffix (".mkv") ||
            lower.has_suffix (".avi") ||
            lower.has_suffix (".mov") ||
            lower.has_suffix (".webm") ||
            lower.has_suffix (".m3u8") ||
            lower.has_suffix (".flv") ||
            lower.has_suffix (".ts") ||
            lower.has_suffix (".m4v");
    }

    private bool is_pptx_ext (string filename) {
        var lower = filename.down ();
        return lower.has_suffix (".pptx") ||
            lower.has_suffix (".ppt")  ||
            lower.has_suffix (".odp");
    }

    private bool nameisplay (string name) {
        if (is_archive_ext (name) ||
        is_excel_ext (name) ||
        name.has_suffix (".torrent") ||
        is_video_ext (name) ||
        name_is_doc (name) ||
        is_pptx_ext (name) ||
        is_text_ext (name)) {
            return true;
        }
        return false;
    }

    private bool mimeisplay (string mime) {
        if (is_archive_mime (mime) ||
        mime.has_prefix ("video/") ||
        mime.has_prefix ("image/") ||
        mime == "application/pdf" ||
        mime.has_prefix ("audio/") ||
        mime_is_doc (mime) || 
        is_archive_mime (mime) ||
        is_text_mime (mime)) {
            return true;
        }
        return false;
    }

    private void server_torr_files(Gee.ArrayList<TrFileInfo> files, Gee.ArrayList<TorrentFile?> fileap) {
        foreach (TrFileInfo file in files) {
            if (file.is_folder) {
                server_torr_files(file.children, fileap);
            } else {
                TorrentFile tf = { file.path, file.size };
                fileap.add (tf);
            }
        }
    }

    private Gtk.IconPaintable? load_icon_paintable (string icon_name, int size) {
        var theme = Gtk.IconTheme.get_for_display (Gdk.Display.get_default ());
        return theme.lookup_icon (icon_name, null, size, 1, Gtk.TextDirection.NONE, Gtk.IconLookupFlags.FORCE_REGULAR);
    }

    public bool match_keycode (uint keyval, uint code) {
        Gdk.KeymapKey [] keys;
        if (Gdk.Display.get_default ().map_keyval (keyval, out keys)) {
            foreach (var key in keys) {
                if (code == key.keycode) {
                    return true;
                }
            }
        }
        return false;
    }

    private int open_database (out Sqlite.Database db) {
        int opendb = 0;
        if (!GLib.FileUtils.test (file_config (".db"), GLib.FileTest.EXISTS)) {
            opendb = creat_no_exist (out db);
        } else {
            opendb = Sqlite.Database.open (file_config (".db"), out db);
        }
        return opendb;
    }

    private int creat_no_exist (out Sqlite.Database db) {
        int opendb = Sqlite.Database.open (file_config (".db"), out db);
        if (opendb != Sqlite.OK) {
            warning ("Can't open database: %s\n", db.errmsg ());
        }
        opendb = table_proxy (db);
        opendb = table_users (db);
        opendb = last_opened (db);
        opendb = table_download (db);
        opendb = table_options (db);
        opendb = table_settings (db);
        return opendb;
    }

    private int table_proxy (Sqlite.Database db) {
        return db.exec (@"CREATE TABLE IF NOT EXISTS proxy (
            id             INT64   NOT NULL,
            typepr         INT     NOT NULL,
            host           TEXT    NOT NULL,
            port           TEXT    NOT NULL,
            user           TEXT    NOT NULL,
            passwd         TEXT    NOT NULL);
            INSERT INTO proxy (id, typepr, host, port, user, passwd)
            VALUES (1, 0, \"\", \"\", \"\", \"\");");
    }

    private int table_users (Sqlite.Database db) {
        return db.exec (@"CREATE TABLE IF NOT EXISTS users (
            id             INT64   NOT NULL,
            active         TEXT    NOT NULL,
            user           TEXT    NOT NULL,
            passwd         TEXT    NOT NULL,
            shortby        TEXT    NOT NULL);
            INSERT INTO users (id, active, user, passwd, shortby)
            VALUES (1, \"true\", \"gabutdm\", \"123456\", \"1\");");
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
            fileordir      TEXT    NOT NULL,
            labeltransfer  TEXT    NOT NULL,
            timeadded      INT64   NOT NULL,
            bitfield       TEXT    NOT NULL,
            piececount     INT     NOT NULL,
            errorcode      TEXT    NOT NULL);");
    }

    private int last_opened (Sqlite.Database db) {
        string dir = Environment.get_user_special_dir (GLib.UserDirectory.DOWNLOAD);
        return db.exec (@"CREATE TABLE IF NOT EXISTS lastop (
            id             INT64   NOT NULL,
            folderloc      TEXT    NOT NULL);
            INSERT INTO users (id, folderloc)
            VALUES (1, \"$(dir)\");");
    }

    private int table_options (Sqlite.Database db) {
        return db.exec ("CREATE TABLE IF NOT EXISTS options (
            id             INTEGER PRIMARY KEY AUTOINCREMENT,
            url            TEXT    NOT NULL,
            magnetbackup   TEXT    NOT NULL,
            torrentbackup  TEXT    NOT NULL,
            proxy          TEXT    NOT NULL,
            proxyusr       TEXT    NOT NULL,
            proxypass      TEXT    NOT NULL,
            httpusr        TEXT    NOT NULL,
            httppass       TEXT    NOT NULL,
            ftpusr         TEXT    NOT NULL,
            ftppass        TEXT    NOT NULL,
            dir            TEXT    NOT NULL,
            cookie         TEXT    NOT NULL,
            referer        TEXT    NOT NULL,
            useragent      TEXT    NOT NULL,
            out            TEXT    NOT NULL,
            proxymethod    TEXT    NOT NULL,
            selectfile     TEXT    NOT NULL,
            checksum       TEXT    NOT NULL,
            cryptolvl      TEXT    NOT NULL,
            requirecryp    TEXT    NOT NULL,
            integrity      TEXT    NOT NULL,
            unverified     TEXT    NOT NULL,
            proxytype      TEXT    NOT NULL,
            selected       TEXT    NOT NULL,
            header         TEXT    NOT NULL);");
    }

    private int table_settings (Sqlite.Database db) {
        string dir = Environment.get_user_special_dir (GLib.UserDirectory.DOWNLOAD);
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
            startup        TEXT    NOT NULL,
            style          TEXT    NOT NULL,
            uploadlimit    TEXT    NOT NULL,
            downloadlimit  TEXT    NOT NULL,
            btlistenport   TEXT    NOT NULL,
            dhtlistenport  TEXT    NOT NULL,
            bttracker      TEXT    NOT NULL,
            bttrackerexc   TEXT    NOT NULL,
            splitsize      TEXT    NOT NULL,
            lowestspeed    TEXT    NOT NULL,
            uriselector    TEXT    NOT NULL,
            pieceselector  TEXT    NOT NULL,
            clipboard      TEXT    NOT NULL,
            sharedir       TEXT    NOT NULL,
            switchdir      TEXT    NOT NULL,
            sortby         TEXT    NOT NULL,
            ascedescen     TEXT    NOT NULL,
            showtime       TEXT    NOT NULL,
            showdate       TEXT    NOT NULL,
            dbusmenu       TEXT    NOT NULL,
            tdefault       TEXT    NOT NULL,
            notifsound     TEXT    NOT NULL,
            menuindicator  TEXT    NOT NULL,
            labelmode      TEXT    NOT NULL,
            themeselect    TEXT    NOT NULL,
            themecustom    TEXT    NOT NULL,
            lastclipboard  TEXT    NOT NULL,
            optimizedow    TEXT    NOT NULL,
            hlsparallelcon TEXT    NOT NULL,
            hlsactive      TEXT    NOT NULL,
            hlstimeout     TEXT    NOT NULL,
            hlsretries     TEXT    NOT NULL);
            INSERT INTO settings (id, rpcport, maxtries, connserver, timeout, dir, retry, rpcsize, btmaxpeers, diskcache, maxactive, bttimeouttrack, split, maxopenfile, dialognotif, systemnotif, onbackground, iplocal, portlocal, seedtime, overwrite, autorenaming, allocation, startup, style, uploadlimit, downloadlimit, btlistenport, dhtlistenport, bttracker, bttrackerexc, splitsize, lowestspeed, uriselector, pieceselector, clipboard, sharedir, switchdir, sortby, ascedescen, showtime, showdate, dbusmenu, tdefault, notifsound, menuindicator, labelmode, themeselect, themecustom, lastclipboard, optimizedow, hlsparallelcon, hlsactive, hlstimeout, hlsretries)
            VALUES (1, \"6807\", \"5\", \"6\", \"60\", \"$(dir.replace ("/", "\\/"))\", \"0\", \"2097152\", \"55\", \"16777216\", \"5\", \"60\", \"5\", \"100\", \"true\", \"true\", \"true\", \"true\", \"2021\", \"0\", \"false\", \"false\", \"None\", \"true\", \"1\", \"128000\", \"0\", \"21301\", \"26701\", \"\", \"\", \"20971520\", \"0\", \"feedback\", \"default\", \"true\", \"$(dir)\", \"false\", \"0\", \"0\", \"false\", \"false\", \"false\", \"false\", \"false\", \"false\", \"0\", \"0\" ,\"Breeze\", \"\", \"false\", \"4\", \"1\", \"2000\", \"2\");");
    }

    private void settings_table () {
        if ((db_get_cols ("settings") - 1) != DBSettings.HLSRETRIES) {
            gabutdb.exec ("DROP TABLE settings;");
            table_settings (gabutdb);
        }
        if (db_get_cols ("lastop") < OpenFiles.OPENPERDONLOADFOLDER) {
            gabutdb.exec ("DROP TABLE lastop;");
            last_opened (gabutdb);
        }
        if (db_get_cols ("users") < UserID.ACTIVE) {
            gabutdb.exec ("DROP TABLE users;");
            table_users (gabutdb);
        }
        if (db_get_cols ("proxy") <  DBMyproxy.PASSWD) {
            gabutdb.exec ("DROP TABLE proxy;");
            table_proxy (gabutdb);
        }
    }

    private void download_table () {
        if ((db_get_cols ("download") - 1) != DBDownload.ERRORCODE) {
            gabutdb.exec ("DROP TABLE download;");
            table_download (gabutdb);
        }
        if ((db_get_cols ("options") - 1) != DBOption.HEADER) {
            gabutdb.exec ("DROP TABLE options;");
            table_options (gabutdb);
        }
    }

    private int db_get_cols (string opt) {
        int ncols;
        string errmsg;
        int res = gabutdb.get_table (@"SELECT * FROM $(opt)", null, null, out ncols, out errmsg);
        if (res != Sqlite.OK) {
            warning ("Error: %s", errmsg);
        }
        return ncols;
    }

    private int64 add_db_lastop (int64 id, string flocation) {
        Sqlite.Statement stmt;
        int res = gabutdb.prepare_v2 ("INSERT OR IGNORE INTO lastop (id, folderloc) VALUES (?, ?);", -1, out stmt);
        res = stmt.bind_int64 (1, id);
        res = stmt.bind_text (2, flocation);
        if ((res = stmt.step ()) != Sqlite.DONE) {
            warning ("Error: %d: %s", gabutdb.errcode (), gabutdb.errmsg ());
        }
        stmt.reset ();
        return id;
    }

    private void update_lastop_id (OpenFiles id, string flocation) {
        Sqlite.Statement stmt;
        int res = gabutdb.prepare_v2 (@"UPDATE lastop SET folderloc = \"$(flocation)\" WHERE id = ?", -1, out stmt);
        res = stmt.bind_int64 (1, id);
        if ((res = stmt.step ()) != Sqlite.DONE) {
            warning ("Error: %d: %s", gabutdb.errcode (), gabutdb.errmsg ());
        }
        stmt.reset ();
    }

    private bool db_lastop_exist (OpenFiles id) {
        Sqlite.Statement stmt;
        int res = gabutdb.prepare_v2 ("SELECT * FROM lastop WHERE id = ?", -1, out stmt);
        res = stmt.bind_int64 (1, id);
        if ((res = stmt.step ()) == Sqlite.ROW) {
            return true;
        }
        stmt.reset ();
        return false;
    }

    private string get_db_lastop (OpenFiles type) {
        Sqlite.Statement stmt;
        int res = gabutdb.prepare_v2 ("SELECT * FROM lastop WHERE id = ?", -1, out stmt);
        stmt.bind_int64 (1, type);
        if ((res = stmt.step ()) == Sqlite.ROW) {
            return stmt.column_text (1);
        }
        return "";
    }

    private int64 add_db_user (int64 id) {
        Sqlite.Statement stmt;
        int res = gabutdb.prepare_v2 ("INSERT OR IGNORE INTO users (id, active, user, passwd, shortby) VALUES (?, ?, ?, ?, ?);", -1, out stmt);
        res = stmt.bind_int64 (1, id);
        res = stmt.bind_text (2, "false");
        res = stmt.bind_text (3, "");
        res = stmt.bind_text (4, "");
        res = stmt.bind_text (5, "1");
        if ((res = stmt.step ()) != Sqlite.DONE) {
            warning ("Error: %d: %s", gabutdb.errcode (), gabutdb.errmsg ());
        }
        stmt.reset ();
        return id;
    }

    private void remove_user (int64 id) {
        Sqlite.Statement stmt;
        int res = gabutdb.prepare_v2 ("DELETE FROM users WHERE id = ?", -1, out stmt);
        res = stmt.bind_int64 (1, id);
        if ((res = stmt.step ()) != Sqlite.DONE) {
            warning ("Error: %d: %s", gabutdb.errcode (), gabutdb.errmsg ());
        }
        stmt.reset ();
    }

    private GLib.List<UsersID?> get_users () {
        var usersid = new GLib.List<UsersID?> ();
        Sqlite.Statement? stmt;
        int res = gabutdb.prepare_v2 ("SELECT id, active, user, passwd FROM users ORDER BY id;", -1, out stmt);
        if (res != Sqlite.OK) {
            warning ("Error: %d: %s", gabutdb.errcode (), gabutdb.errmsg ());
        }
        while (stmt.step () == Sqlite.ROW) {
            var users = UsersID ();
            users.id = stmt.column_int64 (0);
            users.activate = bool.parse (stmt.column_text (1));
            users.user = stmt.column_text (2);
            users.passwd = stmt.column_text (3);
            usersid.append (users);
        }
        stmt.reset ();
        return usersid;
    }

    private void update_user (string user, UserID type, string value) {
        Sqlite.Statement stmt;
        int res = gabutdb.prepare_v2 (@"UPDATE users SET $(type.get_str ()) = \"$(value)\" WHERE user = ?", -1, out stmt);
        res = stmt.bind_text (1, user);
        if ((res = stmt.step ()) != Sqlite.DONE) {
            warning ("Error: %d: %s", gabutdb.errcode (), gabutdb.errmsg ());
        }
        stmt.reset ();
    }

    private void update_user_id (int64 id, UserID type, string value) {
        Sqlite.Statement stmt;
        int res = gabutdb.prepare_v2 (@"UPDATE users SET $(type.get_str ()) = \"$(value)\" WHERE id = ?", -1, out stmt);
        res = stmt.bind_int64 (1, id);
        if ((res = stmt.step ()) != Sqlite.DONE) {
            warning ("Error: %d: %s", gabutdb.errcode (), gabutdb.errmsg ());
        }
        stmt.reset ();
    }

    private string get_db_user (UserID type, string user) {
        Sqlite.Statement stmt;
        int res = gabutdb.prepare_v2 ("SELECT * FROM users WHERE user = ?", -1, out stmt);
        stmt.bind_text (1, user);
        if ((res = stmt.step ()) == Sqlite.ROW) {
            return stmt.column_text (type);
        }
        return "";
    }

    private SavedProxy? get_myproxy () {
        Sqlite.Statement stmt;
        int res = gabutdb.prepare_v2 ("SELECT id, typepr, host, port, user, passwd FROM proxy ORDER BY id;", -1, out stmt);
        if (res != Sqlite.OK) {
            warning ("Error: %d: %s", gabutdb.errcode (), gabutdb.errmsg ());
        }
        var users = SavedProxy ();
        while (stmt.step () == Sqlite.ROW) {
            users.id = stmt.column_int64 (0);
            users.typepr = stmt.column_int (1);
            users.host = stmt.column_text (2);
            users.port = stmt.column_text (3);
            users.user = stmt.column_text (4);
            users.passwd = stmt.column_text (5);
        }
        return users;
    }

    private string set_myproxy (DBMyproxy type, string value) {
        Sqlite.Statement stmt;
        int res = gabutdb.prepare_v2 (@"UPDATE proxy SET $(type.to_string ()) = \"$(value)\" WHERE id = ?", -1, out stmt);
        res = stmt.bind_int (1, 1);
        if ((res = stmt.step ()) != Sqlite.DONE) {
            warning ("Error: %d: %s", gabutdb.errcode (), gabutdb.errmsg ());
        }
        stmt.reset ();
        return value;
    }

    private string get_dbsetting (DBSettings type) {
        Sqlite.Statement stmt;
        int res = gabutdb.prepare_v2 ("SELECT * FROM settings WHERE id = ?", -1, out stmt);
        stmt.bind_int (1, 1);
        if ((res = stmt.step ()) == Sqlite.ROW) {
            return stmt.column_text (type);
        }
        return "";
    }

    private string set_dbsetting (DBSettings type, string value) {
        Sqlite.Statement stmt;
        int res = gabutdb.prepare_v2 (@"UPDATE settings SET $(type.to_string ()) = \"$(value)\" WHERE id = ?", -1, out stmt);
        res = stmt.bind_int (1, 1);
        if ((res = stmt.step ()) != Sqlite.DONE) {
            warning ("Error: %d: %s", gabutdb.errcode (), gabutdb.errmsg ());
        }
        stmt.reset ();
        return value;
    }

    private void set_download (GLib.List<DownloadRow> downloads) {
        foreach (var download in downloads) {
            if (db_download_exist (download.url)) {
                update_download (download);
            } else {
                add_db_download (download);
            }
        }
    }

    private void add_db_download (DownloadRow download) {
        int64 new_id = get_next_available_id ("download");
        Sqlite.Statement stmt;
        string sql = "INSERT OR IGNORE INTO download (id, url, status, ariagid, filepath, filename, totalsize, transferrate, transferred, linkmode, fileordir, labeltransfer, timeadded, bitfield, piececount, errorcode) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
        int res = gabutdb.prepare_v2 (sql, -1, out stmt);
        res = stmt.bind_int64 (DBDownload.ID+1, new_id);
        res = stmt.bind_text (DBDownload.URL+1, download.url);
        res = stmt.bind_int (DBDownload.STATUS+1, download.status);
        res = stmt.bind_text (DBDownload.ARIAGID+1, download.ariagid);
        res = stmt.bind_text (DBDownload.FILEPATH+1, download.filepath == null? "" : download.filepath);
        res = stmt.bind_text (DBDownload.FILENAME+1, download.filename == null? "" : download.filename);
        res = stmt.bind_int64 (DBDownload.TOTALSIZE+1, download.totalsize);
        res = stmt.bind_int (DBDownload.TRANSFERRATE+1, download.transferrate);
        res = stmt.bind_int64 (DBDownload.TRANSFERRED+1, download.transferred);
        res = stmt.bind_int (DBDownload.LINKMODE+1, download.linkmode);
        res = stmt.bind_text (DBDownload.FILEORDIR+1, download.fileordir == null? "" : download.fileordir);
        res = stmt.bind_text (DBDownload.LABELTRANSFER+1, download.labeltransfer == null? "" : download.labeltransfer);
        res = stmt.bind_int64 (DBDownload.TIMEADDED+1, download.timeadded);
        res = stmt.bind_text (DBDownload.BITFIELD+1, download.bitfield == null? "" : download.bitfield);
        res = stmt.bind_int (DBDownload.PIECECOUNT+1, download.piececount);
        res = stmt.bind_text (DBDownload.ERRORCODE+1, download.errorcode == null? "" : download.errorcode);
        if ((res = stmt.step ()) != Sqlite.DONE) {
            warning ("Error: %d: %s", gabutdb.errcode (), gabutdb.errmsg ());
        }
        stmt.reset ();
    }

    private void update_download (DownloadRow download) {
        Sqlite.Statement stmt;
        var buildstr = new StringBuilder ();
        buildstr.append ("UPDATE download SET");
        uint empty_hash = buildstr.str.hash ();
        int res = gabutdb.prepare_v2 ("SELECT * FROM download WHERE url = ?", -1, out stmt);
        res = stmt.bind_text (DBDownload.URL, download.url);
        if ((res = stmt.step ()) == Sqlite.ROW) {
            if (stmt.column_int (DBDownload.STATUS) != download.status) {
                buildstr.append (@" $(DBDownload.STATUS.to_string ()) = $(download.status)");
            }
            if (stmt.column_text (DBDownload.ARIAGID) != download.ariagid && download.ariagid != null) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                buildstr.append (@" $(DBDownload.ARIAGID.to_string ()) = \"$(download.ariagid)\"");
            }
            if (stmt.column_text (DBDownload.FILEPATH) != download.filepath && download.filepath != null) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                buildstr.append (@" $(DBDownload.FILEPATH.to_string ()) = \"$(download.filepath)\"");
            }
            if (stmt.column_text (DBDownload.FILENAME) != download.filename && download.filename != null) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                buildstr.append (@" $(DBDownload.FILENAME.to_string ()) = \"$(download.filename)\"");
            }
            if (stmt.column_int64 (DBDownload.TOTALSIZE) != download.totalsize) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                buildstr.append (@" $(DBDownload.TOTALSIZE.to_string ()) = $(download.totalsize)");
            }
            if (stmt.column_int (DBDownload.TRANSFERRATE) != download.transferrate) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                buildstr.append (@" $(DBDownload.TRANSFERRATE.to_string ()) = $(download.transferrate)");
            }
            if (stmt.column_int64 (DBDownload.TRANSFERRED) != download.transferred) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                buildstr.append (@" $(DBDownload.TRANSFERRED.to_string ()) = $(download.transferred)");
            }
            if (stmt.column_int (DBDownload.LINKMODE) != download.linkmode) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                buildstr.append (@" $(DBDownload.LINKMODE.to_string ()) = $(download.linkmode)");
            }
            if (stmt.column_text (DBDownload.FILEORDIR) != download.fileordir && download.fileordir != null) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                buildstr.append (@" $(DBDownload.FILEORDIR.to_string ()) = \"$(download.fileordir)\"");
            }
            if (stmt.column_text (DBDownload.LABELTRANSFER) != download.labeltransfer && download.labeltransfer != null) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                buildstr.append (@" $(DBDownload.LABELTRANSFER.to_string ()) = \"$(download.labeltransfer)\"");
            }
            if (stmt.column_int64 (DBDownload.TIMEADDED) != download.timeadded) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                buildstr.append (@" $(DBDownload.TIMEADDED.to_string ()) = \"$(download.timeadded)\"");
            }
            if (stmt.column_text (DBDownload.BITFIELD) != download.bitfield && download.bitfield != null) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                buildstr.append (@" $(DBDownload.BITFIELD.to_string ()) = \"$(download.bitfield)\"");
            }
            if (stmt.column_int (DBDownload.PIECECOUNT) != download.piececount) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                buildstr.append (@" $(DBDownload.PIECECOUNT.to_string ()) = \"$(download.piececount)\"");
            }
            if (stmt.column_text (DBDownload.ERRORCODE) != download.errorcode && download.errorcode != null) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                buildstr.append (@" $(DBDownload.ERRORCODE.to_string ()) = \"$(download.errorcode)\"");
            }
            if (buildstr.str.hash () == empty_hash) {
                return;
            }
        }
        buildstr.append (" WHERE url = ?");
        res = gabutdb.prepare_v2 (buildstr.str, -1, out stmt);
        res = stmt.bind_text (DBDownload.URL, download.url);
        if ((res = stmt.step ()) != Sqlite.DONE) {
            warning ("Error: %d: %s", gabutdb.errcode (), gabutdb.errmsg ());
        }
        stmt.reset ();
    }

    private void remove_download (string url) {
        Sqlite.Statement stmt;
        int res = gabutdb.prepare_v2 ("DELETE FROM download WHERE url = ?", -1, out stmt);
        res = stmt.bind_text (DBDownload.URL, url);
        if ((res = stmt.step ()) != Sqlite.DONE) {
            warning ("Error: %d: %s", gabutdb.errcode (), gabutdb.errmsg ());
        }
        stmt.reset ();
    }

    private GLib.List<DownloadRow> get_download () {
        var downloads = new GLib.List<DownloadRow> ();
        Sqlite.Statement stmt;
        int res = gabutdb.prepare_v2 ("SELECT id, url, status, ariagid, filepath, filename, totalsize, transferrate, transferred, linkmode, fileordir, labeltransfer, timeadded, bitfield, piececount, errorcode FROM download ORDER BY url;", -1, out stmt);
        if (res != Sqlite.OK) {
            warning ("Error: %d: %s", gabutdb.errcode (), gabutdb.errmsg ());
        }
        while (stmt.step () == Sqlite.ROW) {
            downloads.append (new DownloadRow.Smt (stmt));
        }
        stmt.reset ();
        return downloads;
    }

    private bool db_download_exist (string url) {
        Sqlite.Statement stmt;
        int res = gabutdb.prepare_v2 ("SELECT * FROM download WHERE url = ?", -1, out stmt);
        res = stmt.bind_text (DBDownload.URL, url);
        if ((res = stmt.step ()) == Sqlite.ROW) {
            return true;
        }
        stmt.reset ();
        return false;
    }

    private Gee.HashMap<string, string> get_dboptions (string url) {
        Gee.HashMap<string, string> hashoption = new Gee.HashMap<string, string> ();
        Sqlite.Statement stmt;
        int res = gabutdb.prepare_v2 ("SELECT * FROM options WHERE url = ?", -1, out stmt);
        res = stmt.bind_text (DBOption.URL, url);
        if ((res = stmt.step ()) == Sqlite.ROW) {
            string dir = stmt.column_text (DBOption.DIR);
            if (dir != "") {
                hashoption[AriaOptions.DIR.to_string ()] = dir;
            }
            string cookie = stmt.column_text (DBOption.COOKIE);
            if (cookie != "") {
                hashoption[AriaOptions.COOKIE.to_string ()] = cookie;
            }
            string referer = stmt.column_text (DBOption.REFERER);
            if (referer != "") {
                hashoption[AriaOptions.REFERER.to_string ()] = referer;
            }
            string magnetbackup = stmt.column_text (DBOption.MAGNETBACKUP);
            if (magnetbackup != "") {
                hashoption[AriaOptions.BT_SAVE_METADATA.to_string ()] = magnetbackup;
            }
            string torrent = stmt.column_text (DBOption.TORRENTBACKUP);
            if (torrent != "") {
                hashoption[AriaOptions.RPC_SAVE_UPLOAD_METADATA.to_string ()] = torrent;
            }
            string proxytype = stmt.column_text (DBOption.PROXYTYPE);
            if (proxytype != "" && proxytype != "NOTSET") {
                string proxy = stmt.column_text (DBOption.PROXY);
                string proxuser = stmt.column_text (DBOption.PROXYUSER);
                string proxypass = stmt.column_text (DBOption.PROXYPASSWORD);
                if (proxytype.down () == "all") {
                    if (proxy != "NOTSET" && proxy != "") {
                        hashoption[AriaOptions.PROXY.to_string ()] = proxy;
                        if (proxuser != "NOTSET" && proxuser != "") {
                            hashoption[AriaOptions.PROXYUSER.to_string ()] = proxuser;
                        }
                        if (proxypass != "NOTSET" && proxypass != "") {
                            hashoption[AriaOptions.PROXYPASSWORD.to_string ()] = proxypass;
                        }
                    }
                } else if (proxytype.down () == "ftp") {
                    hashoption[AriaOptions.FTP_PROXY.to_string ()] = proxy;
                    if (proxuser != "NOTSET" && proxuser != "") {
                        hashoption[AriaOptions.FTP_PROXY_USER.to_string ()] = proxuser;
                    }
                    if (proxypass != "NOTSET" && proxypass != "") {
                        hashoption[AriaOptions.FTP_PROXY_PASSWD.to_string ()] = proxypass;
                    }
                } else if (proxytype.down () == "http") {
                    hashoption[AriaOptions.HTTP_PROXY.to_string ()] = proxy;
                    if (proxuser != "NOTSET" && proxuser != "") {
                        hashoption[AriaOptions.HTTP_PROXY_USER.to_string ()] = proxuser;
                    }
                    if (proxypass != "NOTSET" && proxypass != "") {
                        hashoption[AriaOptions.HTTP_PROXY_PASSWD.to_string ()] = proxypass;
                    }
                } else if (proxytype.down () == "https") {
                    hashoption[AriaOptions.HTTPS_PROXY.to_string ()] = proxy;
                    if (proxuser != "NOTSET" && proxuser != "") {
                        hashoption[AriaOptions.HTTPS_PROXY_USER.to_string ()] = proxuser;
                    }
                    if (proxypass != "NOTSET" && proxypass != "") {
                        hashoption[AriaOptions.HTTPS_PROXY_PASSWD.to_string ()] = proxypass;
                    }
                }
            }
            string httpuser = stmt.column_text (DBOption.HTTPUSR);
            if (httpuser != "NOTSET" && httpuser != "") {
                hashoption[AriaOptions.HTTP_USER.to_string ()] = httpuser;
            }
            string httppass = stmt.column_text (DBOption.HTTPPASS);
            if (httppass != "NOTSET" && httppass != "") {
                hashoption[AriaOptions.HTTP_PASSWD.to_string ()] = httppass;
            }
            string ftpuser = stmt.column_text (DBOption.FTPUSR);
            if (ftpuser != "NOTSET" && ftpuser != "") {
                hashoption[AriaOptions.FTP_USER.to_string ()] = ftpuser;
            }
            string ftppass = stmt.column_text (DBOption.FTPPASS);
            if (ftppass != "NOTSET" && ftppass != "") {
                hashoption[AriaOptions.FTP_PASSWD.to_string ()] = ftppass;
            }
            string usernpagent = stmt.column_text (DBOption.USERAGENT);
            if (usernpagent != "") {
                hashoption[AriaOptions.USER_AGENT.to_string ()] = usernpagent;
            }
            string outd = stmt.column_text (DBOption.OUT);
            if (outd != "") {
                hashoption[AriaOptions.OUT.to_string ()] = outd;
            }
            string prothod = stmt.column_text (DBOption.PROXYMETHOD);
            if (prothod != "") {
                hashoption[AriaOptions.PROXY_METHOD.to_string ()] = prothod;
            }
            string selectfile = stmt.column_text (DBOption.SELECTFILE);
            if (selectfile != "") {
                hashoption[AriaOptions.SELECT_FILE.to_string ()] = selectfile;
            }
            string checksums = stmt.column_text (DBOption.CHECKSUM);
            if (checksums != "") {
                hashoption[AriaOptions.CHECKSUM.to_string ()] = checksums;
            }
            string cryptlvl = stmt.column_text (DBOption.CRYPTOLVL);
            if (cryptlvl != "") {
                hashoption[AriaOptions.BT_MIN_CRYPTO_LEVEL.to_string ()] = cryptlvl;
            }
            string requirecrtp = stmt.column_text (DBOption.REQUIRECRYP);
            if (requirecrtp != "") {
                hashoption[AriaOptions.BT_REQUIRE_CRYPTO.to_string ()] = requirecrtp;
            }
            string integrity = stmt.column_text (DBOption.INTEGRITY);
            if (integrity != "") {
                hashoption[AriaOptions.CHECK_INTEGRITY.to_string ()] = integrity;
            }
            string unverify = stmt.column_text (DBOption.UNVERIFIED);
            if (unverify != "") {
                hashoption[AriaOptions.BT_SEED_UNVERIFIED.to_string ()] = unverify;
            }
            string selected = stmt.column_text (DBOption.SELECTED);
            if (selected != "") {
                hashoption[AriaOptions.SELECT_FILE.to_string ()] = selected;
            }
            string header = stmt.column_text (DBOption.HEADER);
            if (header != "") {
                hashoption[AriaOptions.HEADER.to_string ()] = header;
            }
        }
        stmt.reset ();
        return hashoption;
    }

    private int64 get_next_available_id (string idtype) {
        int64 next_id = 1;
        string query = """
            SELECT COALESCE(
                (SELECT MIN(seq) FROM (
                    SELECT 1 AS seq
                    UNION
                    SELECT id + 1 FROM %s
                ) WHERE seq NOT IN (SELECT id FROM %s)),
            1);
        """.printf (idtype, idtype);
        Sqlite.Statement stmt;
        if (gabutdb.prepare_v2 (query, -1, out stmt) == Sqlite.OK) {
            if (stmt.step () == Sqlite.ROW) {
                next_id = stmt.column_int64 (0);
            }
        }
        return next_id;
    }

    private void set_dboptions (string url, Gee.HashMap<string, string> hashoptions) {
        int64 new_id = get_next_available_id ("options");
        Sqlite.Statement stmt;
        string sql = "INSERT OR IGNORE INTO options (id, url, magnetbackup, torrentbackup, proxy, proxyusr, proxypass, httpusr, httppass, ftpusr, ftppass, dir, cookie, referer, useragent, out, proxymethod, selectfile, checksum, cryptolvl, requirecryp, integrity, unverified, proxytype, selected, header) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
        int res = gabutdb.prepare_v2 (sql, -1, out stmt);
        res = stmt.bind_int64 (DBOption.ID+1, new_id);
        res = stmt.bind_text (DBOption.URL+1, url);
        if (hashoptions.has_key (AriaOptions.BT_SAVE_METADATA.to_string ())) {
            res = stmt.bind_text (DBOption.MAGNETBACKUP+1, hashoptions.@get (AriaOptions.BT_SAVE_METADATA.to_string ()));
        } else {
            res = stmt.bind_text (DBOption.MAGNETBACKUP+1, "false");
        }
        if (hashoptions.has_key (AriaOptions.RPC_SAVE_UPLOAD_METADATA.to_string ())) {
            res = stmt.bind_text (DBOption.TORRENTBACKUP+1, hashoptions.@get (AriaOptions.RPC_SAVE_UPLOAD_METADATA.to_string ()));
        } else {
            res = stmt.bind_text (DBOption.TORRENTBACKUP+1, "false");
        }
        if (hashoptions.has_key (AriaOptions.PROXY.to_string ())) {
            res = stmt.bind_text (DBOption.PROXY+1, hashoptions.@get (AriaOptions.PROXY.to_string ()));
            res = stmt.bind_text (DBOption.PROXYTYPE+1, "all");
        } else if (hashoptions.has_key (AriaOptions.FTP_PROXY.to_string ())) {
            res = stmt.bind_text (DBOption.PROXY+1, hashoptions.@get (AriaOptions.FTP_PROXY.to_string ()));
            res = stmt.bind_text (DBOption.PROXYTYPE+1, "ftp");
        } else if (hashoptions.has_key (AriaOptions.HTTP_PROXY.to_string ())) {
            res = stmt.bind_text (DBOption.PROXY+1, hashoptions.@get (AriaOptions.HTTP_PROXY.to_string ()));
            res = stmt.bind_text (DBOption.PROXYTYPE+1, "http");
        } else if (hashoptions.has_key (AriaOptions.HTTPS_PROXY.to_string ())) {
            res = stmt.bind_text (DBOption.PROXY+1, hashoptions.@get (AriaOptions.HTTPS_PROXY.to_string ()));
            res = stmt.bind_text (DBOption.PROXYTYPE+1, "https");
        } else {
            res = stmt.bind_text (DBOption.PROXY+1, "NOTSET");
            res = stmt.bind_text (DBOption.PROXYTYPE+1, "NOTSET");
        }
        if (hashoptions.has_key (AriaOptions.PROXYUSER.to_string ())) {
            res = stmt.bind_text (DBOption.PROXYUSER+1, hashoptions.@get (AriaOptions.PROXYUSER.to_string ()));
        } else if (hashoptions.has_key (AriaOptions.FTP_PROXY_USER.to_string ())) {
            res = stmt.bind_text (DBOption.PROXYUSER+1, hashoptions.@get (AriaOptions.FTP_PROXY_USER.to_string ()));
        } else if (hashoptions.has_key (AriaOptions.HTTP_PROXY_USER.to_string ())) {
            res = stmt.bind_text (DBOption.PROXYUSER+1, hashoptions.@get (AriaOptions.HTTP_PROXY_USER.to_string ()));
        } else if (hashoptions.has_key (AriaOptions.HTTPS_PROXY_PASSWD.to_string ())) {
            res = stmt.bind_text (DBOption.PROXYPASSWORD+1, hashoptions.@get (AriaOptions.HTTPS_PROXY_PASSWD.to_string ()));
        } else {
            res = stmt.bind_text (DBOption.PROXYUSER+1, "NOTSET");
        }
        if (hashoptions.has_key (AriaOptions.PROXYPASSWORD.to_string ())) {
            res = stmt.bind_text (DBOption.PROXYPASSWORD+1, hashoptions.@get (AriaOptions.PROXYPASSWORD.to_string ()));
        } else if (hashoptions.has_key (AriaOptions.FTP_PROXY_PASSWD.to_string ())) {
            res = stmt.bind_text (DBOption.PROXYPASSWORD+1, hashoptions.@get (AriaOptions.FTP_PROXY_PASSWD.to_string ()));
        } else if (hashoptions.has_key (AriaOptions.HTTP_PROXY_PASSWD.to_string ())) {
            res = stmt.bind_text (DBOption.PROXYPASSWORD+1, hashoptions.@get (AriaOptions.HTTP_PROXY_PASSWD.to_string ()));
        } else if (hashoptions.has_key (AriaOptions.HTTPS_PROXY_PASSWD.to_string ())) {
            res = stmt.bind_text (DBOption.PROXYPASSWORD+1, hashoptions.@get (AriaOptions.HTTPS_PROXY_PASSWD.to_string ()));
        } else {
            res = stmt.bind_text (DBOption.PROXYPASSWORD+1, "NOTSET");
        }
        if (hashoptions.has_key (AriaOptions.HTTP_USER.to_string ())) {
            res = stmt.bind_text (DBOption.HTTPUSR+1, hashoptions.@get (AriaOptions.HTTP_USER.to_string ()));
        } else {
            res = stmt.bind_text (DBOption.HTTPUSR+1, "NOTSET");
        }
        if (hashoptions.has_key (AriaOptions.HTTP_PASSWD.to_string ())) {
            res = stmt.bind_text (DBOption.HTTPPASS+1, hashoptions.@get (AriaOptions.HTTP_PASSWD.to_string ()));
        } else {
            res = stmt.bind_text (DBOption.HTTPPASS+1, "NOTSET");
        }
        if (hashoptions.has_key (AriaOptions.FTP_USER.to_string ())) {
            res = stmt.bind_text (DBOption.FTPUSR+1, hashoptions.@get (AriaOptions.FTP_USER.to_string ()));
        } else {
            res = stmt.bind_text (DBOption.FTPUSR+1, "NOTSET");
        }
        if (hashoptions.has_key (AriaOptions.FTP_PASSWD.to_string ())) {
            res = stmt.bind_text (DBOption.FTPPASS+1, hashoptions.@get (AriaOptions.FTP_PASSWD.to_string ()));
        } else {
            res = stmt.bind_text (DBOption.FTPPASS+1, "NOTSET");
        }
        if (hashoptions.has_key (AriaOptions.DIR.to_string ())) {
            res = stmt.bind_text (DBOption.DIR+1, hashoptions.@get (AriaOptions.DIR.to_string ()));
        } else {
            res = stmt.bind_text (DBOption.DIR+1, "");
        }
        if (hashoptions.has_key (AriaOptions.COOKIE.to_string ())) {
            res = stmt.bind_text (DBOption.COOKIE+1, hashoptions.@get (AriaOptions.COOKIE.to_string ()));
        } else {
            res = stmt.bind_text (DBOption.COOKIE+1, "");
        }
        if (hashoptions.has_key (AriaOptions.REFERER.to_string ())) {
            res = stmt.bind_text (DBOption.REFERER+1, hashoptions.@get (AriaOptions.REFERER.to_string ()));
        } else {
            res = stmt.bind_text (DBOption.REFERER+1, "");
        }
        if (hashoptions.has_key (AriaOptions.USER_AGENT.to_string ())) {
            res = stmt.bind_text (DBOption.USERAGENT+1, hashoptions.@get (AriaOptions.USER_AGENT.to_string ()));
        } else {
            res = stmt.bind_text (DBOption.USERAGENT+1, "");
        }
        if (hashoptions.has_key (AriaOptions.OUT.to_string ())) {
            res = stmt.bind_text (DBOption.OUT+1, hashoptions.@get (AriaOptions.OUT.to_string ()));
        } else {
            res = stmt.bind_text (DBOption.OUT+1, "");
        }
        if (hashoptions.has_key (AriaOptions.PROXY_METHOD.to_string ())) {
            res = stmt.bind_text (DBOption.PROXYMETHOD+1, hashoptions.@get (AriaOptions.PROXY_METHOD.to_string ()));
        } else {
            res = stmt.bind_text (DBOption.PROXYMETHOD+1, "");
        }
        if (hashoptions.has_key (AriaOptions.SELECT_FILE.to_string ())) {
            res = stmt.bind_text (DBOption.SELECTFILE+1, hashoptions.@get (AriaOptions.SELECT_FILE.to_string ()));
        } else {
            res = stmt.bind_text (DBOption.SELECTFILE+1, "");
        }
        if (hashoptions.has_key (AriaOptions.CHECKSUM.to_string ())) {
            res = stmt.bind_text (DBOption.CHECKSUM+1, hashoptions.@get (AriaOptions.CHECKSUM.to_string ()));
        } else {
            res = stmt.bind_text (DBOption.CHECKSUM+1, "");
        }
        if (hashoptions.has_key (AriaOptions.BT_MIN_CRYPTO_LEVEL.to_string ())) {
            res = stmt.bind_text (DBOption.CRYPTOLVL+1, hashoptions.@get (AriaOptions.BT_MIN_CRYPTO_LEVEL.to_string ()));
        } else {
            res = stmt.bind_text (DBOption.CRYPTOLVL+1, "");
        }
        if (hashoptions.has_key (AriaOptions.BT_REQUIRE_CRYPTO.to_string ())) {
            res = stmt.bind_text (DBOption.REQUIRECRYP+1, hashoptions.@get (AriaOptions.BT_REQUIRE_CRYPTO.to_string ()));
        } else {
            res = stmt.bind_text (DBOption.REQUIRECRYP+1, "");
        }
        if (hashoptions.has_key (AriaOptions.CHECK_INTEGRITY.to_string ())) {
            res = stmt.bind_text (DBOption.INTEGRITY+1, hashoptions.@get (AriaOptions.CHECK_INTEGRITY.to_string ()));
        } else {
            res = stmt.bind_text (DBOption.INTEGRITY+1, "");
        }
        if (hashoptions.has_key (AriaOptions.BT_SEED_UNVERIFIED.to_string ())) {
            res = stmt.bind_text (DBOption.UNVERIFIED+1, hashoptions.@get (AriaOptions.BT_SEED_UNVERIFIED.to_string ()));
        } else {
            res = stmt.bind_text (DBOption.UNVERIFIED+1, "");
        }
        if (hashoptions.has_key (AriaOptions.SELECT_FILE.to_string ())) {
            res = stmt.bind_text (DBOption.SELECTED+1, hashoptions.@get (AriaOptions.SELECT_FILE.to_string ()));
        } else {
            res = stmt.bind_text (DBOption.SELECTED+1, "");
        }
        if (hashoptions.has_key (AriaOptions.HEADER.to_string ())) {
            res = stmt.bind_text (DBOption.HEADER+1, hashoptions.@get (AriaOptions.HEADER.to_string ()));
        } else {
            res = stmt.bind_text (DBOption.HEADER+1, "");
        }
        if ((res = stmt.step ()) != Sqlite.DONE) {
            warning ("Error: %d: %s", gabutdb.errcode (), gabutdb.errmsg ());
        }
        stmt.reset ();
    }

    private void remove_dboptions (string url) {
        Sqlite.Statement stmt;
        int res = gabutdb.prepare_v2 ("DELETE FROM options WHERE url = ?", -1, out stmt);
        res = stmt.bind_text (DBOption.URL, url);
        if ((res = stmt.step ()) != Sqlite.DONE) {
            warning ("Error: %d: %s", gabutdb.errcode (), gabutdb.errmsg ());
        }
        stmt.reset ();
    }

    private void update_optionts (string url, Gee.HashMap<string, string> hashoptions) {
        Sqlite.Statement stmt;
        var buildstr = new StringBuilder ();
        buildstr.append ("UPDATE options SET");
        uint empty_hash = buildstr.str.hash ();
        int res = gabutdb.prepare_v2 ("SELECT * FROM options WHERE url = ?", -1, out stmt);
        res = stmt.bind_text (DBOption.URL, url);
        if ((res = stmt.step ()) == Sqlite.ROW) {
            if (hashoptions.has_key (AriaOptions.BT_SAVE_METADATA.to_string ())) {
                string magnetbackup = hashoptions.@get (AriaOptions.BT_SAVE_METADATA.to_string ());
                if (stmt.column_text (DBOption.MAGNETBACKUP) != magnetbackup) {
                    buildstr.append (@" $(DBOption.MAGNETBACKUP.to_string ()) = \"$(magnetbackup)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.RPC_SAVE_UPLOAD_METADATA.to_string ())) {
                string torrentbackup = hashoptions.@get (AriaOptions.RPC_SAVE_UPLOAD_METADATA.to_string ());
                if (stmt.column_text (DBOption.TORRENTBACKUP) != torrentbackup) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.TORRENTBACKUP.to_string ()) = \"$(torrentbackup)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.PROXY.to_string ())) {
                string prox = hashoptions.@get (AriaOptions.PROXY.to_string ());
                if (stmt.column_text (DBOption.PROXY) != prox) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXY.to_string ()) = \"$(prox)\"");
                }
                if (stmt.column_text (DBOption.PROXYTYPE) != "all") {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYTYPE.to_string ()) = \"all\"");
                }
            } else if (hashoptions.has_key (AriaOptions.FTP_PROXY.to_string ())) {
                string ftpro = hashoptions.@get (AriaOptions.FTP_PROXY.to_string ());
                if (stmt.column_text (DBOption.PROXY) != ftpro) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXY.to_string ()) = \"$(ftpro)\"");
                }
                if (stmt.column_text (DBOption.PROXYTYPE) != "ftp") {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYTYPE.to_string ()) = \"ftp\"");
                }
            } else if (hashoptions.has_key (AriaOptions.HTTP_PROXY.to_string ())) {
                string htprox = hashoptions.@get (AriaOptions.HTTP_PROXY.to_string ());
                if (stmt.column_text (DBOption.PROXY) != htprox) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXY.to_string ()) = \"$(htprox)\"");
                }
                if (stmt.column_text (DBOption.PROXYTYPE) != "http") {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYTYPE.to_string ()) = \"http\"");
                }
            } else if (hashoptions.has_key (AriaOptions.HTTPS_PROXY.to_string ())) {
                string htsprox = hashoptions.@get (AriaOptions.HTTPS_PROXY.to_string ());
                if (stmt.column_text (DBOption.PROXY) != htsprox) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXY.to_string ()) = \"$(htsprox)\"");
                }
                if (stmt.column_text (DBOption.PROXYTYPE) != "https") {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYTYPE.to_string ()) = \"https\"");
                }
            } else {
                if (stmt.column_text (DBOption.PROXY) != "NOTSET") {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXY.to_string ()) = \"NOTSET\"");
                }
                if (stmt.column_text (DBOption.PROXYTYPE) != "NOTSET") {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYTYPE.to_string ()) = \"NOTSET\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.PROXYUSER.to_string ())) {
                string proxus = hashoptions.@get (AriaOptions.PROXYUSER.to_string ());
                if (stmt.column_text (DBOption.PROXYUSER) != proxus) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYUSER.to_string ()) = \"$(proxus)\"");
                }
            } else if (hashoptions.has_key (AriaOptions.FTP_PROXY_USER.to_string ())) {
                string ftprus = hashoptions.@get (AriaOptions.FTP_PROXY_USER.to_string ());
                if (stmt.column_text (DBOption.PROXYUSER) != ftprus) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYUSER.to_string ()) = \"$(ftprus)\"");
                }
            } else if (hashoptions.has_key (AriaOptions.HTTP_PROXY_USER.to_string ())) {
                string htus = hashoptions.@get (AriaOptions.HTTP_PROXY_USER.to_string ());
                if (stmt.column_text (DBOption.PROXYUSER) != htus) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYUSER.to_string ()) = \"$(htus)\"");
                }
            } else if (hashoptions.has_key (AriaOptions.HTTPS_PROXY_USER.to_string ())) {
                string htsprus = hashoptions.@get (AriaOptions.HTTPS_PROXY_USER.to_string ());
                if (stmt.column_text (DBOption.PROXYUSER) != htsprus) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYUSER.to_string ()) = \"$(htsprus)\"");
                }
            } else {
                if (stmt.column_text (DBOption.PROXYUSER) != "NOTSET") {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYUSER.to_string ()) = \"NOTSET\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.PROXYPASSWORD.to_string ())) {
                string proxpas = hashoptions.@get (AriaOptions.PROXYPASSWORD.to_string ());
                if (stmt.column_text (DBOption.PROXYPASSWORD) != proxpas) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYPASSWORD.to_string ()) = \"$(proxpas)\"");
                }
            } else if (hashoptions.has_key (AriaOptions.FTP_PROXY_PASSWD.to_string ())) {
                string ftprops = hashoptions.@get (AriaOptions.FTP_PROXY_PASSWD.to_string ());
                if (stmt.column_text (DBOption.PROXYPASSWORD) != ftprops) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYPASSWORD.to_string ()) = \"$(ftprops)\"");
                }
            } else if (hashoptions.has_key (AriaOptions.HTTP_PROXY_PASSWD.to_string ())) {
                string htpas = hashoptions.@get (AriaOptions.HTTP_PROXY_PASSWD.to_string ());
                if (stmt.column_text (DBOption.PROXYPASSWORD) != htpas) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYPASSWORD.to_string ()) = \"$(htpas)\"");
                }
            } else if (hashoptions.has_key (AriaOptions.HTTPS_PROXY_PASSWD.to_string ())) {
                string htspas = hashoptions.@get (AriaOptions.HTTPS_PROXY_PASSWD.to_string ());
                if (stmt.column_text (DBOption.PROXYPASSWORD) != htspas) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYPASSWORD.to_string ()) = \"$(htspas)\"");
                }
            } else {
                if (stmt.column_text (DBOption.PROXYPASSWORD) != "NOTSET") {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYPASSWORD.to_string ()) = \"NOTSET\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.HTTP_USER.to_string ())) {
                string httpuser = hashoptions.@get (AriaOptions.HTTP_USER.to_string ());
                if (stmt.column_text (DBOption.HTTPUSR) != httpuser) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.HTTPUSR.to_string ()) = \"$(httpuser)\"");
                }
            } else {
                if (stmt.column_text (DBOption.HTTPUSR) != "NOTSET") {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.HTTPUSR.to_string ()) = \"NOTSET\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.HTTP_PASSWD.to_string ())) {
                string httppass = hashoptions.@get (AriaOptions.HTTP_PASSWD.to_string ());
                if (stmt.column_text (DBOption.HTTPPASS) != httppass) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.HTTPPASS.to_string ()) = \"$(httppass)\"");
                }
            } else {
                if (stmt.column_text (DBOption.HTTPPASS) != "NOTSET") {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.HTTPPASS.to_string ()) = \"NOTSET\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.FTP_USER.to_string ())) {
                string ftpuser = hashoptions.@get (AriaOptions.FTP_USER.to_string ());
                if (stmt.column_text (DBOption.FTPUSR) != ftpuser) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.FTPUSR.to_string ()) = \"$(ftpuser)\"");
                }
            } else {
                if (stmt.column_text (DBOption.FTPUSR) != "NOTSET") {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.FTPUSR.to_string ()) = \"NOTSET\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.FTP_PASSWD.to_string ())) {
                string ftppass = hashoptions.@get (AriaOptions.FTP_PASSWD.to_string ());
                if (stmt.column_text (DBOption.FTPPASS) != ftppass) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.FTPPASS.to_string ()) = \"$(ftppass)\"");
                }
            } else {
                if (stmt.column_text (DBOption.FTPPASS) != "NOTSET") {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.FTPPASS.to_string ()) = \"NOTSET\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.DIR.to_string ())) {
                string dir = hashoptions.@get (AriaOptions.DIR.to_string ());
                if (stmt.column_text (DBOption.DIR) != dir) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.DIR.to_string ()) = \"$(dir)\"");
                }
            } else {
                if (stmt.column_text (DBOption.DIR) != "") {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.DIR.to_string ()) = \"\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.COOKIE.to_string ())) {
                string cookie = hashoptions.@get (AriaOptions.COOKIE.to_string ());
                if (stmt.column_text (DBOption.COOKIE) != cookie) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.COOKIE.to_string ()) = \"$(cookie)\"");
                }
            } else {
                if (stmt.column_text (DBOption.COOKIE) != "") {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.COOKIE.to_string ()) = \"\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.REFERER.to_string ())) {
                string referer = hashoptions.@get (AriaOptions.REFERER.to_string ());
                if (stmt.column_text (DBOption.REFERER) != referer) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.REFERER.to_string ()) = \"$(referer)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.USER_AGENT.to_string ())) {
                string useragent = hashoptions.@get (AriaOptions.USER_AGENT.to_string ());
                if (stmt.column_text (DBOption.USERAGENT) != useragent) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.USERAGENT.to_string ()) = \"$(useragent)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.OUT.to_string ())) {
                string outf = hashoptions.@get (AriaOptions.OUT.to_string ());
                if (stmt.column_text (DBOption.OUT) != outf) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.OUT.to_string ()) = \"$(outf)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.PROXY_METHOD.to_string ())) {
                string proxymethod = hashoptions.@get (AriaOptions.PROXY_METHOD.to_string ());
                if (stmt.column_text (DBOption.PROXYMETHOD) != proxymethod) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYMETHOD.to_string ()) = \"$(proxymethod)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.SELECT_FILE.to_string ())) {
                string selectfile = hashoptions.@get (AriaOptions.SELECT_FILE.to_string ());
                if (stmt.column_text (DBOption.SELECTFILE) != selectfile) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.SELECTFILE.to_string ()) = \"$(selectfile)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.CHECKSUM.to_string ())) {
                string checksums = hashoptions.@get (AriaOptions.CHECKSUM.to_string ());
                if (stmt.column_text (DBOption.CHECKSUM) != checksums) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.CHECKSUM.to_string ()) = \"$(checksums)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.BT_MIN_CRYPTO_LEVEL.to_string ())) {
                string cryplvl = hashoptions.@get (AriaOptions.BT_MIN_CRYPTO_LEVEL.to_string ());
                if (stmt.column_text (DBOption.CRYPTOLVL) != cryplvl) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.CRYPTOLVL.to_string ()) = \"$(cryplvl)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.BT_REQUIRE_CRYPTO.to_string ())) {
                string reqcrypt = hashoptions.@get (AriaOptions.BT_REQUIRE_CRYPTO.to_string ());
                if (stmt.column_text (DBOption.REQUIRECRYP) != reqcrypt) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.REQUIRECRYP.to_string ()) = \"$(reqcrypt)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.CHECK_INTEGRITY.to_string ())) {
                string integ = hashoptions.@get (AriaOptions.CHECK_INTEGRITY.to_string ());
                if (stmt.column_text (DBOption.INTEGRITY) != integ) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.INTEGRITY.to_string ()) = \"$(integ)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.BT_SEED_UNVERIFIED.to_string ())) {
                string unver = hashoptions.@get (AriaOptions.BT_SEED_UNVERIFIED.to_string ());
                if (stmt.column_text (DBOption.UNVERIFIED) != unver) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.UNVERIFIED.to_string ()) = \"$(unver)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.SELECT_FILE.to_string ())) {
                string selected = hashoptions.@get (AriaOptions.SELECT_FILE.to_string ());
                if (stmt.column_text (DBOption.SELECTED) != selected) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.SELECTED.to_string ()) = \"$(selected)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.HEADER.to_string ())) {
                string header = hashoptions.@get (AriaOptions.HEADER.to_string ());
                if (stmt.column_text (DBOption.HEADER) != header) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.HEADER.to_string ()) = \"$(header)\"");
                }
            }
        }
        if (buildstr.str.hash () == empty_hash) {
            stmt.reset ();
            return;
        }
        buildstr.append (" WHERE url = ?");
        res = gabutdb.prepare_v2 (buildstr.str, -1, out stmt);
        res = stmt.bind_text (DBOption.URL, url);
        if ((res = stmt.step ()) != Sqlite.DONE) {
            warning ("Error: %d: %s", gabutdb.errcode (), gabutdb.errmsg ());
        }
        stmt.reset ();
    }

    private bool db_option_exist (string url) {
        Sqlite.Statement stmt;
        int res = gabutdb.prepare_v2 ("SELECT * FROM options WHERE url = ?", -1, out stmt);
        res = stmt.bind_text (DBOption.URL, url);
        if ((res = stmt.step ()) == Sqlite.ROW) {
            return true;
        }
        stmt.reset ();
        return false;
    }

    private Pango.AttrList set_attribute (Pango.Weight weight, double scale = 0) {
        Pango.AttrList attrlist = new Pango.AttrList ();
        if (scale != 0) {
            attrlist.insert (Pango.attr_scale_new (scale));
        }
        attrlist.insert (Pango.attr_weight_new (weight));
        return attrlist;
    }

    private Pango.AttrList color_attribute (uint16 red, uint16 green, uint16 blue, bool bold = true) {
        Pango.AttrList attrlist = new Pango.AttrList ();
        if (bold) {
            attrlist.insert (Pango.attr_weight_new (Pango.Weight.ULTRABOLD));
        }
        attrlist.insert (Pango.attr_foreground_new (red, green, blue));
        return attrlist;
    }

    private string get_local_address () {
        try {
            var socket = new Socket (SocketFamily.IPV4, SocketType.DATAGRAM, SocketProtocol.UDP);
            var addr = new InetSocketAddress (new InetAddress.from_string ("192.168.0.1"), 9);
            socket.connect (addr);
            var local = socket.get_local_address () as InetSocketAddress;
            if (local != null) {
                string ip = local.get_address ().to_string ();
                if (ip != "0.0.0.0" && ip != "127.0.0.1") {
                    return ip;
                }
            }
        } catch (Error e) {
            warning (e.message);
        }
        return "127.0.0.1";
    }

    private void gdm_theme () {
        var tdefault = bool.parse (get_dbsetting (DBSettings.TDEFAULT));
        var adwt_settings = Adw.StyleManager.get_default ();
        var gtk_settings = Gtk.Settings.get_default ();
        int themesel = int.parse (get_dbsetting (DBSettings.THEMESELECT));
        var themename = get_dbsetting (DBSettings.THEMECUSTOM);
        int stymd = int.parse (get_dbsetting (DBSettings.STYLE));
        switch (stymd) {
            case 1:
                adwt_settings.color_scheme = Adw.ColorScheme.FORCE_LIGHT;
                break;
            case 2:
                adwt_settings.color_scheme = Adw.ColorScheme.FORCE_DARK;
                break;
            default:
                adwt_settings.color_scheme = Adw.ColorScheme.DEFAULT;
                break;
        }
        if (!tdefault) {
            gtk_settings.gtk_theme_name = "Adwaita-empty";
        } else {
            gtk_settings.gtk_theme_name = themesel == 0? "Default" : themename;
        }
    }
}