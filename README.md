Zerotier
=========

This Ansible role installs the zerotier-one package from Zerotier's yum repo, adds and authorizes new members to (existing) Zerotier network and tells the new members to join the network.

Requirements
------------

This roles requires an access token for the Zerotier API. This enables the role to add new members to a private network and authorizes them. Also, the role needs the network ID of the Zerotier network the new members should join.

Role Variables
--------------

###zerotier_api_url
The url where the Zerotier API lives. Must use https protocol.    
Default: https://my.zerotier.com

###zerotier_accesstoken
The access token needed to authorize with the Zerotier API. You can generate one in your account settings on my.zerotier.com.

###zerotier_network_id (required)
The 16 character network ID of the network the new members should join.

Example Playbook
----------------


    - hosts: servers
      vars:
         zerotier_network_id: 1234567890qwerty
         zerotier_accesstoken: "{{ vault_zerotier_accesstoken }}"
      roles:
         - { role: m4rcu5nl.zerotier }

