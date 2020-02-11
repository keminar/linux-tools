#!/bin/bash

conf=~/.db.conf
if [ ! -f $conf ];then
	echo "$conf 不存在"
	exit 0
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
