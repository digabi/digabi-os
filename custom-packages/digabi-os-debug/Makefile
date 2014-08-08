all:

clean:

install:
	touch authorized_keys

	# Install template for sources.list
	install -D -m 644 digabi-os-debug.list $(DESTDIR)/usr/share/doc/digabi-os-debug/digabi-os-debug.list

	# Install digabi-debug binary
	install -D -m 755 digabi-os-debug $(DESTDIR)/usr/bin/digabi-os-debug

	# Install firewall rules
	install -D -m 644 5500-allow-ssh-in.conf $(DESTDIR)/etc/digabi/firewall.d/5500-allow-ssh-in.conf

	# Install sudo rules
	install -D -m 600 digabi-os-debug.sudoers $(DESTDIR)/etc/sudoers.d/digabi-os-debug

	# Install authorized_keys to skeleton
	install -D -m 644 authorized_keys $(DESTDIR)/etc/skel/.ssh/authorized_keys

deb:
	debuild -us -uc
