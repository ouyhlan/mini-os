CC = gcc
LD = ld
OBJDUMP = objdump
CFLAGS = -ffreestanding -I ./include -mgeneral-regs-only
x86_CFLAGS = -m32 -ffreestanding -fno-pic -I ./include
x86_LINKFLAGS = -melf_i386 --oformat binary
LINKFLAGS = --oformat binary
BOOT1FLAGS = -Ttext 0x7c00
BOOT2FLAGS = -Ttext 0x7e00
BOOT3FLAGS = -Ttext 0x8200
KERNALFLAGS = -Ttext 0xffff800000000000 -Tdata 0xffff800000002000 -Tbss 0xffff800000001c00 -static
USERFLAGS = -Ttext 0x400000 -Tdata 0x400600 -static

output = img/os1.img
boot1_obj = boot1.o
boot2_obj = boot2.o SetPageTable.o
boot3_obj = boot3.o ReadSect.o
kernal_obj = main.o shell.o driver.o alltrap.o
user_obj = user1.o user2.o user3.o user4.o
libc_obj = exec.o exit.o scanf.o getchar.o gets.o printf.o putc.o puts.o strlen.o strncmp.o
user_bin = user1.bin user2.bin user3.bin user4.bin

# all the file object
obj = boot1
obj += boot2
obj += boot3
obj += kernal
obj += user

# file offset
boot1_offset = 0
boot2_offset = 1
boot3_offset = 3
kernal_offset = 5
user1_offset = 32
user2_offset = 36
user3_offset = 40
user4_offset = 44

# File Search
vpath %.h ./include
vpath %.c ./boot:./kern:./user_program:./libs
vpath %.S ./boot:./kern
vpath %.img ./img


run:all
	bochs -f bochsrc.bxrc

# make disk file
all:$(obj)
	dd if=boot1.bin of=$(output) bs=512 seek=$(boot1_offset) conv=notrunc;\
	dd if=boot2.bin of=$(output) bs=512 seek=$(boot2_offset) conv=notrunc;\
	dd if=boot3.bin of=$(output) bs=512 seek=$(boot3_offset) conv=notrunc;\
	dd if=kernal.bin of=$(output) bs=512 seek=$(kernal_offset) conv=notrunc;\
	dd if=user1.bin of=$(output) bs=512 seek=$(user1_offset) conv=notrunc;\
	dd if=user2.bin of=$(output) bs=512 seek=$(user2_offset) conv=notrunc;\
	dd if=user3.bin of=$(output) bs=512 seek=$(user3_offset) conv=notrunc;\
	dd if=user4.bin of=$(output) bs=512 seek=$(user4_offset) conv=notrunc;\

backup:$(obj)
	cp -r ./ ../os_backup;\
	cd ../os_backup;\
	rm -f */*.o;\
	rm -f *.o;\
	rm -f *.bin;\
	rm -f */*.out;\

# Link boot program
boot1:$(boot1_obj)
	$(LD) $(x86_LINKFLAGS) $(BOOT1FLAGS) $(boot1_obj) -o boot1.bin

boot2:$(boot2_obj)
	$(LD) $(x86_LINKFLAGS) $(BOOT2FLAGS) $(boot2_obj) -o boot2.bin

boot3:$(boot3_obj)
	$(LD) $(LINKFLAGS) $(BOOT3FLAGS) $(boot3_obj) -o boot3.bin

# Link kernal program
kernal:$(kernal_obj)
	$(LD) $(LINKFLAGS) $(KERNALFLAGS) $(kernal_obj) libc.a -o kernal.bin

# Link user program
user:$(user_bin)

# Debug
kernal_debug:$(kernal_obj)
	$(LD) $(KERNALFLAGS) $(kernal_obj) libc.a -o kernal_debug.bin;\
	$(OBJDUMP) -d kernal_debug.bin

$(user_bin):%.bin:%.o
	$(LD) $(LINKFLAGS) $(USERFLAGS) $< libc.a -o $@

# Dependency
driver.o: driver.c driver.h
main.o: main.S
boot.o: boot.S asm.h
shell.o:libc.a libc.h
# libc.a: libc.c libc.h
user1.bin: libc.a
user2.bin: libc.a
user3.bin: libc.a
user4.bin: libc.a

# ASM program compile rule
%.o: %.S
	$(CC) -c $(CFLAGS) $< -o $@

# C program compile rule
%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@


libc.a:$(libc_obj)
	ar rcs -o libc.a $(libc_obj)

boot1.o: boot1.S asm.h
	$(CC) -c $(x86_CFLAGS) boot/boot1.S -o boot1.o

boot2.o: boot2.S
	$(CC) -c $(x86_CFLAGS) boot/boot2.S -o boot2.o

SetPageTable.o: SetPageTable.c
	$(CC) -c $(x86_CFLAGS) boot/SetPageTable.c -o SetPageTable.o

#%.a: %.c
#	$(CC) -c $(CFLAGS) $< -o $@

# Clean all the obj file
.PHONY:clean
clean:
	-rm -f */*.o
	-rm -f *.o
	-rm -f *.bin
	-rm -f */*.out
	-rm -f *.a