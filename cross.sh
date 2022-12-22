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
        --prefix=/usr/local                                     \
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
cp ../files/armhf-toolchain.txt source
cd source
PKG_CONFIG_PATH=${ROOTFS}/usr/lib/arm-linux-gnueabihf           \
               cmake                                            \
               -DCMAKE_SYSROOT=${ROOTFS}                        \
               -DCMAKE_INSTALL_PREFIX=${ROOTFS}                 \
               -DCMAKE_RUNTIME_PREFIX=/                         \
               -DCMAKE_TOOLCHAIN_FILE=armhf-toolchain.txt .
make CFLAGS="--sysroot=${ROOTFS}"
sudo make install

