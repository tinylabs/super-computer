#!/bin/bash
#
# Cross compile arm packages needed
#

# Point to root fs
ROOTFS=${PWD}/mnt/ext4

# Install dependencies
sudo apt install autoconf libtool libconfig-dev

# Cross compile libconfig
cd libconfig
git co -- .
git clean -d -f
git submodule update
autoreconf -i
make distclean
./configure --host=arm-linux-gnueabihf --with-sysroot=${ROOTFS}
make CFLAGS="--sysroot=${ROOTFS}"
sudo make DESTDIR=${ROOTFS} PREFIX=/usr/local install
cd ../

# Cross compile libusbgx
cd libusbgx
git co -- .
git clean -d -f
git submodule update
autoreconf -i
make distclean
PKG_CONFIG_PATH=${ROOTFS}/usr/lib/arm-linux-gnueabihf/pkgconfig \
        ./configure                                             \
        --host=arm-linux-gnueabihf                              \
        --prefix='=/usr/local'                                  \
        --with-sysroot=${ROOTFS}
make clean
make LDFLAGS="--sysroot=${ROOTFS}"
sudo make DESTDIR=${ROOTFS} PREFIX=/usr/local install
cd ../

# Cross compile gt
cd gt
git co -- .
git clean -d -f
git submodule update
cp ../armhf-toolchain.txt source
cd source
rm -rf build
mkdir build
cd build
PKG_CONFIG_PATH=${ROOTFS}/usr/local/lib/pkgconfig               \
               cmake                                            \
               -DROOTFS=${ROOTFS}                               \
               -DCMAKE_INSTALL_PREFIX=${ROOTFS}/usr/local       \
               -DCMAKE_TOOLCHAIN_FILE=armhf-toolchain.txt ..
make VERBOSE=1
sudo make DESTDIR=${ROOTFS} install
cd ../../../
