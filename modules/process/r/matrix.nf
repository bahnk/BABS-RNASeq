process matrix {

	label "r_analysis"

	input:
		path results 
		val r_script_dir
		val design_filepath
	
	output:
		path "${output_name}.rda", emit: rda
		path "${output_name}.csv", emit: csv
	
	shell:

		gtf = 
			params
				.genomes[params.genome_version][params.genome_release.toString()]
				.gtf

		output_name = "matrix"

		"""
		Rscript ${r_script_dir}/matrix.r \
			--results-dir . \
			--design-file ${design_filepath} \
			--gtf-file ${gtf} \
			--output-name ${output_name}
		"""
}
