CFLAGS += -O3
LDFLAGS += -lcrypto

target/main: main.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $<
