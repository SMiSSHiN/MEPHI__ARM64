###			(a+b)^2 - (c-d)^2
#	res = ----------------------
###		       a + e^3 - c
###
/*
	8  bit: 255
	16 bit: 65 535
	32 bit: 4 294 967 295
	64 bit: 18 446 744 073 709 551 615
 */
	.arch armv8-a
	.data
	.align	3
res:
	.skip	8
a:
	.hword	220
b:
	.hword	100
c:
	.word	210
d:
	.hword	200
e:
	.word	30
	.text
	.align	2
	.global	_start
	.type	_start, %function
_start:
	adr x0, a
	ldrh w1, [x0]
	adr x0, b
	ldrh w2, [x0]
	adr x0, c
	ldrh w3, [x0]
	adr x0, d
	ldrh w4, [x0]
	adr x0, e
	ldrh w5, [x0]

	add w6, w1, w2			// (a + b)
	umull x6, w6, w6		// x6: (a + b)^2
	subs w7, w3, w4			// (c - d)
	bmi L1
	umull x7, w7, w7		// x7: (c - d)^2
	subs x6, x6, x7			// x6: (a + b)^2 - (c - d)^2
	bmi L1
	
	subs w7, w1, w3			// w7: a - c
	bcc L1
	umull x8, w5, w5		// x8: e^2
	uxtw x5, w5

	// ldr x8, = 0xfffffffffffffff
	// ldr x5, = 0xfffffffffffffff

	umulh x10, x8, x5		// Старшие 64 бита результата
	cmp x10, #0
	bne L1

	mul x8, x8, x5			// x8: e^3
	adds x9, x8, w7, uxtw	// x9: (a - c) + e^3
	bcs L1

	udiv x6, x6, x9			// x6: res = ...

	adr x0, res
	str x6, [x0]
	mov x0, #0
	mov x8, #93
	svc #0

L1:
	mov x0, #-1
	mov x8, #93
	svc #0
	.size 	_start, .-_start
