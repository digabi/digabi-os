Miscellaneous
===================================
Misc. things to remember.

## Environment Variables
    export DEBFULLNAME="Your Name"
    export DEBEMAIL="your@email"


## Tool for symlinking latest .ISO (for website, for VirtualBox testing)
    if [ -f latest.iso ]; then rm latest.iso ; fi && ln -s `ls -lt digabi-livecd_*.iso |head -n 1 |awk '{print $9}'` latest.iso

## Debian changelog
Create new changelog inside package

    dch --create -c changelog

Update changelog (create new version, or modify unreleased)

    dch -c changelog

Release

    dch -r --distribution stable -c changelog
