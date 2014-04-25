#!/bin/sh

set -e

#
# Initiliaze new Vagrant (Debian wheezy/jessie)
#
DIGABI_REPOSITORY_PATH="/vagrant/custom-packages/digabi-repository"

if [ -f "/etc/apt/apt.conf" ]
then
    echo "I: Remove apt proxy configuration..."
    rm /etc/apt/apt.conf
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

echo "I: Install digabi-dev..."
apt-get -qy update
apt-get -qy install digabi-dev
