#!/bin/sh

set -ex

cleanup() {
    vagrant destroy -f
}

mdns_resolve() {

    if which avahi-resolve > /dev/null 2>&1 ; then
        avahi-resolve -4 -n "$1" | cut -f2
        return
    fi

    if which dscacheutil > /dev/null 2>&1 ; then
        dscacheutil -q host -a name "$1" | awk '/ip_addr/ {print $2; exit}'
        return
    fi

    echo "Unable to resolve MDNS" 1>&2
    exit 42
}

renki_ip=`mdns_resolve renki.local`
ci_ip=`mdns_resolve ci.local`

proxy="http://${ci_ip}:3128"

for f in Vagrantfile Makefile scripts/vagrant-init.sh ; do
    sed -i.bak -e "s/ci.local/${ci_ip}/g" -e "s/renki.local/${renki_ip}/g" $f
    rm $f.bak
done

if which lscpu > /dev/null 2>&1 ; then
    cpus=$(lscpu |awk '/^CPU\(s\)/ {print $2}')
    if [ $cpus -ge 8 ] ; then
        sed -i.bak -e '/"--cpus"/s/"[0-9][0-9]*"/"4"/' -e '/"--memory"/s/"[0-9][0-9]*"/"4096"/' Vagrantfile
    fi
fi

rm -rf dist
vagrant plugin list | grep -q proxyconf || vagrant plugin install vagrant-proxyconf
vagrant up --provision
trap cleanup EXIT

[ -n "${renki_ip}" ]

echo "HTTP_PROXY=${proxy}/ HTTPS_PROXY=${proxy}/ http_proxy=${proxy}/ https_proxy=${proxy}/" > config/environment.chroot

vagrant ssh -c "sudo rsync -Pav --delete /vagrant/ /home/vagrant/build-live/ && REPOSITORY=http://${renki_ip}/debian/ make -C /home/vagrant/build-live/ dist && rsync -Pav --delete /home/vagrant/build-live/dist/ /vagrant/dist/"
