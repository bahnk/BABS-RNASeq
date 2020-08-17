process mismatch_profile {

	input:
		tuple val(dict), file(bam)

	output:
		tuple val(dict), file("${name}.mismatch_profile*")

	script:		

		name = dict["name"]
		rough_read_length = dict["rough_read_length"]
		metrics_filename = name + ".mismatch_profile"

		template "rseqc/mismatch_profile.sh"
}
