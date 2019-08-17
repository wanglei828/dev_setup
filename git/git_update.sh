#!/bin/bash

SRC_ROOT="${HOME}/github"

for SRC_DIR in "${SRC_ROOT}"/*; do
    if [ -d ${SRC_DIR} ] && [ -d ${SRC_DIR}/.git ];then
        cd ${SRC_DIR} && git checkout master && git pull
    fi
done
