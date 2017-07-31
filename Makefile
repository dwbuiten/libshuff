DESTDIR=/usr/local
CFLAGS=-Wall -Wextra -g -O3 -fPIC

all: shuff.h libshuff.so

shuff.h:
	./genheader shuff.c > shuff.h

libshuff.so: shuff.o
	$(CC) -Wl,--version-script,shuff.ver -shared $^ -o libshuff.so.1

clean:
	@rm -f libshuff.so.1 shuff.o shuff.h unit

install-header: shuff.h
	install -m 644 shuff.h $(DESTDIR)/include

install: all
	install -m 644 shuff.h $(DESTDIR)/include
	install -m 755 libshuff.so.1 $(DESTDIR)/lib
	ln -s libshuff.so.1 $(DESTDIR)/lib/libshuff.so

check: shuff.h
	$(CC) -g -O0 -Wall -Wextra -o unit -I. unit.c
	./unit

uninstall-header:
	@rm -v $(DESTDIR)/include/shuff.h

uninstall:
	@rm -fv $(DESTDIR)/include/shuff.h
	@rm -fv $(DESTDIR)/lib/libshuff.so
	@rm -fv $(DESTDIR)/lib/libshuff.so.1
