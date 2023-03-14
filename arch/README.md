archlinux命令行系统安装步骤
===
```
1.下载系统ISO，并启动进入livecd
2.wget tiny.sh并执行，按提示进行操作
3.重启电脑进入新系统, 默认密码 123456
4.有u盘下载好的base.sh进入第5步，否则进入第6步
5.将base.sh通过u盘copy进来并执行,完成
6.配置网络(参考base.sh 的base_network函数)下载base.sh（下载可以用curl，要用wget需要先用pacman安装）执行
7.如果少装了软件可以重新u盘引导挂载盘并 arch-chroot /mnt 切入系统安装
```

注：使用tiny_gpt.sh 要先使用parted分区，boot分区必须使用fat32格式, 或者用fdisk把盘改回dos模式用tiny.sh

GNOME安装
===
```bash
pacman -S xorg-server
pacman -S gnome gnome-extra gdm
systemctl enable gdm

lspci | grep VGA

pacman -Ss xf86-video | less
pacman -S wqy-microhei wqy-zenhei wqy-bitmapfont
pacman -S fcitx-im fcitx-rime fcitx-configtool librime fcitx-table-extra fcitx-qt5
pacman -S wget sudo base-devel

cat .xprofile 
export LANG=zh_CN.utf8
#export LC_CTYPE=zh_CN.UTF-8
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"

```

轻巧稳定的Mate桌面
===
```
pacman -S mate mate-extra
```
* 2023-03-14 fcitx 在gnome使用不了，在mate正常使用
