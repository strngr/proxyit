#!/bin/bash

CONTAINER=$1
SCRIPTS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT_DIR=$SCRIPTS_DIR/..
PROFILES_DIR=$ROOT_DIR/.data

usage() {
    echo "$0 <container name>"
    echo
}

if [ "x$CONTAINER" == "x" ] || [ "$CONTAINER" == "help" ]; then
    usage
    exit 1
fi

mkdir -p $PROFILES_DIR/$CONTAINER

PROXY=`grep -rP "^$CONTAINER\s" $ROOT_DIR/proxies.txt | awk '{ print $2 }' | head -1`
PROXY=${PROXY:-direct://}

echo CONTAINER=$CONTAINER
echo PROXY=$PROXY

docker run \
    --rm \
    -h $CONTAINER \
    -w /home/user/ \
    -v $PROFILES_DIR/$CONTAINER:/home/user \
    -v $ROOT_DIR/Downloads:/home/user/Downloads \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -u `id -u` \
    --cap-add SYS_ADMIN \
    strngr/chromium:latest \
        /usr/bin/chromium  \
        --proxy-server="$PROXY" \
        http://ifconfig.co
