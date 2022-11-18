## FUFF
**Install:**
* `cd ~/go/src`
* `git clone https://github.com/ffuf/ffuf.git`
* `go get && go build && go install`

**Usuage:**
* Find subdomains: `ffuf -u http://trg -H 'Host: FUZZ.some.htb' -w /usr/share/SecLists/Discovery/DNS/subdomains-top1million-5000.txt`
