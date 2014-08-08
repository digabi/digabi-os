all:

clean:

install:
	install -m 0644 debug.list $(DESTDIR)/usr/share/doc/digabi-os-debug/digabi-os-debug.list

deb:
	touch authorized_keys
	equivs-build debian/control
