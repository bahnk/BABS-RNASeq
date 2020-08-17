#!/bin/sh

cutadapt \
	-a $adapter \
	-o $output1 \
	-e 0.1 \
	-q 10 \
	-m 25 \
	-O 1 \
	$fastq1 > $logfile
