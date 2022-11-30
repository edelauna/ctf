## SSH

### Set-up
Useful if using openvpn within the container, and then setting up a SOCKs proxy in Burp.
Can therefore modify the /etc/hosts file within container vs. on host machine.
* Add an ssh public key to ~/.ssh/authorized_keys in Docker container
* `ssh -N -D 9090 ctf` - sets up a SOCKS gateway to ssh configured route ctf (not detailed)
* Update Firefox Manual Proxy Settings (Settings -> Network & Settings):
    * SOCKS Host 127.0.0.1 Port: 9090
    * No proxy for localhost or 127.0.0.1
    * Proxy DNS when using SOCKS v5
    * Remote DNS: Goto `about:config` and ensure `network.proxy.socks_remote_dns` is set to use vm `/etc/hosts` file configs
        * Make sure to source host file after modification.

### SSH Tunneling
Note: SSH home and files cannot be writable otherwise will cause ssh errors
* `ssh -L ${A_PORT}:localhost:$(T_PORT} user@$T` - forwards the port
* `ssh -R ${T_PORT}:localhost:${A_PORT} user@$T` - reverse tunnel
* `~` then `C` will open a prompt to add the following to an existing connection

### Hosts Files
To follow redirects can update host files as such
* `echo "$T ${cname.of.redirect}" | sudo tee -a /etc/hosts`
