CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = ejercicio3

all: $(TARGET)

$(TARGET): ejercicio3.o
	$(CC) $(CFLAGS) $^ -o $@

hola.o: ejercicio3.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)
	
.PHONY: all clean

