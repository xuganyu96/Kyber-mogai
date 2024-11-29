# Faster generic IND-CCA secure KEM using encrypt-then-MAC
This is the accompanying source code for the paper titled _Faster generic IND-CCA secure KEM using encrypt-then-MC_.

# development notes
To access the underlying IND-CPA subroutines of ML-KEM I chose to use the [reference implementation](https://github.com/pq-crystals/kyber). First clone the repository as a git submodule:

```bash
# this will make a "kyber" directory and clone the repository into it
git submodule add https://github.com/pq-crystals/kyber
```

The reference implementation is scattered across various .c and .h files, which need to be added to the Makefile the compiler can find them.

```Makefile
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
SOURCES = $(KYBERSOURCES)
HEAERS = $(KYBERHEAERS)
```

To quickly confirm that this setup works, I wrote a `main.c` that called the IND-CPA subroutines:

```c
#include "kyber/ref/indcpa.h"
#include "kyber/ref/params.h"
#include "kyber/ref/randombytes.h"
#include <stdio.h>

int main(void) {
  uint8_t indcpa_pk[KYBER_INDCPA_PUBLICKEYBYTES];
  uint8_t indcpa_sk[KYBER_INDCPA_SECRETKEYBYTES];
  uint8_t indcpa_pt[KYBER_INDCPA_MSGBYTES];
  uint8_t decryption[KYBER_INDCPA_MSGBYTES];
  uint8_t indcpa_ct[KYBER_INDCPA_BYTES];
  uint8_t coins[KYBER_SYMBYTES];
  randombytes(coins, sizeof(coins));
  randombytes(indcpa_pt, sizeof(indcpa_pt));

  indcpa_keypair_derand(indcpa_pk, indcpa_sk, coins);
  indcpa_enc(indcpa_ct, indcpa_pt, indcpa_pk, coins);
  indcpa_dec(decryption, indcpa_ct, indcpa_sk);

  int diff = 0;
  for (int i = 0; i < sizeof(decryption); i++) {
    diff |= indcpa_pt[i] ^ decryption[i];
  }
  if (diff == 0) {
    printf("decryption successful\n");
  } else {
    printf("decryption failed\n");
  }

  return 0;
}
```

Create a new target in Makefile. All binaries will be placed in a `target` directory so it's easy to ignore them in git and to delete them all at once. Since we want to run the main binary everytime we call `make main`, it is added as a phony target.

```Makefile
# phony targets will be rerun everytime even if the input files did not change
.PHONY = main

main: $(SOURCES) $(HEADERS) main.c
	$(CC) $(SOURCES) main.c -o target/$@
	./target/$@
```
