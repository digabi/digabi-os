FROM debian:10.4

ARG DEBIAN_FRONTEND=noninteractive

RUN echo 'APT::Default-Release "buster";' > /etc/apt/apt.conf.d/99defaultrelease
RUN echo 'deb     http://ftp.de.debian.org/debian/    bullseye main contrib non-free' > /etc/apt/sources.list.d/bullseye.list

RUN apt-get update && apt-get install -y sudo kmod build-essential rsync git mtools apt-utils && apt-get -t bullseye install -y live-build

COPY . /workdir
WORKDIR /workdir
