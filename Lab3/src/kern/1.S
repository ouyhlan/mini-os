	.file	"1.c"
	.text
	.globl	StrCmp
	.type	StrCmp, @function
StrCmp:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movl	%edx, -36(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L2
.L5:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %edx
	movl	-4(%rbp), %eax
	movslq	%eax, %rcx
	movq	-32(%rbp), %rax
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	cmpb	%al, %dl
	je	.L3
	movl	$-1, %eax
	jmp	.L4
.L3:
	addl	$1, -4(%rbp)
.L2:
	movl	-4(%rbp), %eax
	cmpl	%eax, -36(%rbp)
	ja	.L5
	movl	$0, %eax
.L4:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	StrCmp, .-StrCmp
	.globl	LoadUserProgram
	.type	LoadUserProgram, @function
LoadUserProgram:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movl	%esi, -24(%rbp)
	movq	$4194304, -8(%rbp)
	movl	-24(%rbp), %eax
	movswl	%ax, %edx
	movl	-20(%rbp), %ecx
	movq	-8(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	readsect@PLT
	movq	-8(%rbp), %rax
#APP
# 23 "1.c" 1
	call %rax
	
# 0 "" 2
#NO_APP
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	LoadUserProgram, .-LoadUserProgram
	.section	.rodata
.LC0:
	.string	"1.com"
.LC1:
	.string	"2.com"
.LC2:
	.string	"3.com"
.LC3:
	.string	"4.com"
	.align 8
.LC4:
	.string	"Hello this is ouyhlan's monitor program! The following programs which you can use: "
.LC5:
	.string	"Os1> "
.LC6:
	.string	"exit"
.LC7:
	.string	"\n[System exits normally!]\n"
	.align 8
.LC8:
	.string	"Wrong input! Please enter again!\n"
	.text
	.globl	Welcoming
	.type	Welcoming, @function
Welcoming:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$112, %rsp
	leaq	.LC0(%rip), %rax
	movq	%rax, -64(%rbp)
	leaq	.LC1(%rip), %rax
	movq	%rax, -56(%rbp)
	leaq	.LC2(%rip), %rax
	movq	%rax, -48(%rbp)
	leaq	.LC3(%rip), %rax
	movq	%rax, -40(%rbp)
	movl	$0, -104(%rbp)
	movl	$0, -100(%rbp)
	movq	-104(%rbp), %rax
	movq	%rax, %rdi
	call	SetCurPos@PLT
	movq	$753664, -24(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L8
.L9:
	movl	-4(%rbp), %eax
	addl	%eax, %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movb	$32, (%rax)
	movl	-4(%rbp), %eax
	addl	%eax, %eax
	cltq
	leaq	1(%rax), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movb	$48, (%rax)
	addl	$1, -4(%rbp)
.L8:
	cmpl	$1999, -4(%rbp)
	jle	.L9
	leaq	.LC4(%rip), %rdi
	call	puts@PLT
	movl	$10, %edi
	call	putc@PLT
	movl	$0, -8(%rbp)
	jmp	.L10
.L11:
	movl	-8(%rbp), %eax
	cltq
	movq	-64(%rbp,%rax,8), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	$10, %edi
	call	putc@PLT
	addl	$1, -8(%rbp)
.L10:
	cmpl	$3, -8(%rbp)
	jle	.L11
.L23:
	leaq	.LC5(%rip), %rdi
	call	puts@PLT
	leaq	-96(%rbp), %rax
	movq	%rax, %rdi
	call	gets@PLT
	movl	$0, -12(%rbp)
	leaq	-96(%rbp), %rax
	movl	$4, %edx
	leaq	.LC0(%rip), %rsi
	movq	%rax, %rdi
	call	StrCmp
	testl	%eax, %eax
	jne	.L12
	movl	$1, -12(%rbp)
	jmp	.L13
.L12:
	leaq	-96(%rbp), %rax
	movl	$4, %edx
	leaq	.LC1(%rip), %rsi
	movq	%rax, %rdi
	call	StrCmp
	testl	%eax, %eax
	jne	.L14
	movl	$2, -12(%rbp)
	jmp	.L13
.L14:
	leaq	-96(%rbp), %rax
	movl	$4, %edx
	leaq	.LC2(%rip), %rsi
	movq	%rax, %rdi
	call	StrCmp
	testl	%eax, %eax
	jne	.L15
	movl	$3, -12(%rbp)
	jmp	.L13
.L15:
	leaq	-96(%rbp), %rax
	movl	$4, %edx
	leaq	.LC3(%rip), %rsi
	movq	%rax, %rdi
	call	StrCmp
	testl	%eax, %eax
	jne	.L16
	movl	$4, -12(%rbp)
	jmp	.L13
.L16:
	leaq	-96(%rbp), %rax
	movl	$4, %edx
	leaq	.LC6(%rip), %rsi
	movq	%rax, %rdi
	call	StrCmp
	testl	%eax, %eax
	jne	.L17
	leaq	.LC7(%rip), %rdi
	call	puts@PLT
	jmp	.L13
.L17:
	leaq	.LC8(%rip), %rdi
	call	puts@PLT
	jmp	.L18
.L13:
	cmpl	$4, -12(%rbp)
	je	.L19
	cmpl	$4, -12(%rbp)
	jg	.L23
	cmpl	$3, -12(%rbp)
	je	.L20
	cmpl	$3, -12(%rbp)
	jg	.L23
	cmpl	$1, -12(%rbp)
	je	.L21
	cmpl	$2, -12(%rbp)
	je	.L22
	jmp	.L18
.L21:
	movl	$1, %esi
	movl	$10, %edi
	call	LoadUserProgram
	jmp	.L18
.L22:
	movl	$1, %esi
	movl	$11, %edi
	call	LoadUserProgram
	jmp	.L18
.L20:
	movl	$1, %esi
	movl	$12, %edi
	call	LoadUserProgram
	jmp	.L18
.L19:
	movl	$1, %esi
	movl	$13, %edi
	call	LoadUserProgram
	nop
.L18:
	jmp	.L23
	.cfi_endproc
.LFE2:
	.size	Welcoming, .-Welcoming
	.ident	"GCC: (Ubuntu 9.3.0-11ubuntu0~18.04.1) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
