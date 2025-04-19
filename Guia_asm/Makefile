AS := nasm
ASFLAGS := -f elf64 -F DWARF -g -Wall
LD := ld
LDFLAGS := -g

# Obtener base del archivo sin extensión
FILE ?= HolaMundo.asm
BASENAME := $(basename $(FILE))
TARGET := $(BASENAME)

.PHONY: all clean run

all: $(TARGET)

$(BASENAME).o: $(FILE)
	$(AS) $(ASFLAGS) $< -o $@

$(TARGET): $(BASENAME).o
	$(LD) $(LDFLAGS) $< -o $@

run: all
	./$(TARGET)

clean:
	rm -rf *.o $(TARGET)

#make FILE=ej1.asm
#make FILE=ej1.asm run
#make clean
