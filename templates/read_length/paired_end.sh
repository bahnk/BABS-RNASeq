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
	echo "Problem: Read 1 doesn't have an unique length"
	exit 1
fi

zcat $fastq2 \
	| head -n 16 \
	| sed -n "2~4p" \
	| awk '{ print length }' \
	| sort \
	| uniq \
	| sed -n "1p" \
	> read_length_2.txt

if [[ \$(cat read_length_2.txt | wc -l) != "1" ]]
then
	echo "Problem: Read 2 doesn't have an unique length"
	exit 1
fi

###############################################################################

if [[ \$(diff read_length_1.txt read_length_2.txt | wc -l) == "0" ]]
then
	cat read_length_1.txt | tr -d "\\n"
else
	echo "Problem: Read 1 and Read 2 don't have the same length"
	exit 1
fi

