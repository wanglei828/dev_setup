#!/usr/bin/env bash

DOCKER_REPO="paddlepaddle/paddle"
VERSION="lei_dev"
CONTAINER_ID="lei_dev"

function print_usage() {
  echo "
    $0 [options]

    Options are:
      -r <repo>         Docker repo name, sush as "paddlepaddle/paddle".
      -v <version>      Image version, such as '20180122'. Default is 'latest'.
    For example:
      $0 -r paddlepaddle/paddle -v 20180122
  "
}

while [ $# -gt 0 ]
do
  case "$1" in
  -r)
    DOCKER_REPO=$2
    shift
    ;;
  -v)
    VERSION=$2
    shift
    ;;
  -h)
    print_usage
    exit 0
    ;;
  *)
    # Ignore
    ;;
  esac
  shift
done

IMG=${DOCKER_REPO}:${VERSION}

function container_running() {
    name=$1
    docker ps -a --format "{{.Names}}" | grep "${name}" > /dev/null
    return $?
}

function main(){
    docker pull $IMG

    if container_running "${CONTAINER_ID}"; then
        docker stop "${CONTAINER_ID}" 1>/dev/null
        docker rm -f "${CONTAINER_ID}" 1>/dev/null
    fi
    local display=""
    if [[ -z ${DISPLAY} ]];then
        display=":0"
    else
        display="${DISPLAY}"
    fi

    local devices=" -v /dev:/dev"

    USER_ID=$(id -u)
    GRP=$(id -g -n)
    GRP_ID=$(id -g)
    LOCAL_HOST=`hostname`
    DOCKER_HOME="/home/$USER"
    if [ "$USER" == "root" ];then
        DOCKER_HOME="/root"
    fi
    if [ ! -d "$HOME/.cache" ];then
        mkdir "$HOME/.cache"
    fi
    if [ ! -d "$HOME/.ssh" ];then
        mkdir "$HOME/.ssh"
    fi

    nvidia-docker run -it \
        -d \
        --privileged \
        --name $CONTAINER_ID \
        -e DISPLAY=$display \
        -e DOCKER_USER=$USER \
        -e USER=$USER \
        -e DOCKER_USER_ID=$USER_ID \
        -e DOCKER_GRP=$GRP \
        -e DOCKER_GRP_ID=$GRP_ID \
        -e DOCKER_IMG=$IMG \
        -e HOME=$HOME \
        -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
        -v $PWD:/paddle \
        -v /media:/media \
        -v $HOME/.cache:${DOCKER_HOME}/.cache \
        -v $HOME/.ssh:${DOCKER_HOME}/.ssh \
        -v $HOME/github/dev_setup:/dev_setup \
        -v /etc/localtime:/etc/localtime:ro \
        --net host \
        -w /paddle \
        ${devices} \
        --add-host in_dev_docker:127.0.0.1 \
        --add-host ${LOCAL_HOST}:127.0.0.1 \
        --hostname in_dev_docker \
        --shm-size 2G \
        $IMG \
        /bin/bash
    set +x

    if [ "${USER}" != "root" ]; then
        docker exec $CONTAINER_ID bash -c '/dev_setup/docker_adduser.sh'
    fi
}

main
