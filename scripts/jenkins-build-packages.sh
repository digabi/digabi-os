#!/bin/sh

set -xe

. $(dirname $0)/_jenkins

make custom-packages ARCH="$(ARCH)" DEBIAN_MIRROR="${DEBIAN_MIRROR}"
