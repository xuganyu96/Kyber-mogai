/**
 * a simple example of setting up a TCP listener.
 *
 * to test this binary, use netcat:
 * $ nc 127.0.0.1 8888
 * the server should send a single hello, then hang up
 */
#include "stdio.h"
#include "stdlib.h"
#include "unistd.h"
#include "sys/socket.h"
#include "netinet/in.h"
#include <string.h>
#include "arpa/inet.h"

#define BUFFER_LEN 1 << 12
#define PORT 8080
#define CLIENT_BYE "BYE"
#define CLIENT_BYE_LEN 3

int main(void) {
    int server_fd, stream;
    struct sockaddr_in address;
    size_t addr_len = sizeof(address);
    char buffer[BUFFER_LEN] = {0};
    unsigned char hello[] = "Echo: type BYE to exit\n";

    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (!server_fd) {
        fprintf(stderr, "Failed to create socket\n");
        exit(EXIT_FAILURE);
    }

    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);

    if (bind(server_fd, (struct socketaddr *)&address, addr_len) < 0) {
        fprintf(stderr, "Failed to bind socket to port %d\n", PORT);
        close(server_fd);
        exit(EXIT_FAILURE);
    }

    if (listen(server_fd, 3) < 0) {
        fprintf(stderr, "Failed to listen\n");
        close(server_fd);
        exit(EXIT_FAILURE);
    }
    printf("Listening on port %d\n", PORT);

    stream = accept(server_fd, (struct socketaddr *)&address, (socklen_t *)&addr_len);
    if (stream < 0) {
        fprintf(stderr, "Failed to accept connection\n");
        close(server_fd);
        exit(EXIT_FAILURE);
    }
    // get and display peer's address
    struct sockaddr_in peer_addr;
    size_t peer_addr_len = sizeof(peer_addr);
    char peer_addr_str[INET_ADDRSTRLEN];
    getpeername(stream, (struct socketaddr *)&peer_addr, (socklen_t *)&peer_addr_len);
    inet_ntop(AF_INET, &(peer_addr.sin_addr), peer_addr_str, INET_ADDRSTRLEN);
    int peer_port = ntohs(peer_addr.sin_port);
    printf("Connected to %s:%d\n", peer_addr_str, peer_port);

    send(stream, hello, sizeof(hello), 0);

    int hangup = 0;
    ssize_t received;
    while (!hangup) {
        received = read(stream, buffer, BUFFER_LEN);
        if (strncmp(buffer, CLIENT_BYE, CLIENT_BYE_LEN) == 0) {
            fprintf(stderr, "Client said bye\n");
            hangup = 1;
        } else {
            send(stream, buffer, received, 0);
        }
    }

    close(server_fd);
    close(stream);

    return 0;
}
