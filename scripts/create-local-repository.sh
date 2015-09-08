#!/bin/sh
set -e

REPO_ID="${BUILD_NUMBER:-$(date +%Y%m%d%H%M%S)}"
SIGNING_KEY="${SIGNING_KEY:-0x9D3D06EE}"

CURDIR="${PWD}"
mkdir -p repos incoming
TEMPDIR="$(realpath $(mktemp -d repos/dos-repo.XXXXXXXX))"

echo "I: Creating temporary repository to ${TEMPDIR}..." 1>&2
cd "${TEMPDIR}"
mkdir -p conf

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

NGINX_CONF="nginx_repo_${REPO_ID}.conf"
cat > ${NGINX_CONF} << EOF
location /repo/${REPOID} {
    autoindex on;
    alias ${TEMPDIR}/repository;
}
EOF

echo "I: Import .debs from ${CURDIR}..." 1>&2
find ${CURDIR} -type f -name '*.deb' -exec reprepro includedeb jessie {} \;

echo "${TEMPDIR}"
