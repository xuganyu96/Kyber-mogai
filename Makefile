KYBERDIR = kyber/ref
KYBERSOURCES = $(KYBERDIR)/kem.c \
			   $(KYBERDIR)/indcpa.c \
			   $(KYBERDIR)/polyvec.c \
			   $(KYBERDIR)/poly.c \
			   $(KYBERDIR)/ntt.c \
			   $(KYBERDIR)/cbd.c \
			   $(KYBERDIR)/reduce.c \
			   $(KYBERDIR)/verify.c \
			   $(KYBERDIR)/randombytes.c \
			   $(KYBERDIR)/fips202.c \
			   $(KYBERDIR)/symmetric-shake.c
KYBERHEADERS = $(KYBERDIR)/params.h \
			   $(KYBERDIR)/kem.h \
			   $(KYBERDIR)/indcpa.h \
			   $(KYBERDIR)/polyvec.h \
			   $(KYBERDIR)/poly.h \
			   $(KYBERDIR)/ntt.h \
			   $(KYBERDIR)/cbd.h \
			   $(KYBERDIR)/reduce.c \
			   $(KYBERDIR)/verify.h \
			   $(KYBERDIR)/symmetric.h \
			   $(KYBERDIR)/fips202.h

SOURCES = authenticators.c etmkem.c pke.c
HEADERS = authenticators.h etmkem.h pke.h

# OpenSSL header files should be included using the CFLAGS environment variables:
# for example `export CFLAGS="-I/path/to/openssl/include $CFLAGS"`
CFLAGS += -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
  -Wshadow -Wpointer-arith -O3 -fomit-frame-pointer -Wno-incompatible-pointer-types
# OpenSSL library files are included using the LDFLAGS environment variable:
# `export LDFLAGS="-L/path/to/opensl/lib $LDFLAGS"
LDFLAGS += -lcrypto

# phony targets will be rerun everytime even if the input files did not change
.PHONY = main tests

main: $(SOURCES) $(HEADERS) main.c
	$(CC) $(CFLAGS) $(LDFLAGS) $(KYBERSOURCES) $(SOURCES) -DMAC_POLY1305 main.c -o target/$@
	./target/$@

speed: $(SOURCES) $(HEADERS) speed_etmkem.c speed_mlkem.c
	$(CC) $(CFLAGS) $(LDFLAGS) $(KYBERSOURCES) -DPKE_KYBER -DKYBER_K=2 speed_mlkem.c -o target/speed_mlkem512
	$(CC) $(CFLAGS) $(LDFLAGS) $(KYBERSOURCES) -DPKE_KYBER -DKYBER_K=3 speed_mlkem.c -o target/speed_mlkem768
	$(CC) $(CFLAGS) $(LDFLAGS) $(KYBERSOURCES) -DPKE_KYBER -DKYBER_K=4 speed_mlkem.c -o target/speed_mlkem1024
	$(CC) $(CFLAGS) $(LDFLAGS) $(KYBERSOURCES) $(SOURCES) -DPKE_KYBER -DMAC_POLY1305 -DKYBER_K=2 speed_etmkem.c -o target/speed_mlkem512_poly1305
	$(CC) $(CFLAGS) $(LDFLAGS) $(KYBERSOURCES) $(SOURCES) -DPKE_KYBER -DMAC_POLY1305 -DKYBER_K=3 speed_etmkem.c -o target/speed_mlkem768_poly1305
	$(CC) $(CFLAGS) $(LDFLAGS) $(KYBERSOURCES) $(SOURCES) -DPKE_KYBER -DMAC_POLY1305 -DKYBER_K=4 speed_etmkem.c -o target/speed_mlkem1024_poly1305
	$(CC) $(CFLAGS) $(LDFLAGS) $(KYBERSOURCES) $(SOURCES) -DPKE_KYBER -DMAC_GMAC -DKYBER_K=2 speed_etmkem.c -o target/speed_mlkem512_gmac
	$(CC) $(CFLAGS) $(LDFLAGS) $(KYBERSOURCES) $(SOURCES) -DPKE_KYBER -DMAC_GMAC -DKYBER_K=3 speed_etmkem.c -o target/speed_mlkem768_gmac
	$(CC) $(CFLAGS) $(LDFLAGS) $(KYBERSOURCES) $(SOURCES) -DPKE_KYBER -DMAC_GMAC -DKYBER_K=4 speed_etmkem.c -o target/speed_mlkem1024_gmac
	$(CC) $(CFLAGS) $(LDFLAGS) $(KYBERSOURCES) $(SOURCES) -DPKE_KYBER -DMAC_CMAC -DKYBER_K=2 speed_etmkem.c -o target/speed_mlkem512_cmac
	$(CC) $(CFLAGS) $(LDFLAGS) $(KYBERSOURCES) $(SOURCES) -DPKE_KYBER -DMAC_CMAC -DKYBER_K=3 speed_etmkem.c -o target/speed_mlkem768_cmac
	$(CC) $(CFLAGS) $(LDFLAGS) $(KYBERSOURCES) $(SOURCES) -DPKE_KYBER -DMAC_CMAC -DKYBER_K=4 speed_etmkem.c -o target/speed_mlkem1024_cmac
	$(CC) $(CFLAGS) $(LDFLAGS) $(KYBERSOURCES) $(SOURCES) -DPKE_KYBER -DMAC_KMAC256 -DKYBER_K=2 speed_etmkem.c -o target/speed_mlkem512_kmac256
	$(CC) $(CFLAGS) $(LDFLAGS) $(KYBERSOURCES) $(SOURCES) -DPKE_KYBER -DMAC_KMAC256 -DKYBER_K=3 speed_etmkem.c -o target/speed_mlkem768_kmac256
	$(CC) $(CFLAGS) $(LDFLAGS) $(KYBERSOURCES) $(SOURCES) -DPKE_KYBER -DMAC_KMAC256 -DKYBER_K=4 speed_etmkem.c -o target/speed_mlkem1024_kmac256
	# ------------ NIST level 1 ----------------
	./target/speed_mlkem512
	./target/speed_mlkem512_poly1305
	./target/speed_mlkem512_gmac
	./target/speed_mlkem512_cmac
	./target/speed_mlkem512_kmac256
	# ------------ NIST level 2 ----------------
	./target/speed_mlkem768
	./target/speed_mlkem768_poly1305
	./target/speed_mlkem768_gmac
	./target/speed_mlkem768_cmac
	./target/speed_mlkem768_kmac256
	# ------------ NIST level 3 ----------------
	./target/speed_mlkem1024
	./target/speed_mlkem1024_poly1305
	./target/speed_mlkem1024_gmac
	./target/speed_mlkem1024_cmac
	./target/speed_mlkem1024_kmac256

clean:
	$(RM) target/*
