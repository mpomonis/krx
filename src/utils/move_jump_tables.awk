#!/usr/bin/awk -f

BEGIN {
	# the caller set the value of `outname'
	jmp = 0
	# erase file from previous compilation
	print "" > outname
}
{
	if (jmp == 1) {
		if (match($0, /^[ \t]*\.section[ \t]+\.rodata/)) {
			line = $0
			gsub(/\.rodata/, ".jmp_tbls, \"a\"", line)
			print line >> outname
			next;
		}

		jmp = 0
	}

	if (match($0, /^[ \t]*jmp[ \t]*\*\.L.+\(,/)) {
		jmp = 1
	}
	# log line from file
	print $0 >> outname
}
END {
}
