process duplicates {

	input:
		tuple val(dict), file(bam)

	output:
		tuple val(dict), file("${name}.marked_duplicates"), emit: metrics
		tuple val(dict), file("${name}.dupmarked.bam"), emit: bam

	script:		

		name = dict["name"]
		filename = name + ".dupmarked.bam"
		metrics_filename = name + ".marked_duplicates"
		tmp_dirname = "tmp"

		template "picard/duplicates.sh"
}
