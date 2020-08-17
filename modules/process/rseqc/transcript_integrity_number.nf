process transcript_integrity_number {

	input:
		tuple val(dict), file(bam), file(bai)

	output:
		tuple val(dict), file("*.{xls,txt}")

	script:		

		name = dict["name"]

		genome =
			params
				.genomes[params.genome_version][params.genome_release.toString()]
		bed = genome.bed

		template "rseqc/transcript_integrity_number.sh"
}
