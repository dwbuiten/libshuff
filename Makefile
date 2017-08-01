DESTDIR=/usr/local
CFLAGS=-Wall -Wextra -g -O3 -fPIC

all: shuff.h libshuff.so shuff.pc shuff-header.pc

shuff.pc:
	sed -e "s#\\\$$PREFIX#$(DESTDIR)#" shuff.pc.in > shuff.pc

shuff-header.pc:
	sed -e "s#\\\$$PREFIX#$(DESTDIR)#" -e "s#^Libs:.\+\$$#Libs:#" shuff.pc.in > shuff-header.pc

shuff.h:
	./genheader shuff.c > shuff.h

libshuff.so: shuff.o
	$(CC) -Wl,--version-script,shuff.ver -shared $^ -o libshuff.so.1

clean:
	@rm -f libshuff.so.1 shuff.o shuff.h unit shuff.pc shuff-header.pc

install-header: shuff.h shuff-header.pc
	install -m 644 shuff.h $(DESTDIR)/include
	install -m 644 shuff-header.pc $(DESTDIR)/lib/pkgconfig

install: all
	install -m 644 shuff.h $(DESTDIR)/include
	install -m 755 libshuff.so.1 $(DESTDIR)/lib
	ln -s libshuff.so.1 $(DESTDIR)/lib/libshuff.so
	install -m 644 shuff.pc $(DESTDIR)/lib/pkgconfig
	install -m 644 shuff-header.pc $(DESTDIR)/lib/pkgconfig

check: shuff.h
	$(CC) -g -O3 -Wall -Wextra -o unit -I. unit.c
	./unit

uninstall-header:
	@rm -fv $(DESTDIR)/include/shuff.h
	@rm -fv $(DESTDIR)/lib/pkgconfig/shuff-header.pc

uninstall:
	@rm -fv $(DESTDIR)/include/shuff.h
	@rm -fv $(DESTDIR)/lib/libshuff.so
	@rm -fv $(DESTDIR)/lib/libshuff.so.1
	@rm -fv $(DESTDIR)/lib/pkgconfig/shuff.pc
	@rm -fv $(DESTDIR)/lib/pkgconfig/shuff-header.pc
