#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <command> <name> [version_file]"
  exit 1
fi

command_to_check=$1
name=$2
version_file=${3:-}

echo ""
echo "Checking the $name environment."
echo ""

command_output=$($command_to_check 2>&1)
command_exit_code=$?

echo "\$ $command_to_check"
echo "$command_output"
echo ""

if [ $command_exit_code -ne 0 ]; then
  echo "[ ] Failed to verify the $name development environment."
  exit
fi

# If version_file is provided, read expected version from the file
if [ -n "$version_file" ]; then
  if [ -f "$version_file" ]; then
    expected_version=$(cat "$version_file")
  else
    echo "[ ] Version file $version_file does not exist."
    exit
  fi
fi

# If expected_version is set, perform version check
if [ -n "$expected_version" ]; then
  # Extract the version number from the command output
  # Assuming the version number is the first sequence of numbers and dots
  actual_version=$(echo "$command_output" | grep -o -E '[0-9]+(\.[0-9]+)*' | head -n 1)

  if [ "$actual_version" = "$expected_version" ]; then
    echo "[✓] Successfully verified the $name development environment."
  else
    echo "[ ] Version mismatch: expected $expected_version but found $actual_version"
    exit
  fi
else
  echo "[✓] Successfully verified the $name development environment."
fi
