process complexity {

	input:
		tuple val(dict), file(bam)

	output:
		tuple val(dict), file("${name}.complexity")

	script:		

		name = dict["name"]
		metrics_filename = name + ".complexity"
		tmp_dirname = "tmp"

		template "picard/complexity.sh"
}
