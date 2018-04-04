[![Build Status](https://travis-ci.org/m4rcu5nl/ansible-role-zerotier.svg?branch=master)](https://travis-ci.org/m4rcu5nl/ansible-role-zerotier) [![GitHub issues](https://img.shields.io/github/issues/m4rcu5nl/ansible-role-zerotier.svg)](https://github.com/m4rcu5nl/ansible-role-zerotier/issues)

ZeroTier
=========

This Ansible role installs the `zerotier-one` package, adds and authorizes new members to (existing) ZeroTier networks, and tells the new member to join the network.

Requirements
------------

This role has an optional access token variable to authorize the member using the ZeroTier API. The role also takes the ID of the ZeroTier network to automatically join the new member.

Role Variables
--------------

### zerotier_api_url
The url where the Zerotier API lives. Must use HTTPS protocol.
Default: https://my.zerotier.com

### zerotier_accesstoken
The access token needed to authorize with the ZeroTier API. You can generate one in your account settings at https://my.zerotier.com/. If this is left out then the newly joined member will not be automatically authorized.

### zerotier_network_id
The 16 character network ID of the network the new members should join. The node will not join any network if omitted.

### zerotier_register_short_hostname
Used to register the short hostname (without the FQDN) on the network instead of the long one.
Default: `false`

### zerotier_member_ip_assignments
A list of IP addresses to assign this member. The member will be automatically assigned an address on the network if left out.

### zerotier_member_description
Optional desription for a member.

Example Playbook
----------------

```yaml
    - hosts: servers
      vars:
         zerotier_network_id: 1234567890qwerty
         zerotier_accesstoken: "{{ vault_zerotier_accesstoken }}"
         zerotier_register_short_hostname: true

      roles:
         - { role: m4rcu5nl.zerotier }
```

Example Inventory
----------------

```INI
    [servers]
    web1.example.com zerotier_member_ip_assignments='["192.168.195.1", "192.168.195.2"]'
    web2.example.com zerotier_member_ip_assignments='["192.168.195.3", "192.168.195.4"'
    db1.example.com zerotier_member_ip_assignments='["192.168.195.10"]'
    db2.example.com zerotier_member_ip_assignments='["192.168.195.11"]'
    db3.example.com zerotier_member_ip_assignments='["192.168.195.12"]'

    [webservers]
    web1.example.com
    web2.example.com

    [dbservers]
    db1.example.com
    db2.example.com
    db3.example.com

    [webservers:vars]
    zerotier_member_description='<AppName> webserver'

    [dbservers:vars]
    zerotier_member_description='<AppName> db cluster node'
```
