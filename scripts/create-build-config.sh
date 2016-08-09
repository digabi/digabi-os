#!/bin/sh
set -e

#
# Create configuration file from current environment (variables),
# output is used inside vagrantbox to configure the build system
#


cat << EOF >&1
ARCH="${ARCH:-amd64}"
BINARY_IMAGES="${BINARY_IMAGES:-iso-hybrid}"

BUILD_NUMBER="${BUILD_NUMBER:-0.unknown}"
BUILD_TAG="${BUILD_TAG:-N/A}"

COMMIT="${COMMIT:-HEAD}"

DEBIAN_MIRROR="${DEBIAN_MIRROR:-http://httpredir.debian.org/debian}"
DEBIAN_SUITE="${DEBIAN_SUITE:-jessie}"

DIGABI_BUILD_CPUS="${DIGABI_BUILD_CPUS:-1}"
DIGABI_BUILD_MEM="${DIGABI_BUILD_MEM:-1024}"

DIGABI_BUILD_TARGET="${DIGABI_BUILD_TARGET:-default}"
DIGABI_DEBUG="${DIGABI_DEBUG:-false}"

DIGABI_MIRROR="${DIGABI_MIRROR:-http://dev.digabi.fi/debian}"
DIGABI_SUITE="${DIGABI_SUITE:-stable}"

http_proxy="${http_proxy}"
HTTP_PROXY="${HTTP_PROXY:-${http_proxy}}"

LB_OPTIONS="${LB_OPTIONS}"

ROOT_PASSWORD="${ROOT_PASSWORD}"

WLAN="${WLAN:-false}"

VAGRANT_DEFAULT_PROVIDER="${VAGRANT_DEFAULT_PROVIDER:-virtualbox}"
EOF
