#!/bin/sh
set -e

rm -rf dist/debs
mkdir -p dist/debs

cleanup() {
    vagrant destroy -f
}

trap cleanup EXIT

PACKAGE="$1"

if [ -z "${PACKAGE}" ]
then
    echo "E: Missing package name."
    exit 1
fi

vagrant up

vagrant ssh -c "apt-get source ${PACKAGE} && cd ${PACKAGE}- && debuild-pbuilder -us -uc"
vagrant ssh -c "mv *.deb /artifacts/debs/"

vagrant halt
