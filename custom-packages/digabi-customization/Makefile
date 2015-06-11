all:

install:
	install -D -m 0644 configure-desktop $(DESTDIR)/usr/lib/digabi/scripts/configure-desktop
	install -D -m 0755 digabi-panel-color $(DESTDIR)/usr/bin/digabi-panel-color
	install -D -m digabi-xfconf.desktop $(DESTDIR)/etc/xdg/autostart/digabi-xfconf.desktop

deb:
	dpkg-buildpackage -us -uc
