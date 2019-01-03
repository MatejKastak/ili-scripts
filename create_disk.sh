#!/bin/bash
# Create disk

NAME="disk0"
SIZE="250MiB"

cd /root
fallocate -l $SIZE $NAME
losetup -f $NAME

echo "[Unit]
Description=Setup loop device on boot
DefaultDependencies=false
Before=local-fs.target
After=systemd-udev-settle.service
Required=systemd-udev-settle.service

[Service]
Type=oneshot
ExecStart=/usr/bin/bash -c \"/sbin/losetup -f /root/$NAME\"
RemainAfterExit=yes

[Install]
WantedBy=local-fs.target
Also=systemd-udev-settle.service" > /etc/systemd/system/looponboot.service

systemctl enable looponboot.service
systemctl status looponboot.service
