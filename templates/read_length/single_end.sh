#!/bin/sh

zcat $fastq1 \
	| head -n 16 \
	| sed -n "2~4p" \
	| awk '{ print length }' \
	| sort \
	| uniq \
	| sed -n "1p" \
	> read_length_1.txt

if [[ \$(cat read_length_1.txt | wc -l) != "1" ]]
then
	echo "Problem: Read 1 and Read 2 doesn't have an unique length"
	exit 1
else
	cat read_length_1.txt | tr "\n" ""
fi

