#!/bin/sh

set -e

#
# Initiliaze new Vagrant (Debian wheezy/jessie)
#

if [ -f "/etc/apt/apt.conf" ]
then
    echo "I: Remove apt proxy configuration..."
    rm /etc/apt/apt.conf
fi

echo "I: Add Digabi repository..."
wget -qO /etc/apt/sources.list.d/digabi.list https://digabi.fi/debian/digabi.list
wget -qO- https://digabi.fi/debian/digabi.asc | apt-key add -

echo "I: Install digabi-dev..."
apt-get -qy update
apt-get -qy install digabi-dev
