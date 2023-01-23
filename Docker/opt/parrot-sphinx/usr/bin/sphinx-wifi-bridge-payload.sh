#!/bin/ash
set -e

source /tmp/sphinx.env
source /etc/profile
PATH=/sbin/:$PATH

ANAFI_6DB_REVISION=3
MPP3_6DB_REVISION=2
PRODUCT=$(gprop "ro.hardware")
HW_REVISION=$(gprop "ro.revision")
QCA6174_BDF_10DB="bdf=\"bdwlan30_10db.bin\""

# Redirect stdout and stderr to ulog
exec 1> /dev/ulog_main 2>&1

ulog() {
	level="$1"
	message="$2"
	ulog_tag="sphinx-wifi-bridge"
	printf "%d\0\0\0%s\0%s\n" "${level}" "${ulog_tag}" "${message}"
}

ULOG_CRIT=2
ULOG_ERR=3
ULOG_WARN=4
ULOG_NOTICE=5
ULOG_INFO=6
ULOG_DEBUG=7

mesg() {
	ulog $ULOG_NOTICE "$1"
}

err() {
	ulog $ULOG_ERR "$1"
}

ulogcat -c
mesg "sphinx hw bridge setup..."
# gracefully stop wifid and stop other dragonfly services
pterm -w 10 wifid
stop
pterm dnsmasq_wlan0
pterm dnsmasq_usb0
pterm avahi-daemon
echo 1 > /proc/sys/net/ipv4/ip_forward
echo 1 > /proc/sys/net/ipv4/conf/all/proxy_arp
if ! ip link show br0; then
	ip link add name br0 type bridge
fi
ip link set dev wlan0 down || true
ip link set dev usb0 down || true
ip link set dev br0 down

# The following seems to be necessary,
# without this, the SSID is not visible
modprobe -r wlan
if [ "${PRODUCT}" == "anafi4k" ] && [ ${HW_REVISION} -lt ${ANAFI_6DB_REVISION} ]; then
	echo "Load BDF Anafi 10DB"
	modprobe wlan "${QCA6174_BDF_10DB}"
elif [ "${PRODUCT}" == "mpp3" ] && [ ${HW_REVISION} -lt ${MPP3_6DB_REVISION} ]; then
	echo "Load BDF MPP3 10DB"
	modprobe wlan "${QCA6174_BDF_10DB}"
else
	echo "Load default BDF"
	modprobe wlan
fi

ip link set dev br0 up
ip link set dev wlan0 up
ip link set dev usb0 up

# wlan0 AP needs to be setup before this interface is added to the bridge
# just let the wifid do its magic
sprop wifid.bridge "${SPHINX_WIFI_BRIDGE_IP%/*}"
pstart wifid
sleep 1
ip link set dev wlan0 master br0
ip link set dev usb0 master br0

# drop all configured ip addresses
ip addr flush dev wlan0
ip addr flush dev usb0
ip route flush table local
ip route flush table main

# Route subnets traffic to the bridge interface:
#  wifi subnet
ip route add "${SPHINX_WIFI_SUBNET}" dev br0
#  rndis subnet:
#   the following also add an rndis subnet ip address over the
#   bridge interface
ip addr add "${SPHINX_WIFI_BRIDGE_IP}" dev br0

# flush arp cache
ip neigh flush all

mesg "sphinx hw bridge setup completed"
