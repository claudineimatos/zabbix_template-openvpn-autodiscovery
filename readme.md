# Zabbix Template - OpenVPN Autodiscovery for Linux

Zabbix Template for OpenVPN client instances with AutoDiscovery

Modified original for use in Linux (Ubuntu 22.04) providing simple health check to all OpenVPN client instances.

Please note this does not collect traffic data since it's capable with out-of-the-box Zabbix OS templates.

## Install Instructions 
Instructions are for Ubuntu 22.04 but can adapt to other distros.

1. Download the most recent release and copy all files except the template xml to your Linux box.
    * https://github.com/rjgura/zabbix_template-openvpn-autodiscovery/releases/latest

2. Rename SERVER_NAME.conf and move to /etc/zabbix/zabbix_agentd.d/
    * Recommend using your hostname for the filename.

3. Modify zabbix-agent config found in the renamed SERVER_NAME.conf
    * Putting your config in an external file protects your settings during a zabbix agent upgrade.
    * Put the IP addresses for your Zabbix server and your Linux box's hostname
    * This file contains UserParameters used by the Zabbix template
  ```
Server=127.0.0.1
ServerActive=127.0.0.1
Hostname=localhost
  ```

4. Move zabbix file to /etc/sudoers.d/
    * If zabbix-agent runs as a different user, change the file name to match it
    * This file contains the permissions required to run the discovery shell script without a password
  ```
zabbix ALL=(ALL) NOPASSWD: /usr/local/bin/openvpn_discovery.sh CLIENT
  ```
  * Make sure the following directive is active in `/etc/sudoers`
  ```
@includedir /etc/sudoers.d
  ```

5. Move `openvpn_discovery.sh` into `/usr/local/bin/` and add executable permission
  ```
sudo chmod +x /usr/local/bin/openvpn_discovery.sh
  ```

6. Import the Zabbix template and link it to the desired host
