process fastq {

	input:
		tuple val(dict), file(fastq)

	output:
		tuple val(new_dict), file("${name}_fastq_md5.txt")
	
	script:

		new_dict = dict.clone()
	
		files = fastq
		name = new_dict["name"]
		outfile = name + "_fastq_md5.txt"

		template "md5.sh"
}
