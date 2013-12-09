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

ISO_FILE = binary.hybrid.iso
FILENAME_PREFIX = digabi-livecd

all:	config build

config:	clean
	$(LIVE_BUILD) config

build:
	$(ROOT_CMD) $(LIVE_BUILD) build |tee build.log

clean:
	$(ROOT_CMD) $(LIVE_BUILD) clean --all

bclean:
	find config -type f -name "*~" -exec rm {} \;

dist:	clean config build
	mkdir -p $(TARGET)
	mv $(ISO_FILE) $(TARGET)/$(FILENAME_PREFIX)-livecd_$(VERSION).iso
	mv build.log $(TARGET)/$(FILENAME_PREFIX)-buildlog_$(VERSION).log
	tar -cJf $(TARGET)/$(FILENAME_PREFIX)-config_$(VERSION).tar.xz config
	tar -cJf $(TARGET)/$(FILENAME_PREFIX)-info_$(VERSION).tar.xz chroot.packages.install binary.contents binary.packages chroot.packages.live
