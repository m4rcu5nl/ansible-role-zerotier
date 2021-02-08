#!/usr/bin/env python3

import json
import subprocess

out = subprocess.Popen(['/usr/sbin/zerotier-cli', '-j', 'info'],
                       stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

stdout, stderr = out.communicate()

try:
    info = json.loads(stdout)
except:
    print('zerotier-cli error. Are you sure you are running this as root?')
    exit(1)

j = {
    'node_id': info['address']
}

out = subprocess.Popen(['/usr/sbin/zerotier-cli', '-j', 'listnetworks'],
                       stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

stdout, stderr = out.communicate()

try:
    networks = json.loads(stdout)
except:
    print('zerotier-cli error. Are you sure you are running this as root?')
    exit(2)

n = {}

for network in networks:
    n[network['id']] = {
        'status': network['status'],
        'device': network['portDeviceName'],
    }

j['networks'] = n

print(json.dumps(j, indent=2))
