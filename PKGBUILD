pkgname=gabutdm-master
pkgver=2.8.7
pkgrel=2
pkgdesc="Simple, fast, and powerful Download Manager built with GTK4"
arch=('x86_64')
url="https://github.com/gabutakut/gabutdm"
license=('LGPL2.1')

depends=(
  'gtk4'
  'libadwaita'
  'libsoup3'
  'libgee'
  'json-glib'
  'libqrencode'
  'libcanberra'
  'glib2'
  'sqlite'
  'gdk-pixbuf2'
  'cairo'
  'ffmpeg'
  'aria2'
)

makedepends=(
  'meson'
  'ninja'
  'vala'
  'pkgconf'
  'git'
)

source=("$pkgname-$pkgver.tar.gz::https://github.com/gabutakut/gabutdm/archive/refs/tags/${pkgver}.tar.gz")
sha256sums=('SKIP')

build() {
  cd "$pkgname-$pkgver"
  meson setup build \
    --prefix=/usr \
    --buildtype=release
  ninja -C build
}

package() {
  cd "$pkgname-$pkgver"
  DESTDIR="$pkgdir" ninja -C build install
}
