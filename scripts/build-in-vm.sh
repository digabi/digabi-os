#!/bin/sh
set -e

CONFIG="./dos-config"
SOURCES="sources.list"

[ -f "${CONFIG}" ] && . ${CONFIG} && echo "I: Using local configuration"

echo "I: Copy local configuration to build directory..."
cp ${CONFIG} target/default/digabi.local

echo "I: Configure build env"
sudo cp "${SOURCES}" /etc/apt/sources.list.d/digabi.list

if [ -n "${DEBIAN_MIRROR}" ]
then
    echo "I: Configuring custom Debian mirror: ${DEBIAN_MIRROR}..."
    if [ -z "${DEBIAN_SUITE}" ]
    then
        DEBIAN_SUITE="stretch"
    fi
    (
        echo "deb ${DEBIAN_MIRROR} ${DEBIAN_SUITE} main contrib non-free"
        echo "deb-src ${DEBIAN_MIRROR} ${DEBIAN_SUITE} main contrib non-free"
        echo "deb ${DEBIAN_MIRROR} ${DEBIAN_SUITE}-updates main contrib non-free"
        echo "deb-src ${DEBIAN_MIRROR} ${DEBIAN_SUITE}-updates main contrib non-free"
    ) | sudo tee /etc/apt/sources.list
else
    echo "I: Using pre-configured Debian mirror."
fi

echo "I: Configure APT: do not install recommends..."
cat << EOF | sudo tee /etc/apt/apt.conf.d/99-no-recommends
APT::Install-Recommends "false";
APT::Install-Suggests "false";
EOF

echo "I: Update package lists..."
sudo apt-get -qy update

echo "I: Uninstall postgres so that postgres installed inside chroot gets pristine port..."
sudo DEBIAN_FRONTEND=noninteractive apt-get -qy remove postgresql-9.6 postgresql-contrib-9.6 || true

echo "I: Upgrade build system..."
sudo DEBIAN_FRONTEND=noninteractive apt-get -qy dist-upgrade

echo "I: Install digabi-dev, rsync..."
sudo DEBIAN_FRONTEND=noninteractive apt-get -o "Acquire::http::Pipeline-Depth=10" -qy install build-essential rsync git aptitude live-build=4.0.5-24

echo "I: Copy local sources.list configuration to build directory..."
sed -i -e 's/^deb /&[trusted=yes] /' "${SOURCES}"
cp ${SOURCES} target/default/archives/digabi.list.binary
cp ${SOURCES} target/default/archives/digabi.list.chroot

mkdir -p config/signing_keys/ && cp signing_key.* config/signing_keys/

echo "I: Running lb config..."
lb config ${LB_OPTIONS}

echo "I: Running lb build..."
sudo lb build
