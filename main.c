#include "kyber/ref/kem.h"
#include "kyber/ref/params.h"
#include "kyber/ref/randombytes.h"
#include "stdio.h"
#include "stdint.h"
#include "authenticators.h"
#include "etm.h"

int main(int argc, char *argv[]) {
    uint8_t pk[KYBER_PUBLICKEYBYTES];
    uint8_t sk[KYBER_SECRETKEYBYTES];
    uint8_t ct[KYBER_CIPHERTEXTBYTES + MAC_TAG_BYTES];
    uint8_t ss[KYBER_SYMBYTES];
    uint8_t pt[KYBER_INDCPA_MSGBYTES];
    uint8_t coin[KYBER_SYMBYTES];

    // keygen
    uint8_t keygencoins[2 * KYBER_SYMBYTES];
    randombytes(keygencoins, sizeof(keygencoins));
    crypto_kem_keypair_derand(pk, sk, keygencoins);

    // encap_derand
    randombytes(coin, sizeof(coin));
    randombytes(pt, sizeof(pt));
    etm_encap_derand(ct, ss, pk, pt, coin);

    // encap
    etm_encap(ct, ss, pk);

    // decap
    uint8_t decapsulation[KYBER_SYMBYTES];
    etm_decap(ct, decapsulation, sk);

    // check correctness
    int fail = 0;
    for(size_t i = 0; i < KYBER_SYMBYTES; i++) {
        if(ss[i] != decapsulation[i]) {
            fail = 1;
        }
    }
    if(fail) {
        fprintf(stderr, "Decapsulation failed");
        return 1;
    }
    printf("Decapsulation succeeded");
    return 0;
}
