#!/bin/sh

# SELINUX
# /etc/selinux/config

# getenforce
# sestatus

PASSWORD="asdf"

hostnamectl set-hostname delta
echo "192.168.56.101 gamma" >> /etc/hosts
echo -e "$PASSWORD\n$PASSWORD\n" | passwd
