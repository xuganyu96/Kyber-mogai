CC = /usr/bin/cc
DEVPORT = 8888

# Integer encoding for choice of mac. When compilation involves authenticators.h
# use a C macro definition to specify the choice of authenticator:
# -DMAC_TYPE=$(POLY1305)
POLY1305 = 0
GMAC = 1
CMAC = 2
KMAC = 3

# Flags copied from kyber/ref/Makefile
KYBERDIR = kyber/ref
KYBERSOURCES = $(KYBERDIR)/kem.c $(KYBERDIR)/indcpa.c $(KYBERDIR)/polyvec.c $(KYBERDIR)/poly.c $(KYBERDIR)/ntt.c $(KYBERDIR)/cbd.c $(KYBERDIR)/reduce.c $(KYBERDIR)/verify.c $(KYBERDIR)/randombytes.c
KYBERSOURCESKECCAK = $(KYBERSOURCES) $(KYBERDIR)/fips202.c $(KYBERDIR)/symmetric-shake.c
KYBERHEADERS = $(KYBERDIR)/params.h $(KYBERDIR)/kem.h $(KYBERDIR)/indcpa.h $(KYBERDIR)/polyvec.h $(KYBERDIR)/poly.h $(KYBERDIR)/ntt.h $(KYBERDIR)/cbd.h $(KYBERDIR)/reduce.c $(KYBERDIR)/verify.h $(KYBERDIR)/symmetric.h
KYBERHEADERSKECCAK = $(KYBERHEADERS) $(KYBERDIR)/fips202.h
CFLAGS += -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
  -Wshadow -Wpointer-arith -O3 -fomit-frame-pointer -Wno-incompatible-pointer-types
NISTFLAGS += -Wno-unused-result -O3 -fomit-frame-pointer

SOURCES = $(KYBERSOURCESKECCAK) authenticators.c etm.c kex.c utils.c
HEADERS = $(KYBERHEADERSKECCAK) authenticators.h etm.h kex.h utils.h

.PHONY: \
	test \
	clean \
	speed \
	kex \
	all

all: main \
	test \
	speed \
	kex

main: $(SOURCES) $(HEADERS) main.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) main.c -o $@
	./main

kex: \
	keygen512 \
	keygen768 \
	keygen1024 \
	kex_server512 \
	kex_client512 \
	kex_server768 \
	kex_client768 \
	kex_server1024 \
	kex_client1024

test: \
	test/test_authenticators512 \
	test/test_authenticators768 \
	test/test_authenticators1024 \
	test/test_etm512_poly1305 \
	test/test_etm768_poly1305 \
	test/test_etm1024_poly1305 \
	test/test_etm512_gmac \
	test/test_etm768_gmac \
	test/test_etm1024_gmac \
	test/test_etm512_cmac \
	test/test_etm768_cmac \
	test/test_etm1024_cmac \
	test/test_etm512_kmac \
	test/test_etm768_kmac \
	test/test_etm1024_kmac \
	test/test_utils
	./test/test_authenticators512
	./test/test_authenticators768
	./test/test_authenticators1024
	./test/test_etm512_poly1305
	./test/test_etm768_poly1305
	./test/test_etm1024_poly1305
	./test/test_etm512_gmac
	./test/test_etm768_gmac
	./test/test_etm1024_gmac
	./test/test_etm512_cmac
	./test/test_etm768_cmac
	./test/test_etm1024_cmac
	./test/test_etm512_kmac
	./test/test_etm768_kmac
	./test/test_etm1024_kmac
	./test/test_utils

speed: \
	test/test_speed512_poly1305 \
	test/test_speed768_poly1305 \
	test/test_speed1024_poly1305 \
	test/test_speed512_gmac \
	test/test_speed768_gmac \
	test/test_speed1024_gmac \
	test/test_speed512_cmac \
	test/test_speed768_cmac \
	test/test_speed1024_cmac \
	test/test_speed512_kmac \
	test/test_speed768_kmac \
	test/test_speed1024_kmac
	./test/test_speed512_poly1305
	./test/test_speed768_poly1305
	./test/test_speed1024_poly1305
	./test/test_speed512_gmac
	./test/test_speed768_gmac
	./test/test_speed1024_gmac
	./test/test_speed512_cmac
	./test/test_speed768_cmac
	./test/test_speed1024_cmac
	./test/test_speed512_kmac
	./test/test_speed768_kmac
	./test/test_speed1024_kmac

test/test_authenticators512: $(SOURCES) $(HEADERS) test/test_authenticators.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/cpucycles.h $(KYBERDIR)/test/speed_print.c $(KYBERDIR)/test/speed_print.h
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) -DKYBER_K=2 $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/speed_print.c test/test_authenticators.c -o $@

test/test_authenticators768: $(SOURCES) $(HEADERS) test/test_authenticators.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/cpucycles.h $(KYBERDIR)/test/speed_print.c $(KYBERDIR)/test/speed_print.h
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) -DKYBER_K=3 $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/speed_print.c test/test_authenticators.c -o $@

test/test_authenticators1024: $(SOURCES) $(HEADERS) test/test_authenticators.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/cpucycles.h $(KYBERDIR)/test/speed_print.c $(KYBERDIR)/test/speed_print.h
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) -DKYBER_K=4 $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/speed_print.c test/test_authenticators.c -o $@

test/test_etm512_poly1305: $(SOURCES) $(HEADERS) test/test_etm.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) -DMAC_TYPE=$(POLY1305) -DKYBER_K=2 test/test_etm.c -o $@

test/test_etm768_poly1305: $(SOURCES) $(HEADERS) test/test_etm.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) -DMAC_TYPE=$(POLY1305) -DKYBER_K=3 test/test_etm.c -o $@

test/test_etm1024_poly1305: $(SOURCES) $(HEADERS) test/test_etm.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) -DMAC_TYPE=$(POLY1305) -DKYBER_K=4 test/test_etm.c -o $@

test/test_etm512_gmac: $(SOURCES) $(HEADERS) test/test_etm.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) -DMAC_TYPE=$(GMAC) -DKYBER_K=2 test/test_etm.c -o $@

test/test_etm768_gmac: $(SOURCES) $(HEADERS) test/test_etm.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) -DMAC_TYPE=$(GMAC) -DKYBER_K=3 test/test_etm.c -o $@

test/test_etm1024_gmac: $(SOURCES) $(HEADERS) test/test_etm.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) -DMAC_TYPE=$(GMAC) -DKYBER_K=4 test/test_etm.c -o $@

test/test_etm512_cmac: $(SOURCES) $(HEADERS) test/test_etm.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) -DMAC_TYPE=$(CMAC) -DKYBER_K=2 test/test_etm.c -o $@

test/test_etm768_cmac: $(SOURCES) $(HEADERS) test/test_etm.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) -DMAC_TYPE=$(CMAC) -DKYBER_K=3 test/test_etm.c -o $@

test/test_etm1024_cmac: $(SOURCES) $(HEADERS) test/test_etm.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) -DMAC_TYPE=$(CMAC) -DKYBER_K=4 test/test_etm.c -o $@

test/test_etm512_kmac: $(SOURCES) $(HEADERS) test/test_etm.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) -DMAC_TYPE=$(KMAC) -DKYBER_K=2 test/test_etm.c -o $@

test/test_etm768_kmac: $(SOURCES) $(HEADERS) test/test_etm.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) -DMAC_TYPE=$(KMAC) -DKYBER_K=3 test/test_etm.c -o $@

test/test_etm1024_kmac: $(SOURCES) $(HEADERS) test/test_etm.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) -DMAC_TYPE=$(KMAC) -DKYBER_K=4 test/test_etm.c -o $@

test/test_speed512_poly1305: $(SOURCES) $(HEADERS) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/cpucycles.h $(KYBERDIR)/test/speed_print.c $(KYBERDIR)/test/speed_print.h
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/speed_print.c -DMAC_TYPE=$(POLY1305) -DKYBER_K=2 -o $@

test/test_speed768_poly1305: $(SOURCES) $(HEADERS) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/cpucycles.h $(KYBERDIR)/test/speed_print.c $(KYBERDIR)/test/speed_print.h
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/speed_print.c -DMAC_TYPE=$(POLY1305) -DKYBER_K=3 -o $@

test/test_speed1024_poly1305: $(SOURCES) $(HEADERS) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/cpucycles.h $(KYBERDIR)/test/speed_print.c $(KYBERDIR)/test/speed_print.h
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/speed_print.c -DMAC_TYPE=$(POLY1305) -DKYBER_K=4 -o $@

test/test_speed512_gmac: $(SOURCES) $(HEADERS) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/cpucycles.h $(KYBERDIR)/test/speed_print.c $(KYBERDIR)/test/speed_print.h
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/speed_print.c -DMAC_TYPE=$(GMAC) -DKYBER_K=2 -o $@

test/test_speed768_gmac: $(SOURCES) $(HEADERS) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/cpucycles.h $(KYBERDIR)/test/speed_print.c $(KYBERDIR)/test/speed_print.h
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/speed_print.c -DMAC_TYPE=$(GMAC) -DKYBER_K=3 -o $@

test/test_speed1024_gmac: $(SOURCES) $(HEADERS) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/cpucycles.h $(KYBERDIR)/test/speed_print.c $(KYBERDIR)/test/speed_print.h
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/speed_print.c -DMAC_TYPE=$(GMAC) -DKYBER_K=4 -o $@

test/test_speed512_cmac: $(SOURCES) $(HEADERS) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/cpucycles.h $(KYBERDIR)/test/speed_print.c $(KYBERDIR)/test/speed_print.h
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/speed_print.c -DMAC_TYPE=$(CMAC) -DKYBER_K=2 -o $@

test/test_speed768_cmac: $(SOURCES) $(HEADERS) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/cpucycles.h $(KYBERDIR)/test/speed_print.c $(KYBERDIR)/test/speed_print.h
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/speed_print.c -DMAC_TYPE=$(CMAC) -DKYBER_K=3 -o $@

test/test_speed1024_cmac: $(SOURCES) $(HEADERS) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/cpucycles.h $(KYBERDIR)/test/speed_print.c $(KYBERDIR)/test/speed_print.h
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/speed_print.c -DMAC_TYPE=$(CMAC) -DKYBER_K=4 -o $@

test/test_speed512_kmac: $(SOURCES) $(HEADERS) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/cpucycles.h $(KYBERDIR)/test/speed_print.c $(KYBERDIR)/test/speed_print.h
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/speed_print.c -DMAC_TYPE=$(KMAC) -DKYBER_K=2 -o $@

test/test_speed768_kmac: $(SOURCES) $(HEADERS) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/cpucycles.h $(KYBERDIR)/test/speed_print.c $(KYBERDIR)/test/speed_print.h
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/speed_print.c -DMAC_TYPE=$(KMAC) -DKYBER_K=3 -o $@

test/test_speed1024_kmac: $(SOURCES) $(HEADERS) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/cpucycles.h $(KYBERDIR)/test/speed_print.c $(KYBERDIR)/test/speed_print.h
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) test/test_speed.c $(KYBERDIR)/test/cpucycles.c $(KYBERDIR)/test/speed_print.c -DMAC_TYPE=$(KMAC) -DKYBER_K=4 -o $@

test/test_utils: $(SOURCES) $(HEADERS) test/test_utils.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) test/test_utils.c -o $@

kex_server512: $(SOURCES) $(HEADERS) kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) kex_server.c -DKYBER_K=2 -o $@

kex_client512: $(SOURCES) $(HEADERS) kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) kex_client.c -DKYBER_K=2 -o $@

kex_server768: $(SOURCES) $(HEADERS) kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) kex_server.c -DKYBER_K=3 -o $@

kex_client768: $(SOURCES) $(HEADERS) kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) kex_client.c -DKYBER_K=3 -o $@

kex_server1024: $(SOURCES) $(HEADERS) kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) kex_server.c -DKYBER_K=4 -o $@

kex_client1024: $(SOURCES) $(HEADERS) kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) kex_client.c -DKYBER_K=4 -o $@

keygen512: $(SOURCES) $(HEADERS) keygen.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) keygen.c -DKYBER_K=2 -o $@

keygen768: $(SOURCES) $(HEADERS) keygen.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) keygen.c -DKYBER_K=3 -o $@

keygen1024: $(SOURCES) $(HEADERS) keygen.c
	$(CC) $(CFLAGS) $(LDFLAGS) -lcrypto $(SOURCES) keygen.c -DKYBER_K=4 -o $@

clean:
	$(RM) main
	$(RM) kex_server512
	$(RM) kex_client512
	$(RM) kex_server768
	$(RM) kex_client768
	$(RM) kex_server1024
	$(RM) kex_client1024
	$(RM) keygen512
	$(RM) keygen768
	$(RM) keygen1024
	$(RM) test/test_authenticators512
	$(RM) test/test_authenticators768
	$(RM) test/test_authenticators1024
	$(RM) test/test_etm1024_gmac
	$(RM) test/test_etm1024_poly1305
	$(RM) test/test_etm512_gmac
	$(RM) test/test_etm512_poly1305
	$(RM) test/test_etm768_gmac
	$(RM) test/test_etm768_poly1305
	$(RM) test/test_etm512_cmac
	$(RM) test/test_etm768_cmac
	$(RM) test/test_etm1024_cmac
	$(RM) test/test_etm512_kmac
	$(RM) test/test_etm768_kmac
	$(RM) test/test_etm1024_kmac
	$(RM) test/test_speed512_poly1305
	$(RM) test/test_speed768_poly1305
	$(RM) test/test_speed1024_poly1305
	$(RM) test/test_speed512_gmac
	$(RM) test/test_speed768_gmac
	$(RM) test/test_speed1024_gmac
	$(RM) test/test_speed512_cmac
	$(RM) test/test_speed768_cmac
	$(RM) test/test_speed1024_cmac
	$(RM) test/test_speed512_kmac
	$(RM) test/test_speed768_kmac
	$(RM) test/test_speed1024_kmac
	$(RM) test/test_utils
