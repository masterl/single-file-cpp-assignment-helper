#!/bin/bash

readonly PRINT_LINE='echo "=================================================="'

entr_command=''

function main() {
  ensure_source_file_was_informed "$@"
  normalize_source_path_to_absolute "$@"
  generate_executable_path
  generate_compile_command
  generate_entr_command

  while true; do
    echo "$SOURCE_PATH" |
    entr -d bash -c "$entr_command"
  done
}

function ensure_source_file_was_informed() {
  if [ -z "$1" ]
  then
    echo -e '\nUsage:'
    echo -e "\\t$0 <path/to/file.cpp>"
    exit 1
  fi
}

function normalize_source_path_to_absolute() {
  declare -gr "SOURCE_DIR=$( cd "$( dirname "$1" )" && pwd )"
  declare -gr "SOURCE_PATH=$SOURCE_DIR/$( basename "$1" )"
}

function generate_executable_path() {
  declare -gr "EXECUTABLE_PATH=$SOURCE_DIR/program.bin"
}

function generate_compile_command() {
  local compilation_flags=(
    '-Wall'
    '-std=c++11'
  )

  local command_parts=(
    'g++'
    "$(array_join ' ' "${compilation_flags[@]}")"
    "$SOURCE_PATH"
    "-o $EXECUTABLE_PATH"
  )

  declare -gr "COMPILE_COMMAND=$(array_join ' ' "${command_parts[@]}")"
}

function generate_entr_command() {
  local git_status_command="echo -n ''"

  if [ -x "$(command -v git)" ]; then
    local git_command_parts=(
      'echo "Running GIT Status..."'
      "$PRINT_LINE"
      "git -C $SOURCE_DIR status"
    )

    git_status_command="$(array_join ';' "${git_command_parts[@]}")"
  fi

  local command_parts=(
    'tput reset'
    'echo "Compiling..."'
    "$PRINT_LINE"
    "$COMPILE_COMMAND"
    'echo'
    "$PRINT_LINE"
    "$git_status_command"
    'echo'
    'date'
  )

  entr_command="$(array_join ';' "${command_parts[@]}")"
}

function array_join() {
  local d=$1
  shift
  echo -n "$1"
  shift
  printf "%s" "${@/#/$d}"
}

main "$@"
