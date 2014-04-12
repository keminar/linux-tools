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
function chroot_check
{

	if ! mount -l |grep /mnt/gentoo >/dev/null ; then
		conf_warn "First run ./prepare.sh shell\n"
		exit
	fi
}

# mount
function chroot_mount
{

	mount -t proc none /mnt/gentoo/proc
	mount --rbind /dev /mnt/gentoo/dev
    mount --rbind /sys /mnt/gentoo/sys
	cp -L /etc/resolv.conf /mnt/gentoo/etc/
	cp $BASEDIR/* /mnt/gentoo/
	conf_warn "Mount proc,dev ok"
}

# select mirror
function chroot_mirror
{
	echo 'GENTOO_MIRRORS="http://mirrors.163.com/gentoo/"' >> /mnt/gentoo/etc/portage/make.conf
	echo 'SYNC="rsync://rsync.cn.gentoo.org/gentoo-portage"' >> /mnt/gentoo/etc/portage/make.conf
	conf_warn "Set mirror ok"
}

# chroot && grub
function chroot_chroot
{
	conf_warn "Now chroot into your Gentoo environment"
	chroot /mnt/gentoo /bin/bash
}
chroot_check
chroot_mount
chroot_mirror
chroot_chroot
