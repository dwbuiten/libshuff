DESTDIR=/usr/local
CFLAGS=-Wall -Wextra -g -fPIC

all: shuff.h libshuff.so

shuff.h:
	./genheader shuff.c > shuff.h

libshuff.so: shuff.o
	$(CC) -Wl,--version-script,shuff.ver -shared $^ -o libshuff.so

clean:
	rm -f libshuff.so shuff.o shuff.h

install: all
	install -m 644 shuff.h $(DESTDIR)/include
	install -m 755 libshuff.so $(DESTDIR)/lib

uninstall:
	rm -f $(DESTDIR)/include/shuff.h
	rm -f $(DESTDIR)/lib/libshuff.so
