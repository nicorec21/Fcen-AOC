CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = ejercicio9

all: $(TARGET)

$(TARGET): ejercicio9.o
	$(CC) $(CFLAGS) $^ -o $@

hola.o: ejercicio9.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)
	
.PHONY: all clean

