KYBERSOURCES = kyber/ref/kem.c \
			   kyber/ref/indcpa.c \
			   kyber/ref/polyvec.c \
			   kyber/ref/poly.c \
			   kyber/ref/ntt.c \
			   kyber/ref/cbd.c \
			   kyber/ref/reduce.c \
			   kyber/ref/verify.c \
			   kyber/ref/randombytes.c \
			   kyber/ref/fips202.c \
			   kyber/ref/symmetric-shake.c
KYBERHEADERS = kyber/ref/params.h \
			   kyber/ref/kem.h \
			   kyber/ref/indcpa.h \
			   kyber/ref/polyvec.h \
			   kyber/ref/poly.h \
			   kyber/ref/ntt.h \
			   kyber/ref/cbd.h \
			   kyber/ref/reduce.c \
			   kyber/ref/verify.h \
			   kyber/ref/symmetric.h \
			   kyber/ref/fips202.h

EASYMCELIECEHEADERS = easy-mceliece/easy-mceliece/api.h \
					  easy-mceliece/easy-mceliece/benes.h \
					  easy-mceliece/easy-mceliece/bm.h \
					  easy-mceliece/easy-mceliece/controlbits.h \
					  easy-mceliece/easy-mceliece/crypto_hash.h \
					  easy-mceliece/easy-mceliece/crypto_kem.h \
					  easy-mceliece/easy-mceliece/decrypt.h \
					  easy-mceliece/easy-mceliece/encrypt.h \
					  easy-mceliece/easy-mceliece/gf.h \
					  easy-mceliece/easy-mceliece/int32_sort.h \
					  easy-mceliece/easy-mceliece/keccak.h \
					  easy-mceliece/easy-mceliece/operations.h \
					  easy-mceliece/easy-mceliece/params.h \
					  easy-mceliece/easy-mceliece/pk_gen.h \
					  easy-mceliece/easy-mceliece/randombytes.h \
					  easy-mceliece/easy-mceliece/root.h \
					  easy-mceliece/easy-mceliece/sk_gen.h \
					  easy-mceliece/easy-mceliece/synd.h \
					  easy-mceliece/easy-mceliece/transpose.h \
					  easy-mceliece/easy-mceliece/uint64_sort.h \
					  easy-mceliece/easy-mceliece/util.h \
					  easy-mceliece/easy-mceliece/subroutines/crypto_declassify.h \
					  easy-mceliece/easy-mceliece/subroutines/crypto_int16.h \
					  easy-mceliece/easy-mceliece/subroutines/crypto_int32.h \
					  easy-mceliece/easy-mceliece/subroutines/crypto_uint16.h \
					  easy-mceliece/easy-mceliece/subroutines/crypto_uint32.h \
					  easy-mceliece/easy-mceliece/subroutines/crypto_uint64.h

EASYMCELIECESOURCES = easy-mceliece/easy-mceliece/benes.c \
					  easy-mceliece/easy-mceliece/bm.c \
					  easy-mceliece/easy-mceliece/controlbits.c \
					  easy-mceliece/easy-mceliece/decrypt.c \
					  easy-mceliece/easy-mceliece/encrypt.c \
					  easy-mceliece/easy-mceliece/gf.c \
					  easy-mceliece/easy-mceliece/keccak.c \
					  easy-mceliece/easy-mceliece/operations.c \
					  easy-mceliece/easy-mceliece/pk_gen.c \
					  easy-mceliece/easy-mceliece/randombytes.c \
					  easy-mceliece/easy-mceliece/root.c \
					  easy-mceliece/easy-mceliece/sk_gen.c \
					  easy-mceliece/easy-mceliece/synd.c \
					  easy-mceliece/easy-mceliece/transpose.c \
					  easy-mceliece/easy-mceliece/util.c

SOURCES = authenticators.c etmkem.c pke.c speed.c
HEADERS = authenticators.h etmkem.h pke.h speed.h

# OpenSSL header files should be included using the CFLAGS environment variables:
# for example `export CFLAGS="-I/path/to/openssl/include $CFLAGS"`
CFLAGS += -O3 -Wno-incompatible-pointer-types-discards-qualifiers # -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls -Wshadow -Wpointer-arith -fomit-frame-pointer -Wno-incompatible-pointer-types
# OpenSSL library files are included using the LDFLAGS environment variable:
# `export LDFLAGS="-L/path/to/opensl/lib $LDFLAGS"
LDFLAGS += -lcrypto

# phony targets will be rerun everytime even if the input files did not change
.PHONY = main tests speed speed_mlkem speed_mceliece speed_etmkem

main: $(SOURCES) $(HEADERS) main.c
	$(CC) $(CFLAGS) $(LDFLAGS) $(KYBERSOURCES) $(SOURCES) -DPKE_KYBER -DMAC_POLY1305 main.c -o target/$@
	./target/$@

all: tests speed

tests: test_pke_correctness test_etmkem_correctness

speed: speed_mlkem speed_mceliece speed_etmkem

test_pke_correctness: $(SOURCES) $(HEADERS) test_pke_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) $(KYBERSOURCES) pke.c -DPKE_KYBER -DKYBER_K=2 test_pke_correctness.c -o target/test_pke_kyber512_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) $(KYBERSOURCES) pke.c -DPKE_KYBER -DKYBER_K=3 test_pke_correctness.c -o target/test_pke_kyber768_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) $(KYBERSOURCES) pke.c -DPKE_KYBER -DKYBER_K=4 test_pke_correctness.c -o target/test_pke_kyber1024_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) $(EASYMCELIECESOURCES) pke.c -DPKE_MCELIECE -DMCELIECE_N=3488 test_pke_correctness.c -o target/test_pke_mceliece348864_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) $(EASYMCELIECESOURCES) pke.c -DPKE_MCELIECE -DMCELIECE_N=4608 test_pke_correctness.c -o target/test_pke_mceliece460896_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) $(EASYMCELIECESOURCES) pke.c -DPKE_MCELIECE -DMCELIECE_N=6688 test_pke_correctness.c -o target/test_pke_mceliece6688128_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) $(EASYMCELIECESOURCES) pke.c -DPKE_MCELIECE -DMCELIECE_N=6960 test_pke_correctness.c -o target/test_pke_mceliece6960119_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) $(EASYMCELIECESOURCES) pke.c -DPKE_MCELIECE -DMCELIECE_N=8192 test_pke_correctness.c -o target/test_pke_mceliece8192128_correctness
	./target/test_pke_kyber512_correctness
	./target/test_pke_kyber768_correctness
	./target/test_pke_kyber1024_correctness
	./target/test_pke_mceliece348864_correctness
	./target/test_pke_mceliece460896_correctness
	./target/test_pke_mceliece6688128_correctness
	./target/test_pke_mceliece6960119_correctness
	./target/test_pke_mceliece8192128_correctness

# Copy from test_etmkem_speed, then replace speed with correctness
test_etmkem_correctness: $(SOURCES) $(HEADERS) test_etmkem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=2 -DMAC_POLY1305 $(KYBERSOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_kyber512_poly1305_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=2 -DMAC_GMAC $(KYBERSOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_kyber512_gmac_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=2 -DMAC_CMAC $(KYBERSOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_kyber512_cmac_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=2 -DMAC_KMAC256 $(KYBERSOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_kyber512_kmac256_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=3 -DMAC_POLY1305 $(KYBERSOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_kyber768_poly1305_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=3 -DMAC_GMAC $(KYBERSOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_kyber768_gmac_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=3 -DMAC_CMAC $(KYBERSOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_kyber768_cmac_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=3 -DMAC_KMAC256 $(KYBERSOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_kyber768_kmac256_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=4 -DMAC_POLY1305 $(KYBERSOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_kyber1024_poly1305_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=4 -DMAC_GMAC $(KYBERSOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_kyber1024_gmac_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=4 -DMAC_CMAC $(KYBERSOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_kyber1024_cmac_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=4 -DMAC_KMAC256 $(KYBERSOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_kyber1024_kmac256_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=3488 -DMAC_POLY1305 $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_mceliece348864_poly1305_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=3488 -DMAC_GMAC $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_mceliece348864_gmac_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=3488 -DMAC_CMAC $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_mceliece348864_cmac_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=3488 -DMAC_KMAC256 $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_mceliece348864_kmac256_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=4608 -DMAC_POLY1305 $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_mceliece460896_poly1305_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=4608 -DMAC_GMAC $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_mceliece460896_gmac_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=4608 -DMAC_CMAC $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_mceliece460896_cmac_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=4608 -DMAC_KMAC256 $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_mceliece460896_kmac256_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6688 -DMAC_POLY1305 $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_mceliece6688128_poly1305_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6688 -DMAC_GMAC $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_mceliece6688128_gmac_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6688 -DMAC_CMAC $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_mceliece6688128_cmac_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6688 -DMAC_KMAC256 $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_mceliece6688128_kmac256_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6960 -DMAC_POLY1305 $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_mceliece6960119_poly1305_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6960 -DMAC_GMAC $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_mceliece6960119_gmac_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6960 -DMAC_CMAC $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_mceliece6960119_cmac_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6960 -DMAC_KMAC256 $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_mceliece6960119_kmac256_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=8192 -DMAC_POLY1305 $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_mceliece8192128_poly1305_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=8192 -DMAC_GMAC $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_mceliece8192128_gmac_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=8192 -DMAC_CMAC $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_mceliece8192128_cmac_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=8192 -DMAC_KMAC256 $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_correctness.c -o target/test_mceliece8192128_kmac256_correctness
	./target/test_kyber512_poly1305_correctness
	./target/test_kyber512_gmac_correctness
	./target/test_kyber512_cmac_correctness
	./target/test_kyber512_kmac256_correctness
	./target/test_kyber768_poly1305_correctness
	./target/test_kyber768_gmac_correctness
	./target/test_kyber768_cmac_correctness
	./target/test_kyber768_kmac256_correctness
	./target/test_kyber1024_poly1305_correctness
	./target/test_kyber1024_gmac_correctness
	./target/test_kyber1024_cmac_correctness
	./target/test_kyber1024_kmac256_correctness
	./target/test_mceliece348864_poly1305_correctness
	./target/test_mceliece348864_gmac_correctness
	./target/test_mceliece348864_cmac_correctness
	./target/test_mceliece348864_kmac256_correctness
	./target/test_mceliece460896_poly1305_correctness
	./target/test_mceliece460896_gmac_correctness
	./target/test_mceliece460896_cmac_correctness
	./target/test_mceliece460896_kmac256_correctness
	./target/test_mceliece6688128_poly1305_correctness
	./target/test_mceliece6688128_gmac_correctness
	./target/test_mceliece6688128_cmac_correctness
	./target/test_mceliece6688128_kmac256_correctness
	./target/test_mceliece6960119_poly1305_correctness
	./target/test_mceliece6960119_gmac_correctness
	./target/test_mceliece6960119_cmac_correctness
	./target/test_mceliece6960119_kmac256_correctness
	./target/test_mceliece8192128_poly1305_correctness
	./target/test_mceliece8192128_gmac_correctness
	./target/test_mceliece8192128_cmac_correctness
	./target/test_mceliece8192128_kmac256_correctness

speed_mlkem: $(SOURCES) $(HEADERS) test_mlkem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DKYBER_K=2 $(KYBERSOURCES) speed.c test_mlkem_speed.c -o target/test_mlkem512_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DKYBER_K=3 $(KYBERSOURCES) speed.c test_mlkem_speed.c -o target/test_mlkem768_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DKYBER_K=4 $(KYBERSOURCES) speed.c test_mlkem_speed.c -o target/test_mlkem1024_speed
	./target/test_mlkem512_speed
	./target/test_mlkem768_speed
	./target/test_mlkem1024_speed

speed_mceliece: $(SOURCES) $(HEADERS) test_mceliece_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=3488 $(EASYMCELIECESOURCES) speed.c test_mceliece_speed.c -o target/test_mceliece348864_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=4608 $(EASYMCELIECESOURCES) speed.c test_mceliece_speed.c -o target/test_mceliece460896_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6688 $(EASYMCELIECESOURCES) speed.c test_mceliece_speed.c -o target/test_mceliece6688128_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6960 $(EASYMCELIECESOURCES) speed.c test_mceliece_speed.c -o target/test_mceliece6960119_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=8192 $(EASYMCELIECESOURCES) speed.c test_mceliece_speed.c -o target/test_mceliece8192128_speed
	./target/test_mceliece348864_speed
	./target/test_mceliece460896_speed
	./target/test_mceliece6688128_speed
	./target/test_mceliece6960119_speed
	./target/test_mceliece8192128_speed

# commands generated by cmdgen.py:gen_test_etmkem_speed_cmds
speed_etmkem: $(SOURCES) $(HEADERS) test_etmkem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=2 -DMAC_POLY1305 $(KYBERSOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_kyber512_poly1305_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=2 -DMAC_GMAC $(KYBERSOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_kyber512_gmac_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=2 -DMAC_CMAC $(KYBERSOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_kyber512_cmac_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=2 -DMAC_KMAC256 $(KYBERSOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_kyber512_kmac256_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=3 -DMAC_POLY1305 $(KYBERSOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_kyber768_poly1305_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=3 -DMAC_GMAC $(KYBERSOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_kyber768_gmac_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=3 -DMAC_CMAC $(KYBERSOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_kyber768_cmac_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=3 -DMAC_KMAC256 $(KYBERSOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_kyber768_kmac256_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=4 -DMAC_POLY1305 $(KYBERSOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_kyber1024_poly1305_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=4 -DMAC_GMAC $(KYBERSOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_kyber1024_gmac_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=4 -DMAC_CMAC $(KYBERSOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_kyber1024_cmac_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=4 -DMAC_KMAC256 $(KYBERSOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_kyber1024_kmac256_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=3488 -DMAC_POLY1305 $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_mceliece348864_poly1305_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=3488 -DMAC_GMAC $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_mceliece348864_gmac_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=3488 -DMAC_CMAC $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_mceliece348864_cmac_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=3488 -DMAC_KMAC256 $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_mceliece348864_kmac256_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=4608 -DMAC_POLY1305 $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_mceliece460896_poly1305_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=4608 -DMAC_GMAC $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_mceliece460896_gmac_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=4608 -DMAC_CMAC $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_mceliece460896_cmac_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=4608 -DMAC_KMAC256 $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_mceliece460896_kmac256_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6688 -DMAC_POLY1305 $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_mceliece6688128_poly1305_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6688 -DMAC_GMAC $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_mceliece6688128_gmac_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6688 -DMAC_CMAC $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_mceliece6688128_cmac_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6688 -DMAC_KMAC256 $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_mceliece6688128_kmac256_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6960 -DMAC_POLY1305 $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_mceliece6960119_poly1305_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6960 -DMAC_GMAC $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_mceliece6960119_gmac_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6960 -DMAC_CMAC $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_mceliece6960119_cmac_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6960 -DMAC_KMAC256 $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_mceliece6960119_kmac256_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=8192 -DMAC_POLY1305 $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_mceliece8192128_poly1305_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=8192 -DMAC_GMAC $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_mceliece8192128_gmac_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=8192 -DMAC_CMAC $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_mceliece8192128_cmac_speed
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=8192 -DMAC_KMAC256 $(EASYMCELIECESOURCES) $(SOURCES) test_etmkem_speed.c -o target/test_mceliece8192128_kmac256_speed
	./target/test_kyber512_poly1305_speed
	./target/test_kyber512_gmac_speed
	./target/test_kyber512_cmac_speed
	./target/test_kyber512_kmac256_speed
	./target/test_kyber768_poly1305_speed
	./target/test_kyber768_gmac_speed
	./target/test_kyber768_cmac_speed
	./target/test_kyber768_kmac256_speed
	./target/test_kyber1024_poly1305_speed
	./target/test_kyber1024_gmac_speed
	./target/test_kyber1024_cmac_speed
	./target/test_kyber1024_kmac256_speed
	./target/test_mceliece348864_poly1305_speed
	./target/test_mceliece348864_gmac_speed
	./target/test_mceliece348864_cmac_speed
	./target/test_mceliece348864_kmac256_speed
	./target/test_mceliece460896_poly1305_speed
	./target/test_mceliece460896_gmac_speed
	./target/test_mceliece460896_cmac_speed
	./target/test_mceliece460896_kmac256_speed
	./target/test_mceliece6688128_poly1305_speed
	./target/test_mceliece6688128_gmac_speed
	./target/test_mceliece6688128_cmac_speed
	./target/test_mceliece6688128_kmac256_speed
	./target/test_mceliece6960119_poly1305_speed
	./target/test_mceliece6960119_gmac_speed
	./target/test_mceliece6960119_cmac_speed
	./target/test_mceliece6960119_kmac256_speed
	./target/test_mceliece8192128_poly1305_speed
	./target/test_mceliece8192128_gmac_speed
	./target/test_mceliece8192128_cmac_speed
	./target/test_mceliece8192128_kmac256_speed


clean:
	$(RM) target/*
