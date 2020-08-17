process index {

	input:
		tuple val(dict), file(bam)

	output:
		tuple \
			val(dict),
			file("${name}.dupmarked.bam"),
			file("${name}.dupmarked.bam.bai")

	script:		

		name = dict["name"]

		template "samtools/index.sh"
}
