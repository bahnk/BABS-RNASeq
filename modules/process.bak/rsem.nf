process rsem {

	input:
		tuple val(dict), file(fastq)

	output:
		tuple val(new_dict), file("*.transcript.bam"), emit: rsem_transcript
		tuple val(new_dict), file("*.stat"), emit: rsem_stat
		tuple val(new_dict), file("*.STAR.genome.bam"), emit: rsem_genome
		tuple val(new_dict), file("*.results"), emit: rsem_results

	script:

		new_dict = dict.clone()

		name = new_dict["name"]
		strandedness = params.strandedness
		cpus = task.cpus

		index =
			params
				.genomes[params.genome_version][params.genome_release.toString()]
				.rsem
				.rsem_star[ new_dict["rough_read_length"] + "bp" ]
				.index

		if ( new_dict["is_single_end"] ) {

			template "rsem/star/single_end.sh"

		} else {

			template "rsem/star/paired_end.sh"
		}
}
