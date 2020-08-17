process complexity {

	input:
		tuple val(dict), file(bam)

	output:
		tuple val(new_dict), file("${name}.complexity")

	script:

		new_dict = dict.clone()

		tmp_dirname = "tmp"
		name = new_dict["name"]
		metrics_filename = name + ".complexity"

		template "picard/complexity.sh"
}
