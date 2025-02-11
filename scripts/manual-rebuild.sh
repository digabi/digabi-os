#!/bin/bash

# Use this script to manually test the live-build process

set -ex

export DIGABI_BUILD_TARGET="server meb"
export INCLUDE_WLAN=true
export ROOT_PASSWORD=kukkuu
export DEBIAN_MIRROR="https://debian.abitti.fi/debian-mirror/debian"
export DEBIAN_MIRROR_AUTH="machine debian.abitti.fi login digabi password password-from-aws-goes-here"
export DEBIAN_SUITE=bookworm
export ARCH=amd64
export DEBIAN_FRONTEND=noninteractive

# Clean up clutter from previous build
#### NOT NEEDED IN DOCKER
# sudo lb clean
# rm sources.list || true

# Fetch the resources
wget http://jenkins.abitti.fi/job/usb-kernel-signing-keys/lastSuccessfulBuild/artifact/signing_key.priv
wget http://jenkins.abitti.fi/job/usb-kernel-signing-keys/lastSuccessfulBuild/artifact/signing_key.x509
wget -O sources.list http://jenkins.abitti.fi/job/dos-repository/lastSuccessfulBuild/artifact/sources.list.bookworm

sudo rm /etc/apt/sources.list.d/digabi.list || true
scripts/create-build-config.sh > dos-config

# sudo apt remove live-build
scripts/build-in-vm.sh "digabi-*"
