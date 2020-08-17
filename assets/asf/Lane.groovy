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
@EqualsAndHashCode(includes="number")
class Lane {

	String number

	String toString() {
		return this.number
	}
}
