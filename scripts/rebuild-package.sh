#!/bin/sh
set -e

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

vagrant ssh -c "apt-get source ${PACKAGE} && cd ${PACKAGE}-* && debuild-pbuilder -j${DIGABI_BUILD_CPUS:-1} -us -uc"
vagrant ssh -c "mv *.deb /artifacts/"

vagrant halt
