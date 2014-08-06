Miscellaneous
===================================
Misc. things to remember.

## Environment Variables
    export DEBFULLNAME="Your Name"
    export DEBEMAIL="your@email"


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


## SourceForge

    sftp user,digabi@frs.sf.net:/home/frs/project/d/di/digabi
