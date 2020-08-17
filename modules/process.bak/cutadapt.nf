process cutadapt {

	input:
		tuple val(dict), file(fastq)

	output:
		tuple val(new_dict), file('*.cutadapt.fastq.gz'), emit: fastq
		tuple val(new_dict), file('*.log'), emit: log
	
	script:
	
		new_dict = dict.clone()
		name = new_dict["name"]
		adapter = "AGATCGGAAGAGC"

		if ( new_dict["is_single_end"] ) {

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
