# Faster generic IND-CCA secure KEM using encrypt-then-MAC
This is the accompanying source code for the paper titled _Faster generic IND-CCA secure KEM using encrypt-then-MAC_.

- [ ] Start filling `pke.c` with a single ML-KEM implementation.
- [ ] Change `etmkem.c` to implement using `pke.h`


# Abstraction
`pke.h` and `authenticators.h` provides abstraction over the underlying PKE and MAC implementation by defining a common set of API that all PKE/MAC can use.

`pke.c` and `authenticators.c` will contain concrete instantiations. The choice of instantiation will be controlled using macros. For example

```c
// authenticators.c
#ifdef MAC_POLY1305
void mac_sign(uint8_t *digest, const uint8_t *key, size_t keylen, const uint8_t *msg, size_t msglen) {
    poly1305_sign(digest, key, msg, msglen);
}
#endif
```
