process vst {

	label "r_analysis"

	input:
		file dds
		val r_script_dir
	
	output:
		file "vst.rda"
	
	script:
		
		rda_in = dds
		rda_out = "vst.rda"

		"""
		Rscript ${r_script_dir}/vst.r ${rda_in} ${rda_out}
		"""
}
