    .arch armv8-a
    .data
    .align   3
size:
    .byte    4
matrix: 
    .hword   1, 5, 3, 4
    .hword   2, 6, 7, 8
    .hword   9, 10, 11, 12
    .hword   13, 14, 15, 16
    .text
    .align  2
    .global _start
    .type   _start, %function
_start:
    adr x2, size
    mov x0, #0
    ldrb w0, [x2]                   // x0: size
    adr x1, matrix
    mov x2, #0                      // x2: номер побочной диагонали
    sub x4, x0, #1                  // x4: size - 1
    add x6, x0, x0
    sub x6, x6, #3                  // индекс последней побочной диагонали
    mov x3, #0
_next_diagonal:
    add x2, x2, #1
    add x5, x2, #1
    cmp x2, x6
        bgt _exit
    cmp x2, x0
        beq _prepare
    cmp x2, x0
        bgt _prepare2
_first_element:
    cmp x2, x0
    bge _first_element2
        sub x5, x5, #1              // индекс до которого идем
        cbz x5, _next_diagonal
            mov x3, #0
            add x10, x1, x2, lsl #1             // addr of first element
            ldrh w12, [x10]
_second_element:
        add x3, x3, #1
        cmp x3, x5
        bgt _first_element
            add x11, x10, x4, lsl #1         
            ldrh w13, [x11]                  // second element
            cmp w12, w13
            blt _first_element_jump         // swap elements...
                strh w12, [x11]
                strh w13, [x10]
                mov x10, x11
                b   _second_element
_first_element_jump:
    mov x12, x13
    mov x10, x11
    b   _second_element
_prepare:
    mov x5, x4
    mov x7, x5                  // запомнили x5
_first_element2:
    sub x9, x2, x4
    sub x5, x5, #1
    cbz x5, _next_diagonal
        mov x3, #0
        mul x8, x9, x0
        add x10, x1, x8, lsl #1
        add x10, x10, x4, lsl #1
        ldrh w12, [x10]
        b   _second_element
_prepare2:
    sub x7, x7, #1
    mov x5, x7
    b _first_element2
_exit:
    mov x0, #0
    mov x8, #93
    svc #0
    .size   _start, .-_start
