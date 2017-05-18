# ssss - Stupid Simple Seedbox Script

This is currently a proof-of-concept for a barebone seedbox script. 

It is meant to be a very fast, lean and simple alternative to existing heavy seedbox scripts. 

On comparably modern systems, the script delivers a working seedbox setup in less than 20 seconds.

It installs `transmission-daemon` from the default Ubuntu repository and `caddy` with enabled TLS using Let's Encrypt as reverse proxy for the Transmission web UI and serving the downloaded files.  


It requires systemd and has been tested on Ubuntu 16.04 LTS on following architectures:

`amd64 armv7/armhf arm64`

# Usage

The script is to be used with 3 options, $1 for an existing domain name pointing to the server, $2 for the username and $3 for the password used for accessing Transmission and the file list.

## Example

`sudo sh ssss.sh test.domain.com user password` would create a seedbox on the `test.domain.com` with the username `user` and password `password`.
