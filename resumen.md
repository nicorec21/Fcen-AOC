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

## 🧠 Valores de retorno

| Tipo de dato      | Registro de retorno |
|-------------------|---------------------|
| bool / int8       | al                  |
| int32 / uint32    | eax                 |
| int64 / pointer   | rax                 |

---

## 💾 Registros: preservación (caller vs callee save)

### Caller-save (⚠️ se pueden pisar con `call`):

- `rax`, `rcx`, `rdx`, `rsi`, `rdi`, `r8`, `r9`, `r10`, `r11`

### Callee-save (✅ si los usás, tenés que preservarlos):

- `rbx`, `rbp`, `r12`, `r13`, `r14`, `r15`

---

## 📐 Subregistros por tamaño

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

## 🛠️ Operaciones útiles

- **Extender `uint16_t` a 64 bits**:  
  ```nasm
  movzx rax, word [rsi + rdx*2]
