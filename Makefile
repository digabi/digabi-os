VERSION = $(shell git describe --tags --long)_$(shell date +%Y%m%d%H%M%S)

ISO_FILE = binary.hybrid.iso

FILENAME_PREFIX = digabi-livecd

all:	config build

config:	clean
	exec scripts/*.config
	lb config

build:
	sudo lb build

clean:
	exec scripts/*.clean
	sudo lb clean --all

bclean:
	find config -type f -name "*~" -exec rm {} \;

collect_iso:
	mkdir -p dist

	mv $(ISO_FILE) $(FILENAME_PREFIX)-$(VERSION).iso
	#md5sum $(FILENAME_PREFIX)-$(VERSION) >$(FILENAME_PREFIX)-$(VERSION).md5sum
	mv $(FILENAME_PREFIX)-$(VERSION).iso dist/
	#gpg -a --detach-sign $() # TODO

collect_config:
	mkdir -p dist
	tar --exclude-backups -cvJf dist/$(FILENAME_PREFIX)_config-$(VERSION).tar.xz config
	#gpg -a --detach-sign $(CONFIG_FILENAME)

collect_logs:
	mkdir -p dist
	gzip build.log
	mv build.log.gz dist/$(FILENAME_PREFIX)_build-$(VERSION).log.gz

collect_info:
	mkdir -p dist
	tar -cvJf dist/$(FILENAME_PREFIX)_logs-$(VERSION).tar.xz chroot.packages.install binary.contents binary.packages chroot.packages.live

dist:	clean config build collect_iso collect_config collect_logs collect_info
	
