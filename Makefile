DESTDIR=/usr/local
CFLAGS=-Wall -Wextra -g -fPIC

all: shuff.h libshuff.so

shuff.h:
	./genheader shuff.c > shuff.h

libshuff.so: shuff.o
	$(CC) -Wl,--version-script,shuff.ver -shared $^ -o libshuff.so.1

clean:
	@rm -f libshuff.so.1 shuff.o shuff.h

install: all
	install -m 644 shuff.h $(DESTDIR)/include
	install -m 755 libshuff.so.1 $(DESTDIR)/lib
	ln -s libshuff.so.1 $(DESTDIR)/lib/libshuff.so

uninstall:
	@rm -fv $(DESTDIR)/include/shuff.h
	@rm -fv $(DESTDIR)/lib/libshuff.so
	@rm -fv $(DESTDIR)/lib/libshuff.so.1
