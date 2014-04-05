#!/bin/bash

##############################################################
# title		: arch tiny installer
# authors	: keminar
# contact	: https://github.com/keminar/linux-tools
# date		: 05.04.2014
# license	: GPLv2
# usage		: run ./tiny.sh
##############################################################

# colors
unset ALL_OFF GREEN RED
ALL_OFF='\e[1;0m'
GREEN='\e[1;32m'
RED='\e[1;31m'
readonly ALL_OFF GREEN RED

# start
function start
{
	printf "$RED"
cat << EOF
---------------------------------------
		  install start
---------------------------------------
EOF
	printf "$ALL_OFF"
}

# network config
function network
{
	read -p "Connect internect type [wlan|wifi]: " type
	if [ "$type" == "wlan" ];then
	dhcpcd
	else
	wifi-menu
	fi
}

# select mirror
function mirror
{
	echo "Set 163.com mirror"
	mirror=`grep .163.com /etc/pacman.d/mirrorlist |head -n1`
	sed -i '5a\Server = http://mirrors.163.com/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist
	pacman -Sy
}

# fdisk device
function mkdisk
{
	lsblk
	read -p "Input disk [sda|hda]: " disk
	[[ $(lsblk -dno TYPE "/dev/$disk") = 'disk' ]] || mkdisk
	fdisk /dev/$disk
	fdisk -l /dev/$disk
	while :; do
		read -p "Which device will be install system [${disk}1] " dev
		[[ $(lsblk -dno TYPE "/dev/$dev") = 'part' ]] && break
	done

	read -p "Do you want to format ${dev} device use mkfs.ext4 [y|n]? " ans
	if [ "$ans" == "y" ]; then
		mkfs.ext4 /dev/$dev
	fi
	mount /dev/$dev /mnt
	return $dev
}

# pacstrap && fstab
function strap
{
	pacstrap /mnt base
	genfstab -U -p /mnt >> /mnt/etc/fstab
}

# chroot && grub
function chroot
{
	echo "Set arch-chroot"
	printf '%s\n' "mkinitcpio -p linux; \
	pacman -S grub; \
	grub-install --recheck /dev/$1; \
	grub-mkconfig -o /boot/grub/grub.cfg
	" |arch-chroot /mnt
}

# success
function success
{
	umount /mnt
	printf "$RED"
cat << EOF
---------------------------------------
		Installation completed!
	 Reboot the computer: # reboot
---------------------------------------
EOF
	printf "$ALL_OFF"
}

start
network
mirror
dev=mkdisk
strap
chroot $dev
success
