#!/bin/bash
#
# Boot script that runs everytime supercomputer boots.
#

# Check if installation is complete
if test -f "/opt/sc/install/installed.txt"; then

    # Set screen size
    papirus-set 2.0

    # Display splash screen
    papirus-draw /opt/sc/boot_logo.png

    # Launch python UI
else
    # Run setup - will automatically reboot
    /opt/sc/install/install.sh &> /opt/sc/install/install.log
fi
