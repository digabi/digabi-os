KERNEL_VERSION = 3.2.48
KERNEL_SOURCE_DIR = linux-$(KERNEL_VERSION)
REVISION = $(shell date +%Y%m%d%H%M%S)

all:	clean	build

config:
	cd $(KERNEL_SOURCE_DIR)
	make menuconfig

clean:
	cd $(KERNEL_SOURCE_DIR)
	fakeroot make-kpkg clean

build:
	fakeroot make-kpkg --initrd --revision $(REVISION) kernel_image kernel_headers kernel_source

init:
	echo ""
	# TODO: prepare-linux-source

dist:	build
	echo "kk"
	# TODO

#VERSION = $(shell git describe)_$(shell date +%s)	
