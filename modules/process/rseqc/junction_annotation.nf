process junction_annotation {

	input:
		tuple val(dict), file(bam)

	output:
		tuple val(dict), file("${name}.junction_annotation*")
	
	script:		

		name = dict["name"]
		metrics_filename = name + ".junction_annotation"

		genome =
			params
				.genomes[params.genome_version][params.genome_release.toString()]
		bed = genome.bed

		template "rseqc/junction_annotation.sh"
}
