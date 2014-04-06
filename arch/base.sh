#!/bin/bash

##############################################################
# title		: arch base settings
# authors	: keminar
# contact	: https://github.com/keminar/linux-tools
# date		: 05.04.2014
# license	: GPLv2
# usage		: run ./base.sh
##############################################################

# your root password
PASSWD=123456

# network
function base_network
{
	read -p "Connect internect type [none|wlan|wifi]: " type
	if [ "$type" = "wifi" ];then
		pacman -S dialog wpa_supplicant
		wifi-menu
		profile=`netctl list|head -n1|awk '{print $2}'`
		if [ $profile = "" ];then
			base_network
			return
		fi
		netctl enable $profile
	elif [ "$type" = "wlan" ];then
		dhcpcd
		systemctl enable dhcpcd.service
	fi
	pacman -S net-tools
}

# passwd
function base_passwd
{
	echo "set root passwd"
	echo root:$PASSWD |chkpasswd
}

# language
function base_lang
{
	echo "set language"
	sed -i 's/#en_US.UTF-8/en_US.UTF-8/g' /etc/locale.gen
	sed -i 's/#zh_CN/zh_CN/g' /etc/locale.gen
	locale-gen
	echo LANG=en_US.UTF-8 > /etc/locale.conf
}

# font
function base_font
{
	echo "set font"
	pacman -S  ttf-dejavu wqy-zenhei wqy-microhei
}

# timezone
function base_timezone
{
	echo "set timezone"
	ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
}

# vim
function base_vim
{
	echo "set vim"
	pacman -S vim
	ln -sf /usr/bin/bim /usr/bin/vi
}

# sshd
function base_openssh
{
	echo "set sshd"
	pacman -S openssh
	systemctl enable sshd.service
}

base_network
base_passwd
base_lang
base_font
base_timezone
base_vim
base_openssh
