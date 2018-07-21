#!/bin/bash

yum -y install samba samba-client

smbpasswd -a root

firewall-cmd --permanent --zone=public --add-service=samba
firewall-cmd --reload

cat ./smb.conf >> /etc/samba/smb.conf
