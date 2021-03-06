/*
 * nourdine.bah@crick.ac.uk
 */

/*
 * vim: syntax=groovy
 * -*- mode: groovy;-*-
 */

package asf

import asf.Sample

public class SampleSet extends HashSet {

	@Override
	boolean add(Object o) {

		if ( o instanceof Sample ) {

			// merge if the sample is already present
			if ( super.contains(o) ) {
				Sample sample = null
				this.each{ if ( it == o ) { sample = it } }
				super.remove(sample)
				Sample new_sample = sample + o
				super.add( new_sample )

			// otherwise just add the sample
			} else {
				super.add(o)
			}

		// maybe i will throw an error here
		} else {
			println("Warning: trying to add non Sample object in SampleSet")
		}
	}
}
