#!/bin/zsh

#   openvpn setup   #
#####################
if [ ! -c /dev/net/tun ]; then
    sudo mknod /dev/net/tun c  10 200
fi

sudo mkdir -p /var/run/dbus/
sudo dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address

#     ssh   setup   #
#####################
sudo service ssh restart

exec "$@"
