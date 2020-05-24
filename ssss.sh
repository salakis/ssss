#!/bin/bash
echo "deb [trusted=yes] https://apt.fury.io/caddy/ /" \
    | tee -a /etc/apt/sources.list.d/caddy-fury.list
mkdir /var/torrent
mkdir /var/torrent/downloads
apt update
apt install -y caddy transmission-daemon
systemctl stop caddy
systemctl stop transmission-daemon
rm /etc/caddy/Caddyfile
PW=`caddy hash-password --plaintext $3`
cat > /etc/caddy/Caddyfile << EOL
https://$1
root * /var/torrent/
file_server {
	browse
	}
reverse_proxy /transmission/* localhost:9091
basicauth /downloads/* {
	$2 $PW
	}
EOL
chmod 444 /etc/caddy/Caddyfile
wget -O /var/torrent/torrent.svg https://upload.wikimedia.org/wikipedia/commons/4/46/Transmission_Icon.svg
wget -O /var/torrent/folder.svg https://upload.wikimedia.org/wikipedia/commons/8/8f/Gnome-folder-open.svg
cat > /var/torrent/index.html << EOL
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Seedbox</title>
</head>
<style>
	h1 {
		font-family: sans-serif;
		font-weight: 900
	}
	
	p {
		font-family: sans-serif;
		font-weight: 300
	}
	</style>
<body>
<table width="700" border="0" align="center">
  <tr>
    <td><div align="center"><h1>Welcome to your seedbox</h1></div></td>
  </tr>
  <tr>
    <td><table width="100%" border="0" cellpadding="10">
      <tr>
        <td><a href="/transmission/web/" target="_top"><img src="torrent.svg" alt="Go to Transmission web UI" width="300" height="300" border="0"/></a></td>
        <td><a href="/downloads/" target="_top"><img src="folder.svg" alt="Go to file list" width="300" height="300" border="0"/></a></td>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td><br/>
    <br/>
    <br/></td>
  </tr>
  <tr>
    <td><div align="center"><p>Powered by: <a href=https://github.com/salakis/ssss>Stupid Simple Seedbox Script</a></p></div></td>
  </tr>
</table>
<br/>
</body>
</html>
</html>
EOL
chown -R -f debian-transmission:debian-transmission /var/torrent
rm /etc/transmission-daemon/settings.json
cat > /etc/transmission-daemon/settings.json << EOL
{
    "alt-speed-down": 50, 
    "alt-speed-enabled": false, 
    "alt-speed-time-begin": 540, 
    "alt-speed-time-day": 127, 
    "alt-speed-time-enabled": false, 
    "alt-speed-time-end": 1020, 
    "alt-speed-up": 50, 
    "bind-address-ipv4": "0.0.0.0", 
    "bind-address-ipv6": "::", 
    "blocklist-enabled": false, 
    "blocklist-url": "http://www.example.com/blocklist", 
    "cache-size-mb": 4, 
    "dht-enabled": true, 
    "download-dir": "/var/torrent/downloads", 
    "download-limit": 100, 
    "download-limit-enabled": 0, 
    "download-queue-enabled": true, 
    "download-queue-size": 5, 
    "encryption": 1, 
    "idle-seeding-limit": 30, 
    "idle-seeding-limit-enabled": false, 
    "incomplete-dir": "/var/lib/transmission-daemon/Downloads", 
    "incomplete-dir-enabled": false, 
    "lpd-enabled": false, 
    "max-peers-global": 200, 
    "message-level": 1, 
    "peer-congestion-algorithm": "", 
    "peer-id-ttl-hours": 6, 
    "peer-limit-global": 200, 
    "peer-limit-per-torrent": 50, 
    "peer-port": 51413, 
    "peer-port-random-high": 65535, 
    "peer-port-random-low": 49152, 
    "peer-port-random-on-start": false, 
    "peer-socket-tos": "default", 
    "pex-enabled": true, 
    "port-forwarding-enabled": false, 
    "preallocation": 1, 
    "prefetch-enabled": 1, 
    "queue-stalled-enabled": true, 
    "queue-stalled-minutes": 30, 
    "ratio-limit": 2, 
    "ratio-limit-enabled": false, 
    "rename-partial-files": true, 
    "rpc-authentication-required": true, 
    "rpc-bind-address": "0.0.0.0", 
    "rpc-enabled": true, 
    "rpc-password": "$3", 
    "rpc-port": 9091, 
    "rpc-url": "/transmission/", 
    "rpc-username": "$2", 
    "rpc-whitelist": "127.0.0.1", 
    "rpc-whitelist-enabled": true, 
    "scrape-paused-torrents-enabled": true, 
    "script-torrent-done-enabled": false, 
    "script-torrent-done-filename": "", 
    "seed-queue-enabled": false, 
    "seed-queue-size": 10, 
    "speed-limit-down": 100, 
    "speed-limit-down-enabled": false, 
    "speed-limit-up": 100, 
    "speed-limit-up-enabled": false, 
    "start-added-torrents": true, 
    "trash-original-torrent-files": false, 
    "umask": 18, 
    "upload-limit": 100, 
    "upload-limit-enabled": 0, 
    "upload-slots-per-torrent": 14, 
    "utp-enabled": true
}
EOL
systemctl start transmission-daemon
systemctl start caddy
