#!/bin/bash                                                                                                           

# 设置环境变量, 已设置则忽略
# set path env, no repeat
function set_path_env
{
    params=$@
    if [ -n "${PATH##*${params}}" -a -n "${PATH##*${params}:*}" ]; then
        export PATH=$PATH:${params}
    fi
}
set_path_env "/data/bin"
set_path_env "/data/opt/go/bin"
set_path_env "/data/app/golang/bin"

