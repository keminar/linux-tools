Waydroid 手机模拟器
===

# 1. 需要给内核增加 binder 模块

  常用方法有2个，只能选择其中一个
  ### 法1: 使用 linux-zen 内核
    ```shell
    sudo pacman -S linux-zen
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    ```
  ### 法2: 从aur 安装 binder_linux-dkms （不推荐）
  安装以后使用 `modprobe binder_linux` 挂载模块

# 2. 安装 waydroid 和 waydroid-image-gapps

  使用 aur 安装，安装后初始化
  
  有两种镜像,区别是 vanilla 不含Google套间, gapps 含Google套间
  ```shell
  sudo waydroid init -s GAPPS -f
  sudo systemctl start waydroid-container
  ```

  注：waydroid-image-gapps也可以不用aur安装，通过点waydroid图标启动, 首次打开可下载镜像，这种方式好像不需要命令行再init了

# 3. 使用weston以在X11下运行模拟器
  ```shell
  sudo pacman -S weston
  weston
  ```
  weston 命令会打开一个新的窗口（使用Wayland的协议），在其左上角打开终端即可启动程序
 
  Mate桌面需要安装，Gnome可以不安装，直接点图标可以启动waydroid 
 ### 在weston终端内运行测试
  ```shell
  waydroid session start
  ```
  1. 如果你命令前加了sudo会看到如下错误，去掉sudo即可

ERROR: org.freedesktop.DBus.Error.NotSupported: Using X11 for dbus-daemon autola                                                                                                                                                                                                                                                                      unch was disabled at compile time, set your DBUS_SESSION_BUS_ADDRESS instead

  2. 如果看到错误 /dev/anbox-binder: Permission denied 重启电脑再试

# 4. 启动模拟器
  在weston终端执行 `waydroid show-full-ui` , (启动可以跳过`waydroid session start`)

  关闭虚拟机使用 `waydroid session stop`

  如果遇到 can't open /dev/binder 尝试重新初始化
  ```shell
   rm -rf /var/lib/waydroid
   sudo waydroid init -s GAPPS -f
  ```

# 5. 安装arm指令转义

  默认系统是x86的，如果命令行安装 app 软件没出现，可能是包是arm的, aur 安装  waydroid-script-git

  ### 然后intel的cpu安装
  ```shell
  sudo waydroid-extras install libhoudini
  ```
  ### 如果amd的cpu安装
  ```shell
  sudo waydroid-extras intall libndk
  ```
  如果安装好app打开包闪退，尝试使用非加固包

# 6. 启动菜单

  修改菜单 `vim ~/.local/share/applications/Waydroid.desktop` 的Exec行为下面内容
  
  ```
  Exec=weston --width=540 --height=960
  ```

  可以关闭没用的菜单
  ```shell
  for a in ~/.local/share/applications/waydroid.*.desktop;do grep -q NoDisplay $a                                                                                                                                                                                                                                                                       || sed '/^Icon=/a NoDisplay=true' -i $a; done
  ```

# 7. 模拟器假如没有网络
  默认浏览器首页是Google网络问题会打不开，点右边三个点改为baidu 重新打开浏览器就好了

  如果还是没有网络检查防火墙，如果有用ufw防火墙，是这样操作
  ```shell
  sudo pacman -S ufw
  sudo ufw allow 67
  sudo ufw allow 53
  sudo ufw default allow FORWARD
  ```
  没用防火墙不需要安装防火墙，跳过这一步

# 8. 模拟器设置代理

  终端执行命令  `waydroid shell` 进入模拟器执行：
  ```shell
  settings put global http_proxy "IP:PORT"
  ```

# 9. Google play认证
  https://docs.waydro.id/faq/google-play-certification

  如果设置代理后Google store可以登录但是可能会打不开应用界面，因为有到自己本机的请求也被代理出来了

  代理上设置到自己模拟器ip的请求，如我的192.168.240.112走本地网络                                                                                                                                                                                                                                                                     地网络

# 10.旋转屏幕
  按 F11 可将当前应用切换到窗口模式。

# 11. 参考

  - https://zhuanlan.zhihu.com/p/643889264
  - https://blog.sww.moe/post/waydroid-arknights/
  - https://wiki.archlinux.org/title/Waydroid

# 12. 其他
   android studio 做过测试， windows+Intel下x86镜像无法安装arm的手机app同时无法启动arm镜像
   
   但在Linux下(未安装waydroid前)可以使用x86镜像安装arm架构的app，使用速度上比waydroid差一些

# 13. 报错ModuleNotFoundError: No module named 'gbinder'

   参考 https://github.com/waydroid/waydroid/issues/344  因为系统升级了，导致aur安装的 python-gbinder 也需要重新安装
   

  
