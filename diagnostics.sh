#!/bin/sh

# set proper gettext domain
export TEXTDOMAIN=turris-diagnostics
export TEXTDOMAINDIR=/usr/share/locale

MAX_LINES_PER_MODULE=${MAX_LINES_PER_MODULE:-100000}

# enter the script directory
cd "$(dirname $0)"

ALL_MODULES=./modules/*.module

module_name_exists() {
	[ -x "./modules/$1.module" ]
}

module_name() {
	basename "${1%.module}"
}


module_help() {
	for module in $ALL_MODULES; do
		printf "  %s\n" "$(module_name "$module")"
		"$module" help | sed 's/^/    /'
		echo
	done
}

print_help() {
	echo "$(basename $0) [-b] [-o <file> | -O <file>] [module1[ module2[...]]]"
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


if [ "$1" = "-b" ] ; then
	shift
	"$0" "$@" >/dev/null 2>&1 &
	exit 0
fi

if [ "$1" = "-o" ] ; then
	shift
	OUTPUT_FILE="$1"
	# clean the last output files
	rm -rf "$OUTPUT_FILE"
	rm -rf "$OUTPUT_FILE".preparing
	shift
fi

if [ "$1" = "-O" ] ; then
	shift
	OUTPUT_DIRECTORY="$1"
	rm -rf "$OUTPUT_DIRECTORY" "$OUTPUT_DIRECTORY.preparing"
	mkdir -p "$OUTPUT_DIRECTORY.preparing" || ( echo "Failed to created the log directory" && exit 1 )
	shift
fi

if [ "$1" = help ] ; then
	print_help
	exit 0
fi

if [ $# = 0 ] ; then
	# no parameters run all modules
	for module in $ALL_MODULES; do
		module_run "$module"
	done
else
	for module_name in "$@"; do
		if ! module_name_exists "$module_name"; then
			printf "!!!!!!!!!!!!!! %s not found\n" "$module_name"
		else
			module_run "./modules/$module_name.module"
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
