CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = ejercicio7

all: $(TARGET)

$(TARGET): ejercicio7.o
	$(CC) $(CFLAGS) $^ -o $@

hola.o: ejercicio7.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)
	
.PHONY: all clean

