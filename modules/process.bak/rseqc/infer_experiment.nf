process infer_experiment {

	input:
		tuple val(dict), file(bam)
	
	output:
		tuple val(new_dict), file("${name}.infer_experiment*")
	
	script:

		new_dict = dict.clone()

		name = new_dict["name"]
		bed = params.bed
		metrics_filename = name + ".infer_experiment"

		template "rseqc/infer_experiment.sh"
}
