default rel

section .rodata
	nl db 10


section .text
	global _start
	extern rb_strlen
	extern rb_strdup
	extern free
	extern time
	extern srand
	extern rand

	extern to_lower
	extern to_upper
	extern to_snake

_start:
	pop rax ; argc

	; check argc > 1
	cmp rax, 1
	jle .exit

	mov rdi, [rsp + 8] ; argv[1]
	call rb_strlen
	; rax = strlen

	; print argv[1]
	mov rdi, 1 ; stdout
	mov rsi, [rsp + 8] ; argv[1]
	mov rdx, rax ; n
	mov rax, 1 ; write
	syscall

	; print newline
	lea rsi, [rel nl]
	mov rdx, 1
	mov rax, 1
	syscall

	; dup string; assume argv[1] isn't mutable
	mov rdi, [rsp + 8]
	call rb_strdup
	; rax = strdup

	; call case function

	mov rbx, rax

	; get seed for srand
	xor rdi, rdi
	call time wrt ..plt

	; seed random
	mov rdi, rax
	call srand wrt ..plt

	; get random number
	call rand wrt ..plt

	; mov for prep to call caseinator
	mov rdi, rbx

	xor rdx, rdx
	mov ecx, 3
	div ecx
	; rdx = rand % 2
	; jump to call random caseinator
	cmp rdx, 0
	je .upper
	cmp rdx, 1
	je .lower
	cmp rdx, 2
	je .snake

.upper:
	call to_upper
	jmp .cased

.lower:
	call to_lower
	jmp .cased

.snake:
	call to_snake
	jmp .cased

.cased:

	; rax = rbx = cased string

	mov rdi, rbx
	call rb_strlen
	; rax = strlen

	mov rdi, 1 ; stdout
	mov rsi, rbx ; *buf
	mov rdx, rax ; n
	mov rax, 1 ; write
	syscall

	lea rsi, [rel nl]
	mov rdx, 1
	mov rax, 1
	syscall

	mov rdi, rbx
	call free wrt ..plt

.exit:
	mov rax, 60
	xor rdi, rdi
	syscall

