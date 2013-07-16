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

KERNEL_DIR="linux-${KERNEL_VERSION}"
KERNEL_ARCHIVE="${KERNEL_DIR}.tar.xz"
AUFS_CHECKOUT_PATH="aufs3-standalone"

WGET_BIN="/usr/bin/wget"
GIT_BIN="/usr/bin/git"
TAR_BIN="/bin/tar"
PATCH_BIN="/usr/bin/patch"
CP_BIN="/bin/cp"

WGET_FLAGS="-q"
GIT_FLAGS="-q"
TAR_FLAGS="-xJf"
PATCH_FLAGS="-s -p1"

if [ ! -f "${KERNEL_ARCHIVE}" ]
then
	echo "Get kernel source..."
	${WGET_BIN} ${WGET_FLAGS} "${KERNEL_URL}"
else
	echo "Kernel source already downloaded..."
	echo "TODO: check kernel source checksum, verify signature"
fi

if [ ! -d "${KERNEL_DIR}" ]
then
	echo "Extracting kernel source..."
	${TAR_BIN} ${TAR_FLAGS} "${KERNEL_ARCHIVE}"
else
	echo "Kernel source already extracted..."
	echo "TODO: Check if source has been already patched"
fi

echo "TODO: check if patch already downloaded / applied"
echo "Get grsecurity patch..."
${WGET_BIN} ${WGET_FLAGS} "${GRSECURITY_URL}"

echo "TODO: Check if repository already cloned, pull newest changes"
echo "Get AUFS source..."
${GIT_BIN} clone ${GIT_FLAGS} "${AUFS_URL}" "${AUFS_CHECKOUT_PATH}"


echo "Checkout correct AUFS branch..."
cd "${AUFS_CHECKOUT_PATH}"
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
${CP_BIN} -R "../${AUFS_CHECKOUT_PATH}/fs" "../${AUFS_CHECKOUT_PATH}/Documentation" .
${CP_BIN} "../${AUFS_CHECKOUT_PATH}/include/linux/aufs_type.h" ./include/linux/

echo "TODO: Check if patching succeeds"
echo "TODO: Fix these:"
echo " 1 out of 2 hunks FAILED -- saving rejects to file fs/proc/task_mmu.c.rej"
echo " 1 out of 1 hunk FAILED -- saving rejects to file kernel/fork.c.rej"

