process multiqc {

	label "unique_process"

	input:

		file cutadapt
		file fastqc
		file rsem

		// picard
		file duplicates
		file complexity
		file rnaseqmetrics
		file multimetrics

		// rseqc
		file infer_experiment
		file junction_annotation
		file junction_saturation
		file mismatch_profile
		file read_distribution
		file transcript_integrity_number

		// rnaseqc
		//file rnaseqc

		// pca
		file pca_json

		val multiqc_conf

	output:
		path "multiqc_data", emit: data
		path "multiqc_report.html", emit: report

	script:		

		multiqc_template = "custom"

		template "multiqc.sh"
}
