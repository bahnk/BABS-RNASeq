process junction_annotation {

	input:
		tuple val(dict), file(bam)

	output:
		tuple val(new_dict), file("${name}.junction_annotation*")
	
	script:

		new_dict = dict.clone()

		name = new_dict["name"]
		bed = params.bed
		metrics_filename = name + ".junction_annotation"

		template "rseqc/junction_annotation.sh"
}
