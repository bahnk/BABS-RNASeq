process rsem {

	input:
		tuple val(dict), file(fastq)

	output:
		tuple val(dict), file("*.transcript.bam"), emit: transcript
		tuple val(dict), file("*.stat"), emit: stat
		tuple val(dict), file("*.STAR.genome.bam"), emit: genome
		tuple val(dict), file("*.results"), emit: results

	script:		

		name = dict["name"]
		strandedness = params.strandedness
		cpus = task.cpus

		index =
			params
				.genomes[params.genome_version][params.genome_release.toString()]
				.rsem
				.rsem_star[ dict["rough_read_length"] + "bp" ]
				.index

		if ( dict["is_single_end"] ) {

			template "rsem/star/single_end.sh"

		} else {

			template "rsem/star/paired_end.sh"
		}
}
