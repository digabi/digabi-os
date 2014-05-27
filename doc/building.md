# Building Digabi-Live
================================================

See `doc/INSTALL.md` for prerequisites.


## Provide package dependencies
You may use Digabi package repository (see `doc/repository.md`), or build your own versions of our custom packages.


## Setup local Debian mirror

 - install Debian [`ftpsync` scriptset](https://ftp-master.debian.org/ftpsync.tar.gz)
 - setup webserver to serve your `/debian/` (nginx, for example)
 - in build environment: `export REPOSITORY="http://url.to.my.mirror/debian"`

See also [Setting up a Debian archive 
mirror](https://www.debian.org/mirror/ftpmirror).
