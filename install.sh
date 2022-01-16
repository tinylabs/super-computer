#!/bin/bash
#
# Install super-computer base and all dependencies
#
echo 'Installing super-computer for Raspberry Pi Zero W...'
echo 'Installing dependencies'
sudo apt install git build-essential autoconf libtool libconfig-dev cmake dnsmasq bridge-utils

# Cloning this directory
echo 'Cloning super-computer git repo...'
git clone https://github.com/tinylabs/super-computer.git
cd super-computer

echo 'Compiling/installing dependencies from source'
mkdir sw/build && cd sw/build
cmake ../
make
echo 'Installing base super-computer package in /opt/sc/'
sudo make install

echo 'Update /boot/config.txt to add dwc2 overlay'
# Enable ethernet gadget
# dtoverlay=dwc2

echo 'Update /boot/cmdline.txt to load dwc2,libcomposite'
# Load modules on boot in cmdline.txt
#    ... rootwait modules-load=dwc2,libcomposite

echo 'Create bridge between usb-ethernet and wlan'
sudo brctl addbr br0
sudo brctl addif br0 usb0

echo 'Installing cron job to check for updates'

echo 'Default repo at /opt/sc/repo.d/'
echo 'Add additional repos for the UI to pick up'

echo 'Done! - Reboot now'
