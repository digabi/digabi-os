#
# Makefile for building .deb packages
# See <Makefile.build> for digabi-os build targets
#
# For example, to build new image: make -f Makefile.build dist
#

all:

clean:

install:

deb:
	debuild -us -uc
