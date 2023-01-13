#!/usr/bin/env sh
#
# Build neovim Debian package.

set -eu

VERSION=0.8.2
TOPDIR="${PWD}"

echo "Create build directory"
rm -Rf build
mkdir build
cd build

echo "Download sources"
wget https://github.com/neovim/neovim/archive/refs/tags/v"${VERSION}".tar.gz

echo "Prepare sources"
mv v"${VERSION}".tar.gz neovim_"${VERSION}".orig.tar.gz
tar xf neovim_"${VERSION}".orig.tar.gz
cd neovim-"${VERSION}"
cp -R ../../debian .

echo "Install build dependencies"
sudo mk-build-deps \
--install \
--tool="apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends --yes" \
debian/control

echo "Build package"
debuild -b -us -uc

echo "Test installation"
dpkg --dry-run -i ../neovim_"${VERSION}"*.deb

echo "Delete debug deb files"
rm -f ../neovim*-dbgsym_"${VERSION}"*.deb

echo "Move package to the top directory"
mv ../neovim_"${VERSION}"*.deb "${TOPDIR}"/

# Return to the top directory
cd "${TOPDIR}"

echo "Clean build directory"
rm -Rf build
