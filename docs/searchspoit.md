## Searchsploit 
**Install:**
* `git clone https://github.com/offensive-security/exploitdb.git /opt/exploit-database`
* `ln -sf /opt/exploit-database/searchsploit /usr/local/bin/searchsploit` - ensure `/usr/local/bin` is in path via `echo $PATH`
* `cp -n /opt/exploit-database/.searchsploit_rc ~/`
* `vim ~/.searchsploit_rc` - [See for more info](https://www.exploit-db.com/searchsploit#installgit)
* `searchsploit -u`

**Usage:**
* `searchsploit -u` - update
* `searchsploit ${name}`
* `searchsploit -m ${num}.py` - to view code