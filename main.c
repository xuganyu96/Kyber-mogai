#include "kyber/ref/params.h"
#include "stdio.h"
#include "stdint.h"
#include "authenticators.h"
#include "kyber/ref/indcpa.h"

int main(int argc, char *argv[]) {
    uint8_t pk[KYBER_INDCPA_PUBLICKEYBYTES];
    uint8_t ct[KYBER_INDCPA_BYTES + MAC_TAG_BYTES];
    uint8_t ss[KYBER_SYMBYTES];
    uint8_t pt[KYBER_INDCPA_MSGBYTES];
    uint8_t coin[KYBER_SYMBYTES];


}
