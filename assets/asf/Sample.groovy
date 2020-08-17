/*
 * nourdine.bah@crick.ac.uk
 */

/*
 * vim: syntax=groovy
 * -*- mode: groovy;-*-
 */

package asf

import asf.Fastq

import groovy.transform.ToString
import groovy.transform.EqualsAndHashCode
import groovy.transform.Sortable
import groovy.transform.AutoClone

@ToString
@EqualsAndHashCode(includes="lims_id")
@Sortable(includes="lims_id")
@AutoClone
class Sample {

	// attributes
	String name
	String lims_id
	Set<String> sample_numbers = []
	Set<Fastq> fastq_files
	Map metrics = [:]

	// constructor
	Sample(Fastq fastq_file) {
		this.name = fastq_file.getSample_name()
		this.lims_id = fastq_file.getLims_id()
		this.sample_numbers.add( fastq_file.getSample_number() )
		this.fastq_files = [fastq_file].toSet()
	}

	// operator overloading
	Sample plus(Object o) {
		if ( o instanceof Sample && this == o ) {
			Sample sample = this.clone()
			sample.setFastq_files( sample.getFastq_files() + o.getFastq_files() )
			sample.setSample_numbers(
				sample.getSample_numbers() + o.getSample_numbers()
				)
			return sample
		} else {
			return null
		}
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * stringify
	 */
	 String toString() {
		 return this.fastq_files
	 }

	////////////////////////////////////////////////////////////////////////////
	/*
	 * checks if this sample is single-end
	 */
	boolean isSingleEnd() {

		List<Integer> is_read_2 = []

		this.fastq_files.each{ fastq ->
			is_read_2.add( fastq.isRead2() ? 1 : 0 )
		}

		if ( is_read_2.sum() > 0 ) {
			return false
		} else {
			return true
		}
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * gets the project id based on the fastqs contained in this sample
	 */
	String getProjectId() {

		HashSet<String> project_ids = new HashSet<String>()
		this.fastq_files.each{ project_ids.add( it.getProject_id() ) }

		if ( project_ids.size() != 1 ) {
			throw new Exception("There are several project IDs in one Sample")
		} else {
			return project_ids.toList()[0]
		}
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * gets the list of the fastqs contained in this sample
	 */
	List<Fastq> getFastq() {
		return this.fastq_files.toList().sort()
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * gets the list of the fastqs contained in this sample with the name of
	 * this sample
	 */
	List<Object> getFastqWithName() {

		List<Object> l = []

		this.getFastq().each{
			l.add( [ it.getLabel() , it ] )
		}

		return l

	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * gets the list of the paired fastqs contained in this sample
	 */
	List< List<Fastq> > getPairedFastq() {
		return this
					.fastq_files
					.toList()
					.groupBy{ it.getPair() }
					.collect{ k, v -> v.sort() }
					.sort()
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * gets the list of the paired fastqs path contained in this sample
	 */
	Map< String , List<String> > getPairedFastqPath() {
		
		List<String> read1 = []
		List<String> read2 = []

		List< List<Fastq> > paired_fastq = this.getPairedFastq()

		for ( pair in paired_fastq ) {
			read1.add( pair[0].getPath() )
			if ( pair.size() == 2 ) {
				read2.add( pair[1].getPath() )
			}
		}

		return ["R1": read1, "R2": read2]
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * gets the list of the paired fastqs contained in this sample with the name
	 * of this sample
	 */
	List<Fastq> getPairedFastqWithName() {

		List<Object> paired_fastq_files = this.getPairedFastq()

		List<Object> l = []

		paired_fastq_files.each{
			l.add( [ it[0].getPair() , it ] )
		}

		return l
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * extracts the species, which is supposed to be unique, from the fastq
	 * files
	 */
	String extractSpecies() {

		List<String> speciesS = []

		this.fastq_files.each{
			speciesS.add( it.getSpecies() )
		}

		List<String> species = speciesS.toSet().toList()

		// a unique species per sample
		if ( species.size() > 1 ) {

			String msg =
				"Error: the sample " + this.lims_id + " has more than one species"
			println(msg)
			System.exit(1)

		} else {

			return species[0]
		}
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * extracts the sequencing, which is supposed to be unique, from the fastq
	 * files
	 */
	String extractSequencingType() {

		List<String> sequencing_types = []

		this.fastq_files.each{
			sequencing_types.add( it.getSequencing_type() )
		}

		List<String> sequencing_type = sequencing_types.toSet().toList()

		// a unique species per sample
		if ( sequencing_type.size() > 1 ) {

			String msg =
				"Error: the sample " + this.lims_id +
					" has more than one read length"
			println(msg)
			System.exit(1)

		} else {

			return sequencing_type[0]
		}
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * extracts the species, which is supposed to be unique, from the fastq
	 * files
	 */
	String extractRoughReadLength() {

		List<String> lengths = []

		this.fastq_files.each{
			lengths.add( it.getRough_read_length() )
		}

		List<String> length = lengths.toSet().toList()

		// a unique species per sample
		if ( length.size() > 1 ) {

			String msg =
				"Error: the sample " + this.lims_id +
					" has more than one read length"
			println(msg)
			System.exit(1)

		} else {

			return length[0]
		}
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * a map representing the sample
	 */
	 Map getDict() {

	    Map m = [:]

		 Set<String> keys = [
			"lims_id",
			"project_id",
			"read_length",
			"rough_read_length",
			"species",
			"sequencing_type",
			"factors"
			]

		// get the Fastqs attributes we'd like to keep
		Map fastq_m = [:]
		for ( key in keys ) {
			Set<String> s = []
			for ( fastq in this.fastq_files ) {
				s.add(fastq[key])
			}
			fastq_m[key] = s
		}

		// the attributes has to be unique... logically...
		for ( key in keys ) {
			assert fastq_m[key].size() == 1
			m[key] = fastq_m[key].toList()[0]
		}

		// sample specific info
		m["name"] = this.getName()
		m["is_single_end"] = this.isSingleEnd()
		m["fastq_files"] = this.getPairedFastqPath()
		m["metrics"] = this.getMetrics()

		return m
	 }
	////////////////////////////////////////////////////////////////////////////
}
