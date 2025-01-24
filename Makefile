CFLAGS += -O3
LDFLAGS += -lcrypto

target/main: main.c static-mceliece/libmceliece348864favx.a
	$(CC) $(CFLAGS) $(LDFLAGS) -DMCELIECE_N=3488 -o $@ $^
