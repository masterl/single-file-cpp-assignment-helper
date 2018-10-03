#!/bin/bash

readonly DIV_LINE="=================================================="
readonly PRINT_LINE="echo \"$DIV_LINE\""

function main() {
  ensure_executable_file_was_informed "$@"
  normalize_executable_path_to_absolute "$@"
  generate_output_paths
  generate_test_command
  generate_entr_command

  while true; do
    # This check is done here so user doesn't need to restart script
    #   after creating the file.
    if [ ! -f "$EXPECTED_OUTPUT_FILE" ]; then
      tput reset
      echo -e "Expected output file wasn't found!\\n"
      echo "Missing file:"
      echo "    $EXPECTED_OUTPUT_FILE"
      echo "$DIV_LINE"
      date
      sleep 2
      continue
    fi

    # This check is done here so user doesn't need to restart script
    #   after creating the file.
    # Also, for the executable, the user probably won't be able to compile
    #   the program at first, so this is needed to prevent entr from clogging
    #   screen with:
    #     entr: unable to stat '/path/to/file.cpp'
    #     entr: No regular files to watch
    if [ ! -f "$EXECUTABLE_PATH" ]; then
      tput reset
      echo "Waiting for executable..."
      echo "$DIV_LINE"
      date
      sleep 1
      continue
    fi

    echo "$EXECUTABLE_PATH" |
    entr -d bash -c "$ENTR_COMMAND"
  done
}

function ensure_executable_file_was_informed() {
  if [ -z "$1" ]
  then
    echo -e '\nUsage:'
    echo -e "\\t$0 <path/to/program/executable>"
    exit 1
  fi
}

function normalize_executable_path_to_absolute() {
  declare -gr "EXECUTABLE_DIR=$( cd "$( dirname "$1" )" && pwd )"

  declare -gr "EXECUTABLE_PATH=$EXECUTABLE_DIR/$( basename "$1" )"``
}

function generate_output_paths() {
  declare -gr "EXPECTED_OUTPUT_FILE=$EXECUTABLE_DIR/expected_output.txt"

  declare -gr "EXECUTION_OUTPUT_FILE=$EXECUTABLE_DIR/output.txt"
}

function generate_test_command() {
  local command_parts=(
    "$EXECUTABLE_PATH > $EXECUTION_OUTPUT_FILE &&"
    "diff -y --suppress-common-lines $EXPECTED_OUTPUT_FILE $EXECUTION_OUTPUT_FILE |"
    'head -n 30'
  )


  declare -gr "TEST_COMMAND=$(array_join ' ' "${command_parts[@]}")"
}

function generate_entr_command() {
  local command_parts=(
    'tput reset'
    'echo "Running program..."'
    "$PRINT_LINE"
    "$TEST_COMMAND"
    'echo'
    "$PRINT_LINE"
    'echo'
    'date'
  )

  declare -gr "ENTR_COMMAND=$(array_join ';' "${command_parts[@]}")"
}

function array_join() {
  local d=$1
  shift
  echo -n "$1"
  shift
  printf "%s" "${@/#/$d}"
}

main "$@"
