/*
 * nourdine.bah@crick.ac.uk
 */

/*
 * vim: syntax=groovy
 * -*- mode: groovy;-*-
 */

package asf

import java.io.File
import java.lang.StringBuffer
import java.text.SimpleDateFormat

import sun.nio.fs.UnixPath

import groovy.transform.Canonical
import groovy.transform.Sortable
import groovy.transform.CompileStatic
import groovy.transform.EqualsAndHashCode

@Canonical
@Sortable(includes="label")
@EqualsAndHashCode(includes="basename")
class Fastq {

	////////////////////////////////////////////////////////////////////////////
	// attributes

	String sample_name
	File file
	String path
	String filename
	String basename

	// from filename
	String lims_id
	String sample_number
	Lane lane
	String pair
	Read read
	String label
	String illumina_legacy

	// from parent directory
	String project_id

	// from grand grand parent directory
	Machine machine
	Run run
	FlowCell flow_cell
	//Date date
	String date

	// additional attributes
	Integer read_length
	Integer rough_read_length
	String species
	String sequencing_type
	Map factors
	////////////////////////////////////////////////////////////////////////////

	Fastq(String path, String name, String type, String species, Map factors) {

		// the fastq file
		this.sample_name = name
		this.path = path
		this.file = new File(path)


		/////////////////////////////////////////////////////////////////////////
		// parsing path in order to get information

		this.filename = this.file.getName()
		this.basename = this.filename.replace(".fastq.gz", "")

		// info from the filename
		//List<String> fastq_info = this.basename.split("_")
		String[] fastq_info = this.basename.split("_")
		this.lims_id = fastq_info[0]
		this.sample_number = fastq_info[1]
		this.lane = new Lane( fastq_info[2] )
		this.pair = [
			this.lims_id,
			this.sample_number,
			this.lane.getNumber()
			].join("_")
		this.read = new Read( fastq_info[3] )
		this.label = [
			this.lims_id,
			this.sample_number,
			this.lane.getNumber(),
			this.read.getNumber()
			].join("_")
		this.illumina_legacy = fastq_info[4]

		// info from the parent directory
		File parent_dir = new File( this.file.getParent() )
		this.project_id = parent_dir.getName()

		// info from the grand grand parent directory
		File gg_parent_dir = parent_dir.getParentFile().getParentFile()
		//List<String> flow_cell_info = gg_parent_dir.getName().split("_")
		String[] flow_cell_info = gg_parent_dir.getName().split("_")
		this.machine = new Machine( flow_cell_info[1] )
		this.run = new Run( flow_cell_info[2] )
		this.flow_cell = new FlowCell( flow_cell_info[3] )
		//SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd")
		//this.date = sdf.parse( "20" + flow_cell_info[0] )
		this.date = "20" + flow_cell_info[0]
		/////////////////////////////////////////////////////////////////////////

		this.species = species
		this.sequencing_type = type
		this.factors = factors

		// default
		this.read_length = -1
		this.rough_read_length = -1
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * stringify
	 */
	String toString() {
		String str = 
			this.date +
			"_" + this.machine.toString() + 
			"_" + this.run.toString() +
			"_" + this.flow_cell +
			"_" + this.basename
		return str
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * checks if the fastq file corresponds to the second read of the pair
	 */
	boolean isRead2() {
		return this.getRead().getNumber() == "R2"
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * checks if the fastq passed as an argument is paired with this fastq
	 */
	boolean isPairedWith(Fastq fastq) {

		if (

			this.getLimsId() == fastq.getLimsId() &&
			this.getSampleNumber() == fastq.getSampleNumber() &&
			this.getLane() == fastq.getLane() &&
			this.getIlluminaLegacy() == fastq.getIlluminaLegacy() &&
			this.getRead() != fastq.getRead()

			) {

			return true

		} else {

			return false
		}
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * add the read length
	 */
	Fastq addReadLength(Integer read_length) {
		this.read_length = read_length
		this.rough_read_length = this.determineRoughReadLength(this.read_length)
		return this
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * determines the rough length required to choose the star index
	 */
	Integer determineRoughReadLength(Integer read_length) {

		// three babs star indices have been built with these read length
		// parameters
		List<Integer> starIndexReadLengths = [50, 75, 100, 150]
	
		// take the index with the closest read length to the experiment's
		List<Integer> diffs = []

		starIndexReadLengths.each() { length ->
			Integer diff = (length - read_length).abs()
			diffs.add(diff)
		}
		Integer index = diffs.findIndexValues() { i -> i == diffs.min() }[0]
		Integer rough_read_length = starIndexReadLengths[index.toInteger()]

		return rough_read_length
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * a map representing the Fastq
	 */
	 Map getDict() {

	    Map m = [:]

		 m["sample_name"] = this.sample_name
		 m["file"] = this.file
		 m["path"] = this.path
		 m["basename"] = this.basename
		 m["lims_id"] = this.lims_id
		 m["sample_number"] = this.sample_number
		 m["pair"] = this.pair
		 m["read"] = this.read.getNumber()
		 m["label"] = this.label
		 m["illumina_legacy"] = this.illumina_legacy
		 m["project_id"] = this.project_id
		 m["machine"] = this.machine.getName()
		 m["run"] = this.run.getNumber()
		 m["flow_cell"] = this.flow_cell.getName()
		 m["date"] = this.date
		 m["read_length"] = this.read_length
		 m["rough_read_length"] = this.rough_read_length
		 m["species"] = this.species
		 m["sequencing_type"] = this.sequencing_type
		 m["factors"] = this.factors

		return m
	 }
	////////////////////////////////////////////////////////////////////////////
}
