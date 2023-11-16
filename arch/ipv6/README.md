# 前言

本文只是使用时的一些记录，无法保证所有描述都是准确的，因为官方Wiki要讲的东西比较多，所以新手没有头绪到底要怎么配置。

网络设置有几种套件（ netctl、 dhcpcd、 NetworkManager、 systemd-networkd 等 ），相互之间应该是冲突的，要选择其中一个。

本文是用 NetworkManager 帮助简单图形化配置本机静态ipv6，我原来有用dhcpcd配置ipv4，要禁用掉才行，其它同理。


# 开启ipv6

在Arch linux中 IPv6 默认是开启的，之前本地没有IPv6地址导致有个别网址访问有问题，所以手动进行了关闭。下面先反向开启，没有关闭过的可以忽略。

修改或删除 `/etc/sysctl.d/40-ipv6.conf` 来让系统给网卡分配IPv6地址：

```
 # Enable IPv6
 net.ipv6.conf.all.disable_ipv6 = 0
 net.ipv6.conf.nic0.disable_ipv6 = 0
```

上面的 `nic0` 是你的网卡名, `sudo systemctl restart systemd-sysctl` 来应用上述设置。

# 查看ipv4配置

```
# 查看ipv4地址和子网掩码
ip -4 addr show
```

如：`inet 192.168.1.235/19 brd 192.168.1.255 scope global noprefixroute enp3s0` 说明网卡enp3s0的ipv4地址为192.168.1.235，子网掩码19

```
# 查看网关
ip route
```

如：`default via 192.168.1.1 dev enp3s0 proto static metric 100` 说明网卡enp3s0的网关为192.168.1.1

# 查看DNS
cat /etc/resolv.conf

# 禁用冲突的服务

```
# 如有使用netctl禁
sudo systemctl disable netctl
sudo pacman -Rns netctl

# 如有使用dhcpcd禁
sudo systemctl stop dhcpcd
sudo systemctl disable dhcpcd

# 如有使用systemd-networkd禁
sudo systemctl disable systemd-networkd
sudo systemctl stop systemd-networkd
sudo systemctl disable systemd-resolved
sudo systemctl stop systemd-resolved
```

# 安装NetworkManager

```
sudo pacman -S networkmanager extra/nm-connection-editor

# 启用
sudo systemctl start NetworkManager
sudo systemctl enable NetworkManager
```

安装好以后就有一个高级网络配置的图形配置工具了，通过图形化配置ipv4和ipv6

静态ipv6 需要录入信息有“地址，前缀，网关，DNS服务器”