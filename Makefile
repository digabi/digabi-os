#
# Makefile for digabi-os
#
# (c) 2013-2015 Ylioppilastutkintolautakunta / The Matriculation Examination Board of Finland
# <https://www.ylioppilastutkinto.fi/>
# <https://digabi.fi/>
#
# Author: Ville Korhonen <ville.korhonen@ylioppilastutkinto.fi>
#

#
# User-configurable variables
#
DIGABI_BUILD_CPUS ?= 1
DIGABI_BUILD_MEM ?= 1024

HTTP_PROXY ?= $(http_proxy)
ROOT_PASSWORD ?=

VAGRANT_DEFAULT_PROVIDER ?= virtualbox

#
# Other configuration
#

ROOT_CMD = sudo
REPOSITORY = custom-packages/digabi-repository

ARTIFACTS_DIR = dist
ARTIFACTS_MOUNT = /artifacts/
CONFIG_FILE = dos-config

BUILD_CONFIG = $(BUILD_DIR)/target/default/digabi.local

VM_ENVIRONMENT ?= set -e ; [ -f "/vagrant/$(CONFIG_FILE)" ] && source /vagrant/$(CONFIG_FILE)
VAGRANT  = vagrant

STAGE = .stage

#
# Targets
#
.DEFAULT_GOAL = dist


$(STAGE)/environment:
	@echo "Create artifacts dir..."
	mkdir -p $(ARTIFACTS_DIR)
	@echo "Provision vagrant..."
	-vagrant box update
	vagrant up --provider=$(VAGRANT_DEFAULT_PROVIDER) --provision
	mkdir -p $(STAGE)
	touch $(STAGE)/environment

up: $(STAGE)/environment
	vagrant up

# Clean build environment
clean: $(STAGE)/environment up
	$(VAGRANT) ssh -c 'if [ -d "$(BUILD_DIR)" ] ; then sudo rm -rf "$(BUILD_DIR)" ; fi'
	mkdir -p $(STAGE)
	rm -f $(STAGE)/build* $(STAGE)/config
	touch $(STAGE)/clean

# Remove builder (destroys virtual machine)
purge:
	@echo "Purge..."
	$(VAGRANT) destroy -f || exit 0
	rm -rf $(STAGE)

# Configure build environment
$(STAGE)/config: $(STAGE)/environment up signing_key.priv
	@echo "Configure build environment..."
	./scripts/create-build-config.sh >$(CONFIG_FILE)
	$(VAGRANT) ssh -c '/vagrant/scripts/configure-vm.sh'
	$(VAGRANT) ssh -c 'mkdir digabi-os/config/signing_keys/ && cp /vagrant/signing_key.* digabi-os/config/signing_keys/'

	mkdir -p $(STAGE)
	touch $(STAGE)/config
	rm -f $(STAGE)/build $(STAGE)/clean

signing_key.priv:
	@echo "Need kernel module signing keys, please provide"
	false

config: $(STAGE)/config

# Build new image
$(STAGE)/build: $(STAGE)/config up
	@echo "Build image..."
	$(VAGRANT) ssh -c '/vagrant/scripts/build-vm.sh'
	mkdir -p $(STAGE)
	touch $(STAGE)/build

build-kernel: $(STAGE)/environment up
	@echo "Prepare environment..."
	$(VAGRANT) ssh -c '$(VM_ENVIRONMENT) ; printf "deb http://ftp.fi.debian.org/debian experimental main\ndeb-src http://ftp.fi.debian.org/debian experimental main\n" | sudo tee -a /etc/apt/sources.list'
	$(VAGRANT) ssh -c '$(VM_ENVIRONMENT) ; sudo apt-get update && apt-get -t experimental source linux'
	@echo "Enable module signing"
	$(VAGRANT) ssh -c 'cd linux-* && patch -p1 < /vagrant/patches/module-sign.diff'
	$(VAGRANT) ssh -c 'cd linux-* && sed -i "s/\(^abiname.*\)/\1.ytl/" debian/config/defines'
	@echo "Increment package version..."
	$(VAGRANT) ssh -c 'cd linux-* && debchange --local digabi$(shell date +%Y%m%d%H%M%S) "Automated build by CI (dos-kernel)."'
	$(VAGRANT) ssh -c 'cd linux-* && EDITOR=/bin/true dpkg-source -q --commit . ytl'
	@echo "Try building. First build fails after updating version, so ignore the fail..."
	$(VAGRANT) ssh -c 'cd linux-* && debuild-pbuilder -us -uc -j$(DIGABI_BUILD_CPUS) || exit 0'
	@echo "Now building packages..."
	$(VAGRANT) ssh -c 'cd linux-* && debuild-pbuilder -us -uc -j$(DIGABI_BUILD_CPUS)'
	#$(VAGRANT) ssh -c '$(VM_ENVIRONMENT) ; cd linux-* && fakeroot make -j$(DIGABI_BUILD_CPUS) -f debian/rules.gen binary-arch_i386_none_686-pae'
	#$(VAGRANT) ssh -c '$(VM_ENVIRONMENT) ; cd linux-* && fakeroot make -j$(DIGABI_BUILD_CPUS) -f debian/rules.gen binary-arch_amd64_none_none'
	$(VAGRANT) ssh -c '$(VM_ENVIRONMENT) ; mv *.deb *.dsc *.changes *.xz $(ARTIFACTS_MOUNT)'

package: $(STAGE)/environment up
	$(VAGRANT) ssh -c '$(VM_ENVIRONMENT) ; sudo apt-get update && apt-get source $(PACKAGE) && cd $(PACKAGE)-* && debchange --local "+ypcs$(BUILD_NUMBER)" "Automatic CI build." && debuild-pbuilder -j$(DIGABI_BUILD_CPUS) -us -uc'
	$(VAGRANT) ssh -c '$(VM_ENVIRONMENT) ; mv *.deb *.dsc *.changes *.xz $(ARTIFACTS_MOUNT)'

build: $(STAGE)/build

# Collect build artifacts (.ISO) to dist/
$(STAGE)/collect: $(STAGE)/build
	touch $(STAGE)/collect

# Build image & collect results
dist:	$(STAGE)/collect

debug: $(STAGE)/environment
	$(VAGRANT) ssh || exit 0
