# Install icons
install_data (
    join_paths ('icons', 'apps', meson.project_name () + '.svg'),
    install_dir: join_paths (get_option ('datadir'), 'icons', 'hicolor', 'scalable', 'apps')
)

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
    '.seedloopx.svg',
    '.seedloopy.svg',
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
    '.menu.svg',
    '.onactive.svg',
    '.amchok.svg',
    '.amchoking.svg',
    '.peerchok.svg',
    '.peerchoking.svg'
]

foreach m : actions
    install_data(
        join_paths('icons', 'actions', meson.project_name() + m),
        install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', 'scalable' , 'actions')
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