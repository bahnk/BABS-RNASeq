process dds {

	label "r_analysis"

	input:
		file se
		val r_script_dir
	
	output:
		path "dds.rda"
	
	script:
		
		rda_in = se
		rda_out = "dds.rda"

		"""
		Rscript ${r_script_dir}/dds.r \
			--rda-se ${rda_in} \
			--formula "~ 1" \
			--ncores ${task.cpus} \
			--rda-out ${rda_out}
		"""
}
