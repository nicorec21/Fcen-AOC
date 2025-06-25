## Resumen Teórico: Modo Protegido - System Programming FCEN

### Conceptos Fundamentales

#### ¿Qué es el Modo Protegido?

Es un modo de operación introducido por el 80286 que habilita:

* Acceso a más de 1MB de memoria.
* Segmentación avanzada con protección por privilegios.
* Paginación (a partir del 80386) para traducción de direcciones lógicas a físicas.
* Multitarea, control de acceso y aislamiento entre procesos.

#### Proceso de Arranque (boot)

1. **Modo Real**: CPU inicia en 16 bits en CS\:IP=F000\:FFF0 (0xFFFF0).
2. **Habilitar A20**: para acceder más allá del primer MB.
3. **Cargar GDT**: tabla de descriptores globales con LGDT.
4. **Setear PE=1 en CR0**: habilita el modo protegido.
5. **Far jump**: transición al nuevo selector de código en modo protegido.

#### GDT (Global Descriptor Table)

Contiene descriptores de segmento:

* Segmento nulo (GDT\[0])
* Código y datos kernel (GDT\[1] y GDT\[3])
* Código y datos usuario (GDT\[2] y GDT\[4])
* Segmento de video (GDT\[5])

Cada entrada define:

* base, limit, type, dpl, db, g, etc.

#### Direcciones

* **Lógica** = selector\:offset (ej: CS\:IP)
* **Lineal** = resultado de la segmentación (base + offset)
* **Física** = resultado de pasar la lineal por la paginación

#### Activación de Paginación

1. Armar directorio de páginas (Page Directory) y tablas (Page Tables).
2. Cargar CR3 con la dirección del directorio.
3. Setear PG (bit 31) en CR0.

### Posibles Preguntas de Parcial

**1. ¿Por qué el procesador arranca en modo real?**
Por compatibilidad con el 8086; la dirección de arranque es 0xFFFF0.

**2. ¿Cuál es el propósito de habilitar la línea A20?**
Permitir acceso a memoria más allá del primer MB.

**3. ¿Cómo se habilita el modo protegido?**
Cargando la GDT y seteando el bit PE de CR0, luego haciendo un far jump.

**4. ¿Qué hace la instrucción LGDT?**
Carga el registro GDTR con el puntero a la tabla GDT.

**5. ¿Cuál es la diferencia entre dirección lógica, lineal y física?**

* Lógica: selector + offset
* Lineal: base(selector) + offset
* Física: lineal transformada por la MMU (si hay paginación)

**6. ¿Para qué se usa la GDT?**
Para definir segmentos de memoria con atributos (código/datos, nivel de privilegio, tamaño, etc).

**7. ¿Por qué es importante tener diferentes niveles de privilegio (ring 0 vs ring 3)?**
Para aislar el sistema operativo del código de usuario y evitar errores/crashes.

**8. ¿Qué rol cumple el bit PG de CR0?**
Habilita la unidad de paginación (traducción de direcciones lineales a físicas).

**9. ¿Qué pasa si se omite el far jump tras setear PE?**
La CPU se comportará de forma impredecible, porque el selector de CS no apunta a un descriptor válido para modo protegido.

### Recursos del TP

* `gdt.c` y `gdt.h`: inicialización de la GDT
* `kernel.asm`: muestra la transición de modo real a protegido
* `defines.h`: constantes como `FLAT_SEGM_SIZE` y selectores

---

Este resumen cubre el contenido de los PDF `T06_A_BareMetalProgramming.pdf` y `T06_B_mem.pdf` para las preguntas teóricas relacionadas al modo protegido en System Programming.



# Resumen Teórico: Interrupciones en IA-32

Este resumen incluye los conceptos más relevantes para las preguntas teóricas del parcial, basados en la clase teórica T07 sobre interrupciones.

---

## 1. Fuentes de Interrupción

* **Hardware**:

  * Provienen de dispositivos (ej: teclado, reloj).
  * Son **asíncronas** y **no determinísticas**.
  * Entran por el pin **INTR** o **NMI** (No enmascarable, tipo 2).

* **Software**:

  * Generadas con la instrucción `INT n`.
  * **Determinísticas**.

* **Internas (Excepciones)**:

  * Generadas por la CPU al ejecutar una instrucción errónea.
  * Ej: división por cero, page fault, violación de protección.

---

## 2. Identificación de Interrupciones

* Todas las interrupciones tienen un **tipo** (byte de 8 bits), por lo tanto existen **256 tipos posibles (0 a 255)**.
* Tipos **0 a 31** están predefinidos por Intel (excepciones).
* Tipos **32 a 255** son para uso del usuario (ej: syscall INT 0x80).

---

## 3. Tabla IDT (Interrupt Descriptor Table)

* Tabla de 256 **descriptores**, no punteros.
* Se usa en **modo protegido**.
* Tipos de entradas:

  * **Interrupt Gate**
  * **Trap Gate**
  * **Task Gate** (solo en modo protegido de 32 bits)
* Cualquier otro tipo lanza una **#GP (General Protection Fault)**.

---

## 4. Formato del Descriptor de Interrupción (32 bits)

* Campos clave: **Offset** (direccion handler), **Selector**, **Tipo**, **DPL**, **P** (presente).
* El campo DPL define si puede ser llamado desde nivel de usuario (3) o solo kernel (0).

---

## 5. Manejo de la Pila (cambio de nivel de privilegio)

* Si la interrupción entra con cambio de CPL (ej: 3 → 0):

  * Se guarda SS y ESP del usuario.
  * Se carga ESP0 desde la TSS.
* Siempre se pushean: EIP, CS, EFLAGS. Si hay cambio de nivel: también SS y ESP.

---

## 6. Excepciones: Clasificación y Tipos

* **Fault**: puede reiniciarse la instrucción.
* **Trap**: se ejecuta completa y luego interrumpe.
* **Abort**: no se puede recuperar.

| Tipo | Mnemónico | Descripción        | Tipo de Excepción           |
| ---- | --------- | ------------------ | --------------------------- |
| 0    | #DE       | División por cero  | Fault                       |
| 6    | #UD       | Opcode inválido    | Fault                       |
| 13   | #GP       | General Protection | Fault                       |
| 14   | #PF       | Page Fault         | Fault (con código de error) |
| 8    | #DF       | Doble Fault        | Abort                       |
| 3    | #BP       | Breakpoint         | Trap                        |

---

## 7. Prioridades y simultaneidad

* Cuando hay varias interrupciones, se atienden por **prioridad**.
* Puede haber **interrupciones anidadas** si se reactivan las IRQ dentro del handler.

---

## 8. Controladores de Interrupciones

### PIC (Programmable Interrupt Controller)

* Tradicional: **8259A**.
* Mapea IRQs al rango 0x08-0x0F (se suele remapear a 0x20-0x2F para evitar conflictos).

### APIC (Advanced PIC)

* Soporta múltiples CPUs.
* Tiene control más fino de prioridades.

---

## 9. Interrupciones en modo 64 bits

* No existe el **Task Gate**.
* Los descriptores de IDT solo pueden ser **Interrupt Gate** o **Trap Gate**.
* No hay segmentos (modo plano).

---

## Preguntas posibles de parcial

1. ¿Qué diferencia hay entre interrupción, excepción y syscall?

   * **Interrupción**: evento externo (hardware).
   * **Excepción**: evento interno (error de CPU).
   * **Syscall**: interrupción generada por software (ej. `INT 0x80`).

2. ¿Por qué hay que usar la TSS para interrupciones que cambian de nivel?

   * Porque provee el nuevo valor de **ESP0**, necesario al pasar de usuario (3) a kernel (0).

3. ¿Cuándo se empuja SS y ESP en la pila?

   * Solo si hay **cambio de CPL** (nivel de privilegio) durante la interrupción.

4. ¿Por qué se remapean las interrupciones del PIC?

   * Para evitar que **IRQ 0-7** se solapen con las excepciones de Intel (0x00-0x1F).

5. Describir el formato y función de la IDT.

   * Tabla de 256 descriptores. Cada entrada tiene offset, selector, tipo (Gate), DPL, P.
   * Define cómo atender cada tipo de interrupción.

6. ¿Cuáles son las clases de excepciones y un ejemplo de cada una?

   * **Fault**: división por cero (#DE).
   * **Trap**: breakpoint (#BP).
   * **Abort**: doble fault (#DF).

7. Comparar INT Gate vs Trap Gate.

   * **INT Gate** deshabilita interrupciones al entrar.
   * **Trap Gate** mantiene habilitadas las interrupciones.

---

## Teórica: Tareas en procesadores Intel IA-32

### Conceptos fundamentales

* **Tarea (Task):** Unidad de trabajo que puede ejecutar un procesador, representando:

  * Un proceso o hilo.
  * Un handler de interrupción.
  * Una syscall del S.O.

* **Espacio de ejecución:** Código + datos + pila de la tarea.

* **Contexto de ejecución:** Contenido de los registros del procesador.

* **Espacio de contexto:** Bloque de memoria donde el S.O. guarda el contexto de ejecución.

---

### Cambio de contexto (Context Switch)

* Permite suspender una tarea y continuar otra.
* Incluye guardar el contexto de una y restaurar el de otra.
* Puede incluir o no el espacio de memoria.
* Se producen miles por segundo; genera la ilusión de simultaneidad.

---

### Rol del Sistema Operativo

* El **scheduler** gestiona la lista de tareas a ejecutar.
* Define un **time frame**, dividido en unidades menores (ticks).
* Asigna **prioridades** dando distintos número de ticks a cada tarea.
* Una vez expirado su tiempo, una tarea es suspendida y se despacha otra.

---

### Mecanismos de Tareas en IA-32

* **TSS (Task State Segment):** estructura de hardware para almacenar el contexto completo de una tarea.
* **Selector de tarea:** Entrada en la GDT que apunta a una TSS.
* **Task Gate en IDT:** Entrada especial en la IDT que referencia indirectamente a la TSS.
* Cambio de tarea automático: el procesador guarda/restaura contexto usando TSS.
* Cambio manual: el S.O. guarda/restaura registros.

---

### Tipos de Cambio de Tarea

* **Software:** instrucción `JMP`, `CALL`, `IRET` a un selector de TSS.
* **Hardware:** interrupciones, excepciones o `CALL` a un task gate.

---

### Anidamiento de tareas

* El procesador mantiene una pila de tareas anidadas.
* Permite volver a la tarea anterior (contexto anidado).
* Tiene un límite de profundidad.

---

### Posibles preguntas de parcial y respuestas breves

1. **¿Qué es una tarea?**
   Unidad de ejecución del procesador: programa, syscall o handler.

2. **¿Qué es el cambio de contexto?**
   Guardar el estado de una tarea y restaurar el de otra.

3. **¿Cuál es el rol de la TSS?**
   Almacenar el contexto completo de una tarea (automáticamente en conmutaciones).

4. **¿Qué diferencias hay entre cambio de tarea automático y manual?**
   El automático lo hace el CPU con TSS y task gates. El manual lo hace el S.O. guardando/restaurando registros.

5. **¿Por qué se anidan tareas?**
   Para poder retornar al contexto anterior tras interrupciones o llamadas.

6. **¿Cuál es el objetivo del scheduler?**
   Seleccionar qué tarea ejecutar, y por cuánto tiempo.

7. **¿Cuándo ocurre un cambio de contexto?**
   Cuando expira el tiempo de una tarea, o por interrupciones o eventos del S.O.

8. **¿Qué contiene una TSS?**
   Registros, segmentos, punteros de pila, y otros datos de la tarea.

---

### Tip extra

En el TP de la cátedra:

* Se usa TSS para cada tarea.
* Las tareas tienen su propio stack y directorio de páginas.
* La GDT contiene las TSS de todas las tareas.
* Se programa el cambio manual de tareas desde interrupciones.

