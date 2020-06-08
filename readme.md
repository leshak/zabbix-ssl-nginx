# Zabbix monitoring SSL certificates from nginx config files
#### Test only with Zabbix v5.x and zabbix_agentd v1
(Based on: https://serveradmin.ru/monitoring-sroka-deystviya-ssl-sertifikata-v-zabbix/)

0. Default Nginx config: `/etc/nginx/nginx.conf`


1. Install `crossplane` python package for nginx config (https://github.com/nginxinc/crossplane)

    ```
    pip install crossplane
    ```

2. Clone this repository
    ```
    git clone https://github.com/leshak/zabbix-ssl-nginx.git
    cd zabbix-ssl-nginx/
    ```

3. Copy Zabbix scripts
    ```
    sudo mkdir -p /etc/zabbix/scripts
    sudo cp scripts/* /etc/zabbix/scripts/
    sudo chmod 0740 /etc/zabbix/scripts/*
    sudo chown -R zabbix. /etc/zabbix/scripts
    ```

4. Copy zabbix config
    ```
    sudo cp zabbix_agentd.d/* /etc/zabbix/zabbix_agentd.d/
    ```

5. Restart zabbix_agentd
    ```
    sudo systemctl restart zabbix-agent
    ```

6. Test zabbix_agentd
    ```
    sudo zabbix_agentd -t ssl_https.discovery
    ```
    should output an array of your https domains
    ```
    ssl_https.discovery   [t|{"data": [{"{#DOMAIN_HTTPS}": "yourdomain.com"}]}]
    ```
    check how many days are left
    ```
    sudo zabbix_agentd -t ssl_https.expire[google.com]
    ```
    should out
    ```
    ssl_https.expire[google.com]    [t|64]
    ```

7. Import Zabbix template `zabbix_ssl_templates.xml`

8. Add `SSL Cert Expiration` template in host


### Or script
```
curl -fsSL https://raw.githubusercontent.com/leshak/zabbix-ssl-nginx/master/install.sh | sudo bash -
```
