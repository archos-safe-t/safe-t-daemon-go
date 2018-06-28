PLATFORM  = macos
BITS      = 64
NAME64 = safe-t-daemon-go-darwin-10.6-amd64
VOL_MOUNT = -v $(shell pwd):/release
IMAGETAG  = safe-t-daemon-go-build-env-$(PLATFORM)

IMPORT_PATH = ../..

all: clean .package

clean:
	$(info Cleaning...)
	rm -rf build

.binary:
	$(info Building with xgo ...)
	mkdir -p build
	xgo -targets=darwin/amd64 $(IMPORT_PATH)
	mv -f $(NAME64) build/safe-t-daemon
	cp ../../VERSION build

.package: .binary .docker-image
	$(info Packaging ...)
	docker run -i -t $(VOL_MOUNT) $(IMAGETAG) /release/release.sh $(PLATFORM)$(BITS)

.docker-image:
	$(info Preparing docker image ...)
	docker build -t $(IMAGETAG) .

shell: .docker-image
	docker run -i -t $(VOL_MOUNT) $(IMAGETAG) /bin/bash
