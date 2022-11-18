## SNMP

### Mibs Downloader
**Install:**
* `apt-get install snmp-mibs-downloader`
* `download-mibs`

### Brute force Community String
* `sudo nmap -sU --script snmp-brute trg --script-args snmp-brute.communitiesdb=/usr/share/SecLists/Discovery/SNMP/snmp.txt`

### snmpwalk
**Install:**
* `sudo apt-get install snmp`

**Usage:**
* `snmpwalk -v 2c -c public $T` : I think `public` may be the same string passed in nmap scan eg: `SNMPv1 server (public)`
