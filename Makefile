CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = ejercicio13

all: $(TARGET)

$(TARGET): ejercicio13.o
	$(CC) $(CFLAGS) $^ -o $@

hola.o: ejercicio13.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)
	
.PHONY: all clean

