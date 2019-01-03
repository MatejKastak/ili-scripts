#!/bin/bash
# Add known host

IP1="192.168.56.101"
NAME1="venus"

IP2="192.168.56.102"
NAME2="mars"

echo $IP1 $NAME1 >> /etc/hosts
echo $IP2 $NAME2 >> /etc/hosts

cat /etc/hosts
