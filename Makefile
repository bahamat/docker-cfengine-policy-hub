CF_FLAGS=--verbose
DOCKER=docker
BUILDFLAGS=
RUNFLAGS=
VERSION=3.6.2-1
OWNER=bahamat
WITH_MASTERFILES=
WITH_SKETCHES=

ifneq ($(WITH_MASTERFILES),)
	RUNFLAGS:=$(RUNFLAGS) -e WITH_MASTERFILES=$(WITH_MASTERFILES) -v $(WITH_MASTERFILES):/var/cfengine/masterfiles
endif

ifneq ($(WITH_SKETCHES),)
	RUNFLAGS:=$(RUNFLAGS) -e WITH_SKETCHES=$(WITH_SKETCHES) -v $(WITH_SKETCHES):/var/cfengine/design-center/sketches
endif

RUNFLAGS:=$(RUNFLAGS) -e CF_FLAGS=$(CF_FLAGS)

all: build

build:
	docker build $(BUILDFLAGS) -t="$(OWNER)/cfengine:$(VERSION)" .

run: build
	docker run $(RUNFLAGS) "${OWNER}/cfengine:$(VERSION)"

runv: build
	docker run $(RUNFLAGS) -v `pwd`:/data "$(OWNER)/cfengine:$(VERSION)"

kill:
	docker kill `docker ps -q` || echo nothing to kill
	docker rm -f `docker ps -a -q` || echo nothing to clean

clean: kill
	docker rmi "$(OWNER)/cfengine:$(VERSION)" || echo no image to remove
