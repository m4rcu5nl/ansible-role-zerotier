[![Build Status](https://travis-ci.org/m4rcu5nl/ansible-role-zerotier.svg?branch=master)](https://travis-ci.org/m4rcu5nl/ansible-role-zerotier) [![GitHub issues](https://img.shields.io/github/issues/m4rcu5nl/ansible-role-zerotier.svg)](https://github.com/m4rcu5nl/ansible-role-zerotier/issues)

ZeroTier
=========

This Ansible role adds the ZeroTier repository and installs the `zerotier-one` package using your system's package manager. Depending on the provided variables this role can also add and authorize new members to (existing) ZeroTier networks, and tell the new member to join the network.

Requirements
------------

Technically this role has no requirements. If it's ran without any variables set it will only run the installation tasks. The following variables impact the role's behavior:

[**zerotier_network_id**](#zerotier_network_id): when set hosts are told to join this network.  
[**zerotier_api_accesstoken**](#zerotier_api_accesstoken): when set the role can handle member authentication and configuration using the ZeroTier API.  


Role Variables
--------------

### zerotier_network_id
*Type*: string  
*Default value*:   
*Description*: The 16 character network ID of the network the new members should join. The node will not join any network if omitted.

### zerotier_member_register_short_hostname
*Type*: boolean  
*Default value*: `false`  
*Description*: By default `inventory_hostname` will be used to name a member in a network. If set to `true`, `inventory_hostname_short` will be used instead.

### zerotier_member_ip_assignments
*Type*: list  
*Default value*: `[]`    
*Description*: A list of IP addresses to assign this member. The member will be automatically assigned an address on the network if left out.

### zerotier_member_description
*Type*: string  
*Default value*: `""`      
*Description*: Optional desription for a member.

### zerotier_api_accesstoken
*Type*: string  
*Default value*: `""`   
*Description*: The access token needed to authorize with the ZeroTier API. You can generate one in your account settings at https://my.zerotier.com/. If this is left out then the newly joined member will not be automatically authorized.

### zerotier_api_url
*Type*: string  
*Default value*: `https://my.zerotier.com`  
*Description*: The url where the Zerotier API lives. Must use HTTPS protocol.  

### zerotier_api_delegate
*Type*: string  
*Default value*: `localhost`      
*Description*: Option to delegate tasks for Zerotier API calls. This is usefull in a situation where API calls can only be made from a whitelisted management server, for example.

Example Playbook
----------------

```yaml
    - hosts: servers
      vars:
         zerotier_network_id: 1234567890qwerty
         zerotier_accesstoken: "{{ vault_zerotier_accesstoken }}"
         zerotier_register_short_hostname: true

      roles:
         - { role: m4rcu5nl.zerotier, become: true }
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
