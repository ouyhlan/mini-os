.section .text
.extern Welcoming
.global _start
.extern InitKeyboard
_start:
.code64
    push %rbp
    movq %rsp, %rbp

setint_8259:
    movb $0x11, %al     # ICW1
    out %al, $0x20  
    out %al, $0xa0

    movb $0x20, %al     # master ICW2
    out %al, $0x21
    
    movb $0x28, %al     # slave ICW2
    out %al, $0xa1

    movb $0x04, %al     # master ICW3
    out %al, $0x21

    movb $0x02, %al     # slave ICW3
    out %al, $0xa1

    movb $0x01, %al     # ICW4
    out %al, $0x21
    out %al, $0xa1

    movb $0xfd, %al
    out %al, $0x21      # 屏蔽中断

    movb $0xff, %al     # 屏蔽从8259的所有中断
    out %al, $0xa1
    

    call InitKeyboard
    call Welcoming
    pop %rbp
spin:
    jmp spin

