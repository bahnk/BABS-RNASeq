process rnaseqc {

	input:
		tuple val(dict), file(bam), file(bai)

	output:
		tuple val(new_dict), file("*rnaseqc*")

	script:

		new_dict = dict.clone()

		rrna_list = params.rrna_list
		fasta = params.fasta
		rnaseqc_gtf = params.rnaseqc_gtf
		name = new_dict["name"]
		metrics_filename = name + ".rnaseqc"

		if (new_dict["is_single_end"]) {

			template "rnaseqc/single_end.sh"

		} else {

			template "rnaseqc/paired_end.sh"
		}
}
