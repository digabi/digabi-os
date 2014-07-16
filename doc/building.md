# Building Digabi-Live
================================================

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

    - `DEBIAN_MIRROR` allows you to use custom Debian mirror for your build (local mirror, Debian snapshot etc.)
    - `ARCH` allows you to specify build architecture (`i386`, `amd64`, others in future)
    - `http_proxy` allows you to specify HTTP proxy for the build (FIXME)
    - `BINARY_IMAGES` allows you to select which imagetype to use for 
    output (`iso-hybrid`=ISO w/ USB support, `iso` = regular ISO, `hdd` 
    = USB/HDD image)
    - `ROOT_PASSWORD` sets the password for root user (and adds live 
    user to group `wheel` so he/she can use `su`)


## Do the build

Following assumes that you have vagrant & VirtualBox installed:

    git clone https://github.com/digabi/digabi-os digabi-os
    cd digabi-os
    export DEBIAN_MIRROR="http://my-local-mirror.example.com/debian"
    export ARCH="i386"
    make build
