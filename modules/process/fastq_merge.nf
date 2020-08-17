process fastq_merge {

	input:
		val dict 

	output:
		tuple val(dict), file("${name}_R*.fastq.gz")

	script:		
		
		name = dict["name"]

		if ( dict["is_single_end"] ) {

			fastqs1 = dict["fastq_files"]["R1"].join(" ")

			template "fastq_merge/single_end.sh"

		} else {

			fastqs1 = dict["fastq_files"]["R1"].join(" ")
			fastqs2 = dict["fastq_files"]["R2"].join(" ")

			template "fastq_merge/paired_end.sh"
		}
}
