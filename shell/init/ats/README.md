# apache traffic server 启动脚本

在官方基础上增加archlinux支持，需要通过aur安装start-stop-daemon包

ats目录需要手动修改为自己的安装目录


## 安装start-stop-daemon包

    wget http://developer.axis.com/download/distribution/apps-sys-utils-start-stop-daemon-IR1_9_18-2.tar.gz
    tar zxf apps-sys-utils-start-stop-daemon-IR1_9_18-2.tar.gz
    cd apps/sys-utils/start-stop-daemon-IR1_9_18-2/
    cc start-stop-daemon.c -o start-stop-daemon
    cp start-stop-daemon /usr/local/bin/start-stop-daemon
