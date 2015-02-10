#!/bin/sh
set -e

# Extract initrd images from initrd.imgs that have microcode+actual image
# concatenated together. Ie. images that Debian initramfs-tools produce.

# Author: Ville Korhonen <ville.korhonen@ylioppilastutkinto.fi>


INITRD="$1"
BLOCKSIZE="512"

if [ ! -f "${INITRD}" ]
then
    echo "E: File not found: ${INITRD}!"
    exit 1
fi
INITRD="$(realpath ${INITRD})"

INITRDFULL="initrd.full.img"
INITRDREAL="initrd.real.img"

TEMPDIR="$(mktemp -d tmp.extract-initrd.XXXXXX)"
echo "I: Tempdir ${TEMPDIR}"

cd ${TEMPDIR}
cp ${INITRD} ${INITRDFULL}

BLOCKS="$(cpio -t < ${INITRDFULL} 2>&1 |grep blocks$ |cut -d' ' -f1)"
echo "I: First image is ${BLOCKS} blocks..."
RBLOCKS="$(((${BLOCKS}-1)*${BLOCKSIZE}))"

ls -liah ${INITRDFULL}

NPOS="0x$(dd if=${INITRDFULL} bs=1 skip=${RBLOCKS} count=${BLOCKSIZE} 2>/dev/null |hd |grep "1f 8b 08" |awk '{print $1}')"
NRBLOCKS="$((${RBLOCKS}+${NPOS}))"

CTYPE="$(dd if=${INITRDFULL} bs=1 skip=${NRBLOCKS} |file --mime-type - |awk '{print $2}')"
echo "I: Content type: ${CTYPE}"

case "${CTYPE}" in
    application/gzip)
	SUFFIX=".gz"
	UNPACKCMD="gunzip"
	;;
    *)
	SUFFIX=""
	UNPACKCMD=""
	;;
esac

echo "I: Extracting initrd image to ${INITRDREAL}${SUFFIX}..."
dd if=${INITRDFULL} bs=1 skip=${NRBLOCKS} of=${INITRDREAL}${SUFFIX}

if [ -n "${UNPACKCMD}" ]
then
    echo "I: Unpacking initrd image to ${INITRDREAL}"
    ${UNPACKCMD} ${INITRDREAL}${SUFFIX}
fi

# ville@lumikki:~/work/digabi/digabi-os/dist/tmp/i$ dd if=initrd.img.old bs=1 skip=458240 count=512 2>/dev/null |hd |grep "1f 8b 08"
#   00000090  1f 8b 08 00 0d 49 09 54  00 03 ec 5a 7f 74 53 55  |.....I.T...Z.tSU|
#ville@lumikki:~/work/digabi/digabi-os/dist/tmp/i$ dd if=initrd.img.old bs=1 skip=$((895*512+0x90)) |file -
#   /dev/stdin: gzip compressed data, last modified: Fri Sep  5 08:24:29 2014, from Unix
#ville@lumikki:~/work/digabi/digabi-os/dist/tmp/i$ dd if=initrd.img.old bs=1 skip=$((895*512+0x90)) |gunzip |cpio -i

