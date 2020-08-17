process index {

	input:
		tuple val(dict), file(bam)

	output:
		tuple \
			val(new_dict),
			file("${name}.dupmarked.bam"),
			file("${name}.dupmarked.bam.bai")

	script:

		new_dict = dict.clone()

		name = new_dict["name"]

		template "samtools/index.sh"
}
