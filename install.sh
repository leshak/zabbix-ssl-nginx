#!/bin/bash

echo "Copy scripts..."
sudo mkdir -p /etc/zabbix/scripts
sudo curl https://raw.githubusercontent.com/leshak/zabbix-ssl-nginx/master/scripts/check_ssl_https.sh -o /etc/zabbix/scripts/check_ssl_https.sh
sudo curl https://raw.githubusercontent.com/leshak/zabbix-ssl-nginx/master/scripts/disc_ssl_https.py -o /etc/zabbix/scripts/disc_ssl_https.py
sudo chmod 0740 /etc/zabbix/scripts/*
sudo chown -R zabbix. /etc/zabbix/scripts

echo "Copy config..."
sudo curl https://raw.githubusercontent.com/leshak/zabbix-ssl-nginx/master/zabbix_agentd.d/ssl.conf -o /etc/zabbix/zabbix_agentd.d/ssl.conf

echo "Restart zabbix agent..."
sudo systemctl restart zabbix-agent

echo "Checking..."
sudo zabbix_agentd -t ssl_https.discovery
sudo zabbix_agentd -t ssl_https.expire[google.com]

echo "Don't forget to add the template to the Zabbix!"
