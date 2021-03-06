sony 笔记本安装说明
===

一、网卡驱动
---
	进入livecd 通过lspci -k查看加载的驱动，为Kernel modules: ath9k和Kernel modules: atl1c
	然后在内核里找到相应的选项，具体如下：

	*有线 Ethernet controller: Qualcomm Atheros AR8151 v2.0 Gigabit Ethernet
	参考图片 ethernet.png

	*无线 Network controller: Qualcomm Atheros AR9485 Wireless Network Adapter
	参考图片 wireless.png

二、显卡驱动
---
[Xorg Guide](https://wiki.gentoo.org/wiki/Xorg/Guide)

	通过lspci -k 查得我的显卡为ATI卡 [AMD/ATI] Whistler [Radeon HD 6630M/6650M/6750M/7670M/7690M]

	*这里先要了解一下想要装哪种驱动，fglrx（闭源驱动），radeon（开源驱动）一开始不了解，混装走了不少弯路
	我最后是装的radeon所以下面只记录此方式  

	1. 首先安装 emerge x11-drivers/radeon-ucode
	2. 查看 /lib/firmware/radeon/ 目录是否有相应文件,以备下一步使用
	3. 为了开启KMS，要将原来的framebuffer驱动都去掉
	(Device Drivers->Graphics support->Support for frame buffer devices中的所有驱动)
	然后将Device Drivers->Graphics support->Direct Rendering Manager和它下面的
	ATI Radeon和Enable modesetting on radeon by default
	这两个子项编译入内核(启动Enable modesetting on radeon by default是ATI Radeon的子项)。
	4. 将固件编译入内核这一步最重要，一开始对wiki上说在不理解，最后才知道这里不是勾选，而是手写录入了
	在Wiki 的AMD/ATI settings 这一段也有说明
	进入内核的 Device Drivers -> Generic Driver Options -> 选中
	Include in-kernel firmware blobs in kernel binary
	在下面的External firmware blobs to build into the kernel binary 上按回车，
	填入radeon/R600_rlc.bin radeon/R700_rlc.bin
	在Firmware blobs root directory中回车填入/lib/firmware
	如果上面的bin文件填写不对可以查看开机时的dmesg的错误信息找到需要的bin文件 参考 http://blog.csdn.net/txlxt1117/article/details/44633023
	5. 检查内核 Input driver support 是否正确
	6. 修改 /etc/portage/make.conf
```shell
#鼠标，键盘，触摸板
INPUT_DEVICES="evdev synaptics"
#ATI显卡驱动,如果是装fglrx驱动这里也要对应改
VIDEO_CARDS="radeon"
```
	7. 最后参考 https://wiki.gentoo.org/wiki/Kernel/Rebuild 或我的文档 重新编译内核并重启

三、窗口
---

```shell
emerge --ask --verbose x11-base/xorg-drivers
emerge --ask x11-base/xorg-x11
env-update
source /etc/profile
#生成在当前目录 xorg.conf.new
Xorg -configure
#拷贝到 /etc/X11/xorg.conf
cp xorg.conf.new /etc/X11/xorg.conf
#下面两个测试完可删除
emerge x11-wm/twm x11-terms/xterm 
#检查是否正常
startx
```

四、Gnome和Gdm
---
	*注意：由于gdm必须使用systemd而systemd和openrc互不兼容，所以要删除

	1. 按  https://wiki.gentoo.org/wiki/Systemd  配置内核并编译
	emerge --unmerge sys-fs/udev openrc sysvinit
	emerge systemd
	此时一定不要重启电脑，会进不了系统

	修改 /etc/default/grub
	GRUB_CMDLINE_LINUX="init=/usr/lib/systemd/systemd"
	grub2-mkconfig -o /boot/grub/grub.cfg
	这时可重启看是否正常

	#启动gdm报Failed to get D-Bus connection: Operation not permitted
	emerge systemd-sysv-utils
	安装时出现libpng高版本cmake失败 ,先卸载libpng
	用 emerge -av --usepkg "<libpng-1.6.0" 装上一个旧版本,然后emerge @preserved-rebuild解决

	2. 按 https://wiki.gentoo.org/wiki/GNOME/Guide 进行USE 配置
	查看所有选择，我这里选择4
	eselect profile list
	选择desktop/gnome/systemd
	eselect profile set 4

	修改/etc/portage/make.conf
	USE="bindist systemd -consolekit -kde X dbus gtk gtk3 gnome"

	系统更新
	emerge -av --deep --with-bdeps=y --newuse --update @world 

	3. 装gnome 和启动服务
```shell
emerge --ask gnome-base/gnome-light
env-update && source /etc/profile
systemctl enable dbus.service
systemctl enable gdm.service
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service

```

	4. 启动gnome

```shell
# 新建用户
useradd -m <username>
# plugdev
gpasswd -a <username> plugdev
# 切换到新用户,systemd方式不需要
#su <username>
#echo "exec gnome-session" > ~/.xinitrc
#sed -i '1i\export XDG_MENU_PREFIX=gnome-' ~/.xinitrc
startx
```

五、双系统引导
---
	emerge os-prober ntfs3g
	os-prober 执行时不能识别windows，检查安装ntfs3g时提示CONFIG_FUSE_FS:is not set when it should be
	编译内核打开FUSE, 里面看相关在都可以选上
	File systems ---> <*/M> FUSE (Filesystem in Userspace) support 
	
六、qtwebkit vs chromium block caused by icu
---
	参考 https://wiki.gentoo.org/wiki/Qt/FAQ#qt-webkit_vs_chromium_block_because_of_icu
	新建 /etc/portage/package.use/icublock 写入
```shell
dev-qt/qtwebkit gstreamer icu
```

七、fcitx中文输入
---
	添加USE再重新安装
	echo "app-i18n/fcitx gtk gtk3 qt4" > /etc/portage/package.use/fcitx
	emerge -av fcitx

	在.xprofile里加入如下行，并检查是否执行
	eval "$(dbus-launch --sh-syntax --exit-with-session)"
	export LANG=zh_CN.utf8
	export XMODIFIERS="@im=fcitx"
	export GTK_IM_MODULE=fcitx
	export QT_IM_MODULE=fcitx

	ibus不能删除，重命名防止ibus启动,解决wiznote问题
	mv /usr/bin/ibus-daemon /usr/bin/ibus-daemon.bak

	用登陆用户修改gnome配置,解决gedit问题
	gsettings set org.gnome.settings-daemon.plugins.keyboard active false
	gsettings set org.gnome.settings-daemon.plugins.xsettings overrides "{'Gtk/IMModule':<'fcitx'>}"

八、声音
---
	1. 通过 lspci |grep -i audio 查到是intel声卡和ATI声卡
	2. 编译内核，HD Audio里能选的都选上
```shell
Device Drivers --->
    Sound --->
        <*> Sound card Support
            <*> Advanced Linux Sound Architecture --->
                [*]   PCI sound devices  --->

                      Select the driver for your audio controller, e.g.:
                      <*>   Intel HD Audio  ---> (snd-hda-intel)
                            Select a codec or enable all and let the generic parse choose the right one:
                            [*] Build Realtek HD-audio codec support
                            [*] ...
                            [*] Build Silicon Labs 3054 HD-modem codec support
                            [*] Enable generic HD-audio codec parser
```
	3. 修改/etc/portage/make.conf 在USE里增加alsa
	更新系统让改变生效
	emerge --ask --changed-use --deep @world
	如果一开始按wiki设置USE安装过了alsa，但内核没有编译全，可尝试重新安装alsa
	emerge -av media-libs/alsa-lib
	4. 从gnome的 设置->硬件->声音  把输出声音打开, 默然是关闭的
