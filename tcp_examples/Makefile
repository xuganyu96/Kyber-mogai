.PHONY: clean run_server run_client


run_server: server
	./server

run_client: client
	./client

server: server.c 
	$(CC) server.c -o $@

client: client.c
	$(CC) client.c -o $@

clean:
	$(RM) server
	$(RM) client
