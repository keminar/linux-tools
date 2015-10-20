archlinux命令行系统安装步骤
===
		1.下载系统ISO，并启动进入livecd
		2.wget tiny.sh并执行，按提示进行操作
		3.重启电脑进入新系统
		4.将base.sh通过u盘copy进来并执行，如果没有u盘可以配置网络(配置方法参考base.sh 的base_network函数)并下载bash.sh（下载可以通过curl，要用wget需要先使用pacman安装）

archlinux系统GNOME安装
===
```bash
pacman -S xorg-server xorg-server-utils xorg-xinit
pacman -S gnome gnome-extra gdm
systemctl enable gdm

lspci | grep VGA

pacman -Ss xf86-video | less
pacman -S wqy-microhei wqy-zenhei wqy-bitmapfont
pacman -S fcitx-im fcitx-rime fcitx-configtool librime fcitx-table-extra fcitx-qt5
pacman -S wget sudo base-devel

cat .xprofile 
export LC_CTYPE=zh_CN.UTF-8
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

```
