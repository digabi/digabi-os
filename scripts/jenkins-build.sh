#!/bin/sh

set -ex

. $(dirname $0)/_jenkins

trap cleanup EXIT

make dist ARCH="${ARCH}" DEBIAN_MIRROR="${DEBIAN_MIRROR}" http_proxy="${PROXY}" BUILD_TAG="${BUILD_TAG}"
