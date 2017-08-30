#!/bin/bash

eval "$(rbenv init -)"

START_CMD="ruby mock-server.rb"
[[ -z "${PROJECT_DIR}" ]] && PROJECT_DIR="./" || PROJECT_DIR="${PROJECT_DIR}"
SERVER_DIR="${PROJECT_DIR}/../mock-server"

[[ -z "${BUILT_PRODUCTS_DIR}" ]] && LOG_DIR="/tmp" || LOG_DIR="${BUILT_PRODUCTS_DIR}"

LOG_PREBUILD="${LOG_DIR}/prebuild.log"
LOG_POSTBUILD="${LOG_DIR}/postbuild.log"
LOG_SERVER="${LOG_DIR}/server.log"

PID_SINATRA="${LOG_DIR}/sinatra.pid"

cd ${SERVER_DIR}

function _start {
  > ${LOG_SERVER}

  exec > ${LOG_PREBUILD} 2>&1

  $START_CMD > ${LOG_SERVER} 2>&1 &
  echo $! > ${PID_SINATRA}
}

function _stop {
  exec > ${LOG_POSTBUILD} 2>&1
  cd ${SERVER_DIR}

  SNTR_PID=$(< ${PID_SINATRA})

  echo "Sinatra server pid $SNTR_PID"

  kill -9 $SNTR_PID
}

function _monitor {
  ps aux | grep -E "${START_CMD}" | grep -Ev "(watch|grep)"
}

function _kill {
  _monitor | awk '{print $2}' | while read -r PID; do
    kill -9 $PID
  done
}

case "$1" in
  start)
    _kill
    _start
    ;;
  stop)
    _stop
    ;;
  kill)
    _kill
    ;;
  monitor)
    _monitor
    ;;
  *)
  echo $"Usage: $0 {start|stop|kill|monitor}"
  exit 1
esac
