#!/bin/bash
fqdn=$( hostname --fqdn ) 

#To assign the OS details on the system
operating_system=$( hostnamectl|grep Operating )

#To assign the IP address
ip_address=$( hostname -I )

#To assign the free storage file of system

space=$( df --output=avail --block-size=G / | awk 'NR==2 {print $1}' )
cat<<EOF
Details for $fqdn
###########################
Fully Qualified Domain Name: $fqdn
Operation system info: $operating_system
IP address: $ip_address
Root file free storage: $space
##########################
EOF
