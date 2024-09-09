#!/bin/bash
#
# Usage: ./run_all_kex_client.sh <server_hostname>

if [ -z "$1" ]; then
  echo "Usage: ./run_all_kex_cilent.sh <server_hostname>"
  exit 1
fi

if ping -c 1 $1 &> /dev/null
then
  echo "$1 is reachable"
else
  echo "$1 is unreachable"
  exit 1
fi

# Run all key exchange and record their performances
make kex

# ML-KEM 512 and variants
./keygen512 id_kyber "kyber512"

./kex_etm512_poly1305_client none $1 8000
sleep 1
./kex_etm512_poly1305_client server $1 8001
sleep 1
./kex_etm512_poly1305_client client $1 8002
sleep 1
./kex_etm512_poly1305_client all $1 8003
sleep 1

./kex_etm512_gmac_client none $1 8004
sleep 1
./kex_etm512_gmac_client server $1 8005
sleep 1
./kex_etm512_gmac_client client $1 8006
sleep 1
./kex_etm512_gmac_client all $1 8007
sleep 1

./kex_etm512_cmac_client none $1 8008
sleep 1
./kex_etm512_cmac_client server $1 8009
sleep 1
./kex_etm512_cmac_client client $1 8010
sleep 1
./kex_etm512_cmac_client all $1 8011
sleep 1

./kex_etm512_kmac_client none $1 8012
sleep 1
./kex_etm512_kmac_client server $1 8013
sleep 1
./kex_etm512_kmac_client client $1 8014
sleep 1
./kex_etm512_kmac_client all $1 8015
sleep 1

./kex_mlkem512_client none $1 8016
sleep 1
./kex_mlkem512_client server $1 8017
sleep 1
./kex_mlkem512_client client $1 8018
sleep 1
./kex_mlkem512_client all $1 8019
sleep 1

rm id_kyber.bin
rm id_kyber.pub.bin

# ML-KEM 768 and variants
./keygen768 id_kyber "kyber768"

./kex_etm768_poly1305_client none $1 8020
sleep 1
./kex_etm768_poly1305_client server $1 8021
sleep 1
./kex_etm768_poly1305_client client $1 8022
sleep 1
./kex_etm768_poly1305_client all $1 8023
sleep 1

./kex_etm768_gmac_client none $1 8024
sleep 1
./kex_etm768_gmac_client server $1 8025
sleep 1
./kex_etm768_gmac_client client $1 8026
sleep 1
./kex_etm768_gmac_client all $1 8027
sleep 1

./kex_etm768_cmac_client none $1 8028
sleep 1
./kex_etm768_cmac_client server $1 8029
sleep 1
./kex_etm768_cmac_client client $1 8030
sleep 1
./kex_etm768_cmac_client all $1 8031
sleep 1

./kex_etm768_kmac_client none $1 8032
sleep 1
./kex_etm768_kmac_client server $1 8033
sleep 1
./kex_etm768_kmac_client client $1 8034
sleep 1
./kex_etm768_kmac_client all $1 8035
sleep 1

./kex_mlkem768_client none $1 8036
sleep 1
./kex_mlkem768_client server $1 8037
sleep 1
./kex_mlkem768_client client $1 8038
sleep 1
./kex_mlkem768_client all $1 8039
sleep 1

rm id_kyber.bin
rm id_kyber.pub.bin

# ML-KEM 1024 and variants
./keygen1024 id_kyber "kyber1024"

./kex_etm1024_poly1305_client none $1 8040
sleep 1
./kex_etm1024_poly1305_client server $1 8041
sleep 1
./kex_etm1024_poly1305_client client $1 8042
sleep 1
./kex_etm1024_poly1305_client all $1 8043
sleep 1

./kex_etm1024_gmac_client none $1 8044
sleep 1
./kex_etm1024_gmac_client server $1 8045
sleep 1
./kex_etm1024_gmac_client client $1 8046
sleep 1
./kex_etm1024_gmac_client all $1 8047
sleep 1

./kex_etm1024_cmac_client none $1 8048
sleep 1
./kex_etm1024_cmac_client server $1 8049
sleep 1
./kex_etm1024_cmac_client client $1 8050
sleep 1
./kex_etm1024_cmac_client all $1 8051
sleep 1

./kex_etm1024_kmac_client none $1 8052
sleep 1
./kex_etm1024_kmac_client server $1 8053
sleep 1
./kex_etm1024_kmac_client client $1 8054
sleep 1
./kex_etm1024_kmac_client all $1 8055
sleep 1

./kex_mlkem1024_client none $1 8056
sleep 1
./kex_mlkem1024_client server $1 8057
sleep 1
./kex_mlkem1024_client client $1 8058
sleep 1
./kex_mlkem1024_client all $1 8059
sleep 1

rm id_kyber.bin
rm id_kyber.pub.bin
