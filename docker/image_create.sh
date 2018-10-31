#!/usr/bin/env bash

SRC_TAG="paddlepaddle/paddle:lei_dev" 
DES_TAG="paddlepaddle/paddle:lei_dev" 

cat > Dockerfile <<EOL
FROM  ${SRC_TAG}
RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*
EOL

docker build -t ${DES_TAG} .
rm Dockerfile
