#!/bin/bash

##############################################################
# title		: gentoo tiny installer
# authors	: keminar
# contact	: https://github.com/keminar/linux-tools
# date		: 05.04.2014
# license	: GPLv2
# usage		: run ./tiny.sh
##############################################################

DISK='sda'
PASSWD='123456'

# colors
unset OFF GREEN RED
OFF='\e[1;0m'
GREEN='\e[1;32m'
RED='\e[1;31m'
readonly OFF GREEN RED

#
function tiny_install
{
	env-update
	source /etc/profile
	echo root:$PASSWD|chpasswd
	cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
	nano /etc/fstab
	emerge --sync
	emerge gentoo-sources
	cd /usr/src/linux
	make menuconfig
	cpu=$(($(cat /proc/cpuinfo | grep processor | wc -l)+1))
	make -j$cpu
	version=$(ls -l /usr/src/|awk '{print $9}'|grep gentoo|cut -d "-" -f 2)
	cp arch/x86/boot/bzImage /boot/kernel-$version-gentoo
	make modules_install

}

function tiny_grub
{
	emerge grub
	grub2-install /dev/$DISK
	grub2-mkconfig -o /boot/grub/grub.cfg
}

function tiny_utils
{

	emerge dhcpcd
}

tiny_install
