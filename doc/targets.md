# Targets

Description about build targets (`target/X` directories).

Build target is configured using `DIGABI_BUILD_TARGET` variable, which includes one or more build targets, space separated list. For example

    DIGABI_BUILD_TARGET="default client meb"

which would combine three configurations. Default is *always* used, even if not added to configuration variable.

Script `auto/config` does the combining work, currently using `rsync` to copy content into `config/`, which is used by `lb build`, ie. live-build toolchain.

## default
Default configuration, that is always used as a base for creating DOS images.

## client
Client configuration, that is used when creating images for student devices.

## server
Server configuration, that is used when creating server images.

## meb
Special flavour, when creating our official images. Add some not-yet-open components to the build.
