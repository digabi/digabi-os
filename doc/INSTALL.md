# INSTALL
Setting up build environment.


## Setup Debian installation
TBD


## Checkout config from git
If you're Digabi project developer (you have access to sensori.digabi.fi):

    git clone git@sensori.digabi.fi:digabi-live.git

Otherwise, use GitHub clone:

    git clone https://github.com/digabi/digabi-live.git


## Install required packages (for development)

    # Add Digabi APT repository:
    echo "deb http://digabi.fi/debian/ wheezy main" >/etc/apt/sources.list.d/digabi.list
    # Fetch Digabi GPG key from keyserver:
    apt-key add --keyserver hkp://keyserver.ubuntu.com:80 0xFFFFFFFF
    # Update package lists
    apt-get update
    # Install required tools
    apt-get install digabi-dev

    OR:
    # Install required packages manually (might not be up-to-date, see correct list from digabi-dev package)
    apt-get install live-build build-essential kernel-package apt-cacher-ng



## Compiling ISO image
To compile new ISO image, you may use make:

    make dist

If successful, output will be named `digabi-livecd-$(git describe).iso`. For example: `digabi-livecd-0.3.0-5-g5d6b142.iso`. (Files will be in `dist/`.)


### Creating new tag
    git tag -a 1.0 -m "Created tag for version 1.0"


