#!/usr/bin/env bash
#!/bin/bash
# chkconfig: 12345 80 90
function start_http(){
    /usr/local/apache/bin/apachectl  start
}
function stop_http(){
    /usr/local/apache/bin/apachectl  stop
}
case "$1" in
    start)
        start_http
        ;;
    stop)
    stop_http
        ;;
    restart)
        stop_http
        start_http
        ;;
    *)
        echo "Usage : start | stop | restart"
        ;;
esac