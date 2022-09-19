#!/bin/bash

SCRIPT=$0
# 用于ssh连服务器时，密钥有密码
rsa=""

if [ "$rsa" != "" ];then
    ssh-add -l 2>/dev/null|grep $rsa >/dev/null
    if [ "$?" != "0" ] ;then
        # 使用source时可调用ssh-agent保存密钥密码
        if [ "${SCRIPT%/bin/bash}" != "${SCRIPT}" ]; then
            eval `ssh-agent -s`
            ssh-add ~/.ssh/$rsa
            return
        else
            echo "# source $SCRIPT"
            exit
        fi
    fi
fi

# 为避免取相对路径有岐义，source时不向下执行
if [ "${SCRIPT%/bin/bash}" != "${SCRIPT}" ]; then
    echo "Do not use source command"
    # 注意这里不能exit
    return
fi

conf=$(dirname $SCRIPT)/.$(basename $SCRIPT .sh).conf
if [ ! -f $conf ];then
    conf=$(dirname $SCRIPT)/$(basename $SCRIPT .sh).conf
    if [ ! -f $conf ];then
        echo "$conf 不存在"
        exit 0
    fi
fi

while true
do
    select opt in `cat $conf |grep -v ^#|cut -d '=' -f 1 -s`
    do
        if  [ "$opt" = "" ];then
            echo '输入的项不存在,重新选择编号'
        else
            echo "选择了数据项: $opt"
            while read line
            do
                name=`echo $line|grep -v ^#|cut -d '=' -f 1 -s`
                if [ "$name" = "$opt" ];then
                    cmd=`echo $line |awk -F '=' '{for(i=2;i<NF;i++)printf("%s=",$i);print $NF}'`
                    break 3
                fi
            done < $conf
        fi
        break
    done
done
$cmd
