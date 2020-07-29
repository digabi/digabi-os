FROM debian:10.4

RUN apt-get update && apt-get install -y live-build sudo kmod

COPY . /workdir
WORKDIR /workdir
