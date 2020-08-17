process insert_size {

	input:
		tuple val(dict), file(bam)

	output:
		tuple val(dict), file("${name}_insert_size.txt")
	
	script:		
	
		name = dict["name"]
		outfile = name + "_insert_size.txt"

		template "insert_size.sh"
}
