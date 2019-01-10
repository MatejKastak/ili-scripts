#!/bin/sh

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
