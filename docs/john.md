## John the Ripper

**Install:**
* Reference [INSTALL.MD](https://github.com/openwall/john/blob/bleeding-jumbo/doc/INSTALL-UBUNTU)
* Updated `~/.bash_aliases` to include aliases for `john` and `zip2john` executables installed in `~/src/john`
* Also installed `SecLists` and unzipped rockyou.txt for cracking

**Key Commands:**
* Password protected zips: `zip2john ${thezip} > hashes`
* Cracking: `john -wordlist=/usr/share/SecLists/Passwords/Leaked-Databases/rockyou.txt hashes`