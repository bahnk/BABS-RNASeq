process group {

	input:
		tuple val(dict), file(bam), file(bai)

	output:
		tuple val(new_dict), file("${name}.rg.bam")

	script:

		new_dict = dict.clone()

		tmp_dirname = "tmp"
		filename = new_dict["name"] + ".rg.bam"

		template "picard/group.sh"

}
