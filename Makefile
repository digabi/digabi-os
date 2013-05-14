VERSION = $(shell git describe)

all:	config build

config:	clean
	lh config

build:
	sudo lh build

clean:
	sudo lh clean --all --purge

dist:	config build
	mv binary.hybrid.iso digabi-livecd-$(VERSION).iso
	md5sum digabi-livecd-$(VERSION).iso >digabi-livecd-$(VERSION).md5sum

	tar --exclude-backups -cvJf digabi-livecd_config-$(VERSION).tar.xz config

	gpg -a --detach-sign digabi-livecd-$(VERSION).iso