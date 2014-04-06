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

# color
function base_print
{
	OFF='\e[1;0m'
	RED='\e[1;31m'
	printf "$RED"
	printf "$@"
	printf "$OFF"
}

# pacman
function base_pacman
{
	pacman -S --noconfirm "$@"
}

# network
function base_network
{
	base_print "set network"
	read -p "Connect internect type [none|wlan|wifi]: " type
	if [ "$type" = "wifi" ];then
		base_pacman dialog wpa_supplicant
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
	base_pacman net-tools
}

# sshd
function base_openssh
{
	base_print "set sshd"
	base_pacman openssh
	read -p "Start sshd at boot?[y|n]: " type
	if [ "$type" != 'n' ];then
		systemctl enable sshd.service
	fi
}

# passwd
function base_passwd
{
	base_print "set root passwd"
	echo root:$PASSWD |chpasswd
}

# language
function base_lang
{
	base_print "set language"
	sed -i 's/#en_US.UTF-8/en_US.UTF-8/g' /etc/locale.gen
	sed -i 's/#zh_CN/zh_CN/g' /etc/locale.gen
	locale-gen
	echo LANG=en_US.UTF-8 > /etc/locale.conf
}

# timezone
function base_timezone
{
	base_print "set timezone"
	ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
}

# keymap
function base_keymap
{
	base_print "set keymap"
	echo KEYMAP=us > /etc/vconsole.conf
	echo FONT= >> /etc/vconsole.conf
}

# vim
function base_vim
{
	base_print "set vim"
	base_pacman vim
	ln -sf /usr/bin/vim /usr/bin/vi
}

# alias
function base_alias
{
	echo  alias ll='ls -l' >> /etc/bash.bashrc
}

base_network
base_openssh
base_passwd
base_lang
base_timezone
base_keymap
base_vim
base_alias
