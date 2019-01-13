#!/bin/bash
# Create disk

echo -n "Input loop number: "; read num
echo -n "Input loop size(M): "; read size

cp "loop@.service" /etc/systemd/system
systemctl daemon-reload

mkdir -p ~/disks
cd ~/disks
fallocate -l ${size}M loop$num
losetup /dev/loop$num ~/disks/loop$num

# echo "[Unit]
# Description=Setup loop device on boot
# DefaultDependencies=false
# Before=local-fs.target
# After=systemd-udev-settle.service
# Required=systemd-udev-settle.service
# 
# [Service]
# Type=oneshot
# ExecStart=/usr/bin/bash -c \"/sbin/losetup /dev/loop$num /root/disks/loop$num\"
# RemainAfterExit=yes
# 
# [Install]
# WantedBy=local-fs.target
# Also=systemd-udev-settle.service" > /etc/systemd/system/loop($num)onboot.service

systemctl enable loop@${num}.service
systemctl status loop@${num}.service
