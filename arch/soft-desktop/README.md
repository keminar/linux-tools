显卡驱动
===
    执行 **lspci | grep VGA** 查看显卡品牌
    执行 **pacman -Ss xf86-video | less** 找到显卡驱动，如我的ati显卡，安装 **pacman -S xf86-video-ati**

基础包
===
```shell
pacman -S wget sudo base-devel ntfs-3g less
pacman -S wqy-microhei wqy-zenhei wqy-bitmapfont
pacman -S xorg-server
pacman -S gdm
systemctl enable --now gdm
```

轻巧的Mate桌面
===
```
pacman -S mate mate-extra
```

GNOME安装
===
```bash
pacman -S gnome gnome-extra 
```

* 2023-03-14 fcitx 在进入桌面后先从菜单打开软件，添加中文输入法就可正常使用

fcitx
===
pacman -S fcitx-im fcitx-rime fcitx-configtool librime fcitx-table-extra fcitx-qt5

```
cat> ~/.xprofile <<EOF
export LANG=zh_CN.utf8
#export LC_CTYPE=zh_CN.UTF-8
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
EOF
```

