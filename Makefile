VERSION = $(shell git describe)
ISO_FILE = "binary.hybrid.iso"

FILENAME_PREFIX = "digabi-livecd"

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
	mv $(ISO_FILE) $(FILENAME_PREFIX)-$(VERSION).iso
	md5sum $(FILENAME_PREFIX)-$(VERSION) >$(FILENAME_PREFIX)-$(VERSION).md5sum

	#gpg -a --detach-sign $() # TODO

collect_config:
	tar --exclude-backups -cvJf $(FILENAME_PREFIX)_config-$(VERSION).tar.xz config
	#gpg -a --detach-sign $(CONFIG_FILENAME)

dist:	config build collect_iso collect_config

pub:	dist
    mkdir -p dist/
	mv digabi-livecd* dist/

test:	clean build
    # TODO: If not exists
    mkdir -p dist
	mv $(ISO_FILE) dist/
