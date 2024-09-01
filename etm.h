#include "authenticators.h"
#include "kyber/ref/params.h"
#include <stdint.h>
#include "kyber/ref/kem.h"

#define ETM_PUBLICKEYBYTES KYBER_PUBLICKEYBYTES
#define ETM_SECRETKEYBYTES KYBER_SECRETKEYBYTES
#define ETM_CIPHERTEXTBYTES (KYBER_CIPHERTEXTBYTES + MAC_TAG_BYTES)
#define ETM_SESSIONKEYBYTES KYBER_SYMBYTES

// TODO: etm's keygen is identical to kyber's so no separate function was 
// defined but maybe we should
int etm_encap_derand(uint8_t *ct, uint8_t *ss, const uint8_t *pk,
                     const uint8_t *indcpa_pt, const uint8_t *indcpa_coin);
int etm_encap(uint8_t *ct, uint8_t *ss, const uint8_t *pk);
int etm_decap(uint8_t *ct, uint8_t *ss, const uint8_t *sk);
