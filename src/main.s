
section .bss
	argc resb 8
	digit resb 8

section .text
	global _start

_start:
	pop rax
	mov [REL argc], rax

	add rax, 48
	or rax, 10 << 8
	mov [REL digit], rax
	mov rax, 1
	mov rdi, 1
	mov rsi, digit
	mov rdx, 2
	syscall

	mov rax, [REL digit]

	cmp rax, 1
	jle .exit

.exit:
	mov rax, 60
	xor rdi, rdi
	syscall

; push rbp, mov rbp rsp, push rbx r12-r15
