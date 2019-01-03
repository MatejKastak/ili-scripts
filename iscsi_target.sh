#!/bin/bash
# iscsi target

IP="192.168.56.101"
LOOP="/dev/loop0"
STORAGE_OBJECT="foo"
TARGET="iqn.2018-11.com.example"
TARGET_PRIVATE_ENDING="disk0"
TARGET_PUBLIC_ENDING="lun1"


# Install targetcli
yum install targetcli -y

# Configure target
echo "cd /backstores/block
create $STORAGE_OBJECT $LOOP
cd /iscsi
create $TARGET:$TARGET_PUBLIC_ENDING
cd /iscsi/$TARGET:lun1/tpg1/acls
create $TARGET:$TARGET_PRIVATE_ENDING
cd /iscsi/$TARGET:lun1/tpg1/luns
create /backstores/block/$STORAGE_OBJECT
cd /iscsi/$TARGET:lun1/tpg1/portals
delete 0.0.0.0 3260
create $IP
cd /
saveconfig
exit" | targetcli

# Enable firewall on TARGET
firewall-cmd --permanent --add-port=3260/tcp
firewall-cmd --reload

# Start and enable service
systemctl enable target.service
systemctl restart target.service

cat /etc/iscsi/initiatorname.iscsi
