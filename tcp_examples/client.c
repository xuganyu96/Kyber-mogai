#include "stdio.h"
#include "stdlib.h"
#include "unistd.h"
#include "sys/socket.h"
#include "netinet/in.h"

#include "arpa/inet.h"

#define PORT 8080
#define BUFFER_LEN 8192

int main(void) {
    printf("TCP Client\n");

    int stream;
    char buffer[BUFFER_LEN];
    struct sockaddr_in address;
    address.sin_family = AF_INET;
    address.sin_port = htons(PORT);

    stream = socket(AF_INET, SOCK_STREAM, 0);
    if (stream < 0) {
        fprintf(stderr, "Failed to create socket\n");
        exit(EXIT_FAILURE);
    }
    if (inet_pton(AF_INET, "127.0.0.1", &address.sin_addr) <= 0) {
        fprintf(stderr, "Invalid address\n");
        exit(EXIT_FAILURE);
    }
    if (connect(stream, (struct socketaddr *)&address, sizeof(address)) < 0) {
        fprintf(stderr, "Failed to connect\n");
        exit(EXIT_FAILURE);
    }

    // first read server hello, and send BYE
    ssize_t received = read(stream, buffer, BUFFER_LEN);
    for (ssize_t i = 0; i < received; i++) {
        printf("%c", buffer[i]);
    }
    printf("\n");
    send(stream, "BYE", 3, 0);
    while (received != 0) {
        received = read(stream, buffer, BUFFER_LEN);
    }

    close(stream);

    return 0;
}
