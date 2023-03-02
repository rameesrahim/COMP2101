#! /bin/bash

#cheching the version of lxd that being currently used
checkLxd=$(lxd --version)





#if there is no lxd found then install lxd and give the output
if [ "$?" = 0 ] ; then
	echo "LXD found. Current version of lxd installed is $checkLxd"
else
	echo "lxd is not yet installed. Installing now."
	sudo apt install snapd -y 
	
	sudo snap install lxd

fi

#initializing lxd
sudo lxd init --auto


#checking to see what version of operating system is being run on this machine
os=$(cat /etc/os-release | grep -i pretty | awk -F'"' '{print $2}')


#creating a container COMP2101-S22 
lxcList=$(lxc list | grep -w "COMP2101-S22" | awk -F' ' '{print $2}')


#check to see whether there is already a container called COMP2101-S22
#if there is, then ignore 
#notifying that they already have a container running named COMP2101-S22

if [ "$lxcList" = COMP2101-S22 ] ; then
	echo "There is a container called COMP2101-S22"

else
	echo "No container named COMP2101-S22 was found. $os will be downloaded and installed and a container called COMP2101-S22 will be created to house it."
	lxc launch ubuntu:22.04 COMP2101-S22
fi


#Checking to see whether apache2 is installed in the COMP2101-S22 container and not the host machine
#by looking to see if there is a string present in the $apache2 variable created below
#download and install apache2 to the COMP2101-S22 container if apache2 not found and inform the user
#or inform the user if apache2 is already installed
apache2=$(lxc exec COMP2101-S22 -- dpkg --get-selections | grep apache2)


if [[ -z "$apache2" ]] ; then
	echo "Checking Apache2 status: ..."
	echo "Apache2 is not yet installed. Installing now!"
	sudo lxc exec COMP2101-S22 -- apt-get update
	sudo lxc exec COMP2101-S22 -- apt-get install apache2 -y
else
	echo "Checking Apache2 status: ..."
	echo "Apache2 is already installed."

fi



#see what ip the container is using and put that in a variable named ip
ip=$(lxc list | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
#curl the webpage for apache2 install in the container located at that ip
lxc exec COMP2101-S22 -- curl --head $ip




#let the user know whether the script was successful in getting the default Apache2 webpage based 
#curl the default index file on the apache2 web server.
if [ "$?" = 0 ] ; then
	echo "Successfully retrieved the webpage"
else
	echo "Failed to retrieve the web page"
fi
