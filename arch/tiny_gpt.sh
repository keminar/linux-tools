#!/bin/bash

##############################################################
# title		: arch tiny installer
# authors	: keminar
# contact	: https://github.com/keminar/linux-tools
# date		: 05.04.2014
# license	: GPLv2
# usage		: run ./tiny_gpt.sh
# 先使用parted分区，boot分区必须使用fat32格式
##############################################################

# Abort on any errors
set -e -u

# disk
DISK='sda'

# wifi utils soft, don't edit
WIFI_UTILS=''

# colors
unset OFF GREEN RED
OFF='\e[1;0m'
GREEN='\e[1;32m'
RED='\e[1;31m'
readonly OFF GREEN RED

# start
function tiny_start
{
	printf "$GREEN"
cat << EOF
-------------------------------
           Arch linux
        Tiny install start
-------------------------------
EOF
	printf "$OFF"
}

# network config
function tiny_network
{
	read -p "Connect internect type [none|wlan|wifi]: " type
	if [ "$type" = "wifi" ];then
		wifi-menu
		WIFI_UTILS='pacman -S --noconfirm dialog wpa_supplicant;'
	elif [ "$type" = "wlan" ];then
		dhcpcd
	fi
}

# select mirror
function tiny_mirror
{
	echo "Set 163.com mirror"
	mirror=`grep .163.com /etc/pacman.d/mirrorlist |head -n1`
	sed -i '5a\Server = http://mirrors.163.com/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist
	pacman -Sy
}

# set disk
function tiny_setdisk
{
	lsblk
	read -p "Select disk [sda|hda]: " disk
	disk=${disk:-$DISK}
	[[ $(lsblk -dno TYPE "/dev/$disk") = 'disk' ]] || tiny_setdisk
	DISK=$disk
}

# fdisk
function tiny_fdisk
{
	fdisk /dev/$DISK
	fdisk -l /dev/$DISK
	while :; do
		read -p "Which partition will be install system [${DISK}1]: " part
		part=${part:-${DISK}1}
		[[ $(lsblk -dno TYPE "/dev/$part") = 'part' ]] && break
	done

	read -p "Do you want to format ${part} partition use mkfs.ext4 [n|y]: " ans
	if [ "$ans" = "y" ]; then
		mkfs.ext4 /dev/$part
	fi
	mount /dev/$part /mnt
}

# pacstrap && fstab
function tiny_strap
{
	echo "start pacstrap base system"
	pacstrap /mnt base
	genfstab -U -p /mnt >> /mnt/etc/fstab
}

# chroot && grub
function tiny_chroot
{
	echo "Set arch-chroot"
	printf '%s\n' "mkinitcpio -p linux; \
	pacman -S --noconfirm grub; \
  pacman -S --noconfirm efibootmgr; \
  grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub; \
	grub-mkconfig -o /boot/grub/grub.cfg; \
	$WIFI_UTILS \
	" |arch-chroot /mnt
	umount /mnt
}

# success
function tiny_success
{
	printf "$GREEN"
cat << EOF
---------------------------------------
        Installation completed!
      Reboot the computer: # reboot
---------------------------------------
EOF
	printf "$OFF"
}

tiny_start
tiny_network
tiny_mirror
tiny_setdisk
tiny_fdisk
tiny_strap
tiny_chroot
tiny_success
