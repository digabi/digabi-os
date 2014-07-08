# INSTALL
Setting up build environment.

See also [Debian Live Manual](http://live.debian.net/manual/).


## Install Debian
Might also work on Ubuntu, but not tested. There will also be a Vagrant box that you can use to compile new images. VirtualBox images, maybe?

**TBD**


## Checkout config from git
Clone from our GitHub repository:

    git clone https://github.com/digabi/digabi-os.git digabi-os

Fetch submodules

    cd digabi-os
    git submodule init
    git submodule update

## Install required packages (for development)

Install HTTPS support for APT (our repositories are served only via HTTPS).

    apt-get -y install apt-transport-https

Add Digabi APT repository:

    echo "deb https://digabi.fi/debian/ jessie main contrib non-free" >/etc/apt/sources.list.d/digabi.list

Fetch Digabi GPG key:

    # pub   4096R/9D3D06EE 2013-05-23 [expires: 2016-01-20]
    #       Key fingerprint = 91AE C10B CEF8 EF27 41CB  B886 20F1 4706 9D3D 06EE
    # uid                  Ylioppilastutkintolautakunta / Digabi (Signing key for Digabi repository) <digabi@ylioppilastutkinto.fi>
    # sub   4096R/3578D7AF 2013-05-23 [expires: 2014-05-23]      

    wget -O- https://digabi.fi/debian/digabi.asc |sudo apt-key add -

Update package lists

    apt-get update

Install required tools

    apt-get install digabi-dev


## Preparation
    # Copy our proprietary logo into bootloader config
    cp logo.svg.in config/bootloaders/isolinux/splash.svg.in


## Compiling ISO image
To compile new ISO image, you may use make:

    make dist

If successful, output will be named `digabi-livecd-$(git describe).iso`. For example: `digabi-livecd-0.3.0-5-g5d6b142.iso`. (Files will be in `dist/`.)


### Creating new tag
    git tag -a v1.0 -m "Created tag for version 1.0"


