Miscellaneous
===================================
Misc. things to remember.

## Environment Variables
    export DEBFULLNAME="Your Name"
    export DEBEMAIL="your@email"


## Tool for symlinking latest .ISO (for website, for VirtualBox testing)
    if [ -f latest.iso ]; then rm latest.iso ; fi && ln -s `ls -lt digabi-os_*.iso |head -n 1 |awk '{print $9}'` latest.iso

## Debian changelog
Create new changelog inside package (file `debian/changelog`)

    dch --create

Update changelog (create new version, or modify unreleased)

    dch

Release

    dch --release --distribution stable


## Install Ruby Gems to user directory

    gem install --user-install <gem>


## Manage GitHub issues from command line
You can manage GitHub issues from command line using 
[ghi](https://github.com/stephencelis/ghi).

    gem install ghi
    
App looks for `upstream` remote, if that is missing, `origin`. If this 
looks like GitHub repository, you can manage issues.

    ghi --help
