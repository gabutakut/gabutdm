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

#ifndef ARIA2_WRAPPER_H
#define ARIA2_WRAPPER_H

#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ARIA2_EXPORT __attribute__((visibility("default")))

typedef struct Aria2Engine Aria2Engine;
typedef void (*Aria2NotifyCallback)(const char* gid, void* user_data);
ARIA2_EXPORT int aria2_engine_is_running(Aria2Engine* e);
ARIA2_EXPORT Aria2Engine* aria2_engine_create();
ARIA2_EXPORT void aria2_engine_add_option(Aria2Engine* e, const char* key, const char* value);
ARIA2_EXPORT int aria2_engine_start(Aria2Engine* e);
ARIA2_EXPORT void aria2_engine_stop(Aria2Engine* e);
ARIA2_EXPORT void aria2_engine_unref(Aria2Engine* e);

ARIA2_EXPORT char* aria2_engine_add_uri(Aria2Engine* e, const char* uri);
ARIA2_EXPORT char* aria2_engine_add_torrent(Aria2Engine* e, const char* path);
ARIA2_EXPORT int aria2_engine_remove(Aria2Engine* e, const char* gid);
ARIA2_EXPORT int aria2_engine_pause(Aria2Engine* e, const char* gid);
ARIA2_EXPORT int aria2_engine_unpause(Aria2Engine* e, const char* gid);
ARIA2_EXPORT int aria2_engine_change_position(Aria2Engine* e, const char* gid, int pos, const char* how);
ARIA2_EXPORT int aria2_engine_change_option(Aria2Engine* e, const char* gid, const char* key, const char* value);

ARIA2_EXPORT char* aria2_engine_tell_status(Aria2Engine* e, const char* gid);
ARIA2_EXPORT char* aria2_engine_tell_active(Aria2Engine* e);
ARIA2_EXPORT char* aria2_engine_get_files( Aria2Engine* e, const char* gid);
ARIA2_EXPORT char* aria2_engine_get_peers(Aria2Engine* e, const char* gid);
ARIA2_EXPORT char* aria2_engine_get_out(Aria2Engine* e, const char* gid);
ARIA2_EXPORT char* aria2_engine_get_dir(Aria2Engine* e, const char* gid);

ARIA2_EXPORT void aria2_engine_set_on_complete(Aria2Engine* e, Aria2NotifyCallback cb, void* user_data);
ARIA2_EXPORT void aria2_engine_set_on_error(Aria2Engine* e, Aria2NotifyCallback cb, void* user_data);

#ifdef __cplusplus
}
#endif
#endif