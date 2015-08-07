include common.make


compile: bin/rancheros


all: clean ros-build-base build-all


ros-build-base:
	docker build -t ros-build-base -f Dockerfile.base .


ros-build-image:
	docker build -t ros-build .


bin/rancheros: ros-build-image
	./scripts/docker-run.sh make -f Makefile.docker $@

	docker cp ros-build:/go/src/github.com/rancherio/os/$@ $(dir $@)


build-all: ros-build-image
	./scripts/docker-run.sh make -f Makefile.docker FORCE_PULL=$(FORCE_PULL) $@

	docker cp ros-build:/go/src/github.com/rancherio/os/bin/rancheros bin
	docker cp ros-build:/go/src/github.com/rancherio/os/dist/artifacts dist


version:
	@echo $(VERSION)


clean:
	rm -rf bin build dist gopath .dockerfile


.PHONY: all compile clean build-all ros-build-image ros-build-base version bin/rancheros
