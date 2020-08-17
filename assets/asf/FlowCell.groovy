/*
 * nourdine.bah@crick.ac.uk
 */

/*
 * vim: syntax=groovy
 * -*- mode: groovy;-*-
 */

package asf

import groovy.transform.Canonical
import groovy.transform.Sortable
import groovy.transform.CompileStatic
import groovy.transform.EqualsAndHashCode

@Canonical
@Sortable
@CompileStatic
@EqualsAndHashCode(includes="name")
class FlowCell {

	String name

	String toString() {
		return this.name
	}

}
