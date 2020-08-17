process group {

	input:
		tuple val(dict), file(bam), file(bai)

	output:
		tuple val(dict), file("${name}.rg.bam")

	script:		

		name = dict["name"]
		filename = dict["name"] + ".rg.bam"
		tmp_dirname = "tmp"

		template "picard/group.sh"

}
