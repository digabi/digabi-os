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

ARCH ?= i386

DEBIAN_MIRROR ?= http://http.debian.net/debian
#DIGABI_BUILD_CPUS ?= $(shell ...)
DIGABI_RAM_BUILD ?= 0
HTTP_PROXY ?= 
ROOT_PASSWORD ?=

BUILD_TAG ?= N/A

REPOSITORY = custom-packages/digabi-repository
REPOSITORY_SUITE ?= sid
BINARY_IMAGES ?= iso-hybrid

# Enable debugging? (If true, runs debug hooks when building)
DIGABI_DEBUG ?= false

#
# Other configuration
#

ROOT_CMD = sudo
BUILD_DIR = digabi-os
BUILDER = vagrant
GIT_REPOSITORY = /digabi-os.git
ARTIFACTS_DIR = dist

# Helper for running targets in another Makefile (default: vagrant/Makefile)
BUILDER_DO  = $(MAKE) -C $(BUILDER)
REPOSITORY_DO = $(MAKE) -C $(REPOSITORY)

#
# Targets
#

# Default target
all:	build

# Initialize new builder
environment:
	$(BUILDER_DO) up
	$(BUILDER_DO) provision
	# TODO: Check if already exists & re-use?
	# TODO: Export variables? (DEBIAN_MIRROR, http_proxy, et. all); save as config/digabi.local
	#TEMPFILE = $(shell /bin/mktemp $(BUILDER)/digabi.local.XXXXXXX.tmp)
	# TODO: Create digabi.local, copy from /vagrant
	#echo "DIGABI_MIRROR=$(DIGABI_MIRROR)"
	#$(BUILDER_DO) run COMMAND='if [ ! -d "$(BUILD_DIR)/.git" ] ; then git clone $(GIT_REPOSITORY) $(BUILD_DIR) ; else cd $(BUILD_DIR) ; git fetch --all ; fi'

# Configure build environment
config:	clean environment
	#$(BUILDER_DO) run COMMAND='cd $(BUILD_DIR) && $(ROOT_CMD) lb config'
	#$(LIVE_BUILD) config

halt:
	$(BUILDER_DO) halt

# Provision buildbox
provision: environment halt

# Build new image
build: config
	# TODO: Check if uncommitted changes (git)
	# TODO: Allow specifying COMMIT=xx => if COMMIT != "" > run cd builddir & git co ...
	$(BUILDER_DO) run COMMAND='DIGABI_DEBUG="$(DIGABI_DEBUG)" ROOT_PASSWORD="$(ROOT_PASSWORD)" BINARY_IMAGES="$(BINARY_IMAGES)" ARCH="$(ARCH)" DEBIAN_MIRROR="$(DEBIAN_MIRROR)" BUILD_TAG="$(BUILD_TAG)" /usr/bin/digabi os build'

# Clean build environment
clean:
	#$(BUILDER_DO) run COMMAND='sudo rm -rf $(BUILD_DIR)'
	#$(MAKE) -C vagrant ssh

# Remove builder (destroys virtual machine)
purge:
	$(BUILDER_DO) destroy

# Collect build artifacts (.ISO) to dist/
collect: build
	#$(BUILDER_DO) run COMMAND='if [ -d "$(BUILD_DIR)/$(ARTIFACTS_DIR)" ] ; then cd $(BUILD_DIR) ; rsync -avh $(ARTIFACTS_DIR) /$(BUILDER)/ ; fi'
	#mkdir -p $(ARTIFACTS_DIR)
	#mv $(BUILDER)/$(ARTIFACTS_DIR)/* $(ARTIFACTS_DIR)/
	mkdir -p $(ARTIFACTS_DIR)
	mv $(BUILDER)/digabi-os-* $(ARTIFACTS_DIR)/

# Build image & collect results
dist:	collect
	echo "TODO	"

# Build custom packages defined in ./custom-packages/*
custom-packages: environment
	# TODO: chdir to repo, run build cmd
	$(BUILDER_DO) run COMMAND='if [ -d "$(BUILD_DIR)" ] ; then cd $(BUILD_DIR) ; git pull ; else git clone $(GIT_REPOSITORY) $(BUILD_DIR) ; fi'
	$(BUILDER_DO) run COMMAND='cd $(BUILD_DIR) && git submodule init && git submodule update && BUILD_TAG="$(BUILD_TAG)" digabi os build-custom-packages'
	$(BUILDER_DO) run COMMAND='rsync -avh $(BUILD_DIR)/custom-packages/*.deb /$(BUILDER)/$(ARTIFACTS_DIR)'
	mkdir -p $(ARTIFACTS_DIR)
	mv $(BUILDER)/$(ARTIFACTS_DIR)/*.deb $(ARTIFACTS_DIR)/

publish-packages: custom-packages
	git submodule init
	git submodule update
	$(REPOSITORY_DO) sync-from-server
	# TODO: Foreach *.deb $(BUILDER_DO) add-package DEB=$(DEB)
	for deb in $(ARTIFACTS_DIR)/*.deb ; do $(REPOSITORY_DO) add-package DEB="\"$$(readlink -f $${deb})\"" ; done
	$(REPOSITORY_DO) sync-to-server

# Export builder as VirtualBox Machine Image
buildbox: clean environment
	# TODO
	# TODO: Modify VM: remove VT-X, PAE et. all

debug: environment
	$(BUILDER_DO) run

.PHONY: custom-packages
