	.arch armv8-a
//	sin(x)	
	.data
mes1:
	.string	"Enter x --> "
mes2:
	.string	"Precision --> "
mes3:
    .string "sin(%.17g) = %.17g\n"
mes4:
    .string "sin(%.17g) = %.17g\n"
format1:
    .string "%lf"
errmes1:
    .string "Usage: %s filename\n"
errmes2:
    .string "Unknown error"
mode:
    .string "w"
    .text
    .align  2
    .global mysin
    .type   mysin, %function
mysin:
    fmov d5, #2.0
    mov x1, #4
    fmov d6, d1                             // precision
    fmov d12, #1.0
    fmov d1, d0                             // Число sin(x)
    fmov d2, d0                             // Предыдущий член ряда
    fmov d3, d5                             // Счетчик факториалов
0:
    fcvtau x0, d3
    udiv x2, x0, x1
    msub x3, x2, x1, x0 
    cmp x3, #0
    bne 1f
        fmov d10, #1.0
        b   2f
1:
    fmov d10, #-1.0
2:
    fmov d4, d2
    fabs d1, d1
    fmul d1, d1, d0
    fmul d1, d1, d0 
    fdiv d1, d1, d3
    fadd d3, d3, d12
    fdiv d1, d1, d3
    fadd d3, d3, d12
    fmul d1, d1, d10
    fadd d2, d2, d1
    fabs d4, d4
    fabs d7, d2
    fsub d7, d7, d4                         // d7: a(n) - a(n-1)
    fabs d7, d7
    fcmp d7, d6
    bgt 0b
        fmov d0, d2
        ret
    .size   mysin, .-mysin
	.global	main
	.type	main, %function
	.equ	progname, 16
    .equ    filename, 24
    .equ    filepointer, 32
    .equ    x, 40                           // argument
    .equ    y, 48                           // sin, mysin
    .equ    z, 56                           // precision
main:
    stp x29, x30, [sp, #-64]!               // Pre-index addressing mode
    mov x29, sp
    cmp w0, #2
    beq 0f
        ldr x2, [x1]                        // Адресс первой строчки(имя программы)
        adr x0, stderr                      // ???
        ldr x0, [x0]
        adr x1, errmes1
        bl  fprintf                         // ???
9:
    mov w0, #0
    ldp x29, x30, [sp], #64                 // Post-index addressing mode
    ret
0:  
    ldr x0, [x1]                            // Адрес имени программы
    str x0, [x29, progname]
    ldr x0, [x1, #8]                        // Адрес имени файла
    str x0, [x29, filename]
/*
    FILE *fopen(const char *filename, const char *mode);
*/
    adr x1, mode
    bl  fopen                               // Через x0 вернет указатель на struct file*
    cbnz x0, 1f
        ldr x0, [x29, filename]
        bl  perror
        b   9b
1:
    str x0, [x29, filepointer]
    adr x0, mes1
    bl  printf
/*
    int scanf(const char *format, ...);
*/
    adr x0, format1
    add x1, x29, x
    bl  scanf
    ldr d0, [x29, x]
    bl  sin
    str d0, [x29, y]                        // ???
    adr x0, mes2
    bl  printf
    adr x0, format1
    add x1, x29, z
    bl  scanf
/*
    int printf(const char *format, ...)
*/
    adr x0, mes3
    ldr d0, [x29, x]
    ldr d1, [x29, y]
    bl  printf
/*
    int fprintf(FILE *stream, const char *format, ...)
*/
    ldr x0, [x29, filepointer]
    adr x1, mes3
    ldr d0, [x29, x]
    ldr d1, [x29, y]
    bl  fprintf
    cmp x0, #0
    bgt 2f
        ldr x0, [x29, filepointer]
        bl  fclose
        adr x0, stderr
        ldr x0, [x0]
        adr x1, errmes2
        bl  fprintf
        b   9b
2:  
    ldr d0, [x29, x]
    ldr d1, [x29, z]
    bl  mysin
    str d0, [x29, y]
    adr x0, mes4
    ldr d0, [x29, x]
    ldr d1, [x29, y]
    bl  printf
    ldr x0, [x29, filepointer]
    adr x1, mes3
    ldr d0, [x29, x]
    ldr d1, [x29, y]
    bl  fprintf
    cmp x0, #0
    bgt 3f
        ldr x0, [x29, filepointer]
        bl  fclose
        adr x0, stderr
        ldr x0, [x0]
        adr x1, errmes2
        bl  fprintf
        b   9b
3:
    ldr x0, [x29, filepointer]
    bl  fclose
    b   9b
    .size   main, .-main
