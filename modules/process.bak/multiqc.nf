process multiqc {

	input:

		// cutadapt
		file("*") from cutadapt_log.map{x->x[1]}.collect()

		// fastqc
		file("*") from fastqc.collect()
		file("*") from fastqc_cutadapt.collect()

		// rsem
		file("*") from rsem_genome_indexed_multiqc.map{x->x[1]}.collect()
		file("*") from rsem_transcript.map{x->x[1]}.collect()
		file("*") from rsem_results.map{x->x[1]}.collect()
		file("*") from rsem_stat.map{x->x[1]}.collect()

		// picard
		file("*") from duplicates_stats.map{x->x[1]}.collect()
		file("*") from duplicates_bai_multiqc.map{x->x[1]}.collect()
		file("*") from complexity.map{x->x[1]}.collect()
		file("*") from rnaseqmetrics.map{x->x[1]}.collect()
		file("*") from multimetrics_metrics.map{x->x[1]}.collect()

		// rseqc
		file("*") from infer_experiment.map{x->x[1]}.collect()
		file("*") from junction_annotation.map{x->x[1]}.collect()
		file("*") from junction_saturation.map{x->x[1]}.collect()
		file("*") from mismatch_profile.map{x->x[1]}.collect()
		file("*") from read_distribution.map{x->x[1]}.collect()
		file("*") from transcript_integrity_number.map{x->x[1]}.collect()

		// rnaseqc
		file("*") from rnaseqc.map{x->x[1]}.collect()

		// pca
		file("*") from pca_json.collect()

	output:
		file "multiqc_data", emit: data
		file "multiqc_report.html", emit: report

	script:

		new_dict = dict.clone()

		multiqc_template = "custom"
		multiqc_conf = params.multiqc_conf

		template "multiqc.sh"
}
