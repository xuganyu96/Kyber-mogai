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

# ref implementation of mceliece has very slow decryption
MCELIECEREFHEADERS = ref/api.h \
					 ref/benes.h \
					 ref/bm.h \
					 ref/controlbits.h \
					 ref/crypto_hash.h \
					 ref/crypto_kem.h \
					 ref/decrypt.h \
					 ref/encrypt.h \
					 ref/gf.h \
					 ref/int32_sort.h \
					 ref/keccak.h \
					 ref/operations.h \
					 ref/params.h \
					 ref/pk_gen.h \
					 ref/randombytes.h \
					 ref/root.h \
					 ref/sk_gen.h \
					 ref/synd.h \
					 ref/transpose.h \
					 ref/uint64_sort.h \
					 ref/util.h \
					 ref/crypto_declassify.h \
					 ref/crypto_int16.h \
					 ref/crypto_int32.h \
					 ref/crypto_uint16.h \
					 ref/crypto_uint32.h \
					 ref/crypto_uint64.h

MCELIECEREFSOURCES = ref/benes.c \
					 ref/bm.c \
					 ref/controlbits.c \
					 ref/decrypt.c \
					 ref/encrypt.c \
					 ref/gf.c \
					 ref/keccak.c \
					 ref/operations.c \
					 ref/pk_gen.c \
					 ref/randombytes.c \
					 ref/root.c \
					 ref/sk_gen.c \
					 ref/synd.c \
					 ref/transpose.c \
					 ref/util.c


# vec implementations of classic mceliece take longer to compile but will run
# faster
MCELIECEVECSOURCES = easy-mceliece/vec/benes.c \
					 easy-mceliece/vec/bm.c \
					 easy-mceliece/vec/controlbits.c \
					 easy-mceliece/vec/decrypt.c \
					 easy-mceliece/vec/encrypt.c \
					 easy-mceliece/vec/fft.c \
					 easy-mceliece/vec/fft_tr.c \
					 easy-mceliece/vec/gf.c \
					 easy-mceliece/vec/keccak.c \
					 easy-mceliece/vec/operations.c \
					 easy-mceliece/vec/pk_gen.c \
					 easy-mceliece/vec/randombytes.c \
					 easy-mceliece/vec/sk_gen.c \
					 easy-mceliece/vec/vec.c

MCELIECEVECHEADERS = easy-mceliece/vec/api.h \
					 easy-mceliece/vec/benes.h \
					 easy-mceliece/vec/bm.h \
					 easy-mceliece/vec/controlbits.h \
					 easy-mceliece/vec/crypto_declassify.h \
					 easy-mceliece/vec/crypto_hash.h \
					 easy-mceliece/vec/crypto_int16.h \
					 easy-mceliece/vec/crypto_int32.h \
					 easy-mceliece/vec/crypto_kem.h \
					 easy-mceliece/vec/crypto_uint16.h \
					 easy-mceliece/vec/crypto_uint32.h \
					 easy-mceliece/vec/crypto_uint64.h \
					 easy-mceliece/vec/decrypt.h \
					 easy-mceliece/vec/encrypt.h \
					 easy-mceliece/vec/fft.h \
					 easy-mceliece/vec/fft_tr.h \
					 easy-mceliece/vec/gf.h \
					 easy-mceliece/vec/int32_sort.h \
					 easy-mceliece/vec/keccak.h \
					 easy-mceliece/vec/operations.h \
					 easy-mceliece/vec/params.h \
					 easy-mceliece/vec/pk_gen.h \
					 easy-mceliece/vec/randombytes.h \
					 easy-mceliece/vec/sk_gen.h \
					 easy-mceliece/vec/transpose.h \
					 easy-mceliece/vec/uint16_sort.h \
					 easy-mceliece/vec/uint64_sort.h \
					 easy-mceliece/vec/util.h \
					 easy-mceliece/vec/vec.h

# use vec impl by default
MCELIECESOURCES = $(MCELIECEVECSOURCES)
MCELIECEHEADERS = $(MCELIECEVECHEADERS)

ETMKEMSOURCES = etmkem.c authenticators.c pke.c
ETMKEMHEADERS = etmkem.h authenticators.h pke.h

# If the DEBUG environment is set to 1, then all targets will be compiled with the flag -D__DEBUG__
ifeq ($(DEBUG),1)
	CFLAGS += -D__DEBUG__
endif

# OpenSSL header files should be included using the CFLAGS environment variables:
# for example `export CFLAGS="-I/path/to/openssl/include $CFLAGS"`
CFLAGS += -O3 -Wno-incompatible-pointer-types-discards-qualifiers -Wno-incompatible-pointer-types # -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls -Wshadow -Wpointer-arith -fomit-frame-pointer
# OpenSSL library files are included using the LDFLAGS environment variable:
# `export LDFLAGS="-L/path/to/opensl/lib $LDFLAGS"
LDFLAGS += -lcrypto

# phony targets will be rerun everytime even if the input files did not change
.PHONY: tests test_pke_correctness test_kyber_kem_correctness test_mceliece_kem_correctness test_etmkem_correctness speed test_pke_speed test_kem_speed test_kyber_kem_speed test_mceliece_kem_speed test_etmkem_speed kex run_kex_clients_all run_kex_clients_auth_none run_kex_clients_auth_server run_kex_clients_auth_all run_kex_servers_all run_kex_servers_auth_none run_kex_servers_auth_server run_kex_servers_auth_all

tests: test_pke_correctness test_kyber_kem_correctness test_mceliece_kem_correctness test_etmkem_correctness

test_pke_correctness: \
	target/test_kyber512_pke_correctness \
	target/test_kyber768_pke_correctness \
	target/test_kyber1024_pke_correctness \
	target/test_mceliece348864_pke_correctness \
	target/test_mceliece460896_pke_correctness \
	target/test_mceliece6688128_pke_correctness \
	target/test_mceliece6960119_pke_correctness \
	target/test_mceliece8192128_pke_correctness \
	target/test_mceliece348864f_pke_correctness \
	target/test_mceliece460896f_pke_correctness \
	target/test_mceliece6688128f_pke_correctness \
	target/test_mceliece6960119f_pke_correctness \
	target/test_mceliece8192128f_pke_correctness
	./target/test_kyber512_pke_correctness
	./target/test_kyber768_pke_correctness
	./target/test_kyber1024_pke_correctness
	./target/test_mceliece348864_pke_correctness
	./target/test_mceliece460896_pke_correctness
	./target/test_mceliece6688128_pke_correctness
	./target/test_mceliece6960119_pke_correctness
	./target/test_mceliece8192128_pke_correctness
	./target/test_mceliece348864f_pke_correctness
	./target/test_mceliece460896f_pke_correctness
	./target/test_mceliece6688128f_pke_correctness
	./target/test_mceliece6960119f_pke_correctness
	./target/test_mceliece8192128f_pke_correctness

target/test_kyber512_pke_correctness: $(KYBERSOURCES) $(KYBERHEADERS) pke.c pke.h test_pke_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=2 $(KYBERSOURCES) pke.c test_pke_correctness.c -o $@

target/test_kyber768_pke_correctness: $(KYBERSOURCES) $(KYBERHEADERS) pke.c pke.h test_pke_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=3 $(KYBERSOURCES) pke.c test_pke_correctness.c -o $@

target/test_kyber1024_pke_correctness: $(KYBERSOURCES) $(KYBERHEADERS) pke.c pke.h test_pke_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=4 $(KYBERSOURCES) pke.c test_pke_correctness.c -o $@

target/test_mceliece348864_pke_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) pke.c pke.h test_pke_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=3488 $(MCELIECESOURCES) pke.c test_pke_correctness.c -o $@

target/test_mceliece460896_pke_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) pke.c pke.h test_pke_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=4608 $(MCELIECESOURCES) pke.c test_pke_correctness.c -o $@

target/test_mceliece6688128_pke_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) pke.c pke.h test_pke_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6688 $(MCELIECESOURCES) pke.c test_pke_correctness.c -o $@

target/test_mceliece6960119_pke_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) pke.c pke.h test_pke_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6960 $(MCELIECESOURCES) pke.c test_pke_correctness.c -o $@

target/test_mceliece8192128_pke_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) pke.c pke.h test_pke_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=8192 $(MCELIECESOURCES) pke.c test_pke_correctness.c -o $@

target/test_mceliece348864f_pke_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) pke.c pke.h test_pke_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=3488 -DFASTKEYGEN $(MCELIECESOURCES) pke.c test_pke_correctness.c -o $@

target/test_mceliece460896f_pke_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) pke.c pke.h test_pke_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=4608 -DFASTKEYGEN $(MCELIECESOURCES) pke.c test_pke_correctness.c -o $@

target/test_mceliece6688128f_pke_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) pke.c pke.h test_pke_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6688 -DFASTKEYGEN $(MCELIECESOURCES) pke.c test_pke_correctness.c -o $@

target/test_mceliece6960119f_pke_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) pke.c pke.h test_pke_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6960 -DFASTKEYGEN $(MCELIECESOURCES) pke.c test_pke_correctness.c -o $@

target/test_mceliece8192128f_pke_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) pke.c pke.h test_pke_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=8192 -DFASTKEYGEN $(MCELIECESOURCES) pke.c test_pke_correctness.c -o $@

test_kyber_kem_correctness: \
	target/test_kyber512_kem_correctness \
	target/test_kyber768_kem_correctness \
	target/test_kyber1024_kem_correctness
	target/test_kyber512_kem_correctness
	target/test_kyber768_kem_correctness
	target/test_kyber1024_kem_correctness

target/test_kyber512_kem_correctness: $(KYBERSOURCES) $(KYBERHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=2 $(KYBERSOURCES) test_kem_correctness.c -o $@

target/test_kyber768_kem_correctness: $(KYBERSOURCES) $(KYBERHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=3 $(KYBERSOURCES) test_kem_correctness.c -o $@

target/test_kyber1024_kem_correctness: $(KYBERSOURCES) $(KYBERHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=4 $(KYBERSOURCES) test_kem_correctness.c -o $@

test_mceliece_kem_correctness: \
	target/test_mceliece348864_kem_correctness \
	target/test_mceliece460896_kem_correctness \
	target/test_mceliece6688128_kem_correctness \
	target/test_mceliece6960119_kem_correctness \
	target/test_mceliece8192128_kem_correctness \
	target/test_mceliece348864f_kem_correctness \
	target/test_mceliece460896f_kem_correctness \
	target/test_mceliece6688128f_kem_correctness \
	target/test_mceliece6960119f_kem_correctness \
	target/test_mceliece8192128f_kem_correctness
	target/test_mceliece348864_kem_correctness
	target/test_mceliece460896_kem_correctness
	target/test_mceliece6688128_kem_correctness
	target/test_mceliece6960119_kem_correctness
	target/test_mceliece8192128_kem_correctness
	target/test_mceliece348864f_kem_correctness
	target/test_mceliece460896f_kem_correctness
	target/test_mceliece6688128f_kem_correctness
	target/test_mceliece6960119f_kem_correctness
	target/test_mceliece8192128f_kem_correctness

target/test_mceliece348864_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=3488 $(MCELIECESOURCES) test_kem_correctness.c -o $@

target/test_mceliece460896_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=4608 $(MCELIECESOURCES) test_kem_correctness.c -o $@

target/test_mceliece6688128_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6688 $(MCELIECESOURCES) test_kem_correctness.c -o $@

target/test_mceliece6960119_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6960 $(MCELIECESOURCES) test_kem_correctness.c -o $@

target/test_mceliece8192128_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=8192 $(MCELIECESOURCES) test_kem_correctness.c -o $@

target/test_mceliece348864f_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=3488 -DFASTKEYGEN $(MCELIECESOURCES) test_kem_correctness.c -o $@

target/test_mceliece460896f_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=4608 -DFASTKEYGEN $(MCELIECESOURCES) test_kem_correctness.c -o $@

target/test_mceliece6688128f_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6688 -DFASTKEYGEN $(MCELIECESOURCES) test_kem_correctness.c -o $@

target/test_mceliece6960119f_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6960 -DFASTKEYGEN $(MCELIECESOURCES) test_kem_correctness.c -o $@

target/test_mceliece8192128f_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=8192 -DFASTKEYGEN $(MCELIECESOURCES) test_kem_correctness.c -o $@

test_etmkem_correctness: \
	target/test_kyber512poly1305_kem_correctness \
	target/test_kyber768poly1305_kem_correctness \
	target/test_kyber1024poly1305_kem_correctness \
	target/test_mceliece348864poly1305_kem_correctness \
	target/test_mceliece460896poly1305_kem_correctness \
	target/test_mceliece6688128poly1305_kem_correctness \
	target/test_mceliece6960119poly1305_kem_correctness \
	target/test_mceliece8192128poly1305_kem_correctness \
	target/test_mceliece348864fpoly1305_kem_correctness \
	target/test_mceliece460896fpoly1305_kem_correctness \
	target/test_mceliece6688128fpoly1305_kem_correctness \
	target/test_mceliece6960119fpoly1305_kem_correctness \
	target/test_mceliece8192128fpoly1305_kem_correctness \
	target/test_kyber512gmac_kem_correctness \
	target/test_kyber768gmac_kem_correctness \
	target/test_kyber1024gmac_kem_correctness \
	target/test_mceliece348864gmac_kem_correctness \
	target/test_mceliece460896gmac_kem_correctness \
	target/test_mceliece6688128gmac_kem_correctness \
	target/test_mceliece6960119gmac_kem_correctness \
	target/test_mceliece8192128gmac_kem_correctness \
	target/test_mceliece348864fgmac_kem_correctness \
	target/test_mceliece460896fgmac_kem_correctness \
	target/test_mceliece6688128fgmac_kem_correctness \
	target/test_mceliece6960119fgmac_kem_correctness \
	target/test_mceliece8192128fgmac_kem_correctness \
	target/test_kyber512cmac_kem_correctness \
	target/test_kyber768cmac_kem_correctness \
	target/test_kyber1024cmac_kem_correctness \
	target/test_mceliece348864cmac_kem_correctness \
	target/test_mceliece460896cmac_kem_correctness \
	target/test_mceliece6688128cmac_kem_correctness \
	target/test_mceliece6960119cmac_kem_correctness \
	target/test_mceliece8192128cmac_kem_correctness \
	target/test_mceliece348864fcmac_kem_correctness \
	target/test_mceliece460896fcmac_kem_correctness \
	target/test_mceliece6688128fcmac_kem_correctness \
	target/test_mceliece6960119fcmac_kem_correctness \
	target/test_mceliece8192128fcmac_kem_correctness \
	target/test_kyber512kmac256_kem_correctness \
	target/test_kyber768kmac256_kem_correctness \
	target/test_kyber1024kmac256_kem_correctness \
	target/test_mceliece348864kmac256_kem_correctness \
	target/test_mceliece460896kmac256_kem_correctness \
	target/test_mceliece6688128kmac256_kem_correctness \
	target/test_mceliece6960119kmac256_kem_correctness \
	target/test_mceliece8192128kmac256_kem_correctness \
	target/test_mceliece348864fkmac256_kem_correctness \
	target/test_mceliece460896fkmac256_kem_correctness \
	target/test_mceliece6688128fkmac256_kem_correctness \
	target/test_mceliece6960119fkmac256_kem_correctness \
	target/test_mceliece8192128fkmac256_kem_correctness
	target/test_kyber512poly1305_kem_correctness
	target/test_kyber768poly1305_kem_correctness
	target/test_kyber1024poly1305_kem_correctness
	target/test_mceliece348864poly1305_kem_correctness
	target/test_mceliece460896poly1305_kem_correctness
	target/test_mceliece6688128poly1305_kem_correctness
	target/test_mceliece6960119poly1305_kem_correctness
	target/test_mceliece8192128poly1305_kem_correctness
	target/test_mceliece348864fpoly1305_kem_correctness
	target/test_mceliece460896fpoly1305_kem_correctness
	target/test_mceliece6688128fpoly1305_kem_correctness
	target/test_mceliece6960119fpoly1305_kem_correctness
	target/test_mceliece8192128fpoly1305_kem_correctness
	target/test_kyber512gmac_kem_correctness
	target/test_kyber768gmac_kem_correctness
	target/test_kyber1024gmac_kem_correctness
	target/test_mceliece348864gmac_kem_correctness
	target/test_mceliece460896gmac_kem_correctness
	target/test_mceliece6688128gmac_kem_correctness
	target/test_mceliece6960119gmac_kem_correctness
	target/test_mceliece8192128gmac_kem_correctness
	target/test_mceliece348864fgmac_kem_correctness
	target/test_mceliece460896fgmac_kem_correctness
	target/test_mceliece6688128fgmac_kem_correctness
	target/test_mceliece6960119fgmac_kem_correctness
	target/test_mceliece8192128fgmac_kem_correctness
	target/test_kyber512cmac_kem_correctness
	target/test_kyber768cmac_kem_correctness
	target/test_kyber1024cmac_kem_correctness
	target/test_mceliece348864cmac_kem_correctness
	target/test_mceliece460896cmac_kem_correctness
	target/test_mceliece6688128cmac_kem_correctness
	target/test_mceliece6960119cmac_kem_correctness
	target/test_mceliece8192128cmac_kem_correctness
	target/test_mceliece348864fcmac_kem_correctness
	target/test_mceliece460896fcmac_kem_correctness
	target/test_mceliece6688128fcmac_kem_correctness
	target/test_mceliece6960119fcmac_kem_correctness
	target/test_mceliece8192128fcmac_kem_correctness
	target/test_kyber512kmac256_kem_correctness
	target/test_kyber768kmac256_kem_correctness
	target/test_kyber1024kmac256_kem_correctness
	target/test_mceliece348864kmac256_kem_correctness
	target/test_mceliece460896kmac256_kem_correctness
	target/test_mceliece6688128kmac256_kem_correctness
	target/test_mceliece6960119kmac256_kem_correctness
	target/test_mceliece8192128kmac256_kem_correctness
	target/test_mceliece348864fkmac256_kem_correctness
	target/test_mceliece460896fkmac256_kem_correctness
	target/test_mceliece6688128fkmac256_kem_correctness
	target/test_mceliece6960119fkmac256_kem_correctness
	target/test_mceliece8192128fkmac256_kem_correctness

target/test_kyber512poly1305_kem_correctness: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_KYBER -DKYBER_K=2 $(KYBERSOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_kyber768poly1305_kem_correctness: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_KYBER -DKYBER_K=3 $(KYBERSOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_kyber1024poly1305_kem_correctness: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_KYBER -DKYBER_K=4 $(KYBERSOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece348864poly1305_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=3488 $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece460896poly1305_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=4608 $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece6688128poly1305_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=6688 $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece6960119poly1305_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=6960 $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece8192128poly1305_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=8192 $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece348864fpoly1305_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=3488 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece460896fpoly1305_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=4608 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece6688128fpoly1305_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=6688 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece6960119fpoly1305_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=6960 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece8192128fpoly1305_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=8192 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_kyber512gmac_kem_correctness: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_KYBER -DKYBER_K=2 $(KYBERSOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_kyber768gmac_kem_correctness: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_KYBER -DKYBER_K=3 $(KYBERSOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_kyber1024gmac_kem_correctness: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_KYBER -DKYBER_K=4 $(KYBERSOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece348864gmac_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=3488 $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece460896gmac_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=4608 $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece6688128gmac_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=6688 $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece6960119gmac_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=6960 $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece8192128gmac_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=8192 $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece348864fgmac_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=3488 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece460896fgmac_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=4608 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece6688128fgmac_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=6688 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece6960119fgmac_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=6960 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece8192128fgmac_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=8192 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_kyber512cmac_kem_correctness: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_KYBER -DKYBER_K=2 $(KYBERSOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_kyber768cmac_kem_correctness: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_KYBER -DKYBER_K=3 $(KYBERSOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_kyber1024cmac_kem_correctness: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_KYBER -DKYBER_K=4 $(KYBERSOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece348864cmac_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=3488 $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece460896cmac_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=4608 $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece6688128cmac_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=6688 $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece6960119cmac_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=6960 $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece8192128cmac_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=8192 $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece348864fcmac_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=3488 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece460896fcmac_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=4608 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece6688128fcmac_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=6688 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece6960119fcmac_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=6960 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece8192128fcmac_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=8192 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_kyber512kmac256_kem_correctness: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_KYBER -DKYBER_K=2 $(KYBERSOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_kyber768kmac256_kem_correctness: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_KYBER -DKYBER_K=3 $(KYBERSOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_kyber1024kmac256_kem_correctness: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_KYBER -DKYBER_K=4 $(KYBERSOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece348864kmac256_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=3488 $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece460896kmac256_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=4608 $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece6688128kmac256_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=6688 $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece6960119kmac256_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=6960 $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece8192128kmac256_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=8192 $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece348864fkmac256_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=3488 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece460896fkmac256_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=4608 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece6688128fkmac256_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=6688 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece6960119fkmac256_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=6960 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

target/test_mceliece8192128fkmac256_kem_correctness: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) test_kem_correctness.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=8192 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) test_kem_correctness.c -o $@

speed: test_pke_speed test_kem_speed

test_pke_speed: \
	target/test_kyber512_pke_speed \
	target/test_kyber768_pke_speed \
	target/test_kyber1024_pke_speed \
	target/test_mceliece348864_pke_speed \
	target/test_mceliece460896_pke_speed \
	target/test_mceliece6688128_pke_speed \
	target/test_mceliece6960119_pke_speed \
	target/test_mceliece8192128_pke_speed \
	target/test_mceliece348864f_pke_speed \
	target/test_mceliece460896f_pke_speed \
	target/test_mceliece6688128f_pke_speed \
	target/test_mceliece6960119f_pke_speed \
	target/test_mceliece8192128f_pke_speed
	target/test_kyber512_pke_speed
	target/test_kyber768_pke_speed
	target/test_kyber1024_pke_speed
	target/test_mceliece348864_pke_speed
	target/test_mceliece460896_pke_speed
	target/test_mceliece6688128_pke_speed
	target/test_mceliece6960119_pke_speed
	target/test_mceliece8192128_pke_speed
	target/test_mceliece348864f_pke_speed
	target/test_mceliece460896f_pke_speed
	target/test_mceliece6688128f_pke_speed
	target/test_mceliece6960119f_pke_speed
	target/test_mceliece8192128f_pke_speed

target/test_kyber512_pke_speed: $(KYBERSOURCES) $(KYBERHEADERS) pke.c pke.h speed.c speed.h test_pke_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=2 $(KYBERSOURCES) speed.c pke.c test_pke_speed.c -o $@

target/test_kyber768_pke_speed: $(KYBERSOURCES) $(KYBERHEADERS) pke.c pke.h speed.c speed.h test_pke_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=3 $(KYBERSOURCES) speed.c pke.c test_pke_speed.c -o $@

target/test_kyber1024_pke_speed: $(KYBERSOURCES) $(KYBERHEADERS) pke.c pke.h speed.c speed.h test_pke_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=4 $(KYBERSOURCES) speed.c pke.c test_pke_speed.c -o $@

target/test_mceliece348864_pke_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) pke.c pke.h speed.c speed.h test_pke_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=3488 $(MCELIECESOURCES) speed.c pke.c test_pke_speed.c -o $@

target/test_mceliece460896_pke_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) pke.c pke.h speed.c speed.h test_pke_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=4608 $(MCELIECESOURCES) speed.c pke.c test_pke_speed.c -o $@

target/test_mceliece6688128_pke_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) pke.c pke.h speed.c speed.h test_pke_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6688 $(MCELIECESOURCES) speed.c pke.c test_pke_speed.c -o $@

target/test_mceliece6960119_pke_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) pke.c pke.h speed.c speed.h test_pke_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6960 $(MCELIECESOURCES) speed.c pke.c test_pke_speed.c -o $@

target/test_mceliece8192128_pke_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) pke.c pke.h speed.c speed.h test_pke_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=8192 $(MCELIECESOURCES) speed.c pke.c test_pke_speed.c -o $@

target/test_mceliece348864f_pke_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) pke.c pke.h speed.c speed.h test_pke_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=3488 -DFASTKEYGEN $(MCELIECESOURCES) speed.c pke.c test_pke_speed.c -o $@

target/test_mceliece460896f_pke_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) pke.c pke.h speed.c speed.h test_pke_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=4608 -DFASTKEYGEN $(MCELIECESOURCES) speed.c pke.c test_pke_speed.c -o $@

target/test_mceliece6688128f_pke_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) pke.c pke.h speed.c speed.h test_pke_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6688 -DFASTKEYGEN $(MCELIECESOURCES) speed.c pke.c test_pke_speed.c -o $@

target/test_mceliece6960119f_pke_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) pke.c pke.h speed.c speed.h test_pke_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6960 -DFASTKEYGEN $(MCELIECESOURCES) speed.c pke.c test_pke_speed.c -o $@

target/test_mceliece8192128f_pke_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) pke.c pke.h speed.c speed.h test_pke_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=8192 -DFASTKEYGEN $(MCELIECESOURCES) speed.c pke.c test_pke_speed.c -o $@

test_kem_speed: test_kyber_kem_speed test_mceliece_kem_speed test_etmkem_speed

test_kyber_kem_speed: \
	target/test_kyber512_kem_speed \
	target/test_kyber768_kem_speed \
	target/test_kyber1024_kem_speed
	target/test_kyber512_kem_speed
	target/test_kyber768_kem_speed
	target/test_kyber1024_kem_speed

# Kyber KEM speed
target/test_kyber512_kem_speed: $(KYBERSOURCES) $(KYBERHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=2 $(KYBERSOURCES) speed.c test_kem_speed.c -o $@

target/test_kyber768_kem_speed: $(KYBERSOURCES) $(KYBERHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=3 $(KYBERSOURCES) speed.c test_kem_speed.c -o $@

target/test_kyber1024_kem_speed: $(KYBERSOURCES) $(KYBERHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=4 $(KYBERSOURCES) speed.c test_kem_speed.c -o $@

test_mceliece_kem_speed: \
	target/test_mceliece348864_kem_speed \
	target/test_mceliece460896_kem_speed \
	target/test_mceliece6688128_kem_speed \
	target/test_mceliece6960119_kem_speed \
	target/test_mceliece8192128_kem_speed \
	target/test_mceliece348864f_kem_speed \
	target/test_mceliece460896f_kem_speed \
	target/test_mceliece6688128f_kem_speed \
	target/test_mceliece6960119f_kem_speed \
	target/test_mceliece8192128f_kem_speed
	target/test_mceliece348864_kem_speed
	target/test_mceliece460896_kem_speed
	target/test_mceliece6688128_kem_speed
	target/test_mceliece6960119_kem_speed
	target/test_mceliece8192128_kem_speed
	target/test_mceliece348864f_kem_speed
	target/test_mceliece460896f_kem_speed
	target/test_mceliece6688128f_kem_speed
	target/test_mceliece6960119f_kem_speed
	target/test_mceliece8192128f_kem_speed

target/test_mceliece348864_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=3488 $(MCELIECESOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece460896_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=4608 $(MCELIECESOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece6688128_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6688 $(MCELIECESOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece6960119_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6960 $(MCELIECESOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece8192128_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=8192 $(MCELIECESOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece348864f_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=3488 -DFASTKEYGEN $(MCELIECESOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece460896f_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=4608 -DFASTKEYGEN $(MCELIECESOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece6688128f_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6688 -DFASTKEYGEN $(MCELIECESOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece6960119f_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6960 -DFASTKEYGEN $(MCELIECESOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece8192128f_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=8192 -DFASTKEYGEN $(MCELIECESOURCES) speed.c test_kem_speed.c -o $@

test_etmkem_speed: \
	target/test_kyber512poly1305_kem_speed \
	target/test_kyber768poly1305_kem_speed \
	target/test_kyber1024poly1305_kem_speed \
	target/test_mceliece348864poly1305_kem_speed \
	target/test_mceliece460896poly1305_kem_speed \
	target/test_mceliece6688128poly1305_kem_speed \
	target/test_mceliece6960119poly1305_kem_speed \
	target/test_mceliece8192128poly1305_kem_speed \
	target/test_mceliece348864fpoly1305_kem_speed \
	target/test_mceliece460896fpoly1305_kem_speed \
	target/test_mceliece6688128fpoly1305_kem_speed \
	target/test_mceliece6960119fpoly1305_kem_speed \
	target/test_mceliece8192128fpoly1305_kem_speed \
	target/test_kyber512gmac_kem_speed \
	target/test_kyber768gmac_kem_speed \
	target/test_kyber1024gmac_kem_speed \
	target/test_mceliece348864gmac_kem_speed \
	target/test_mceliece460896gmac_kem_speed \
	target/test_mceliece6688128gmac_kem_speed \
	target/test_mceliece6960119gmac_kem_speed \
	target/test_mceliece8192128gmac_kem_speed \
	target/test_mceliece348864fgmac_kem_speed \
	target/test_mceliece460896fgmac_kem_speed \
	target/test_mceliece6688128fgmac_kem_speed \
	target/test_mceliece6960119fgmac_kem_speed \
	target/test_mceliece8192128fgmac_kem_speed \
	target/test_kyber512cmac_kem_speed \
	target/test_kyber768cmac_kem_speed \
	target/test_kyber1024cmac_kem_speed \
	target/test_mceliece348864cmac_kem_speed \
	target/test_mceliece460896cmac_kem_speed \
	target/test_mceliece6688128cmac_kem_speed \
	target/test_mceliece6960119cmac_kem_speed \
	target/test_mceliece8192128cmac_kem_speed \
	target/test_mceliece348864fcmac_kem_speed \
	target/test_mceliece460896fcmac_kem_speed \
	target/test_mceliece6688128fcmac_kem_speed \
	target/test_mceliece6960119fcmac_kem_speed \
	target/test_mceliece8192128fcmac_kem_speed \
	target/test_kyber512kmac256_kem_speed \
	target/test_kyber768kmac256_kem_speed \
	target/test_kyber1024kmac256_kem_speed \
	target/test_mceliece348864kmac256_kem_speed \
	target/test_mceliece460896kmac256_kem_speed \
	target/test_mceliece6688128kmac256_kem_speed \
	target/test_mceliece6960119kmac256_kem_speed \
	target/test_mceliece8192128kmac256_kem_speed \
	target/test_mceliece348864fkmac256_kem_speed \
	target/test_mceliece460896fkmac256_kem_speed \
	target/test_mceliece6688128fkmac256_kem_speed \
	target/test_mceliece6960119fkmac256_kem_speed \
	target/test_mceliece8192128fkmac256_kem_speed
	target/test_kyber512poly1305_kem_speed
	target/test_kyber768poly1305_kem_speed
	target/test_kyber1024poly1305_kem_speed
	target/test_mceliece348864poly1305_kem_speed
	target/test_mceliece460896poly1305_kem_speed
	target/test_mceliece6688128poly1305_kem_speed
	target/test_mceliece6960119poly1305_kem_speed
	target/test_mceliece8192128poly1305_kem_speed
	target/test_mceliece348864fpoly1305_kem_speed
	target/test_mceliece460896fpoly1305_kem_speed
	target/test_mceliece6688128fpoly1305_kem_speed
	target/test_mceliece6960119fpoly1305_kem_speed
	target/test_mceliece8192128fpoly1305_kem_speed
	target/test_kyber512gmac_kem_speed
	target/test_kyber768gmac_kem_speed
	target/test_kyber1024gmac_kem_speed
	target/test_mceliece348864gmac_kem_speed
	target/test_mceliece460896gmac_kem_speed
	target/test_mceliece6688128gmac_kem_speed
	target/test_mceliece6960119gmac_kem_speed
	target/test_mceliece8192128gmac_kem_speed
	target/test_mceliece348864fgmac_kem_speed
	target/test_mceliece460896fgmac_kem_speed
	target/test_mceliece6688128fgmac_kem_speed
	target/test_mceliece6960119fgmac_kem_speed
	target/test_mceliece8192128fgmac_kem_speed
	target/test_kyber512cmac_kem_speed
	target/test_kyber768cmac_kem_speed
	target/test_kyber1024cmac_kem_speed
	target/test_mceliece348864cmac_kem_speed
	target/test_mceliece460896cmac_kem_speed
	target/test_mceliece6688128cmac_kem_speed
	target/test_mceliece6960119cmac_kem_speed
	target/test_mceliece8192128cmac_kem_speed
	target/test_mceliece348864fcmac_kem_speed
	target/test_mceliece460896fcmac_kem_speed
	target/test_mceliece6688128fcmac_kem_speed
	target/test_mceliece6960119fcmac_kem_speed
	target/test_mceliece8192128fcmac_kem_speed
	target/test_kyber512kmac256_kem_speed
	target/test_kyber768kmac256_kem_speed
	target/test_kyber1024kmac256_kem_speed
	target/test_mceliece348864kmac256_kem_speed
	target/test_mceliece460896kmac256_kem_speed
	target/test_mceliece6688128kmac256_kem_speed
	target/test_mceliece6960119kmac256_kem_speed
	target/test_mceliece8192128kmac256_kem_speed
	target/test_mceliece348864fkmac256_kem_speed
	target/test_mceliece460896fkmac256_kem_speed
	target/test_mceliece6688128fkmac256_kem_speed
	target/test_mceliece6960119fkmac256_kem_speed
	target/test_mceliece8192128fkmac256_kem_speed




target/test_kyber512poly1305_kem_speed: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_KYBER -DKYBER_K=2 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_kyber768poly1305_kem_speed: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_KYBER -DKYBER_K=3 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_kyber1024poly1305_kem_speed: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_KYBER -DKYBER_K=4 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece348864poly1305_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=3488 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece460896poly1305_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=4608 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece6688128poly1305_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=6688 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece6960119poly1305_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=6960 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece8192128poly1305_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=8192 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece348864fpoly1305_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=3488 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece460896fpoly1305_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=4608 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece6688128fpoly1305_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=6688 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece6960119fpoly1305_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=6960 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece8192128fpoly1305_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=8192 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_kyber512gmac_kem_speed: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_KYBER -DKYBER_K=2 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_kyber768gmac_kem_speed: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_KYBER -DKYBER_K=3 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_kyber1024gmac_kem_speed: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_KYBER -DKYBER_K=4 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece348864gmac_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=3488 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece460896gmac_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=4608 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece6688128gmac_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=6688 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece6960119gmac_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=6960 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece8192128gmac_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=8192 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece348864fgmac_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=3488 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece460896fgmac_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=4608 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece6688128fgmac_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=6688 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece6960119fgmac_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=6960 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece8192128fgmac_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=8192 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_kyber512cmac_kem_speed: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_KYBER -DKYBER_K=2 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_kyber768cmac_kem_speed: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_KYBER -DKYBER_K=3 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_kyber1024cmac_kem_speed: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_KYBER -DKYBER_K=4 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece348864cmac_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=3488 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece460896cmac_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=4608 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece6688128cmac_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=6688 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece6960119cmac_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=6960 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece8192128cmac_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=8192 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece348864fcmac_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=3488 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece460896fcmac_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=4608 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece6688128fcmac_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=6688 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece6960119fcmac_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=6960 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece8192128fcmac_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=8192 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_kyber512kmac256_kem_speed: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_KYBER -DKYBER_K=2 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_kyber768kmac256_kem_speed: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_KYBER -DKYBER_K=3 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_kyber1024kmac256_kem_speed: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_KYBER -DKYBER_K=4 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece348864kmac256_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=3488 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece460896kmac256_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=4608 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece6688128kmac256_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=6688 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece6960119kmac256_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=6960 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece8192128kmac256_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=8192 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece348864fkmac256_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=3488 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece460896fkmac256_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=4608 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece6688128fkmac256_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=6688 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece6960119fkmac256_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=6960 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

target/test_mceliece8192128fkmac256_kem_speed: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h test_kem_speed.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=8192 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c test_kem_speed.c -o $@

# key exchange clients need to know where the server is:
server_name := 127.0.0.1
run_kex_clients_all: run_kex_clients_auth_none run_kex_clients_auth_server run_kex_clients_auth_all

run_kex_clients_auth_none: kex
	sleep 1 && ./target/kex_kyber512_client none $(server_name) 8000
	sleep 1 && ./target/kex_kyber768_client none $(server_name) 8001
	sleep 1 && ./target/kex_kyber1024_client none $(server_name) 8002
	sleep 1 && ./target/kex_mceliece348864_client none $(server_name) 8003
	sleep 1 && ./target/kex_mceliece460896_client none $(server_name) 8004
	sleep 1 && ./target/kex_mceliece6688128_client none $(server_name) 8005
	sleep 1 && ./target/kex_mceliece6960119_client none $(server_name) 8006
	sleep 1 && ./target/kex_mceliece8192128_client none $(server_name) 8007
	sleep 1 && ./target/kex_mceliece348864f_client none $(server_name) 8008
	sleep 1 && ./target/kex_mceliece460896f_client none $(server_name) 8009
	sleep 1 && ./target/kex_mceliece6688128f_client none $(server_name) 8010
	sleep 1 && ./target/kex_mceliece6960119f_client none $(server_name) 8011
	sleep 1 && ./target/kex_mceliece8192128f_client none $(server_name) 8012
	sleep 1 && ./target/kex_kyber512poly1305_client none $(server_name) 8013
	sleep 1 && ./target/kex_kyber768poly1305_client none $(server_name) 8014
	sleep 1 && ./target/kex_kyber1024poly1305_client none $(server_name) 8015
	sleep 1 && ./target/kex_mceliece348864poly1305_client none $(server_name) 8016
	sleep 1 && ./target/kex_mceliece460896poly1305_client none $(server_name) 8017
	sleep 1 && ./target/kex_mceliece6688128poly1305_client none $(server_name) 8018
	sleep 1 && ./target/kex_mceliece6960119poly1305_client none $(server_name) 8019
	sleep 1 && ./target/kex_mceliece8192128poly1305_client none $(server_name) 8020
	sleep 1 && ./target/kex_mceliece348864fpoly1305_client none $(server_name) 8021
	sleep 1 && ./target/kex_mceliece460896fpoly1305_client none $(server_name) 8022
	sleep 1 && ./target/kex_mceliece6688128fpoly1305_client none $(server_name) 8023
	sleep 1 && ./target/kex_mceliece6960119fpoly1305_client none $(server_name) 8024
	sleep 1 && ./target/kex_mceliece8192128fpoly1305_client none $(server_name) 8025
	sleep 1 && ./target/kex_kyber512gmac_client none $(server_name) 8026
	sleep 1 && ./target/kex_kyber768gmac_client none $(server_name) 8027
	sleep 1 && ./target/kex_kyber1024gmac_client none $(server_name) 8028
	sleep 1 && ./target/kex_mceliece348864gmac_client none $(server_name) 8029
	sleep 1 && ./target/kex_mceliece460896gmac_client none $(server_name) 8030
	sleep 1 && ./target/kex_mceliece6688128gmac_client none $(server_name) 8031
	sleep 1 && ./target/kex_mceliece6960119gmac_client none $(server_name) 8032
	sleep 1 && ./target/kex_mceliece8192128gmac_client none $(server_name) 8033
	sleep 1 && ./target/kex_mceliece348864fgmac_client none $(server_name) 8034
	sleep 1 && ./target/kex_mceliece460896fgmac_client none $(server_name) 8035
	sleep 1 && ./target/kex_mceliece6688128fgmac_client none $(server_name) 8036
	sleep 1 && ./target/kex_mceliece6960119fgmac_client none $(server_name) 8037
	sleep 1 && ./target/kex_mceliece8192128fgmac_client none $(server_name) 8038
	sleep 1 && ./target/kex_kyber512cmac_client none $(server_name) 8039
	sleep 1 && ./target/kex_kyber768cmac_client none $(server_name) 8040
	sleep 1 && ./target/kex_kyber1024cmac_client none $(server_name) 8041
	sleep 1 && ./target/kex_mceliece348864cmac_client none $(server_name) 8042
	sleep 1 && ./target/kex_mceliece460896cmac_client none $(server_name) 8043
	sleep 1 && ./target/kex_mceliece6688128cmac_client none $(server_name) 8044
	sleep 1 && ./target/kex_mceliece6960119cmac_client none $(server_name) 8045
	sleep 1 && ./target/kex_mceliece8192128cmac_client none $(server_name) 8046
	sleep 1 && ./target/kex_mceliece348864fcmac_client none $(server_name) 8047
	sleep 1 && ./target/kex_mceliece460896fcmac_client none $(server_name) 8048
	sleep 1 && ./target/kex_mceliece6688128fcmac_client none $(server_name) 8049
	sleep 1 && ./target/kex_mceliece6960119fcmac_client none $(server_name) 8050
	sleep 1 && ./target/kex_mceliece8192128fcmac_client none $(server_name) 8051
	sleep 1 && ./target/kex_kyber512kmac256_client none $(server_name) 8052
	sleep 1 && ./target/kex_kyber768kmac256_client none $(server_name) 8053
	sleep 1 && ./target/kex_kyber1024kmac256_client none $(server_name) 8054
	sleep 1 && ./target/kex_mceliece348864kmac256_client none $(server_name) 8055
	sleep 1 && ./target/kex_mceliece460896kmac256_client none $(server_name) 8056
	sleep 1 && ./target/kex_mceliece6688128kmac256_client none $(server_name) 8057
	sleep 1 && ./target/kex_mceliece6960119kmac256_client none $(server_name) 8058
	sleep 1 && ./target/kex_mceliece8192128kmac256_client none $(server_name) 8059
	sleep 1 && ./target/kex_mceliece348864fkmac256_client none $(server_name) 8060
	sleep 1 && ./target/kex_mceliece460896fkmac256_client none $(server_name) 8061
	sleep 1 && ./target/kex_mceliece6688128fkmac256_client none $(server_name) 8062
	sleep 1 && ./target/kex_mceliece6960119fkmac256_client none $(server_name) 8063
	sleep 1 && ./target/kex_mceliece8192128fkmac256_client none $(server_name) 8064

run_kex_clients_auth_server: kex
	sleep 1 && ./target/kex_kyber512_client server $(server_name) 8065
	sleep 1 && ./target/kex_kyber768_client server $(server_name) 8066
	sleep 1 && ./target/kex_kyber1024_client server $(server_name) 8067
	sleep 1 && ./target/kex_mceliece348864_client server $(server_name) 8068
	sleep 1 && ./target/kex_mceliece460896_client server $(server_name) 8069
	sleep 1 && ./target/kex_mceliece6688128_client server $(server_name) 8070
	sleep 1 && ./target/kex_mceliece6960119_client server $(server_name) 8071
	sleep 1 && ./target/kex_mceliece8192128_client server $(server_name) 8072
	sleep 1 && ./target/kex_mceliece348864f_client server $(server_name) 8073
	sleep 1 && ./target/kex_mceliece460896f_client server $(server_name) 8074
	sleep 1 && ./target/kex_mceliece6688128f_client server $(server_name) 8075
	sleep 1 && ./target/kex_mceliece6960119f_client server $(server_name) 8076
	sleep 1 && ./target/kex_mceliece8192128f_client server $(server_name) 8077
	sleep 1 && ./target/kex_kyber512poly1305_client server $(server_name) 8078
	sleep 1 && ./target/kex_kyber768poly1305_client server $(server_name) 8079
	sleep 1 && ./target/kex_kyber1024poly1305_client server $(server_name) 8080
	sleep 1 && ./target/kex_mceliece348864poly1305_client server $(server_name) 8081
	sleep 1 && ./target/kex_mceliece460896poly1305_client server $(server_name) 8082
	sleep 1 && ./target/kex_mceliece6688128poly1305_client server $(server_name) 8083
	sleep 1 && ./target/kex_mceliece6960119poly1305_client server $(server_name) 8084
	sleep 1 && ./target/kex_mceliece8192128poly1305_client server $(server_name) 8085
	sleep 1 && ./target/kex_mceliece348864fpoly1305_client server $(server_name) 8086
	sleep 1 && ./target/kex_mceliece460896fpoly1305_client server $(server_name) 8087
	sleep 1 && ./target/kex_mceliece6688128fpoly1305_client server $(server_name) 8088
	sleep 1 && ./target/kex_mceliece6960119fpoly1305_client server $(server_name) 8089
	sleep 1 && ./target/kex_mceliece8192128fpoly1305_client server $(server_name) 8090
	sleep 1 && ./target/kex_kyber512gmac_client server $(server_name) 8091
	sleep 1 && ./target/kex_kyber768gmac_client server $(server_name) 8092
	sleep 1 && ./target/kex_kyber1024gmac_client server $(server_name) 8093
	sleep 1 && ./target/kex_mceliece348864gmac_client server $(server_name) 8094
	sleep 1 && ./target/kex_mceliece460896gmac_client server $(server_name) 8095
	sleep 1 && ./target/kex_mceliece6688128gmac_client server $(server_name) 8096
	sleep 1 && ./target/kex_mceliece6960119gmac_client server $(server_name) 8097
	sleep 1 && ./target/kex_mceliece8192128gmac_client server $(server_name) 8098
	sleep 1 && ./target/kex_mceliece348864fgmac_client server $(server_name) 8099
	sleep 1 && ./target/kex_mceliece460896fgmac_client server $(server_name) 8100
	sleep 1 && ./target/kex_mceliece6688128fgmac_client server $(server_name) 8101
	sleep 1 && ./target/kex_mceliece6960119fgmac_client server $(server_name) 8102
	sleep 1 && ./target/kex_mceliece8192128fgmac_client server $(server_name) 8103
	sleep 1 && ./target/kex_kyber512cmac_client server $(server_name) 8104
	sleep 1 && ./target/kex_kyber768cmac_client server $(server_name) 8105
	sleep 1 && ./target/kex_kyber1024cmac_client server $(server_name) 8106
	sleep 1 && ./target/kex_mceliece348864cmac_client server $(server_name) 8107
	sleep 1 && ./target/kex_mceliece460896cmac_client server $(server_name) 8108
	sleep 1 && ./target/kex_mceliece6688128cmac_client server $(server_name) 8109
	sleep 1 && ./target/kex_mceliece6960119cmac_client server $(server_name) 8110
	sleep 1 && ./target/kex_mceliece8192128cmac_client server $(server_name) 8111
	sleep 1 && ./target/kex_mceliece348864fcmac_client server $(server_name) 8112
	sleep 1 && ./target/kex_mceliece460896fcmac_client server $(server_name) 8113
	sleep 1 && ./target/kex_mceliece6688128fcmac_client server $(server_name) 8114
	sleep 1 && ./target/kex_mceliece6960119fcmac_client server $(server_name) 8115
	sleep 1 && ./target/kex_mceliece8192128fcmac_client server $(server_name) 8116
	sleep 1 && ./target/kex_kyber512kmac256_client server $(server_name) 8117
	sleep 1 && ./target/kex_kyber768kmac256_client server $(server_name) 8118
	sleep 1 && ./target/kex_kyber1024kmac256_client server $(server_name) 8119
	sleep 1 && ./target/kex_mceliece348864kmac256_client server $(server_name) 8120
	sleep 1 && ./target/kex_mceliece460896kmac256_client server $(server_name) 8121
	sleep 1 && ./target/kex_mceliece6688128kmac256_client server $(server_name) 8122
	sleep 1 && ./target/kex_mceliece6960119kmac256_client server $(server_name) 8123
	sleep 1 && ./target/kex_mceliece8192128kmac256_client server $(server_name) 8124
	sleep 1 && ./target/kex_mceliece348864fkmac256_client server $(server_name) 8125
	sleep 1 && ./target/kex_mceliece460896fkmac256_client server $(server_name) 8126
	sleep 1 && ./target/kex_mceliece6688128fkmac256_client server $(server_name) 8127
	sleep 1 && ./target/kex_mceliece6960119fkmac256_client server $(server_name) 8128
	sleep 1 && ./target/kex_mceliece8192128fkmac256_client server $(server_name) 8129

run_kex_clients_auth_all: kex
	sleep 1 && ./target/kex_kyber512_client all $(server_name) 8130
	sleep 1 && ./target/kex_kyber768_client all $(server_name) 8131
	sleep 1 && ./target/kex_kyber1024_client all $(server_name) 8132
	sleep 1 && ./target/kex_mceliece348864_client all $(server_name) 8133
	sleep 1 && ./target/kex_mceliece460896_client all $(server_name) 8134
	sleep 1 && ./target/kex_mceliece6688128_client all $(server_name) 8135
	sleep 1 && ./target/kex_mceliece6960119_client all $(server_name) 8136
	sleep 1 && ./target/kex_mceliece8192128_client all $(server_name) 8137
	sleep 1 && ./target/kex_mceliece348864f_client all $(server_name) 8138
	sleep 1 && ./target/kex_mceliece460896f_client all $(server_name) 8139
	sleep 1 && ./target/kex_mceliece6688128f_client all $(server_name) 8140
	sleep 1 && ./target/kex_mceliece6960119f_client all $(server_name) 8141
	sleep 1 && ./target/kex_mceliece8192128f_client all $(server_name) 8142
	sleep 1 && ./target/kex_kyber512poly1305_client all $(server_name) 8143
	sleep 1 && ./target/kex_kyber768poly1305_client all $(server_name) 8144
	sleep 1 && ./target/kex_kyber1024poly1305_client all $(server_name) 8145
	sleep 1 && ./target/kex_mceliece348864poly1305_client all $(server_name) 8146
	sleep 1 && ./target/kex_mceliece460896poly1305_client all $(server_name) 8147
	sleep 1 && ./target/kex_mceliece6688128poly1305_client all $(server_name) 8148
	sleep 1 && ./target/kex_mceliece6960119poly1305_client all $(server_name) 8149
	sleep 1 && ./target/kex_mceliece8192128poly1305_client all $(server_name) 8150
	sleep 1 && ./target/kex_mceliece348864fpoly1305_client all $(server_name) 8151
	sleep 1 && ./target/kex_mceliece460896fpoly1305_client all $(server_name) 8152
	sleep 1 && ./target/kex_mceliece6688128fpoly1305_client all $(server_name) 8153
	sleep 1 && ./target/kex_mceliece6960119fpoly1305_client all $(server_name) 8154
	sleep 1 && ./target/kex_mceliece8192128fpoly1305_client all $(server_name) 8155
	sleep 1 && ./target/kex_kyber512gmac_client all $(server_name) 8156
	sleep 1 && ./target/kex_kyber768gmac_client all $(server_name) 8157
	sleep 1 && ./target/kex_kyber1024gmac_client all $(server_name) 8158
	sleep 1 && ./target/kex_mceliece348864gmac_client all $(server_name) 8159
	sleep 1 && ./target/kex_mceliece460896gmac_client all $(server_name) 8160
	sleep 1 && ./target/kex_mceliece6688128gmac_client all $(server_name) 8161
	sleep 1 && ./target/kex_mceliece6960119gmac_client all $(server_name) 8162
	sleep 1 && ./target/kex_mceliece8192128gmac_client all $(server_name) 8163
	sleep 1 && ./target/kex_mceliece348864fgmac_client all $(server_name) 8164
	sleep 1 && ./target/kex_mceliece460896fgmac_client all $(server_name) 8165
	sleep 1 && ./target/kex_mceliece6688128fgmac_client all $(server_name) 8166
	sleep 1 && ./target/kex_mceliece6960119fgmac_client all $(server_name) 8167
	sleep 1 && ./target/kex_mceliece8192128fgmac_client all $(server_name) 8168
	sleep 1 && ./target/kex_kyber512cmac_client all $(server_name) 8169
	sleep 1 && ./target/kex_kyber768cmac_client all $(server_name) 8170
	sleep 1 && ./target/kex_kyber1024cmac_client all $(server_name) 8171
	sleep 1 && ./target/kex_mceliece348864cmac_client all $(server_name) 8172
	sleep 1 && ./target/kex_mceliece460896cmac_client all $(server_name) 8173
	sleep 1 && ./target/kex_mceliece6688128cmac_client all $(server_name) 8174
	sleep 1 && ./target/kex_mceliece6960119cmac_client all $(server_name) 8175
	sleep 1 && ./target/kex_mceliece8192128cmac_client all $(server_name) 8176
	sleep 1 && ./target/kex_mceliece348864fcmac_client all $(server_name) 8177
	sleep 1 && ./target/kex_mceliece460896fcmac_client all $(server_name) 8178
	sleep 1 && ./target/kex_mceliece6688128fcmac_client all $(server_name) 8179
	sleep 1 && ./target/kex_mceliece6960119fcmac_client all $(server_name) 8180
	sleep 1 && ./target/kex_mceliece8192128fcmac_client all $(server_name) 8181
	sleep 1 && ./target/kex_kyber512kmac256_client all $(server_name) 8182
	sleep 1 && ./target/kex_kyber768kmac256_client all $(server_name) 8183
	sleep 1 && ./target/kex_kyber1024kmac256_client all $(server_name) 8184
	sleep 1 && ./target/kex_mceliece348864kmac256_client all $(server_name) 8185
	sleep 1 && ./target/kex_mceliece460896kmac256_client all $(server_name) 8186
	sleep 1 && ./target/kex_mceliece6688128kmac256_client all $(server_name) 8187
	sleep 1 && ./target/kex_mceliece6960119kmac256_client all $(server_name) 8188
	sleep 1 && ./target/kex_mceliece8192128kmac256_client all $(server_name) 8189
	sleep 1 && ./target/kex_mceliece348864fkmac256_client all $(server_name) 8190
	sleep 1 && ./target/kex_mceliece460896fkmac256_client all $(server_name) 8191
	sleep 1 && ./target/kex_mceliece6688128fkmac256_client all $(server_name) 8192
	sleep 1 && ./target/kex_mceliece6960119fkmac256_client all $(server_name) 8193
	sleep 1 && ./target/kex_mceliece8192128fkmac256_client all $(server_name) 8194

run_kex_servers_all: run_kex_servers_auth_none run_kex_servers_auth_server run_kex_servers_auth_all

run_kex_servers_auth_none: kex
	target/kex_kyber512_server none 127.0.0.1 8000
	target/kex_kyber768_server none 127.0.0.1 8001
	target/kex_kyber1024_server none 127.0.0.1 8002
	target/kex_mceliece348864_server none 127.0.0.1 8003
	target/kex_mceliece460896_server none 127.0.0.1 8004
	target/kex_mceliece6688128_server none 127.0.0.1 8005
	target/kex_mceliece6960119_server none 127.0.0.1 8006
	target/kex_mceliece8192128_server none 127.0.0.1 8007
	target/kex_mceliece348864f_server none 127.0.0.1 8008
	target/kex_mceliece460896f_server none 127.0.0.1 8009
	target/kex_mceliece6688128f_server none 127.0.0.1 8010
	target/kex_mceliece6960119f_server none 127.0.0.1 8011
	target/kex_mceliece8192128f_server none 127.0.0.1 8012
	target/kex_kyber512poly1305_server none 127.0.0.1 8013
	target/kex_kyber768poly1305_server none 127.0.0.1 8014
	target/kex_kyber1024poly1305_server none 127.0.0.1 8015
	target/kex_mceliece348864poly1305_server none 127.0.0.1 8016
	target/kex_mceliece460896poly1305_server none 127.0.0.1 8017
	target/kex_mceliece6688128poly1305_server none 127.0.0.1 8018
	target/kex_mceliece6960119poly1305_server none 127.0.0.1 8019
	target/kex_mceliece8192128poly1305_server none 127.0.0.1 8020
	target/kex_mceliece348864fpoly1305_server none 127.0.0.1 8021
	target/kex_mceliece460896fpoly1305_server none 127.0.0.1 8022
	target/kex_mceliece6688128fpoly1305_server none 127.0.0.1 8023
	target/kex_mceliece6960119fpoly1305_server none 127.0.0.1 8024
	target/kex_mceliece8192128fpoly1305_server none 127.0.0.1 8025
	target/kex_kyber512gmac_server none 127.0.0.1 8026
	target/kex_kyber768gmac_server none 127.0.0.1 8027
	target/kex_kyber1024gmac_server none 127.0.0.1 8028
	target/kex_mceliece348864gmac_server none 127.0.0.1 8029
	target/kex_mceliece460896gmac_server none 127.0.0.1 8030
	target/kex_mceliece6688128gmac_server none 127.0.0.1 8031
	target/kex_mceliece6960119gmac_server none 127.0.0.1 8032
	target/kex_mceliece8192128gmac_server none 127.0.0.1 8033
	target/kex_mceliece348864fgmac_server none 127.0.0.1 8034
	target/kex_mceliece460896fgmac_server none 127.0.0.1 8035
	target/kex_mceliece6688128fgmac_server none 127.0.0.1 8036
	target/kex_mceliece6960119fgmac_server none 127.0.0.1 8037
	target/kex_mceliece8192128fgmac_server none 127.0.0.1 8038
	target/kex_kyber512cmac_server none 127.0.0.1 8039
	target/kex_kyber768cmac_server none 127.0.0.1 8040
	target/kex_kyber1024cmac_server none 127.0.0.1 8041
	target/kex_mceliece348864cmac_server none 127.0.0.1 8042
	target/kex_mceliece460896cmac_server none 127.0.0.1 8043
	target/kex_mceliece6688128cmac_server none 127.0.0.1 8044
	target/kex_mceliece6960119cmac_server none 127.0.0.1 8045
	target/kex_mceliece8192128cmac_server none 127.0.0.1 8046
	target/kex_mceliece348864fcmac_server none 127.0.0.1 8047
	target/kex_mceliece460896fcmac_server none 127.0.0.1 8048
	target/kex_mceliece6688128fcmac_server none 127.0.0.1 8049
	target/kex_mceliece6960119fcmac_server none 127.0.0.1 8050
	target/kex_mceliece8192128fcmac_server none 127.0.0.1 8051
	target/kex_kyber512kmac256_server none 127.0.0.1 8052
	target/kex_kyber768kmac256_server none 127.0.0.1 8053
	target/kex_kyber1024kmac256_server none 127.0.0.1 8054
	target/kex_mceliece348864kmac256_server none 127.0.0.1 8055
	target/kex_mceliece460896kmac256_server none 127.0.0.1 8056
	target/kex_mceliece6688128kmac256_server none 127.0.0.1 8057
	target/kex_mceliece6960119kmac256_server none 127.0.0.1 8058
	target/kex_mceliece8192128kmac256_server none 127.0.0.1 8059
	target/kex_mceliece348864fkmac256_server none 127.0.0.1 8060
	target/kex_mceliece460896fkmac256_server none 127.0.0.1 8061
	target/kex_mceliece6688128fkmac256_server none 127.0.0.1 8062
	target/kex_mceliece6960119fkmac256_server none 127.0.0.1 8063
	target/kex_mceliece8192128fkmac256_server none 127.0.0.1 8064

run_kex_servers_auth_server: kex
	target/kex_kyber512_server server 127.0.0.1 8065
	target/kex_kyber768_server server 127.0.0.1 8066
	target/kex_kyber1024_server server 127.0.0.1 8067
	target/kex_mceliece348864_server server 127.0.0.1 8068
	target/kex_mceliece460896_server server 127.0.0.1 8069
	target/kex_mceliece6688128_server server 127.0.0.1 8070
	target/kex_mceliece6960119_server server 127.0.0.1 8071
	target/kex_mceliece8192128_server server 127.0.0.1 8072
	target/kex_mceliece348864f_server server 127.0.0.1 8073
	target/kex_mceliece460896f_server server 127.0.0.1 8074
	target/kex_mceliece6688128f_server server 127.0.0.1 8075
	target/kex_mceliece6960119f_server server 127.0.0.1 8076
	target/kex_mceliece8192128f_server server 127.0.0.1 8077
	target/kex_kyber512poly1305_server server 127.0.0.1 8078
	target/kex_kyber768poly1305_server server 127.0.0.1 8079
	target/kex_kyber1024poly1305_server server 127.0.0.1 8080
	target/kex_mceliece348864poly1305_server server 127.0.0.1 8081
	target/kex_mceliece460896poly1305_server server 127.0.0.1 8082
	target/kex_mceliece6688128poly1305_server server 127.0.0.1 8083
	target/kex_mceliece6960119poly1305_server server 127.0.0.1 8084
	target/kex_mceliece8192128poly1305_server server 127.0.0.1 8085
	target/kex_mceliece348864fpoly1305_server server 127.0.0.1 8086
	target/kex_mceliece460896fpoly1305_server server 127.0.0.1 8087
	target/kex_mceliece6688128fpoly1305_server server 127.0.0.1 8088
	target/kex_mceliece6960119fpoly1305_server server 127.0.0.1 8089
	target/kex_mceliece8192128fpoly1305_server server 127.0.0.1 8090
	target/kex_kyber512gmac_server server 127.0.0.1 8091
	target/kex_kyber768gmac_server server 127.0.0.1 8092
	target/kex_kyber1024gmac_server server 127.0.0.1 8093
	target/kex_mceliece348864gmac_server server 127.0.0.1 8094
	target/kex_mceliece460896gmac_server server 127.0.0.1 8095
	target/kex_mceliece6688128gmac_server server 127.0.0.1 8096
	target/kex_mceliece6960119gmac_server server 127.0.0.1 8097
	target/kex_mceliece8192128gmac_server server 127.0.0.1 8098
	target/kex_mceliece348864fgmac_server server 127.0.0.1 8099
	target/kex_mceliece460896fgmac_server server 127.0.0.1 8100
	target/kex_mceliece6688128fgmac_server server 127.0.0.1 8101
	target/kex_mceliece6960119fgmac_server server 127.0.0.1 8102
	target/kex_mceliece8192128fgmac_server server 127.0.0.1 8103
	target/kex_kyber512cmac_server server 127.0.0.1 8104
	target/kex_kyber768cmac_server server 127.0.0.1 8105
	target/kex_kyber1024cmac_server server 127.0.0.1 8106
	target/kex_mceliece348864cmac_server server 127.0.0.1 8107
	target/kex_mceliece460896cmac_server server 127.0.0.1 8108
	target/kex_mceliece6688128cmac_server server 127.0.0.1 8109
	target/kex_mceliece6960119cmac_server server 127.0.0.1 8110
	target/kex_mceliece8192128cmac_server server 127.0.0.1 8111
	target/kex_mceliece348864fcmac_server server 127.0.0.1 8112
	target/kex_mceliece460896fcmac_server server 127.0.0.1 8113
	target/kex_mceliece6688128fcmac_server server 127.0.0.1 8114
	target/kex_mceliece6960119fcmac_server server 127.0.0.1 8115
	target/kex_mceliece8192128fcmac_server server 127.0.0.1 8116
	target/kex_kyber512kmac256_server server 127.0.0.1 8117
	target/kex_kyber768kmac256_server server 127.0.0.1 8118
	target/kex_kyber1024kmac256_server server 127.0.0.1 8119
	target/kex_mceliece348864kmac256_server server 127.0.0.1 8120
	target/kex_mceliece460896kmac256_server server 127.0.0.1 8121
	target/kex_mceliece6688128kmac256_server server 127.0.0.1 8122
	target/kex_mceliece6960119kmac256_server server 127.0.0.1 8123
	target/kex_mceliece8192128kmac256_server server 127.0.0.1 8124
	target/kex_mceliece348864fkmac256_server server 127.0.0.1 8125
	target/kex_mceliece460896fkmac256_server server 127.0.0.1 8126
	target/kex_mceliece6688128fkmac256_server server 127.0.0.1 8127
	target/kex_mceliece6960119fkmac256_server server 127.0.0.1 8128
	target/kex_mceliece8192128fkmac256_server server 127.0.0.1 8129

run_kex_servers_auth_all: kex
	target/kex_kyber512_server all 127.0.0.1 8130
	target/kex_kyber768_server all 127.0.0.1 8131
	target/kex_kyber1024_server all 127.0.0.1 8132
	target/kex_mceliece348864_server all 127.0.0.1 8133
	target/kex_mceliece460896_server all 127.0.0.1 8134
	target/kex_mceliece6688128_server all 127.0.0.1 8135
	target/kex_mceliece6960119_server all 127.0.0.1 8136
	target/kex_mceliece8192128_server all 127.0.0.1 8137
	target/kex_mceliece348864f_server all 127.0.0.1 8138
	target/kex_mceliece460896f_server all 127.0.0.1 8139
	target/kex_mceliece6688128f_server all 127.0.0.1 8140
	target/kex_mceliece6960119f_server all 127.0.0.1 8141
	target/kex_mceliece8192128f_server all 127.0.0.1 8142
	target/kex_kyber512poly1305_server all 127.0.0.1 8143
	target/kex_kyber768poly1305_server all 127.0.0.1 8144
	target/kex_kyber1024poly1305_server all 127.0.0.1 8145
	target/kex_mceliece348864poly1305_server all 127.0.0.1 8146
	target/kex_mceliece460896poly1305_server all 127.0.0.1 8147
	target/kex_mceliece6688128poly1305_server all 127.0.0.1 8148
	target/kex_mceliece6960119poly1305_server all 127.0.0.1 8149
	target/kex_mceliece8192128poly1305_server all 127.0.0.1 8150
	target/kex_mceliece348864fpoly1305_server all 127.0.0.1 8151
	target/kex_mceliece460896fpoly1305_server all 127.0.0.1 8152
	target/kex_mceliece6688128fpoly1305_server all 127.0.0.1 8153
	target/kex_mceliece6960119fpoly1305_server all 127.0.0.1 8154
	target/kex_mceliece8192128fpoly1305_server all 127.0.0.1 8155
	target/kex_kyber512gmac_server all 127.0.0.1 8156
	target/kex_kyber768gmac_server all 127.0.0.1 8157
	target/kex_kyber1024gmac_server all 127.0.0.1 8158
	target/kex_mceliece348864gmac_server all 127.0.0.1 8159
	target/kex_mceliece460896gmac_server all 127.0.0.1 8160
	target/kex_mceliece6688128gmac_server all 127.0.0.1 8161
	target/kex_mceliece6960119gmac_server all 127.0.0.1 8162
	target/kex_mceliece8192128gmac_server all 127.0.0.1 8163
	target/kex_mceliece348864fgmac_server all 127.0.0.1 8164
	target/kex_mceliece460896fgmac_server all 127.0.0.1 8165
	target/kex_mceliece6688128fgmac_server all 127.0.0.1 8166
	target/kex_mceliece6960119fgmac_server all 127.0.0.1 8167
	target/kex_mceliece8192128fgmac_server all 127.0.0.1 8168
	target/kex_kyber512cmac_server all 127.0.0.1 8169
	target/kex_kyber768cmac_server all 127.0.0.1 8170
	target/kex_kyber1024cmac_server all 127.0.0.1 8171
	target/kex_mceliece348864cmac_server all 127.0.0.1 8172
	target/kex_mceliece460896cmac_server all 127.0.0.1 8173
	target/kex_mceliece6688128cmac_server all 127.0.0.1 8174
	target/kex_mceliece6960119cmac_server all 127.0.0.1 8175
	target/kex_mceliece8192128cmac_server all 127.0.0.1 8176
	target/kex_mceliece348864fcmac_server all 127.0.0.1 8177
	target/kex_mceliece460896fcmac_server all 127.0.0.1 8178
	target/kex_mceliece6688128fcmac_server all 127.0.0.1 8179
	target/kex_mceliece6960119fcmac_server all 127.0.0.1 8180
	target/kex_mceliece8192128fcmac_server all 127.0.0.1 8181
	target/kex_kyber512kmac256_server all 127.0.0.1 8182
	target/kex_kyber768kmac256_server all 127.0.0.1 8183
	target/kex_kyber1024kmac256_server all 127.0.0.1 8184
	target/kex_mceliece348864kmac256_server all 127.0.0.1 8185
	target/kex_mceliece460896kmac256_server all 127.0.0.1 8186
	target/kex_mceliece6688128kmac256_server all 127.0.0.1 8187
	target/kex_mceliece6960119kmac256_server all 127.0.0.1 8188
	target/kex_mceliece8192128kmac256_server all 127.0.0.1 8189
	target/kex_mceliece348864fkmac256_server all 127.0.0.1 8190
	target/kex_mceliece460896fkmac256_server all 127.0.0.1 8191
	target/kex_mceliece6688128fkmac256_server all 127.0.0.1 8192
	target/kex_mceliece6960119fkmac256_server all 127.0.0.1 8193
	target/kex_mceliece8192128fkmac256_server all 127.0.0.1 8194

kex: \
	target/kex_kyber512_client \
	target/kex_kyber768_client \
	target/kex_kyber1024_client \
	target/kex_mceliece348864_client \
	target/kex_mceliece460896_client \
	target/kex_mceliece6688128_client \
	target/kex_mceliece6960119_client \
	target/kex_mceliece8192128_client \
	target/kex_mceliece348864f_client \
	target/kex_mceliece460896f_client \
	target/kex_mceliece6688128f_client \
	target/kex_mceliece6960119f_client \
	target/kex_mceliece8192128f_client \
	target/kex_kyber512poly1305_client \
	target/kex_kyber768poly1305_client \
	target/kex_kyber1024poly1305_client \
	target/kex_mceliece348864poly1305_client \
	target/kex_mceliece460896poly1305_client \
	target/kex_mceliece6688128poly1305_client \
	target/kex_mceliece6960119poly1305_client \
	target/kex_mceliece8192128poly1305_client \
	target/kex_mceliece348864fpoly1305_client \
	target/kex_mceliece460896fpoly1305_client \
	target/kex_mceliece6688128fpoly1305_client \
	target/kex_mceliece6960119fpoly1305_client \
	target/kex_mceliece8192128fpoly1305_client \
	target/kex_kyber512gmac_client \
	target/kex_kyber768gmac_client \
	target/kex_kyber1024gmac_client \
	target/kex_mceliece348864gmac_client \
	target/kex_mceliece460896gmac_client \
	target/kex_mceliece6688128gmac_client \
	target/kex_mceliece6960119gmac_client \
	target/kex_mceliece8192128gmac_client \
	target/kex_mceliece348864fgmac_client \
	target/kex_mceliece460896fgmac_client \
	target/kex_mceliece6688128fgmac_client \
	target/kex_mceliece6960119fgmac_client \
	target/kex_mceliece8192128fgmac_client \
	target/kex_kyber512cmac_client \
	target/kex_kyber768cmac_client \
	target/kex_kyber1024cmac_client \
	target/kex_mceliece348864cmac_client \
	target/kex_mceliece460896cmac_client \
	target/kex_mceliece6688128cmac_client \
	target/kex_mceliece6960119cmac_client \
	target/kex_mceliece8192128cmac_client \
	target/kex_mceliece348864fcmac_client \
	target/kex_mceliece460896fcmac_client \
	target/kex_mceliece6688128fcmac_client \
	target/kex_mceliece6960119fcmac_client \
	target/kex_mceliece8192128fcmac_client \
	target/kex_kyber512kmac256_client \
	target/kex_kyber768kmac256_client \
	target/kex_kyber1024kmac256_client \
	target/kex_mceliece348864kmac256_client \
	target/kex_mceliece460896kmac256_client \
	target/kex_mceliece6688128kmac256_client \
	target/kex_mceliece6960119kmac256_client \
	target/kex_mceliece8192128kmac256_client \
	target/kex_mceliece348864fkmac256_client \
	target/kex_mceliece460896fkmac256_client \
	target/kex_mceliece6688128fkmac256_client \
	target/kex_mceliece6960119fkmac256_client \
	target/kex_mceliece8192128fkmac256_client \
	target/kex_kyber512_server \
	target/kex_kyber768_server \
	target/kex_kyber1024_server \
	target/kex_mceliece348864_server \
	target/kex_mceliece460896_server \
	target/kex_mceliece6688128_server \
	target/kex_mceliece6960119_server \
	target/kex_mceliece8192128_server \
	target/kex_mceliece348864f_server \
	target/kex_mceliece460896f_server \
	target/kex_mceliece6688128f_server \
	target/kex_mceliece6960119f_server \
	target/kex_mceliece8192128f_server \
	target/kex_kyber512poly1305_server \
	target/kex_kyber768poly1305_server \
	target/kex_kyber1024poly1305_server \
	target/kex_mceliece348864poly1305_server \
	target/kex_mceliece460896poly1305_server \
	target/kex_mceliece6688128poly1305_server \
	target/kex_mceliece6960119poly1305_server \
	target/kex_mceliece8192128poly1305_server \
	target/kex_mceliece348864fpoly1305_server \
	target/kex_mceliece460896fpoly1305_server \
	target/kex_mceliece6688128fpoly1305_server \
	target/kex_mceliece6960119fpoly1305_server \
	target/kex_mceliece8192128fpoly1305_server \
	target/kex_kyber512gmac_server \
	target/kex_kyber768gmac_server \
	target/kex_kyber1024gmac_server \
	target/kex_mceliece348864gmac_server \
	target/kex_mceliece460896gmac_server \
	target/kex_mceliece6688128gmac_server \
	target/kex_mceliece6960119gmac_server \
	target/kex_mceliece8192128gmac_server \
	target/kex_mceliece348864fgmac_server \
	target/kex_mceliece460896fgmac_server \
	target/kex_mceliece6688128fgmac_server \
	target/kex_mceliece6960119fgmac_server \
	target/kex_mceliece8192128fgmac_server \
	target/kex_kyber512cmac_server \
	target/kex_kyber768cmac_server \
	target/kex_kyber1024cmac_server \
	target/kex_mceliece348864cmac_server \
	target/kex_mceliece460896cmac_server \
	target/kex_mceliece6688128cmac_server \
	target/kex_mceliece6960119cmac_server \
	target/kex_mceliece8192128cmac_server \
	target/kex_mceliece348864fcmac_server \
	target/kex_mceliece460896fcmac_server \
	target/kex_mceliece6688128fcmac_server \
	target/kex_mceliece6960119fcmac_server \
	target/kex_mceliece8192128fcmac_server \
	target/kex_kyber512kmac256_server \
	target/kex_kyber768kmac256_server \
	target/kex_kyber1024kmac256_server \
	target/kex_mceliece348864kmac256_server \
	target/kex_mceliece460896kmac256_server \
	target/kex_mceliece6688128kmac256_server \
	target/kex_mceliece6960119kmac256_server \
	target/kex_mceliece8192128kmac256_server \
	target/kex_mceliece348864fkmac256_server \
	target/kex_mceliece460896fkmac256_server \
	target/kex_mceliece6688128fkmac256_server \
	target/kex_mceliece6960119fkmac256_server \
	target/kex_mceliece8192128fkmac256_server

target/kex_kyber512_client: $(KYBERSOURCES) $(KYBERHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=2 $(KYBERSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_kyber768_client: $(KYBERSOURCES) $(KYBERHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=3 $(KYBERSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_kyber1024_client: $(KYBERSOURCES) $(KYBERHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=4 $(KYBERSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece348864_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=3488 $(MCELIECESOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece460896_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=4608 $(MCELIECESOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece6688128_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6688 $(MCELIECESOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece6960119_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6960 $(MCELIECESOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece8192128_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=8192 $(MCELIECESOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece348864f_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=3488 -DFASTKEYGEN $(MCELIECESOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece460896f_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=4608 -DFASTKEYGEN $(MCELIECESOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece6688128f_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6688 -DFASTKEYGEN $(MCELIECESOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece6960119f_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6960 -DFASTKEYGEN $(MCELIECESOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece8192128f_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=8192 -DFASTKEYGEN $(MCELIECESOURCES) speed.c kex.c kex_client.c -o $@

target/kex_kyber512poly1305_client: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_KYBER -DKYBER_K=2 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_kyber768poly1305_client: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_KYBER -DKYBER_K=3 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_kyber1024poly1305_client: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_KYBER -DKYBER_K=4 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece348864poly1305_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=3488 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece460896poly1305_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=4608 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece6688128poly1305_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=6688 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece6960119poly1305_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=6960 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece8192128poly1305_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=8192 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece348864fpoly1305_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=3488 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece460896fpoly1305_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=4608 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece6688128fpoly1305_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=6688 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece6960119fpoly1305_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=6960 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece8192128fpoly1305_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=8192 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_kyber512gmac_client: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_KYBER -DKYBER_K=2 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_kyber768gmac_client: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_KYBER -DKYBER_K=3 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_kyber1024gmac_client: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_KYBER -DKYBER_K=4 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece348864gmac_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=3488 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece460896gmac_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=4608 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece6688128gmac_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=6688 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece6960119gmac_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=6960 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece8192128gmac_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=8192 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece348864fgmac_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=3488 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece460896fgmac_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=4608 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece6688128fgmac_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=6688 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece6960119fgmac_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=6960 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece8192128fgmac_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=8192 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_kyber512cmac_client: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_KYBER -DKYBER_K=2 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_kyber768cmac_client: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_KYBER -DKYBER_K=3 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_kyber1024cmac_client: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_KYBER -DKYBER_K=4 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece348864cmac_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=3488 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece460896cmac_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=4608 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece6688128cmac_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=6688 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece6960119cmac_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=6960 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece8192128cmac_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=8192 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece348864fcmac_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=3488 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece460896fcmac_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=4608 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece6688128fcmac_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=6688 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece6960119fcmac_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=6960 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece8192128fcmac_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=8192 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_kyber512kmac256_client: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_KYBER -DKYBER_K=2 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_kyber768kmac256_client: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_KYBER -DKYBER_K=3 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_kyber1024kmac256_client: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_KYBER -DKYBER_K=4 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece348864kmac256_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=3488 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece460896kmac256_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=4608 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece6688128kmac256_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=6688 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece6960119kmac256_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=6960 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece8192128kmac256_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=8192 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece348864fkmac256_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=3488 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece460896fkmac256_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=4608 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece6688128fkmac256_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=6688 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece6960119fkmac256_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=6960 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_mceliece8192128fkmac256_client: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_client.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=8192 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_client.c -o $@

target/kex_kyber512_server: $(KYBERSOURCES) $(KYBERHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=2 $(KYBERSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_kyber768_server: $(KYBERSOURCES) $(KYBERHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=3 $(KYBERSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_kyber1024_server: $(KYBERSOURCES) $(KYBERHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_KYBER -DKYBER_K=4 $(KYBERSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece348864_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=3488 $(MCELIECESOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece460896_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=4608 $(MCELIECESOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece6688128_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6688 $(MCELIECESOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece6960119_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6960 $(MCELIECESOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece8192128_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=8192 $(MCELIECESOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece348864f_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=3488 -DFASTKEYGEN $(MCELIECESOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece460896f_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=4608 -DFASTKEYGEN $(MCELIECESOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece6688128f_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6688 -DFASTKEYGEN $(MCELIECESOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece6960119f_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=6960 -DFASTKEYGEN $(MCELIECESOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece8192128f_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DPKE_MCELIECE -DMCELIECE_N=8192 -DFASTKEYGEN $(MCELIECESOURCES) speed.c kex.c kex_server.c -o $@

target/kex_kyber512poly1305_server: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_KYBER -DKYBER_K=2 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_kyber768poly1305_server: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_KYBER -DKYBER_K=3 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_kyber1024poly1305_server: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_KYBER -DKYBER_K=4 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece348864poly1305_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=3488 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece460896poly1305_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=4608 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece6688128poly1305_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=6688 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece6960119poly1305_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=6960 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece8192128poly1305_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=8192 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece348864fpoly1305_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=3488 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece460896fpoly1305_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=4608 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece6688128fpoly1305_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=6688 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece6960119fpoly1305_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=6960 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece8192128fpoly1305_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DPKE_MCELIECE -DMCELIECE_N=8192 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_kyber512gmac_server: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_KYBER -DKYBER_K=2 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_kyber768gmac_server: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_KYBER -DKYBER_K=3 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_kyber1024gmac_server: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_KYBER -DKYBER_K=4 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece348864gmac_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=3488 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece460896gmac_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=4608 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece6688128gmac_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=6688 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece6960119gmac_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=6960 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece8192128gmac_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=8192 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece348864fgmac_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=3488 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece460896fgmac_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=4608 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece6688128fgmac_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=6688 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece6960119fgmac_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=6960 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece8192128fgmac_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DPKE_MCELIECE -DMCELIECE_N=8192 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_kyber512cmac_server: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_KYBER -DKYBER_K=2 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_kyber768cmac_server: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_KYBER -DKYBER_K=3 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_kyber1024cmac_server: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_KYBER -DKYBER_K=4 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece348864cmac_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=3488 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece460896cmac_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=4608 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece6688128cmac_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=6688 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece6960119cmac_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=6960 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece8192128cmac_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=8192 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece348864fcmac_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=3488 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece460896fcmac_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=4608 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece6688128fcmac_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=6688 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece6960119fcmac_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=6960 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece8192128fcmac_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DPKE_MCELIECE -DMCELIECE_N=8192 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_kyber512kmac256_server: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_KYBER -DKYBER_K=2 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_kyber768kmac256_server: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_KYBER -DKYBER_K=3 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_kyber1024kmac256_server: $(KYBERSOURCES) $(KYBERHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_KYBER -DKYBER_K=4 $(KYBERSOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece348864kmac256_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=3488 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece460896kmac256_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=4608 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece6688128kmac256_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=6688 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece6960119kmac256_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=6960 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece8192128kmac256_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=8192 $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece348864fkmac256_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=3488 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece460896fkmac256_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=4608 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece6688128fkmac256_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=6688 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece6960119fkmac256_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=6960 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

target/kex_mceliece8192128fkmac256_server: $(MCELIECESOURCES) $(MCELIECEHEADERS) $(ETMKEMSOURCES) $(ETMKEMHEADERS) speed.c speed.h kex.c kex.h kex_server.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DPKE_MCELIECE -DMCELIECE_N=8192 -DFASTKEYGEN $(MCELIECESOURCES) $(ETMKEMSOURCES) speed.c kex.c kex_server.c -o $@

clean:
	$(RM) target/*
