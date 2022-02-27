# Dependencies
    sudo apt install git build-essential autoconf libtool libconfig-dev cmake iptables-persistent
# Setup static IP
# /etc/dhcpcd.conf
    interface usb0
    static ip_address=192.168.2.1
    static domain_name_servers=1.1.1.1 8.8.8.8
    
# Configure DHCP
# /etc/dnsmasq.conf
    interface=usb0
    bind-dynamic
    domain-needed
    bogus-priv
    dhcp-range=192.168.1.100,192.168.1.200,255.255.255.0,12h
    dhcp-option=option:router,192.168.2.1
    dhcp-option=option:dns-server,192.168.2.1

# /etc/network/interfaces
    #auto wlan0
    allow-hotplug wlan0
    allow-hotplug usb0
    iface usb0 inet manual

    #auto br0
    #iface br0 inet dhcp
    #bridge_ports usb0 wlan0

# Setup NAT from usb0 <=> wlan0
    sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
    sudo iptables-save > /etc/iptables/rules.v4
# Enable packet forwarding (disable ipv6 redirects)
    sudo sysctl -w net.ipv4.ip_forward=1 >> /etc/sysctl.d/88-sc-networking.conf
    sudo sysctl -w net.ipv4.conf.all.send_redirects=0 >> /etc/sysctl.d/88-sc-networking.conf
    sudo sysctl -w net.ipv6.conf.all.forwarding=1 >> /etc/sysctl.d/88-sc-networking.conf
    sudo sysctl -w net.ipv6.conf.all.accept_redirects=0 >> /etc/sysctl.d/88-sc-networking.conf
    sudo sysctl --system

    sudo sysctl -w net.ipv4.ip_forward=1
    sudo sysctl -w net.ipv4.conf.all.send_redirects=0
    sudo sysctl -w net.ipv6.conf.all.forwarding=1
    sudo sysctl -w net.ipv6.conf.all.accept_redirects=0
    sudo sysctl --system

# Use mtools to copy configuration files to/from vfat partition

# For remote connections scan for access points and try the following:
- spoof mac and deauth client / release / renew
- Connect to tunnel over iodine
- WPS7 PIN attack -
  https://rafalharazinski.gitbook.io/security/personal-projects/wifi-penetration-testing/wps-attack-pin-bruteforce
- Capture WPA2 handshake, etc, log info
- send to crack server when online
