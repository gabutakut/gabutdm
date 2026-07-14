pkgname=gabutdm-master
_pkgname=gabutdm

pkgver=2.9.4
pkgrel=2

pkgdesc="Simple, fast, and powerful Download Manager built with GTK4"
arch=('x86_64')

url="https://github.com/gabutakut/gabutdm"

license=('LGPL2.1')

depends=(
  'glib2'
  'gtk4'
  'sqlite'
  'libcanberra'
  'libsoup3'
  'libgee'
  'json-glib'
  'qrencode'
  'gdk-pixbuf2'
  'cairo'
  'libadwaita'
  'ffmpeg'
  'aria2'
)

makedepends=(
  'meson'
  'ninja'
  'vala'
  'pkg-config'
)

source=("$_pkgname-$pkgver.tar.gz::https://github.com/gabutakut/gabutdm/archive/refs/tags/${pkgver}.tar.gz")

sha256sums=('SKIP')

build() {
  cd "$srcdir/$_pkgname-$pkgver"

  meson setup build \
    --prefix=/usr \
    --buildtype=release

  ninja -C build
}

package() {
  cd "$srcdir/$_pkgname-$pkgver"

  DESTDIR="$pkgdir" ninja -C build install
}
