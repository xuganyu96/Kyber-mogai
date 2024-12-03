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
SOURCES = $(KYBERSOURCES) authenticators.c etmkem.c
HEADERS = $(KYBERHEADERS) authenticators.h etmkem.h

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
	$(CC) $(CFLAGS) $(LDFLAGS) $(SOURCES) main.c -o target/$@
	./target/$@

tests: test_etmkem
	./target/test_etmkem

test_etmkem: $(SOURCES) $(HEADERS) tests/etmkem.c
	$(CC) $(CFLAGS) $(LDFLAGS) $(SOURCES) tests/etmkem.c -o target/$@

showflags:
	echo $(CFLAGS) $(LDFLAGS)

clean:
	$(RM) target/*
