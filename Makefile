# GNU Makefile
#
# Type `make` to build and optionally run the system image

DOCKER ?= docker

ssh.eif: Makefile Dockerfile start.sh nitriding/cmd/nitriding
	$(DOCKER) build -t ssh:latest .
	nitro-cli build-enclave --docker-uri ssh:latest --output-file $@

# Checkout the submodule if necessary
nitriding/cmd/Makefile:
	git submodule update --init

# Build the nitriding daemon
nitriding/cmd/nitriding: nitriding/cmd/Makefile
	make -C $(dir $@)
