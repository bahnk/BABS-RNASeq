process infer_experiment {

	input:
		tuple val(dict), file(bam)
	
	output:
		tuple val(dict), file("${name}.infer_experiment*")
	
	script:		

		name = dict["name"]
		metrics_filename = name + ".infer_experiment"

		genome =
			params
				.genomes[params.genome_version][params.genome_release.toString()]
		bed = genome.bed

		template "rseqc/infer_experiment.sh"
}
