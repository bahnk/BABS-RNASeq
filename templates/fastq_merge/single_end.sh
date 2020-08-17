#!/bin/sh

zcat $fastqs1 | gzip -c > "${name}_R1.fastq.gz"

