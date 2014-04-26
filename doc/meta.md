# Meta (/var/lib/digabi)
=======================================

Metadata that is going to be included in live environment.

TODO: digabi meta -script, that reads these files.



## /var/lib/digabi/version
Version information. This file will replace `/etc/digabi-version`.

### File Format

    version-number

#### Example

    14.05a1+af9gaa_201404261112.dev


## /var/lib/digabi/builder
Details about the build environment for this image. (Hostname, UUID for the build machine.)

### File Format

    uuid
    hostname


#### Example

    2658abc0-cd2b-11e3-9c1a-0800200c9a66
    myownbuildbox

