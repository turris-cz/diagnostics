#!/bin/sh

# set proper gettext domain
export TEXTDOMAIN=turris-diagnostics
export TEXTDOMAINDIR=/usr/share/locale

MAX_LINES_PER_MODULE=${MAX_LINES_PER_MODULE:-100000}

# enter the script directory
cd "$(dirname $0)"

ALL_MODULES=./modules/*.module

module_exists() {
	[ -x "$1" ]
}

module_name() {
	local t="$(basename "${1%.module}")"
	echo "${t#*_}" # remove initial index from XX_name
}

module_from_name() {
	# There should be only one module of the same name but to be sure we
	# potentially select the one with lower number.
	find -name "??_$1.module" | head -1
}


module_help() {
	for module in $ALL_MODULES; do
		printf "  %s\n" "$(module_name "$module")"
		"$module" help | sed 's/^/    /'
		echo
	done
}

print_usage() {
	echo "Usage: $(basename $0) [-b] [-o <file> | -O <file>] [module1[ module2[...]]]"
}

print_help() {
	print_usage
	echo
	echo "Arguments:"
	echo "	-b		$(gettext "run in background")"
	echo "	-o <file>	$(gettext "print output to a file")"
	echo "	-O <file>	$(gettext "print output to a directory module per file")"
	echo
	gettext "modules:"
	echo
	module_help
}


module_run() {
	local module="$1"
	if [ -n "$OUTPUT_DIRECTORY" ] ; then
		module_wrapper "$module" >> "$OUTPUT_DIRECTORY.preparing/$module.out.preparing"
		mv "$OUTPUT_DIRECTORY.preparing/$module".out.preparing "$OUTPUT_DIRECTORY.preparing/$module".out
	elif [ -n "$OUTPUT_FILE" ] ; then
		{
			module_header "$module"
			module_wrapper "$module"
			module_footer "$module"
		} >> "$OUTPUT_FILE".preparing
	else
		module_header "$module"
		module_wrapper "$module"
		module_footer "$module"
	fi
}


module_header() {
	local module_name="$1"
	printf "############## %s\n" "$module_name"
}


module_footer() {
	local module_name="$1"
	printf "************** %s\n" "$module"
}


module_wrapper() {
	"$1" run 2>&1 < /dev/null | tail -n "$MAX_LINES_PER_MODULE"
}


OUTPUT_FILE=
OUTPUT_DIRECTORY=
background="n"

while getopts "bBo:O:" opt; do
	case "$opt" in
		b)
			background="y"
			;;
		o)
			OUTPUT_FILE="$OPTARG"
			;;
		O)
			OUTPUT_DIRECTORY="$OPTARG"
			;;
		*)
			print_usage
			exit 1
	;;
	esac
done
shift "$((OPTIND - 1))"

if [ "$background" = "y" -a "$TURRIS_DIAGNOSTICS_IN_BACKGROUND" != "1" ]; then
	export TURRIS_DIAGNOSTICS_IN_BACKGROUND=1
	"$0" "$@" >/dev/null 2>&1 </dev/null &
	exit 0
fi

# Clean the last output files
if [ -n "$OUTPUT_FILE" ]; then
	rm -rf "$OUTPUT_FILE"
	rm -rf "$OUTPUT_FILE".preparing
elif [ -n "$OUTPUT_DIRECTORY" ]; then
	rm -rf "$OUTPUT_DIRECTORY" "$OUTPUT_DIRECTORY.preparing"
	mkdir -p "$OUTPUT_DIRECTORY.preparing" || {
		echo "Failed to created the log directory" >&2
		exit 1
	}
fi

# Print help if requested (this should ignore any module execution)
for arg in "$@"; do
	if [ "$arg" = "help" ]; then
		print_help
		exit 0
	fi
done


if [ $# = 0 ] ; then
	# no parameters run all modules
	for module in $ALL_MODULES; do
		module_run "$module"
	done
else
	for module_name in "$@"; do
		module="$(module_from_name "$module_name")"
		if ! module_exists "$module"; then
			printf "!!!!!!!!!!!!!! %s not found\n" "$module_name"
		else
			module_run "$module"
		fi
	done
fi


# rename the output directory when finished
if [ -n "$OUTPUT_DIRECTORY" ] ; then
	mv "$OUTPUT_DIRECTORY".preparing "$OUTPUT_DIRECTORY"
else
	# rename the output file when finished
	if [ -n "$OUTPUT_FILE" ] ; then
		mv "$OUTPUT_FILE".preparing "$OUTPUT_FILE"
	fi
fi
