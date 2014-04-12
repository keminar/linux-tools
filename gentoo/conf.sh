#!/bin/bash

##############################################################
# title		: gentoo tiny installer
# authors	: keminar
# contact	: https://github.com/keminar/linux-tools
# date		: 12.04.2014
# license	: GPLv2
##############################################################

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

# colors
unset OFF GREEN RED
OFF='\e[1;0m'
GREEN='\e[1;32m'
RED='\e[1;31m'
readonly OFF GREEN RED

# warn
function tiny_warn
{
	printf "$RED"
	printf '%s\n' "$@"
	printf "$OFF"
}

# start
function tiny_start
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
