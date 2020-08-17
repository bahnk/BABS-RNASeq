process rnaseqmetrics {
	input:
		tuple val(dict), file(bam)

	output:
		set val(name), file("${name}.rnaseqmetrics") into rnaseqmetrics

	script:

		new_dict = dict.clone()

		tmp_dirname = "tmp"
		new_dict["name"]
		metrics_filename = name + ".rnaseqmetrics"
		rrna_interval_list = params.rrna_interval_list

		template "picard/rnaseqmetrics.sh"
}
