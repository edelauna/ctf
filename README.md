# Hecking Toolkit (Set-up)
Helpful notes and a docker image for running some hecker utilities.

## How I use
* Build docker image `docker build -t ctf:latest .`
* Run it `docker run --name ctf -it ctf`
* Run docker image `${cmd_here}`
* Attach to running container from vscode
    * Note: requires remote explorer plugin
* Check out `docs/` section for available utilities and how to use. 
    * Note: `$T` variables represents target IP or DNS
