# Building Digabi OS

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

 - `DEBIAN_MIRROR` allows you to use custom Debian mirror for your build 
 (local mirror, Debian snapshot etc.)
 - `ARCH` allows you to specify build architecture (`i386`, `amd64`, others in future)
 - `http_proxy` allows you to specify HTTP proxy for the build (FIXME)
 - `BINARY_IMAGES` allows you to select which imagetype to use for 
 output (`iso-hybrid`=ISO w/ USB support, `iso` = regular ISO, `hdd` = 
 USB/HDD image)
 - `ROOT_PASSWORD` sets the password for root user (and adds live user 
 to group `wheel` so he/she can use `su`)
 - `DIGABI_DEBUG` (=true) enables `0001-digabi-debug.hook.chroot`
 - `COMMIT` builds specific commit

In `Makefile:config` these will be saved to the build system, to file `config/digabi.local`, which is read by `auto/config` & `auto/build`. This file overrides environment variables defined in the build system. Ie. if you build Digabi OS manually, you should put your variables to this file.


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

    git clone https://github.com/digabi/digabi-os digabi-os
    cd digabi-os
    export ROOT_PASSWORD="my-super-secret-password"
    export DEBIAN_MIRROR="http://my-local-mirror.example.com/debian"
    export ARCH="i386"
    export BINARY_IMAGES="hdd"
    make build
