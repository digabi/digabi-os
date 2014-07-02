# -*- coding: utf-8 -*-
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Hostname of the virtual machine (must be in /etc/hosts)
VIRTUAL_MACHINE_HOSTNAME = 'jessie.vagrantup.com'

# Virtual machine memory size for in-memory builds
VM_MEMORY_FOR_RAM_BUILDS = 6 * 1024 + 512 # 6.5 GB

# Virtual machine memory size for on-disk builds
VM_MEMORY_FOR_DISK_BUILDS = 1024 # 1 GB

# Checksum for BOX
BOX_CHECKSUM = '7c4516c0cfa3b7dad11662381ccf813ad6eb0c028bc2cdd0f14784e3757cee87'
