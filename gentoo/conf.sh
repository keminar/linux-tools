#!/bin/bash

##############################################################
# title		: gentoo tiny installer
# authors	: keminar
# contact	: https://github.com/keminar/linux-tools
# date		: 12.04.2014
# license	: GPLv2
##############################################################

# wifi
WIFI_INTERFACE=''
WIFI_ESSID=''
WIFI_PASSWD=''

# disk where system installed
DISK='sda'
# disk where grub mbr installed
GRUB_DISK='sda'
# /boot partition
BOOT='sda1'
# swap partition
SWAP='sda2'
# / main partition
ROOT='sda3'

# mirror
MIRROR='http://mirrors.163.com'
#ROOT PASSWORD
PASSWD='123456'

# colors
unset OFF GREEN RED
OFF='\e[1;0m'
GREEN='\e[1;32m'
RED='\e[1;31m'
readonly OFF GREEN RED

# warn
function conf_warn
{
	printf "$RED"
	printf '%s\n' "$@"
	printf "$OFF"
}

# start
function conf_start
{
	printf "$GREEN"
cat << EOF
-------------------------------
           Gentoo linux
        Tiny install start
-------------------------------
EOF
	printf "$OFF"
}
