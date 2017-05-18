#!/bin/bash
mkdir /etc/caddy
mkdir /var/torrent
mkdir /var/torrent/downloads
apt-get update
apt-get install -y transmission-daemon
wget -qO- https://getcaddy.com | bash
cat > /etc/caddy/Caddyfile << EOL
https://$1
root /var/torrent/
browse
proxy /transmission localhost:9091 {
        transparent
}
basicauth /downloads $2 $3
EOL
chown root:root /usr/local/bin/caddy
chmod 755 /usr/local/bin/caddy
setcap 'cap_net_bind_service=+ep' /usr/local/bin/caddy
groupadd -g 33 www-data
useradd \
  -g www-data --no-user-group \
  --home-dir /var/www --no-create-home \
  --shell /usr/sbin/nologin \
  --system --uid 33 www-data
chown -R root:www-data /etc/caddy
mkdir /etc/ssl/caddy
chown -R www-data:root /etc/ssl/caddy
chmod 0770 /etc/ssl/caddy
chown www-data:www-data /etc/ssl/caddy
chown www-data:www-data /etc/caddy/Caddyfile
chmod 444 /etc/caddy/Caddyfile
wget -O /etc/systemd/system/caddy.service "https://github.com/mholt/caddy/raw/master/dist/init/linux-systemd/caddy.service"
chown root:root /etc/systemd/system/caddy.service
chmod 644 /etc/systemd/system/caddy.service
systemctl daemon-reload
systemctl start caddy.service
systemctl enable caddy.service
service transmission-daemon stop
wget -O /var/torrent/torrent.svg https://upload.wikimedia.org/wikipedia/commons/4/46/Transmission_Icon.svg
wget -O /var/torrent/folder.svg https://upload.wikimedia.org/wikipedia/commons/8/8f/Gnome-folder-open.svg
cat > /var/torrent/index.html << EOL
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">

  <title>Seedbox</title>
<link href="https://fonts.googleapis.com/css?family=Roboto:300,900" rel="stylesheet">
</head>
<style>
	h1 {
		font-family: 'Roboto', sans-serif;
		font-weight: 900
	}
	
	p {
		font-family: 'Roboto', sans-serif;
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
        <td><a href="/transmission" target="_top"><img src="torrent.svg" alt="Go to Transmission web UI" width="300" height="300" border="0"/></a></td>
        <td><a href="/downloads" target="_top"><img src="folder.svg" alt="Go to file list" width="300" height="300" border="0"/></a></td>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td><br/>

    <br/>
    <br/></td>
  </tr>
  <tr>
    <td><div align="center"><p>Powered by: Simple Stupid Seedbox Script</p></div></td>
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
service transmission-daemon start
service caddy restart
