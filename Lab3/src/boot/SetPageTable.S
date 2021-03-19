	.file	"SetPageTable.c"
	.text
	.globl	SetPageTable
	.type	SetPageTable, @function
SetPageTable:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$40, %rsp
	movq	$1048576, -88(%rbp)
	movq	-88(%rbp), %rax
	movq	$3145767, (%rax)
	movq	-88(%rbp), %rax
	addq	$4088, %rax
	movq	$2097191, (%rax)
	movq	-88(%rbp), %rax
	addq	$2048, %rax
	movq	$2097191, (%rax)
	movq	$2097152, -96(%rbp)
	movq	-96(%rbp), %rax
	movq	$4194343, (%rax)
	movq	-96(%rbp), %rax
	addq	$4088, %rax
	movq	$4194343, (%rax)
	movq	$3145728, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	$5242919, (%rax)
	movq	$4194304, -112(%rbp)
	movq	-112(%rbp), %rax
	movq	$6291495, (%rax)
	movq	-112(%rbp), %rax
	addq	$4088, %rax
	movq	$6291495, (%rax)
	movq	$5242880, -120(%rbp)
	movq	-120(%rbp), %rax
	movq	$7340071, (%rax)
	movq	-120(%rbp), %rax
	addq	$16, %rax
	movq	$11534375, (%rax)
	movq	$6291456, -128(%rbp)
	movq	$10485799, -8(%rbp)
	movl	$0, -12(%rbp)
	jmp	.L2
.L3:
	movl	-12(%rbp), %eax
	cltq
	addq	$256, %rax
	leaq	0(,%rax,8), %rdx
	movq	-128(%rbp), %rax
	addq	%rax, %rdx
	movq	-8(%rbp), %rax
	movq	%rax, (%rdx)
	addl	$1, -12(%rbp)
	addq	$4096, -8(%rbp)
.L2:
	cmpl	$255, -12(%rbp)
	jle	.L3
	movq	$8388647, -24(%rbp)
	movl	$0, -28(%rbp)
	jmp	.L4
.L5:
	movl	-28(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-128(%rbp), %rax
	addq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	%rax, (%rdx)
	addl	$1, -28(%rbp)
	addq	$32768, -24(%rbp)
.L4:
	cmpl	$255, -28(%rbp)
	jle	.L5
	movq	$7340032, -136(%rbp)
	movq	$39, -40(%rbp)
	movl	$0, -44(%rbp)
	jmp	.L6
.L7:
	movl	-44(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-136(%rbp), %rax
	addq	%rax, %rdx
	movq	-40(%rbp), %rax
	movq	%rax, (%rdx)
	addl	$1, -44(%rbp)
	addq	$4096, -40(%rbp)
.L6:
	cmpl	$255, -44(%rbp)
	jle	.L7
	movq	-136(%rbp), %rax
	addq	$1472, %rax
	movq	$753711, (%rax)
	movq	$9437223, -56(%rbp)
	movl	$0, -60(%rbp)
	jmp	.L8
.L9:
	movl	-60(%rbp), %eax
	cltq
	addq	$256, %rax
	leaq	0(,%rax,8), %rdx
	movq	-136(%rbp), %rax
	addq	%rax, %rdx
	movq	-56(%rbp), %rax
	movq	%rax, (%rdx)
	addl	$1, -60(%rbp)
	addq	$4096, -56(%rbp)
.L8:
	cmpl	$255, -60(%rbp)
	jle	.L9
	movq	$11534336, -144(%rbp)
	movq	$12582951, -72(%rbp)
	movl	$0, -76(%rbp)
	jmp	.L10
.L11:
	movl	-76(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-144(%rbp), %rax
	addq	%rax, %rdx
	movq	-72(%rbp), %rax
	movq	%rax, (%rdx)
	addl	$1, -76(%rbp)
	addq	$4096, -72(%rbp)
.L10:
	cmpl	$511, -76(%rbp)
	jle	.L11
	movq	$9437184, -152(%rbp)
	movl	$0, -80(%rbp)
	jmp	.L12
.L13:
	movl	-80(%rbp), %eax
	addl	%eax, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-152(%rbp), %rax
	addq	%rdx, %rax
	movabsq	$15393163313152, %rcx
	movq	%rcx, (%rax)
	movl	-80(%rbp), %eax
	addl	%eax, %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-152(%rbp), %rax
	addq	%rdx, %rax
	movq	$0, (%rax)
	addl	$1, -80(%rbp)
.L12:
	cmpl	$255, -80(%rbp)
	jle	.L13
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	SetPageTable, .-SetPageTable
	.ident	"GCC: (Ubuntu 9.3.0-11ubuntu0~18.04.1) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
