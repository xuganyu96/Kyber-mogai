OPENSSLDIR = /opt/homebrew/Cellar/openssl@3/3.3.1
CC = /usr/bin/cc
CFLAGS += -I$(OPENSSLDIR)/include
SOURCE = authenticators.c $(OPENSSLDIR)/lib/libcrypto.a
HEADERS = authenticators.h

main:
	$(CC) $(SOURCE) $(CFLAGS) main.c -o $@
	./main

test:
	$(CC) $(SOURCE) $(CFLAGS) tests/test_authenticators.c -o tests/test_authenticators
	./tests/test_authenticators

clean:
	rm main
