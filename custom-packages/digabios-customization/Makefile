REPOSITORY ?= digabi-proprietary
CONTENT_DIR = $(REPOSITORY)/images
IMAGEDIR = /usr/share/images/digabios-backgrounds

all:

clean:

$(REPOSITORY):
	git clone git@github.com:digabi/digabi-proprietary.git $(REPOSITORY)

$(CONTENT_DIR): $(REPOSITORY)

install: $(CONTENT_DIR)
	# digabi-customization
	install -D -m 0644 configure-desktop $(DESTDIR)/usr/lib/digabi/scripts/configure-desktop
	install -D -m 0755 digabi-panel-color $(DESTDIR)/usr/bin/digabi-panel-color
	install -D -m 0644 digabi-xfconf.desktop $(DESTDIR)/etc/xdg/autostart/digabi-xfconf.desktop
	
	# digabi-backgrounds
	install -d -m 0755 $(DESTDIR)$(IMAGEDIR)
	install -D -m 0644 $(CONTENT_DIR)/background.svg $(DESTDIR)$(IMAGEDIR)/background.svg
	install -D -m 0644 $(CONTENT_DIR)/digabi.svg $(DESTDIR)$(IMAGEDIR)/start-here.svg
	install -D -m 0644 $(CONTENT_DIR)/splash.svg $(DESTDIR)$(IMAGEDIR)/splash.svg
	
	# plymouth-themes-digabios
	install -d -m 0755 $(DESTDIR)/usr/share/plymouth/themes/digabios
	install -D -m 0644 plymouth/* $(DESTDIR)/usr/share/plymouth/themes/digabios
	
	# digabios-system-settings
	install -D -m 0644 xfce4-panel.xml $(DESTDIR)/etc/xdg/xfce4/panel/default.xml.digabios
	install -D -m 0644 xfwm4.xml $(DESTDIR)/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml.digabios
	install -D -m 0644 xsessionrc $(DESTDIR)/etc/skel/.xsessionrc.digabios
	install -D -m 0644 user-dirs.defaults $(DESTDIR)/etc/xdg/user-dirs.defaults.digabios
	install -D -m 0644 default-applications.list $(DESTDIR)/etc/xdg/mimeapps.list
	install -D -m 0644 locale $(DESTDIR)/etc/default/locale.digabios
	install -D -m 0644 keyboard $(DESTDIR)/etc/default/keyboard.digabios	
	install -d -m 0755 $(DESTDIR)/var/lib/live/config
	touch $(DESTDIR)/var/lib/live/config/locales
	touch $(DESTDIR)/var/lib/live/config/keyboard-configuration

deb:
	dpkg-buildpackage -us -uc
