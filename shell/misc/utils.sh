# 检查进程是否在
function checkpid
{
    BASENAME=$(basename $1)
    PID=$$
    FID=$(ps -ef|grep "$BASENAME"|grep -v "grep "|grep -v "vim " |grep -v "sudo "|awk '{if ($2=='"$PID"'){print $3}}')
    pids=$(ps -ef|grep "$BASENAME"|grep -v "grep "|grep -v "vim "|grep -v "sudo "|awk '{print ","$2","$3","}')
    for i in $pids;do
        if echo "$i"|grep -v ",$PID,"|grep -v ",$FID," > /dev/null; then
            echo 'runing'
            exit
        fi
    done
}
