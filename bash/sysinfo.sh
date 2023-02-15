#!/bin/bash
fqdn=$( hostname --fqdn ) 

#To assign the OS details on the system
os=$( hostnamectl|grep Operating )

#To assign the IP address
IP=$( hostname -I )

#To assign the free storage file of system

root=$( df --output=avail --block-size=G / | awk 'NR==2 {print $1}' )
cat<<EOF
Details for $fqdn
###########################
Fully Qualified Domain Name: $fqdn
Operation system and version info: $os
IP address: $IP
Root file free storage: $root
##########################
EOF
