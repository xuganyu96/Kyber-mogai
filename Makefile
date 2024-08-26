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

SOURCES = $(KYBERSOURCESKECCAK) authenticators.c etm.c
HEADERS = $(KYBERHEADERSKECCAK) authenticators.h etm.h

.PHONY: test clean speed

main: $(SOURCES) $(HEADERS) main.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) -lcrypto main.c -o $@
	./main

test: \
	test/test_authenticators \
	test/test_etm512_poly1305 \
	test/test_etm768_poly1305 \
	test/test_etm1024_poly1305 \
	test/test_etm512_gmac \
	test/test_etm768_gmac \
	test/test_etm1024_gmac \
	test/test_speed512 \
	test/test_speed768 \
	test/test_speed1024
	./test/test_authenticators
	./test/test_etm512_poly1305
	./test/test_etm768_poly1305
	./test/test_etm1024_poly1305
	./test/test_etm512_gmac
	./test/test_etm768_gmac
	./test/test_etm1024_gmac

speed: \
	test/test_speed512 \
	test/test_speed768 \
	test/test_speed1024

test/test_authenticators: $(SOURCES) $(HEADERS) test/test_authenticators.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/cpucycles.h $(KYBERDIR)/test/speed_print.c $(KYBERDIR)/test/speed_print.h
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/speed_print.c test/test_authenticators.c -o $@

test/test_etm512_poly1305: $(SOURCES) $(HEADERS) test/test_etm.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) -DKYBER_K=2 test/test_etm.c -o $@

test/test_etm768_poly1305: $(SOURCES) $(HEADERS) test/test_etm.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) -DKYBER_K=3 test/test_etm.c -o $@

test/test_etm1024_poly1305: $(SOURCES) $(HEADERS) test/test_etm.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) -DKYBER_K=4 test/test_etm.c -o $@

test/test_etm512_gmac: $(SOURCES) $(HEADERS) test/test_etm.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) -DMACNAME=GMAC -DKYBER_K=2 test/test_etm.c -o $@

test/test_etm768_gmac: $(SOURCES) $(HEADERS) test/test_etm.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) -DMACNAME=GMAC -DKYBER_K=3 test/test_etm.c -o $@

test/test_etm1024_gmac: $(SOURCES) $(HEADERS) test/test_etm.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) -DMACNAME=GMAC -DKYBER_K=4 test/test_etm.c -o $@

test/test_speed512: $(SOURCES) $(HEADERS) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/cpucycles.h $(KYBERDIR)/test/speed_print.c $(KYBERDIR)/test/speed_print.h
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/speed_print.c -DKYBER_K=2 -o $@

test/test_speed768: $(SOURCES) $(HEADERS) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/cpucycles.h $(KYBERDIR)/test/speed_print.c $(KYBERDIR)/test/speed_print.h
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/speed_print.c -DKYBER_K=3 -o $@

test/test_speed1024: $(SOURCES) $(HEADERS) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/cpucycles.h $(KYBERDIR)/test/speed_print.c $(KYBERDIR)/test/speed_print.h
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/speed_print.c -DKYBER_K=4 -o $@

clean:
	$(RM) -f main
	$(RM) -f test/test_authenticators
	$(RM) -f test/test_etm1024_gmac
	$(RM) -f test/test_etm1024_poly1305
	$(RM) -f test/test_etm512_gmac
	$(RM) -f test/test_etm512_poly1305
	$(RM) -f test/test_etm768_gmac
	$(RM) -f test/test_etm768_poly1305
	$(RM) -f test/test_speed512
	$(RM) -f test/test_speed768
	$(RM) -f test/test_speed1024
