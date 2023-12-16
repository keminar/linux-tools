Waydroid 手机模拟器
===

# 1. 需要给内核增加 binder 模块

常用方法有2个，只能选择其中一个
 ### 法1: 使用 linux-zen 内核
```shell
sudo pacman -S linux-zen
sudo grub-mkconfig -o /boot/grub/grub.cfg
```
 ### 法2: 从aur 安装 binder_linux-dkms
  使用 modprobe binder_linux 挂载模块

# 2. 安装 waydroid 和 waydroid-image-gapps

使用 aur 安装，安装后初始化

有两种镜像 vanilla 不含Google套间  gapps 含Google套间
```shell
sudo waydroid init -s GAPPS -f
sudo systemctl start waydroid-container
```

# 3. 使用weston以在X11下运行模拟器
```shell
sudo pacman -S weston
weston
```
weston 命令会打开一个新的窗口（使用Wayland的协议），在其左上角打开终端即可启动程                                                                                                                                                                                                                                                                      序

 ### 在weston终端内运行
```shell
waydroid session start
```
  1. 如果你命令前加了sudo会看到如下错误，去掉sudo即可

ERROR: org.freedesktop.DBus.Error.NotSupported: Using X11 for dbus-daemon autola                                                                                                                                                                                                                                                                      unch was disabled at compile time, set your DBUS_SESSION_BUS_ADDRESS instead

  2. 如果完全看到错误 /dev/anbox-binder: Permission denied 重启电脑再试

# 4. 在普通命令行
```shell
waydroid show-full-ui
```

如果遇到 can't open /dev/binder
```shell
 rm -rf /var/lib/waydroid
 sudo waydroid init -s GAPPS -f
```
  以后启动可以跳过`waydroid session start`直接使用`waydroid show-full-ui`

# 5. 安装arm指令转义

如果命令行安装 app 软件没出现，可能是包是arm的, aur 安装  waydroid-script-git

 ### 然后intel的cpu安装
```shell
sudo waydroid-extras install libhoudini
```
如果安装好app打开包闪退，尝试使用非加固包

# 6. 启动菜单

vim ~/.local/share/applications/Waydroid.desktop

修改菜单

Exec=weston --width=540 --height=960

关闭没用的菜单
```shell
for a in ~/.local/share/applications/waydroid.*.desktop;do grep -q NoDisplay $a                                                                                                                                                                                                                                                                       || sed '/^Icon=/a NoDisplay=true' -i $a; done
```

# 7. 模拟器假如没有网络，如果自己有用放火墙，如ufw
```shell
sudo pacman -S ufw
sudo ufw allow 67
sudo ufw allow 53
sudo ufw default allow FORWARD
```
在waydroid session start 前 sudo ufw enable

如果本地有其他服务，启用后发现用不了了，对应端口也要放行，如ssh
```
sudo ufw allow 22
```
如果没用防火墙不需要安装防火墙，跳过这一步

# 8. 模拟器设置代理

waydroid shell 进入模拟器执行：
```shell
settings put global http_proxy "IP:PORT"
```

# 9. Google play认证
https://docs.waydro.id/faq/google-play-certification

如果设置代理后Google store可以登录但是可能会打不开显示应用界面，
因为有到自己本机的请求也被转出来了，代理上设置自己ip，如我的192.168.240.112走本                                                                                                                                                                                                                                                                      地网络

# 10.旋转屏幕
按 F11 可将当前应用切换到窗口模式。

# 11. 参考

  - https://zhuanlan.zhihu.com/p/643889264
  - https://blog.sww.moe/post/waydroid-arknights/
  - https://wiki.archlinux.org/title/Waydroid
