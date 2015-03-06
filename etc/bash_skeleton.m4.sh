#!/usr/bin/env bash

set -e

readonly SCRIPT_NAME=$(basename $0)
readonly PWD=$(pwd)

log() {
  logger -s -t $SCRIPT_NAME -- $*
}

usage() {
  echo <<-EOF
    USAGE
  EOF
}