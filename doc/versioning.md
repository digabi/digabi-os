Versioning
============================================
All public releases do have a codename, based on animals, in format `(IUCN vulnerability status) (English name for species)`.

## Creating codename

 1. Pick an animal
 2. Check its IUCN vulnerability status
 3. ...
 4. Profit!

## Initial releases
First versions, released in Autumn 2013, were numbered as `1.x` and `2.x`.

 - 0.0 Unknown Umbrella Bird: default version for unconfigured build
 - 1.0 Endangered Saimaa ringed seal: first public release, August 2013
 - 2.0 Least Concern Daubenton's Bat: misc improvements, never officially released


## Version numbering (year.month.day.revision)
Since December 2013, new versioning scheme was introduced. Follows Ubuntu pattern: `(year - 2000).(month)`. See file `scripts/version.helper` for technical details. Version changes when new features are added.

 - 13.12 Extinct Western Black Rhinoceros
 - 14.04

Since v14.01 version number has been available in .ISO images, see file 
`/etc/digabi-version`. In terminal you can use command `digabi 
version` to check version number.


At build-time version number is determined with script `scripts/version.helper`.

Currently the full format of .ISO image versions is (OUTDATED!)

    version+gitbranch-gitcommit_timestamp

Example

    v14.01.21+dev-e566cec_20140121111949

where `14.01.21` is the compilation date, in this example 21th of 
January  2014. `+dev` is the git branch in which compilation was made. 
No branch, if built from `master`. `e566cec` is the git commit from which this image 
has been built `20140121111949` is timestamp, when build was started.

Git branch is available only for unofficial images, usually containing new features and intented only for testing.

For official releases there is git tag for that commit, and version number is in format

    version_gitcommit_timestamp

For beta releases (experimental, only for testing purposes)

    v14.03b1_abcdef_2014...
    v14.03b2_abcdee_2014...

For stable releases (for end-users, these have cool codenames)

    v14.03_abcdef_20140309120315
    v14.04_defaaa_2014...

For updates (fixes bugs in release)

    v14.03r1_abcdef_2014...
    v14.03r2_defabc_2014...

Beta releases introduce new features. Releases include only stable versions of new features, and updates fix bugs in releases.
