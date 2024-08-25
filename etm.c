#include <stdint.h>
#include <string.h>
#include "kyber/ref/randombytes.h"
#include "kyber/ref/symmetric.h"
#include "kyber/ref/params.h"
#include "kyber/ref/indcpa.h"
#include "authenticators.h"

int etm_encap_derand(uint8_t *ct,
                     uint8_t *ss,
                     const uint8_t *pk,
                     const uint8_t *indcpa_pt,
                     const uint8_t *indcpa_coin) {
    // plaintext || H(pk)
    uint8_t mh[KYBER_INDCPA_MSGBYTES + KYBER_SYMBYTES];
    // preKey || MAC key
    uint8_t kk[KYBER_SYMBYTES + MAC_KEY_BYTES];
    // holds preKey || tag
    uint8_t kt[KYBER_SYMBYTES + MAC_TAG_BYTES];

    memcpy(mh, indcpa_pt, KYBER_INDCPA_MSGBYTES);
    hash_h(mh + KYBER_INDCPA_MSGBYTES, pk, KYBER_PUBLICKEYBYTES);
    // this is technically incorrect: it only works because MAC_KEY_BYTES happen to be equal to
    // KYBER_SYMBYTES.
    // TODO: maybe use the xof?
    hash_g(kk, mh, sizeof(mh));

    indcpa_enc(ct, indcpa_pt, pk, indcpa_coin);
    mac(kk + KYBER_SYMBYTES, ct, KYBER_CIPHERTEXTBYTES, ct + KYBER_CIPHERTEXTBYTES);

    memcpy(kt, kk, KYBER_SYMBYTES);
    memcpy(kt + KYBER_SYMBYTES, ct + KYBER_CIPHERTEXTBYTES, MAC_TAG_BYTES);
    hash_h(ss, kt, sizeof(kt));

    return 0;
}

int etm_encap(uint8_t *ct,
              uint8_t *ss,
              const uint8_t *pk) {
    uint8_t ptcoins[KYBER_INDCPA_MSGBYTES + KYBER_SYMBYTES];
    randombytes(ptcoins, sizeof(ptcoins));
    etm_encap_derand(ct, ss, pk, ptcoins, ptcoins + KYBER_INDCPA_MSGBYTES);

    return 0;
}

int etm_decap(uint8_t *ct, uint8_t *ss, const uint8_t *sk) {
    uint8_t mh[KYBER_INDCPA_MSGBYTES + KYBER_SYMBYTES];
    uint8_t kk[KYBER_SYMBYTES + MAC_KEY_BYTES];
    uint8_t verify_tag[MAC_TAG_BYTES];
    indcpa_dec(mh, ct, sk);
    memcpy(mh + KYBER_INDCPA_MSGBYTES, sk + KYBER_SECRETKEYBYTES - 2 * KYBER_SYMBYTES, KYBER_SYMBYTES);
    hash_g(kk, mh, sizeof(mh));

    // verify the tag
    mac(kk + KYBER_SYMBYTES, ct, KYBER_CIPHERTEXTBYTES, verify_tag);
    int fail = 0;
    for(size_t i = 0; i < MAC_TAG_BYTES; i++) {
        if((ct + KYBER_CIPHERTEXTBYTES)[i] != verify_tag[i]) {
            fail |= 1;
        }
    }

    // compute the rejection symbol
    uint8_t zt[KYBER_SYMBYTES + MAC_TAG_BYTES];
    memcpy(zt, sk + KYBER_SECRETKEYBYTES - KYBER_SYMBYTES, KYBER_SYMBYTES);  // copy z
    memcpy(zt + KYBER_SYMBYTES, ct + KYBER_CIPHERTEXTBYTES, MAC_TAG_BYTES);  // copy t
    hash_h(ss, zt, sizeof(zt));

    if(!fail) {
        uint8_t kt[KYBER_SYMBYTES + MAC_TAG_BYTES];
        memcpy(kt, kk, KYBER_SYMBYTES);
        memcpy(kt + KYBER_SYMBYTES, ct + KYBER_CIPHERTEXTBYTES, MAC_TAG_BYTES);
        hash_h(ss, kt, sizeof(kt));
    }

    return 0;
}
