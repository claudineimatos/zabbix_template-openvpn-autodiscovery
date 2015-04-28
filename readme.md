# Zabbix Template - OpenVPN Autodiscovery

This is a simple Zabbix Template for OpenVPN with AutoDiscovery
It's aim to provide a simple health check to all OpenVPN client and server instances. Altough the primary use for this template is a pfSense server, it's easy to use it in any other Linux / UNIX / BSD host.

Please note that I've choosed to do not collect traffic data as the host which this template is linked probably already has it's network interfaces autodiscovered, so this data would be be redundant


## Install Instructions 
The following instructions are for a pfSense server but you can easily adapt it to any other setup.

1.  Add the following UserParameters to zabbix_agentd.conf (Services -> Zabbix-2 Agent)
  ```
# OpenVPN Discovery rules
UserParameter=openvpn.list.discovery[*],sudo /usr/local/bin/openvpn_discovery.sh $1

# OpenVPN current sessions
UserParameter=openvpn.conn.status[*],echo "state" | sudo /usr/local/bin/socat $1 stdio |grep -q CONNECTED,SUCCESS && echo 1 || echo 0
UserParameter=openvpn.server.clients[*],echo "load-stats" | sudo /usr/local/bin/socat $1 stdio | grep SUCCESS | cut -d= -f 2 |   cut -d, -f 1 || echo 0
  ```

2. Install socat utility
  ```
sudo pkg_add -r ftp://ftp.freebsd.org/pub/FreeBSD/ports/amd64/packages-8-stable/Latest/socat.tbz
  ```

3. Install sudo utility from (System -> Package Manager) as socat will need root rights to get data from sockets.
_Note that zabbix user is automatically created from the Zabbix Agent plugin and as such isn't possible to add rights from the pfSense web gui, so you'll have to do it from the console._
  * Create a file named `/usr/local/etc/suoders.d/zabbix` and add the lines below.
  ```
zabbix ALL=(ALL) NOPASSWD: /usr/local/bin/socat /var/etc/openvpn/*.sock stdio
zabbix ALL=(ALL) NOPASSWD: /usr/local/bin/openvpn_discovery.sh CLIENT
zabbix ALL=(ALL) NOPASSWD: /usr/local/bin/openvpn_discovery.sh SERVER
  ```
  * Add the following line into `/usr/pbi/sudo-amd64/etc/sudoers`
  ```
#includedir /usr/local/etc/sudoers.d/
  ```

4. Copy `openvpn_discovery.sh` into `/usr/local/bin/` and add executable permission
  ```
sudo chmod +x /usr/local/bin/openvpn_discovery.sh
  ```

5. Import the Zabbix template and link it to the desired host
