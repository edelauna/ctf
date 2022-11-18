## Nmap

### Installation
* `sudo apt-get install nmap`

## Usage
* `nmap (-sV|-Pn) -sC ${target_IP}`
    * `-sV:` Enables version detection, which will detect what versions are running on the what port
    * `-sC:` Performes a script scan using default set of scripts. Some are intrusive and should not be run witout permissions
    * `-Pn`: skips host discover... good to use instead of `-sV` if a firewall may be present
    * `-sU`: UDP port scan (takes considerably longer, requires sudo)
    * `p$ports`: Where:
        * `ports=$(nmap -p- --min-rate=1000 -T4 trg | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//)` : identifies open ports
        * tcp: `sudo nmap -p$ports -sSCV -v -oA nmap.tcp -T4 trg`
        * udp: `sudo nmap -p- --min-rate=1000 -sCUV --open -v -oA nmap.udp -T4 trg`
        * indepth: `sudo nmap -p$ports -sSCV -v -oA nmap.tcp -T4 trg;sudo nmap -sCUV --open -v -oA nmap.udp -T4 trg;`