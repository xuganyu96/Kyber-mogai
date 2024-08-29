/**
 * Unauthenticated key exchange routines
 */
#include "authenticators.h"
#include "kyber/ref/params.h"
#include <stdio.h>

int server_handle_stream(int stream);
int client_handle_stream(int stream);
