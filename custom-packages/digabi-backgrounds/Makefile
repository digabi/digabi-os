RELEASE ?= public

clean:
	rm -rf images

images:	$(RELEASE)

public:
	ln -s images.free images

private:
	git clone git@github.com:digabi/digabi-proprietary.git
	ln -s digabi-proprietary/images proprietary

install:	images
	install -d -m 0755 $(DESTDIR)/usr/share/digabi/images
	install -m 0644 images/background.svg images/digabi.svg images/splash.svg $(DESTDIR)/usr/share/digabi/images/

deb:
	debuild -us -uc	
