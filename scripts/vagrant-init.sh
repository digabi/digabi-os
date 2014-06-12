#!/bin/sh

set -e

#
# Initialiaze new Vagrant (Debian wheezy/jessie)
#
DIGABI_REPOSITORY_PATH="/vagrant/custom-packages/digabi-repository"

if [ -x "/vagrant/scripts/vagrant-local.sh" ]
then
    echo "I: Run local Vagrant customization scripts.."
    /vagrant/scripts/vagrant-local.sh
fi

echo "I: Add Digabi repository..."
if [ -f "${DIGABI_REPOSITORY_PATH}/digabi.list" ]
then
    cp ${DIGABI_REPOSITORY_PATH}/digabi.list /etc/apt/sources.list.d/digabi.list
else
    wget -qO /etc/apt/sources.list.d/digabi.list https://digabi.fi/debian/digabi.list
fi
if [ -f "${DIGABI_REPOSITORY_PATH}/digabi.asc" ]
then
    apt-key add ${DIGABI_REPOSITORY_PATH}/digabi.asc
else
    wget -qO- https://digabi.fi/debian/digabi.asc | apt-key add -
fi

# If APT source exists, move it as default mirror (fixed problems w/ pbuilder)
if [ ! -f "/etc/apt/sources.list" ] &&  [ -f "/etc/apt/sources.list.d/jessie.list" ]
then
    echo "I: Use jessie.list as sources.list (default mirror)..."
    mv /etc/apt/sources.list.d/jessie.list /etc/apt/sources.list
fi

echo "I: Configure APT: do not install recommends..."
cat << EOF >/etc/apt/apt.conf.d/99-no-recommends
APT::Install-Recommends "false";
APT::Install-Suggests "false";
EOF

echo "I: Update package lists..."
apt-get -qy update

echo "I: Install digabi-dev, rsync..."
DEBIAN_FRONTEND=noninteractive apt-get -o "Acquire::http::Pipeline-Depth=10" -qy install digabi-dev rsync
