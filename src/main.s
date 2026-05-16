
extern strlen

section .text
	global _start

_start:
	pop rax ; argc

	; print argc
	;add rax, 48
	;or rax, 10 << 8
	;mov [REL digit], rax
	;mov rax, 1
	;mov rdi, 1
	;mov rsi, digit
	;mov rdx, 2
	;syscall

	;mov rax, [REL argc]

	cmp rax, 1
	jle .exit

	mov rdi, [rsp + 8] ; argv[1]
	call strlen

	mov rdi, 1
	mov rsi, [rsp + 8] ; argv[1]
	mov rdx, rax
	mov rax, 1
	syscall

	push 10
	mov rsi, rsp
	mov rdx, 1
	mov rax, 1
	syscall
	pop rsi

.exit:
	mov rax, 60
	xor rdi, rdi
	syscall

; push rbp, mov rbp rsp, push rbx r12-r15
