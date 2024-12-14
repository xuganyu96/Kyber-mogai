TODO:
- rerun speed and KEX on c7a instance

# Faster generic IND-CCA secure KEM using encrypt-then-MAC
This is the accompanying source code for the paper titled _Faster generic IND-CCA secure KEM using encrypt-then-MAC_.

# Getting started
The [`Makefile`](./Makefile) contains three main sets of compilation targets:
- `make tests` compiles and runs correctness tests. Each correctness test generates a random key pair, then check that decrypting a random encryption recovers the correct plaintext
- `make speed` compiles and runs speed tests. Each speed test measures the medium time (CPU clock or CPU cycles depending on the platform, see [speed.h](./speed.h) for specific definitions) needed to execute `TEST_ROUNDS` calls to `keygen`, `enc`, and `dec` routines.
- `make kex` compiles all key exchange binaries. Each KEM scheme has its own pair of server and client binaries (e.g. `target/kex_kyber1024_client` and `target/kex_kyber1024_server`). To run a key exchange benchmark, first run the server `./target/kex_kyber1024_server <none|server|client|all> 127.0.0.1 <port>`, then run the client `./target/kex_kyber1024_client <none|server|client|all> <servername> <port>`. I also included convenient make target `make run_kex_servers_all` and `make run_kex_clients_all server_name=<server_name>`, which will run all key exchange binaries in sequence.

```bash
# build all targets
make all test_rounds=5 speed_rounds=100000 kex_rounds=10000 -j8

# test correctness
make tests

# test speed. prehash_publickey is turned on by default but can be turned off 
# with the argument "prehash_publickey=0". keygen will only be tested for up to 
# 10 rounds
make speed > speed.log &
tail -f -n 100 speed.log

# test key exchange
make run_kex_servers_all > kex_server.log &
make run_kex_clients_all server_name=127.0.0.1 > kex_client.log &
tail -f -n 100 kex_client.log

# clean up
```

# Performance analysis on Apple Silicon M1
The preliminary performanc results were run on Apple Silicon M1. The C compiler is:

```
Apple clang version 15.0.0 (clang-1500.3.9.4)
Target: arm64-apple-darwin24.1.0
Thread model: posix
InstalledDir: /Library/Developer/CommandLineTools/usr/bin
```

OpenSSL version is 

```
OpenSSL 3.3.2 3 Sep 2024 (Library: OpenSSL 3.3.2 3 Sep 2024)
```

## PKE subroutines
Each subroutine is tested 10,000 times, with the medium reporte in the table. Time is measured using `mach_absolute_time()` as provided by `<mach/mach_time.h>`.

|name|keygen|enc|dec|note|
|:---|---:|---:|---:|:---|
|kyber512|584|465|139|
|kyber768|613|751|178|
|kyber1024|997|1182|231|
|mceliece348864|949171|127|1974|
|mceliece348864f|694287|142|1990|keygen is 26.85% faster|
|mceliece460896|2772434|278|8655|
|mceliece460896f|2183114|282|8716|keygen 21.26% faster|
|mceliece6688128|6158500|492|6361|
|mceliece6688128f|4359122|492|6407|keygen 29.22% faster|
|mceliece6960119|5296469|392|6148|
|mceliece6960119f|3885351|392|6147|keygen 26.64% faster|
|mceliece8192128|6426728|631|6398|
|mceliece8192128f|4240965|630|6401|keygen 34.01% faster|

Nothing too crazy here. It is interesting to see how the f-variants of classic McEliece reduces key generation time by some 20-30 percent.

## Vanilla KEMS
Each subroutine is tested 10,000 times with medium reported in this table. Time is measured using `mach_absolute_time()`.

|name|keygen|enc|dec|note|
|:---|---:|---:|---:|:---|
|kyber512|468|535|684|
|kyber768|798|851|1061|
|kyber1024|1245|1267|1549|
|mceliece348864|936710|215|2471|
|mceliece348864f|702175|257|2465|keygen -25.04%|
|mceliece460896|2515801|487|6694|
|mceliece460896f|2172231|459|6695|keygen -13.66%|
|mceliece6688128|4653916|816|7500|
|mceliece6688128f|4208891|774|7507|keygen -9.58%|
|mceliece6960119|5699161|699|7262|
|mceliece6960119f|3881215|699|7249|keygen -31.90%|
|mceliece8192128|5822820|858|7464|
|mceliece8192128f|4229676|858|7461|keygen -27.36%|

With Kyber we used the reference implementation (not the avx2 version since Apple Silicon does not support AVX2 instruction set). With classic McEliece we used the portable `vec` version, which is significantly faster than the `ref` implementation, but does not use avx2.

## Encrypt-then-MAC KEMs
**Kyber512**
|name|keygen|enc|dec|note|
|:---|---:|---:|---:|:---|
|kyber512|468|535|684|
|kyber512poly1305|511|570 (+6.54%)|206 (-69.88%)|
|kyber512gmac|506|583 (+8.97%)|223 (-67.4%)|
|kyber512cmac|506|598 (+11.78%)|241 (-64.77%)|
|kyber512kmac256|512|604 (+12.9%)|245 (-64.18%)|

**Kyber768**
|name|keygen|enc|dec|note|
|:---|---:|---:|---:|:---|
|kyber768|798|851|1061|
|kyber768cmac|829|910 (+6.93%)|305 (-71.25%)|
|kyber768gmac|828|878 (+3.17%)|277 (-73.89%)|
|kyber768kmac256|831|915 (+7.52%)|312 (-70.59%)|
|kyber768poly1305|837|859 (+0.94%)|259 (-75.59%)|

**Kyber1024**
|name|keygen|enc|dec|note|
|:---|---:|---:|---:|:---|
|kyber1024|1245|1267|1549|
|kyber1024poly1305|1264|1245 (-1.74%)|328 (-78.83%)|
|kyber1024gmac|1265|1274 (+0.55%)|347 (-77.60%)|
|kyber1024cmac|1270|1313 (+3.63%)|381 (-75.40%)|
|kyber1024kmac256|1276|1318 (+4.03%)|389 (-74.89%)|

**McEliece348864**
|name|keygen|enc|dec|note|
|:---|---:|---:|---:|:---|
|mceliece348864|936710|215|2471|
|mceliece348864poly1305|837257|316 (+46.98%)|2074 (-16.07%)|
|mceliece348864gmac|891205|335 (+55.81%)|2087 (-15.54%)|
|mceliece348864cmac|1003395|340 (+58.14%)|2092 (-15.34%)|
|mceliece348864kmac256|1253559|304 (+41.4%)|2093 (-15.30%)|

**McEliece348864f**
|name|keygen|enc|dec|note|
|:---|---:|---:|---:|:---|
|mceliece348864f|702175|257|2465|
|mceliece348864fpoly1305|713703|276 (+7.39%)|2075 (15.82%)|
|mceliece348864fgmac|706901|294 (14.40%)|2126 (13.79%)|
|mceliece348864fcmac|706250|303 (+17.90%)|2101 (14.77%)|
|mceliece348864fkmac256|705897|304 (+18.29%)|2090 (15.21%)|

**McEliece460896**
|name|keygen|enc|dec|note|
|:---|---:|---:|---:|:---|
|mceliece460896|2515801|487|6694|
|mceliece460896poly1305|3544247 (+40.88%)|514 (+5.54%)|5784 (-13.59%)|
|mceliece460896gmac|3331190 (+32.41%)|565 (+16.02%)|5809 (-13.22%)|
|mceliece460896cmac|3065937 (+21.87%)|544 (+11.70%)|5905 (-11.79%)|
|mceliece460896kmac256|2847616 (+13.19%)|570 (+17.04%)|5760 (-13.95%)|

**McEliece460896f**
|name|keygen|enc|dec|note|
|:---|---:|---:|---:|:---|
|mceliece460896f|2172231|459|6695|
|mceliece460896fpoly1305|2190784 (+0.85%)|538 (+17.21%)|5784 (-13.61%)|
|mceliece460896fgmac|2191735 (+0.90%)|536 (+16.78%)|5711 (-14.70%)|
|mceliece460896fcmac|2189278 (+0.78%)|543 (+18.30%)|5818 (-13.10%)|
|mceliece460896fkmac256|2193191 (+0.96%)|545 (+18.74%)|5768 (-13.85%)|

**McEliece6688128**
|name|keygen|enc|dec|note|
|:---|---:|---:|---:|:---|
|mceliece6688128|4653916|816|7500|
|mceliece6688128poly1305|6686271 (+43.67%)|889 (+8.95%)|6509 (-13.21%)|
|mceliece6688128gmac|4746145 (+1.98%)|890 (+9.07%)|6521 (-13.05%)|
|mceliece6688128cmac|4133297 (-11.19%)|900 (+10.29%)|6540 (-12.80%)|
|mceliece6688128kmac256|6124269 (+31.59%)|901 (+10.42%)|6546 (-12.72%)|

**McEliece6688128f**
|name|keygen|enc|dec|note|
|:---|---:|---:|---:|:---|
|mceliece6688128f|4208891|774|7507|
|mceliece6688128fpoly1305|4275599 (+1.58%)|868 (+12.14%)|6511 (-13.27%)|
|mceliece6688128fgmac|4257076 (+1.14%)|890 (+14.99%)|6525 (-13.08%)|
|mceliece6688128fcmac|4269156 (+1.43%)|898 (+16.02%)|6544 (-12.83%)|
|mceliece6688128fkmac256|4277949 (+1.64%)|872 (+12.66%)|6546 (-12.80%)|

**McEliece6960119**
|name|keygen|enc|dec|note|
|:---|---:|---:|---:|:---|
|mceliece6960119|5699161|699|7262|
|mceliece6960119poly1305|4533305 (-20.46%)|735 (+5.15%)|6389 (-12.02%)|
|mceliece6960119gmac|5724027 (+0.44%)|753 (+7.73%)|6450 (-11.18%)|
|mceliece6960119cmac|6122335 (+7.43%)|763 (+9.16%)|6428 (-11.48%)|
|mceliece6960119kmac256|4588406 (-19.49%)|765 (+9.44%)|6303 (-13.21%)|

**McEliece6960119f**
|name|keygen|enc|dec|note|
|:---|---:|---:|---:|:---|
|mceliece6960119f|3881215|699|7249|
|mceliece6960119fcmac|3924842 (+1.12%)|762 (+9.01%)|6423 (-11.39%)|
|mceliece6960119fgmac|3928747 (+1.22%)|752 (+7.58%)|6442 (-11.13%)|
|mceliece6960119fkmac256|3974546 (+2.40%)|755 (+8.01%)|6298 (-13.12%)|
|mceliece6960119fpoly1305|3972592 (+2.35%)|728 (+4.15%)|6384 (-11.93%)|

**McEliece8192128**
|name|keygen|enc|dec|note|
|:---|---:|---:|---:|:---|
|mceliece8192128|5822820|858|7464|
|mceliece8192128cmac|4651358 (-20.12%)|955 (+11.31%)|6547 (-12.29%)|
|mceliece8192128fcmac|4260442 (-26.83%)|957 (+11.54%)|6550 (-12.25%)|
|mceliece8192128fgmac|4261110 (-26.82%)|945 (+10.14%)|6546 (-12.30%)|
|mceliece8192128fkmac256|4265588 (-26.74%)|957 (+11.54%)|6574 (-11.92%)|

**McEliece8192128f**
|name|keygen|enc|dec|note|
|:---|---:|---:|---:|:---|
|mceliece8192128f|4229676|858|7461|
|mceliece8192128fpoly1305|4282896 (+1.26%)|924 (+7.69%)|6518 (-12.64%)|
|mceliece8192128gmac|4634300 (+9.57%)|945 (+10.14%)|6543 (-12.30%)|
|mceliece8192128kmac256|6256017 (+47.91%)|957 (+11.54%)|6571 (-11.93%)|
|mceliece8192128poly1305|6354288 (+50.23%)|925 (+7.81%)|6517 (-12.65%)|

## key exchange
Using loopback (client and server are the same machine). Time is measured in microseconds. Each test contains 100 key exchanges with medium reported.

**kyber512**
|name|no auth|server auth|mutual auth|
|:---|---:|---:|---:|
|kyber512|140|354|446|
|kyber512poly1305|169|282|325|
|kyber512gmac|230|299|333|
|kyber512cmac|146|275|345|
|kyber512kmac256|245|299|345|

**kyber768**
|name|no auth|server auth|mutual auth|
|:---|---:|---:|---:|
|kyber768|224|481|574|
|kyber768poly1305|174|378|457|
|kyber768gmac|288|380|465|
|kyber768cmac|287|365|471|
|kyber768kmac256|285|331|466|

**kyber1024**
|name|no auth|server auth|mutual auth|
|:---|---:|---:|---:|
|kyber1024|463|592|692|
|kyber1024poly1305|357|459|546|
|kyber1024gmac|371|456|551|
|kyber1024cmac|357|465|558|
|kyber1024kmac256|244|465|572|

**mceliece348864**
|name|no auth|server auth|mutual auth|
|:---|---:|---:|---:|
|mceliece348864-f|29588|29700|29793|
|mceliece348864-fpoly1305|29710|29838|29930|
|mceliece348864-fgmac|29800|29866|29961|
|mceliece348864-fcmac|30026|30154|30247|
|mceliece348864-fkmac256|29718|29858|30022|

**mceliece348864**
|name|no auth|server auth|mutual auth|
|:---|---:|---:|---:|
|mceliece348864|39092|34508|34524|
|mceliece348864poly1305|34666|37395|35005|
|mceliece348864gmac|39481|34947|39665|
|mceliece348864cmac|39460|34761|37558|
|mceliece348864kmac256|39480|39663|35111|

**mceliece460896**
|name|no auth|server auth|mutual auth|
|:---|---:|---:|---:|
|mceliece460896-f|90941|91114|91590|
|mceliece460896-fpoly1305|91931|92149|92491|
|mceliece460896-fgmac|92729|92910|93237|
|mceliece460896-fcmac|91901|92243|92529|
|mceliece460896-fkmac256|92691|93088|93549|

**mceliece460896**
|name|no auth|server auth|mutual auth|
|:---|---:|---:|---:|
|mceliece460896|135642|115369|115832|
|mceliece460896poly1305|136326|136515|136844|
|mceliece460896gmac|137044|137280|117084|
|mceliece460896cmac|136071|115890|126628|
|mceliece460896kmac256|121795|117098|138097|

**mceliece6688128**
|name|no auth|server auth|mutual auth|
|:---|---:|---:|---:|
|mceliece6688128-f|176072|176194|176817|
|mceliece6688128-fpoly1305|179162|179115|180292|
|mceliece6688128-fgmac|178287|178207|178625|
|mceliece6688128-fcmac|177863|178460|178778|
|mceliece6688128-fkmac256|177707|179134|178628|

**mceliece6688128**
|name|no auth|server auth|mutual auth|
|:---|---:|---:|---:|
|mceliece6688128|257336|221720|236211|
|mceliece6688128poly1305|214201|259524|258734|
|mceliece6688128gmac|258132|216964|262129|
|mceliece6688128cmac|220741|262033|259729|
|mceliece6688128kmac256|218177|262194|216469|

**mceliece6960119**
|name|no auth|server auth|mutual auth|
|:---|---:|---:|---:|
|mceliece6960119-f|180112|184180|181462|
|mceliece6960119-fpoly1305|164344|164706|168346|
|mceliece6960119-fgmac|165403|164630|165687|
|mceliece6960119-fcmac|164854|165821|166443|
|mceliece6960119-fkmac256|163972|164687|164968|

**mceliece6960119**
|name|no auth|server auth|mutual auth|
|:---|---:|---:|---:|
|mceliece6960119|221469|189003|222095|
|mceliece6960119poly1305|224704|191594|191617|
|mceliece6960119gmac|190366|190637|224455|
|mceliece6960119cmac|222879|192720|223511|
|mceliece6960119kmac256|189726|208243|208697|

**mceliece8192128**
|name|no auth|server auth|mutual auth|
|:---|---:|---:|---:|
|mceliece8192128-f|176080|176269|177184|
|mceliece8192128-fpoly1305|178399|178746|178978|
|mceliece8192128-fgmac|178542|178614|178940|
|mceliece8192128-fcmac|178049|178564|179542|
|mceliece8192128-fkmac256|178460|178892|179345|

**mceliece8192128**
|name|no auth|server auth|mutual auth|
|:---|---:|---:|---:|
|mceliece8192128|228811|275103|274117|
|mceliece8192128poly1305|237724|287002|287434|
|mceliece8192128gmac|265563|266039|266559|
|mceliece8192128cmac|248205|266556|229462|
|mceliece8192128kmac256|284094|236581|285081|