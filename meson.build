project ('com.github.gabutakut.gabutdm','vala', 'c', version: '2.6.0')

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
    dependency ('libcurl'),
    dependency ('libadwaita-1'),

    meson.get_compiler ('vala').find_library ('posix'),
]

subdir ('src')

executable (
    meson.project_name (),
    sources,
    dependencies: dependencies,
    install: true
)

subdir ('data')
subdir ('po')

meson.add_install_script ('meson/post_install.py')