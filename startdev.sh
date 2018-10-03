#!/bin/bash

function main() {
  ensure_source_file_was_informed "$@"
  generate_paths "$@"

  tmux \
    new-session "$SCRIPTS_ROOT/autocompile.sh $1" \; \
    split-window -h "$SCRIPTS_ROOT/autotest.sh $EXECUTABLE_PATH" \; \
    attach
}

function ensure_source_file_was_informed() {
  if [ -z "$1" ]
  then
    echo -e '\nUsage:'
    echo -e "\\t$0 <path/to/file.cpp>"
    exit 1
  fi
}

function generate_paths() {
  declare -gr "SCRIPTS_ROOT=$( cd "$( dirname "$0" )" && pwd )"

  declare -gr "PROJECT_PATH=$( cd "$( dirname "$1" )" && pwd )"

  declare -gr EXECUTABLE_PATH="$PROJECT_PATH/program.bin"
}

main "$@"
