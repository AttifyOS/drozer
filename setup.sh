#!/usr/bin/env bash

set -e

show_usage() {
  echo "Usage: $(basename $0) takes exactly 1 argument (install | uninstall)"
}

if [ $# -ne 1 ]
then
  show_usage
  exit 1
fi

check_env() {
  if [[ -z "${APM_TMP_DIR}" ]]; then
    echo "APM_TMP_DIR is not set"
    exit 1
  
  elif [[ -z "${APM_PKG_INSTALL_DIR}" ]]; then
    echo "APM_PKG_INSTALL_DIR is not set"
    exit 1
  
  elif [[ -z "${APM_PKG_BIN_DIR}" ]]; then
    echo "APM_PKG_BIN_DIR is not set"
    exit 1
  fi
}

install() {
  wget https://github.com/AttifyOS/drozer/releases/download/va80c5f1/drozer-a80c5f1.tar.gz -O $APM_TMP_DIR/drozer-a80c5f1.tar.gz
  tar xf $APM_TMP_DIR/drozer-a80c5f1.tar.gz -C $APM_PKG_INSTALL_DIR/
  rm $APM_TMP_DIR/drozer-a80c5f1.tar.gz

  echo '#!/usr/bin/env sh' > $APM_PKG_BIN_DIR/drozer
  echo "PATH=$APM_PKG_INSTALL_DIR/bin:\$PATH $APM_PKG_INSTALL_DIR/bin/drozer" >> $APM_PKG_BIN_DIR/drozer
  chmod +x $APM_PKG_BIN_DIR/drozer

  echo "This package adds the command: drozer"
}

uninstall() {
  rm -rf $APM_PKG_INSTALL_DIR/*
  rm $APM_PKG_BIN_DIR/drozer
}

run() {
  if [[ "$1" == "install" ]]; then 
    install
  elif [[ "$1" == "uninstall" ]]; then 
    uninstall
  else
    show_usage
  fi
}

check_env
run $1