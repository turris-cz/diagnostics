#!/bin/sh

section() {
	echo "== $@ =="
}


subsection() {
	echo "-- $@ --"
}


error() {
	echo "!! $@ !!"
}


check_installed() {
	local program="$1"
	which "$program" > /dev/null || {
		error "Program '$program' not found"
		return 1
	}
}


. "$1"

case "$2" in
	help)
		# remove first and last newline
		newline="
"
		help=${help##$newline}
		help=${help%%$newline}
		echo "$help"
		;;
	run)
		run
		;;
esac
