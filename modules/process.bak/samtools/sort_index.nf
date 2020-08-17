process sort_index {

	input:
		tuple val(dict), file(bam)

	output:
		tuple \
			val(new_dict),
			file("${name}.sorted.bam"),
			file("${name}.sorted.bam.bai")

	script:

		new_dict = dict.clone()

		name = new_dict["name"]
		filename = name + ".sorted.bam"
		cpus = task.cpus

		template "samtools/sort_index.sh"
}
