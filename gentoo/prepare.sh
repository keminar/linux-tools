#!/bin/bash

##############################################################
# title		: gentoo tiny installer
# authors	: keminar
# contact	: https://github.com/keminar/linux-tools
# date		: 12.04.2014
# license	: GPLv2
##############################################################

BASEDIR=$(dirname $(readlink -f $0))
source $BASEDIR/conf.sh

# wifi
function prepare_network
{
	if [ "$WIFI_INTERFACE" != "" ] && [ "$WIFI_ESSID" != "" ];then
		iwconfig $WIFI_INTERFACE essid "$WIFI_ESSID" key $WIFI_PASSWD
		ifconfig $WIFI_INTERFACE up
		dhcpcd $WIFI_INTERFACE
	fi
	conf_warn "Config network ok"
}

# set disk
function prepare_setdisk
{
	lsblk
	read -p "Select disk [sda]: " disk
	disk=${disk:-$DISK}
	[[ $(lsblk -dno TYPE "/dev/$disk") = 'disk' ]] || prepare_setdisk
	DISK=$disk
	conf_warn "Select disk ok"
}

# fdisk
function prepare_fdisk_boot
{
	conf_warn "Use fdisk to create partition. Need a /boot, a swap, a main partition at least"
	fdisk /dev/$DISK
	fdisk -l /dev/$DISK
	while :; do
		read -p "Which partition will be /boot [$BOOT]: " part
		part=${part:-$BOOT}
		[[ $(lsblk -dno TYPE "/dev/$part") = 'part' ]] && break
	done
	boot=`fdisk -l /dev/$DISK|grep "/dev/$part "|awk '{print $2}'`
	if [ "$boot" != "*" ];then
		conf_warn "Please make /dev/$part as boot flag"
		prepare_fdisk_boot
		return
	fi

	read -p "Do you want to format ${part} partition use mkfs.ext2 [n|y]: " ans
	if [ "$ans" = "y" ]; then
		mkfs.ext2 /dev/$part
	fi
	BOOT=$part
	conf_warn "/dev/$part partition ok"
}

# fdisk
function prepare_fdisk_swap
{
	fdisk /dev/$DISK
	fdisk -l /dev/$DISK
	while :; do
		read -p "Which partition will be swap [$SWAP]: " part
		part=${part:-$SWAP}
		[[ $(lsblk -dno TYPE "/dev/$part") = 'part' ]] && break
	done

	mkswap /dev/$part
	swapon /dev/$part
	SWAP=$part
	conf_warn "/dev/$part swap ok"
}

# fdisk
function prepare_fdisk_root
{
	fdisk /dev/$DISK
	fdisk -l /dev/$DISK
	while :; do
		read -p "Which partition will be main partition / [$ROOT]: " part
		part=${part:-$ROOT}
		[[ $(lsblk -dno TYPE "/dev/$part") = 'part' ]] && break
	done

	read -p "Do you want to format ${part} partition use mkfs.ext4 [n|y]: " ans
	if [ "$ans" = "y" ]; then
		mkfs.ext4 /dev/$part
	fi
	ROOT=$part
	conf_warn "/dev/$part partition ok"
}

# mount
function prepare_mount
{
	mount /dev/$ROOT /mnt/gentoo
	mkdir -p /mnt/gentoo/boot
	mount /dev/$BOOT /mnt/gentoo/boot
	conf_warn "Mount ok"
}

# date
function prepare_date
{
	read -p "Set the current date and time if required,(Format is MMDDhhmmYYYY): " ans
	if [ "$ans" != "" ];then
		date $ans
	fi
	date
	conf_warn "Set date ok"
}

# download
function prepare_download
{
	cd /mnt/gentoo
	read -p "Gentoo mirror [$MIRROR]: " url
	url=${url:-$MIRROR}
	links $url
	if [ ! -f stage3*.bz2 ]; then
		conf_warn "stage3*.bz2 not found, retry"
		prepare_download
		return
	fi
	tar jxvfp stage3*.bz2

	if [ ! -f portage*.bz2 ]; then
		conf_warn "portage*.bz2 not found, retry"
		prepare_download
		return
	fi
	tar jxvfp portage*.bz2 -C usr/
	conf_warn "Download state3, portage ok"
}

conf_start
prepare_network
prepare_setdisk
prepare_fdisk_boot
prepare_fdisk_swap
prepare_fdisk_root
prepare_mount
prepare_date
prepare_download
