CF_FLAGS=--verbose
DOCKER=docker
BUILDFLAGS=
RUNFLAGS=
VERSION=3.8.1-1
OWNER=tzz
IMAGEBASE=cfengine
IMAGENAME=$(OWNER)/$(IMAGEBASE)
WITH_MASTERFILES=
WITH_SKETCHES=
WITH_TESTFILES=

ifneq ($(WITH_MASTERFILES),)
	RUNFLAGS:=$(RUNFLAGS) -e WITH_MASTERFILES=/var/cfengine/masterfiles -v $(WITH_MASTERFILES):/var/cfengine/masterfiles
endif

ifneq ($(WITH_TESTFILES),)
	RUNFLAGS:=$(RUNFLAGS) -e WITH_TESTFILES=/opt/local/lib/testfiles -v $(WITH_TESTFILES):/opt/local/lib/testfiles
endif

ifneq ($(WITH_SKETCHES),)
	RUNFLAGS:=$(RUNFLAGS) -e WITH_SKETCHES=$(WITH_SKETCHES) -v $(WITH_SKETCHES):/var/cfengine/design-center/sketches
endif

RUNFLAGS:=$(RUNFLAGS) -e CF_FLAGS=$(CF_FLAGS)

all: build

build:
	VERSION=$(VERSION) $(DOCKER) build $(BUILDFLAGS) -t="$(IMAGENAME):$(VERSION)" .

build_as_latest: build
	$(DOCKER) tag "$(IMAGENAME):$(VERSION)" "$(IMAGENAME):latest"

run: build
	$(DOCKER) run $(RUNFLAGS) "${OWNER}/$(IMAGEBASE):$(VERSION)"

runv: build
	$(DOCKER) run $(RUNFLAGS) -v `pwd`:/data "$(IMAGENAME):$(VERSION)"

tester: build
	$(DOCKER) run $(RUNFLAGS) "${OWNER}/$(IMAGEBASE):$(VERSION)"

kill:
	$(DOCKER) kill `$(DOCKER) ps -q` || echo nothing to kill
	$(DOCKER) rm -f `$(DOCKER) ps -a -q` || echo nothing to clean

clean: kill
	$(DOCKER) rmi "$(IMAGENAME):$(VERSION)" || echo no image to remove
