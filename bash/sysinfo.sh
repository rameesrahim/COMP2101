#!/bin/bash
#system information of this device.

#It will store the hostname of the device.
hostname=$(hostname)

# It will store domain name if it have one.
domain=$(dnsdomainname)


#It will store the name of operating system and their version.
operating_system=$(lsb_release -d -s)


#It will store ip address of the device.
ip_address=$(ip a s ens33 | grep -w inet | awk '{print $2}')


#Showing the free space available in root filesystem.
freespace=$(df -h /dev/sda3 | tail -1 | awk '{print $4}')


#display the result.
cat <<EOF
 Report for $hostname
 ======================================================================
 FQDN: $domain
 Operating System name and version: $operating_system
 IP Address: $ip_address
 Root Filesystem Free Space: $freespace
 ======================================================================
EOF
