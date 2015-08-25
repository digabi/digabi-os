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
	
	# digabi-backgrounds
	install -d -m 0755 $(DESTDIR)$(IMAGEDIR)
	install -D -m 0644 $(CONTENT_DIR)/background.svg $(DESTDIR)$(IMAGEDIR)/background.svg
	install -D -m 0644 $(CONTENT_DIR)/ytl_logo_helmet_black.svg $(DESTDIR)$(IMAGEDIR)/logo.svg
	install -D -m 0644 $(CONTENT_DIR)/splash.svg $(DESTDIR)$(IMAGEDIR)/splash.svg
	rsvg-convert -f png -w 121 -o $(DESTDIR)$(IMAGEDIR)/logo.png $(CONTENT_DIR)/ytl_logo_helmet_black.svg
	
	# plymouth-themes-digabios
	install -d -m 0755 $(DESTDIR)/usr/share/plymouth/themes/digabios
	install -D -m 0644 plymouth/* $(DESTDIR)/usr/share/plymouth/themes/digabios
	
	# digabios-system-settings
	install -D -m 0644 locale.gen $(DESTDIR)/etc/locale.gen.digabios
	install -D -m 0644 xfce/xfce4-panel.xml $(DESTDIR)/etc/xdg/xfce4/panel/default.xml.digabios
	install -D -m 0644 xfce/xfwm4.xml $(DESTDIR)/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml.digabios
	install -D -m 0644 xfce/xfce4-session.xml $(DESTDIR)/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml.digabios
	install -D -m 0644 xfce/xfce4-desktop.xml $(DESTDIR)/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml.digabios
	install -D -m 0644 xfce/xfce4-notifyd.xml $(DESTDIR)/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-notifyd.xml.digabios
	install -D -m 0644 xfce/xsettings.xml $(DESTDIR)/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml.digabios
	install -D -m 0644 xsessionrc $(DESTDIR)/etc/skel/.xsessionrc.digabios
	install -D -m 0644 user-dirs.defaults $(DESTDIR)/etc/xdg/user-dirs.defaults.digabios
	install -D -m 0644 default-applications.list $(DESTDIR)/etc/xdg/mimeapps.list
	install -D -m 0644 locale $(DESTDIR)/etc/default/locale.digabios
	install -D -m 0644 keyboard $(DESTDIR)/etc/default/keyboard.digabios	
	install -d -m 0755 $(DESTDIR)/var/lib/live/config
	install -D -m 0644 xfce/xfce-applications.menu $(DESTDIR)/etc/xdg/menus/xfce-applications.menu.digabios
	install -d -m 0755 $(DESTDIR)/etc/sysctl.d
	install -m 0644 sysctl.d/* $(DESTDIR)/etc/sysctl.d
	install -D -m 0755 digabi-panel-color $(DESTDIR)/usr/bin/digabi-panel-color
	install -D -m 0644 geogebra.properties $(DESTDIR)/etc/skel/.config/geogebra/geogebra.properties
	install -D -m 0644 timezone $(DESTDIR)/etc/timezone.digabios
	install -d -m 0755 $(DESTDIR)/etc/skel/.config/xfce4/panel/launcher-11
	install -m 0644 xkb/* $(DESTDIR)/etc/skel/.config/xfce4/panel/launcher-11
	install -D -m 0644 xfce/screenshotrc $(DESTDIR)/etc/skel/.config/xfce4/panel/screenshooter-10.rc
	install -D -m 0644 xfce/batteryrc $(DESTDIR)/etc/skel/.config/xfce4/panel/battery-16.rc
	touch $(DESTDIR)/var/lib/live/config/locales
	touch $(DESTDIR)/var/lib/live/config/keyboard-configuration
	install -D -m 0755 display/toggle-dpi.sh $(DESTDIR)/usr/bin/digabi-dpi
	install -D -m 0644 display/toggle-dpi.desktop $(DESTDIR)/usr/share/applications/digabi-dpi.desktop
	install -D -m 0644 iceweasel-localstore.rdf $(DESTDIR)/etc/iceweasel/profile/localstore.rdf.digabios
	install -D -m 0644 xfce/xfce-kioskrc $(DESTDIR)/etc/xdg/xfce4/kiosk/kioskrc
	install -D -m 0644 xfce/org.xfce.power.policy $(DESTDIR)/usr/share/polkit-1/actions/org.xfce.power.policy.digabios
	
	# digabios-firewall
	install -d -m 0700 $(DESTDIR)/etc/digabi/firewall.d
	install -D -m 0644 firewall/digabios-firewall.service $(DESTDIR)/lib/systemd/system/digabios-firewall.service
	install -D -m 0755 firewall/digabios-firewall.sh $(DESTDIR)/usr/sbin/digabios-firewall
	install -m 0600 firewall/rules/* $(DESTDIR)/etc/digabi/firewall.d
	
deb:
	dpkg-buildpackage -us -uc
