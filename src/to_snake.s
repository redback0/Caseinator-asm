section .text
	global to_snake
	extern rb_isspace

to_snake:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15

	; rdi = char* string
	mov r14, rdi
	mov r12, rdi
	mov r13, rdi
	mov r15, 1

	; rbx = current char
	; r12 = source
	; r13 = dest
	; r14 = store
	; r15 = was last whitespace
.loop:
	xor rdi, rdi
	mov dil, byte [r12]

	cmp dil, 0
	je .loop_exit

	call rb_isspace
	; rax = 0 or 1

	cmp rax, 0
	jne .space

.not_space:
	mov r15, 0
	cmp dil, 65 ; 'A'
	jl .write_new

	cmp dil, 90 ; 'Z'
	jg .write_new

	add dil, 32
	jmp .write_new

.space:
	cmp r15, 0
	mov r15, 1
	jne .loop_cont

	mov dil, 95 ; '_'

.write_new:
	mov byte [r13], dil
	inc r13

.loop_cont:
	inc r12
	jmp .loop

.loop_exit:
	mov rax, r14

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	leave
	ret
