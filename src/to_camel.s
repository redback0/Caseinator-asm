section .text
	global to_camel
	extern rb_isspace

to_camel:
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
	mov r15, 0

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
	cmp r15, 0
	mov r15, 0
	jne .to_upper

.to_lower:
	cmp dil, 65 ; 'A'
	jl .write_new

	cmp dil, 90 ; 'Z'
	jg .write_new

	add dil, 32
	jmp .write_new

.to_upper:
	cmp dil, 97 ; 'a'
	jl .write_new

	cmp dil, 122 ; 'z'
	jg .write_new

	sub dil, 32
	jmp .write_new

.space:
	mov r15, 1
	jmp .loop_cont

.write_new:
	mov byte [r13], dil
	inc r13

.loop_cont:
	inc r12
	jmp .loop

.loop_exit:
	mov byte [r13], 0
	mov rax, r14

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	leave
	ret
