#!/bin/sh

# |        | Min number of disks | Fault tolerance |
# | RAID 0 |                   2 |               0 |
# | RAID 1 |                   2 |           n - 1 |
# | RAID 2 |                   3 |               1 |
# | RAID 3 |                   3 |               1 |
# | RAID 4 |                   3 |               1 |
# | RAID 5 |                   3 |               1 |
# | RAID 6 |                   4 |               2 |

yum install -y mdadm

RAID_NAME=md0

cp loop@.service /etc/systemd/system
systemctl daemon-reload

# Create disk files
mkdir -p ~/disks
fallocate -l 200MB ~/disks/loop10
fallocate -l 200MB ~/disks/loop11
fallocate -l 200MB ~/disks/loop12
fallocate -l 200MB ~/disks/loop13

# Plugin and enable the disks
systemctl start loop@10.service
systemctl start loop@11.service
systemctl start loop@12.service
systemctl start loop@13.service

systemctl enable loop@10.service
systemctl enable loop@11.service
systemctl enable loop@12.service
systemctl enable loop@13.service

# Create raid
mdadm --create --verbose /dev/$RAID_NAME --level=5 -n 3 /dev/loop10 /dev/loop11 /dev/loop12

# Add hotspare disks
mdadm --manage /dev/$RAID_NAME --add /dev/loop13

# Create init config
mkdir -p /etc/mdadm
mdadm --detail --scan >> /etc/mdadm/mdadm.conf
