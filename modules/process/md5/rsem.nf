process rsem {

	input:
		tuple val(dict), file(results)

	output:
		tuple val(dict), file("${name}_rsem_md5.txt")
	
	script:		
	
		files = results
		name = dict["name"]
		outfile = name + "_rsem_md5.txt"

		template "md5.sh"
}
