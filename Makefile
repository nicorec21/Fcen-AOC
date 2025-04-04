CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = ejercicio11

all: $(TARGET)

$(TARGET): ejercicio11.o
	$(CC) $(CFLAGS) $^ -o $@

hola.o: ejercicio11.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)
	
.PHONY: all clean

