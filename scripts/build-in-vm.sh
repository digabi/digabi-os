#!/bin/sh
set -ex

CONFIG="./dos-config"
SOURCES="sources.list"

[ -f "${CONFIG}" ] && . ${CONFIG} && echo "I: Using local configuration"

echo "I: Copy local configuration to build directory..."
cp ${CONFIG} target/default/digabi.local

echo "I: Configure build env"
sed -i -e 's/^deb http/deb [trusted=yes] http/' "${SOURCES}"
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

echo "I: Configure APT: increase number of retries..."
cat << EOF | sudo tee /etc/apt/apt.conf.d/99-retries
APT::Acquire::Retries 5;
EOF

echo "I: Update package lists..."
sudo apt-get -qy update

echo "I: Upgrade build system..."
sudo DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confnew" -qy dist-upgrade

echo "I: Install digabi-dev, rsync..."
sudo DEBIAN_FRONTEND=noninteractive apt-get -o "Acquire::http::Pipeline-Depth=10" -qy install build-essential rsync git aptitude live-build

echo "I: Copy local sources.list configuration to build directory..."
cp ${SOURCES} target/default/archives/digabi.list.binary
cp ${SOURCES} target/default/archives/digabi.list.chroot

cat >> target/default/archives/digabi.pref.chroot << EOF
Package: *
Pin: release o=Digabi
Pin-Priority: 1000
EOF

cp target/default/archives/digabi.pref.chroot target/default/archives/digabi.pref.binary

mkdir -p config/signing_keys/ && cp signing_key.* config/signing_keys/

echo "I: Running lb config..."
lb config ${LB_OPTIONS}

echo "I: Running lb build..."
sudo lb build --verbose --debug

mkdir -p artifacts
mv digabi-os-* artifacts
mv chroot/boot/initrd* artifacts
