VERSION = $(shell git describe)

all:	config build

config:	clean
	lh config

build:
	sudo lh build

clean:
	sudo lh clean

dist:	config build
	mv binary.hybrid.iso digabi-livecd-$(VERSION).iso
	tar --exclude-backups -cvJf digabi-livecd_config-$(VERSION).tar.xz config