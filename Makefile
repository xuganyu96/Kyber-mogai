OPENSSLDIR = /opt/homebrew/Cellar/openssl@3/3.3.1
CC = /usr/bin/cc


KYBERDIR = kyber/ref
KYBERSOURCES = $(KYBERDIR)/kem.c $(KYBERDIR)/indcpa.c $(KYBERDIR)/polyvec.c $(KYBERDIR)/poly.c $(KYBERDIR)/ntt.c $(KYBERDIR)/cbd.c $(KYBERDIR)/reduce.c $(KYBERDIR)/verify.c $(KYBERDIR)/randombytes.c
KYBERSOURCESKECCAK = $(KYBERSOURCES) $(KYBERDIR)/fips202.c $(KYBERDIR)/symmetric-shake.c
KYBERHEADERS = $(KYBERDIR)/params.h $(KYBERDIR)/kem.h $(KYBERDIR)/indcpa.h $(KYBERDIR)/polyvec.h $(KYBERDIR)/poly.h $(KYBERDIR)/ntt.h $(KYBERDIR)/cbd.h $(KYBERDIR)/reduce.c $(KYBERDIR)/verify.h $(KYBERDIR)/symmetric.h
KYBERHEADERSKECCAK = $(KYBERHEADERS) $(KYBERDIR)/fips202.h

CFLAGS += -I$(OPENSSLDIR)/include
SOURCE = $(KYBERSOURCESKECCAK) authenticators.c etm.c $(OPENSSLDIR)/lib/libcrypto.a
HEADERS = $(KYBERHEADERSKECCAK) authenticators.h etm.h

main:
	$(CC) $(SOURCE) $(CFLAGS) main.c -o $@
	./main

test:
	$(CC) $(SOURCE) $(CFLAGS) tests/test_authenticators.c -o tests/test_authenticators
	./tests/test_authenticators

clean:
	rm main
