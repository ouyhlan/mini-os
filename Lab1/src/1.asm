; 程序源代码（stone.asm）
; 本程序在文本方式显示器上从左边射出一个*号,以45度向右下运动，撞到边框后反射,如此类推.
;  凌应标 2014/3
;   MASM汇编格式
     Dn_Rt equ 1                  ;D-Down,U-Up,R-right,L-Left
     Up_Rt equ 2                  ;
     Up_Lt equ 3                  ;
     Dn_Lt equ 4                  ;
     Still equ 5
     delay equ 50000					; 计时器延迟计数,用于控制画框的速度
     ddelay equ 580					; 计时器延迟计数,用于控制画框的速度
;     .386
     org 7c00h					; 程序加载到100h，可用于生成COM/7c00H引导扇区程序
;    ASSUME cs:code,ds:code
;   code SEGMENT
start:
	;xor ax,ax					; AX = 0   程序加载到0000：100h才能正确执行
    mov ax,cs
	mov es,ax					; ES = 0
	mov ds,ax					; DS = CS
	mov es,ax					; ES = CS
	mov ax,0B800h				; 文本窗口显存起始地址
	mov gs,ax					; GS = B800h
    mov byte[char],'A'
    jmp SetBackGround           ; 设置背景颜色
loop1:
	dec word[count]				; 递减计数变量
	jnz loop1					; >0：跳转;
	mov word[count],delay
	dec word[dcount]				; 递减计数变量
    jnz loop1
	mov word[count],delay
	mov word[dcount],ddelay

    mov al,1
    cmp al,byte[rdul]
	jz  DnRt
      mov al,2
      cmp al,byte[rdul]
	jz  UpRt
      mov al,3
      cmp al,byte[rdul]
	jz  UpLt
      mov al,4
      cmp al,byte[rdul]
	jz  DnLt
      jmp $	

DnRt:
    mov cx, 0x0

	inc word[x]
	inc word[y]
    mov bx,word[x]
	mov ax,25
	sub ax,bx
      jz  dr2ur
	mov bx,word[y]
	mov ax,80
	sub ax,bx
      jz  dr2dl
	jmp show
dr2ur:
      mov word[x],23
      mov byte[rdul],Up_Rt	
      jmp show
dr2dl:
      mov word[y],78
      mov byte[rdul],Dn_Lt	
      jmp show

UpRt:
	dec word[x]
	inc word[y]
	mov bx,word[y]
	mov ax,80
	sub ax,bx
      jz  ur2ul
	mov bx,word[x]
	mov ax,-1
	sub ax,bx
      jz  ur2dr
	jmp show
ur2ul:
      mov word[y],78
      mov byte[rdul],Up_Lt	
      jmp show
ur2dr:
      mov word[x],1
      mov byte[rdul],Dn_Rt	
      jmp show

	
	
UpLt:
	dec word[x]
	dec word[y]
	mov bx,word[x]
	mov ax,-1
	sub ax,bx
      jz  ul2dl
	mov bx,word[y]
	mov ax,-1
	sub ax,bx
      jz  ul2ur
	jmp show

ul2dl:
      mov word[x],1
      mov byte[rdul],Dn_Lt	
      jmp show
ul2ur:
      mov word[y],1
      mov byte[rdul],Up_Rt	
      jmp show

	
	
DnLt:
	inc word[x]
	dec word[y]
	mov bx,word[y]
	mov ax,-1
	sub ax,bx
      jz  dl2dr
	mov bx,word[x]
	mov ax,25
	sub ax,bx
      jz  dl2ul
	jmp show

dl2dr:
      mov word[y],1
      mov byte[rdul],Dn_Rt	
      jmp show
	
dl2ul:
      mov word[x],23
      mov byte[rdul],Up_Lt	
      jmp show
	
show:	
      xor ax,ax                 ; 计算显存地址
      mov ax,word[x]
	mov bx,80
	mul bx
	add ax,word[y]
	mov bx,2
	mul bx
	mov bx,ax

color:                          ; 设置字体颜色
    inc byte[fcolor]
    mov ah, [fcolor]
    cmp ah, 0x10
    jnz continue
    mov ah, 0x0
continue:
    mov [fcolor], ah
    add ah, [bcolor]

character:
    inc byte[acount]
    mov cl, [acount]
    cmp cl, 0x1a
    jnz show1
    mov cl,0x0
show1:
    mov [acount],cl
    mov al,byte[char]			;  AL = 显示字符值（默认值为20h=空格符）
	add al,cl
    mov [gs:bx],ax  		;  显示字符的ASCII码值
	jmp loop1

SetBackGround:
    mov cx, 0x7d0
    mov bx, 0x0
    mov ax, 0x3020
ls:
    mov [gs:bx],ax
    inc bx 
    inc bx
    loop ls
    jmp DisplayName

DisplayName:
    ; 设置背景色
    mov ah, 0x3f
    mov bx, 0x0
    ; 名字偏移值
    mov si, 0x0
ld:
    mov al, byte[id + si]
    cmp al, 0x0
    jz exitd
    mov [gs:bx],ax  		;  显示字符的ASCII码值
    inc si
    inc bx
    inc bx
    jmp ld
exitd:
    jmp loop1

end:
    jmp $                   ; 停止画框，无限循环 
	
datadef:	
    acount db 0x-1
    count dw delay
    dcount dw ddelay
    rdul db Dn_Rt         ; 向右下运动
    x    dw 7
    y    dw 0
    char db 'A'
    bcolor db 0x30
    fcolor db 0x0
    id db "18340133 Ouyang Haolan", 0x0
;code ENDS
;     END start

times 510-($-$$) db 0
                 db 0x55,0xaa