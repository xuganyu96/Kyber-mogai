#include "stdio.h"
#include "../etm.h"
#include "../authenticators.h"
#include "../kyber/ref/params.h"
#include "../kyber/ref/kem.h"

#define ROUNDS 10000

static int randomized_encap_then_decap() {
    uint8_t pk[KYBER_PUBLICKEYBYTES];
    uint8_t sk[KYBER_SECRETKEYBYTES];
    uint8_t ct[KYBER_CIPHERTEXTBYTES + MAC_TAG_BYTES];
    uint8_t ss[KYBER_SYMBYTES];
    uint8_t decapsulation[KYBER_SYMBYTES];
    crypto_kem_keypair(pk, sk);
    for(int round = 0; round < ROUNDS; round++) {
        etm_encap(ct, ss, pk);
        etm_decap(ct, decapsulation, sk);
        for(size_t i = 0; i < KYBER_SYMBYTES; i++) {
            if(ss[i] != decapsulation[i]) {
                fprintf(stderr, "Decapsulation failed\n");
                return 1;
            }
        }
    }

    return 0;
}

int main(void) {
    int fail = 0;

    fail |= randomized_encap_then_decap();
    
    if (fail) {
        return 1;
    }
    return 0;
}
