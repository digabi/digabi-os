Custom Debian repository management (using reprepro)
=====================================

## Create GPG keys
   gpg --gen-key
   gpg -a --export <key-id> >repository-signing-key.asc

(Distribute repository-signing-key.asc.)

## Install required packages
    apt-get install reprepro
