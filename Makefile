#
# Makefile for digabi-os
#
# (c) 2013, 2014 Ylioppilastutkintolautakunta / The Matriculation Examination Board of Finland
# <http://www.ylioppilastutkinto.fi/>
# <http://digabi.fi/>
#
# Author: Ville Korhonen <ville.korhonen@ylioppilastutkinto.fi>
#

ARCH ?= i386

DEBIAN_MIRROR ?= http://http.debian.net/debian
#DIGABI_BUILD_CPUS ?= $(shell ...)
DIGABI_RAM_BUILD ?= 0
HTTP_PROXY ?= 
ROOT_PASSWORD ?=
COMMIT ?= HEAD

BUILD_TAG ?= N/A

REPOSITORY = custom-packages/digabi-repository
REPOSITORY_SUITE ?= sid
BINARY_IMAGES ?= iso-hybrid
DIGABI_BUILD_TARGET ?= default

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
CONFIG_FILE = digabi.local

BUILD_CONFIG = $(BUILD_DIR)/target/default/$(CONFIG_FILE)

VM_ENVIRONMENT ?= set -ex

# Helper for running targets in another Makefile (default: vagrant/Makefile)
BUILDER_DO  = $(MAKE) -C $(BUILDER)
REPOSITORY_DO = $(MAKE) -C $(REPOSITORY)

#
# Targets
#
.DEFAULT_GOAL = dist

# Default target
all:	dist

# Initialize new builder
environment:
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	$(BUILDER_DO) up
	$(BUILDER_DO) provision


# Clean build environment
clean: environment
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	$(BUILDER_DO) run COMMAND='if [ -d "$(BUILD_DIR)" ] ; then sudo rm -rf "$(BUILD_DIR)" ; fi'
	

# Remove builder (destroys virtual machine)
purge:
	$(BUILDER_DO) destroy

# Configure build environment
config:	clean environment
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	$(eval TMP := $(shell mktemp $(BUILDER)/$(CONFIG_FILE).XXXXXX.tmp))

	# Export variables to config/digabi.local (which is read by auto/config, auto/build)
	echo 'COMMIT="$(COMMIT)"' >>$(TMP)
	echo 'ROOT_PASSWORD="$(ROOT_PASSWORD)"' >>$(TMP)
	echo 'BINARY_IMAGES="$(BINARY_IMAGES)"' >>$(TMP)
	echo 'ARCH="$(ARCH)"' >>$(TMP)
	echo 'DEBIAN_MIRROR="$(DEBIAN_MIRROR)"' >>$(TMP)
	echo 'DIGABI_DEBUG="$(DIGABI_DEBUG)"' >>$(TMP)
	echo 'BUILD_TAG="$(BUILD_TAG)"' >>$(TMP)
	echo 'DIGABI_BUILD_TARGET="$(DIGABI_BUILD_TARGET)"' >>$(TMP)

	$(BUILDER_DO) run COMMAND='$(VM_ENVIRONMENT) ; if [ ! -d $(BUILD_DIR) ] ; then git clone $(GIT_REPOSITORY) $(BUILD_DIR) ; else cd $(BUILD_DIR) ; git checkout $(COMMIT) ; fi'
	$(BUILDER_DO) run COMMAND='$(VM_ENVIRONMENT) ; cd $(BUILD_DIR) && git submodule init && git submodule update'

	$(BUILDER_DO) run COMMAND='$(VM_ENVIRONMENT) ; cat /$(BUILDER)/$(shell basename $(TMP)) >> $(BUILD_CONFIG)'

	rm $(TMP)

	$(BUILDER_DO) run COMMAND='cd $(BUILD_DIR) && lb config'

halt:
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	$(BUILDER_DO) halt

# Provision buildbox
provision: environment halt

# Build new image
build: config
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	$(BUILDER_DO) run COMMAND='$(VM_ENVIRONMENT) ; cd $(BUILD_DIR) && $(BUILD_ENV) sudo lb build ; mv digabi-* /$(BUILDER)/'

# Collect build artifacts (.ISO) to dist/
collect: build
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	mkdir -p $(ARTIFACTS_DIR)
	mv $(BUILDER)/digabi-os-* $(ARTIFACTS_DIR)/

# Build image & collect results
dist:	collect
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	echo "TODO"

# Build custom packages defined in ./custom-packages/*
custom-packages: environment
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	$(BUILDER_DO) run COMMAND='$(VM_ENVIRONMENT) ; if [ -d "$(BUILD_DIR)" ] ; then cd $(BUILD_DIR) ; git pull ; else git clone $(GIT_REPOSITORY) $(BUILD_DIR) ; fi'
	$(BUILDER_DO) run COMMAND='$(VM_ENVIRONMENT) ; cd $(BUILD_DIR) && git submodule init && git submodule update && BUILD_TAG="$(BUILD_TAG)" digabi os build-custom-packages'
	$(BUILDER_DO) run COMMAND='$(VM_ENVIRONMENT) ; rsync -avh $(BUILD_DIR)/custom-packages/*.deb /$(BUILDER)/$(ARTIFACTS_DIR)'
	mkdir -p $(ARTIFACTS_DIR)
	mv $(BUILDER)/$(ARTIFACTS_DIR)/*.deb $(ARTIFACTS_DIR)/

publish-packages: custom-packages
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	git submodule init
	git submodule update
	$(REPOSITORY_DO) sync-from-server
	for deb in $(ARTIFACTS_DIR)/*.deb ; do $(REPOSITORY_DO) add-package DEB="\"$$(readlink -f $${deb})\"" ; done
	$(REPOSITORY_DO) sync-to-server

# Export builder as VirtualBox Machine Image
buildbox: clean environment
	# TODO: Modify VM: remove VT-X, PAE et. all

debug: environment
	$(BUILDER_DO) run

.PHONY: custom-packages
