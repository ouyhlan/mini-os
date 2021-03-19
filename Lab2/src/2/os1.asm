;程序源代码（os1.asm）
; 用户程序存放位置（磁盘号）
    com_1 equ 3
    com_2 equ 4
    com_3 equ 5
    com_4 equ 6

org  7c00h              ; 引导区程序 需要在0:7c00h上执行
;org  100h
;org 0h

		; BIOS将把引导扇区加载到0:7C00h处，并开始执行

Start:
	mov	ax, cs	       ; 置其他段寄存器值与CS相同
	mov	ds, ax	       ; 数据段
    mov es, ax
    mov ss, ax         ; 堆栈段
    mov ax,0B800h				; 文本窗口显存起始地址
	mov gs,ax					; GS = B800h
    mov sp, 0          ; 初始化堆栈地址
    
    jmp SetBackGround  ; 设置终端背景颜色
Welcoming:
	mov	bp, WelcomingMessage		 ; BP=当前串的偏移地址
	mov	ax, ds		 ; ES:BP = 串地址
	mov	es, ax		 ; 置ES=DS
	mov	cx, WelcomingMessageLength  ; CX = 串长（=9）
	mov	ax, 1301h		 ; AH = 13h（功能号）、AL = 01h（光标置于串尾）
	mov	bx, 0031h		 ; 页号为0(BH = 0) 
    mov dh, 0		       ; 行号=0
	mov	dl, 0			 ; 列号=0
	int	10h			 ; BIOS的10h功能：显示一行字符
    jmp Input
LoadnEx:
     ;读软盘或硬盘上的若干物理扇区到内存的ES:BX处：
      mov ax,cs                ;段地址 ; 存放数据的内存基地址
      mov es,ax                ;设置段地址（不能直接mov es,段地址）
      mov bx,8100h             ;偏移地址; 存放数据的内存偏移地址 0:8100h和800:100h相同
      mov ah,2                 ; 功能号
      mov al,1                 ;扇区数
      mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
      mov dh,0                 ;磁头号 ; 起始编号为0
      mov ch,0                 ;柱面号 ; 起始编号为0
      ;mov cl,3                 ;起始扇区号 起始编号为1 2用来存放用户程序信息 
      int 13H ;                调用读磁盘BIOS的13h功能
      ; 用户程序已加载到指定内存区域中
      call 800h:0100h             ;修复一个bug
      jmp Start                 ;回到监控程序继续执行

SetBackGround:
    mov cx, 0x7d0
    mov bx, 0x0
    mov ax, 0x3020
ls:
    mov [gs:bx],ax
    inc bx 
    inc bx
    loop ls
    jmp Welcoming

Input:                          ; 输入函数 选择执行的程序
    mov bp, 0
    mov bx, 0030h

I1:
    mov ah, 0
    int 16h                     ; 等待按键输入
    cmp al, 0dh                 ; 回车进入选择阶段
    jz Select
    mov [inputbuf + bp], al
    inc bp
Echo:
    mov cx, 1
    mov ah, 0ah
    int 10h                     ; 同步回显
    mov ah, 03h                 ; 移动光标
    int 10h
    inc dl
    mov ah,02h
    int 10h
    jmp I1                      

Select:
    mov al, [inputbuf]
    cmp al, 'q'
    jz Exit

    cmp al, '1'
    mov cl, com_1
    jz LoadnEx
    
    cmp al, '2'
    mov cl, com_2
    jz LoadnEx

    cmp al, '3'
    mov cl, com_3
    jz LoadnEx

    cmp al, '4'
    mov cl, com_4
    jz LoadnEx 
Exit:

       mov  ah, 03h
       int  10h
       inc  dh                         ; 获取当前行号，切换到下一行
       mov  dl, 0			           ; 列号=0
       mov	bp, ExitMessage	           ; BP=当前串的偏移地址
       mov	ax, ds		               ; ES:BP = 串地址
       mov	es, ax		               ; 置ES=DS
       mov	cx, ExitMessageLength      ; CX = 串长（=9）
       mov	ax, 1301h		           ; AH = 13h（功能号）、AL = 01h（光标置于串尾）
       mov	bx, 0031h		           ; 页号为0(BH = 0) 
       int	10h			               ; BIOS的10h功能：显示一行字符
       jmp $                           ; 无限循环

data:
    WelcomingMessage db "  Hello, this is ouyhlan's monitor program! The following is the user programs which you can use: ", 0dh, 0ah, "1.com    2.com   3.com   4.com", 0dh, 0ah, "os1> "
    WelcomingMessageLength  equ ($-WelcomingMessage)

    ExitMessage db "[Program Exited Normly]"
    ExitMessageLength equ ($-ExitMessage)
    inputbuf db 0, 0, 0, 0, 0
      times 510-($-$$) db 0
      db 0x55,0xaa

