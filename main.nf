#!/usr/bin/env nextflow

/*
 * christopher.barrington chez crick.ac.uk
 * gavin.kelly chez crick.ac.uk
 * harshil.patel chez crick.ac
 * nourdine.bah chez crick.ac.uk
 * philip.east chez crick.ac.uk
 */

import java.nio.file.Paths

import static groovy.io.FileType.FILES

@Grab('com.xlson.groovycsv:groovycsv:1.3')
import static com.xlson.groovycsv.CsvParser.parseCsv

import asf.Project
import asf.Fastq
import asf.Sample


nextflow.enable.dsl=2

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

///////////////////////////////////////////////////////////////////////////////
//// PROCESSES ////////////////////////////////////////////////////////////////

include { fastq_merge } from "./modules/process/fastq_merge"
include { read_length } from "./modules/process/read_length"
include { fastqc } from "./modules/process/fastqc"
include { cutadapt } from "./modules/process/cutadapt"
include { rsem } from "./modules/process/rsem"
include { rnaseqc } from "./modules/process/rnaseqc"

// metadata
include { fastq as fastq_md5 } from "./modules/process/md5/fastq"
include { rsem as rsem_md5 } from "./modules/process/md5/rsem"
include { insert_size } from "./modules/process/insert_size"
include { metadata } from "./modules/process/metadata"

// samtools
include { sort_index } from "./modules/process/samtools/sort_index"
include { index } from "./modules/process/samtools/index"

// picard
include { group } from "./modules/process/picard/group"
include { duplicates } from "./modules/process/picard/duplicates"
include { complexity } from "./modules/process/picard/complexity"
include { rnaseqmetrics } from "./modules/process/picard/rnaseqmetrics"
include { multimetrics } from "./modules/process/picard/multimetrics"

// rseqc
include { infer_experiment } from "./modules/process/rseqc/infer_experiment"
include {
	junction_annotation
	} from "./modules/process/rseqc/junction_annotation"
include {
	junction_saturation
	} from "./modules/process/rseqc/junction_saturation"
include { mismatch_profile } from "./modules/process/rseqc/mismatch_profile"
include { read_distribution } from "./modules/process/rseqc/read_distribution"
include {
	transcript_integrity_number
	} from "./modules/process/rseqc/transcript_integrity_number"

// r
include { matrix as build_matrix  } from "./modules/process/r/matrix"
include { dds as create_dds  } from "./modules/process/r/dds"
include { vst as create_vst  } from "./modules/process/r/vst"
include { rlog as create_rlog } from "./modules/process/r/rlog"
include { pca as do_pca  } from "./modules/process/r/pca"
include { pca_to_json  } from "./modules/process/r/pca_to_json"

include { multiqc } from "./modules/process/multiqc"

///////////////////////////////////////////////////////////////////////////////
//// GENOME ///////////////////////////////////////////////////////////////////

// genome
//params.genome_version = params.genome_version.toString()
//params.genome_release = params.genome_release.toString()

//// annotation
//fasta = params.genome.fasta
//gtf = params.genome.gtf
//bed = params.genome.bed
//refflat = params.genome.refflat
//rrna_list = params.genome.rrna_list
//rrna_interval_list = params.genome.rrna_interval_list
//rnaseqc_gtf = params.genome.rnaseqc_gtf

// locations
design_path = absolute_path( params.design )
r_script_dir = absolute_path( "assets/scripts/r" )
multiqc_conf = absolute_path( "assets/multiqc/conf.yml" )

///////////////////////////////////////////////////////////////////////////////
//// FASTQ ////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
//// a project is a set of fastq files with the same project ID
//fastqs = []
//fastq_dir = new File('examples/fastq/paired_end')
//fastq_dir.eachFileRecurse(FILES) {
//	if ( it.name.endsWith('.fastq.gz') ) {
//		fastqs.add( new Fastq(it.getAbsolutePath(), "type", "homo sapiens") )
//	}
//}
//project = new Project(fastqs)
///////////////////////////////////////////////////////////////////////////////

design = parseCsv( new File(params.design).readLines().join("\n") )

fastqs = []

for ( line in design ) {

	row = [:]
	experimental_factors = []
	line.columns.each{ column, index ->
		if ( ! ["sample", "file"].contains(column) ) {
			experimental_factors.add(column)
		}
		row[column] = line.getAt(index)
	}


	Fastq fastq = new Fastq(
							row["file"],
							row["sample"],
							params.type,
							params.species, 
							row.subMap(experimental_factors)
							)

	fastqs.add(fastq)
}

project = new Project(fastqs)

///////////////////////////////////////////////////////////////////////////////
//// MAIN WORKFLOW ////////////////////////////////////////////////////////////

// the sample channel
samples = project.getSamples().collect{ it.getDict() }
SAMPLES = Channel.from(samples[0..1])

workflow {

	// merge the different runs and lanes in one single fastq file
	fastq_merge(SAMPLES)
	fastq_merge	
		.out
		.map{ [ it[0] , it[1].sort() ] }
		.map{ addFiles(it[0], it[1], "fastq") }
		.set{ MERGED_FASTQ }
	
	read_length(MERGED_FASTQ)
	read_length
		.out
		.map{ addValue(it[0], it[1], "read_length") }
		.map{ addValue(it[0], rrlen(it[0]["read_length"]), "rough_read_length") }
		.map{ [ it[0] , it[0]["fastq"] ] }
		.set{ FASTQ }
	
	fastqc(FASTQ)

	cutadapt(FASTQ)
	cutadapt
		.out
		.fastq
		.map{ addFiles(it[0], it[1], "cutadapt") }
		.set{ CUTADAPT }

	rsem(CUTADAPT)
	rsem	
		.out
		.results
		.map{ addFiles(it[0], it[1], "rsem_results") }
		.set{ RSEM_RESULTS }
	rsem	
		.out
		.genome
		.map{ addFiles(it[0], it[1], "rsem_genome") }
		.set{ RSEM_GENOME }

	////////////////////////////////////////////////////////////////////////////
	// METADATA

	// md5 sums for the fastq files
	fastq_md5(FASTQ)
	fastq_md5
		.out
		.map{ addFiles(it[0], it[1], "fastq_md5") }
		.set{ FASTQ_MD5 }

	// md5 sums for the rsem results
	rsem_md5(RSEM_RESULTS)
	rsem_md5
		.out
		.map{ addFiles(it[0], it[1], "rsem_md5") }
		.set{ RSEM_MD5 }

	insert_size(RSEM_GENOME)
	insert_size
		.out
		.map{ addFiles(it[0], it[1], "insert_size") }
		.set{ INSERT_SIZE }
	
	//metadata(FASTQ_MD5, RSEM_MD5, INSERT_SIZE)
	////////////////////////////////////////////////////////////////////////////
	
	sort_index(RSEM_GENOME)
	sort_index
		.out
		.map{ addIndex(it[0], it[1], it[2], "indexed_rsem_genome") }
		.set{ SORTED_RSEM }
	
	group(SORTED_RSEM)
	group
		.out
		.map{ addFiles(it[0], it[1], "group") }
		.set{ GROUP }
	
	duplicates(GROUP)
	duplicates
		.out
		.bam
		.map{ addFiles(it[0], it[1], "duplicates") }
		.set{ DUPLICATES }
	
	complexity(DUPLICATES)
	rnaseqmetrics(DUPLICATES)
	multimetrics(DUPLICATES)

	infer_experiment(DUPLICATES)
	junction_annotation(DUPLICATES)
	junction_saturation(DUPLICATES)
	mismatch_profile(DUPLICATES)
	read_distribution(DUPLICATES)
	
	index(DUPLICATES)
	index
		.out
		.map{ addIndex(it[0], it[1], it[2], "indexed_duplicates") }
		.set{ INDEXED_DUPLICATES }
	
	transcript_integrity_number(INDEXED_DUPLICATES)
	rnaseqc(INDEXED_DUPLICATES)

	// build r object for analysis
	build_matrix( RSEM_RESULTS.collect{it[1][0]} , r_script_dir , design_path )
	create_dds( build_matrix.out.rda , r_script_dir )
	create_vst( create_dds.out , r_script_dir )
	create_rlog( create_dds.out , r_script_dir )
	do_pca( create_vst.out , r_script_dir )
	pca_to_json(do_pca.out , r_script_dir , design_path )

	multiqc(
		cutadapt.out.log.collect{it[1]},
		rsem.out.stat.collect{it[1]},
		fastqc.out.collect{it[1]},
		duplicates.out.metrics.collect{it[1]},
		complexity.out.collect{it[1]},
		rnaseqmetrics.out.collect{it[1]},
		multimetrics.out.metrics.collect{it[1]},
		infer_experiment.out.collect{it[1]},
		junction_annotation.out.collect{it[1]},
		junction_saturation.out.collect{it[1]},
		mismatch_profile.out.collect{it[1]},
		read_distribution.out.collect{it[1]},
		transcript_integrity_number.out.collect{it[1]},
		//rnaseqc.out.collect{it[1]},
		pca_to_json.out,
		multiqc_conf
	)
}

