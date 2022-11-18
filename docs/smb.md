## SMB

### SMBClient
**Installation:**
* `sudo apt-get install smbclient`

**Usage:**
* `smbclient -L $T`
    * `-U Administrator` to check if paswordless is allowed
    * Note: lookup PSexec.py from Impacket for "loud" attack

### enum4linux
Tool for enumerating data from Windows and Samba hosts
**Installation:**
* `cd /opt/`
* `git clone https://github.com/CiscoCXSecurity/enum4linux.git`
* `sudo vim /usr/local/bin/enum4linux`
* Add following into script:
    ```pl
    #!/usr/bin/perl
    exec "/opt/enum4linux/enum4linux.pl @ARGV";
    ```
* `chmod +x /usr/local/bin/enum4linux`

**Usage:**
* `enum4linux -a $T`