Custom Debian Packages
====================================



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


