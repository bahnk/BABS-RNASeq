#!/bin/sh

zcat $fastqs1 | gzip -c > "${name}_R1.fastq.gz"
zcat $fastqs2 | gzip -c > "${name}_R2.fastq.gz"

