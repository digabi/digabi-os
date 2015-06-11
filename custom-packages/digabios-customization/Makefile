REPOSITORY ?= digabi-proprietary
CONTENT_DIR = $(REPOSITORY)/images
IMAGEDIR = /usr/share/images/digabios-backgrounds

all:

clean:

$(REPOSITORY):
	git clone git@github.com:digabi/digabi-proprietary.git $(REPOSITORY)

$(CONTENT_DIR): $(REPOSITORY)

install: $(CONTENT_DIR)
	install -D -m 0644 configure-desktop $(DESTDIR)/usr/lib/digabi/scripts/configure-desktop
	install -D -m 0755 digabi-panel-color $(DESTDIR)/usr/bin/digabi-panel-color
	install -D -m 0644 digabi-xfconf.desktop $(DESTDIR)/etc/xdg/autostart/digabi-xfconf.desktop
	
	install -d -m 0755 $(DESTDIR)$(IMAGEDIR)
	install -D -m 0644 $(CONTENT_DIR)/background.svg $(CONTENT_DIR)/digabi.svg $(CONTENT_DIR)/splash.svg $(DESTDIR)$(IMAGEDIR)/

deb:
	dpkg-buildpackage -us -uc
