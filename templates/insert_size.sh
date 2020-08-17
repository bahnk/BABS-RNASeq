#!/bin/sh

samtools stats "$bam" \
	| grep "insert size " \
	| sed --expression "s/SN/$name/" \
	| awk \
		-v FS='\t' \
		-v OFS='\t' 'NR % 2 == 1 { o=\$0 ; next } { print o , \$3 }' \
	> "$outfile"

