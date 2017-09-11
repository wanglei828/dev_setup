#!/bin/bash

xhost +local:root 1>/dev/null 2>&1
docker exec -it tmp_container /bin/bash
xhost -local:root 1>/dev/null 2>&1
