#!/bin/bash

make -C easy-mceliece -f avx.Makefile tests -j8
make all -j8

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <number_of_times>"
    exit 1
fi

# Check if the argument is a valid positive integer
if ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "Error: Argument must be a positive integer."
    exit 1
fi

# Store the argument
n=$1

# Loop n times
for ((i=1; i<=n; i++))
do
    echo "run $i"
    echo "mceliece348864_avx" && ./easy-mceliece/target/test_mceliece348864_avx_correctness
    echo "mceliece348864f_avx" && ./easy-mceliece/target/test_mceliece348864f_avx_correctness
    echo "mceliece460896_avx" && ./easy-mceliece/target/test_mceliece460896_avx_correctness
    echo "mceliece460896f_avx" && ./easy-mceliece/target/test_mceliece460896f_avx_correctness
    echo "mceliece6688128_avx" && ./easy-mceliece/target/test_mceliece6688128_avx_correctness
    echo "mceliece6688128f_avx" && ./easy-mceliece/target/test_mceliece6688128f_avx_correctness
    echo "mceliece6960119_avx" && ./easy-mceliece/target/test_mceliece6960119_avx_correctness
    echo "mceliece6960119f_avx" && ./easy-mceliece/target/test_mceliece6960119f_avx_correctness
    echo "mceliece8192128_avx" && ./easy-mceliece/target/test_mceliece8192128_avx_correctness
    echo "mceliece8192128f_avx" && ./easy-mceliece/target/test_mceliece8192128f_avx_correctness
    echo "mceliece348864_avx" && ./easy-mceliece/target/test_mceliece348864_avx_speed
    echo "mceliece348864f_avx" && ./easy-mceliece/target/test_mceliece348864f_avx_speed
    echo "mceliece460896_avx" && ./easy-mceliece/target/test_mceliece460896_avx_speed
    echo "mceliece460896f_avx" && ./easy-mceliece/target/test_mceliece460896f_avx_speed
    echo "mceliece6688128_avx" && ./easy-mceliece/target/test_mceliece6688128_avx_speed
    echo "mceliece6688128f_avx" && ./easy-mceliece/target/test_mceliece6688128f_avx_speed
    echo "mceliece6960119_avx" && ./easy-mceliece/target/test_mceliece6960119_avx_speed
    echo "mceliece6960119f_avx" && ./easy-mceliece/target/test_mceliece6960119f_avx_speed
    echo "mceliece8192128_avx" && ./easy-mceliece/target/test_mceliece8192128_avx_speed
    echo "mceliece8192128f_avx" && ./easy-mceliece/target/test_mceliece8192128f_avx_speed

    echo "mceliece348864_poly1305" && target/mceliece348864_poly1305
    echo "mceliece348864f_poly1305" && target/mceliece348864f_poly1305
    echo "mceliece460896_poly1305" && target/mceliece460896_poly1305
    echo "mceliece460896f_poly1305" && target/mceliece460896f_poly1305
    echo "mceliece6688128_poly1305" && target/mceliece6688128_poly1305
    echo "mceliece6688128f_poly1305" && target/mceliece6688128f_poly1305
    echo "mceliece6960119_poly1305" && target/mceliece6960119_poly1305
    echo "mceliece6960119f_poly1305" && target/mceliece6960119f_poly1305
    echo "mceliece8192128_poly1305" && target/mceliece8192128_poly1305
    echo "mceliece8192128f_poly1305" && target/mceliece8192128f_poly1305
    echo "mceliece348864_gmac" && target/mceliece348864_gmac
    echo "mceliece348864f_gmac" && target/mceliece348864f_gmac
    echo "mceliece460896_gmac" && target/mceliece460896_gmac
    echo "mceliece460896f_gmac" && target/mceliece460896f_gmac
    echo "mceliece6688128_gmac" && target/mceliece6688128_gmac
    echo "mceliece6688128f_gmac" && target/mceliece6688128f_gmac
    echo "mceliece6960119_gmac" && target/mceliece6960119_gmac
    echo "mceliece6960119f_gmac" && target/mceliece6960119f_gmac
    echo "mceliece8192128_gmac" && target/mceliece8192128_gmac
    echo "mceliece8192128f_gmac" && target/mceliece8192128f_gmac
    echo "mceliece348864_cmac" && target/mceliece348864_cmac
    echo "mceliece348864f_cmac" && target/mceliece348864f_cmac
    echo "mceliece460896_cmac" && target/mceliece460896_cmac
    echo "mceliece460896f_cmac" && target/mceliece460896f_cmac
    echo "mceliece6688128_cmac" && target/mceliece6688128_cmac
    echo "mceliece6688128f_cmac" && target/mceliece6688128f_cmac
    echo "mceliece6960119_cmac" && target/mceliece6960119_cmac
    echo "mceliece6960119f_cmac" && target/mceliece6960119f_cmac
    echo "mceliece8192128_cmac" && target/mceliece8192128_cmac
    echo "mceliece8192128f_cmac" && target/mceliece8192128f_cmac
    echo "mceliece348864_kmac256" && target/mceliece348864_kmac256
    echo "mceliece348864f_kmac256" && target/mceliece348864f_kmac256
    echo "mceliece460896_kmac256" && target/mceliece460896_kmac256
    echo "mceliece460896f_kmac256" && target/mceliece460896f_kmac256
    echo "mceliece6688128_kmac256" && target/mceliece6688128_kmac256
    echo "mceliece6688128f_kmac256" && target/mceliece6688128f_kmac256
    echo "mceliece6960119_kmac256" && target/mceliece6960119_kmac256
    echo "mceliece6960119f_kmac256" && target/mceliece6960119f_kmac256
    echo "mceliece8192128_kmac256" && target/mceliece8192128_kmac256
    echo "mceliece8192128f_kmac256" && target/mceliece8192128f_kmac256
done

