process junction_saturation {

	input:
		tuple val(dict), file(bam)

	output:
		tuple val(new_dict), file("*.junction_saturation*")

	script:

		new_dict = dict.clone()

		name = new_dict["name"]
		bed = params.bed
		metrics_filename = name + ".junction_saturation"

		template "rseqc/junction_saturation.sh"
}
