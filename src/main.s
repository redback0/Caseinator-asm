default rel

section .rodata
nl db 10


section .text
	global _start
	extern rb_strlen
	extern rb_strdup
	extern free
	extern to_lower
	extern to_upper
	extern time
	extern srand
	extern rand

_start:
	pop rax ; argc

	; check argc > 1
	cmp rax, 1
	jle .exit

	mov rdi, [rsp + 8] ; argv[1]
	call rb_strlen
	; rax = strlen

	mov rdi, 1
	mov rsi, [rsp + 8] ; argv[1]
	mov rdx, rax
	mov rax, 1
	syscall

	lea rsi, [rel nl]
	mov rdx, 1
	mov rax, 1
	syscall

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
	mov ecx, 2
	div ecx
	; rdx = rand % 2
	cmp rdx, 0
	je .upper
	cmp rdx, 1
	je .lower
	jmp .default

.upper:
	call to_upper
	jmp .default

.lower:
	call to_lower
	jmp .default

.default:

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

