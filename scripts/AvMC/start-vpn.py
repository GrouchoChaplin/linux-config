#!/usr/bin/env python

from subprocess import call, PIPE
import os


user = '<user>'
vpn_servers = ['<server1>', '<server2>']

for vpn_server in vpn_servers:
    # Test server first
    response = call('ping -c 1 -W 2 {}'.format(vpn_server), shell=True, stdout=PIPE)
    if response == 0:
        p = call(['sudo', 'openconnect', '-b', '--no-cert-check', '--user=' + user, vpn_server])
