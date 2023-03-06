#!/bin/bash
SCRIPT=$(basename $0)

# 存放版本列表的目录
dir=${1:-''}
if [ "$dir" = "" ]; then
    if [ "$GOROOT" = "" ]; then
        echo "Usage: "
        echo "    $SCRIPT <DIR>"
        exit 2
    else
        dir=`dirname $GOROOT`
    fi
fi
if [ ! -d "$dir" ];then
    echo "The $dir is not a directory"
    exit 3
fi
# 检查GOROOT
if [ "$GOROOT" = "" ]; then
    GOROOT="$dir/go"
fi

if [ ! -L "$GOROOT" ];then
    echo "The $GOROOT is not a symbolic link"
    exit 3
fi
link=`ls -al $GOROOT|awk '{print $NF}'`
oldVer=`basename $link`
read -p "Current version $oldVer, do you need to change [y|n]?" answer
if [ "$answer" = 'n' ];then
    exit
fi

# 选择新版本
ver=""
lists=`find $dir -depth -maxdepth 1 -mindepth 1 -type d -name "go[1-9].*"|awk -F '/' '{print $NF}'`
select opt in $lists
do
    if [ "$opt" = "" ]; then
        echo "Invalid input, please retry"
    else
        #echo "selected: $opt"
        for line in $lists
        do
            if [ "$line" = "$opt" ]; then
                ver=$opt
                break 3
            fi
        done
    fi
done

if [ "$ver" = "" ];then
    echo "Version list not found"
    exit 3
fi
if [ "$oldVer" = "$ver" ];then
    echo "The new version is the same as the old version"
    exit
fi

fullVer=`echo "$dir/$ver"|sed 's#\/\/#\/#g'`
rm -f $GOROOT
ln -sf $fullVer $GOROOT
link=`ls -al $GOROOT|awk '{print $NF}'`
newVer=`basename $link`
echo "New version $newVer"
