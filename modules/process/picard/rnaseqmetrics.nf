process rnaseqmetrics {
	input:
		tuple val(dict), file(bam)

	output:
		tuple val(name), file("${name}.rnaseqmetrics")

	script:		

		name = dict["name"]
		metrics_filename = name + ".rnaseqmetrics"
		tmp_dirname = "tmp"

		/////////////////////////////////////////////////////////////////////////
		genome =
			params
				.genomes[params.genome_version][params.genome_release.toString()]
		rrna_interval_list = genome.rrna_interval_list
		refflat = genome.refflat


		template "picard/rnaseqmetrics.sh"
}
