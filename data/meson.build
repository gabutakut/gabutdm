# Install icons
icon_sizes = ['16', '24', '32', '48', '64', '128']

foreach i : icon_sizes
    install_data (
        join_paths ('icons', i, meson.project_name () + '.svg'),
        install_dir: join_paths (get_option ('datadir'), 'icons', 'hicolor', i + 'x' + i, 'apps')
    )
    install_data (
        join_paths ('icons', i, meson.project_name () + '.svg'),
        install_dir: join_paths (get_option ('datadir'), 'icons', 'hicolor', i + 'x' + i + '@2', 'apps')
    )
endforeach

actions = [
    '.active.svg',
    '.complete.svg',
    '.error.svg',
    '.pause.svg',
    '.magnet.svg',
    '.waiting.svg',
    '.clear.svg',
    '.seed.svg',
    '.seedloop.svg',
    '.metalink.svg',
    '.find.svg',
    '.insertlink.svg',
    '.settings.svg',
    '.gohome.svg',
    '.delete.svg',
    '.referer.svg',
    '.hash.svg',
    '.theme.svg',
    '.torrent.svg',
    '.up.svg',
    '.down.svg',
    '.client.svg',
    '.uri.svg',
    '.hdd.svg',
    '.date.svg',
    '.svdrv.svg',
    '.cookie.svg',
    '.opt.svg',
    '.menu.svg'
]

foreach m : actions
    install_data(
        join_paths('icons', 'actions', meson.project_name() + m),
        install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', '16x16' , 'apps')
    )
    install_data(
        join_paths('icons', 'actions', meson.project_name() + m),
        install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', '24x24' , 'apps')
    )
    install_data(
        join_paths('icons', 'actions', meson.project_name() + m),
        install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', '32x32' , 'apps')
    )
    install_data(
        join_paths('icons', 'actions', meson.project_name() + m),
        install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', '48x48' , 'apps')
    )

endforeach

# Translate and install our .desktop file so the Applications Menu will see it
i18n.merge_file (
    input: meson.project_name () + '.desktop.in',
    output: meson.project_name () + '.desktop',
    po_dir: join_paths (meson.source_root (), 'po', 'extra'),
    type: 'desktop',
    install: true,
    install_dir: join_paths (get_option ('datadir'), 'applications')
)
i18n.merge_file (
    input: meson.project_name () + '.startup.desktop.in',
    output: meson.project_name () + '.startup.desktop',
    po_dir: join_paths (meson.source_root (), 'po', 'extra'),
    type: 'desktop',
    install: true,
    install_dir: join_paths(get_option('sysconfdir'), 'xdg', 'autostart')
)

i18n.merge_file (
    input: meson.project_name () + '.appdata.xml.in',
    output: meson.project_name () + '.appdata.xml',
    po_dir: join_paths (meson.source_root (), 'po', 'extra'),
    install: true,
    install_dir: join_paths (get_option ('datadir'), 'metainfo')
)