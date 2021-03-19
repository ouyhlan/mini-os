.section .data
str: .asciz "I am hungry now! Come and bring me some eat"
output: .ascii " "

.section .text
.extern Count
.global _start
_start:
    # Count(a, str)
    mov $'t', %rdi
    mov $str, %rsi
    call Count
    
    lea 0x30(%rax), %rax # +0x30是为了转换为ascii
    mov %al, output(%rip)

    # write(fd, str, len) 写入stdout文件就是输出
    mov $1, %rax    # system call 1 write
    mov $1, %rdi    # fd = 1 stdout
    lea output(%rip), %rsi
    mov $1, %rdx    # len = 1
    syscall

    # exit(0)
    mov $60, %rax   # system call 60 exit 返回Linux系统
    xor %rdi, %rdi  # return 0;
    syscall