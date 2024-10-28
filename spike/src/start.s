.section .data
.section .text
.globl _start
_start:
	nop
	la t0, main
	jalr t0

	la t1, tohost
	li t2, 1
	sw t2, 0(t1)

.section .tohost, "aw", @progbits
.globl tohost
.align 8
tohost: .dword 0
.globl fromhost
.align 8
fromhost: .dword 0
