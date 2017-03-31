#!/bin/bash
# Build script using gradle
# created: 2016/11/1
# author: shanyou

if [ $SCRIPT_DEBUG ]; then set -x; fi

notify_msg(){
  echo -e "\033[0;32;1m[$(date +'%Y/%m%d %H:%M:%S')]: $*\033[0m"
}

alert_msg() {
  echo -e "\033[0;31;1m[$(date +'%Y/%m%d %H:%M:%S\')]: $*\033[0m"
}

# check user right function
# @$1: user name
check_user() {
  local current_uid=`id -u`
  local require_uid=`id -u $1`
  if [ $require_uid -ne $current_uid ]; then
    alert_msg The script $0 require $1 user to run.
    alert_msg Try to use sudo -u $1 $0 again.
    exit 1
  fi
}

# generate build tags
# usage:
# gen_tag <tagvariable>
gen_tag()
{
  local date_str=$(date +"%Y%m%d.%H%M").$(shuf -i 1-1000 -n 1)
  eval "$1=$date_str"
}

check_prog()
{
  if ! type "$1"  > /dev/null ; then
    alert_msg program $1 not exists. need to install it first
    exit 1
  fi
}

###### variable

WORK_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
APP_PATH=${WORK_DIR}/server/mimas/src/main/webapp
BUILD_PATH=${WORK_DIR}/server/mimas/build
RELEASE_WAR=mimas-1.0.0-SNAPSHOT.war
RELEASE_PATH=${BUILD_PATH}/libs/${RELEASE_WAR}
PUBLISH_DIR=/mnt/mercury_mimas_release
PUBLISH_LATEST_DIR=${PUBLISH_DIR}/latest

unset APP_VER
gen_tag APP_VER
notify_msg APP_VERSION: $APP_VER

#generate version.txt to app root
echo $APP_VER > ${APP_PATH}/version.txt

check_prog gradle

gradle clean
gradle assemble

if [ ! -f ${RELEASE_PATH} ]; then
  alert_msg ${RELEASE_PATH} not exists
  exit 1
fi

#mount -t cifs //172.17.60.104/casicloud_release /mnt/casicloud_release -o username=builder,password=1234.asd,uid=jenkins,gid=jenkins
mkdir -p ${PUBLISH_DIR}/${APP_VER}
mkdir -p ${PUBLISH_LATEST_DIR}

yes | cp -rf ${RELEASE_PATH} ${PUBLISH_DIR}/${APP_VER}/${RELEASE_WAR}
yes | cp -rf ${RELEASE_PATH} ${PUBLISH_LATEST_DIR}/${RELEASE_WAR}
echo ${APP_VER} > ${PUBLISH_LATEST_DIR}/version.txt

echo done!!!
