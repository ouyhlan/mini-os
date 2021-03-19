*因为这次源文件有点多，我把中间生成的obj文件去掉了，这样看起来更加方便一点*

本文件夹构成如下

- include
  - asm.h 引导程序boot.S的头文件
  - driver.h 系统内核头文件（里面是一些驱动程序的函数声明体）
  - libc.h 库函数声明头文件（对应libc.c）
  - mem.h 内存管理头文件
- boot
  - boot1.S 引导程序1
  - boot2.S 引导程序2
  - boot3.S 引导程序3
  - ReadSect.c 加载系统内核源文件
  - SetPageTable.c 建立页表源文件
- kern
  - main.S 系统内核入口，进行一些类似于中断初始化的操作
  - driver.c 系统内核代码
  - alltrap.S 保存save和restart函数文件
- user_program
  - shell.c shell源代码
  - user1.c
  - user2.c
  - user3.c
- user4.c
- libs
  - exec.c
  - exit.c
  - getchar.c
  - gets.c
  - libc.c
  - multiexec.c
  - printf.c
  - putc.c
  - puts.c
  - scanf.c
  - strlen.c
- strncmp.c
- img
  - os1.img 原型操作系统磁盘映像文件

文件夹include是存放所有的头文件

文件夹boot是引导程序源代码。

文件夹kern存放的是系统内核的文件。

文件夹user_program是4个用户程序。

文件夹libs存放着C库。

文件夹img存放磁盘映像文件（如果想要正确运行，必须采用支持64位长模式的虚拟机！）

bochsrc.bxsrc是bochs的配置文件

Makefile是本项目的Makefile



