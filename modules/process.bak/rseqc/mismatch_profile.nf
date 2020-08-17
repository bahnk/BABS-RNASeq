process mismatch_profile {

	input:
		tuple val(dict), file(bam)

	output:
		tuple val(new_dict), file("${name}.mismatch_profile*")

	script:

		new_dict = dict.clone()

		name = new_dict["name"]
		rough_read_length = new_dict["rough_read_length"]
		metrics_filename = name + ".mismatch_profile"

		template "rseqc/mismatch_profile.sh"
}
