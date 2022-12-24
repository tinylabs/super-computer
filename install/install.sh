#!/bin/bash
#
# Install the supercomputer framework
# This only happens once on boot and requires no internet connection
#
# MUST be run as root
#

# debug
set -x

# Check installation not already done
if test -f "/opt/sc/install/installed.txt"; then
    echo "Supercomputer already installed"
    exit -1
fi

# Go to install dir
cd /opt/sc/install/

# Install dependencies
dpkg -i debs/*

# Enable i2c and spi
raspi-config nonint do_spi 0
raspi-config nonint do_i2c 0

# Install papirus
cd PaPiRus/
python3 setup.py install
cd ../

# Install papirus driver
cd gratis
make rpi EPD_IO=epd_io.h PANEL_VERSION='V231_G2'
make rpi-install EPD_IO=epd_io.h PANEL_VERSION='V231_G2'
systemctl enable epd-fuse.service
cd ../

# Install usb gadget drivers
cd libusbgx
# Missing ltmain.sh after first one - gets copied to dir
# above. Copy it back
autoreconf -i
mv ../ltmain.sh .
./configure
make
make install
cd ../
ldconfig

cd gt/source
mkdir build
cd build
cmake ../
make
make install
cd ../../../

# Enable ssh
raspi-config nonint do_ssh 0

# Prevent overwriting our custom kernel
apt-mark hold raspberrypi-kernel raspberrypi-kernel-headers

# Mark installation finished
touch /opt/sc/install/installed.txt

# Reboot
reboot -h now
