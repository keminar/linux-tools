archlinux命令行系统安装步骤
===
```
1.下载系统ISO，并启动进入livecd
2.wget tiny.sh并执行，按提示进行操作
3.重启电脑进入新系统
4.有u盘下载好的base.sh进入第5步，否则进入第6步
5.将base.sh通过u盘copy进来并执行,完成
6.配置网络(参考base.sh 的base_network函数)下载base.sh（下载可以用curl，要用wget需要先用pacman安装）执行
```
archlinux系统GNOME安装
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
export LC_CTYPE=zh_CN.UTF-8
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

```
