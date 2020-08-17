#
# nourdine.bah@crick.ac.uk
#

BIN=groovy
CC=groovyc
ARCH=jar
OPT=cvf

PACKAGE = asf

.PHONY: .FORCE
.FORCE:

all: jar

clean:
	rm -v $(PACKAGE)/*.class

jar: .FORCE $(PACKAGE)/Project.class
	$(ARCH) $(OPT) $(PACKAGE).jar $(PACKAGE)
	rm -v $(PACKAGE)/*.class

$(PACKAGE)/Project.class: \
	.FORCE \
	$(PACKAGE)/Sample.class \
	$(PACKAGE)/SampleSet.class
	$(CC) -d . $(PACKAGE)/Project.groovy

$(PACKAGE)/SampleSet.class: .FORCE
	$(CC) -d . $(PACKAGE)/SampleSet.groovy

$(PACKAGE)/Sample.class: .FORCE $(PACKAGE)/Fastq.class
	$(CC) -d . $(PACKAGE)/Sample.groovy

$(PACKAGE)/Fastq.class: \
	.FORCE \
	$(PACKAGE)/FlowCell.class \
	$(PACKAGE)/Lane.class \
	$(PACKAGE)/Machine.class \
	$(PACKAGE)/Read.class \
	$(PACKAGE)/Run.class
	$(CC) -d . $(PACKAGE)/Fastq.groovy

$(PACKAGE)/FlowCell.class: .FORCE
	$(CC) -d . $(PACKAGE)/FlowCell.groovy

$(PACKAGE)/Lane.class: .FORCE
	$(CC) -d . $(PACKAGE)/Lane.groovy

$(PACKAGE)/Machine.class: .FORCE
	$(CC) -d . $(PACKAGE)/Machine.groovy

$(PACKAGE)/Read.class: .FORCE
	$(CC) -d . $(PACKAGE)/Read.groovy

$(PACKAGE)/Run.class: .FORCE
	$(CC) -d . $(PACKAGE)/Run.groovy

