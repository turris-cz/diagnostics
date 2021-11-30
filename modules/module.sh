#!/bin/sh

section() {
	echo "== $@ =="
}


subsection() {
	echo "-- $@ --"
}


file_header() {
	local file="$1"
	echo "~~ File: $1 ~~"
}


error() {
	echo "!! $@ !!"
}


dump_file() {
	for file in "$@"; do
		file_header "$file"

		[ -f "$file" ] || {
			error "File not found"
			return 1
		}

		if file -Li "$file" | grep "text/plain"; then
			cat "$file"
		else
			error "File was detected as binary and is encoded by base64"
			base64 "$file"
		fi
	done
}


check_installed() {
	local program="$1"
	which "$program" > /dev/null || {
		error "Program '$program' not found"
		return 1
	}
}


# find uci parameters described by a given regexp and replace their values with asterisk symbols
uci_anonymize() {
	awk -v regex="$1" '
		BEGIN {
			FS = "="
			OFS = "="
		}
		$1 ~ regex {
			gsub(".", "*", $2)
		}
		{
			print
		}
	'
}


device() {
	if [ -z "${_OPENWRT_DEVICE_PRODUCT:-}" ]; then
		_OPENWRT_DEVICE_PRODUCT="$(. /etc/os-release && echo "$OPENWRT_DEVICE_PRODUCT")"
	fi
	echo "$_OPENWRT_DEVICE_PRODUCT"
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
	*)
		{
			echo "Invalid usage of diagnostics module!"
			echo "Usage: ${0##*/} (help|run)"
		} >&2
		exit 1
		;;
esac
