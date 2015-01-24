DOCKER=docker
BUILDFLAGS=
RUNFLAGS=
VERSION=3.6.2-1
OWNER=bahamat

all: build

build:
	docker build $(BUILDFLAGS) -t="${OWNER}/cfengine:$(VERSION)" .

run: build
	docker run ${RUNFLAGS} "${OWNER}/cfengine:$(VERSION)"

runv: build
	docker run ${RUNFLAGS} -v `pwd`:/data "${OWNER}/cfengine:$(VERSION)"

kill:
	docker kill `docker ps -q` || echo nothing to kill
	docker rm -f `docker ps -a -q` || echo nothing to clean

clean: kill
	docker rmi "${OWNER}/cfengine:$(VERSION)" || echo no image to remove
