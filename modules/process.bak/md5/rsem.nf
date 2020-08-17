process rsem {

	input:
		tuple val(dict), file(results)

	output:
		tuple val(new_dict), file("${name}_rsem_md5.txt")
	
	script:

		new_dict = dict.clone()
	
		files = results
		name = new_dict["name"]
		outfile = name + "_rsem_md5.txt"

		template "md5.sh"
}
