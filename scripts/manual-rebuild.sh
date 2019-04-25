#!/bin/bash

# Use this script to manually test the live-build process

set -ex

export DIGABI_BUILD_TARGET="client meb"
export WLAN=true
export ROOT_PASSWORD=kukkuu
export DEBIAN_MIRROR=http://192.168.3.32/debian
export DEBIAN_SUITE=stretch
export ARCH=amd64

# Clean up clutter from previous build
sudo lb clean
rm sources.list || true

# Fetch the resources
wget http://jenkins.local/job/usb-kernel-signing-keys/lastSuccessfulBuild/artifact/signing_key.priv
wget http://jenkins.local/job/usb-kernel-signing-keys/lastSuccessfulBuild/artifact/signing_key.x509
wget http://jenkins.local/job/dos-repository/lastSuccessfulBuild/artifact/sources.list

sudo rm /etc/apt/sources.list.d/digabi.list || true
scripts/create-build-config.sh > dos-config

sudo apt remove live-build
scripts/build-in-vm.sh "digabi-*"
