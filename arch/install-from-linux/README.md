
注意： 以下操作都要在命令行模式操作(如: ctrl+alt+f3)，不能在桌面模式的终端操作, 因为在移动旧环境目录后桌面会失效

# 旧系统
```
/dev/sdc2 /
/dev/sdc1 /boot
```

# 准备

```
cd /tmp/
wget http://mirrors.163.com/archlinux/iso/2023.03.01/archlinux-bootstrap-x86_64.tar.gz
tar xzf archlinux-bootstrap-x86_64.tar.gz --numeric-owner
sed -i 's/#Server = http:\/\/mirrors.163/Server = http:\/\/mirrors.163/g' /tmp/root.x86_64/etc/pacman.d/mirrorlist 
/tmp/root.x86_64/bin/arch-chroot /tmp/root.x86_64/
pacman-key --init
pacman-key --populate
```

# 挂载旧系统
```
mount /dev/sdc2 /mnt
mount /dev/sdc1 /mnt/boot

cd /mnt
mkdir -p data/bak/
mv bin etc home lib lib64 mnt opt root sbin srv usr var data/bak/
```

# 新系统
```
pacstrap /mnt base linux linux-firmware
genfstab -U -p /mnt >> /mnt/etc/fstab
arch-chroot /mnt
mkinitcpio -p linux
pacman -S  --noconfirm  grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg

echo root:123456|chpasswd
pacman -S vim dhcpcd net-tools
```
上面为硬盘GPT方案，如果盘为DOS的可参考从ISO安装脚本

# 退出
```
  exit
  exit
  reboot
```

# 官方Wiki
https://wiki.archlinux.org/title/Install_Arch_Linux_from_existing_Linux
