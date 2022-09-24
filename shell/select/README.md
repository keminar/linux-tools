# 选择执行, 功能如下

* DB连接
* SSH连接

# 配置

默认配置在~/.select/目录, 按shell文件名命名

# 使用
```
cp select.sh ssh.sh
bash ssh.sh

cp select.sh db.sh
bash db.sh
```

# 记录ssh密码

在配置文件中增加#rsa=开头的配置,可以配置多个

如
```
#rsa=/root/.ssh/id_rsa
#rsa=/root/.ssh/id_rsa2
ssh1=ssh root@127.0.0.1
ssh2=ssh root@127.0.0.1
```

# 关闭全部代理
```
./select.sh close
```

# 删除当前代理的密钥
./select.sh clear
