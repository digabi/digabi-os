#!/bin/sh
set -e

# HOWTO:
# 1. import artifacts from .deb builds to $WORKSPACE/incoming/
# 2. run this script, get path to nginx config ($0 |grep ^CONFIG:)
# 3. serve repository via http (cp $config, nginx reload)
# 4. configure current build for build-specific repository
# 5. do the build
# 6. remove temporary repository, ie. get path from step 2


REPO_ID="${BUILD_NUMBER:-$(date +%Y%m%d%H%M%S)}"
SIGNING_KEY="${SIGNING_KEY:-0x9D3D06EE}"

CURDIR="${PWD}"
mkdir -p repos incoming
TEMPDIR="$(realpath $(mktemp -d repos/dos-repo.${REPO_ID}.XXXXXXXX))"

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
location /repo/${REPO_ID} {
    autoindex on;
    alias ${TEMPDIR}/repository;
}
EOF

echo "I: Import .debs from ${CURDIR}/incoming..." 1>&2
DEBS="$(find ${CURDIR}/incoming -type f -name '*.deb' |xargs)"
reprepro includedeb jessie ${DEBS}

echo "I: List .debs in repository..." 1>&2
reprepro list jessie

echo "CONFIG: ${TEMPDIR}/${NGINX_CONF}"
