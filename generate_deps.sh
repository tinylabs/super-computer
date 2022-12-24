#!/bin/bash
#
# This must be run on the pi to download the package urls based on the distribution.
# The resulting packages are installed offline to allow us to talk to papirus before wifi is up.
#
# Run this on raspios lite version to ensure we get all packages.
# After raspios gets updated:
# - Install the lite version
# - Copy this script over
# - Run this script
# - Copy debs directory back to install/debs/
#
sudo apt update
for PKG in git bc i2c-tools fonts-freefont-ttf whiptail make gcc python3-pil python3-smbus python3-dateutil python3-distutils libconfig-dev libfuse-dev autoconf libtool cmake; do
    sudo apt-get install -y --download-only $PKG   
done

# Copy packages back to home
mkdir debs
cp /var/cache/apt/archives/*.deb debs
echo "All deps downloaded to debs, add these to the supercomputer installation"
