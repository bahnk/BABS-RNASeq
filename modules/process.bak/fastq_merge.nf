process fastq_merge {

	input:
		val dict 

	output:
		tuple val(new_dict), file("${name}_R*.fastq.gz")

	script:

		new_dict = dict.clone()
		
		name = new_dict["name"]

		if ( new_dict["is_single_end"] ) {

			fastqs1 = new_dict["fastq_files"]["R1"].join(" ")

			template "fastq_merge/single_end.sh"

		} else {

			fastqs1 = new_dict["fastq_files"]["R1"].join(" ")
			fastqs2 = new_dict["fastq_files"]["R2"].join(" ")

			template "fastq_merge/paired_end.sh"
		}
}
