section .text
	global to_lower

to_lower:
	push rbp
	mov rbp, rsp
	push rbx
	;push r12
	;push r13
	;push r14
	;push r15

	; rdi = char* string
	mov rcx, rdi
.loop:
	xor rbx, rbx
	mov bl, byte [rdi]

	cmp bl, 0
	je .loop_exit

	cmp bl, 65 ; 'A'
	jl .check_loop

	cmp bl, 90 ; 'Z'
	jg .check_loop

	add bl, 32
	mov byte [rdi], bl

.check_loop:
	inc rdi
	jmp .loop

.loop_exit:

	mov rax, rcx

	;pop r15
	;pop r14
	;pop r13
	;pop r12
	pop rbx
	leave
	ret
