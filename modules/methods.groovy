
/*
 * nourdine.bah@crick.ac.uk
 */

import java.nio.file.Paths

///////////////////////////
def absolute_path(path) {//
///////////////////////////

	def f = new File(path)

	if ( ! f.isAbsolute() ) {
		return Paths.get(workflow.projectDir.toString(), path).toString()
	} else {
		return path
	}
}

//////////////////////////////////
def addValue(dict, value, key) {//
//////////////////////////////////
	dict.put(key, value)
	return [ dict , value ]
}

//////////////////////////////////
def addFiles(dict, value, key) {//
//////////////////////////////////

	// test if it is a list of files
	def exist = value.collect{ new File(it.toString()).exists() ? 0 : 1 }.sum()

	if ( exist == 0 ) {

		def sorted_value = value.sort{ it.getFileName() }
		dict.put(key, sorted_value)

		return [ dict , sorted_value ]

	} else {

		dict.put(key, value)

		return [ dict , value ]
	}
}

/////////////////////////////////////
def addIndex(dict, bam, bai, key) {//
/////////////////////////////////////
	dict.put(key, [bam , bai])
	return [ dict , bam , bai ]
}

//////////////////////////
def rrlen(read_length) {//
//////////////////////////

	/* return rough read length for STAR */
	
	// three babs star indices have been built with these read length parameters
	def starIndexReadLengths = [50, 75, 100]
	
	// take the index with the closest read length to the experiment's
	def diffs = []
	starIndexReadLengths.each() { length ->
		diff = (length - read_length.toInteger()).abs()
		diffs.add(diff)
	}
	def index = diffs.findIndexValues() { i -> i == diffs.min() }[0]
	def rough_read_length = starIndexReadLengths[index.toInteger()]

	return rough_read_length
}

