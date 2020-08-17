process rlog {

	label "r_analysis"

	input:
		file dds
		val r_script_dir
	
	output:
		file "rlog.rda"
	
	script:
		
		rda_in = dds
		rda_out = "rlog.rda"

		"""
		Rscript ${r_script_dir}/rlog.r ${rda_in} ${rda_out}
		"""
}
