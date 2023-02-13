#!/bin/zsh

#   openvpn setup   #
#####################

sudo mkdir -p /openvpn{/pid,/sock,/tmp} /dev/net /config/log /config/etc/tmp

if [ ! -c /dev/net/tun ]; then
    sudo mknod /dev/net/tun c  10 200
fi

# dbus setup
sudo mkdir -p /var/run/dbus/
sudo dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address

#     ssh   setup   #
#####################
sudo service ssh restart

exec "$@"
