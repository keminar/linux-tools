
使用parted分区
===
https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Disks

Effi引导
===
···
pacman -S efibootmgr
grub-install --target=x86_64-efi --efi-directory=esp_mount --bootloader-id=grub
···
