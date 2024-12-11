TODO:
- test loopback kex times
- test kex times on a pair of servers on AWS

# Faster generic IND-CCA secure KEM using encrypt-then-MAC
This is the accompanying source code for the paper titled _Faster generic IND-CCA secure KEM using encrypt-then-MAC_.

# Getting started
The [`Makefile`](./Makefile) contains three main sets of compilation targets:
- `make tests` compiles and runs correctness tests. Each correctness test generates a random key pair, then check that decrypting a random encryption recovers the correct plaintext
- `make speed` compiles and runs speed tests. Each speed test measures the medium time (CPU clock or CPU cycles depending on the platform, see [speed.h](./speed.h) for specific definitions) needed to execute `TEST_ROUNDS` calls to `keygen`, `enc`, and `dec` routines.
- `make kex` compiles all key exchange binaries. Each KEM scheme has its own pair of server and client binaries (e.g. `target/kex_kyber1024_client` and `target/kex_kyber1024_server`). To run a key exchange benchmark, first run the server `./target/kex_kyber1024_server <none|server|client|all> 127.0.0.1 <port>`, then run the client `./target/kex_kyber1024_client <none|server|client|all> <servername> <port>`. I also included convenient make target `make run_kex_servers_all` and `make run_kex_clients_all server_name=<server_name>`, which will run all key exchange binaries in sequence.

## Performance
This batch of performance number is strange. Kyber/ML-KEM numbers are in line with the [published results from PQCrystals](https://pq-crystals.org/kyber/index.shtml). However, McEliece numbers are way off its [published results](https://classic.mceliece.org/impl.html).

|KEM|encap|decap|
|:---|:---|:---|
|mlkem512|90634|120540|
|mlkem768|144730|183660|
|mlkem1024|203408|251914|
|mceliece348864|93979|42580525|
|mceliece460896|188252|97297777|
|mceliece6688128|296052|186754052|
|mceliece6960119|533305|180815173|
|mceliece8192128|348862|228409562|
|kyber512_poly1305|92084|37577|
|kyber512_gmac|99544|43203|
|kyber512_cmac|102258|45541|
|kyber512_kmac256|103929|46892|
|kyber768_poly1305|141076|48082|
|kyber768_gmac|152168|53501|
|kyber768_cmac|155397|56923|
|kyber768_kmac256|158289|59609|
|kyber1024_poly1305|215765|62412|
|kyber1024_gmac|211980|64353|
|kyber1024_cmac|216623|69045|
|kyber1024_kmac256|219665|72748|
|mceliece348864_poly1305|1735309|23748450|
|mceliece348864_gmac|1739049|23760303|
|mceliece348864_cmac|1738782|23759384|
|mceliece348864_kmac256|1738417|23757472|
|mceliece460896_poly1305|3607049|54184695|
|mceliece460896_gmac|3488256|54156512|
|mceliece460896_cmac|3475866|54159486|
|mceliece460896_kmac256|3487676|54158849|
|mceliece6688128_poly1305|6907116|103759820|
|mceliece6688128_gmac|6874567|103802367|
|mceliece6688128_cmac|6872755|105307270|
|mceliece6688128_kmac256|6899139|105370200|
|mceliece6960119_poly1305|7592450|101810383|
|mceliece6960119_gmac|7135215|100448330|
|mceliece6960119_cmac|7109881|100442747|
|mceliece6960119_kmac256|7111164|100448569|
|mceliece8192128_poly1305|8889311|126763141|
|mceliece8192128_gmac|8882271|126819924|
|mceliece8192128_cmac|8882345|126822836|
|mceliece8192128_kmac256|8931962|128639971|
