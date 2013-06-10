# INSTALL
=================
Setting up build environment

## With existing Debian installation

### Option 1
    echo "deb http://digabi.fi/debian/ wheezy main" >/etc/apt/sources.list.d/digabi.list
    apt-key add --keyserver hkp://keyserver.ubuntu.com:80 0xFFFFFFFF
    apt-get update
    apt-get install digabi-dev


### Option 2
	apt-get install live-build build-essential kernel-package apt-cacher-ng


## Virtualbox
TBD


## Virtualbox + Vagrant
    vagrant box add digabi http://digabi.fi/s/digabi.box



## Compiling
Make uses `git describe` to pick version number, ie. it uses git tags.
    make dist


### Creating new tag
    git tag -a 1.0 -m "Created tag for version 1.0"


