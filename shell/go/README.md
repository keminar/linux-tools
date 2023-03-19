Golang 版本切换
===

有时不同的项目可能需要不同的go来编译,所以有了这个小工具

把多个golang版本包下载并解压到指定目录,需要一直go软链指向任意一个版本,如下所示

```shell

$ ll /data/opt/|grep go|awk '{print $1,$6,$9}'
lrwxrwxrwx Mar go -> /data/opt/go1.18.7
drwxr-xr-x Jul go1.17.13
drwxr-xr-x Oct go1.18.7

```

使用方法
===
要切换go版本时, 执行 _gover_ 即可, 如下:
```shell
$ /data/bin/gover
Current version go1.18.7, do you need to change [y|n]?
1) go1.18.7
2) go1.17.13
#? 2
New version go1.17.13

```

如果你不想把go放在 **/data/opt/** 也可以指定目录执行,如 **gover /usr/local/**