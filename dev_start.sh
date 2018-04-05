#!/usr/bin/env bash

DOCKER_REPO="paddlepaddle/paddle"
VERSION="lei_dev"
CONTAINER_ID="lei_dev"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function print_usage() {
  echo "
    $0 [options]

    Options are:
      -r <repo>         Docker repo name, sush as "paddlepaddle/paddle".
      -v <version>      Image version, such as 'lei_dev'. Default is 'latest'.
      -t <build_type>   Container environment setting, such as "CI".
      -h                Print help message.
    For example:
      $0 -r paddlepaddle/paddle -v lei_dev -t CI 
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
  -t)
    TYPE=$2
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

    case "${TYPE}" in
      "CI")
        DOCKER_ENV=$(cat <<EOL
            -e FLAGS_fraction_of_gpu_memory_to_use=0.15 \
            -e CTEST_OUTPUT_ON_FAILURE=1 \
            -e CTEST_PARALLEL_LEVEL=5 \
            -e WITH_GPU=ON \
            -e WITH_TESTING=ON \
            -e WITH_C_API=OFF \
            -e WITH_COVERAGE=ON \
            -e COVERALLS_UPLOAD=ON \
            -e WITH_DEB=OFF \
            -e CMAKE_BUILD_TYPE=RelWithDebInfo \
            -e PADDLE_FRACTION_GPU_MEMORY_TO_USE=0.15 \
            -e CUDA_VISIBLE_DEVICES=0,1 \
            -e WITH_DISTRIBUTE=ON \
            -e RUN_TEST=ON
EOL
         )
         ;;
      *)
       ;;
      esac
        
    set -x
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
        ${DOCKER_ENV} \
        -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
        -v $HOME/.cache:${DOCKER_HOME}/.cache \
        -v $HOME/.ssh:${DOCKER_HOME}/.ssh \
        -v /etc/localtime:/etc/localtime:ro \
        -v /media:/media \
        -v /dev:/dev \
        -v $PWD:/paddle \
        -v $DIR:/dev_setup \
        -w /paddle \
        --net host \
        --add-host in_dev_docker:127.0.0.1 \
        --add-host ${LOCAL_HOST}:127.0.0.1 \
        --hostname in_dev_docker \
        $IMG \
        /bin/bash
    set +x

    if [ "${USER}" != "root" ]; then
        docker exec $CONTAINER_ID bash -c '/dev_setup/docker_adduser.sh'
    fi
}

main
