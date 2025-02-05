FROM debian:12.9

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y sudo kmod build-essential rsync git mtools apt-utils live-build

# Fix debootstrap umounting /proc outside chroot
# See https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=921815
RUN sed -i.bak 's/ || \[ "$CONTAINER" = "docker" ]//' /usr/share/debootstrap/scripts/debian-common

# Disable generation of default syslinux config because
# a) it is not used, and
# b) it breaks the build
RUN rm /usr/share/live/build/bootloaders/syslinux_common/live.cfg.in

COPY . /workdir
WORKDIR /workdir
