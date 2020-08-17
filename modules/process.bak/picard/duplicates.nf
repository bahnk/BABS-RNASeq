process duplicates {

	input:
		tuple val(dict), file(bam)

	output:
		set val(new_dict), file("${name}.marked_duplicates"), emit: metrics
		set val(new_dict), file("${name}.dupmarked.bam"), emit: bam

	script:

		new_dict = dict.clone()

		tmp_dirname = "tmp"
		name = new_dict["name"]
		filename = name + ".dupmarked.bam"
		metrics_filename = name + ".marked_duplicates"

		template "picard/duplicates.sh"
}
