process multimetrics {

	input:
		tuple val(dict), file(bam)

	output:
		tuple val(dict), file("*.pdf"), emit: pdf
		tuple val(dict), file("*_metrics"), emit: metrics

	script:		

		name = dict["name"]
		metrics_filename = name + ".multimetrics"
		tmp_dirname = "tmp"

		/////////////////////////////////////////////////////////////////////////
		genome =
			params
				.genomes[params.genome_version][params.genome_release.toString()]
		fasta = genome.fasta

		template "picard/multimetrics.sh"
}
