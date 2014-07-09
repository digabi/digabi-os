#
# Makefile for digabi-os
#
# (c) 2013, 2014 Ylioppilastutkintolautakunta / The Matriculation Examination Board of Finland
# <http://www.ylioppilastutkinto.fi/>
# <http://digabi.fi/>
#
# Author: Ville Korhonen <ville.korhonen@ylioppilastutkinto.fi>
#

#LIVE_BUILD = lb

#VERSION = $(shell ./scripts/version.helper)
#TARGET = dist/$(VERSION)

ARCH = i386

DEBIAN_MIRROR ?= http://http.debian.net/debian
#DIGABI_BUILD_CPUS ?= $(shell ...)
DIGABI_RAM_BUILD ?= 0
HTTP_PROXY ?= 

#
# Other configuration
#

ROOT_CMD = sudo
BUILD_DIR = digabi-os
BUILDER = vagrant
GIT_REPOSITORY = /digabi-os.git
ARTIFACTS_DIR = dist


#
# Targets
#

all:	build

_configure_env:
	# TODO: Check if already exists & re-use?
	# TODO: Export variables? (DEBIAN_MIRROR, http_proxy, et. all); save as config/digabi.local
	#TEMPFILE = $(shell /bin/mktemp $(BUILDER)/digabi.local.XXXXXXX.tmp)
	# TODO: Create digabi.local, copy from /vagrant
	#echo "DIGABI_MIRROR=$(DIGABI_MIRROR)"

	$(MAKE) -C $(BUILDER) run COMMAND='git clone $(GIT_REPOSITORY) $(BUILD_DIR)'

config:	clean _configure_env
	$(MAKE) -C $(BUILDER) run COMMAND='cd $(BUILD_DIR) && $(ROOT_CMD) lb config'
	#$(LIVE_BUILD) config

build: config
	# TODO: Check if uncommitted changes (git)
	# TODO: Allow specifying COMMIT=xx => if COMMIT != "" > run cd builddir & git co ...
	$(MAKE) -C $(BUILDER) run COMMAND='cd $(BUILD_DIR) && $(ROOT_CMD) lb build && mkdir -p dist && mv digabi-os-* dist/'

clean:
	$(MAKE) -C $(BUILDER) run COMMAND='sudo rm -rf $(BUILD_DIR)'
	#$(MAKE) -C vagrant ssh

purge:
	$(MAKE) -C $(BUILDER) destroy

collect: build
	$(MAKE) -C $(BUILDER) run COMMAND='if [ -d "$(BUILD_DIR)/$(ARTIFACTS_DIR)" ] ; then cd $(BUILD_DIR) ; rsync -avh $(ARTIFACTS_DIR) /vagrant/ ; fi'

dist:	collect
	echo "TODO	"

custom-packages:
	cd custom-packages
	# TODO
	cd ..

.PHONY: custom-packages
