#!/bin/sh

# SELINUX
# /etc/selinux/config

# getenforce
# sestatus

PASSWORD="asdf"

hostnamectl set-hostname gamma
echo "192.168.56.102 delta" >> /etc/hosts
echo -e "$PASSWORD\n$PASSWORD\n" | passwd
