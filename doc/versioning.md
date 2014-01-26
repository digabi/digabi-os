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


## New version numbering (year.month.day.revision)
Since December 2013, new versioning scheme was introduced. Follows Ubuntu pattern: `(year - 2000).(month).(day)`. See file `scripts/version.helper` for technical details.

 - 13.12 Extinct Western Black Rhinoceros
 - 14.01

Since 14.01.XX version number has been available in .ISO images, file 
`/etc/digabi-version`. In terminal you can use command `digabi 
version` to check version number.

Currently the full format of .ISO image versions is

    v14.01.21+dev-e566cec_20140121111949

where `14.01.21` is the compilation date, in this example 21th of 
January  2014. `+dev` is the git branch in which compilation was made. 
No branch, if built from `master`. `e566cec` is the git commit from which this image 
has been built `20140121111949` is timestamp, when build was started.
