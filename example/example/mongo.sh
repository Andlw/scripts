#!/bin/sh
# chkconfig: - 64 36
# description:mongod
MONGO_HOME=/usr/local/mongodb/mongodb
case $1 in
start)
${MONGO_HOME}/bin/mongod  --maxConns 20000  --config ${MONGO_HOME}/mongodb.conf
;;
stop)
${MONGO_HOME}/bin/mongo 127.0.0.1:27017/admin --eval "db.shutdownServer()"
;;
status)
${MONGO_HOME}/bin/mongo 127.0.0.1:27017/admin --eval "db.stats()"
;;
esac
