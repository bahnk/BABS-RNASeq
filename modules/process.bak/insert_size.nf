process insert_size {

	input:
		tuple val(dict), file(bam)

	output:
		tuple val(new_dict), file("${name}_insert_size.txt")
	
	script:

		new_dict = dict.clone()
	
		name = new_dict["name"]
		outfile = name + "_insert_size.txt"

		template "insert_size.sh"
}
