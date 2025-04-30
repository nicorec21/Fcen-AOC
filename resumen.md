# 📦 ABI System V AMD64 – Resumen para Parcial

## 📌 Parámetros por registro (enteros/punteros)

| Orden | Registro | Descripción                      |
|-------|----------|----------------------------------|
| 1     | rdi      | Primer parámetro                 |
| 2     | rsi      | Segundo parámetro                |
| 3     | rdx      | Tercer parámetro                 |
| 4     | rcx      | Cuarto parámetro                 |
| 5     | r8       | Quinto parámetro                 |
| 6     | r9       | Sexto parámetro                  |
| 7+    | stack    | Por la pila (`[rbp + offset]`)   |

---

## 🧐 Valores de retorno

| Tipo de dato      | Registro de retorno |
|-------------------|---------------------|
| bool / int8       | al                  |
| int32 / uint32    | eax                 |
| int64 / pointer   | rax                 |

---

## 📂 Registros: preservación (caller vs callee save)

### Caller-save (se pueden pisar con `call`):

- `rax`, `rcx`, `rdx`, `rsi`, `rdi`, `r8`, `r9`, `r10`, `r11`

### Callee-save (si los usás, tenés que preservarlos):

- `rbx`, `rbp`, `r12`, `r13`, `r14`, `r15`

---

## 🖐️ Subregistros por tamaño

| Registro base | 64 bits | 32 bits | 16 bits | 8 bits bajo |
|---------------|---------|---------|---------|-------------|
| rax           | rax     | eax     | ax      | al          |
| rbx           | rbx     | ebx     | bx      | bl          |
| rcx           | rcx     | ecx     | cx      | cl          |
| rdx           | rdx     | edx     | dx      | dl          |
| rsi           | rsi     | esi     | si      | sil         |
| rdi           | rdi     | edi     | di      | dil         |
| r8            | r8      | r8d     | r8w     | r8b         |
| r9            | r9      | r9d     | r9w     | r9b         |
| r10           | r10     | r10d    | r10w    | r10b        |
| r11           | r11     | r11d    | r11w    | r11b        |
| r12           | r12     | r12d    | r12w    | r12b        |
| r13           | r13     | r13d    | r13w    | r13b        |
| r14           | r14     | r14d    | r14w    | r14b        |
| r15           | r15     | r15d    | r15w    | r15b        |

---

## 🛠️ Operaciones úTiles frecuentes en ASM

### Acceder a un índice de array:
```asm
movzx rax, word [rsi + rdx*2]    ; acceder a indice[i] de uint16_t*
mov rbx, [rdi + rax*8]           ; acceder a inventario[indice[i]] de item_t**
```

### Copiar un puntero a resultado:
```asm
mov [r14 + r13*8], rbx           ; resultado[i] = inventario[indice[i]]
```

### Copiar una estructura de 28 bytes (ej: item_t):
```asm
mov rax, [rsi]       ; 8 bytes
mov [rdi], rax
mov rax, [rsi+8]     ; siguiente 8
mov [rdi+8], rax
mov rax, [rsi+16]    ; siguiente 8
mov [rdi+16], rax
mov ax, [rsi+24]     ; últimos 2 bytes
mov [rdi+24], ax
```

### Comparar resultado booleano:
```asm
call rcx
; valor devuelto está en al

; chequear si es falso
test al, al
jz .no_ordenado
```

### Multiplicar por potencias de 2
```asm
shl rax, 1 ; x2
shl rax, 2 ; x4
shl rax, 3 ; x8
shl rax, 4 ; x16
```

---

## 📊 Convención de pila (stack frame)

```
| argumento 7+       | <- rsp al entrar (si hay más de 6 args)
| ------------------|
| return address     |
| rbp (viejo)        | <- rbp (marco de pila)
| variables locales  |
| registros guardados|
```



> Hecho por Nico con ayuda de ChatGPT 😎

