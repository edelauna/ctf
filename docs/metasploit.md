## Metasploit
Requirements: 4GB of Ram - installed on john server

**Install:**
Ref: [Install on Linux](https://docs.rapid7.com/metasploit/installing-the-metasploit-framework/#installing-the-metasploit-framework-on-linux)
* `curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall`


**Usage:**
* `msfconsole` - `y` to setup new database
* `db_status` to confirm working
Payloads:
  * `msfvenom -l payloads`
  * `msfvenom -p $payload LHOST=$A LPORT=$port -f $(format - eg. msi) > $outFile`