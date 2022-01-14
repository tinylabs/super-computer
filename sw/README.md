# Setup static IP
# /etc/dhcpcd.conf
interface usb0
static ip_address=192.168.2.1
static routers=192.168.2.1
static domain_name_servers=192.168.2.1 8.8.8.8

# Configure DHCP
# /etc/dnsmasq.conf
interface=usb0
bind-dynamic
domain-needed
bogus-priv
dhcp-range=192.168.1.100,192.168.1.200,255.255.255.0,12h

# Setup bridge
#sudo brctl addbr br0
#sudo brctl addif br0 eth0

# /etc/network/interfaces
#auto wlan0
allow-hotplug wlan0
allow-hotplug usb0
iface usb0 inet manual

#auto br0
#iface br0 inet dhcp
#bridge_ports usb0 wlan0

# Setup NAT from usb0 <=> wlan0