#!/bin/sh

# Create new config file
pcs cluster cib stonith_cfg

# Random values, its all fake
pcs -f stonith_cfg stonith create ClusterStonith fence_apc pcmk_host_list="fox;lion" aipaddr="1.1.1.1" login="login" pass="pass" port="15" pcmk_monitor_action=metadata

# Enable stonith
pcs -f stonith_cfg property set stonith-enabled=true

# Push the config to the cluster
pcs cluster cib-push stonith_cfg

# ============Distributed Lock Manager=====================

# Create new config file
pcs cluster cib dlm_cfg

# Create DLM resource
pcs -f dlm_cfg resource create dlm ocf:pacemaker:controld op monitor interval=60s

# Push the config to the cluster
pcs cluster cib-push dlm_cfg --config

# ===========Global file system=============================
# Format the drive first!!!
mkfs.gfs2 -p lock_dlm -j 2 -t cluster0:web /dev/sdb1

pcs cluster cib fs_cfg

pcs -f fs_cfg resource create WebFS Filesystem device="/dev/sdb1" directory="/var/www/html" fstype="gfs2"

pcs -f fs_cfg constraint colocation add WebSite with WebFS INFINITY

pcs cluster cib-push fs_cfg --config
