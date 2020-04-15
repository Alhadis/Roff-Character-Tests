#!/bin/sh
set -e

# Print bytes by decimal value
bytes(){
	case $1 in -h|--help|-\?|'')
		printf >&2 'Usage: bytes [0..255]\n'; [ "$1" ]
		return ;;
	esac
	printf %b "`printf \\\\%03o "$@"`"
}

# Strip trailing whitespace
trimend(){
	sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba'
}

# Determine if a character is allowed in a roff(7) macro name
# - Arguments: [byte-value] [command]
test_byte(){
	[ $# -gt 1 ] || set -- "$1" 'groff -Tutf8'
	set -- "$1" "$2" "`printf '.de X?\nUnsupported\n..'`"
	case $1 in 63) set -- "$1" "$2" . ;; esac
	printf "`cat <<-EOF
		.de X%b
		Supported
		..
		$3
		.de X
		Unsupported
		..
		.X%b
	EOF
	`\n" "`printf \\\\%03o "$1"`" "`printf \\\\%03o "$1"`" \
	| $2 | sed 's/ *() *()$//g; /^  *.*()$/d; /./!d' | trimend
}

printf '# Byte\tResult\tWarning   # vim\072ts=14\n'
for i in {0..255}; do
	j=`test_byte "$i" "$*" 2>&1`
	printf '%02X\t%s\t%s\n' "$i" \
		"`printf '%s' "$j" | tail -n1`" \
		"`printf '%s' "$j" | head -n1`" \
	| sed -e 's/\([UnSs]*upported\)\(.\)\1$/\1\2/g'
done
