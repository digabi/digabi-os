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

_init-vm: up
	#vagrant halt
	# TODO: Configure VM (memory, cpu, ...)
	#vagrant up

provision: _init-vm
	vagrant provision

run: _init-vm
ifndef COMMAND
	vagrant ssh
else
	vagrant ssh -c '$(COMMAND)'
endif

up:
	vagrant up

halt:
	vagrant halt

destroy:
	vagrant destroy -f

create-basebox: halt
	echo "TODO"

configure-memory: halt
	echo "TODO"

configure-cpus: halt
	echo "TODO"
