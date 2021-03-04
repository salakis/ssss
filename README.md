# ssss - Stupid Simple Seedbox Script

This is currently a proof-of-concept for a barebone seedbox script.

It is meant to be a very fast, lean and simple alternative to existing heavy seedbox scripts. 

On comparably modern systems, the script delivers a working seedbox setup in about 30 seconds.

It installs `transmission-daemon` from the default repository and `caddy` with enabled auto-updated TLS (Let's Encrypt) acting as reverse proxy for the Transmission web UI as well as a HTTPS file server for the downloaded files.

This script relies on the official Caddy .deb repository on cloudsmith.io, which is currently providing Caddy packages for the following architectures:

`amd64 arm64 armel armel armhf ppc64el s390x`

Additonally, it's currently only working properly if caddy can bind on ports 80 and 443 (both ports have to be externally reachable).

# Usage

The script is to be used with 3 options, $1 for an existing domain name pointing to the server, $2 for the username and $3 for the password used for accessing Transmission and the file list.

## Example

First, download the script using wget and make it executable.

`wget https://raw.githubusercontent.com/salakis/ssss/master/ssss.sh && chmod +x ssss.sh`

Then, run it as root with all relevant variables.

`sudo sh ssss.sh test.domain.com user password` would create a seedbox on the `test.domain.com` with the username `user` and password `password`.

# Disclaimer

I am not responsible for anything this script ends up doing, I tested it (to some extent) and it shouldn't do any harm, but please use it with caution.
