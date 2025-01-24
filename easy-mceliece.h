/**
* Jan 24, 2025: we will only use the AVX implementations
* The encrypt-then-MAC KEM transformation does not claim to impact keygen
* performance by much, so we will also skip the f-variants of McEliece.
*/
#ifndef EASYMCELIECE_H
#define EASYMCELIECE_H

#if (MCELIECE_N == 3488)
#include "easy-mceliece/avx/mceliece348864/api.h"
#include "easy-mceliece/avx/mceliece348864/operations.h"
#include "easy-mceliece/avx/mceliece348864/params.h"
#include "easy-mceliece/avx/mceliece348864/encrypt.h"
#include "easy-mceliece/avx/mceliece348864/decrypt.h"


#elif (MCELIECE_N == 4608)
#include "easy-mceliece/avx/mceliece460896/api.h"
#include "easy-mceliece/avx/mceliece460896/operations.h"
#include "easy-mceliece/avx/mceliece460896/params.h"
#include "easy-mceliece/avx/mceliece460896/encrypt.h"
#include "easy-mceliece/avx/mceliece460896/decrypt.h"

#elif (MCELIECE_N == 6688)
#include "easy-mceliece/avx/mceliece6688128/api.h"
#include "easy-mceliece/avx/mceliece6688128/operations.h"
#include "easy-mceliece/avx/mceliece6688128/params.h"
#include "easy-mceliece/avx/mceliece6688128/encrypt.h"
#include "easy-mceliece/avx/mceliece6688128/decrypt.h"

#elif (MCELIECE_N == 6960)
#include "easy-mceliece/avx/mceliece6960119/api.h"
#include "easy-mceliece/avx/mceliece6960119/operations.h"
#include "easy-mceliece/avx/mceliece6960119/params.h"
#include "easy-mceliece/avx/mceliece6960119/encrypt.h"
#include "easy-mceliece/avx/mceliece6960119/decrypt.h"

#elif (MCELIECE_N == 8192)
#include "easy-mceliece/avx/mceliece8192128/api.h"
#include "easy-mceliece/avx/mceliece8192128/operations.h"
#include "easy-mceliece/avx/mceliece8192128/params.h"
#include "easy-mceliece/avx/mceliece8192128/encrypt.h"
#include "easy-mceliece/avx/mceliece8192128/decrypt.h"

#else
#error "Invalid MCELIECE_N"
#endif

#define CRYPTO_PLAINTEXTBYTES (SYS_N / 8)

#endif
