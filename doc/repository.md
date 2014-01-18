Custom Debian repository management (using reprepro)
=====================================

## Create GPG keys
   gpg --gen-key
   gpg -a --export <key-id> >repository-signing-key.asc

(Distribute repository-signing-key.asc.)

## Install required packages
    apt-get install reprepro


## Enabling custom repository
You can install Digabi packages to your existing desktop installation.

    echo "deb http://digabi.fi/debian jessie main contrib non-free" >/etc/apt/sources.list.d/digabi.list
    apt-key add digabi.key # TODO: Fetch GPG key via trusted channel, and remember to verify
    apt-get update

By default Digabi Live builder also uses this repository. Configuration is done in `config/archives/digabi.list.chroot` file, which contains digabi.fi repository

    deb http://digabi.fi/debian jessie main contrib non-free

Digabi public GPG key used to sign repository is in file `config/archives/digabi.key.chroot`.
