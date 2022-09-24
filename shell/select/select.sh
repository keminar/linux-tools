#!/bin/bash
set -e

SCRIPT=$0
ACTION=$1
# 配置默认目录
confDir=~/.select

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

# 关闭记录的密码
function agent_close
{
   if [ "$ACTION" = "close" ];then
      echo "killall ssh-agent"
      killall ssh-agent
      exit 0
   fi
}

# 检查配置
function check_config
{
   if [ ! -d $confDir ];then
     mkdir $confDir
   fi
   confFile=$confDir/$(basename $SCRIPT .sh).conf
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
     agentFile=$confDir/$(basename $SCRIPT .sh).agent
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
   $cmd
}

# 不可用source调用
if [ "$SCRIPT" = "bash" -o "$SCRIPT" = "-bash" -o "${SCRIPT%/bin/bash}" != "${SCRIPT}" ]; then
   echo "Do not use source command"
   # 把错误回滚,不然后面再操作shell出错时会退掉终端
   set +e
else
   agent_close
   check_config
   agent_add
   select_cmd
fi

