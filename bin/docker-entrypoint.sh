#!/bin/zsh
sudo mkdir -p /var/run/dbus/
sudo dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address

sudo service ssh restart

exec "$@"
