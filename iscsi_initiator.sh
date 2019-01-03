#!/bin/bash
# iscsi initiator

IP="192.168.56.101"
INITIATOR="iqn.2018-11.com.example"
INITIATOR_PRIVATE_ENDING="disk0"
INITIATOR_PUBLIC_ENDING="lun1"

# Install initiator
yum install iscsi-initiator-utils -y
# Add iscsi initiator name
echo "InitiatorName=$INITIATOR:$INITIATOR_PRIVATE_ENDING" > /etc/iscsi/initiatorname.iscsi
# Discover target
iscsiadm -m discovery -t st -p $IP
# Restart and enable service
systemctl restart iscsid.service
systemctl enable iscsid.service
# Login
iscsiadm -m node -T $INITIATOR:$INITIATOR_PUBLIC_ENDING -p $IP -l
# List of devices
cat /proc/partitions
