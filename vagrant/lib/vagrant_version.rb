require 'vagrant/version'

def vagrant_old
  version = Vagrant::VERSION.split(".")
  return version[1].to_i < 2
end
