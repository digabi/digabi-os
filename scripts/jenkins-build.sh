#!/bin/sh

set -e

git submodule init
git submodule update

cleanup() {
    vagrant destroy -f || true
}

rm -rf dist
vagrant plugin list | grep -q proxyconf || vagrant plugin install 
vagrant-proxyconf
vagrant up --provision
#vagrant up



trap cleanup EXIT

rm config/hooks/0001-git-status.pre-build
repo_ip=$(avahi-resolve -4 -n renki.local | cut -f2)
vagrant ssh -c "sudo apt-get -y install rsync"
vagrant ssh -c "sudo rsync -Pav --delete /vagrant/ /home/vagrant/build-live/ && REPOSITORY=http://${repo_ip}/debian/ make -C /home/vagrant/build-live/ dist && rsync -Pav --delete /home/vagrant/build-live/dist/ /vagrant/dist/"
status=$?
vagrant halt

exit ${status}
