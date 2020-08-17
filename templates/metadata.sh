#!/bin/sh

echo "genome: " > $outfile
echo "  version: " $genome_version >> $outfile
echo "  release: " $genome_release >> $outfile
#echo "  genome: " $genome >> $outfile
echo "  fasta: " $fasta >> $outfile
echo "annotation: " >> $outfile
echo "  gtf: " $gtf >> $outfile
echo "  bed: " $bed >> $outfile
echo "  refflat: " $refflat >> $outfile
echo "  rrna_list: " $rrna_list >> $outfile
echo "  rrna_interval_list: " $rrna_interval_list >> $outfile
echo "  rnaseqc_gtf: " $rnaseqc_gtf >> $outfile
echo "  index: " $index  >> $outfile

awk \
	'BEGIN{print "raw_md5: "}{print "  - name: "\$2"\\n    md5: "\$1}' \
	"$fastq_md5" >> $outfile

awk \
	'BEGIN{print "processed_md5: "}{print "  - name: "\$2"\\n    md5: "\$1}' \
	"$rsem_md5" >> $outfile

awk \
	-F '\t' 'BEGIN{print "insert: "}{print "  - name: "\$1"\\n    average: "\$3"\\n    sd: "\$4}' \
	"$insert_size" >> $outfile

