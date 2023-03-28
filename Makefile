# GNU Makefile
#
# Type `make` to build and optionally run the system image

DOCKER ?= docker

ssh.eif: Makefile Dockerfile start.sh nitriding/cmd/nitriding
	$(DOCKER) build -t ssh:latest .
	nitro-cli build-enclave --docker-uri ssh:latest --output-file $@

# Checkout the submodules if necessary
nitriding/cmd/Makefile gvisor-tap-vsock/Makefile:
	git submodule update --init

# Build the nitriding daemon
nitriding/cmd/nitriding: nitriding/cmd/Makefile
	make -C $(dir $@)

# Build the vsock proxy
gvisor-tap-vsock/bin/gvproxy: gvisor-tap-vsock/Makefile
	make -C $(dir $<)

# Launch and configure the proxy
gvproxy_ctl := /tmp/network.sock
gvproxy: gvisor-tap-vsock/bin/gvproxy
	sudo gvisor-tap-vsock/bin/gvproxy \
		-listen vsock://:1024 \
		-listen unix://$(gvproxy_ctl) \
		-mtu 65000 &
	sleep 1
	sudo curl --unix-socket $(gvproxy_ctl) \
		http:/unix/services/forwarder/expose \
		--json \
		  '{ "local":":2223", "remote":"192.168.127.2:22" }'

# Run the enclave image
run: ssh.eif
	nitro-cli run-enclave \
		--cpu-count 2 \
		--memory 4000 \
		--eif-path $< \
		--attach-console

clean:
	make -C nitriding/cmd clean
	$(RM) ssh.eif
