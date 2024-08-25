#include <stdint.h>

int etm_encap_derand(uint8_t *ct, uint8_t *ss, const uint8_t *pk, const uint8_t *indcpa_pt, const uint8_t *indcpa_coin);
int etm_encap(uint8_t *ct, uint8_t *ss, const uint8_t *pk);
