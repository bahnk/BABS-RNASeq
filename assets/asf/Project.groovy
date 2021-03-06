/*
 * nourdine.bah@crick.ac.uk
 */

/*
 * vim: syntax=groovy
 * -*- mode: groovy;-*-
 */

package asf

import asf.Fastq
import asf.Sample
import asf.SampleSet

import groovy.transform.ToString

@ToString
class Project implements Iterable {

	// attributes
	String id
	SampleSet samples
	Map sample_to_species
	Map sample_to_rough_read_length
	Map sample_to_sequencing_type

	// constructor
	Project(List<Fastq> fastq_files) {
		this.samples = this.createSampleSet(fastq_files)
		this.id = this.extractId(this.samples)
		this.sample_to_species = this.createSpeciesMap(this.samples)
		this.sample_to_rough_read_length =
			this.createRoughReadLengthMap(this.samples)
		this.sample_to_sequencing_type =
			this.createSequencingTypeMap(this.samples)
	}

	// iterate over the samples
	@Override
	Iterator iterator() {
		return this.samples.iterator()
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * creates a sample set from a list of fastq passed as an argument
	 */
	SampleSet createSampleSet(List<Fastq> fastq_files) {

		SampleSet samples = new SampleSet()

		fastq_files.each{
			Sample s = new Sample(it)
			samples.add(s)
		}

		return samples
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * get the project id of a sample set passed as an argument
	 */
	String extractId(SampleSet samples) {

		HashSet<String> ids = new HashSet<String>()
		samples.each{ ids.add( it.getProjectId() ) }

		if ( ids.size() != 1 ) {
			throw new Exception("There are several project IDs in the SampleSet")
		} else {
			return ids.toList()[0]
		}
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * a map to associate a sample to its species
	 */
	Map createSpeciesMap(SampleSet samples) {

		Map species = [:]

		samples.each{
			species[ it.getLims_id() ] = it.extractSpecies()
		}

		return species
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * get the species from the lims id
	 */
	String getSpecies(String lims_id) {
		return this.sample_to_species[lims_id]
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * a map to associate a sample to its species
	 */
	Map createRoughReadLengthMap(SampleSet samples) {

		Map lengths = [:]

		samples.each{
			lengths[ it.getLims_id() ] = it.extractRoughReadLength()
		}

		return lengths
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * get the rough read length from the lims id
	 */
	String getRoughReadLength(String lims_id) {
		return this.sample_to_rough_read_length[lims_id]
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * a map to associate a sample to its sequencing type
	 */
	Map createSequencingTypeMap(SampleSet samples) {

		Map sequencing_types = [:]

		samples.each{
			sequencing_types[ it.getLims_id() ] = it.extractSequencingType()
		}

		return sequencing_types
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * get the sequencing type from the lims id
	 */
	String getSequencingType(String lims_id) {
		return this.sample_to_sequencing_type[lims_id]
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * gets the fastq list of the whole project
	 */
	List<Fastq> getFastq() {

		List<Fastq> fastq_files = []

		this.samples.each{
			fastq_files = [ *fastq_files , *it.getFastq() ]
		}

		return fastq_files
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * gets the fastq list of the whole project with their name
	 */
	List<Object> getFastqWithName() {

		List<Object> fastq_files = []

		this.samples.each{
			fastq_files = [ *fastq_files , *it.getFastqWithName() ]
		}

		return fastq_files
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * gets the paired fastq list of the whole project
	 */
	List<Object> getPairedFastq() {

		List<Object> paired_fastq_files = []

		this.samples.each{
			paired_fastq_files = [ *paired_fastq_files , *it.getPairedFastq() ]
		}

		return paired_fastq_files
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * gets the paired fastq list of the whole project with their name
	 */
	List<Object> getPairedFastqWithName() {

		List<Object> paired_fastq_files = []

		this.samples.each{
			paired_fastq_files = 
				[
					*paired_fastq_files,
					*it.getPairedFastqWithName()
				]
		}

		return paired_fastq_files
	}

	////////////////////////////////////////////////////////////////////////////
	/*
	 * a list to create a nextflow channel for fastqc
	 */
	 List<Object> getFastqC() {

		 List<Object> l = []

		 this.getFastqWithName().each{
			 l.add([
				it[1].getFlow_cell().getName(),
				it[0],
				it[1].getFile().getAbsolutePath().toString()
				])
		 }

		 return l
	 }

	////////////////////////////////////////////////////////////////////////////
	/*
	 * a list to create a nextflow channel for cutadapt
	 */
	 List<Object> getCutadapt() {

		 List<Object> l = []

		 this.getPairedFastqWithName().each{

			 l.add([
				it[1][0].getFlow_cell().getName(),
				it[0],
				it[1].size() == 1,
				it[1].collect{fq->fq.getFile().getAbsolutePath().toString()}.sort()
				])
		 }

		 return l
	 }

	////////////////////////////////////////////////////////////////////////////
}
