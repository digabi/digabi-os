# Building DigabiOS

See `doc/INSTALL.md` for prerequisites.


## Provide package dependencies
You may use Digabi package repository (see `doc/repository.md`), or build your own versions of our custom packages.


## Setup local Debian mirror

 - install Debian [`ftpsync` scriptset](https://ftp-master.debian.org/ftpsync.tar.gz)
 - setup webserver to serve your `/debian/` (nginx, for example)
 

See also [Setting up a Debian archive 
mirror](https://www.debian.org/mirror/ftpmirror).


## Customize build

### Environment variables
Currently following configuration variables have been defined in the 
build system:

Please see `scripts/create-build-config.sh` for current options. These are pushed to build environment.


### Adding new customization variables

 1. Add default value to `Makefile`
 2. Export value in Makefile:config
 3. (do something w/ the value, in `auto/config`, `auto/build`, hooks, 
 ...)
 4. Add Jenkins support to `digabi-dev/scripts/_os/jenkins-build`
 5. Add new option to Jenkins job `digabi-os EXPERIMENTAL` 
 (parameterized build) (optional)

## Do the build

Following assumes that you have vagrant & VirtualBox installed:

    # Fetch the sources
    git clone https://github.com/digabi/digabi-os digabi-os
    cd digabi-os

    # Configure build
    export ROOT_PASSWORD="my-super-secret-password"
    export DEBIAN_MIRROR="http://my-local-mirror.example.com/debian"
    export ARCH="i386"
    export BINARY_IMAGES="hdd"

    # Do the build (runs inside Vagrant)
    make -f Makefile.build dist
