#!/bin/bash

GO_VERSION="1.11.1"
OS_ARCH="linux-amd64"
GO_BUILD_FILE="go${GO_VERSION}.${OS_ARCH}.tar.gz"

set -o errexit

# install golang and add to path
wget "https://dl.google.com/go/${GO_BUILD_FILE}"
sudo tar -C /usr/local -xzf "${GO_BUILD_FILE}"
sudo rm -rf "~/${GO_BUILD_FILE}"
sudo echo 'export PATH=/usr/local/go/bin:$PATH' >> ~/.profile
sudo echo 'export GOPATH=$HOME/go' >> ~/.profile
sudo echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.profile
source ~/.profile

# install and start messaging server
go get github.com/nats-io/gnatsd
go get github.com/nats-io/nats-top

# setup gnatsd as a systemctl service
sudo cp /tmp/gnatsd.service /etc/systemd/system
cat /tmp/gnatsd.service
rm -rf /tmp/gnatsd.service

sudo systemctl enable gnatsd
sudo systemctl start gnatsd

