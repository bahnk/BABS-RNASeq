process pca_to_json {

	label "r_analysis"

	input:
		file pca
		val r_script_dir
		val design_filepath

	output:
		file "rnaseq_pca.json"
	
	script:

		rda = pca
		json = "rnaseq_pca.json"

		"""
		Rscript ${r_script_dir}/pca_to_json.r \
			--rda ${rda} \
			--design ${design_filepath} \
			> ${json}
		"""
}
