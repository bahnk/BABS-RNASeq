process metadata {

	input:
		tuple val(fastq_dict), file(fastq_md5)
		tuple val(rsem_dict), file(rsem_md5)
		tuple val(insert_size_dict), file(insert_size)

	output:
		tuple val(new_dict), file("$outfile")

	script:

		new_dict = insert_size_dict.clone()

		outfile = new_dict["name"] + "_metadata.txt"

		/////////////////////////////////////////////////////////////////////////
		genome =
			params
				.genomes[params.genome_version][params.genome_release.toString()]

		genome_version = params.genome_version
		genome_release = params.genome_release.toString()
		fasta = genome.fasta
		gtf = genome.gtf
		bed = genome.bed
		refflat = genome.refflat
		rrna_list = genome.rrna_list
		rrna_interval_list = genome.rrna_interval_list
		rnaseqc_gtf = genome.rnaseqc_gtf
		index =
			genome
				.rsem
				.rsem_star[ new_dict["rough_read_length"] + "bp" ]
				.index

		template "metadata.sh"
 }
