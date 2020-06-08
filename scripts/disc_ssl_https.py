#!/usr/bin/env python
# -*- coding: utf-8 -*-

import crossplane
import json

NGINX_CONFIG_PATH = '/etc/nginx/nginx.conf'
HTTPS_PORT = 'ssl'


domainsList = []
nginxConfig = crossplane.parse(NGINX_CONFIG_PATH)
if nginxConfig['config']:
    for cfile in nginxConfig['config']:
        for parsed in cfile['parsed']:
            if 'block' in parsed:
                foundHttps = False
                httpsDomain = None

                for blk in parsed['block']:

                    if blk['directive'] == 'listen':
                        if HTTPS_PORT in blk['args']:
                            foundHttps = True

                    if foundHttps and blk['directive'] == 'server_name' and len(blk['args']) > 0:
                        httpsDomain = blk['args'][0]

                if foundHttps and httpsDomain != None:
                    domainsList.append({
                        "{#DOMAIN_HTTPS}": httpsDomain
                    })


print(json.dumps({
    'data': domainsList
}))
