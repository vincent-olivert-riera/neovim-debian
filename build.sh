#!/usr/bin/env sh
#
# Build neovim Debian package.

set -eu

NAME="neovim"
VERSION="0.9.0"
TOPDIR="${PWD}"

echo "Create build directory"
rm -Rf build
mkdir build
cd build

echo "Download sources"
wget https://github.com/"${NAME}"/"${NAME}"/archive/refs/tags/v"${VERSION}".tar.gz

echo "Prepare sources"
mv v"${VERSION}".tar.gz "${NAME}"_"${VERSION}".orig.tar.gz
tar xf "${NAME}"_"${VERSION}".orig.tar.gz
cd "${NAME}"-"${VERSION}"
cp -R ../../debian .

echo "Install build dependencies"
sudo mk-build-deps \
    --install \
    --tool="apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends --yes" \
    debian/control

echo "Build package"
debuild -b -us -uc

echo "Test installation"
dpkg --dry-run -i ../"${NAME}"_"${VERSION}"*.deb

echo "Delete debug deb files"
rm -f ../"${NAME}"*-dbgsym_"${VERSION}"*.deb

echo "Move package to the top directory"
mv ../"${NAME}"_"${VERSION}"*.deb "${TOPDIR}"/

# Return to the top directory
cd "${TOPDIR}"

echo "Clean build directory"
rm -Rf build
