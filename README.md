# Faster generic IND-CCA secure KEM using encrypt-then-MAC
This is the accompanying source code for the paper titled _Faster generic IND-CCA secure KEM using encrypt-then-MAC_.

- [ ] Kyber's security level is controlled by the macro `KYBER_K`: Kyber512 sets `KYBER_K=2`, KYBER768 sets `KYBER_K=3`, Kyber1024 sets `KYBER_K=4`
- [ ] I want to prevent a multiplicative blowup of code complexity: I expect many sets of distinct IND-CPA PKE and at least 4 MAC (Poly1305, GMAC, CMAC, KMAC) but possible more (PMAC, EliMAC), which means I will have dozens of build target; I do not want identical code repeated dozens of times. `etm.c` needs to abstract over parameters of the input IND-CPA subroutines and MAC.
