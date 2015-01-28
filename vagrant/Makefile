#
# Control Vagrant buildbox
#

# Hostname of the virtual machine (must be in /etc/hosts)
VIRTUAL_MACHINE_HOSTNAME ?= 'jessie.vagrantup.com'

# Virtual machine memory size for in-memory builds
VM_MEMORY_FOR_RAM_BUILDS ?= 6 * 1024 + 512 # 6.5 GB

# Virtual machine memory size for on-disk builds
VM_MEMORY_FOR_DISK_BUILDS ?= 1024 # 1 GB

# Checksum for BOX
BOX_CHECKSUM = '0ca8a38a5f48021c9d0a644b0f03c364b9cb4a87aa1c8727d068c1492449e0f9'

VAGRANT_DEFAULT_PROVIDER ?= virtualbox

STAGE ?= .stage

$(STAGE)/init-vm: up
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.

	vagrant up --provider=$(VAGRANT_DEFAULT_PROVIDER) --provision

	mkdir -p $(STAGE)
	touch $(STAGE)/init-vm

$(STAGE)/provision: $(STAGE)/init-vm
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	vagrant up --provider=$(VAGRANT_DEFAULT_PROVIDER) --provision
	mkdir -p $(STAGE)
	touch $(STAGE)/provision

run: $(STAGE)/init-vm up
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
ifndef COMMAND
	vagrant ssh
else
	vagrant ssh -c '$(COMMAND)' -- -n
endif

up: $(STAGE)/init-vm
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	vagrant up --provider=$(VAGRANT_DEFAULT_PROVIDER) --no-provision

halt:
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	vagrant halt

destroy:
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	vagrant destroy -f
	rm -rf $(STAGE)

create-basebox: halt
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	echo "TODO"

configure-memory: halt
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	echo "TODO"

configure-cpus: halt
	@echo D: Making $@. The prerequisites are $^. Of those, $? are newer than $@.
	echo "TODO"
