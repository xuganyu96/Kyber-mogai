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

MCELIECE348864HEADERS = easy-mceliece/mceliece348864/api.h \
						easy-mceliece/mceliece348864/benes.h \
						easy-mceliece/mceliece348864/bm.h \
						easy-mceliece/mceliece348864/controlbits.h \
						easy-mceliece/mceliece348864/crypto_hash.h \
						easy-mceliece/mceliece348864/crypto_kem.h \
						easy-mceliece/mceliece348864/crypto_kem_mceliece348864.h \
						easy-mceliece/mceliece348864/decrypt.h \
						easy-mceliece/mceliece348864/encrypt.h \
						easy-mceliece/mceliece348864/gf.h \
						easy-mceliece/mceliece348864/int32_sort.h \
						easy-mceliece/mceliece348864/keccak.h \
						easy-mceliece/mceliece348864/operations.h \
						easy-mceliece/mceliece348864/params.h \
						easy-mceliece/mceliece348864/pk_gen.h \
						easy-mceliece/mceliece348864/randombytes.h \
						easy-mceliece/mceliece348864/root.h \
						easy-mceliece/mceliece348864/sk_gen.h \
						easy-mceliece/mceliece348864/synd.h \
						easy-mceliece/mceliece348864/transpose.h \
						easy-mceliece/mceliece348864/uint64_sort.h \
						easy-mceliece/mceliece348864/util.h \
						easy-mceliece/mceliece348864/subroutines/crypto_declassify.h \
						easy-mceliece/mceliece348864/subroutines/crypto_int16.h \
						easy-mceliece/mceliece348864/subroutines/crypto_int32.h \
						easy-mceliece/mceliece348864/subroutines/crypto_uint16.h \
						easy-mceliece/mceliece348864/subroutines/crypto_uint32.h \
						easy-mceliece/mceliece348864/subroutines/crypto_uint64.h

MCELIECE348864SOURCES = easy-mceliece/mceliece348864/benes.c \
						easy-mceliece/mceliece348864/bm.c \
						easy-mceliece/mceliece348864/controlbits.c \
						easy-mceliece/mceliece348864/decrypt.c \
						easy-mceliece/mceliece348864/encrypt.c \
						easy-mceliece/mceliece348864/gf.c \
						easy-mceliece/mceliece348864/keccak.c \
						easy-mceliece/mceliece348864/operations.c \
						easy-mceliece/mceliece348864/pk_gen.c \
						easy-mceliece/mceliece348864/randombytes.c \
						easy-mceliece/mceliece348864/root.c \
						easy-mceliece/mceliece348864/sk_gen.c \
						easy-mceliece/mceliece348864/synd.c \
						easy-mceliece/mceliece348864/transpose.c \
						easy-mceliece/mceliece348864/util.c

MCELIECE460896HEADERS = easy-mceliece/mceliece460896/api.h \
						easy-mceliece/mceliece460896/benes.h \
						easy-mceliece/mceliece460896/bm.h \
						easy-mceliece/mceliece460896/controlbits.h \
						easy-mceliece/mceliece460896/crypto_hash.h \
						easy-mceliece/mceliece460896/crypto_kem.h \
						easy-mceliece/mceliece460896/crypto_kem_mceliece460896.h \
						easy-mceliece/mceliece460896/decrypt.h \
						easy-mceliece/mceliece460896/encrypt.h \
						easy-mceliece/mceliece460896/gf.h \
						easy-mceliece/mceliece460896/int32_sort.h \
						easy-mceliece/mceliece460896/keccak.h \
						easy-mceliece/mceliece460896/operations.h \
						easy-mceliece/mceliece460896/params.h \
						easy-mceliece/mceliece460896/pk_gen.h \
						easy-mceliece/mceliece460896/randombytes.h \
						easy-mceliece/mceliece460896/root.h \
						easy-mceliece/mceliece460896/sk_gen.h \
						easy-mceliece/mceliece460896/synd.h \
						easy-mceliece/mceliece460896/transpose.h \
						easy-mceliece/mceliece460896/uint64_sort.h \
						easy-mceliece/mceliece460896/util.h \
						easy-mceliece/mceliece460896/subroutines/crypto_declassify.h \
						easy-mceliece/mceliece460896/subroutines/crypto_int16.h \
						easy-mceliece/mceliece460896/subroutines/crypto_int32.h \
						easy-mceliece/mceliece460896/subroutines/crypto_uint16.h \
						easy-mceliece/mceliece460896/subroutines/crypto_uint32.h \
						easy-mceliece/mceliece460896/subroutines/crypto_uint64.h

MCELIECE460896SOURCES = easy-mceliece/mceliece460896/benes.c \
						easy-mceliece/mceliece460896/bm.c \
						easy-mceliece/mceliece460896/controlbits.c \
						easy-mceliece/mceliece460896/decrypt.c \
						easy-mceliece/mceliece460896/encrypt.c \
						easy-mceliece/mceliece460896/gf.c \
						easy-mceliece/mceliece460896/keccak.c \
						easy-mceliece/mceliece460896/operations.c \
						easy-mceliece/mceliece460896/pk_gen.c \
						easy-mceliece/mceliece460896/randombytes.c \
						easy-mceliece/mceliece460896/root.c \
						easy-mceliece/mceliece460896/sk_gen.c \
						easy-mceliece/mceliece460896/synd.c \
						easy-mceliece/mceliece460896/transpose.c \
						easy-mceliece/mceliece460896/util.c

MCELIECE6688128HEADERS = easy-mceliece/mceliece6688128/api.h \
						 easy-mceliece/mceliece6688128/benes.h \
						 easy-mceliece/mceliece6688128/bm.h \
						 easy-mceliece/mceliece6688128/controlbits.h \
						 easy-mceliece/mceliece6688128/crypto_hash.h \
						 easy-mceliece/mceliece6688128/crypto_kem.h \
						 easy-mceliece/mceliece6688128/crypto_kem_mceliece6688128.h \
						 easy-mceliece/mceliece6688128/decrypt.h \
						 easy-mceliece/mceliece6688128/encrypt.h \
						 easy-mceliece/mceliece6688128/gf.h \
						 easy-mceliece/mceliece6688128/int32_sort.h \
						 easy-mceliece/mceliece6688128/keccak.h \
						 easy-mceliece/mceliece6688128/operations.h \
						 easy-mceliece/mceliece6688128/params.h \
						 easy-mceliece/mceliece6688128/pk_gen.h \
						 easy-mceliece/mceliece6688128/randombytes.h \
						 easy-mceliece/mceliece6688128/root.h \
						 easy-mceliece/mceliece6688128/sk_gen.h \
						 easy-mceliece/mceliece6688128/synd.h \
						 easy-mceliece/mceliece6688128/transpose.h \
						 easy-mceliece/mceliece6688128/uint64_sort.h \
						 easy-mceliece/mceliece6688128/util.h \
						 easy-mceliece/mceliece6688128/subroutines/crypto_declassify.h \
						 easy-mceliece/mceliece6688128/subroutines/crypto_int16.h \
						 easy-mceliece/mceliece6688128/subroutines/crypto_int32.h \
						 easy-mceliece/mceliece6688128/subroutines/crypto_uint16.h \
						 easy-mceliece/mceliece6688128/subroutines/crypto_uint32.h \
						 easy-mceliece/mceliece6688128/subroutines/crypto_uint64.h

MCELIECE6688128SOURCES = easy-mceliece/mceliece6688128/benes.c \
						 easy-mceliece/mceliece6688128/bm.c \
						 easy-mceliece/mceliece6688128/controlbits.c \
						 easy-mceliece/mceliece6688128/decrypt.c \
						 easy-mceliece/mceliece6688128/encrypt.c \
						 easy-mceliece/mceliece6688128/gf.c \
						 easy-mceliece/mceliece6688128/keccak.c \
						 easy-mceliece/mceliece6688128/operations.c \
						 easy-mceliece/mceliece6688128/pk_gen.c \
						 easy-mceliece/mceliece6688128/randombytes.c \
						 easy-mceliece/mceliece6688128/root.c \
						 easy-mceliece/mceliece6688128/sk_gen.c \
						 easy-mceliece/mceliece6688128/synd.c \
						 easy-mceliece/mceliece6688128/transpose.c \
						 easy-mceliece/mceliece6688128/util.c

MCELIECE6960119HEADERS = easy-mceliece/mceliece6960119/api.h \
						 easy-mceliece/mceliece6960119/benes.h \
						 easy-mceliece/mceliece6960119/bm.h \
						 easy-mceliece/mceliece6960119/controlbits.h \
						 easy-mceliece/mceliece6960119/crypto_hash.h \
						 easy-mceliece/mceliece6960119/crypto_kem.h \
						 easy-mceliece/mceliece6960119/crypto_kem_mceliece6960119.h \
						 easy-mceliece/mceliece6960119/decrypt.h \
						 easy-mceliece/mceliece6960119/encrypt.h \
						 easy-mceliece/mceliece6960119/gf.h \
						 easy-mceliece/mceliece6960119/int32_sort.h \
						 easy-mceliece/mceliece6960119/keccak.h \
						 easy-mceliece/mceliece6960119/operations.h \
						 easy-mceliece/mceliece6960119/params.h \
						 easy-mceliece/mceliece6960119/pk_gen.h \
						 easy-mceliece/mceliece6960119/randombytes.h \
						 easy-mceliece/mceliece6960119/root.h \
						 easy-mceliece/mceliece6960119/sk_gen.h \
						 easy-mceliece/mceliece6960119/synd.h \
						 easy-mceliece/mceliece6960119/transpose.h \
						 easy-mceliece/mceliece6960119/uint64_sort.h \
						 easy-mceliece/mceliece6960119/util.h \
						 easy-mceliece/mceliece6960119/subroutines/crypto_declassify.h \
						 easy-mceliece/mceliece6960119/subroutines/crypto_int16.h \
						 easy-mceliece/mceliece6960119/subroutines/crypto_int32.h \
						 easy-mceliece/mceliece6960119/subroutines/crypto_uint16.h \
						 easy-mceliece/mceliece6960119/subroutines/crypto_uint32.h \
						 easy-mceliece/mceliece6960119/subroutines/crypto_uint64.h

MCELIECE6960119SOURCES = easy-mceliece/mceliece6960119/benes.c \
						 easy-mceliece/mceliece6960119/bm.c \
						 easy-mceliece/mceliece6960119/controlbits.c \
						 easy-mceliece/mceliece6960119/decrypt.c \
						 easy-mceliece/mceliece6960119/encrypt.c \
						 easy-mceliece/mceliece6960119/gf.c \
						 easy-mceliece/mceliece6960119/keccak.c \
						 easy-mceliece/mceliece6960119/operations.c \
						 easy-mceliece/mceliece6960119/pk_gen.c \
						 easy-mceliece/mceliece6960119/randombytes.c \
						 easy-mceliece/mceliece6960119/root.c \
						 easy-mceliece/mceliece6960119/sk_gen.c \
						 easy-mceliece/mceliece6960119/synd.c \
						 easy-mceliece/mceliece6960119/transpose.c \
						 easy-mceliece/mceliece6960119/util.c

MCELIECE8192128HEADERS = easy-mceliece/mceliece8192128/api.h \
						 easy-mceliece/mceliece8192128/benes.h \
						 easy-mceliece/mceliece8192128/bm.h \
						 easy-mceliece/mceliece8192128/controlbits.h \
						 easy-mceliece/mceliece8192128/crypto_hash.h \
						 easy-mceliece/mceliece8192128/crypto_kem.h \
						 easy-mceliece/mceliece8192128/crypto_kem_mceliece8192128.h \
						 easy-mceliece/mceliece8192128/decrypt.h \
						 easy-mceliece/mceliece8192128/encrypt.h \
						 easy-mceliece/mceliece8192128/gf.h \
						 easy-mceliece/mceliece8192128/int32_sort.h \
						 easy-mceliece/mceliece8192128/keccak.h \
						 easy-mceliece/mceliece8192128/operations.h \
						 easy-mceliece/mceliece8192128/params.h \
						 easy-mceliece/mceliece8192128/pk_gen.h \
						 easy-mceliece/mceliece8192128/randombytes.h \
						 easy-mceliece/mceliece8192128/root.h \
						 easy-mceliece/mceliece8192128/sk_gen.h \
						 easy-mceliece/mceliece8192128/synd.h \
						 easy-mceliece/mceliece8192128/transpose.h \
						 easy-mceliece/mceliece8192128/uint64_sort.h \
						 easy-mceliece/mceliece8192128/util.h \
						 easy-mceliece/mceliece8192128/subroutines/crypto_declassify.h \
						 easy-mceliece/mceliece8192128/subroutines/crypto_int16.h \
						 easy-mceliece/mceliece8192128/subroutines/crypto_int32.h \
						 easy-mceliece/mceliece8192128/subroutines/crypto_uint16.h \
						 easy-mceliece/mceliece8192128/subroutines/crypto_uint32.h \
						 easy-mceliece/mceliece8192128/subroutines/crypto_uint64.h

MCELIECE8192128SOURCES = easy-mceliece/mceliece8192128/benes.c \
						 easy-mceliece/mceliece8192128/bm.c \
						 easy-mceliece/mceliece8192128/controlbits.c \
						 easy-mceliece/mceliece8192128/decrypt.c \
						 easy-mceliece/mceliece8192128/encrypt.c \
						 easy-mceliece/mceliece8192128/gf.c \
						 easy-mceliece/mceliece8192128/keccak.c \
						 easy-mceliece/mceliece8192128/operations.c \
						 easy-mceliece/mceliece8192128/pk_gen.c \
						 easy-mceliece/mceliece8192128/randombytes.c \
						 easy-mceliece/mceliece8192128/root.c \
						 easy-mceliece/mceliece8192128/sk_gen.c \
						 easy-mceliece/mceliece8192128/synd.c \
						 easy-mceliece/mceliece8192128/transpose.c \
						 easy-mceliece/mceliece8192128/util.c

SOURCES = authenticators.c etmkem.c pke.c
HEADERS = authenticators.h etmkem.h pke.h

# OpenSSL header files should be included using the CFLAGS environment variables:
# for example `export CFLAGS="-I/path/to/openssl/include $CFLAGS"`
CFLAGS += -O3 # -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls -Wshadow -Wpointer-arith -fomit-frame-pointer -Wno-incompatible-pointer-types
# OpenSSL library files are included using the LDFLAGS environment variable:
# `export LDFLAGS="-L/path/to/opensl/lib $LDFLAGS"
LDFLAGS += -lcrypto

# phony targets will be rerun everytime even if the input files did not change
.PHONY = main tests

main: $(SOURCES) $(HEADERS) main.c
	$(CC) $(CFLAGS) $(LDFLAGS) $(MCELIECE8192128SOURCES) -DPKE_MCELIECE8192128 pke.c main.c -o target/$@
	./target/$@

test_pke_correctness: pke.c test_pke_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) $(KYBERSOURCES) pke.c -DPKE_KYBER -DKYBER_K=2 test_pke_correctness.c -o target/test_pke_kyber512_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) $(KYBERSOURCES) pke.c -DPKE_KYBER -DKYBER_K=3 test_pke_correctness.c -o target/test_pke_kyber768_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) $(KYBERSOURCES) pke.c -DPKE_KYBER -DKYBER_K=4 test_pke_correctness.c -o target/test_pke_kyber1024_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) $(MCELIECE348864SOURCES) pke.c -DPKE_MCELIECE348864 test_pke_correctness.c -o target/test_pke_mceliece348864_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) $(MCELIECE460896SOURCES) pke.c -DPKE_MCELIECE460896 test_pke_correctness.c -o target/test_pke_mceliece460896_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) $(MCELIECE6688128SOURCES) pke.c -DPKE_MCELIECE6688128 test_pke_correctness.c -o target/test_pke_mceliece6688128_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) $(MCELIECE6960119SOURCES) pke.c -DPKE_MCELIECE6960119 test_pke_correctness.c -o target/test_pke_mceliece6960119_correctness
	$(CC) $(CFLAGS) $(LDFLAGS) $(MCELIECE8192128SOURCES) pke.c -DPKE_MCELIECE8192128 test_pke_correctness.c -o target/test_pke_mceliece8192128_correctness
	time ./target/test_pke_kyber512_correctness
	time ./target/test_pke_kyber768_correctness
	time ./target/test_pke_kyber1024_correctness
	time ./target/test_pke_mceliece348864_correctness
	time ./target/test_pke_mceliece460896_correctness
	time ./target/test_pke_mceliece6688128_correctness
	time ./target/test_pke_mceliece6960119_correctness
	time ./target/test_pke_mceliece8192128_correctness

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
