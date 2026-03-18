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

#include <aria2/aria2.h>
#include <vector>
#include <string>
#include <cstring>
#include <atomic>
#include <thread>
#include <map>
#include <fstream>
#include <iterator>
#include <algorithm>
#include <mutex>
#include "aria2_wrapper.h"

struct Aria2Engine {
    std::atomic<bool> running;
    aria2::Session* session;
    std::thread* worker_thread;
    std::mutex engine_mutex;
    std::map<std::string, std::string> options_map;
    Aria2NotifyCallback on_complete_cb = nullptr;
    Aria2NotifyCallback on_error_cb = nullptr;
    void* user_data = nullptr;
};

std::string gidToHex(aria2::A2Gid gid) {
    char buf[17];
    snprintf(buf, sizeof(buf), "%016lx", (unsigned long)gid);
    return std::string(buf);
}

aria2::A2Gid hexToGid(const char* hex) {
    if (!hex || strlen(hex) == 0) {
        return 0;
    }
    return (aria2::A2Gid)strtoul(hex, nullptr, 16);
}

std::string statusToString(aria2::DownloadStatus status) {
    switch(status) {
        case aria2::DOWNLOAD_ACTIVE:   return "active";
        case aria2::DOWNLOAD_WAITING:  return "waiting";
        case aria2::DOWNLOAD_PAUSED:   return "paused";
        case aria2::DOWNLOAD_COMPLETE: return "complete";
        case aria2::DOWNLOAD_ERROR:    return "error";
        case aria2::DOWNLOAD_REMOVED:  return "removed";
        default: return "unknown";
    }
}

int internal_callback(aria2::Session* s, aria2::DownloadEvent ev, aria2::A2Gid gid, void* ud) {
    Aria2Engine* e = (Aria2Engine*)ud;
    std::string gid_hex = gidToHex(gid);
    if (ev == aria2::EVENT_ON_DOWNLOAD_COMPLETE && e->on_complete_cb) {
        e->on_complete_cb(gid_hex.c_str(), e->user_data);
    }
    if (ev == aria2::EVENT_ON_DOWNLOAD_ERROR && e->on_error_cb) {
        e->on_error_cb(gid_hex.c_str(), e->user_data);
    }
    return 0;
}

ARIA2_EXPORT Aria2Engine* aria2_engine_create() {
    aria2::libraryInit();
    Aria2Engine* e = new Aria2Engine();
    e->running.store(false); 
    e->session = nullptr; 
    e->worker_thread = nullptr;
    return e;
}

static std::string sanitize_path_for_aria2(const char* v) {
    if (!v) {
        return "";
    }
    std::string in(v);
    std::string out;
    out.reserve(in.size());

    for (size_t i = 0; i < in.size(); ++i) {
        if (in[i] == '\\' && i + 1 < in.size() && in[i + 1] == '/') {
            out.push_back('/');
            ++i;
            continue;
        }
        if (in[i] == '\\') {
            continue;
        }
        out.push_back(in[i]);
    }
    return out;
}

ARIA2_EXPORT void aria2_engine_add_option(Aria2Engine* e, const char* k, const char* v) {
    if (!e || !k || !v) {
        return;
    }
    std::string key(k);
    std::string value(v);
    if (key == "dir") {
        value = sanitize_path_for_aria2(v);
    }
    e->options_map[key] = value;
}


ARIA2_EXPORT int aria2_engine_start(Aria2Engine* e) {
    if (!e || e->running.load()) {
        return -1;
    }
    aria2::SessionConfig conf;
    conf.keepRunning = true; 
    conf.userData = e; 
    conf.downloadEventCallback = internal_callback;
    aria2::KeyVals kv;
    for (auto const& [k, v] : e->options_map) {
        kv.push_back({k, v});
    }
    kv.push_back({"dir", "/"});
    e->session = aria2::sessionNew(kv, conf);
    if (!e->session) {
        return -1;
    }
    e->running.store(true);
    e->worker_thread = new std::thread([e]() {
        while (e->running.load()) {{
            std::lock_guard<std::mutex> lock(e->engine_mutex);
                if (e->session) {
                    aria2::run(e->session, aria2::RUN_ONCE);
                }
            }
            std::this_thread::sleep_for(std::chrono::nanoseconds(10)); 
        }
    });
    return 0;
}

ARIA2_EXPORT void aria2_engine_stop(Aria2Engine* e) {
    if (!e || !e->running.load()) {
        return;
    }
    e->running.store(false);
    if (e->worker_thread) { 
        if(e->worker_thread->joinable()) {
            e->worker_thread->join();
        }
        delete e->worker_thread; 
        e->worker_thread = nullptr; 
    }
    if (e->session) { 
        aria2::sessionFinal(e->session); 
        e->session = nullptr; 
    }
}

ARIA2_EXPORT char* aria2_engine_add_uri(Aria2Engine* e, const char* uri) {
    aria2::A2Gid gid;
    std::vector<std::string> uris = {uri};
    if (aria2::addUri(e->session, &gid, uris, aria2::KeyVals()) == 0) {
        return strdup(gidToHex(gid).c_str());
    }
    return nullptr;
}

ARIA2_EXPORT char* aria2_engine_add_torrent(Aria2Engine* e, const char* path) {
    std::ifstream is(path, std::ios::binary);
    if (!is) {
        return nullptr;
    }
    std::string content((std::istreambuf_iterator<char>(is)), std::istreambuf_iterator<char>());
    
    aria2::A2Gid gid;
    if (aria2::addTorrent(e->session, &gid, content, aria2::KeyVals(), 0) == 0) {
        return strdup(gidToHex(gid).c_str());
    }
    return nullptr;
}

ARIA2_EXPORT int aria2_engine_remove(Aria2Engine* e, const char* gid) { 
    return aria2::removeDownload(e->session, hexToGid(gid)); 
}

ARIA2_EXPORT int aria2_engine_pause(Aria2Engine* e, const char* gid) { 
    return aria2::pauseDownload(e->session, hexToGid(gid)); 
}

ARIA2_EXPORT int aria2_engine_unpause(Aria2Engine* e, const char* gid) { 
    return aria2::unpauseDownload(e->session, hexToGid(gid)); 
}

ARIA2_EXPORT int aria2_engine_change_position(Aria2Engine* e, const char* gid, int pos, const char* how) {
    aria2::OffsetMode m = aria2::OFFSET_MODE_SET;
    std::string s_how = how ? how : "";
    if (s_how == "POS_CUR") {
        m = aria2::OFFSET_MODE_CUR;
    } else if (s_how == "POS_END") {
        m = aria2::OFFSET_MODE_END;
    }
    return aria2::changePosition(e->session, hexToGid(gid), (int64_t)pos, m);
}

ARIA2_EXPORT char* aria2_engine_tell_status(Aria2Engine* e, const char* gid) {
    aria2::A2Gid a2gid = hexToGid(gid);
    aria2::DownloadHandle* dh = aria2::getDownloadHandle(e->session, a2gid);
    if (!dh) {
        return nullptr;
    }
    std::string res = "{\"gid\":\"" + gidToHex(a2gid) + "\","
                      "\"status\":\"" + statusToString(dh->getStatus()) + "\","
                      "\"totalLength\":\"" + std::to_string(dh->getTotalLength()) + "\","
                      "\"completedLength\":\"" + std::to_string(dh->getCompletedLength()) + "\","
                      "\"downloadSpeed\":\"" + std::to_string(dh->getDownloadSpeed()) + "\"}";
    
    aria2::deleteDownloadHandle(dh); 
    return strdup(res.c_str());
}

ARIA2_EXPORT char* aria2_engine_tell_active(Aria2Engine* e) {
    auto gids = aria2::getActiveDownload(e->session);
    std::string res = "[";
    for (size_t i = 0; i < gids.size(); ++i) {
        aria2::DownloadHandle* dh = aria2::getDownloadHandle(e->session, gids[i]);
        if (dh) {
            res += "{\"gid\":\"" + gidToHex(gids[i]) + "\",\"status\":\"" + statusToString(dh->getStatus()) + "\"}";
            if (i < gids.size() - 1) res += ",";
            aria2::deleteDownloadHandle(dh);
        }
    }
    res += "]"; 
    return strdup(res.c_str());
}

ARIA2_EXPORT char* aria2_engine_get_files(Aria2Engine* e, const char* gid) {
    aria2::DownloadHandle* dh = aria2::getDownloadHandle(e->session, hexToGid(gid));
    if (!dh) {
        return nullptr;
    }
    auto files = dh->getFiles(); 
    std::string res = "[";
    for (size_t i = 0; i < files.size(); ++i) {
        res += "{\"index\":" + std::to_string(files[i].index) + 
               ",\"path\":\"" + files[i].path + 
               "\",\"length\":\"" + std::to_string(files[i].length) + "\"}";
        if (i < files.size() - 1) {
            res += ",";
        }
    }
    res += "]"; 
    aria2::deleteDownloadHandle(dh); 
    return strdup(res.c_str());
}

ARIA2_EXPORT char* aria2_engine_get_out(Aria2Engine* e, const char* gid) {
    aria2::DownloadHandle* dh = aria2::getDownloadHandle(e->session, hexToGid(gid));
    if (!dh) {
        return nullptr;
    }
    std::string out = dh->getOption("out");
    aria2::deleteDownloadHandle(dh); 
    return strdup(out.c_str());
}

ARIA2_EXPORT void aria2_engine_set_on_complete(Aria2Engine* e, Aria2NotifyCallback cb, void* ud) { 
    e->on_complete_cb = cb; e->user_data = ud; 
}

ARIA2_EXPORT void aria2_engine_set_on_error(Aria2Engine* e, Aria2NotifyCallback cb, void* ud) { 
    e->on_error_cb = cb; e->user_data = ud; 
}

ARIA2_EXPORT void aria2_engine_unref(Aria2Engine* e) { 
    aria2_engine_stop(e); 
    delete e; 
    aria2::libraryDeinit(); 
}
ARIA2_EXPORT int aria2_engine_is_running(Aria2Engine* e) {
    if (!e) {
        return 0;
    }
    return e->running.load() ? 1 : 0;
}