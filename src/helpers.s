
extern malloc

section .text
	global rb_strlen
	global rb_strcpy
	global rb_strdup
	global rb_isspace


rb_strlen:
	push    rbp
	mov     rbp,rsp
	; skip unused rbx, r12-r15

	; assume rdi contains address of string

	; loop on string till null terminator
	mov     rcx, dword -1
	xor     al, al
	cld
	repnz scasb

	; get length
	mov     rax, dword -2
	sub     rax, rcx

	leave
	ret


rb_strcpy:
	push    rbp
	mov     rbp,rsp
	; skip unused rbx, r12-r15

	; rdi = dst, rsi = src

	; save start of dst
	mov     rax, rdi

	xor     dl, dl

.while_src:
	cmp     dl, [rsi]
	je      .while_src_end

	movsb
	jmp     .while_src

.while_src_end:
	mov     [rdi], byte 0x0

	leave
	ret


rb_strdup:
	push    rbp
	mov     rbp,rsp
	push    rbx
	; skip unused r12-r15

	; rdi = str
	mov     rbx, rdi
	call    rb_strlen
	; rax = strlen

	mov     rdi, rax
	inc     rdi
	call    malloc wrt ..plt
	; rax = new memory

	cmp     rax, 0x0
	je     .strdup_error

	mov     rdi, rax
	mov     rsi, rbx
	call    rb_strcpy

.strdup_error:

	pop     rbx
	leave
	ret


rb_isspace:
	push    rbp
	mov     rbp,rsp
	; skip unused rbx, r12-15

	; rdi = c

	xor     rax, rax

	cmp     rdi, " "
	je      .found
	cmp     rdi, 0x9        ; \t
	jb      .not_found
	cmp     rdi, 0xD        ; \r
	ja      .not_found

.found:
	mov     rax, 0x1

.not_found:
	leave
	ret

