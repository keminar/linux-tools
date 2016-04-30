sony 笔记本安装说明
===

一、网卡驱动
---
进入livecd 通过lspci -k查看加载的驱动，为Kernel modules: ath9k和Kernel modules: atl1c

然后在内核里找到相应的选项，具体如下：

有线 Ethernet controller: Qualcomm Atheros AR8151 v2.0 Gigabit Ethernet

参考图片 ethernet.png

无线 Network controller: Qualcomm Atheros AR9485 Wireless Network Adapter

参考图片 wireless.png

二、显卡驱动
---
通过lspci -k 查得我的显卡为ATI卡 [AMD/ATI] Whistler [Radeon HD 6630M/6650M/6750M/7670M/7690M]

这里先要了解一下想要装哪种驱动，fglrx（闭源驱动），radeon（开源驱动）一开始不了解，混装走了不少弯路

我最后是装的radeon所以下面只记录此方式  wiki https://wiki.gentoo.org/wiki/Xorg/Guide

1. 首先安装 emerge x11-drivers/radeon-ucode

2. 查看 /lib/firmware/radeon/ 目录是否有相应文件

3. 这一步最重要，一开始对wiki上说在不理解，最后才知道这里不是勾选，而是手写录入了

在AMD/ATI settings 这一段

进入内核的 Device Drivers ---> Generic Driver Options ---> 找到如下两个配置

Include in-kernel firmware blobs in kernel binary 在上面回车会提示录入

radeon/<CARD-MODEL>.bin (这里我录入的是radeon/R600_rlc.bin)

External firmware blobs to build into the kernel binary 在上面回车录入如下

/lib/firmware/

4. 检查内核 Input driver support 是否正确

5. 修改 /etc/portage/make.conf

## (For mouse, keyboard, and Synaptics touchpad support)

INPUT_DEVICES="evdev synaptics"

## (For AMD/ATI cards), 如果是装fglrx驱动这里也要对应改

VIDEO_CARDS="radeon"

6. 最后参考 https://wiki.gentoo.org/wiki/Kernel/Rebuild 或我的文档 重新编译内核并重启

三、窗口
---
emerge --ask --verbose x11-base/xorg-drivers

emerge --ask x11-base/xorg-x11

env-update

source /etc/profile

Xorg -configure 生成在当前目录 xorg.conf.new 拷贝到 /etc/X11/xorg.conf

emerge x11-wm/twm x11-terms/xterm 

startx 检查是否正常

四、Gnome和Gdm
---

注意：由于gdm必须使用systemd而systemd和openrc互不兼容，所以要删除

1.按 https://wiki.gentoo.org/wiki/Systemd 编译内核

emerge --unmerge sys-fs/udev openrc sysvinit

安装 emerge systemd

此时一定不要重启电脑，会进不了系统

修改 /etc/default/grub

GRUB_CMDLINE_LINUX="init=/usr/lib/systemd/systemd"

grub2-mkconfig -o /boot/grub/grub.cfg

重启看是否正常

2. 配置use

https://wiki.gentoo.org/wiki/GNOME/Guide

选择配置

eselect profile list 查看所有选择，我这里选择4

eselect profile set 4

修改/etc/portage/make.conf

USE="bindist systemd -consolekit -qt4 -kde X dbus gtk gnome"

系统更新 emerge -av --deep --with-bdeps=y --newuse --update @world 

3.装gnome 和启动服务 

emerge --ask gnome-base/gnome-light

systemctl enable dbus.service

systemctl enable systemd-networkd.service

systemctl enable systemd-resolved.service

systemctl enable gdm.service

emerge systemd-sysv-utils 安装时出现libpng高版本cmake失败 ,所有用 emerge -av --usepkg "<libpng-1.6.0" 装上一个旧版本

4.启动gnome

新建用户 useradd -m <username> 

然后 gpasswd -a <username> plugdev

切换到新用户 su <username>

echo "exec gnome-session" > ~/.xinitrc

sed -i '1i\export XDG_MENU_PREFIX=gnome-' ~/.xinitrc

startx

五、双系统引导
---
emerge os-prober ntfs3g

os-prober 不能识别windows，安装ntfs3g时提示CONFIG_FUSE_FS:is not set when it should be

编译内核打开FUSE
File systems ---> <*/M> FUSE (Filesystem in Userspace) support 
