#!/bin/bash
set -e  # Bomb on any script errors
target_string="$1"
verbose=false
if [ -n "$2" ]; then
  verbose=true
fi

function main {
	# Get targets into an array, run 'em
	IFS=',' read -a targets <<< "$target_string"
	for target in "${targets[@]}"; do
		_run_target $target;
	done
	# Remove files added by ruby script
	rm capture.js
	rm config-screenshots.sh
	rm ui-screen-shooter.sh
	rm unix_instruments.sh
}

function _run_target {
	echo "  Running $1"
	if [ "$verbose" = true ]; then
		source ui-screen-shooter.sh "$HOME/Desktop/screenshots/$1" "$1"
	else
		source ui-screen-shooter.sh "$HOME/Desktop/screenshots/$1" "$1" >/dev/null 2>/dev/null
	fi
}

main