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

# check
function build_check
{

	if [ -d /mnt/gentoo ]; then
		conf_warn "First run ./chroot.sh shell\n"
		exit
	fi
}

# config
function build_config
{
	env-update
	source /etc/profile
	echo root:$PASSWD|chpasswd
	# timezone
	cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
	# hostname
	echo "127.0.0.1 gentoo localhost" > /etc/hosts
	sed -i -e 's/hostname.*/hostname="gentoo"/' /etc/conf.d/hostname
	# locale
	sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
	locale-gen
	# fstab
	nano -w /etc/fstab
	conf_warn "Config ok"
}

# kernel
function build_kernel
{
	emerge-webrsync
	emerge --sync
	time emerge gentoo-sources
	cd /usr/src/linux
	make menuconfig
	cpu=$(($(cat /proc/cpuinfo | grep processor | wc -l)+1))
	time make -j$cpu
	version=$(ls -l /usr/src/|awk '{print $9}'|grep gentoo|cut -d "-" -f 2)
	cp arch/x86/boot/bzImage /boot/kernel-$version-gentoo
	make modules_install

	# emerge genkernel
	# genkernel --install --no-ramdisk-modules initramfs
	conf_warn "Kernel ok"
}

# grub
function build_grub
{
	emerge grub
	grub2-install /dev/$GRUB_DISK
	grub2-mkconfig -o /boot/grub/grub.cfg
	conf_warn "Grub ok"
}

# utils
function build_network
{
	emerge dhcpcd
	ln -sf /etc/init.d/net.lo /etc/init.d/net.eth0
	rc-update add net.eth0 default
	conf_warn "utils ok"
}

build_check
build_config
build_kernel
build_grub
build_network
conf_success
