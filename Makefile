CF_FLAGS=--verbose
DOCKER=docker
BUILDFLAGS=
RUNFLAGS=
VERSION=3.8.1-1
OWNER=tzz
IMAGEBASE=cfengine
IMAGENAME=$(OWNER)/$(IMAGEBASE)
TESTERNAME=$(OWNER)_$(IMAGEBASE)_tester
WITH_MASTERFILES=
WITH_SKETCHES=
WITH_TESTFILES=
CONTAINER_MASTERFILES=/opt/local/lib/testfiles
CONTAINER_TESTFILES=/opt/local/lib/testfiles

ifneq ($(WITH_MASTERFILES),)
# inside the container, WITH_MASTERFILES takes the values CONTAINER_MASTERFILES because it's remapped
	RUNFLAGS:=$(RUNFLAGS) -e WITH_MASTERFILES=$(CONTAINER_MASTERFILES) -v $(WITH_MASTERFILES):$(CONTAINER_MASTERFILES):z
endif

ifneq ($(WITH_TESTFILES),)
# inside the container, WITH_TESTFILES takes the values CONTAINER_TESTFILES because it's remapped
	RUNFLAGS:=$(RUNFLAGS) -e WITH_TESTFILES=$(CONTAINER_TESTFILES) -v $(WITH_TESTFILES):$(CONTAINER_TESTFILES):z
	TEST_DATE := $(shell /bin/date +%F-%T)
# inside the container, TEST_LOGDIR takes the values CONTAINER_LOGDIR because it's remapped
	TEST_LOGDIR := $(WITH_TESTFILES)/testruns/$(TEST_DATE)
	CONTAINER_LOGDIR := $(CONTAINER_TESTFILES)/testruns/$(TEST_DATE)
endif

ifneq ($(WITH_SKETCHES),)
	RUNFLAGS:=$(RUNFLAGS) -e WITH_SKETCHES=$(WITH_SKETCHES) -v $(WITH_SKETCHES):/var/cfengine/design-center/sketches:z
endif

RUNFLAGS:=$(RUNFLAGS) -e CF_FLAGS=$(CF_FLAGS)

all: build

build:
	VERSION=$(VERSION) $(DOCKER) build $(BUILDFLAGS) -t="$(IMAGENAME):$(VERSION)" .

build_as_latest: build
	$(DOCKER) tag "$(IMAGENAME):$(VERSION)" "$(IMAGENAME):latest"

run: build
	$(DOCKER) run $(RUNFLAGS) "$(IMAGENAME):$(VERSION)"

runv: build
	$(DOCKER) run $(RUNFLAGS) -v `pwd`:/data "$(IMAGENAME):$(VERSION)"

test:
	mkdir -p $(TEST_LOGDIR)
	$(DOCKER) rm -fv $(TESTERNAME) || echo "Tester image $(TESTERNAME) didn't need to be cleaned up"
	$(DOCKER) run $(RUNFLAGS) -e TEST_LOGDIR=$(CONTAINER_LOGDIR) --name $(TESTERNAME) "$(IMAGENAME):$(VERSION)"
	$(DOCKER) diff $(TESTERNAME) > $(TEST_LOGDIR)/filesystem.log

kill:
	$(DOCKER) kill `$(DOCKER) ps -q` || echo nothing to kill
	$(DOCKER) rm -f `$(DOCKER) ps -a -q` || echo nothing to clean

clean: kill
	$(DOCKER) rmi "$(IMAGENAME):$(VERSION)" || echo no image to remove
