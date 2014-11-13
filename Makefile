DOCKER=docker
BUILDFLAGS=
VERSION=3.6.2-1

all:
	docker build $(BUILDFLAGS) -t="bahamat/cfengine:$(VERSION)" .
