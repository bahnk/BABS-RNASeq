process read_length {

	input:
		tuple val(dict), file(fastq)

	output:
		tuple val(dict), stdout

	script:		
		
		name = dict["name"]

		if ( dict["is_single_end"] ) {

			fastq1 = fastq[0]

			template "read_length/single_end.sh"

		} else {

			fastq1 = fastq[0]
			fastq2 = fastq[1]

			template "read_length/paired_end.sh"
		}
}
