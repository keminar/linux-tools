#!/bin/bash

# 默认错误不退, 否则source执行时会退错
set +e

SCRIPT=$0
ACTION=$1
# 配置默认目录
confDir=~/.select
confFile=""
agentFile=""

# 检查是否为source执行
function isSource
{
    if [ "$SCRIPT" = "bash" -o "$SCRIPT" = "-bash" -o "${SCRIPT%/bin/bash}" != "${SCRIPT}" ]; then
        return 0
    else
        return 1
    fi
}

if ! isSource ;then
    confFile=$confDir/$(basename $SCRIPT .sh).conf
    agentFile=$confDir/$(basename $SCRIPT .sh).agent
fi

# 当前时间
timeNow=`date +%s`
# 最晚休息时间
timeEnd=`date +%s -d '21:00:00'`
# 计算有效期
timeExpire=$(($timeEnd - $timeNow))
# 如果不足1小时,按1小时有效
if [ $timeExpire -lt 3600 ];then
    timeExpire=3600
fi

# 根据参数执行指定动作
function check_action
{
    if [ "$ACTION" = "close" ];then
        # 关闭所有代理
        if pgrep ssh-agent >/dev/null;then
            echo "killall ssh-agent"
            killall ssh-agent
            exit 0
        fi
        echo "ssh-agent process not found"
        exit 0
    elif [ "$ACTION" = "clear" ];then
        # 清理当前代理密钥
        if [ -f $agentFile ];then
            source $agentFile >/dev/null
            if ps -p $SSH_AGENT_PID > /dev/null; then
                # 清理密钥
                ssh-add -D
                exit 0
            fi
        fi
        echo "ssh-agent process not found"
        exit 0
    elif [ "$ACTION" = "conf" ];then
        # check_config 检查过，一定会存在
        cat $confFile
        exit 0
    elif [ "$ACTION" = "agent" ];then
        # 可能是check_config 后才生成
        if [ -f $agentFile ];then
            cat $agentFile
        else
            echo "# $agentFile not found"
        fi
        exit 0
    elif [ "$ACTION" = "help" ];then
        name=$(basename $SCRIPT)
        echo ""
        echo "$name 是对ssh-agent的封装, 方便跨会话共享私钥密码连接服务器"
        echo ""
        echo "用法:"
        echo -e "\t$name [选项]"
        echo ""
        echo "选项:"
        echo -e "\tclose\t杀掉全部ssh-agent进程"
        echo -e "\tclear\t清除当前进程对应的由ssh-agent保存的密码"
        echo -e "\tconf \t输出当前进程对应的配置文件内容"
        echo -e "\tagent\t输出当前进程的ssh-agent信息,用于其它命令共享,方法为: eval \`$name agent\`"
        echo -e "\thelp \t帮助"
        exit 0
    fi
}

# 检查配置
function check_config
{
    if [ ! -d $confDir ];then
        mkdir $confDir
    fi
    if [ ! -f $confFile ];then
        echo "$confFile not found"
        exit 1
    fi
}

# 检查是否要记录ssh密码
function agent_add
{
    rsaList=`grep '^#rsa=' $confFile|awk -F '=' '{for(i=2;i<NF;i++)printf("%s=",$i);print $NF}'`
    if [ "$rsaList" != "" ];then
       if [ ! -f $agentFile ];then
           echo "start ssh-agent"
           ssh-agent -s >$agentFile 2>/dev/null
       fi
       source $agentFile >/dev/null
       # 如果不存在表示过期,要重新生成
       if ! ps -p $SSH_AGENT_PID > /dev/null; then
       #if [ ! -e $SSH_AUTH_SOCK ];then
           echo "start ssh-agent"
           ssh-agent -s >$agentFile 2>/dev/null
           source $agentFile >/dev/null
       fi
       # 临时把错误忽略, 不然ssh-add出错时会退出
       set +e
       for rsa in $rsaList
       do
           ssh-add -l 2>/dev/null|grep $rsa >/dev/null
           if [ "$?" != "0" ] ;then
               ssh-add -t $timeExpire $rsa
           fi
       done
       set -e
    fi
}

function select_cmd
{
   while true
   do
       opts=`cat $confFile |grep -v ^#|cut -d '=' -f 1 -s`
       if [ "$opts" = "" ];then
           echo "opts not set in $confFile"
           exit 1
       fi
       select opt in $opts 
       do
           if  [ "$opt" = "" ];then
               echo 'input not found, please retry'
           else
               echo "selected: $opt"
               while read line
               do
                   name=`echo $line|grep -v ^#|cut -d '=' -f 1 -s`
                   if [ "$name" = "$opt" ];then
                       cmd=`echo $line |awk -F '=' '{for(i=2;i<NF;i++)printf("%s=",$i);print $NF}'`
                       break 3
                   fi
               done < $confFile
           fi
           break
       done
   done
   #$cmd
   eval $cmd
}

# 不可用source调用提示
if [ "$confFile" = "" ];then
    echo "Do not use source command"
else
    # 非source 的打开错误中断退出
    set -e
    check_config
    check_action
    agent_add
    select_cmd
fi

