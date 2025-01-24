/**
* Jan 24, 2025: we will only use the AVX implementations
*/
#ifndef EASYMCELIECE_H
#define EASYMCELIECE_H

#if (MCELIECE_N == 3488) && !defined(FASTKEYGEN)
#include "easy-mceliece/avx/mceliece348864/api.h"
#include "easy-mceliece/avx/mceliece348864/operations.h"
#include "easy-mceliece/avx/mceliece348864/params.h"
#include "easy-mceliece/avx/mceliece348864/encrypt.h"
#include "easy-mceliece/avx/mceliece348864/decrypt.h"
#include "easy-mceliece/avx/mceliece348864/keccak.h"

#elif (MCELIECE_N == 3488) && defined(FASTKEYGEN)
#include "easy-mceliece/avx/mceliece348864f/api.h"
#include "easy-mceliece/avx/mceliece348864f/operations.h"
#include "easy-mceliece/avx/mceliece348864f/params.h"
#include "easy-mceliece/avx/mceliece348864f/encrypt.h"
#include "easy-mceliece/avx/mceliece348864f/decrypt.h"
#include "easy-mceliece/avx/mceliece348864f/keccak.h"

#elif (MCELIECE_N == 4608) && !defined(FASTKEYGEN)
#include "easy-mceliece/avx/mceliece460896/api.h"
#include "easy-mceliece/avx/mceliece460896/operations.h"
#include "easy-mceliece/avx/mceliece460896/params.h"
#include "easy-mceliece/avx/mceliece460896/encrypt.h"
#include "easy-mceliece/avx/mceliece460896/decrypt.h"
#include "easy-mceliece/avx/mceliece460896/keccak.h"

#elif (MCELIECE_N == 4608) && defined(FASTKEYGEN)
#include "easy-mceliece/avx/mceliece460896f/api.h"
#include "easy-mceliece/avx/mceliece460896f/operations.h"
#include "easy-mceliece/avx/mceliece460896f/params.h"
#include "easy-mceliece/avx/mceliece460896f/encrypt.h"
#include "easy-mceliece/avx/mceliece460896f/decrypt.h"
#include "easy-mceliece/avx/mceliece460896f/keccak.h"

#elif (MCELIECE_N == 6688) && !defined(FASTKEYGEN)
#include "easy-mceliece/avx/mceliece6688128/api.h"
#include "easy-mceliece/avx/mceliece6688128/operations.h"
#include "easy-mceliece/avx/mceliece6688128/params.h"
#include "easy-mceliece/avx/mceliece6688128/encrypt.h"
#include "easy-mceliece/avx/mceliece6688128/decrypt.h"
#include "easy-mceliece/avx/mceliece6688128/keccak.h"

#elif (MCELIECE_N == 6688) && defined(FASTKEYGEN)
#include "easy-mceliece/avx/mceliece6688128f/api.h"
#include "easy-mceliece/avx/mceliece6688128f/operations.h"
#include "easy-mceliece/avx/mceliece6688128f/params.h"
#include "easy-mceliece/avx/mceliece6688128f/encrypt.h"
#include "easy-mceliece/avx/mceliece6688128f/decrypt.h"
#include "easy-mceliece/avx/mceliece6688128f/keccak.h"

#elif (MCELIECE_N == 6960) && !defined(FASTKEYGEN)
#include "easy-mceliece/avx/mceliece6960119/api.h"
#include "easy-mceliece/avx/mceliece6960119/operations.h"
#include "easy-mceliece/avx/mceliece6960119/params.h"
#include "easy-mceliece/avx/mceliece6960119/encrypt.h"
#include "easy-mceliece/avx/mceliece6960119/decrypt.h"
#include "easy-mceliece/avx/mceliece6960119/keccak.h"

#elif (MCELIECE_N == 6960) && defined(FASTKEYGEN)
#include "easy-mceliece/avx/mceliece6960119f/api.h"
#include "easy-mceliece/avx/mceliece6960119f/operations.h"
#include "easy-mceliece/avx/mceliece6960119f/params.h"
#include "easy-mceliece/avx/mceliece6960119f/encrypt.h"
#include "easy-mceliece/avx/mceliece6960119f/decrypt.h"
#include "easy-mceliece/avx/mceliece6960119f/keccak.h"

#elif (MCELIECE_N == 8192) && !defined(FASTKEYGEN)
#include "easy-mceliece/avx/mceliece8192128/api.h"
#include "easy-mceliece/avx/mceliece8192128/operations.h"
#include "easy-mceliece/avx/mceliece8192128/params.h"
#include "easy-mceliece/avx/mceliece8192128/encrypt.h"
#include "easy-mceliece/avx/mceliece8192128/decrypt.h"
#include "easy-mceliece/avx/mceliece8192128/keccak.h"

#elif (MCELIECE_N == 8192) && defined(FASTKEYGEN)
#include "easy-mceliece/avx/mceliece8192128f/api.h"
#include "easy-mceliece/avx/mceliece8192128f/operations.h"
#include "easy-mceliece/avx/mceliece8192128f/params.h"
#include "easy-mceliece/avx/mceliece8192128f/encrypt.h"
#include "easy-mceliece/avx/mceliece8192128f/decrypt.h"
#include "easy-mceliece/avx/mceliece8192128f/keccak.h"

#else
#error "Invalid MCELIECE_N"
#endif

#define CRYPTO_PLAINTEXTBYTES (SYS_N / 8)

#endif
