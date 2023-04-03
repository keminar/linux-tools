# 硬件

    一台主机，两个显示器，虚拟机用windows挂一个键盘一个鼠标一个显示器，主机Linux挂一个键盘一个显示器。使用barrier方案共享键鼠

# WARNING: secondary screen unavailable: unable to open screen

鼠标只在主系统激活，ssh连到客户端发现 barrierc 没启动，手动启动测试报上面错。解决方法是用客户端键盘激活屏幕并登录账号即可。
    
# 锁屏后鼠标不见了
    
在Linux键盘上按ctrl+alt+f3切换命令行模式，登录帐号。**sudo virsh shutdown win10** 关闭 windows机器，如果关不掉可以尝试  **sudo virsh destroy win10**
    
# 鼠标移动不到副屏

可以尝试ssh检查linux下进程是否存在，如果存在可以观查日志是否正常。如果也正常可以查看windows日志是否正常，如果也正正常可以尝试分别重启windows和linux下的barrier，如果还不能解决，那尝试重启windows
