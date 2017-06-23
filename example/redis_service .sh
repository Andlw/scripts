#!/usr/bin/env bash

#

# redis start up the redis server daemon

#

# chkconfig: 345 99 99

# description: redis service in /etc/init.d/redis \

#            chkconfig --add redis or chkconfig --list redis \

#            service redis start  or  service redis stop

# processname: redis-server

# config: /etc/redis.conf



PATH=/data/redis/bin:/sbin:/usr/bin:/bin



REDISPORT=27001

EXEC=/data/redis/bin/redis-server

REDIS_CLI=/data/redis/bin/redis-cli



PIDFILE=/var/run/redis_6379.pid

CONF="/data/redis/redis.conf"

#make sure some dir exist

if [ ! -d /var/lib/redis ] ;then

    mkdir -p /var/lib/redis

    mkdir -p /var/log/redis

fi



case "$1" in

    status)

        ps -A|grep redis

        ;;

    start)

        if [ -f $PIDFILE ]

        then

                echo "$PIDFILE exists, process is already running or crashed"

        else

                echo "Starting Redis server..."

                $EXEC $CONF

        fi

        if [ "$?"="0" ]

        then

              echo "Redis is running..."

        fi

        ;;

    stop)

        if [ ! -f $PIDFILE ]

        then

                echo "$PIDFILE does not exist, process is not running"

        else

                PID=$(cat $PIDFILE)

                echo "Stopping ..."

                $REDIS_CLI -p $REDISPORT SHUTDOWN

                while [ -x ${PIDFILE} ]

              do

                    echo "Waiting for Redis to shutdown ..."

                    sleep 1

                done

                echo "Redis stopped"

        fi

        ;;

  restart|force-reload)

        ${0} stop

        ${0} start

        ;;

  *)

    echo "Usage: /etc/init.d/redis {start|stop|restart|force-reload}" >&2

        exit 1

esac
