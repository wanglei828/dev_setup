#!/usr/bin/env bash

function init() {
  BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}

function print_usage() {
  echo 'Usage:
  ./setup.sh [OPTION]'
  echo 'Options:
  bash: 
  '
}

function main() {
  init
  OS="$(uname -s)"
  if [ "$OS" == "Darwin" ]; then
    cp $BASE_DIR/bash/.bashrc_mac  ~/.bashrc
  else
    cp $BASE_DIR/bash/.bashrc ~/
  fi
  cp $BASE_DIR/bash/.bash_profile ~/
  cp $BASE_DIR/bash/.bash_aliases ~/
  cp $BASE_DIR/bash/.vimrc ~/
  cp $BASE_DIR/git/.gitconfig ~/
  mkdir ~/.kube
  source ~/.bashrc
}

main
