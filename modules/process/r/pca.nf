process pca {

	label "r_analysis"

	input:
		file rda
		val r_script_dir

	output:
		file "pca.rda"
	
	script:

		rda_in = rda
		rda_out = "pca.rda"

		"""
		Rscript ${r_script_dir}/pca.r ${rda_in} ${rda_out}
		"""
}
