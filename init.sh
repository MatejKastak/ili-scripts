#!/bin/sh

# SELINUX
# Config file: /etc/selinux/config
# getenforce
# sestatus

echo -n "Input this VM hostname: "; read this_hostname
echo -n "Input other VM hostname: "; read other_hostname
echo -n "Input other VM ip: "; read other_ip

PASSWORD="asdf"

hostnamectl set-hostname $this_hostname
echo "$other_ip $other_hostname" >> /etc/hosts
echo -e "$PASSWORD\n$PASSWORD\n" | passwd
