#include <asm.h>

# Start the CPU: switch to 32-bit protected mode, jump into C.
# The BIOS loads this code from the first sector of the hard disk into
# memory at physical address 0x7c00 and starts executing in real mode
# with %cs=0 %ip=7c00.

.set PROC_SETUPPAGETABLE,   0x2
.set PROT_MODE_CSEG,        0x8                     # kernel code segment selector
.set PROT_MODE_DSEG,        0x10                    # kernel data segment selector
.set PROT_MODE_GSEG,        0x18                    # kernel graph segment selector
.set CR0_PE_ON,             0x1                     # protected mode enable flag
.set PML4_BASE,             0x100000                # pml-4 base address
.set LONG_MODE_CSEG,        0x8
.set LONG_MODE_SMEM,        0xffffffffffffffff          
.set LONG_MODE_SYSM,        0xffff800000000000
.set KERNEL_SEC,            0x5
.set NUM_KERNEL_SEC,        0x0a                    # read 16 secs
# start address should be 0:7c00, in real mode, the beginning address of the running bootloader
.section .text
.extern puts
.extern readsect
.globl _start
_start:
.code16                                             # Assemble for 16-bit mode    
loadfuncputs:
    mov %cs, %ax
    mov %ax, %es
    mov $0x7e00, %bx
    mov $0x0204, %ax
    mov $0x0080, %dx                                # Read Hard-Disk
    mov $0x0002, %cx
    int $0x13

    cli                                             # Disable interrupts
    cld                                             # String operations increment

    # Set up the important data segment registers (DS, ES, SS).
    xorw %ax, %ax                                   # Segment number zero
    movw %ax, %ds                                   # -> Data Segment
    movw %ax, %es                                   # -> Extra Segment
    movw %ax, %ss                                   # -> Stack Segment

    # Enable A20:
    #  For backwards compatibility with the earliest PCs, physical
    #  address line 20 is tied low, so that addresses higher than
    #  1MB wrap around to zero by default. This code undoes this.
seta20.1:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.1

    movb $0xd1, %al                                 # 0xd1 -> port 0x64
    outb %al, $0x64                                 # 0xd1 means: write data to 8042's P2 port

seta20.2:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.2

    movb $0xdf, %al                                 # 0xdf -> port 0x60
    outb %al, $0x60                                 # 0xdf = 11011111, means set P2's A20 bit(the 1 bit) to 1

    # Switch from real to protected mode, using a bootstrap GDT
    # and segment translation that makes virtual addresses
    # identical to physical addresses, so that the
    # effective memory map does not change during the switch.
    lgdt gdtdesc
    lidt idtdesc
    movl %cr0, %eax
    orl $CR0_PE_ON, %eax
    movl %eax, %cr0

    # Jump to next instruction, but in 32-bit code segment.
    # Switches processor into 32-bit mode.
    ljmp $PROT_MODE_CSEG, $protcseg

.code32                                             # Assemble for 32-bit mode
protcseg:
    # Set up the protected-mode data segment registers
    movw $PROT_MODE_DSEG, %ax                       # Our data segment selector
    movw %ax, %ds                                   # -> DS: Data Segment
    movw %ax, %es                                   # -> ES = DS
    movw %ax, %fs                                   # -> FS = DS
    movw %ax, %ss                                   # -> SS: Stack Segment
    movw $PROT_MODE_GSEG, %ax                       
    movw %ax, %gs                                   # -> GS = 0xB6000

    # Set up the stack pointer and call into C. The stack region is from 0--start(0x7c00)
    movl $0x0, %ebp
    movl $_start, %esp
    call SetPageTable

    #
    # Enable the 64-bit page-translation-table entries by
    # setting CR4.PAE=1 (this is _required_ before activating
    # long mode). Paging is not enabled until after long mode
    # is enabled.
    #
    movl %cr4, %eax
    bts $0x5, %eax
    movl %eax, %cr4
    #
    # Create the long-mode page tables, and initialize the
    # 64-bit CR3 (page-table base address) to point to the base
    # of the PML4 page table. The PML4 page table must be located
    # below 4 Gbytes because only 32 bits of CR3 are loaded when
    # the processor is not in 64-bit mode.
    #
    movl $PML4_BASE, %eax                           # Pointer to PML4 table (<4GB).
    movl %eax, %cr3                                 # Initialize CR3 with PML4 base.
    #
    # Enable long mode (set EFER.LME=1).
    #
    mov $0x0c0000080, %ecx                          # EFER MSR number.
    rdmsr                                           # Read EFER.
    bts $0x8, %eax                                  # Set LME=1.
    wrmsr                                           # Write EFER.
    #
    # Enable paging to activate long mode (set CR0.PG=1)
    #
    movl %cr0, %eax                                 # Read CR0.
    orl $0x80000000, %eax                           # Set PG=1.
    movl %eax, %cr0                                 # Write CR0.
    #
    # At this point, we are in 16-bit compatibility mode
    # ( LMA=1, CS.L=0, CS.D=0 ).
    lgdt gdt64desc
    lidt idt64desc
start64_linear:
    ljmp $LONG_MODE_CSEG, $longseg

.code64                                             # Assemble for 64-bit mode
longseg:
    movq $PML4_BASE, %rax                           # Pointer to Final PML4 table
    movq %rax, %cr3                                 # Initialize CR3 with PML4 base.
    movq $LONG_MODE_SMEM, %rsp                      # Setting Stack
    movq $longmesg, %rdi
    call puts

	# 延迟显示
	movq $0x100000, %rcx
L:	loop L

    # Loading Kernel Code in
    movq $LONG_MODE_SYSM, %rdi
    movq $KERNEL_SEC, %rsi
    movq $NUM_KERNEL_SEC, %rdx
    call readsect

    movq $LONG_MODE_SYSM, %r9
    jmp %r9

spin:
    jmp spin

# Bootstrap GDT
.p2align 2                                          # force 4 byte alignment
gdt:
    SEG_NULLASM                                     # null seg
    SEG_ASM(STA_X|STA_R, 0x0, 0xffffffff)           # code seg for bootloader and kernel
    SEG_ASM(STA_W, 0x0, 0xffffffff)                 # data seg for bootloader and kernel
    SEG_ASM(STA_W, 0xB8000, 0xffffffff)             # graph seg for bootloader and kernel

gdtdesc:
    .word 0x1f                                      # sizeof(gdt) - 1
    .long gdt                                       # address gdt
idtdesc:
    .word 0x0
    .long 0
gdt64:
    # NULL
    .word 0xffff
    .word 0
    .byte 0
    .byte 0
    .byte 1
    .byte 0
    # Code
gdt64Code:
    .word 0
    .word 0
    .byte 0
    .byte 0x9a
    .byte 0xaf
    .byte 0
    # Data
    .word 0
    .word 0
    .byte 0
    .byte 0x92
    .byte 0
    .byte 0
gdt64desc:
    .word 0x1f
    .quad gdt64
idt64desc:
    .word 0x8000
    .quad 0x100000
longmesg:
    .string "Successfully entering Long Mode!\n"

cur:
   .fill (510 - (cur - _start)), 1, 0
   .byte 0x55, 0xaa

.code32
	.globl	SetPageTable
	.type	SetPageTable, @function
SetPageTable:
.LFB0:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$112, %esp
	movl	$1048576, -76(%ebp)
	movl	-76(%ebp), %eax
	movl	$3145767, (%eax)
	movl	$0, 4(%eax)
	movl	-76(%ebp), %eax
	addl	$4088, %eax
	movl	$2097191, (%eax)
	movl	$0, 4(%eax)
	movl	-76(%ebp), %eax
	addl	$2048, %eax
	movl	$2097191, (%eax)
	movl	$0, 4(%eax)
	movl	$2097152, -80(%ebp)
	movl	-80(%ebp), %eax
	movl	$4194343, (%eax)
	movl	$0, 4(%eax)
	movl	-80(%ebp), %eax
	addl	$4088, %eax
	movl	$4194343, (%eax)
	movl	$0, 4(%eax)
	movl	$3145728, -84(%ebp)
	movl	-84(%ebp), %eax
	movl	$5242919, (%eax)
	movl	$0, 4(%eax)
	movl	$4194304, -88(%ebp)
	movl	-88(%ebp), %eax
	movl	$6291495, (%eax)
	movl	$0, 4(%eax)
	movl	-88(%ebp), %eax
	addl	$4088, %eax
	movl	$6291495, (%eax)
	movl	$0, 4(%eax)
	movl	$5242880, -92(%ebp)
	movl	-92(%ebp), %eax
	movl	$7340071, (%eax)
	movl	$0, 4(%eax)
	movl	-92(%ebp), %eax
	addl	$16, %eax
	movl	$11534375, (%eax)
	movl	$0, 4(%eax)
	movl	$6291456, -96(%ebp)
	movl	$10485799, -8(%ebp)
	movl	$0, -4(%ebp)
	movl	$0, -12(%ebp)
	jmp	.L2
.L3:
	movl	-12(%ebp), %eax
	addl	$256, %eax
	leal	0(,%eax,8), %edx
	movl	-96(%ebp), %eax
	leal	(%edx,%eax), %ecx
	movl	-8(%ebp), %eax
	movl	-4(%ebp), %edx
	movl	%eax, (%ecx)
	movl	%edx, 4(%ecx)
	addl	$1, -12(%ebp)
	addl	$4096, -8(%ebp)
	adcl	$0, -4(%ebp)
.L2:
	cmpl	$255, -12(%ebp)
	jle	.L3
	movl	$8388647, -16(%ebp)
	movl	$0, -20(%ebp)
	jmp	.L4
.L5:
	movl	-16(%ebp), %eax
	movl	-20(%ebp), %edx
	leal	0(,%edx,8), %ecx
	movl	-96(%ebp), %edx
	addl	%edx, %ecx
	cltd
	movl	%eax, (%ecx)
	movl	%edx, 4(%ecx)
	addl	$1, -20(%ebp)
	addl	$32768, -16(%ebp)
.L4:
	cmpl	$255, -20(%ebp)
	jle	.L5
	movl	$7340032, -100(%ebp)
	movl	$39, -32(%ebp)
	movl	$0, -28(%ebp)
	movl	$0, -36(%ebp)
	jmp	.L6
.L7:
	movl	-36(%ebp), %eax
	leal	0(,%eax,8), %edx
	movl	-100(%ebp), %eax
	leal	(%edx,%eax), %ecx
	movl	-32(%ebp), %eax
	movl	-28(%ebp), %edx
	movl	%eax, (%ecx)
	movl	%edx, 4(%ecx)
	addl	$1, -36(%ebp)
	addl	$4096, -32(%ebp)
	adcl	$0, -28(%ebp)
.L6:
	cmpl	$255, -36(%ebp)
	jle	.L7
	movl	-100(%ebp), %eax
	addl	$1472, %eax
	movl	$753711, (%eax)
	movl	$0, 4(%eax)
	movl	$9437223, -48(%ebp)
	movl	$0, -44(%ebp)
	movl	$0, -52(%ebp)
	jmp	.L8
.L9:
	movl	-52(%ebp), %eax
	addl	$256, %eax
	leal	0(,%eax,8), %edx
	movl	-100(%ebp), %eax
	leal	(%edx,%eax), %ecx
	movl	-48(%ebp), %eax
	movl	-44(%ebp), %edx
	movl	%eax, (%ecx)
	movl	%edx, 4(%ecx)
	addl	$1, -52(%ebp)
	addl	$4096, -48(%ebp)
	adcl	$0, -44(%ebp)
.L8:
	cmpl	$255, -52(%ebp)
	jle	.L9
	movl	$11534336, -104(%ebp)
	movl	$12582951, -64(%ebp)
	movl	$0, -60(%ebp)
	movl	$0, -68(%ebp)
	jmp	.L10
.L11:
	movl	-68(%ebp), %eax
	leal	0(,%eax,8), %edx
	movl	-104(%ebp), %eax
	leal	(%edx,%eax), %ecx
	movl	-64(%ebp), %eax
	movl	-60(%ebp), %edx
	movl	%eax, (%ecx)
	movl	%edx, 4(%ecx)
	addl	$1, -68(%ebp)
	addl	$4096, -64(%ebp)
	adcl	$0, -60(%ebp)
.L10:
	cmpl	$511, -68(%ebp)
	jle	.L11
	movl	$9437184, -108(%ebp)
	movl	$0, -72(%ebp)
	jmp	.L12
.L13:
	movl	-72(%ebp), %eax
	sall	$4, %eax
	movl	%eax, %edx
	movl	-108(%ebp), %eax
	addl	%edx, %eax
	movl	$524288, (%eax)
	movl	$3584, 4(%eax)
	movl	-72(%ebp), %eax
	sall	$4, %eax
	leal	8(%eax), %edx
	movl	-108(%ebp), %eax
	addl	%edx, %eax
	movl	$0, (%eax)
	movl	$0, 4(%eax)
	addl	$1, -72(%ebp)
.L12:
	cmpl	$255, -72(%ebp)
	jle	.L13
	nop
	nop
	leave
	ret