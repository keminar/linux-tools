gentoo 安装说明
===
一、配置wifi上网
---
http://blog.linuxphp.org/archives/1631/

二、下载包目录
---
[stage3](http://mirrors.163.com/gentoo/releases/x86/autobuilds/current-stage3-i686/)
[portage](http://mirrors.163.com/gentoo/snapshots/portage-latest.tar.bz2)

三、查看硬件lspci命令不存在
---
emerge pciutils

四、装好系统后重新编译内核
---
```shell
#!/bin/bash
cd /usr/src/linux
make menuconfig
cpu=$(($(cat /proc/cpuinfo | grep processor | wc -l)+1))
time make -j$cpu
version=$(ls -l /usr/src/|awk '{print $9}'|grep gentoo|cut -d "-" -f 2)
bit=$(getconf LONG_BIT)
if [ "$bit" = "32" ];then
	cp arch/x86/boot/bzImage /boot/kernel-x86-$version-gentoo
else
	cp arch/x86_64/boot/bzImage /boot/kernel-x86_64-$version-gentoo
fi
make modules_install
cp .config /boot/config-$version-gentoo
```
五、无网络安装软件
---
下载的包放在 /usr/portage/distfiles 目录，然后就可以使用emerge安装了

六、我的是Intel无线网卡,使用wifi上网（可以放在chroot里和安装wpa_supplicant一起做更方便）
---

*使用方法三编译内核，按照官网wifi里编译内核的说明选择驱动
https://wiki.gentoo.org/wiki/Wifi#linux-firmware

*安装固件
http://mirrors.163.com/gentoo/distfiles/linux-firmware-20150206.tar.xz
下载的包放在 /usr/portage/distfiles 目录
emerge linux-firmware

*重启电脑，查看网卡是否存在

七、重新进入chroot来安装wpa_supplicant软件包
---
由于wpa_supplicant依赖太多使用无网络安装方法会太累
进入livecd配置好网络，然后chroot,注意下面的$ROOT变量替换为实际设备
```bash
mount /dev/$ROOT /mnt/gentoo
mount -t proc none /mnt/gentoo/proc
mount --rbind /dev /mnt/gentoo/dev
mount --rbind /sys /mnt/gentoo/sys
cp -L /etc/resolv.conf /mnt/gentoo/etc/
chroot /mnt/gentoo /bin/bash
emerge wpa_supplicant
```
重启电脑

八、引导双系统
---
```
os-prober
grub2-mkconfig -o /boot/grub/grub.cfg
```

九、智能编译内核（不建议）
---
```
emerge genkernel
genkernel --install all
```

十、SSH支持中文
---
```
echo 'zh_CN.UTF-8 UTF-8' >> /etc/locale.gen
locale-gen
export LC_ALL=zh_CN.UTF-8
emerge openssh
/etc/init.d/sshd start
```

十一、make.conf里的SYNC变量给取消了
---
```
cp /usr/share/portage/config/repos.conf /etc/portage/repos.conf/gentoo.conf
```
参考 http://tieba.baidu.com/p/3723242816
