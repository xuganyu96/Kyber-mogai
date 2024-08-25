#include "../authenticators.h"
#include <stdint.h>

static int test_poly1305_wrapper(void) {
    uint8_t key[MAC_KEY_BYTES];
    for(size_t i = 0; i < sizeof(key); i++) {
        key[i] = 0;
    }

    uint8_t tag[MAC_TAG_BYTES];
    for(size_t i = 0; i < sizeof(tag); i++) {
        tag[i] = 0xFF;
    }

    unsigned char msg[] = "Hello, world!";

    mac_poly1305(key, msg, sizeof(msg), tag);

    for(size_t i = 0; i < sizeof(tag); i++) {
        if(tag[i] != 0) {
            return 1;
        }
    }
    return 0;
}


int main(void) {
    int r = 0;

    r |= test_poly1305_wrapper();

    if (r) {
        return 1;
    }

    printf("Ok\n");
    return 0;

}
