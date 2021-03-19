本文件夹构成如下

- dos 
  - 1.asm
  - 1.com

- include
  - asm.h 引导程序boot.S的头文件
  - 1.h 系统内核头文件（里面是一些驱动程序的函数声明体）

- boot
  - boot.S 引导程序
  - puts.c 一些长模式下的驱动
  - SetPageTable.c 建立页表源文件
  - boot.o
  - puts.o
  - SetPageTable.S
  - boot.bin 最终链接后生成的引导程序
- kern
  - shell.c 系统shell
  - main.S 系统内核入口，用于调用1.c里的函数
  - driver.c 驱动程序
  - shell.o
  - driver.o
  - main.o
  - kernal.bin 生成的系统内核二进制文件
- user_program
  - user1.c
  - user2.c
  - user3.c
  - user4.c
  - user1.o
  - user2.o
  - user3.o
  - user4.o
  - user1,.bin
  - user2.bin
  - user3.bin
  - user4.bin

- img
  - os1.img 原型操作系统磁盘映像文件

文件夹dos是实验内容一的源代码（在dos系统的无敌风火轮com程序）

文件夹include是存放所有的头文件

文件夹boot是引导程序源代码及编译后的文件。

文件夹kern存放的是系统内核的文件。

文件夹user_program是4个用户程序及编译后的文件。

文件夹img存放磁盘映像文件（如果想要正确运行，必须采用支持64位长模式的虚拟机！）

bochsrc.bxsrc是bochs的配置文件

Makefile是本项目的Makefile