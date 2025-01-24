CFLAGS += -O3 -z noexecstack
LDFLAGS += -lcrypto

.PHONY: all clean

all: \
	target/mceliece348864_poly1305 \
	target/mceliece348864f_poly1305 \
	target/mceliece460896_poly1305 \
	target/mceliece460896f_poly1305 \
	target/mceliece6688128_poly1305 \
	target/mceliece6688128f_poly1305 \
	target/mceliece6960119_poly1305 \
	target/mceliece6960119f_poly1305 \
	target/mceliece8192128_poly1305 \
	target/mceliece8192128f_poly1305 \
	target/mceliece348864_gmac \
	target/mceliece348864f_gmac \
	target/mceliece460896_gmac \
	target/mceliece460896f_gmac \
	target/mceliece6688128_gmac \
	target/mceliece6688128f_gmac \
	target/mceliece6960119_gmac \
	target/mceliece6960119f_gmac \
	target/mceliece8192128_gmac \
	target/mceliece8192128f_gmac \
	target/mceliece348864_cmac \
	target/mceliece348864f_cmac \
	target/mceliece460896_cmac \
	target/mceliece460896f_cmac \
	target/mceliece6688128_cmac \
	target/mceliece6688128f_cmac \
	target/mceliece6960119_cmac \
	target/mceliece6960119f_cmac \
	target/mceliece8192128_cmac \
	target/mceliece8192128f_cmac \
	target/mceliece348864_kmac256 \
	target/mceliece348864f_kmac256 \
	target/mceliece460896_kmac256 \
	target/mceliece460896f_kmac256 \
	target/mceliece6688128_kmac256 \
	target/mceliece6688128f_kmac256 \
	target/mceliece6960119_kmac256 \
	target/mceliece6960119f_kmac256 \
	target/mceliece8192128_kmac256 \
	target/mceliece8192128f_kmac256

target/mceliece348864_poly1305: etmkem.c easy-mceliece/target/libmceliece348864avx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DMCELIECE_N=3488 -o $@ $^

target/mceliece348864f_poly1305: etmkem.c easy-mceliece/target/libmceliece348864favx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DMCELIECE_N=3488 -DFASTKEYGEN -o $@ $^

target/mceliece460896_poly1305: etmkem.c easy-mceliece/target/libmceliece460896avx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DMCELIECE_N=4608 -o $@ $^

target/mceliece460896f_poly1305: etmkem.c easy-mceliece/target/libmceliece460896favx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DMCELIECE_N=4608 -DFASTKEYGEN -o $@ $^

target/mceliece6688128_poly1305: etmkem.c easy-mceliece/target/libmceliece6688128avx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DMCELIECE_N=6688 -o $@ $^

target/mceliece6688128f_poly1305: etmkem.c easy-mceliece/target/libmceliece6688128favx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DMCELIECE_N=6688 -DFASTKEYGEN -o $@ $^

target/mceliece6960119_poly1305: etmkem.c easy-mceliece/target/libmceliece6960119avx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DMCELIECE_N=6960 -o $@ $^

target/mceliece6960119f_poly1305: etmkem.c easy-mceliece/target/libmceliece6960119favx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DMCELIECE_N=6960 -DFASTKEYGEN -o $@ $^

target/mceliece8192128_poly1305: etmkem.c easy-mceliece/target/libmceliece8192128avx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DMCELIECE_N=8192 -o $@ $^

target/mceliece8192128f_poly1305: etmkem.c easy-mceliece/target/libmceliece8192128favx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_POLY1305 -DMCELIECE_N=8192 -DFASTKEYGEN -o $@ $^

target/mceliece348864_gmac: etmkem.c easy-mceliece/target/libmceliece348864avx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DMCELIECE_N=3488 -o $@ $^

target/mceliece348864f_gmac: etmkem.c easy-mceliece/target/libmceliece348864favx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DMCELIECE_N=3488 -DFASTKEYGEN -o $@ $^

target/mceliece460896_gmac: etmkem.c easy-mceliece/target/libmceliece460896avx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DMCELIECE_N=4608 -o $@ $^

target/mceliece460896f_gmac: etmkem.c easy-mceliece/target/libmceliece460896favx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DMCELIECE_N=4608 -DFASTKEYGEN -o $@ $^

target/mceliece6688128_gmac: etmkem.c easy-mceliece/target/libmceliece6688128avx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DMCELIECE_N=6688 -o $@ $^

target/mceliece6688128f_gmac: etmkem.c easy-mceliece/target/libmceliece6688128favx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DMCELIECE_N=6688 -DFASTKEYGEN -o $@ $^

target/mceliece6960119_gmac: etmkem.c easy-mceliece/target/libmceliece6960119avx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DMCELIECE_N=6960 -o $@ $^

target/mceliece6960119f_gmac: etmkem.c easy-mceliece/target/libmceliece6960119favx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DMCELIECE_N=6960 -DFASTKEYGEN -o $@ $^

target/mceliece8192128_gmac: etmkem.c easy-mceliece/target/libmceliece8192128avx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DMCELIECE_N=8192 -o $@ $^

target/mceliece8192128f_gmac: etmkem.c easy-mceliece/target/libmceliece8192128favx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_GMAC -DMCELIECE_N=8192 -DFASTKEYGEN -o $@ $^

target/mceliece348864_cmac: etmkem.c easy-mceliece/target/libmceliece348864avx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DMCELIECE_N=3488 -o $@ $^

target/mceliece348864f_cmac: etmkem.c easy-mceliece/target/libmceliece348864favx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DMCELIECE_N=3488 -DFASTKEYGEN -o $@ $^

target/mceliece460896_cmac: etmkem.c easy-mceliece/target/libmceliece460896avx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DMCELIECE_N=4608 -o $@ $^

target/mceliece460896f_cmac: etmkem.c easy-mceliece/target/libmceliece460896favx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DMCELIECE_N=4608 -DFASTKEYGEN -o $@ $^

target/mceliece6688128_cmac: etmkem.c easy-mceliece/target/libmceliece6688128avx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DMCELIECE_N=6688 -o $@ $^

target/mceliece6688128f_cmac: etmkem.c easy-mceliece/target/libmceliece6688128favx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DMCELIECE_N=6688 -DFASTKEYGEN -o $@ $^

target/mceliece6960119_cmac: etmkem.c easy-mceliece/target/libmceliece6960119avx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DMCELIECE_N=6960 -o $@ $^

target/mceliece6960119f_cmac: etmkem.c easy-mceliece/target/libmceliece6960119favx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DMCELIECE_N=6960 -DFASTKEYGEN -o $@ $^

target/mceliece8192128_cmac: etmkem.c easy-mceliece/target/libmceliece8192128avx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DMCELIECE_N=8192 -o $@ $^

target/mceliece8192128f_cmac: etmkem.c easy-mceliece/target/libmceliece8192128favx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_CMAC -DMCELIECE_N=8192 -DFASTKEYGEN -o $@ $^

target/mceliece348864_kmac256: etmkem.c easy-mceliece/target/libmceliece348864avx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DMCELIECE_N=3488 -o $@ $^

target/mceliece348864f_kmac256: etmkem.c easy-mceliece/target/libmceliece348864favx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DMCELIECE_N=3488 -DFASTKEYGEN -o $@ $^

target/mceliece460896_kmac256: etmkem.c easy-mceliece/target/libmceliece460896avx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DMCELIECE_N=4608 -o $@ $^

target/mceliece460896f_kmac256: etmkem.c easy-mceliece/target/libmceliece460896favx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DMCELIECE_N=4608 -DFASTKEYGEN -o $@ $^

target/mceliece6688128_kmac256: etmkem.c easy-mceliece/target/libmceliece6688128avx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DMCELIECE_N=6688 -o $@ $^

target/mceliece6688128f_kmac256: etmkem.c easy-mceliece/target/libmceliece6688128favx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DMCELIECE_N=6688 -DFASTKEYGEN -o $@ $^

target/mceliece6960119_kmac256: etmkem.c easy-mceliece/target/libmceliece6960119avx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DMCELIECE_N=6960 -o $@ $^

target/mceliece6960119f_kmac256: etmkem.c easy-mceliece/target/libmceliece6960119favx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DMCELIECE_N=6960 -DFASTKEYGEN -o $@ $^

target/mceliece8192128_kmac256: etmkem.c easy-mceliece/target/libmceliece8192128avx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DMCELIECE_N=8192 -o $@ $^

target/mceliece8192128f_kmac256: etmkem.c easy-mceliece/target/libmceliece8192128favx.a authenticators.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DMAC_KMAC256 -DMCELIECE_N=8192 -DFASTKEYGEN -o $@ $^

clean:
	$(RM) target/*
