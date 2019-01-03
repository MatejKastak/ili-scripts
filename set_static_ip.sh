#!/bin/bash
# Set static IP address

IP="192.168.56.102"

echo "NAME=enp0s8
DEVICE=enp0s8
BOOTPROTO=static
ONBOOT=yes
IPADDR=$IP
NETMASK=255.255.255.0
GATEWAY=192.168.56.1
" > /etc/sysconfig/network-scripts/ifcfg-enp0s8
systemctl restart network

cat /etc/sysconfig/network-scripts/ifcfg-enp0s8
