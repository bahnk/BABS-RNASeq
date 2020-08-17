process fastq {

	input:
		tuple val(dict), file(fastq)

	output:
		tuple val(dict), file("${name}_fastq_md5.txt")
	
	script:		
	
		files = fastq
		name = dict["name"]
		outfile = name + "_fastq_md5.txt"

		template "md5.sh"
}
