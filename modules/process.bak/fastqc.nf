process fastqc {

	input:
		tuple val(dict), file(fastq)

	output:
		tuple val(new_dict), file("*fastqc*")
	
	script:
	
		new_dict = dict.clone()
		name = new_dict["name"]

		if ( new_dict["is_single_end"] ) {

			fastq1 = fastq[0]

			template "fastqc/single_end.sh"

		} else {

			fastq1 = fastq[0]
			fastq2 = fastq[1]

			template "fastqc/paired_end.sh"
		}
}
