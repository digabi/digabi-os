VERSION = $(shell git describe)

all:	config build

config:	clean
	lb config

build:
	sudo lb build

clean:
	sudo lb clean --all --purge

bclean:
	find config -type f -name "*~" -exec rm {} \;

collect_iso:
	ISO_FILENAME = digabi-livecd-$(VERSION).iso
	mv binary.hybrid.iso $(ISO_FILENAME)
	md5sum $(ISO_FILENAME) >$(ISO_FILENAME).md5sum

	gpg -a --detach-sign $(ISO_FILENAME)

collect_config:
	CONFIG_FILENAME = digabi-livecd_config-$(VERSION).tar.xz
	tar --exclude-backups -cvJf $(CONFIG_FILENAME) config
	gpg -a --detach-sign $(CONFIG_FILENAME)

dist:	config build collect_iso collect_config

pub:	dist
	mv digabi-livecd* /public/www/
