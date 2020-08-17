process read_distribution {

	input:
		tuple val(dict), file(bam)

	output:
		tuple val(dict), file("${name}.read_distribution*")
	
	script:		

		name = dict["name"]
		metrics_filename = name + ".read_distribution"

		genome =
			params
				.genomes[params.genome_version][params.genome_release.toString()]
		bed = genome.bed

		template "rseqc/read_distribution.sh"
}
