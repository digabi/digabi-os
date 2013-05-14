VERSION = $(shell git describe)

all:	config build

config:	clean
	lh config

build:
	sudo lh build

clean:
	sudo lh clean --all --purge

bclean:
	find config -type f -name "*~" -exec rm {} \;

collect_iso:
	ISO_FILENAME = digabi-livecd-$(VERSION).iso
	mv binary.hybrid.iso $(ISO_FILENAME)
	md5sum $(ISO_FILENAME) >$(ISO_FILENAME).md5sum

	gpg -a --detach-sign $(ISO_FILENAME)

collect_config:
	tar --exclude-backups -cvJf digabi-livecd_config-$(VERSION).tar.xz config

dist:	config build collect_iso collect_config