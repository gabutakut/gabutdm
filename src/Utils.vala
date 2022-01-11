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
        PIECESELECTOR = 34;

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
        HTTPS_PROXY_PASSWD = 109;

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

    private enum TorrentPeers {
        HOST,
        PEERID,
        DOWNLOADSPEED,
        UPLOADSPEED,
        SEEDER,
        BITFIELD,
        AMCHOKING,
        PEERCHOKING,
        N_COLUMNS
    }

    private enum AriaGetfiles {
        INDEX = 0,
        PATH = 1,
        LENGTH = 2,
        COMPLETEDLENGTH = 3,
        URIS = 4;

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
        FILEORDIR = 10,
        LABELTRANSFER = 11;

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
                case TRANSFERRED:
                    return "transferred";
                case LINKMODE:
                    return "linkmode";
                case FILEORDIR:
                    return "fileordir";
                case LABELTRANSFER:
                    return "labeltransfer";
                default:
                    return "id";
            }
        }
    }

    private enum GlobalStat {
        DOWNLOADSPEED = 0,
        NUMACTIVE = 1,
        NUMSTOPPED = 2,
        NUMWAITING = 3,
        UPLOADSPEED = 4;

        public string get_name () {
            switch (this) {
                case NUMACTIVE:
                    return "numActive";
                case NUMSTOPPED:
                    return "numStopped";
                case NUMWAITING:
                    return "numWaiting";
                case UPLOADSPEED:
                    return "uploadSpeed";
                default:
                    return "downloadSpeed";
            }
        }
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
        PROXYTYPE = 23;

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

    public enum BTEncrypts {
        PLAIN = 0,
        ARC4 = 1;

        public string get_name () {
            switch (this) {
                case ARC4:
                    return "Arc4";
                default:
                    return "Plain";
            }
        }

        public static BTEncrypts [] get_all () {
            return { PLAIN, ARC4 };
        }
    }

    public enum LoginUsers {
        HTTP = 0,
        FTP = 1;

        public string get_name () {
            switch (this) {
                case FTP:
                    return "FTP";
                default:
                    return "HTTP";
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

        public string get_name () {
            switch (this) {
                case INORDER:
                    return "Inorder";
                case RANDOM:
                    return "Random";
                case GEOM:
                    return "Geom";
                default:
                    return "Default";
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

        public string get_name () {
            switch (this) {
                case INORDER:
                    return "Inorder";
                case ADAPTIVE:
                    return "Adaptive";
                default:
                    return "Feedback";
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

    public enum ProxyTypes {
        ALL = 0,
        HTTP = 1,
        HTTPS = 2,
        FTP = 3;

        public string get_name () {
            switch (this) {
                case HTTP:
                    return "HTTP";
                case HTTPS:
                    return "HTTPS";
                case FTP:
                    return "FTP";
                default:
                    return "ALL";
            }
        }

        public static ProxyTypes [] get_all () {
            return { ALL, HTTP, HTTPS, FTP };
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
        stringbuild.append (@"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.addUri\", \"params\":[[\"$(url)\"], {");
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
        stringbuild.append (@"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.addMetalink\", \"params\":[[\"$(metal)\"], {");
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

    private Gtk.ListStore aria_get_peers (string gid) {
        var liststore = new Gtk.ListStore (TorrentPeers.N_COLUMNS, typeof (string), typeof (string), typeof (string), typeof (string), typeof (string), typeof (string), typeof (string), typeof (string));
        var session = new Soup.Session ();
        var message = new Soup.Message ("POST", aria_listent);
        var jsonrpc = @"{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.getPeers\", \"params\":[\"$(gid)\"]}";
        message.set_request (Soup.FORM_MIME_TYPE_MULTIPART, Soup.MemoryUse.COPY, jsonrpc.data);
        session.send_message (message);
        string result = (string) message.response_body.flatten ().data;
        if (!result.down ().contains ("result") || result == null) {
            return liststore;
        }
        string regexstr = "{\"amChoking\":\"(.*?)\".*?\"bitfield\":\"(.*?)\".*?\"downloadSpeed\":\"(.*?)\".*?\"ip\":\"(.*?)\".*?\"peerChoking\":\"(.*?)\".*?\"peerId\":\"(.*?)\".*?\"port\":\"(.*?)\".*?\"seeder\":\"(.*?)\".*?\"uploadSpeed\":\"(.*?)\"}";
        if (Regex.match_simple (regexstr, result)) {
            try {
                MatchInfo match_info;
                Regex regex = new Regex (regexstr);
                regex.match_full (result, -1, 0, 0, out match_info);
                while (match_info.matches ()) {
                    string peerid = Soup.URI.decode (match_info.fetch (6));
                    Gtk.TreeIter iter;
                    liststore.append (out iter);
                    liststore.set (iter, TorrentPeers.HOST, @"$(match_info.fetch (4)):$(match_info.fetch (7))", TorrentPeers.PEERID, peerid != ""? get_peerid (peerid.slice (1, 3)) : "Unknow", TorrentPeers.DOWNLOADSPEED, format_size (int64.parse (match_info.fetch (3))), TorrentPeers.UPLOADSPEED, match_info.fetch (9), TorrentPeers.SEEDER, match_info.fetch (8), TorrentPeers.BITFIELD, match_info.fetch (2), TorrentPeers.AMCHOKING, match_info.fetch (1), TorrentPeers.PEERCHOKING, match_info.fetch (5));
                    match_info.next ();
                }
            } catch (Error e) {
                GLib.warning (e.message);
            }
        }
        return liststore;
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
            Regex regex = new Regex (@"\"$(files.get_name ())\":\"(.*?)\"");
            regex.match_full (result, -1, 0, 0, out match_info);
            string getfile = match_info.fetch (1);
            return getfile.contains ("\\/")? getfile.replace ("\\/", "/") : getfile;
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
                    liststore.set (iter, FileCol.SELECTED, bool.parse (match_info.fetch (5)), FileCol.ROW, match_info.fetch (2), FileCol.NAME, file.get_basename (), FileCol.FILEPATH, file.get_path (), FileCol.DOWNLOADED, format_size (transfer), FileCol.SIZE, format_size (total), FileCol.PERCEN, persen, FileCol.URIS, uris.contains ("\\/")? Soup.URI.decode (uris.replace ("\\/", "/").replace ("[{", "")) : uris);
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
            string ariaopt = match_info.fetch (1);
            if (ariaopt != null) {
                return ariaopt;
            }
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

    private string aria_globalstat (GlobalStat stat) {
        var session = new Soup.Session ();
        var message = new Soup.Message ("POST", aria_listent);
        var jsonrpc = "{\"jsonrpc\":\"2.0\", \"id\":\"qwer\", \"method\":\"aria2.getGlobalStat\"}";
        message.set_request (Soup.FORM_MIME_TYPE_MULTIPART, Soup.MemoryUse.COPY, jsonrpc.data);
        session.send_message (message);
        string result = (string) message.response_body.flatten ().data;
        if (!result.down ().contains ("result") || result == null) {
            return "";
        }
        try {
            MatchInfo match_info;
            Regex regex = new Regex (@"\"$(stat.get_name ())\":\"(.*?)\"");
            regex.match_full (result, -1, 0, 0, out match_info);
            return match_info.fetch (1);
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
        string btport = get_dbsetting (DBSettings.BTLISTENPORT);
        string dhtport = get_dbsetting (DBSettings.DHTLISTENPORT);
        string[] exec = {"aria2c", "--no-conf", "--enable-rpc", @"--rpc-listen-port=$(rpcport)", @"--rpc-max-request-size=$(size_req)", @"--listen-port=$(btport)", @"--dht-listen-port=$(dhtport)", @"--disk-cache=$(cache)", @"--file-allocation=$(allocate.down ())", "--quiet=true"};
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
        do {
            aria_set_globalops (AriaOptions.MAX_OVERALL_UPLOAD_LIMIT, get_dbsetting (DBSettings.UPLOADLIMIT));
        } while (get_dbsetting (DBSettings.UPLOADLIMIT) != aria_get_globalops (AriaOptions.MAX_OVERALL_UPLOAD_LIMIT));
        do {
            aria_set_globalops (AriaOptions.MAX_OVERALL_DOWNLOAD_LIMIT, get_dbsetting (DBSettings.DOWNLOADLIMIT));
        } while (get_dbsetting (DBSettings.DOWNLOADLIMIT) != aria_get_globalops (AriaOptions.MAX_OVERALL_DOWNLOAD_LIMIT));
        do {
            aria_set_globalops (AriaOptions.BT_TRACKER, get_dbsetting (DBSettings.BTTRACKER));
        } while (get_dbsetting (DBSettings.BTTRACKER) != aria_get_globalops (AriaOptions.BT_TRACKER));
        do {
            aria_set_globalops (AriaOptions.BT_EXCLUDE_TRACKER, get_dbsetting (DBSettings.BTTRACKEREXC));
        } while (get_dbsetting (DBSettings.BTTRACKEREXC) != aria_get_globalops (AriaOptions.BT_EXCLUDE_TRACKER));
        do {
            aria_set_globalops (AriaOptions.MIN_SPLIT_SIZE, get_dbsetting (DBSettings.SPLITSIZE));
        } while (get_dbsetting (DBSettings.SPLITSIZE) != aria_get_globalops (AriaOptions.MIN_SPLIT_SIZE));
        do {
            aria_set_globalops (AriaOptions.LOWEST_SPEED_LIMIT, get_dbsetting (DBSettings.LOWESTSPEED));
        } while (get_dbsetting (DBSettings.LOWESTSPEED) != aria_get_globalops (AriaOptions.LOWEST_SPEED_LIMIT));
        do {
            aria_set_globalops (AriaOptions.URI_SELECTOR, get_dbsetting (DBSettings.URISELECTOR));
        } while (get_dbsetting (DBSettings.URISELECTOR) != aria_get_globalops (AriaOptions.URI_SELECTOR));
        do {
            aria_set_globalops (AriaOptions.STREAM_PIECE_SELECTOR, get_dbsetting (DBSettings.PIECESELECTOR));
        } while (get_dbsetting (DBSettings.PIECESELECTOR) != aria_get_globalops (AriaOptions.STREAM_PIECE_SELECTOR));
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

#if HAVE_DBUSMENU
    private SourceFunc quicksource;
    private async void open_quicklist (Dbusmenu.Server dbusserver, Dbusmenu.Menuitem menuitem) throws GLib.Error {
        if (quicksource != null) {
            Idle.add ((owned)quicksource);
        }
        quicksource = open_quicklist.callback;
        unowned UnityLauncherEntry entrydbus = yield UnityLauncherEntry.get_instance ();
        dbusserver.set_root (menuitem);
        entrydbus.set_app_property ("quicklist", new GLib.Variant.string (dbusserver.dbus_object));
        yield;
    }
#endif
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
        var filechooser = new Gtk.FileChooserNative (_("Open Torrent Or Metalink"), window, Gtk.FileChooserAction.OPEN, _("Open"), _("Cancel"));
        filechooser.select_multiple = multi;

        var torrent = new Gtk.FileFilter ();
        torrent.set_filter_name (_("Torrent"));
        torrent.add_mime_type ("application/x-bittorrent");
        var metalink = new Gtk.FileFilter ();
        metalink.set_filter_name (_("Metalink"));
        metalink.add_pattern ("application/metalink+xml");
        metalink.add_pattern ("application/metalink4+xml");

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
            fileordir      TEXT    NOT NULL,
            labeltransfer  TEXT    NOT NULL);");
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
            proxytype      TEXT    NOT NULL);");
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
            pieceselector  TEXT    NOT NULL);
            INSERT INTO settings (id, rpcport, maxtries, connserver, timeout, dir, retry, rpcsize, btmaxpeers, diskcache, maxactive, bttimeouttrack, split, maxopenfile, dialognotif, systemnotif, onbackground, iplocal, portlocal, seedtime, overwrite, autorenaming, allocation, startup, style, uploadlimit, downloadlimit, btlistenport, dhtlistenport, bttracker, bttrackerexc, splitsize, lowestspeed, uriselector, pieceselector)
            VALUES (1, \"6807\", \"5\", \"6\", \"60\", \"$(dir)\", \"0\", \"2097152\", \"55\", \"16777216\", \"5\", \"60\", \"5\", \"100\", \"true\", \"true\", \"true\", \"true\", \"2021\", \"0\", \"false\", \"false\", \"None\", \"true\", \"1\", \"128000\", \"0\", \"21301\", \"26701\", \"\", \"\", \"20971520\", \"0\", \"feedback\", \"default\");");
    }

    private void settings_table () {
        if ((db_table ("settings") - 1) != DBSettings.PIECESELECTOR) {
            GabutApp.db.exec ("DROP TABLE settings;");
            table_settings (GabutApp.db);
        }
    }

    private void download_table () {
        if ((db_table ("download") - 1) != DBDownload.LABELTRANSFER) {
            GabutApp.db.exec ("DROP TABLE download;");
            table_download (GabutApp.db);
        }
        if ((db_table ("options") - 1) != DBOption.UNVERIFIED) {
            GabutApp.db.exec ("DROP TABLE options;");
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
            string sql = "INSERT OR IGNORE INTO download (url, status, ariagid, filepath, filename, totalsize, transferrate, transferred, linkmode, fileordir, labeltransfer) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
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
            res = stmt.bind_text (DBDownload.LABELTRANSFER, download.labeltransfer);
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
            if (stmt.column_text (DBDownload.LABELTRANSFER) != download.labeltransfer) {
                if (buildstr.str.hash () != empty_hash) {
                    buildstr.append (",");
                }
                buildstr.append (@" $(DBDownload.LABELTRANSFER.get_name ()) = \"$(download.labeltransfer)\"");
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
        int res = GabutApp.db.prepare_v2 ("SELECT id, url, status, ariagid, filepath, filename, totalsize, transferrate, transferred, linkmode, fileordir, labeltransfer FROM download ORDER BY url;", -1, out stmt);
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
            string proxytype = stmt.column_text (DBOption.PROXYTYPE);
            if (proxytype != "" && proxytype != "NOTSET") {
                string proxy = stmt.column_text (DBOption.PROXY);
                string proxuser = stmt.column_text (DBOption.PROXYUSER);
                string proxypass = stmt.column_text (DBOption.PROXYPASSWORD);
                if (proxytype.down () == "all") {
                    if (proxy != "NOTSET" && proxy != "") {
                        hashoption[AriaOptions.PROXY.get_name ()] = proxy;
                        if (proxuser != "NOTSET" && proxuser != "") {
                            hashoption[AriaOptions.PROXYUSER.get_name ()] = proxuser;
                        }
                        if (proxypass != "NOTSET" && proxypass != "") {
                            hashoption[AriaOptions.PROXYPASSWORD.get_name ()] = proxypass;
                        }
                    }
                } else if (proxytype.down () == "ftp") {
                    hashoption[AriaOptions.FTP_PROXY.get_name ()] = proxy;
                    if (proxuser != "NOTSET" && proxuser != "") {
                        hashoption[AriaOptions.FTP_PROXY_USER.get_name ()] = proxuser;
                    }
                    if (proxypass != "NOTSET" && proxypass != "") {
                        hashoption[AriaOptions.FTP_PROXY_PASSWD.get_name ()] = proxypass;
                    }
                } else if (proxytype.down () == "http") {
                    hashoption[AriaOptions.HTTP_PROXY.get_name ()] = proxy;
                    if (proxuser != "NOTSET" && proxuser != "") {
                        hashoption[AriaOptions.HTTP_PROXY_USER.get_name ()] = proxuser;
                    }
                    if (proxypass != "NOTSET" && proxypass != "") {
                        hashoption[AriaOptions.HTTP_PROXY_PASSWD.get_name ()] = proxypass;
                    }
                } else if (proxytype.down () == "https") {
                    hashoption[AriaOptions.HTTPS_PROXY.get_name ()] = proxy;
                    if (proxuser != "NOTSET" && proxuser != "") {
                        hashoption[AriaOptions.HTTPS_PROXY_USER.get_name ()] = proxuser;
                    }
                    if (proxypass != "NOTSET" && proxypass != "") {
                        hashoption[AriaOptions.HTTPS_PROXY_PASSWD.get_name ()] = proxypass;
                    }
                }
            }
            string httpuser = stmt.column_text (DBOption.HTTPUSR);
            if (httpuser != "NOTSET" && httpuser != "") {
                hashoption[AriaOptions.HTTP_USER.get_name ()] = httpuser;
            }
            string httppass = stmt.column_text (DBOption.HTTPPASS);
            if (httppass != "NOTSET" && httppass != "") {
                hashoption[AriaOptions.HTTP_PASSWD.get_name ()] = httppass;
            }
            string ftpuser = stmt.column_text (DBOption.FTPUSR);
            if (ftpuser != "NOTSET" && ftpuser != "") {
                hashoption[AriaOptions.FTP_USER.get_name ()] = ftpuser;
            }
            string ftppass = stmt.column_text (DBOption.FTPPASS);
            if (ftppass != "NOTSET" && ftppass != "") {
                hashoption[AriaOptions.FTP_PASSWD.get_name ()] = ftppass;
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
            string cryptlvl = stmt.column_text (DBOption.CRYPTOLVL);
            if (cryptlvl != "") {
                hashoption[AriaOptions.BT_MIN_CRYPTO_LEVEL.get_name ()] = cryptlvl;
            }
            string requirecrtp = stmt.column_text (DBOption.REQUIRECRYP);
            if (requirecrtp != "") {
                hashoption[AriaOptions.BT_REQUIRE_CRYPTO.get_name ()] = requirecrtp;
            }
            string integrity = stmt.column_text (DBOption.INTEGRITY);
            if (integrity != "") {
                hashoption[AriaOptions.CHECK_INTEGRITY.get_name ()] = integrity;
            }
            string unverify = stmt.column_text (DBOption.UNVERIFIED);
            if (unverify != "") {
                hashoption[AriaOptions.BT_SEED_UNVERIFIED.get_name ()] = unverify;
            }
        }
        stmt.reset ();
        return hashoption;
    }

    private void set_dboptions (string url, Gee.HashMap<string, string> hashoptions) {
        Sqlite.Statement stmt;
        string sql = "INSERT OR IGNORE INTO options (url, magnetbackup, torrentbackup, proxy, proxyusr, proxypass, httpusr, httppass, ftpusr, ftppass, dir, cookie, referer, useragent, out, proxymethod, selectfile, checksum, cryptolvl, requirecryp, integrity, unverified, proxytype) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
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
            res = stmt.bind_text (DBOption.PROXYTYPE, "all");
        } else if (hashoptions.has_key (AriaOptions.FTP_PROXY.get_name ())) {
            res = stmt.bind_text (DBOption.PROXY, hashoptions.@get (AriaOptions.FTP_PROXY.get_name ()));
            res = stmt.bind_text (DBOption.PROXYTYPE, "ftp");
        } else if (hashoptions.has_key (AriaOptions.HTTP_PROXY.get_name ())) {
            res = stmt.bind_text (DBOption.PROXY, hashoptions.@get (AriaOptions.HTTP_PROXY.get_name ()));
            res = stmt.bind_text (DBOption.PROXYTYPE, "http");
        } else if (hashoptions.has_key (AriaOptions.HTTPS_PROXY.get_name ())) {
            res = stmt.bind_text (DBOption.PROXY, hashoptions.@get (AriaOptions.HTTPS_PROXY.get_name ()));
            res = stmt.bind_text (DBOption.PROXYTYPE, "https");
        } else {
            res = stmt.bind_text (DBOption.PROXY, "NOTSET");
            res = stmt.bind_text (DBOption.PROXYTYPE, "NOTSET");
        }
        if (hashoptions.has_key (AriaOptions.PROXYUSER.get_name ())) {
            res = stmt.bind_text (DBOption.PROXYUSER, hashoptions.@get (AriaOptions.PROXYUSER.get_name ()));
        } else if (hashoptions.has_key (AriaOptions.FTP_PROXY_USER.get_name ())) {
            res = stmt.bind_text (DBOption.PROXYUSER, hashoptions.@get (AriaOptions.FTP_PROXY_USER.get_name ()));
        } else if (hashoptions.has_key (AriaOptions.HTTP_PROXY_USER.get_name ())) {
            res = stmt.bind_text (DBOption.PROXYUSER, hashoptions.@get (AriaOptions.HTTP_PROXY_USER.get_name ()));
        } else if (hashoptions.has_key (AriaOptions.HTTPS_PROXY_PASSWD.get_name ())) {
            res = stmt.bind_text (DBOption.PROXYPASSWORD, hashoptions.@get (AriaOptions.HTTPS_PROXY_PASSWD.get_name ()));
        } else {
            res = stmt.bind_text (DBOption.PROXYUSER, "NOTSET");
        }
        if (hashoptions.has_key (AriaOptions.PROXYPASSWORD.get_name ())) {
            res = stmt.bind_text (DBOption.PROXYPASSWORD, hashoptions.@get (AriaOptions.PROXYPASSWORD.get_name ()));
        } else if (hashoptions.has_key (AriaOptions.FTP_PROXY_PASSWD.get_name ())) {
            res = stmt.bind_text (DBOption.PROXYPASSWORD, hashoptions.@get (AriaOptions.FTP_PROXY_PASSWD.get_name ()));
        } else if (hashoptions.has_key (AriaOptions.HTTP_PROXY_PASSWD.get_name ())) {
            res = stmt.bind_text (DBOption.PROXYPASSWORD, hashoptions.@get (AriaOptions.HTTP_PROXY_PASSWD.get_name ()));
        } else if (hashoptions.has_key (AriaOptions.HTTPS_PROXY_PASSWD.get_name ())) {
            res = stmt.bind_text (DBOption.PROXYPASSWORD, hashoptions.@get (AriaOptions.HTTPS_PROXY_PASSWD.get_name ()));
        } else {
            res = stmt.bind_text (DBOption.PROXYPASSWORD, "NOTSET");
        }
        if (hashoptions.has_key (AriaOptions.HTTP_USER.get_name ())) {
            res = stmt.bind_text (DBOption.HTTPUSR, hashoptions.@get (AriaOptions.HTTP_USER.get_name ()));
        } else {
            res = stmt.bind_text (DBOption.HTTPUSR, "NOTSET");
        }
        if (hashoptions.has_key (AriaOptions.HTTP_PASSWD.get_name ())) {
            res = stmt.bind_text (DBOption.HTTPPASS, hashoptions.@get (AriaOptions.HTTP_PASSWD.get_name ()));
        } else {
            res = stmt.bind_text (DBOption.HTTPPASS, "NOTSET");
        }
        if (hashoptions.has_key (AriaOptions.FTP_USER.get_name ())) {
            res = stmt.bind_text (DBOption.FTPUSR, hashoptions.@get (AriaOptions.FTP_USER.get_name ()));
        } else {
            res = stmt.bind_text (DBOption.FTPUSR, "NOTSET");
        }
        if (hashoptions.has_key (AriaOptions.FTP_PASSWD.get_name ())) {
            res = stmt.bind_text (DBOption.FTPPASS, hashoptions.@get (AriaOptions.FTP_PASSWD.get_name ()));
        } else {
            res = stmt.bind_text (DBOption.FTPPASS, "NOTSET");
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
        if (hashoptions.has_key (AriaOptions.BT_MIN_CRYPTO_LEVEL.get_name ())) {
            res = stmt.bind_text (DBOption.CRYPTOLVL, hashoptions.@get (AriaOptions.BT_MIN_CRYPTO_LEVEL.get_name ()));
        } else {
            res = stmt.bind_text (DBOption.CRYPTOLVL, "");
        }
        if (hashoptions.has_key (AriaOptions.BT_REQUIRE_CRYPTO.get_name ())) {
            res = stmt.bind_text (DBOption.REQUIRECRYP, hashoptions.@get (AriaOptions.BT_REQUIRE_CRYPTO.get_name ()));
        } else {
            res = stmt.bind_text (DBOption.REQUIRECRYP, "");
        }
        if (hashoptions.has_key (AriaOptions.CHECK_INTEGRITY.get_name ())) {
            res = stmt.bind_text (DBOption.INTEGRITY, hashoptions.@get (AriaOptions.CHECK_INTEGRITY.get_name ()));
        } else {
            res = stmt.bind_text (DBOption.INTEGRITY, "");
        }
        if (hashoptions.has_key (AriaOptions.BT_SEED_UNVERIFIED.get_name ())) {
            res = stmt.bind_text (DBOption.UNVERIFIED, hashoptions.@get (AriaOptions.BT_SEED_UNVERIFIED.get_name ()));
        } else {
            res = stmt.bind_text (DBOption.UNVERIFIED, "");
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
                string torrentbackup = hashoptions.@get (AriaOptions.RPC_SAVE_UPLOAD_METADATA.get_name ());
                if (stmt.column_text (DBOption.TORRENTBACKUP) != torrentbackup) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.TORRENTBACKUP.get_name ()) = \"$(torrentbackup)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.PROXY.get_name ())) {
                string prox = hashoptions.@get (AriaOptions.PROXY.get_name ());
                if (stmt.column_text (DBOption.PROXY) != prox) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXY.get_name ()) = \"$(prox)\"");
                }
                if (stmt.column_text (DBOption.PROXYTYPE) != "all") {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYTYPE.get_name ()) = \"all\"");
                }
            } else if (hashoptions.has_key (AriaOptions.FTP_PROXY.get_name ())) {
                string ftpro = hashoptions.@get (AriaOptions.FTP_PROXY.get_name ());
                if (stmt.column_text (DBOption.PROXY) != ftpro) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXY.get_name ()) = \"$(ftpro)\"");
                }
                if (stmt.column_text (DBOption.PROXYTYPE) != "ftp") {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYTYPE.get_name ()) = \"ftp\"");
                }
            } else if (hashoptions.has_key (AriaOptions.HTTP_PROXY.get_name ())) {
                string htprox = hashoptions.@get (AriaOptions.HTTP_PROXY.get_name ());
                if (stmt.column_text (DBOption.PROXY) != htprox) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXY.get_name ()) = \"$(htprox)\"");
                }
                if (stmt.column_text (DBOption.PROXYTYPE) != "http") {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYTYPE.get_name ()) = \"http\"");
                }
            } else if (hashoptions.has_key (AriaOptions.HTTPS_PROXY.get_name ())) {
                string htsprox = hashoptions.@get (AriaOptions.HTTPS_PROXY.get_name ());
                if (stmt.column_text (DBOption.PROXY) != htsprox) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXY.get_name ()) = \"$(htsprox)\"");
                }
                if (stmt.column_text (DBOption.PROXYTYPE) != "https") {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYTYPE.get_name ()) = \"https\"");
                }
            } else {
                if (stmt.column_text (DBOption.PROXY) != "NOTSET") {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXY.get_name ()) = \"NOTSET\"");
                }
                if (stmt.column_text (DBOption.PROXYTYPE) != "NOTSET") {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYTYPE.get_name ()) = \"NOTSET\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.PROXYUSER.get_name ())) {
                string proxus = hashoptions.@get (AriaOptions.PROXYUSER.get_name ());
                if (stmt.column_text (DBOption.PROXYUSER) != proxus) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYUSER.get_name ()) = \"$(proxus)\"");
                }
            } else if (hashoptions.has_key (AriaOptions.FTP_PROXY_USER.get_name ())) {
                string ftprus = hashoptions.@get (AriaOptions.FTP_PROXY_USER.get_name ());
                if (stmt.column_text (DBOption.PROXYUSER) != ftprus) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYUSER.get_name ()) = \"$(ftprus)\"");
                }
            } else if (hashoptions.has_key (AriaOptions.HTTP_PROXY_USER.get_name ())) {
                string htus = hashoptions.@get (AriaOptions.HTTP_PROXY_USER.get_name ());
                if (stmt.column_text (DBOption.PROXYUSER) != htus) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYUSER.get_name ()) = \"$(htus)\"");
                }
            } else if (hashoptions.has_key (AriaOptions.HTTPS_PROXY_USER.get_name ())) {
                string htsprus = hashoptions.@get (AriaOptions.HTTPS_PROXY_USER.get_name ());
                if (stmt.column_text (DBOption.PROXYUSER) != htsprus) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYUSER.get_name ()) = \"$(htsprus)\"");
                }
            } else {
                if (stmt.column_text (DBOption.PROXYUSER) != "NOTSET") {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYUSER.get_name ()) = \"NOTSET\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.PROXYPASSWORD.get_name ())) {
                string proxpas = hashoptions.@get (AriaOptions.PROXYPASSWORD.get_name ());
                if (stmt.column_text (DBOption.PROXYPASSWORD) != proxpas) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYPASSWORD.get_name ()) = \"$(proxpas)\"");
                }
            } else if (hashoptions.has_key (AriaOptions.FTP_PROXY_PASSWD.get_name ())) {
                string ftprops = hashoptions.@get (AriaOptions.FTP_PROXY_PASSWD.get_name ());
                if (stmt.column_text (DBOption.PROXYPASSWORD) != ftprops) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYPASSWORD.get_name ()) = \"$(ftprops)\"");
                }
            } else if (hashoptions.has_key (AriaOptions.HTTP_PROXY_PASSWD.get_name ())) {
                string htpas = hashoptions.@get (AriaOptions.HTTP_PROXY_PASSWD.get_name ());
                if (stmt.column_text (DBOption.PROXYPASSWORD) != htpas) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYPASSWORD.get_name ()) = \"$(htpas)\"");
                }
            } else if (hashoptions.has_key (AriaOptions.HTTPS_PROXY_PASSWD.get_name ())) {
                string htspas = hashoptions.@get (AriaOptions.HTTPS_PROXY_PASSWD.get_name ());
                if (stmt.column_text (DBOption.PROXYPASSWORD) != htspas) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYPASSWORD.get_name ()) = \"$(htspas)\"");
                }
            } else {
                if (stmt.column_text (DBOption.PROXYPASSWORD) != "NOTSET") {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYPASSWORD.get_name ()) = \"NOTSET\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.HTTP_USER.get_name ())) {
                string httpuser = hashoptions.@get (AriaOptions.HTTP_USER.get_name ());
                if (stmt.column_text (DBOption.HTTPUSR) != httpuser) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.HTTPUSR.get_name ()) = \"$(httpuser)\"");
                }
            } else {
                if (stmt.column_text (DBOption.HTTPUSR) != "NOTSET") {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.HTTPUSR.get_name ()) = \"NOTSET\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.HTTP_PASSWD.get_name ())) {
                string httppass = hashoptions.@get (AriaOptions.HTTP_PASSWD.get_name ());
                if (stmt.column_text (DBOption.HTTPPASS) != httppass) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.HTTPPASS.get_name ()) = \"$(httppass)\"");
                }
            } else {
                if (stmt.column_text (DBOption.HTTPPASS) != "NOTSET") {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.HTTPPASS.get_name ()) = \"NOTSET\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.FTP_USER.get_name ())) {
                string ftpuser = hashoptions.@get (AriaOptions.FTP_USER.get_name ());
                if (stmt.column_text (DBOption.FTPUSR) != ftpuser) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.FTPUSR.get_name ()) = \"$(ftpuser)\"");
                }
            } else {
                if (stmt.column_text (DBOption.FTPUSR) != "NOTSET") {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.FTPUSR.get_name ()) = \"NOTSET\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.FTP_PASSWD.get_name ())) {
                string ftppass = hashoptions.@get (AriaOptions.FTP_PASSWD.get_name ());
                if (stmt.column_text (DBOption.FTPPASS) != ftppass) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.FTPPASS.get_name ()) = \"$(ftppass)\"");
                }
            } else {
                if (stmt.column_text (DBOption.FTPPASS) != "NOTSET") {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.FTPPASS.get_name ()) = \"NOTSET\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.DIR.get_name ())) {
                string dir = hashoptions.@get (AriaOptions.DIR.get_name ());
                if (stmt.column_text (DBOption.DIR) != dir) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.DIR.get_name ()) = \"$(dir)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.COOKIE.get_name ())) {
                string cookie = hashoptions.@get (AriaOptions.COOKIE.get_name ());
                if (stmt.column_text (DBOption.COOKIE) != cookie) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.COOKIE.get_name ()) = \"$(cookie)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.REFERER.get_name ())) {
                string referer = hashoptions.@get (AriaOptions.REFERER.get_name ());
                if (stmt.column_text (DBOption.REFERER) != referer) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.REFERER.get_name ()) = \"$(referer)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.USER_AGENT.get_name ())) {
                string useragent = hashoptions.@get (AriaOptions.USER_AGENT.get_name ());
                if (stmt.column_text (DBOption.USERAGENT) != useragent) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.USERAGENT.get_name ()) = \"$(useragent)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.OUT.get_name ())) {
                string outf = hashoptions.@get (AriaOptions.OUT.get_name ());
                if (stmt.column_text (DBOption.OUT) != outf) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.OUT.get_name ()) = \"$(outf)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.PROXY_METHOD.get_name ())) {
                string proxymethod = hashoptions.@get (AriaOptions.PROXY_METHOD.get_name ());
                if (stmt.column_text (DBOption.PROXYMETHOD) != proxymethod) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.PROXYMETHOD.get_name ()) = \"$(proxymethod)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.SELECT_FILE.get_name ())) {
                string selectfile = hashoptions.@get (AriaOptions.SELECT_FILE.get_name ());
                if (stmt.column_text (DBOption.SELECTFILE) != selectfile) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.SELECTFILE.get_name ()) = \"$(selectfile)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.CHECKSUM.get_name ())) {
                string checksums = hashoptions.@get (AriaOptions.CHECKSUM.get_name ());
                if (stmt.column_text (DBOption.CHECKSUM) != checksums) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.CHECKSUM.get_name ()) = \"$(checksums)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.BT_MIN_CRYPTO_LEVEL.get_name ())) {
                string cryplvl = hashoptions.@get (AriaOptions.BT_MIN_CRYPTO_LEVEL.get_name ());
                if (stmt.column_text (DBOption.CRYPTOLVL) != cryplvl) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.CRYPTOLVL.get_name ()) = \"$(cryplvl)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.BT_REQUIRE_CRYPTO.get_name ())) {
                string reqcrypt = hashoptions.@get (AriaOptions.BT_REQUIRE_CRYPTO.get_name ());
                if (stmt.column_text (DBOption.REQUIRECRYP) != reqcrypt) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.REQUIRECRYP.get_name ()) = \"$(reqcrypt)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.CHECK_INTEGRITY.get_name ())) {
                string integ = hashoptions.@get (AriaOptions.CHECK_INTEGRITY.get_name ());
                if (stmt.column_text (DBOption.INTEGRITY) != integ) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.INTEGRITY.get_name ()) = \"$(integ)\"");
                }
            }
            if (hashoptions.has_key (AriaOptions.BT_SEED_UNVERIFIED.get_name ())) {
                string unver = hashoptions.@get (AriaOptions.BT_SEED_UNVERIFIED.get_name ());
                if (stmt.column_text (DBOption.UNVERIFIED) != unver) {
                    if (buildstr.str.hash () != empty_hash) {
                        buildstr.append (",");
                    }
                    buildstr.append (@" $(DBOption.UNVERIFIED.get_name ()) = \"$(unver)\"");
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

    private Pango.AttrList set_attribute (Pango.Weight weight, double scale = 0) {
        Pango.AttrList attrlist = new Pango.AttrList ();
        Pango.Attribute attr = Pango.attr_weight_new (weight);
        if (scale != 0) {
            attr = Pango.attr_scale_new (scale);
        }
        attrlist.change ((owned) attr);
        return attrlist;
    }

    [DBus (name = "org.freedesktop.DBus.Properties")]
    private interface DBusProerties : Object {
        public abstract Variant get (string interface, string name) throws DBusError, IOError;
    }

    [DBus (name = "org.freedesktop.portal.Settings")]
    private interface PortalSettings : Object {
        public abstract Variant read (string namespace, string key) throws DBusError, IOError;
        public signal void setting_changed (string namespace, string key, Variant value);
    }

    private string get_local_address () {
        try {
            DBusProerties networkmanager = GLib.Bus.get_proxy_sync (GLib.BusType.SYSTEM, "org.freedesktop.NetworkManager", "/org/freedesktop/NetworkManager");
            if (networkmanager != null) {
                Variant nmconn = networkmanager.get ("org.freedesktop.NetworkManager", "PrimaryConnection");
                if (nmconn != null) {
                    DBusProerties nmactive = GLib.Bus.get_proxy_sync (GLib.BusType.SYSTEM, "org.freedesktop.NetworkManager", nmconn.get_string (null));
                    Variant activetype = nmactive.get ("org.freedesktop.NetworkManager.Connection.Active", "Type");
                    if (activetype.get_string (null) != "vpn") {
                        return ipv4address (nmactive.get ("org.freedesktop.NetworkManager.Connection.Active", "Ip4Config"));
                    } else {
                        Variant objspcific = nmactive.get ("org.freedesktop.NetworkManager.Connection.Active", "SpecificObject");
                        DBusProerties nmactivevpn = GLib.Bus.get_proxy_sync (GLib.BusType.SYSTEM, "org.freedesktop.NetworkManager", objspcific.get_string (null));
                        return ipv4address (nmactivevpn.get ("org.freedesktop.NetworkManager.Connection.Active", "Ip4Config"));
                    }
                }
            }
        } catch (Error e) {
            GLib.warning (e.message);
        }
        return "0.0.0.0";
    }

    private string ipv4address (Variant pathip4) {
        try {
            DBusProerties ip4conf = GLib.Bus.get_proxy_sync (GLib.BusType.SYSTEM, "org.freedesktop.NetworkManager", pathip4.get_string (null));
            Variant addressdata = ip4conf.get ("org.freedesktop.NetworkManager.IP4Config", "AddressData");
            string addressstr = addressdata.print (true);
            MatchInfo match_info;
            Regex regex = new Regex ("<'(.*?)'>");
            regex.match_full (addressstr, -1, 0, 0, out match_info);
            return match_info.fetch (1);
        } catch (Error e) {
            GLib.warning (e.message);
        }
        return "0.0.0.0";
    }

    private SourceFunc themecall;
    private async void pantheon_theme () throws Error {
        if (themecall != null) {
            Idle.add ((owned)themecall);
        }
        var gtk_settings = Gtk.Settings.get_default ();
        switch (int.parse (get_dbsetting (DBSettings.STYLE))) {
            case 1:
                gtk_settings.gtk_application_prefer_dark_theme = false;
                break;
            case 2:
                gtk_settings.gtk_application_prefer_dark_theme = true;
                break;
            default:
                PortalSettings portalsettings = yield GLib.Bus.get_proxy (GLib.BusType.SESSION, "org.freedesktop.portal.Desktop", "/org/freedesktop/portal/desktop");
                if (portalsettings != null) {
                    themecall = pantheon_theme.callback;
                    gtk_settings.gtk_application_prefer_dark_theme = portalsettings.read ("org.freedesktop.appearance", "color-scheme").get_variant ().get_uint32 () == 1? true : false;
                    portalsettings.setting_changed.connect ((scheme, key, value) => {
                        if (scheme == "org.freedesktop.appearance" && key == "color-scheme") {
                            gtk_settings.gtk_application_prefer_dark_theme = value.get_uint32 () == 1? true : false;
                        }
                    });
                    yield;
                }
                break;
        }
    }
}
