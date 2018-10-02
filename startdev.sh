#!/bin/bash

if [ -z "$1" ]
then
  echo -e '\nUsage:'
  echo -e "\\t$0 <path/to/file.cpp>"
  exit 1
fi

readonly SCRIPTS_ROOT=$( cd "$( dirname "$0" )" && pwd )

readonly PROJECT_PATH=$( cd "$( dirname "$1" )" && pwd )

readonly EXECUTABLE_PATH="$PROJECT_PATH/program.bin"

tmux \
  new-session "$SCRIPTS_ROOT/autocompile.sh $1" \; \
  split-window -h "$SCRIPTS_ROOT/autotest.sh $EXECUTABLE_PATH" \; \
  attach
