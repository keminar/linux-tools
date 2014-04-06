Introduction
========
日用工具集

Install Arch Linux
========
	Arch 最小化系统安装
	进入Arch iso 系统
	下载arch/tiny.sh
	wget http://tools.linuxphp.org/arch -O tiny.sh
	chmod +x tiny.sh
	./tiny.sh
	按提示操作即可

qemu-tools
========
	虚拟机使用工具, 目前只在debian系统上使用kvm命令使用
	配置参考：http://blog.linuxphp.org/archives/134/
	没有使用新的qemu-system-i386因为上网有问题，去掉-no-acpi因为archlinux键盘问题
	使用命令如下
	./kvm.sh
	按提示操作
