Introduction
===
	这是我使用Linux的成长日记，方便对新电脑做系统安装，环境部署等。也有些目录不常用可能会随着时间推移会失效。

Arch Linux
===
	Arch Linux 是通用 x86-64 GNU/Linux 发行版。Arch采用滚动升级模式，尽全力提供最新的稳定版软件。
	初始安装的Arch只是一个基本系统，随后用户可以根据自己的喜好安装需要的软件并配置成符合自己理想的系统。
	这是我日常使用的发行版，需要定期（如：每周）进行系统更新。系统安装脚本在 arch 目录

Gpu-直通
===
    gpu-passthrough 是一项显卡直通技术，可以让虚拟机使用物理硬件提供更优的性能

Shell
===
	一些日常使用的脚本
Vim
===
	Vim 简单配置

Gentoo [无维护]
===
    Gentoo Linux是一套通用的、快捷的、完全免费的Linux发行版，它面向开发人员和网络职业人员。
	与其他发行不同的是，Gentoo Linux拥有一套先进的包管理系统叫作Portage。
	系统安装脚本在gentoo目录，现在没在持续使用，所以脚本仅供参考。

qemu-tools [无维护]
===
	虚拟机使用工具, 目前只在debian系统上使用kvm命令使用
	配置参考：http://blog.linuxphp.org/archives/134/
	没有使用新的qemu-system-i386因为上网没配好有问题，去掉-no-acpi因为archlinux键盘问题
	使用命令如下
	./kvm.sh
	按提示操作
