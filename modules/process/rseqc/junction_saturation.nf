process junction_saturation {

	input:
		tuple val(dict), file(bam)

	output:
		tuple val(dict), file("*.junction_saturation*")

	script:		

		name = dict["name"]
		metrics_filename = name + ".junction_saturation"

		genome =
			params
				.genomes[params.genome_version][params.genome_release.toString()]
		bed = genome.bed

		template "rseqc/junction_saturation.sh"
}
