#include "etmkem.h"
#include "authenticators.h"
#include "kyber/ref/fips202.h"
#include "kyber/ref/indcpa.h"
#include "kyber/ref/params.h"
#include "kyber/ref/randombytes.h"
#include <string.h>

/**
 * Generate the encrypt-then-MAC keypair using the pseudorandom coins as the
 * seed. Caller is responsible for providing correctly sized buffers.
 *
 * The ETM-KEM public key is identical to that of the PKE. The ETM-KEM private
 * key is laid out as kem_sk = pke_sk || SHA3-256(pke_pk) || z
 * where z is the rejection symbol.
 *
 * We include a hash of the public key to save hashing the public key: the
 * public key is usually large so hashing the public key can be slow. ETM-KEM
 * does not perform re-encrypt, so the PKE public key itself is not needed.
 *
 * This function will never fail and so no return code is necessary
 */
void etmkem_keypair_derand(uint8_t *pk, uint8_t *sk, const uint8_t *coins) {
  uint8_t *indcpa_pk = pk;
  uint8_t *indcpa_sk = sk;
  uint8_t *indcpa_pkhash = sk + KYBER_INDCPA_SECRETKEYBYTES;
  uint8_t *rejsymbol = sk + KYBER_INDCPA_SECRETKEYBYTES + KYBER_SYMBYTES;
  indcpa_keypair_derand(indcpa_pk, indcpa_sk, coins);

  keccak_state hasher;
  shake256_init(&hasher);
  shake256_absorb_once(&hasher, indcpa_pk, KYBER_INDCPA_PUBLICKEYBYTES);
  shake256_squeeze(indcpa_pkhash, KYBER_SYMBYTES, &hasher);

  randombytes(rejsymbol, KYBER_INDCPA_MSGBYTES);
}

/**
 * The encrypt-then-MAC KEM encapsulates by encrypting a randomly sampled
 * PKE plaintext. The ciphertext and the shared secret will be written to the
 * input buffer. Caller is responsible for providing correctly sized buffer.
 */
void etmkem_encap(uint8_t *ct, uint8_t *ss, const uint8_t *pk) {
  // INDCPA public key and plaintext will be absorbed together
  uint8_t pkhash_pt[KYBER_SYMBYTES + KYBER_INDCPA_MSGBYTES];
  uint8_t *pt = pkhash_pt + KYBER_SYMBYTES;
  keccak_state hasher;
  shake256_init(&hasher);
  shake256_absorb_once(&hasher, pk, KYBER_INDCPA_PUBLICKEYBYTES);
  shake256_squeeze(pkhash_pt, KYBER_SYMBYTES, &hasher);
  randombytes(pt, KYBER_INDCPA_MSGBYTES);

  // hash public key and plaintext into:
  // prekey: which will later contribute to the session key
  // mackey: the symmetric key for the MAC
  // NOTE: some MAC has nonce (e.g. GMAC), which will need to be filled, as well
  // uint8_t prekey_mackey_macnonce[KYBER_SSBYTES + GMAC_KEYBYTES +
  //     GMAC_IVBYTES];
  uint8_t prekey_mackey[KYBER_SSBYTES + POLY1305_KEYBYTES];
  uint8_t *mackey = prekey_mackey + KYBER_SSBYTES;
  keccak_state xof;
  shake256_init(&xof);
  // NOTE: absorb_once is non-incremental whereas absorb is incremental; since
  // we have all absorption material, using absorb_once helps decreases the
  // number of function calls
  shake256_absorb_once(&xof, pkhash_pt, KYBER_SYMBYTES + KYBER_INDCPA_MSGBYTES);
  // NOTE: squeezeblocks will squeeze full blocks
  shake256_squeeze(prekey_mackey, KYBER_SSBYTES + POLY1305_KEYBYTES, &xof);

  // ETM-KEM's ciphertext contains the IND-CPA ciphertext and a MAC tag
  uint8_t *pke_ct = ct;
  uint8_t *mactag = ct + KYBER_INDCPA_BYTES;
  uint8_t coins[KYBER_SYMBYTES];
  randombytes(coins, KYBER_SYMBYTES);
  indcpa_enc(pke_ct, pt, pk, coins);
  mac_poly1305(mactag, mackey, pke_ct, KYBER_INDCPA_BYTES);

  // derive session key by hashing prekey (which already contains pk and pt) and
  // tag
  shake256_init(&xof);
  shake256_absorb(&xof, prekey_mackey, KYBER_SSBYTES); // absorb only the prekey
  shake256_absorb(&xof, mactag, POLY1305_TAGBYTES);
  shake256_finalize(&xof);
  shake256_squeeze(ss, KYBER_SSBYTES, &xof);
}

/**
 * The ETM-KEM decapsulates by first decrypting the ciphertext. It then hashes
 * the decryption and the public key to re-derive the MAC key, which is then
 * used to re-compute the tag. If the tag matches what is on the ciphertext, the
 * ciphertext is valid; otherwise it is not.
 */
void etmkem_decap(uint8_t *ss, const uint8_t *ct, const uint8_t *sk) {
  const uint8_t *pke_sk = sk;
  const uint8_t *rejsymbol = sk + KYBER_INDCPA_SECRETKEYBYTES + KYBER_SYMBYTES;
  const uint8_t *pke_ct = ct;
  const uint8_t *mactag = ct + KYBER_INDCPA_BYTES;

  // Decrypt PKE ciphertext and copy the public key hash
  uint8_t pkhash_decryption[KYBER_SYMBYTES + KYBER_INDCPA_MSGBYTES];
  uint8_t *decryption = pkhash_decryption + KYBER_SYMBYTES;
  indcpa_dec(decryption, pke_ct, pke_sk);
  memcpy(pkhash_decryption, sk + KYBER_INDCPA_SECRETKEYBYTES, KYBER_SYMBYTES);

  // derive prekey and mackey
  uint8_t prekey_mackey[KYBER_SSBYTES + POLY1305_KEYBYTES];
  uint8_t *mackey = prekey_mackey + KYBER_SSBYTES;
  keccak_state hasher;
  shake256_init(&hasher);
  shake256_absorb_once(&hasher, pkhash_decryption,
                       KYBER_SYMBYTES + KYBER_INDCPA_MSGBYTES);
  shake256_squeeze(prekey_mackey, KYBER_SSBYTES + POLY1305_KEYBYTES, &hasher);

  // To achieve constant time, both the true session key and the implicit
  // rejection will be computed
  uint8_t true_ss[KYBER_SSBYTES];
  shake256_init(&hasher);
  shake256_absorb(&hasher, prekey_mackey, KYBER_SSBYTES);
  shake256_absorb(&hasher, mactag, POLY1305_TAGBYTES);
  shake256_finalize(&hasher);
  shake256_squeeze(true_ss, KYBER_SSBYTES, &hasher);
  uint8_t false_ss[KYBER_SSBYTES];
  shake256_init(&hasher);
  shake256_absorb(&hasher, ct, KYBER_INDCPA_BYTES + POLY1305_TAGBYTES);
  shake256_absorb(&hasher, rejsymbol, KYBER_INDCPA_MSGBYTES);
  shake256_finalize(&hasher);
  shake256_squeeze(false_ss, KYBER_SSBYTES, &hasher);

  // Re-compute the tag
  uint8_t recomp_mactag[POLY1305_TAGBYTES];
  mac_poly1305(recomp_mactag, mackey, pke_ct, KYBER_INDCPA_BYTES);
  uint8_t diff = 0;
  for (int i = 0; i < POLY1305_TAGBYTES; i++) {
    diff |= recomp_mactag[i] ^ mactag[i];
  }

  // Supposedly constant-time selection, suggested by ChatGPT
  for (int i = 0; i < KYBER_SSBYTES; i++) {
    ss[i] = ((1 - diff) * true_ss[i]) | (diff * false_ss[i]);
  }
}
