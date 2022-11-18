## Gobuster

### Installation
* Manual install on machine using root access to install Go version > 1.16
* `go install github.com/OJ/gobuster/v3@latest`
* Had to update profile to also look into `$HOME/${user}/go/bin` for executables
* Needed to download own set of word lists - used this repo: https://github.com/v0re/dirb/blob/master/wordlists/common.txt
* Later referred to SecLists: https://github.com/danielmiessler/SecLists.git
    * Used word list found in Discover/WebContent/... installed to `/usr/share/SecLists` in vm

### Usage
* `gobuster dir -w /usr/share/wordlists/common.txt -u $T`
* `gobuster vhost -w /use/share/wordlists/ -u $T -k` - for subdomain discovery
