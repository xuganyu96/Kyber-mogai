#include "authenticators.h"
#include "pke.h"
#include <stdio.h>

int main(void) {
  uint8_t pke_pk[PKE_PUBLICKEYBYTES];
  uint8_t pke_sk[PKE_SECRETKEYBYTES];
  uint8_t pke_pt[PKE_PLAINTEXTBYTES];
  uint8_t pke_ct[PKE_CIPHERTEXTBYTES];
  uint8_t coins[PKE_SYMBYTES];
  pke_keypair(pke_pk, pke_sk, coins);
  sample_pke_pt(pke_pt, NULL);
  pke_enc(pke_ct, pke_pt, pke_pk, coins);

  uint8_t ptcmp[PKE_PLAINTEXTBYTES];
  pke_dec(ptcmp, pke_ct, pke_sk);

  int diff = 0;
  for (int i = 0; i < PKE_PLAINTEXTBYTES; i++) {
    diff |= pke_pt[i] ^ ptcmp[i];
  }
  if (diff) {
    printf("Decryption failed\n");
  } else {
    printf("Decryption is correct\n");
  }

  uint8_t mac_key[MAC_KEYBYTES];
  uint8_t mac_tag[MAC_TAGBYTES];
  uint8_t mac_iv[MAC_IVBYTES];
  mac_sign(mac_tag, mac_key, mac_iv, pke_ct, PKE_CIPHERTEXTBYTES);
  if (mac_cmp(mac_tag, mac_key, mac_iv, pke_ct, PKE_CIPHERTEXTBYTES)) {
    printf("MAC is bad\n");
  } else {
    printf("MAC is good\n");
  }

  return 0;
}
