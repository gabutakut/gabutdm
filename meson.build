project ('com.github.gabutakut.gabutdm','vala', 'c', version: '2.8.8')

i18n = import ('i18n')

vapi = join_paths (meson.current_source_dir (), 'vapi')
add_project_arguments ('-DGETTEXT_PACKAGE="' + meson.project_name () + '"'.format (meson.project_name ()), language:'c')
add_project_arguments (['--vapidir', vapi], language: 'vala')

dependencies = [
    dependency ('glib-2.0'),
    dependency ('gtk4'),
    dependency ('sqlite3'),
    dependency ('libcanberra'),
    dependency ('libsoup-3.0'),
    dependency ('gee-0.8'),
    dependency ('json-glib-1.0'),
    dependency ('libqrencode'),
    dependency ('gdk-pixbuf-2.0'),
    dependency ('cairo'),
    dependency ('libadwaita-1'),
    dependency ('libavformat'),
    dependency ('libavcodec'),
    dependency ('libavutil'),
    dependency ('libaria2'),
    dependency ('libswscale'),
    dependency ('libswresample'),
    meson.get_compiler ('vala').find_library ('aria2_wrapper', dirs: vapi),
    meson.get_compiler ('vala').find_library ('ffmpeg_merger', dirs: vapi),
    meson.get_compiler ('c').find_library ('m'),
    meson.get_compiler ('vala').find_library ('posix'),
]

subdir ('src')
subdir ('data')
subdir ('po')

meson.add_install_script ('meson/post_install.py')