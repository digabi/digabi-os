#
# Makefile for digabi-live
#
# (c) 2013 Ylioppilastutkintolautakunta / The Matriculation Examination Board of Finland
# <http://www.ylioppilastutkinto.fi/>
# <http://digabi.fi/>
#
# Author: Ville Korhonen <ville.korhonen@ylioppilastutkinto.fi>
#

LIVE_BUILD = lb
ROOT_CMD = sudo

VERSION = $(shell ./scripts/version.helper)
#TARGET = dist/$(VERSION)
TARGET = dist
ARCH = i386

TAR_BIN = /bin/tar
TAR_FLAGS = -cJf
TAR_EXT = .tar.xz

ISO_FILE = live-image-$(ARCH).hybrid.iso
FILENAME_PREFIX = digabi-os

CHROOT_PACKAGES = config/packages.chroot

all:	config build

config:	clean
	$(LIVE_BUILD) config

$(CHROOT_PACKAGES):
	mkdir -p $(CHROOT_PACKAGES)
	digabi build-custom-packages

	#for pkg in $(shell cat config/package-lists/digabi.list.chroot |grep ^digabi |xargs)
	#do
	#	mv custom-packages/$(pkg)_*_*.deb $(CHROOT_PACKAGES)/
	#done
	# TODO: List packages we need (cat config/package-lists/digabi.list.chroot |grep ^digabi |xargs)
	# TODO: For $pkg in $packages
	
build: config
	$(ROOT_CMD) $(LIVE_BUILD) build |tee build.log

clean:
	$(ROOT_CMD) $(LIVE_BUILD) clean --all

bclean:
	find config -type f -name "*~" -exec rm {} \;

purge:
	$(ROOT_CMD) $(LIVE_BUILD) clean --all --purge
	rm -f config/build
	rm -f config/root-password
	rm -rf $(CHROOT_PACKAGES)

collect:
	mkdir -p $(TARGET)
	mv $(ISO_FILE) $(TARGET)/$(FILENAME_PREFIX)_$(VERSION).iso
	mv build.log $(TARGET)/$(FILENAME_PREFIX)-build_$(VERSION).log
	$(TAR_BIN) $(TAR_FLAGS) $(TARGET)/$(FILENAME_PREFIX)-config_$(VERSION)$(TAR_EXT) config
	$(TAR_BIN) $(TAR_FLAGS) $(TARGET)/$(FILENAME_PREFIX)-info_$(VERSION)$(TAR_EXT) chroot.packages.install chroot.packages.live chroot.files live-image-$(ARCH).*

dist:	clean bclean build collect
