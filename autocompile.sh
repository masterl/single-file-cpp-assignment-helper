#!/bin/bash

if [ -z "$1" ]
then
  echo -e '\nUsage:'
  echo -e "\\t$0 <path/to/file.cpp>"
  exit 1
fi

# normalize to absolute paths
readonly FILE_DIR=$( cd "$( dirname "$1" )" && pwd )
readonly FILE_PATH="$FILE_DIR/$( basename "$1" )"

readonly EXECUTABLE="$FILE_DIR/program.bin"

readonly COMPILE_COMMAND="g++ -Wall -std=c++11 $FILE_PATH -o $EXECUTABLE"

readonly GIT_STATUS_COMMAND="git status"
readonly PRINT_LINE="echo \"==================================================\""

entr_command="
tput reset;
echo \"Compiling...\";
$PRINT_LINE;
$COMPILE_COMMAND;
echo;
$PRINT_LINE;
echo \"Running GIT Status...\";
$PRINT_LINE;
$GIT_STATUS_COMMAND;
echo;
date;
"

while true; do
  echo "$FILE_PATH" |
  entr -d bash -c "$entr_command"
done
