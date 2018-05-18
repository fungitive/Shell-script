#!/bin/bash
#检查nginx是否启动
# Description: Only support RedHat system
. /etc/init.d/functions
WORD_DIR=/data/project/nginx1.10
DAEMON=$WORD_DIR/sbin/nginx
CONF=$WORD_DIR/conf/nginx.conf
NAME=nginx
PID=$(awk -F'[; ]+' '/^[^#]/{if($0~/pid;/)print $2}' $CONF)
if [ -z "$PID" ]; then
    PID=$WORD_DIR/logs/nginx.pid
else
    PID=$WORD_DIR/$PID
fi
stop() {
    $DAEMON -s stop
    sleep 1
    [ ! -f $PID ] && action "* Stopping $NAME"  /bin/true || action "* Stopping $NAME" /bin/false
}
start() {
    $DAEMON
    sleep 1
    [ -f $PID ] && action "* Starting $NAME"  /bin/true || action "* Starting $NAME" /bin/false
}
reload() {
    $DAEMON -s reload
}
test_config() {
    $DAEMON -t
}
case "$1" in
    start)
        if [ ! -f $PID ]; then
            start
        else
            echo "$NAME is running..."
            exit 0
        fi
        ;;
    stop)
        if [ -f $PID ]; then
            stop
        else
            echo "$NAME not running!"
            exit 0
        fi
        ;;
    restart)
        if [ ! -f $PID ]; then
            echo "$NAME not running!" 
            start
        else
            stop
            start
        fi
        ;;
    reload)
        reload
        ;;
    testconfig)
        test_config
        ;; 
    status)
        [ -f $PID ] && echo "$NAME is running..." || echo "$NAME not running!"
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|reload|testconfig|status}"
        exit 3
        ;;
esac