kilo.so: kilo.c
	$(CC) -fPIC -shared  kilo.c -o kilo.so -Wall -Wextra -pedantic -std=c99

clean:
	rm kilo.so
