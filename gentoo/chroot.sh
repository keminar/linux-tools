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
function tiny_check
{

	if ! mount -l |grep /mnt/gentoo >/dev/null ; then
		tiny_warn "First run ./prepare.sh shell\n"
		exit
	fi
}

# mount
function tiny_mount
{

	mount -t proc none /mnt/gentoo/proc
	mount --rbind /dev /mnt/gentoo/dev
    mount --rbind /sys /mnt/gentoo/sys
	cp -L /etc/resolv.conf /mnt/gentoo/etc/
	cp $BASEDIR/* /mnt/gentoo/
}

# select mirror
function tiny_mirror
{
	echo "Set 163.com mirror"
	echo 'GENTOO_MIRRORS="http://mirrors.163.com/gentoo/"' >> /mnt/gentoo/etc/portage/make.conf
	echo 'SYNC="rsync://rsync.cn.gentoo.org/gentoo-portage"' >> /mnt/gentoo/etc/portage/make.conf
}

# chroot && grub
function tiny_chroot
{
	tiny_warn "Now chroot into your Gentoo environment"
	chroot /mnt/gentoo /bin/bash
}
tiny_check
tiny_mount
tiny_mirror
tiny_chroot
