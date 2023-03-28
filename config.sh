#!/bin/sh -ex
#
# Set up a nitro enclave host for testing
# Assumes Amazon Linux 2023 or similar

# General build deps
sudo dnf install -y git make golang gcc gcc-c++ glibc-static openssl-devel

# Enclave utils want to talk to a docker registry
sudo dnf install -y docker
sudo systemctl enable docker
sudo systemctl start docker
# Add the default user so we don't need sudo
sudo groupmod -U $USER docker

# Amazon-packaged enclave utils
sudo dnf install -y aws-nitro-enclaves-cli aws-nitro-enclaves-cli-devel
sudo systemctl enable nitro-enclaves-allocator
sudo systemctl start nitro-enclaves-allocator
sudo groupmod -U $USER ne

# Install go linter
curl --proto '=https' --tlsv1.3 -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.52.0
echo 'export PATH=$PATH:$HOME/go/bin' >> $HOME/.profile
echo 'export PATH=$PATH:$HOME/go/bin' >> $HOME/.bashrc
