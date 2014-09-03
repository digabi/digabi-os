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
BUILD_DIR = digabi-os.$(BUILD_NUMBER)
BUILD_NUMBER ?= unknown
BUILDER = vagrant
GIT_REPOSITORY = /digabi-os.git
ARTIFACTS_DIR = dist
CONFIG_FILE = digabi.local

BUILD_CONFIG = $(BUILD_DIR)/target/default/$(CONFIG_FILE)

VM_ENVIRONMENT ?= set -ex

# Helper for running targets in another Makefile (default: vagrant/Makefile)
BUILDER_DO  = $(MAKE) -C $(BUILDER)
REPOSITORY_DO = $(MAKE) -C $(REPOSITORY)

STAGE = .stage

#
# Targets
#
.DEFAULT_GOAL = dist


$(STAGE)/environment:
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	$(BUILDER_DO) up
	$(BUILDER_DO) provision
	mkdir -p $(STAGE)
	touch $(STAGE)/environment


# Clean build environment
bclean: $(STAGE)/environment
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	$(BUILDER_DO) run COMMAND='if [ -d "$(BUILD_DIR)" ] ; then sudo rm -rf "$(BUILD_DIR)" ; fi'
	mkdir -p $(STAGE)
	rm -f $(STAGE)/build* $(STAGE)/config
	touch $(STAGE)/clean

# Remove builder (destroys virtual machine)
purge:
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	$(BUILDER_DO) destroy
	rm -rf $(STAGE)

# Configure build environment
$(STAGE)/config:	bclean $(STAGE)/environment
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	$(eval TMP := $(shell mktemp $(BUILDER)/$(CONFIG_FILE).XXXXXX))

	# Export variables to config/digabi.local (which is read by auto/config, auto/build)
	echo 'COMMIT="$(COMMIT)"' >>$(TMP)
	echo 'ROOT_PASSWORD="$(ROOT_PASSWORD)"' >>$(TMP)
	echo 'BINARY_IMAGES="$(BINARY_IMAGES)"' >>$(TMP)
	echo 'ARCH="$(ARCH)"' >>$(TMP)
	echo 'DEBIAN_MIRROR="$(DEBIAN_MIRROR)"' >>$(TMP)
	echo 'DIGABI_DEBUG="$(DIGABI_DEBUG)"' >>$(TMP)
	echo 'BUILD_TAG="$(BUILD_TAG)"' >>$(TMP)
	echo 'BUILD_NUMBER="$(BUILD_NUMBER)"' >>$(TMP)
	echo 'DIGABI_BUILD_TARGET="$(DIGABI_BUILD_TARGET)"' >>$(TMP)

	$(BUILDER_DO) run COMMAND='$(VM_ENVIRONMENT) ; if [ ! -d $(BUILD_DIR) ] ; then git clone $(GIT_REPOSITORY) $(BUILD_DIR) ; else cd $(BUILD_DIR) ; git checkout $(COMMIT) ; fi'
	$(BUILDER_DO) run COMMAND='$(VM_ENVIRONMENT) ; cd $(BUILD_DIR) && git submodule init && git submodule update'

	$(BUILDER_DO) run COMMAND='$(VM_ENVIRONMENT) ; cat /$(BUILDER)/$(shell basename $(TMP)) >> $(BUILD_CONFIG)'

	rm $(TMP)

	$(BUILDER_DO) run COMMAND='cd $(BUILD_DIR) && lb config'
	mkdir -p $(STAGE)
	touch $(STAGE)/config
	rm -f $(STAGE)/build $(STAGE)/bclean

config: $(STAGE)/config
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.

$(STAGE)/halt:
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	$(BUILDER_DO) halt
	mkdir -p $(STAGE)
	touch $(STAGE)/halt

halt: $(STAGE)/halt
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.

# Provision buildbox
provision: $(STAGE)/environment halt
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.

# Build new image
$(STAGE)/build: $(STAGE)/config
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	$(BUILDER_DO) run COMMAND='$(VM_ENVIRONMENT) ; cd $(BUILD_DIR) && $(BUILD_ENV) sudo lb build ; mv digabi-* /$(BUILDER)/'
	mkdir -p $(STAGE)
	touch $(STAGE)/build

$(STAGE)/build-bootstrap: $(STAGE)/config
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	$(BUILDER_DO) run COMMAND='$(VM_ENVIRONMENT) ; cd $(BUILD_DIR) && $(BUILD_ENV) sudo lb bootstrap'
	mkdir -p $(STAGE)
	touch $(STAGE)/build-bootstrap

$(STAGE)/build-chroot: $(STAGE)/build-bootstrap
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	$(BUILDER_DO) run COMMAND='$(VM_ENVIRONMENT) ; cd $(BUILD_DIR) && $(BUILD_ENV) sudo lb chroot'
	mkdir -p $(STAGE)
	touch $(STAGE)/build-chroot

$(STAGE)/build-binary: $(STAGE)/build-chroot
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	$(BUILDER_DO) run COMMAND='$(VM_ENVIRONMENT) ; cd $(BUILD_DIR) && $(BUILD_ENV) sudo lb binary ; mv digabi-* /$(BUILDER)/'
	mkdir -p $(STAGE)
	touch $(STAGE)/build-binary
	rm -f $(STAGE)/collect

bbuild: $(STAGE)/build
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.

build:

# Collect build artifacts (.ISO) to dist/
$(STAGE)/collect: build
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	mkdir -p $(ARTIFACTS_DIR)
	mv $(BUILDER)/digabi-os-* $(ARTIFACTS_DIR)/
	touch $(STAGE)/collect

# Build image & collect results
ddist:	$(STAGE)/collect
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.

# Build custom packages defined in ./custom-packages/*
$(STAGE)/custom-packages: $(STAGE)/environment
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	$(BUILDER_DO) run COMMAND='$(VM_ENVIRONMENT) ; if [ -d "$(BUILD_DIR)" ] ; then cd $(BUILD_DIR) ; git pull ; else git clone $(GIT_REPOSITORY) $(BUILD_DIR) ; fi'
	$(BUILDER_DO) run COMMAND='$(VM_ENVIRONMENT) ; cd $(BUILD_DIR) && git submodule init && git submodule update && BUILD_TAG="$(BUILD_TAG)" digabi os build-custom-packages'
	$(BUILDER_DO) run COMMAND='$(VM_ENVIRONMENT) ; rsync -avh $(BUILD_DIR)/custom-packages/*.deb /$(BUILDER)/$(ARTIFACTS_DIR)'
	mkdir -p $(ARTIFACTS_DIR)
	mv $(BUILDER)/$(ARTIFACTS_DIR)/*.deb $(ARTIFACTS_DIR)/
	mkdir -p $(STAGE)
	touch $(STAGE)/custom-packages

publish-packages: $(STAGE)/custom-packages
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	git submodule init
	git submodule update
	$(REPOSITORY_DO) sync-from-server
	for deb in $(ARTIFACTS_DIR)/*.deb ; do $(REPOSITORY_DO) add-package DEB="\"$$(readlink -f $${deb})\"" ; done
	$(REPOSITORY_DO) sync-to-server

# Export builder as VirtualBox Machine Image
buildbox: bclean $(STAGE)/environment
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	# TODO: Modify VM: remove VT-X, PAE et. all

debug: $(STAGE)/environment
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	$(BUILDER_DO) run || exit 0

.PHONY: custom-packages
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
