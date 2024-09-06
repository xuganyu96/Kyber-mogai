#include "stdint.h"
#include "../kyber/ref/params.h"
#include "../kyber/ref/test/cpucycles.h"
#include "../kyber/ref/kem.h"
#include "../kyber/ref/randombytes.h"
#include "../kyber/ref/test/speed_print.h"
#include "../authenticators.h"
#include "../etm.h"

#define NTESTS 10000
#if (KYBER_K == 2)
    #define PRINT_ALGNAME "Mogai512"
#elif (KYBER_K == 3)
    #define PRINT_ALGNAME "Mogai768"
#elif (KYBER_K == 4)
    #define PRINT_ALGNAME "Mogai1024"
#else
    #error "Unsupported security level"
#endif

uint64_t t[NTESTS];

int main(void) {
    uint8_t pk[ETM_PUBLICKEYBYTES];
    uint8_t sk[ETM_SECRETKEYBYTES];
    uint8_t ct[ETM_CIPHERTEXTBYTES];
    uint8_t ss[ETM_SESSIONKEYBYTES];
    uint8_t decapsulation[ETM_SESSIONKEYBYTES];
    uint8_t indcpa_pt[KYBER_INDCPA_MSGBYTES];
    uint8_t coins32[KYBER_SYMBYTES];
    uint8_t coins64[2*KYBER_SYMBYTES];
    int i;

    randombytes(indcpa_pt, KYBER_INDCPA_MSGBYTES);
    randombytes(coins32, KYBER_SYMBYTES);
    randombytes(coins64, 2*KYBER_SYMBYTES);

    for(i=0;i<NTESTS;i++) {
        t[i] = cpucycles();
        crypto_kem_keypair_derand(pk, sk, coins64);
    }

    print_results("kyber_keypair_derand: ", t, NTESTS);

    for(i=0;i<NTESTS;i++) {
        t[i] = cpucycles();
        crypto_kem_keypair(pk, sk);
    }
    print_results("kyber_keypair: ", t, NTESTS);

    for(i=0;i<NTESTS;i++) {
        t[i] = cpucycles();
        etm_encap_derand(ct, ss, pk, indcpa_pt, coins32);
    }
    print_results("kyber_encaps_derand: ", t, NTESTS);

    for(i=0;i<NTESTS;i++) {
        t[i] = cpucycles();
        etm_encap(ct, ss, pk);
    }
    print_results("kyber_encaps: ", t, NTESTS);

    for(i=0;i<NTESTS;i++) {
        t[i] = cpucycles();
        etm_decap(decapsulation, ct, sk);
    }
    print_results("kyber_decaps: ", t, NTESTS);
}
