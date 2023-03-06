#!/bin/bash
SCRIPT=$(basename $0)

dir=${1:-'.'}
if [ "$dir" = "" ]; then
   echo "Usage: "
   echo "    $SCRIPT <DIR>"
   exit 2
fi

if [ ! -L "$dir/go" ];then
    echo "The $dir/go is not a symbolic link"
    exit 3
fi
link=`ls -al $dir/go|awk '{print $NF}'`
oldVer=`basename $link`
read -p "Current version $oldVer, do you need to change [y|n]?" answer
if [ "$answer" = 'n' ];then
    exit
fi

ver=""
lists=`find $dir -depth -maxdepth 1 -mindepth 1 -type d -name "go*"|awk -F '/' '{print $NF}'`
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

if [ "$oldVer" = "$ver" ];then
    echo "The new version is the same as the old version"
    exit
fi

fullVer=`echo "$dir/$ver"|sed 's#\/\/#\/#g'`
rm -f $dir/go
ln -sf $fullVer $dir/go
link=`ls -al $dir/go|awk '{print $NF}'`
newVer=`basename $link`
echo "New version $newVer"
