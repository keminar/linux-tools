#!/bin/bash
set -e

SCRIPT=$0

# 不可用source调用
if [ "$SCRIPT" = "bash" -o "$SCRIPT" = "-bash" -o "${SCRIPT%/bin/bash}" != "${SCRIPT}" ]; then
   echo "Do not use source command"
   # 不可用exit
   return
fi

# 关闭记录的密码
if [ "$1" = "close" ];then
   echo "killall ssh-agent"
   killall ssh-agent
   exit 0
fi

# 配置默认目录
confDir=~/.select
if [ ! -d $confDir ];then
  mkdir $confDir
fi
confFile=$confDir/$(basename $SCRIPT .sh).conf
if [ ! -f $confFile ];then
  echo "$confFile not found"
  exit 1
fi

# 检查是否要记录ssh密码
rsaList=`grep '^#rsa=' $confFile|awk -F '=' '{for(i=2;i<NF;i++)printf("%s=",$i);print $NF}'`
if [ "$rsaList" != "" ];then
  agentFile=$confDir/$(basename $SCRIPT .sh).agent
  if [ ! -f $agentFile ];then
    echo "start ssh-agent"
    ssh-agent -s >$agentFile 2>/dev/null
  fi
  source $agentFile >/dev/null
  # 如果不存在表示过期,要重新生成
  if [ ! -e $SSH_AUTH_SOCK ];then
    echo "start ssh-agent"
    ssh-agent -s >$agentFile 2>/dev/null
    source $agentFile >/dev/null
  fi
  # 临时把错误忽略
  set +e
  for rsa in $rsaList
  do
    ssh-add -l 2>/dev/null|grep $rsa >/dev/null
    if [ "$?" != "0" ] ;then
      ssh-add $rsa
    fi
  done
  set -e
fi

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
$cmd


