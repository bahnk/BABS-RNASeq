process transcript_integrity_number {

	input:
		tuple val(dict), file(bam)

	output:
		tuple val(new_dict), file("*.{xls,txt}")

	script:

		new_dict = dict.clone()

		name = new_dict["name"]
		bed = params.bed

		template "rseqc/transcript_integrity_number.sh"
}
