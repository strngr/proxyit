#!/bin/bash

CONTAINER=$1
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/../"
PROFILES_ROOT=$SCRIPT_DIR/.data

usage() {
    echo "$0 <container name>"
    echo
}

if [ "x$CONTAINER" == "x" ] || [ "$CONTAINER" == "help" ]; then
    usage
    exit 1
fi

mkdir -p $PROFILES_ROOT/$CONTAINER

PROXY=`grep -rP "^$CONTAINER\s" $SCRIPT_DIR/proxies.txt | awk '{ print $2 }' | head -1`
PROXY=${PROXY:-direct://}

echo CONTAINER=$CONTAINER
echo PROXY=$PROXY

docker run \
    --rm \
    -h $CONTAINER \
    -v $PROFILES_ROOT/$CONTAINER:/home/user \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -u `id -u` \
    --cap-add SYS_ADMIN \
    strngr/chromium:latest \
        /usr/bin/chromium  \
        --proxy-server="$PROXY" \
        http://ifconfig.co
