#!/bin/bash

basedir='/data/opt/kvm'
qemuimg='/usr/bin/qemu-img'
kvmcmd='/usr/bin/kvm'
#kvmcmd='/usr/bin/qemu-system-i386 -enable-kvm' # 连不上网要重配

function install
{
	read -p "input img name:" answer
	if [ ! -e $basedir/$answer.img ];then
		$qemuimg create $basedir/$answer.img  -f qcow2 10G
	fi

	read -p "input iso path:" iso
	if [ ! -e $iso ];then
		echo "iso not found"
		exit
	fi
	# archlinux要内存大于256,且不能有-no-acpi否则进不了系统或键盘会无法使用
	$kvmcmd -vnc :2  \
		-m 512 \
		-M pc \
		-hda $basedir/$answer.img \
		-cdrom $iso -boot d \
		-net nic,macaddr=52:54:00:12:34:57 -net tap,ifname=tap1
}

function start
{
	read -p "input img name:" answer
	if [ ! -e $basedir/$answer.img ];then
		echo "img not exists,exit."
		exit
	fi
	$kvmcmd -vnc :2 \
		-daemonize \
		-hda $basedir/$answer.img \
		-M pc \
		-m 512 \
		-localtime \
		-net nic,macaddr=52:54:00:12:34:57 -net tap,ifname=tap1
}

case "$1" in
	start)
		start
		;;
	install)
		install
		;;
	*)
		echo "usage: $0 {start|install}"
		exit
		;;
esac
