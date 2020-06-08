#!/bin/bash

echo "Copy scripts..."
mkdir -p /etc/zabbix/scripts
curl https://raw.githubusercontent.com/leshak/zabbix-ssl-nginx/master/scripts/check_ssl_https.sh -o /etc/zabbix/scripts/check_ssl_https.sh
curl https://raw.githubusercontent.com/leshak/zabbix-ssl-nginx/master/scripts/disc_ssl_https.py -o /etc/zabbix/scripts/disc_ssl_https.py
chmod 0740 /etc/zabbix/scripts/*
chown -R zabbix. /etc/zabbix/scripts

echo "Copy config..."
curl https://raw.githubusercontent.com/leshak/zabbix-ssl-nginx/master/zabbix_agentd.d/ssl.conf -o /etc/zabbix/zabbix_agentd.d/ssl.conf

echo "Restart zabbix agent..."
systemctl restart zabbix-agent
sleep 4

echo "Checking..."
zabbix_agentd -t ssl_https.discovery
zabbix_agentd -t ssl_https.expire[google.com]

echo "Don't forget to add the template to the Zabbix!"
