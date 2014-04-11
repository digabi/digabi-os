Custom Debian Packages
====================================


## Configure apt-cacher-ng
To use apt-cacher-ng as proxy, you must add following config to `/etc/apt-cacher-ng/digabi.conf`:

    Remap-digabi: digabi.fi
    PassThroughPattern: digabi\.fi:443$

After adding config, restart apt-cacher-ng: `service apt-cacher-ng restart`.


## Install required packages
    apt-get install equivs


## Create new package

    mkdir my-package && cd my-package
    mkdir debian
    equivs-control debian/control

    # create changelog (debian/changelog)
    dch --create


## Edit package

    $EDITOR debian/control
    
    # update changelog
    dch

    # mark as release
    dch --release


## Build package

    equivs-build debian/control


