## OpenVPN

### Installation:
* `sudo apt-get install apt-transport-https`
* `sudo wget https://swupdate.openvpn.net/repos/openvpn-repo-pkg-key.pub`
* `sudo apt-key add openvpn-repo-pkg-key.pub`
* `DISTRO=focal` - assuming ubuntu 20.04
* `sudo wget -O /etc/apt/sources.list.d/openvpn3.list https://swupdate.openvpn.net/community/openvpn3/repos/openvpn3-$DISTRO.list`
* `sudo apt update`
* `sudo apt install openvpn3`

    dbus:
    * `sudo apt-get install apt-transport-https`
    *  `dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address`
      * Will require this to be set within an ENTRYPOINT

`/etc/systemd/system/openvpn-client@pia.service.d/override.conf`

### Usage
Copy file from local to vm using scp:
* `scp ~/Downloads/starting_point.ovpn ctf:/home/dev/openvpn/configs` -assumed ssh config setup for htb configuration

* Add profile: `openvpn3 config-import --config starting_point.ovpn --name ctf`
* Latest version of openvpn3 doesn't like AES-126-CBC - may need to enable
    * `openvpn3 config-manage --config ctf --enable-legacy-algorithms true`
* Connect: `openvpn3 session-start --config ctf`
* Disconnect : `openvpn3 session-manage --config ctf --disconnect`
* Find my ip: `ifconfig | grep tun0 -A 1`
