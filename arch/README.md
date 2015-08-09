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



cat .xprofile 

export LC_CTYPE=zh_CN.UTF-8

export GTK_IM_MODULE=fcitx

export QT_IM_MODULE=fcitx

export XMODIFIERS=@im=fcitx



pacman -S flashplugin

chromium-pepper-flash

pacman -S wget sudo base-devel
```
