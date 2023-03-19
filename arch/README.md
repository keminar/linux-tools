ISO系统安装
===
1. 下载系统ISO，并启动进入livecd
2. 在install-from-iso找到tiny.sh 或 tiny_gpt.sh 并执行，按提示进行操作
3. 如果是GPT模式,需要一个单独boot盘(大小为500M)
4. 重启电脑进入新系统, 默认密码 123456
5. 配置网络(参考base.sh 的base_network函数)下载base.sh（下载可以用curl，要用wget需要先用pacman安装）执行
6. 如果少装了软件可以重新u盘引导挂载盘并 arch-chroot /mnt 切入系统安装

注：使用tiny_gpt.sh 要先使用parted分区，boot分区必须使用fat32格式, 或者用fdisk把盘改回dos模式用tiny.sh

硬盘安装
===
    在install-from-iso目录

基础软件
===
    在安装好的系统里执行soft-base/base.sh

桌面软件
===
    在soft-desktop 目录,个人推荐mate 轻量稳定