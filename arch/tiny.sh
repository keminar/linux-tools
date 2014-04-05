#!/bin/bash

function passwd 
{
    echo "Set root passwd"
    echo root:123456 | chpasswd
}

function mirror
{
    echo "Set 163.com mirror"
    mirror=`grep .163.com /etc/pacman.d/mirrorlist |head -n1`
    sed -i '5a\Server = http://mirrors.163.com/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist
}

function netconfig
{
    read -p "Connect internect type [wlan|wifi]: " type
    if [ "$type" == "wlan" ];then
	dhcpcd
    else
	wifi-menu
    fi
}

function mkdisk
{
    lsblk
    read -p "Input disk [sda|hda]: " disk
    [[ $(lsblk -dno TYPE "/dev/$disk") = 'disk' ]] || mkdisk
    fdisk /dev/$disk
    fdisk -l /dev/$disk
    read -p "Do you want to format ${disk}1 device use mkfs.ext4 [y|n]? " dev
    if [ "$dev" == "y" ]; then
	mkfs.ext4 /dev/${disk}1
    fi
    mount /dev/${disk}1 /mnt
}


#netconfig
#mirror
#passwd
#mkdisk
