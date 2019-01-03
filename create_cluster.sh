#!/bin/bash
# Create cluster

CLUSTER_NAME="mycluster"
CLUSTER_PASSWORD="asdf"
CLUSTER_USER="hacluster"
PC1="venus"
PC2="mars"
PC2_PASSWORD="asdf"


echo "************ Install cluster software on both nodes ************"
yum install -y pacemaker pcs psmisc policycoreutils-python

ssh $PC2 yum install -y pacemaker pcs psmisc policycoreutils-python

echo "**** Allow cluster services through firewall on both nodes ****"
firewall-cmd --permanent --add-service=high-availability
firewall-cmd --reload

ssh $PC2 firewall-cmd --permanent --add-service=high-availability
ssh $PC2 firewall-cmd --reload

echo "*************** Enable pcs Daemon on both nodes ***************"
systemctl start pcsd.service
systemctl enable pcsd.service

ssh $PC2 systemctl start pcsd.service
ssh $PC2 systemctl enable pcsd.service

echo "*************************** Set password **********************"
echo -e "$CLUSTER_PASSWORD\n$CLUSTER_PASSWORD\n" | passwd "$CLUSTER_USER"

#ssh $PC2 echo -e "$CLUSTER_PASSWORD\n$CLUSTER_PASSWORD\n" | passwd "$CLUSTER_USER"
ssh $PC2 passwd "$CLUSTER_USER"

echo "************************* Authenticate ************************"
echo -e "$CLUSTER_USER\n$CLUSTER_PASSWORD\n" | pcs cluster auth $PC1 $PC2

echo "**** Generate and synchronize the corosync configuration ******"
pcs cluster setup --force --name $CLUSTER_NAME $PC1 $PC2

echo "*********************** Start cluster *************************"
pcs cluster start --all

echo "**************** Start cluster after reboot *******************"
echo "[Unit]
Description=Start cluster on boot
After=pcsd.service

[Service]
Type=idle
ExecStart=/usr/bin/bash -c \"/sbin/pcs cluster start\"
RemainAfterExit=yes

[Install]
WantedBy=pcsd.service" > /etc/systemd/system/clusteronboot.service
systemctl enable clusteronboot.service
systemctl start clusteronboot.service
systemctl status clusteronboot.service

scp /etc/systemd/system/clusteronboot.service $PC2:/etc/systemd/system/clusteronboot.service
ssh $PC2 systemctl enable clusteronboot.service
ssh $PC2 systemctl status clusteronboot.service

echo "************************ Show status *************************"
pcs status
