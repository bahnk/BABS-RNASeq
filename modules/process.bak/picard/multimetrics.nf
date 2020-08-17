process multimetrics {

	input:
		tuple val(dict), file(bam)

	output:
		tuple val(new_dict), file("*.pdf"), emit: pdf
		tuple val(new_dict), file("*_metrics"), emit: metrics

	script:

		new_dict = dict.clone()

		tmp_dirname = "tmp"
		name = new_dict["name"]
		metrics_filename = name + ".multimetrics"
		fasta = params.fasta

		template "picard/multimetrics.sh"
}
