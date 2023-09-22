# Zabbix Template - OpenVPN Autodiscovery for Linux
#NOT READY YET, LOOK FOR FIRST RELEASE SOON! -9/22/2023

Zabbix Template for OpenVPN with AutoDiscovery
Modified the original for use in Linux (Ubuntu 22.04.)  Template provides a simple health check to all OpenVPN client instances.

Please note this does not collect traffic data as this is capable with out-of-the-box Zabbix OS templates.

## Install Instructions 
The following instructions are for Ubuntu 22.04 but you can adapt it to others.

1. Download the most recent release and copy all files except the template xml to your Linux box.

2. Rename SERVER_NAME.conf and move to /etc/zabbix/zabbix_agentd.d/
  ```
# OpenVPN Discovery rules
UserParameter=openvpn.list.discovery[*],sudo /usr/local/bin/openvpn_discovery.sh $1

# OpenVPN current sessions
UserParameter=openvpn.conn.status[*],echo "state" | sudo /usr/local/bin/socat $1 stdio |grep -q CONNECTED,SUCCESS && echo 1 || echo 0
UserParameter=openvpn.server.clients[*],echo "load-stats" | sudo /usr/local/bin/socat $1 stdio | grep SUCCESS | cut -d= -f 2 |   cut -d, -f 1 || echo 0
  ```

2. Modify zabbix-agent config found in SERVER_NAME.conf
  ```

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
