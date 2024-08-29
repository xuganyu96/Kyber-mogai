#include "../authenticators.h"
#include "../kyber/ref/params.h"
#include "../kyber/ref/test/cpucycles.h"
#include "../kyber/ref/test/speed_print.h"
#include <stdint.h>

#define TESTMSG "Hello, world!"
#define NTESTS 1000
uint64_t t[NTESTS];

static int test_poly1305_wrapper(void) {
    uint8_t key[POLY1305_KEY_BYTES];
    uint8_t digest[POLY1305_TAG_BYTES];
    unsigned char msg[KYBER_CIPHERTEXTBYTES];
    int fail = 0;

    for(int i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        fail |= mac_poly1305(key, msg, sizeof(msg), digest);
    }
    // printf("Poly1305, len(msg) = %d bytes", KYBER_CIPHERTEXTBYTES);
    // print_results("\t", t, NTESTS);

    return fail;
}

static int test_gmac(void) {
    uint8_t key[GMAC_KEY_BYTES];
    unsigned char msg[KYBER_CIPHERTEXTBYTES];
    uint8_t digest[GMAC_TAG_BYTES];
    int fail = 0;
    
    for(int i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        fail |= mac_gmac(key, msg, sizeof(msg), digest);
    }
    // printf("AES-256-GCM, len(msg) = %d bytes", KYBER_CIPHERTEXTBYTES);
    // print_results("\t", t, NTESTS);

    return fail;
}

static int test_cmac(void) {
    uint8_t key[CMAC_KEY_BYTES];
    unsigned char msg[KYBER_CIPHERTEXTBYTES];
    uint8_t digest[CMAC_TAG_BYTES];
    int fail = 0;
    
    for(int i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        fail |= mac_cmac(key, msg, sizeof(msg), digest);
    }
    // printf("AES-256-CBC, len(msg) = %d bytes", KYBER_CIPHERTEXTBYTES);
    // print_results("\t", t, NTESTS);

    return fail;
}

static int test_kmac(void) {
    uint8_t key[KMAC_KEY_BYTES];
    unsigned char msg[KYBER_CIPHERTEXTBYTES];
    uint8_t digest[KMAC_TAG_BYTES];
    int fail = 0;
    
    for(int i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        fail |= mac_kmac(key, msg, sizeof(msg), digest);
    }
    // printf("KMAC-256, len(msg) = %d bytes", KYBER_CIPHERTEXTBYTES);
    // print_results("\t", t, NTESTS);

    return fail;
}

int main(void) {
    int fail = 0;

    fail |= test_poly1305_wrapper();
    fail |= test_gmac();
    fail |= test_cmac();
    fail |= test_kmac();

    if (fail) {
        return 1;
    }

    printf("Ok\n");
    return 0;

}
