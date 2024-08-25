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

.PHONY: test clean speed

main: $(SOURCES) $(HEADERS) main.c
	$(CC) $(CFLAGS) $(SOURCES) main.c -o $@

test: \
	test/test_authenticators \
	test/test_etm512 \
	test/test_etm768 \
	test/test_etm1024 \
	test/test_speed512 \
	test/test_speed768 \
	test/test_speed1024
	./test/test_authenticators
	./test/test_etm512
	./test/test_etm768
	./test/test_etm1024

speed: \
	test/test_speed512 \
	test/test_speed768 \
	test/test_speed1024

test/test_authenticators: $(SOURCES) $(HEADERS) test/test_authenticators.c
	$(CC) $(CFLAGS) $(SOURCES) test/test_authenticators.c -o $@

test/test_etm512: $(SOURCES) $(HEADERS) test/test_etm.c
	$(CC) $(CFLAGS) $(SOURCES) -DKYBER_K=2 test/test_etm.c -o $@

test/test_etm768: $(SOURCES) $(HEADERS) test/test_etm.c
	$(CC) $(CFLAGS) $(SOURCES) -DKYBER_K=3 test/test_etm.c -o $@

test/test_etm1024: $(SOURCES) $(HEADERS) test/test_etm.c
	$(CC) $(CFLAGS) $(SOURCES) -DKYBER_K=4 test/test_etm.c -o $@

test/test_speed512: $(SOURCES) $(HEADERS) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/cpucycles.h $(KYBERDIR)/test/speed_print.c $(KYBERDIR)/test/speed_print.h
	$(CC) $(CFLAGS) $(SOURCES) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/speed_print.c -DKYBER_K=2 -o $@

test/test_speed768: $(SOURCES) $(HEADERS) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/cpucycles.h $(KYBERDIR)/test/speed_print.c $(KYBERDIR)/test/speed_print.h
	$(CC) $(CFLAGS) $(SOURCES) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/speed_print.c -DKYBER_K=3 -o $@

test/test_speed1024: $(SOURCES) $(HEADERS) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/cpucycles.h $(KYBERDIR)/test/speed_print.c $(KYBERDIR)/test/speed_print.h
	$(CC) $(CFLAGS) $(SOURCES) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/speed_print.c -DKYBER_K=4 -o $@

clean:
	$(RM) -f main
	$(RM) -f test/test_authenticators
	$(RM) -f test/test_etm512
	$(RM) -f test/test_etm768
	$(RM) -f test/test_etm1024
	$(RM) -f test/test_speed512
	$(RM) -f test/test_speed768
	$(RM) -f test/test_speed1024
