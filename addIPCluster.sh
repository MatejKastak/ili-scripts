#!bin/bash
ipaddr="192.168.56.50"

pcs resource create ClusterIP ocf:heartbeat:IPaddr2 ip=$ipaddr cidr_netmask=32 op monitor interval=30s 

#zabrana migrovania po starte
#pcs resource defaults resource-stickiness=100

#obmedzenie, musia byt spolu
#pcs constraint colocation add WebSite with ClusterIP INFINITY

#obmedzenie, najprv IP, potom sluzba
#pcs constraint order ClusterIP then WebSite

#obmedzenie, snaha nabehnut na node pcmk-1 je 50
#pcs constraint location WebSite prefers pcmk-1=50

#manualny posun
#pcs resource move WebSite pcmk-1

#zrusit manualny presun
#pcs resource clear WebSite