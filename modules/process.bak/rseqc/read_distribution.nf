process read_distribution {

	input:
		tuple val(dict), file(bam)

	output:
		tuple val(new_dict), file("${name}.read_distribution*")
	
	script:

		new_dict = dict.clone()

		name = new_dict["name"]
		bed = params.bed
		metrics_filename = name + ".read_distribution"

		template "rseqc/read_distribution.sh"
}
