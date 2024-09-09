#!/bin/bash
#
# Usage: ./run_all_kex_server.sh

# Run all key exchange and record their performances
make kex

# ML-KEM 512 and variants
./keygen512 id_kyber "kyber512"

./kex_etm512_poly1305_server none none 8000
./kex_etm512_poly1305_server server none 8001
./kex_etm512_poly1305_server client none 8002
./kex_etm512_poly1305_server all none 8003

./kex_etm512_gmac_server none none 8004
./kex_etm512_gmac_server server none 8005
./kex_etm512_gmac_server client none 8006
./kex_etm512_gmac_server all none 8007

./kex_etm512_cmac_server none none 8008
./kex_etm512_cmac_server server none 8009
./kex_etm512_cmac_server client none 8010
./kex_etm512_cmac_server all none 8011

./kex_etm512_kmac_server none none 8012
./kex_etm512_kmac_server server none 8013
./kex_etm512_kmac_server client none 8014
./kex_etm512_kmac_server all none 8015

./kex_mlkem512_server none none 8016
./kex_mlkem512_server server none 8017
./kex_mlkem512_server client none 8018
./kex_mlkem512_server all none 8019

rm id_kyber.bin
rm id_kyber.pub.bin

# ML-KEM 768 and variants
./keygen768 id_kyber "kyber768"

./kex_etm768_poly1305_server none none 8020
./kex_etm768_poly1305_server server none 8021
./kex_etm768_poly1305_server client none 8022
./kex_etm768_poly1305_server all none 8023

./kex_etm768_gmac_server none none 8024
./kex_etm768_gmac_server server none 8025
./kex_etm768_gmac_server client none 8026
./kex_etm768_gmac_server all none 8027

./kex_etm768_cmac_server none none 8028
./kex_etm768_cmac_server server none 8029
./kex_etm768_cmac_server client none 8030
./kex_etm768_cmac_server all none 8031

./kex_etm768_kmac_server none none 8032
./kex_etm768_kmac_server server none 8033
./kex_etm768_kmac_server client none 8034
./kex_etm768_kmac_server all none 8035

./kex_mlkem768_server none none 8036
./kex_mlkem768_server server none 8037
./kex_mlkem768_server client none 8038
./kex_mlkem768_server all none 8039

rm id_kyber.bin
rm id_kyber.pub.bin

# ML-KEM 1024 and variants
./keygen1024 id_kyber "kyber1024"

./kex_etm1024_poly1305_server none none 8040
./kex_etm1024_poly1305_server server none 8041
./kex_etm1024_poly1305_server client none 8042
./kex_etm1024_poly1305_server all none 8043

./kex_etm1024_gmac_server none none 8044
./kex_etm1024_gmac_server server none 8045
./kex_etm1024_gmac_server client none 8046
./kex_etm1024_gmac_server all none 8047

./kex_etm1024_cmac_server none none 8048
./kex_etm1024_cmac_server server none 8049
./kex_etm1024_cmac_server client none 8050
./kex_etm1024_cmac_server all none 8051

./kex_etm1024_kmac_server none none 8052
./kex_etm1024_kmac_server server none 8053
./kex_etm1024_kmac_server client none 8054
./kex_etm1024_kmac_server all none 8055

./kex_mlkem1024_server none none 8056
./kex_mlkem1024_server server none 8057
./kex_mlkem1024_server client none 8058
./kex_mlkem1024_server all none 8059

rm id_kyber.bin
rm id_kyber.pub.bin
