#!/bin/bash

if [ -z "$1" ]
then
  echo -e '\nUsage:'
  echo -e "\\t$0 <path/to/program/executable>"
  exit 1
fi

# normalize to absolute paths
readonly EXECUTABLE_DIR=$( cd "$( dirname "$1" )" && pwd )
readonly EXECUTABLE_PATH="$EXECUTABLE_DIR/$( basename "$1" )"

readonly EXPECTED_OUTPUT_FILE="$EXECUTABLE_DIR/expected_output.txt"
readonly EXECUTION_OUTPUT_FILE="$EXECUTABLE_DIR/output.txt"

readonly TEST_COMMAND="$EXECUTABLE_PATH > $EXECUTION_OUTPUT_FILE &&
diff -y --suppress-common-lines $EXPECTED_OUTPUT_FILE $EXECUTION_OUTPUT_FILE |
head -n 30"

readonly DIV_LINE="=================================================="
readonly PRINT_LINE="echo \"$DIV_LINE\""

entr_command="
tput reset;
echo \"Running program...\";
$PRINT_LINE;
$TEST_COMMAND;
echo;
$PRINT_LINE;
echo;
date;
"

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
  entr -d bash -c "$entr_command"
done
