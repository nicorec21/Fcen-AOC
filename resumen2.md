## ✅ Pasos realizados

### 1. Segmentación Flat - GDT
> Se configura una tabla GDT con segmentos planos, es decir, todos con base 0x0 y límite grande (4GB), permitiendo direccionamiento lineal simple.

- Se definieron los siguientes descriptores:
  - `GDT_IDX_CODE_0`: Código ring 0, base 0x0, límite 4GB, permisos execute/read.
  - `GDT_IDX_DATA_0`: Datos ring 0, base 0x0, límite 4GB, permisos read/write.
  - `GDT_IDX_VIDEO`: Acceso a video, base 0xB8000, límite 4KB, granularidad activada.

```c
#define GDT_CODE_0_SEL (1 << 3) | 0x0   // 0x08
#define GDT_DATA_0_SEL (3 << 3) | 0x0   // 0x18
#define GDT_VIDEO_SEL  (5 << 3) | 0x0   // 0x28
```

---

### 2. Inicialización en `kernel.asm`
> Se desactiva modo real, se configura el entorno, y se pasa a modo protegido.

- Deshabilitamos interrupciones con `cli`.
- Cambiamos modo de video a 80x50 usando `int 10h`.
- Mostramos mensaje en modo real con `print_text_rm`.
- Habilitamos línea A20 para poder usar direcciones por encima del 1MB.
- Cargamos la GDT con `lgdt [GDT_DESC]`.
- Activamos modo protegido modificando `CR0`:

```asm
mov eax, cr0
or eax, 1
mov cr0, eax
jmp CS_RING_0_SEL:modo_protegido
```

---

### 3. Código en modo protegido (`modo_protegido:`)
> Ya en modo protegido, se ajustan registros de segmento, pila, se imprime un mensaje y se llama código en C.

- Se cargan registros de segmento: `ds`, `es`, `fs`, `gs`, `ss` con `DS_RING_0_SEL`.
- Se inicializa la pila:

```asm
mov esp, 0x25000
mov ebp, esp
```

- Se imprime el mensaje "Iniciando kernel en Modo Protegido" centrado con `print_text_pm`.
- Se inserta `xchg bx, bx` como breakpoint visible para GDB.
- Se llama a la función `screen_draw_layout` escrita en C.

---

### 4. Dibujo en pantalla desde C

> Se usa acceso directo a memoria de video para manipular caracteres en pantalla.

- La estructura usada es:

```c
typedef struct ca {
  uint8_t c;  // carácter
  uint8_t a;  // atributo (color)
} ca;
```

- La pantalla se accede como una matriz `ca[ROWS][COLS]` donde `ca(*p)[80] = (ca(*)[80])0xB8000`.

- Se implementó la función `screen_draw_box` que permite escribir rectángulos de caracteres en pantalla.

- Se creó `screen_draw_layout` que:
  - Limpia la pantalla (`' '` con color claro).
  - Escribe un mensaje en el centro.
  - Dibuja un marco usando ASCII extendido.

```c
void screen_draw_layout(void) {
  screen_draw_box(0, 0, ROWS, COLS, ' ', 0x07);  // limpiar pantalla
  char* msg = "NICO Y EL KERNEL 🧠";
  int len = 17;
  int fila = ROWS / 2;
  int col = (COLS - len) / 2;
  ca(*p)[COLS] = (ca(*)[COLS])0xB8000;
  for (int i = 0; i < len; i++) {
    p[fila][col + i].c = msg[i];
    p[fila][col + i].a = 0x4F;
  }
  screen_draw_box(0, 0, ROWS, COLS, 178, 0x0A);  // borde decorativo
}
```
[text](https://docs.google.com/document/d/1j2fV9WGEdfMBcaU-gSZxLqo0OzWDIQ05SVzd28CebZM/edit?tab=t.0)