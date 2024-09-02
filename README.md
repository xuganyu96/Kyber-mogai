# Kyber-mogai

# Key exchange
I want to have a single handler for all three types of key exchanges: unauthenticated, unilaterally authenticated, and mutually authenticated.

```c
int server_handle(int stream, uint8_t *sk_server, size_t sk_server_len, uint8_t *pk_client, size_t pk_client_len);
int client_handle(int stream, uint8_t *sk_client, size_t sk_client_len, uint8_t *pk_server, size_t pk_server_len);
```

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
