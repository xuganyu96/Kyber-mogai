OPENSSLDIR = /opt/homebrew/Cellar/openssl@3/3.3.1
CC = /usr/bin/cc


# Flags copied from kyber/ref/Makefile
KYBERDIR = kyber/ref
KYBERSOURCES = $(KYBERDIR)/kem.c $(KYBERDIR)/indcpa.c $(KYBERDIR)/polyvec.c $(KYBERDIR)/poly.c $(KYBERDIR)/ntt.c $(KYBERDIR)/cbd.c $(KYBERDIR)/reduce.c $(KYBERDIR)/verify.c $(KYBERDIR)/randombytes.c
KYBERSOURCESKECCAK = $(KYBERSOURCES) $(KYBERDIR)/fips202.c $(KYBERDIR)/symmetric-shake.c
KYBERHEADERS = $(KYBERDIR)/params.h $(KYBERDIR)/kem.h $(KYBERDIR)/indcpa.h $(KYBERDIR)/polyvec.h $(KYBERDIR)/poly.h $(KYBERDIR)/ntt.h $(KYBERDIR)/cbd.h $(KYBERDIR)/reduce.c $(KYBERDIR)/verify.h $(KYBERDIR)/symmetric.h
KYBERHEADERSKECCAK = $(KYBERHEADERS) $(KYBERDIR)/fips202.h
CFLAGS += -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
  -Wshadow -Wpointer-arith -O3 -fomit-frame-pointer 
NISTFLAGS += -Wno-unused-result -O3 -fomit-frame-pointer
RM = /bin/rm

SOURCES = $(KYBERSOURCESKECCAK) authenticators.c etm.c $(OPENSSLDIR)/lib/libcrypto.a
HEADERS = $(KYBERHEADERSKECCAK) authenticators.h etm.h

.PHONY: test clean

main: $(SOURCES) $(HEADERS) main.c
	$(CC) $(CFLAGS) $(SOURCES) main.c -o $@

test: \
	test/test_authenticators \
	test/test_etm
	./test/test_authenticators
	./test/test_etm
	echo "Ok"

test/test_authenticators: $(SOURCES) $(HEADERS) test/test_authenticators.c
	$(CC) $(CFLAGS) $(SOURCES) test/test_authenticators.c -o $@

test/test_etm: $(SOURCES) $(HEADERS) test/test_etm.c
	$(CC) $(CFLAGS) $(SOURCES) test/test_etm.c -o $@

clean:
	$(RM) -f main
	$(RM) -f test/test_authenticators
	$(RM) -f test/test_etm
