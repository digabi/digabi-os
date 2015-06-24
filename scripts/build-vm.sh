#!/bin/sh
set -e

CONFIG="/vagrant/dos-config"

[ -f "${CONFIG}" ] && . ${CONFIG} && echo "I: Using local configuration"

BUILD_DIR="${HOME}/digabi-os"

cd ${BUILD_DIR}
sudo lb build

mv digabi-* /artifacts/
