# Makefile for PDCurses library for X11

SHELL = /bin/sh



srcdir		=.
prefix		=/usr/local
exec_prefix	=$(DESTDIR)${prefix}
libdir		=$(exec_prefix)/lib
bindir		=$(exec_prefix)/bin
includedir	=$(exec_prefix)/include
pdcursesdir	=./x11

INSTALL		=$(srcdir)/install-sh
RANLIB		=ranlib
SHLPRE = lib
SHLPST = .so
SHLFILE = XCurses

include $(srcdir)/version.mif

PDC_DIR=PDCurses-$(VERDOT)

ZIPFILE = pdcurs$(VER).zip
TARBALL = $(PDC_DIR).tar.gz

all \
clean \
distclean \
mostlyclean \
realclean ::
	cd x11; $(MAKE) $(MFLAGS) $@
	cd doc; $(MAKE) $(MFLAGS) $@

install ::
	$(INSTALL) -d -m 755 $(libdir)
	$(INSTALL) -d -m 755 $(bindir)
	$(INSTALL) -d -m 755 $(includedir)
	$(INSTALL) -d -m 755 $(includedir)/xcurses
	$(INSTALL) -c -m 644 $(srcdir)/curses.h $(includedir)/xcurses.h
	$(INSTALL) -c -m 644 $(srcdir)/curses.h $(includedir)/xcurses/curses.h
	sed -e 's/#include <curses.h>/#include <xcurses.h>/' \
		< $(srcdir)/panel.h > ./xpanel.h
	$(INSTALL) -m 644 ./xpanel.h $(includedir)/xpanel.h
	$(INSTALL) -c -m 644 $(srcdir)/panel.h $(includedir)/xcurses/panel.h
	$(INSTALL) -c -m 644 $(srcdir)/term.h $(includedir)/xcurses/term.h
	$(INSTALL) -c -m 644 $(pdcursesdir)/libXCurses.a $(libdir)/libXCurses.a
	-$(RANLIB) $(libdir)/libXCurses.a
	-$(INSTALL) -c -m 755 $(pdcursesdir)/$(SHLPRE)$(SHLFILE)$(SHLPST) \
		$(libdir)/$(SHLPRE)$(SHLFILE)$(SHLPST)
	ln -f -s $(libdir)/$(SHLPRE)$(SHLFILE)$(SHLPST) \
		$(libdir)/$(SHLPRE)Xpanel$(SHLPST)
	ln -f -s $(libdir)/libXCurses.a $(libdir)/libXpanel.a
	-$(RANLIB) $(libdir)/libXpanel.a
	$(INSTALL) -c -m 755 x11/xcurses-config $(bindir)/xcurses-config

clean ::
	rm -f config.log config.cache config.status

distclean ::
	rm -f config.log config.cache config.status
	rm -f config.h Makefile x11/xcurses-config

manual:
	cd doc; $(MAKE) $(MFLAGS) $@

$(ZIPFILE):
	zip -9y $(ZIPFILE) README HISTORY IMPLEMNT *.spec *.mif *.def \
	Makefile.in config.h.in configure configure.ac config.guess \
	config.sub x11/xcurses-config.in install-sh aclocal.m4 curses.h \
	curspriv.h panel.h term.h pdcurses/README \
	pdcurses/*.c demos/README demos/*.c demos/*.h dos/README dos/*.c \
	dos/*.h dos/*.mak dos/*.lrf os2/README os2/*.c os2/*.h os2/*.mak \
	os2/*.lrf sdl1/README sdl1/*.c sdl1/*.h sdl1/Make* \
	win32/README win32/*.c win32/*.h win32/*.mak \
	win32/*.ico win32/*.rc x11/README x11/*.c x11/*.h x11/Makefile.* \
	x11/*.xbm doc/*.txt doc/manext.c doc/Makefile

zip: $(ZIPFILE)

../$(TARBALL):
	(cd ..; tar cvf - $(PDC_DIR)/README $(PDC_DIR)/HISTORY \
	$(PDC_DIR)/IMPLEMNT $(PDC_DIR)/*.spec $(PDC_DIR)/*.mif \
	$(PDC_DIR)/*.def $(PDC_DIR)/Makefile.in $(PDC_DIR)/aclocal.m4 \
	$(PDC_DIR)/config.h.in $(PDC_DIR)/configure \
	$(PDC_DIR)/config.guess $(PDC_DIR)/x11/xcurses-config.in \
	$(PDC_DIR)/config.sub $(PDC_DIR)/configure.ac \
	$(PDC_DIR)/install-sh $(PDC_DIR)/curses.h $(PDC_DIR)/curspriv.h \
	$(PDC_DIR)/panel.h $(PDC_DIR)/term.h \
	$(PDC_DIR)/pdcurses/README $(PDC_DIR)/pdcurses/*.c \
	$(PDC_DIR)/demos/README $(PDC_DIR)/demos/*.c $(PDC_DIR)/demos/*.h \
	$(PDC_DIR)/doc/*.txt $(PDC_DIR)/dos/README $(PDC_DIR)/dos/*.c \
	$(PDC_DIR)/dos/*.h $(PDC_DIR)/dos/*.mak $(PDC_DIR)/dos/*.lrf \
	$(PDC_DIR)/os2/README $(PDC_DIR)/os2/*.c $(PDC_DIR)/os2/*.h \
	$(PDC_DIR)/os2/*.mak $(PDC_DIR)/os2/*.lrf \
	$(PDC_DIR)/sdl1/README $(PDC_DIR)/sdl1/*.c $(PDC_DIR)/sdl1/*.h \
	$(PDC_DIR)/sdl1/Make* $(PDC_DIR)/win32/README $(PDC_DIR)/win32/*.c \
	$(PDC_DIR)/win32/*.h $(PDC_DIR)/win32/*.mak \
	$(PDC_DIR)/win32/*.ico $(PDC_DIR)/win32/*.rc $(PDC_DIR)/x11/README \
	$(PDC_DIR)/x11/*.c $(PDC_DIR)/x11/*.xbm $(PDC_DIR)/x11/*.h \
	$(PDC_DIR)/x11/Makefile.* $(PDC_DIR)/doc/manext.c \
	$(PDC_DIR)/doc/Makefile | gzip -9 > $(TARBALL))

dist: ../$(TARBALL)

rpm: ../$(TARBALL)
	rpmbuild -ba $(srcdir)/PDCurses.spec
