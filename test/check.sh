#!/bin/bash

# Function to display help
function show_help() {
	echo "Usage: $0 <rand> <prog>"
	echo "Fuzzes <prog> by comparing its output with the input."
	echo
	echo "This script generates random signed numbers in the range -2^127-1 to 2^127-1,"
	echo "feeds them to <prog>, and compares the output with the input."
	echo "If the output differs, the number is logged to the 'err' file."
	exit 0
}

# Check for help flag or no arguments
if [ "$#" -le 1 ] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
	show_help
fi

# Variables
rand="$1"
prog="$2"
runs=0
faults=0
err_file="err"

# Check if <rand> starts with './', if not get the absolute path of the executable
if [[ "$rand" != ./* ]]; then
	rand="$(command -v "$rand")"
	if [ -z "$rand" ]; then
		echo "Error: '$1' is not found in PATH."
		exit 1
	fi
fi

# Check if the resolved <rand> is executable
if [ ! -x "$rand" ]; then
	echo "Error: '$rand' is not executable."
	exit 1
fi

# Check if <prog> starts with './', if not get the absolute path of the executable
if [[ "$prog" != ./* ]]; then
	prog="$(command -v "$prog")"
	if [ -z "$prog" ]; then
		echo "Error: '$1' is not found in PATH."
		exit 1
	fi
fi

# Check if the resolved <prog> is executable
if [ ! -x "$prog" ]; then
	echo "Error: '$prog' is not executable."
	exit 1
fi

# Trap Ctrl-C to exit gracefully
trap 'echo -e "\nExiting..."; exit 0' INT

# Loop forever
while true; do
	# Generate random 128-bit number
	num=$("$rand")

	# Capture outputs
	prog_output=$(echo "$num" | "$prog" 2>/dev/null)

	# Compare outputs
	if [ "$prog_output" != "$num" ]; then
		faults=$((faults + 1))
		echo "$num" >>"$err_file"
	fi

	runs=$((runs + 1))

	# Print statistics
	echo -ne "Runs: $runs, Faults: $faults\r"
done
