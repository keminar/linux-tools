# 选择执行

* DB连接
* SSH连接

# 配置

默认配置在~/.select/目录

# 记录ssh密码

在配置文件中增加#rsa=开头的配置如
```
#rsa=/root/.ssh/id_rsa
```
可以配置多个

# 关闭密码
```
./select.sh close
```
