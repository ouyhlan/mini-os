本文件夹构成如下

- boot
  - asm.h 引导程序boot.S的头文件
  - boot.S 引导程序
  - puts.c 一些长模式下的驱动
  - SetPageTable.c 建立页表源文件
  - boot.o
  - puts.o
  - SetPageTable.S
  - boot2.bin 最终链接后生成的引导程序
- kern
  - 1.h 系统内核头文件（里面是一些驱动程序的函数声明体）
  - 1.c 系统内核主要执行部分
  - main.S 系统内核入口，用于调用1.c里的函数
  - driver.c 驱动程序
  - 1.o
  - driver.o
  - main.o
  - main.bin 生成的系统内核二进制文件
- test
  - 1.c 用来观察gcc编译的摸板程序
  - AsCount.S 计算字符串的汇编程序
  - count.c 计算字符串的C语言程序
  - count 最终Linux下可执行的文件

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

文件夹boot是引导程序源代码及编译后的文件。

文件夹kern存放的是系统内核的文件。

文件夹test对应实验内容1和2的一些模板程序

文件夹user_program是4个用户程序及编译后的文件。

hd10m.img是所采用的磁盘映像文件（如果想要正确运行，必须采用支持64位长模式的虚拟机！）

bochsrc.bxsrc是bochsdbg.exe的配置文件