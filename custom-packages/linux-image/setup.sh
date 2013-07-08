#!/bin/sh

if [ -f ./versions ]
then
	. ./versions
else
	echo "Version config (./versions) not found, exiting."
	exit 1
fi

KERNEL_URL="https://www.kernel.org/pub/linux/kernel/v3.x/linux-${KERNEL_VERSION}.tar.xz"
GRSECURITY_URL="https://grsecurity.net/stable/grsecurity-${GRSECURITY_VERSION}.patch"
AUFS_URL="http://git.code.sf.net/p/aufs/aufs3-standalone"

AUFS_CHECKOUT_PATH="aufs3-standalone"

WGET_BIN="/usr/bin/wget"
GIT_BIN="/usr/bin/git"
TAR_BIN="/bin/tar"
PATCH_BIN="/usr/bin/patch"

WGET_FLAGS="-q"
GIT_FLAGS="-q"
TAR_FLAGS="-xJf"
PATCH_FLAGS="-s -p1"

echo "Get kernel source..."
${WGET_BIN} ${WGET_FLAGS} "${KERNEL_URL}"
echo "Get grsecurity patch..."
${WGET_BIN} ${WGET_FLAGS} "${GRSECURITY_URL}"
echo "Get AUFS source..."
${GIT_BIN} clone ${GIT_FLAGS} "${AUFS_URL}" "${AUFS_CHECKOUT_PATH}"

echo "Extract kernel source..."
${TAR_BIN} ${TAR_FLAGS} "linux-${KERNEL_VERSION}.tar.xz"

echo "Checkout correct AUFS branch..."
cd "${AUFS_CHECKOUT_PATH"
${GIT_BIN} checkout ${GIT_FLAGS} -b "aufs${AUFS_VERSION}" "origin/aufs${AUFS_VERSION}"
cd ..

cd "linux-${KERNEL_VERSION}"

echo "Apply grsecurity patch..."
${PATCH_BIN} ${PATCH_FLAGS} <"../grsecurity-${GRSECURITY_VERSION}.patch"

echo "Apply AUFS patch..."
${PATCH_BIN} ${PATCH_FLAGS} <"../${AUFS_CHECKOUT_PATH}/aufs3-kbuild.patch"
${PATCH_BIN} ${PATCH_FLAGS} <"../${AUFS_CHECKOUT_PATH}/aufs3-base.patch"
${PATCH_BIN} ${PATCH_FLAGS} <"../${AUFS_CHECKOUT_PATH}/aufs3-proc_map.patch"
${PATCH_BIN} ${PATCH_FLAGS} <"../${AUFS_CHECKOUT_PATH}/aufs3-standalone.patch"

echo "Copy required files from AUFS source tree..."
cp -R "../${AUFS_CHECKOUT_PATH}/{fs,Documentation}" .
cp "../${AUFS_CHECKOUT_PATH}/include/linux/aufs_type.h" ./include/linux/

