# Kyber-mogai

## Naked Key Exchange
Here naked key exchange means that the key exchange happens outside any bigger protocols; this is in contrast with a key exchange performed within a protocol, such as TLS 1.3.

We are interested in three categories of key exchange:

**Unauthenticated key exchange (KEX)**:
- client generates ephemeral keypair `pk, sk`
- client sends public key `pk`
- server encapsulates `ss, ct` and transmits encapsulation `ct`
- client decapsulates `ss <- decap(sk, ct)`

```bash
# Start server first
make run_kex_server512
# Start client
make run_kex_client512
# Verify that the session keys are identical
```

- **Unilterally authenticated key exchange (UAKEX)**:
    - client has server's long-term public key `pk_server`
    - client generates ephemeral keypair `pk_ephemeral`
    - client runs encaps with server's public key `(ct_server, K_auth) <- encap(pk_server)`
    - client transmits ephemeral public key and encapsulation `(ct_server, pk_ephemeral)`
    - server decapsulates `K_auth <- decap(ct_server)` and encapsulate `(ct_ephemeral, K_ephemeral) <- encaps(pk_ephemeral)`
    - server computes session key `K <- SHA3-256(K_auth, K_ephemeral)`
    - server transmits `ct_ephemeral`
    - client decapsulates `K_ephemeral <- decap(ct_ephemeral)`
    - client computes session key `K <- SHA3-256(K_auth, K_ephemeral)`
- **Mutually authenticated key exchange (AKEX)**:
    - client has server's long-term public key `pk_server`
    - client generates ephemeral public key `(pk_e, sk_e)`
    - client encapsulates `(ct_server, K_server) <- encap(pk_server)`
    - client transmits `(pk_e, ct_server)`
    - server has client's long-term public key `pk_client`
    - server encapsulates `(ct_client, K_client) <- encap(pk_client)`
    - server encapsulates `(ct_e, K_e) <- encap(pk_e)`
    - server decapsulates `K_server <- decap(ct_server)`
    - server computes `K <- SHA3-256(K_e, K_client, K_server)`
    - server transmits `(ct_client, ct_e)`
    - client decapsulates `K_client <- decap(ct_client)`
    - client decapsulates `K_e <- decap(ct_e)`
    - client computes `K <- SHA3-256(K, K_server, K_client)`

## Configuring build environment with OpenSSL
Export environment variables `CFLAGS` and `LDFLAGS` so that the compiler can find OpenSSL.
```bash
export OPENSSLDIR="/path/to/openssl"
export CFLAGS="-I${OPENSSL_PATH}/include"
export LDFLAGS="-L${OPENSSL_PATH}/lib"
```

Include `$(CFLAGS)` and `$(LDFLAGS)` so that the environment variables are reflected into the compiler command
```makefile
$(CC) ... $(CFLAGS) $(LDFLAGS) -lcrypto ...
```

The dev environment uses OpenSSL 3.3.1. This project is NOT compatible with OpenSSL 1.1

## Configuring language server
Configure the following stuff in `.clangd`

```yaml
CompileFlags:
  Add: [
    "-I/opt/homebrew/Cellar/openssl@3/3.3.1/include", 
    "-D__arm64__",
    "-Wall", 
    "-Wextra", 
    "-Wpedantic", 
    "-Wmissing-prototypes", 
    "-Wredundant-decls", 
    "-Wshadow", 
    "-Wpointer-arith", 
    "-O3", 
    "-fomit-frame-pointer",
  ]
```
