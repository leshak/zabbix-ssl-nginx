#!/usr/bin/env python
# -*- coding: utf-8 -*-

import crossplane
import json
nginxConfig = crossplane.parse('/etc/nginx/nginx.conf')

HTTPS_PORT = 'ssl'

domainsList = []
if nginxConfig['config']:
    for cfile in nginxConfig['config']:
        for parsed in cfile['parsed']:
            foundHttps = False

            if 'block' in parsed:
                for blk in parsed['block']:

                    if blk['directive'] == 'listen':
                        if HTTPS_PORT in blk['args']:
                            foundHttps = True

                    if foundHttps and blk['directive'] == 'server_name' and len(blk['args']) > 0:
                        domainsList.append({
                            "{#DOMAIN_HTTPS}": blk['args'][0]
                        })

print(json.dumps({
    'data': domainsList
}))
