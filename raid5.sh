#!/bin/sh

|        | Min number of disks | Fault tolerance |
| RAID 0 |                   2 |               0 |
| RAID 1 |                   2 |           n - 1 |
| RAID 2 |                   3 |               1 |
| RAID 3 |                   3 |               1 |
| RAID 4 |                   3 |               1 |
| RAID 5 |                   3 |               1 |
| RAID 6 |                   4 |               2 |

RAID_NAME=md0

# Create disk files
mkdir ~/disks
fallocate -l 200MB ~/disks/$(RAID_NAME)_disk0
fallocate -l 200MB ~/disks/$(RAID_NAME)_disk1
fallocate -l 200MB ~/disks/$(RAID_NAME)_disk2
fallocate -l 200MB ~/disks/$(RAID_NAME)_disk3

# Plugin the disks
losetup -f ~/disks/$(RAID_NAME)_disk0
losetup -f ~/disks/$(RAID_NAME)_disk1
losetup -f ~/disks/$(RAID_NAME)_disk2
losetup -f ~/disks/$(RAID_NAME)_disk3

# Create raid
mdadm --create --verbose /dev/$(RAID_NAME) --level=5 -n 3 /dev/loop0 /dev/loop1 /dev/loop2

# Add hotspare disks
mdadm --manage /dev/$(RAID_NAME) --add /dev/loop3
