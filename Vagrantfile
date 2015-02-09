# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Hostname of the virtual machine (must be in /etc/hosts)
VIRTUAL_MACHINE_HOSTNAME = 'jessie.vagrantup.com'

# Virtual machine memory size for on-disk builds
VM_MEMORY_FOR_DISK_BUILDS = 1024 # 1 GB

if ENV['DIGABI_BUILD_MEM']
  mem_size = ENV['DIGABI_BUILD_MEM']
else
  mem_size = VM_MEMORY_FOR_DISK_BUILDS
end
cpus = ENV['DIGABI_BUILD_CPUS']

if ENV['DIGABI_NETWORK_TYPE']
  network_type = ENV['DIGABI_NETWORK_TYPE']
end

if ENV['DIGABI_NETWORK_HOST_DEV']
  network_host_dev = ENV['DIGABI_NETWORK_HOST_DEV']
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # You should be able to use *any* Debian 8 (jessie) image as your building environment
  config.vm.box = "debian-jessie64"

  config.vm.box_url = "https://cdn.ypcs.fi/vagrant/metadata.json"

  config.vm.provision "shell", inline: "sudo http_proxy='#{ENV['http_proxy']}' DEBIAN_MIRROR='#{ENV['DEBIAN_MIRROR']}' sh /vagrant/scripts/provision.sh"

  # Mount /vagrant as read-only
  config.vm.synced_folder '.', '/vagrant', :mount_options => ["ro"]

  config.vm.synced_folder '.git', '/digabi-os.git', :mount_options => ["ro"]
  config.vm.synced_folder 'dist', '/artifacts'

  if network_type == 'bridged'
    if network_host_dev
      config.vm.network "public_network", bridge: network_host_dev
    else
      config.vm.network "public_network"    
    end
#  else
#    config.vm.network "private_network", type: "dhcp"
  end

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', mem_size]
    vb.customize ['modifyvm', :id, '--cpus', cpus] unless cpus.nil?
    vb.customize ['modifyvm', :id, '--ioapic', 'on']
    vb.customize ['modifyvm', :id, '--nictype1', 'virtio']
  end

  config.vm.provider :vmware_workstation do |vmw, override|
    vmw.vmx['memsize'] = mem_size
    vmw.vmx['numvcpus'] = cpus unless cpus.nil?
  end

  config.vm.provider :vmware_fusion do |vmw, override|
    vmw.vmx['memsize'] = mem_size
    vmw.vmx['numvcpus'] = cpus unless cpus.nil?
  end
end
