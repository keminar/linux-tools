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

# set disk
function tiny_setdisk
{
	lsblk
	read -p "Select disk [sda]: " disk
	disk=${disk:-$DISK}
	[[ $(lsblk -dno TYPE "/dev/$disk") = 'disk' ]] || tiny_setdisk
	DISK=$disk
}

# fdisk
function tiny_fdisk_boot
{
	tiny_warn "Use fdisk to create partition. Need a /boot, a swap, a main partition at least"
	fdisk /dev/$DISK
	fdisk -l /dev/$DISK
	while :; do
		read -p "Which partition will be /boot [$BOOT]: " part
		part=${part:-$BOOT}
		[[ $(lsblk -dno TYPE "/dev/$part") = 'part' ]] && break
	done
	boot=`fdisk -l /dev/$DISK|grep "/dev/$part "|awk '{print $2}'`
	if [ "$boot" != "*" ];then
		tiny_warn "Please make /dev/$part as boot flag"
		tiny_fdisk_boot
		return
	fi

	read -p "Do you want to format ${part} partition use mkfs.ext4 [n|y]: " ans
	if [ "$ans" = "y" ]; then
		mkfs.ext4 /dev/$part
	fi
	BOOT=$part
}

# fdisk
function tiny_fdisk_swap
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
}

# fdisk
function tiny_fdisk_root
{
	fdisk /dev/$DISK
	fdisk -l /dev/$DISK
	while :; do
		read -p "Which partition will be / [$ROOT]: " part
		part=${part:-$ROOT}
		[[ $(lsblk -dno TYPE "/dev/$part") = 'part' ]] && break
	done

	read -p "Do you want to format ${part} partition use mkfs.ext4 [n|y]: " ans
	if [ "$ans" = "y" ]; then
		mkfs.ext4 /dev/$part
	fi
	ROOT=$part
}

# mount
function tiny_mount
{
	mount /dev/$ROOT /mnt/gentoo
	mkdir /mnt/gentoo/boot
	mount /dev/$BOOT /mnt/gentoo/boot
}

# download
function tiny_download
{
	cd /mnt/gentoo
	read -p "Gentoo mirror [$MIRROR]: " url
	url=${url:-$MIRROR}
	links $url
	if [ ! -f stage3*.bz2 ]; then
		tiny_warn "stage3*.bz2 not found, retry"
		tiny_download
		return
	fi
	tar jxvfp stage3*.bz2

	if [ ! -f portage*.bz2 ]; then
		tiny_warn "portage*.bz2 not found, retry"
		tiny_download
		return
	fi
	tar jxvfp portage*.bz2 -C usr/
}

tiny_start
tiny_setdisk
tiny_fdisk_boot
tiny_fdisk_swap
tiny_fdisk_root
tiny_mount
tiny_download
