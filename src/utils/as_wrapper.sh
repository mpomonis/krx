#!/bin/bash

array=( "$@" )
for (( i=0; i<$#; i++ ));
do
	if [[ "${array[$i]}" == "-o" ]]; then
		outname=$((i+1))
		eof=$((i+2))
		if [[ "${array[$outname]}" == *"/realmode/"* 		|| \
				 "${array[$outname]}" == *"/scripts/"* 	|| \
				 "${array[$outname]}" == *"/vdso/"* 	|| \
				 "${array[$outname]}" == *"/boot/"* 	|| \
				 "${array[$outname]}" == *"init/version.o" ]];
		then
			/usr/bin/as.old "${array[@]}"
			exit
		fi

		# if this is asm, then the last argument 
		# should be a file at $i+2,
		# otherwise there should be no $i+2
		if [[ "$#" != "$eof" && "${array[$eof]}" != "-" ]];
		then
			/usr/bin/as.old "${array[@]}"
			exit
		else
			# compiled C code is passed to the assembler
			# through a pipe. Read and store it to a file
			# in /tmp, then add/remove any instrumentation
			# from it
			asmfile="/tmp/$(echo ${array[$outname]} | \
							sed -e 's/\//_/g')_2"
			/usr/bin/awk -v outname="$asmfile" 		\
					-f /home/w00t/move_jump_tables.awk -
			array[$eof]="$asmfile"
			/usr/bin/as.old "${array[@]}"
			rm "$asmfile"
			exit
		fi
	fi
done
#shouldn't be used
/usr/bin/as.old "${array[@]}"
