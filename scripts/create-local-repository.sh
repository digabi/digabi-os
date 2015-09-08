#!/bin/sh
set -e

SIGNING_KEY="0x9D3D06EE"

CURDIR="${PWD}"
TEMPDIR="$(mktemp -d)"

echo "I: Creating temporary repository to ${TEMPDIR}..." 1>&2
cd "${TEMPDIR}"
mkdir -p conf incoming

echo "I: Configure reprepro..." 1>&2
cat > conf/distributions << EOF
Origin: Digabi
Codename: jessie
Architectures: amd64 i386 source
Components: main contrib non-free
SignWith: ${SIGNING_KEY}
Contents: percomponent
EOF

cat > conf/options << EOF
ask-passphrase
waitforlock 3
outdir +b/repository
dbdir +b/db
listdir +b/lists
morguedir +b/morgue
EOF

echo "I: Import .debs from ${CURDIR}..." 1>&2
find ${CURDIR} -type f -name '*.deb' -exec reprepro includedeb jessie {} \;

echo "${TEMPDIR}"
