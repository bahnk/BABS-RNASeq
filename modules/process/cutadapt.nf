process cutadapt {

	input:
		tuple val(dict), file(fastq)

	output:
		tuple val(dict), file('*.cutadapt.fastq.gz'), emit: fastq
		tuple val(dict), file('*.log'), emit: log
	
	script:
	
		name = dict["name"]
		adapter = "AGATCGGAAGAGC"

		if ( dict["is_single_end"] ) {

			fastq1 = fastq[0]
			output1 = name + "_R1" + ".cutadapt.fastq.gz"
			logfile = name + ".log"

			template "cutadapt/single_end.sh"

		} else {

			fastq1 = fastq[0]
			fastq2 = fastq[1]

			output1 = name + "_R1" + ".cutadapt.fastq.gz"
			output2 = name + "_R2" + ".cutadapt.fastq.gz"

			logfile = name + ".log"

			template "cutadapt/paired_end.sh"
		}
}
