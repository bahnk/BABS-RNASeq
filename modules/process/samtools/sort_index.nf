process sort_index {

	input:
		tuple val(dict), file(bam)

	output:
		tuple \
			val(dict),
			file("${name}.sorted.bam"),
			file("${name}.sorted.bam.bai")

	script:		

		name = dict["name"]
		filename = name + ".sorted.bam"
		cpus = task.cpus

		template "samtools/sort_index.sh"
}
