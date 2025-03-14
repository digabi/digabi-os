#!/bin/bash

# Use this script to manually test the live-build process

set -ex

if [ -f .env ]; then
  echo "Reading env variables from .env"

  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
else
  echo ".env variable not found, initialize it before running"
fi

export DIGABI_BUILD_TARGET="server meb"
export INCLUDE_WLAN=true
export ROOT_PASSWORD=kukkuu
export DEBIAN_MIRROR="https://debian.abitti.fi/debian-mirror/debian"
export DEBIAN_SUITE=bookworm
export ARCH=amd64
export DEBIAN_FRONTEND=noninteractive

# Fetch the resources
wget http://jenkins.abitti.fi/job/usb-kernel-signing-keys/lastSuccessfulBuild/artifact/signing_key.priv
wget http://jenkins.abitti.fi/job/usb-kernel-signing-keys/lastSuccessfulBuild/artifact/signing_key.x509
wget -O sources.list http://jenkins.abitti.fi/job/dos-repository/lastSuccessfulBuild/artifact/sources.list.bookworm

scripts/create-build-config.sh > dos-config
scripts/build-in-vm.sh "digabi-*"
