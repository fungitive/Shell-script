
#!/bin/bash
[ -f /etc/init.d/functions ] && source /etc/init.d/functions
bindir="/application/mysql/bin"
datadir="/application/mysql/data"
mysqld_pid_file_path="/application/mysql/`hostname`.pid"
PATH="/sbin:/usr/sbin:/bin:/usr/bin:$basedir/bin" #此步对开机启动及定时启动及其关键。
export PATH
return_value=0
# Lock directory.
lockdir='/var/lock/subsys'
lock_file_path="$lockdir/mysql"

log_success_msg(){
    echo " SUCCESS! $@" # 注意函数的缩进，下同，也是专业的表现，可放到functions里。
}
log_failure_msg(){
    echo " ERROR! $@"
}

# Start Func
start(){
    # Start daemon
    echo "Starting MySQL"
    if test -x $bindir/mysqld_safe  # 启动文件是否可执行。
    then
        $bindir/mysqld_safe --datadir="$datadir" --pid-file="$mysqld_pid_file_path"  >/dev/null &
        return_value=$? # 是否处理好返回值是区别脚本是否专业规范的关键。
        sleep 2

        # Make lock for CentOS
        if test -w "$lockdir"   # 锁目录是否可写。
        then
            touch "$lock_file_path"  # 创建锁文件。
        fi
        exit $return_value
    else
        log_failure_msg "Couldn't find MySQL server ($bindir/mysqld_safe)"
    fi
}
# Stop Func
stop(){
    if test -s "$mysqld_pid_file_path" # 是否PID文件存在并大小大于0。
    then
        mysqld_pid=`cat "$mysqld_pid_file_path"`

        if (kill -0 $mysqld_pid 2>/dev/null) # 检查PID对应的进程是否存在。
        then
            echo "Shutting down MySQL"
            kill $mysqld_pid  # 不能带-9，否则后果自负。
            return_value=$?
            sleep 2
        else
            log_failure_msg "MySQL server process #$mysqld_pid is not running!"
            rm -f "$mysqld_pid_file_path"
        fi
        # Delete lock for Oldboy's CentOS
        if test -f "$lock_file_path"
        then
            rm -f "$lock_file_path"
        fi
        exit $return_value
    else
        log_failure_msg "MySQL server PID file could not be found!"
    fi
}
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        if $0 stop; then
           $0 start
        else
           log_failure_msg "Failed to stop running server, so refusing to try to start."
           exit 1
        fi
        ;;

    *)
        echo "Usage: $0  {start|stop|restart}"
        exit 1
esac
exit $return_value #是否处理好返回值是区别脚本是否专业规范的关键。