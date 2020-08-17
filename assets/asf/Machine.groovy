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
@EqualsAndHashCode(includes="name")
class Machine {

	String name

	String toString() {
		return this.name
	}
}
