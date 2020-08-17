process rnaseqc {

	input:
		tuple val(dict), file(bam), file(bai)

	output:
		tuple val(dict), file("${name}.rnaseqc")

	script:		

		name = dict["name"]
		metrics_filename = name + ".rnaseqc"

		/////////////////////////////////////////////////////////////////////////
		genome =
			params
				.genomes[params.genome_version][params.genome_release.toString()]

		rrna_list = genome.rrna_list
		fasta = genome.fasta
		rnaseqc_gtf = genome.rnaseqc_gtf


		if (dict["is_single_end"]) {

			template "rnaseqc/single_end.sh"

		} else {

			template "rnaseqc/paired_end.sh"
		}
}
