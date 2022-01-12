project ('com.github.gabutakut.gabutdm','vala', 'c', version: '1.6.9')

i18n = import ('i18n')

vapi = join_paths (meson.current_source_dir (), 'vapi')
add_project_arguments ('-DGETTEXT_PACKAGE="' + meson.project_name () + '"'.format (meson.project_name ()), language:'c')
add_project_arguments (['--vapidir', vapi], language: 'vala')

dbusmenu_glib_dep = dependency ('dbusmenu-glib-0.4', required: false)
if dbusmenu_glib_dep.found ()
    add_project_arguments ('--define', 'HAVE_DBUSMENU', language: 'vala')
endif

dependencies = [
    dependency ('glib-2.0'),
    dependency ('gtk+-3.0'),
    dependency ('sqlite3'),
    dependency ('libcanberra'),
    dependency ('gdk-x11-3.0'),
    dependency ('xtst'),
    dependency ('x11'),
    dependency ('libsoup-2.4'),
    dependency ('gee-0.8'),
    dependency ('json-glib-1.0'),
    dependency ('libqrencode'),
    dependency ('gdk-pixbuf-2.0'),
    dependency ('cairo'),
    dependency ('libhandy-1'),
    dbusmenu_glib_dep,

    meson.get_compiler ('vala').find_library ('Dbusmenu-0.4', required : false),
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