CC = gcc
LD = ld
OBJDUMP = objdump
CFLAGS = -ffreestanding -I ./include -mgeneral-regs-only 
LINKFLAGS = --oformat binary
BOOTFLAGS = -Ttext 0x7c00
KERNALFLAGS = -Ttext 0xffff800000000000 -Tdata 0xffff800000001000 
USERFLAGS = -Ttext 0x400000 -Tdata 0x4005b0

output = img/os1.img
boot_obj = boot.o puts.o
kernal_obj = main.o shell.o driver.o
user_obj = user1.o user2.o user3.o user4.o
user_bin = user1.bin user2.bin user3.bin user4.bin

# all the file object
obj = boot
obj += kernal
obj += user

# file offset
boot_offset = 0
kernal_offset = 5
user1_offset = 16
user2_offset = 19
user3_offset = 22
user4_offset = 25

# File Search
vpath %.h ./include
vpath %.c ./boot:./kern:./user_program
vpath %.S ./boot:./kern
vpath %.img ./img

run:all
	bochs -f bochsrc.bxrc

# make disk file
all:$(obj)
	dd if=boot.bin of=$(output) bs=512 seek=$(boot_offset) conv=notrunc;\
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
boot:$(boot_obj)
	$(LD) $(LINKFLAGS) $(BOOTFLAGS) $(boot_obj) -o boot.bin

# Link kernal program
kernal:$(kernal_obj)
	$(LD) $(LINKFLAGS) $(KERNALFLAGS) $(kernal_obj) -o kernal.bin

# Link user program
user:$(user_bin)

# Debug
kernal_debug:$(kernal_obj)
	$(LD) $(KERNALFLAGS) $(kernal_obj) -o kernal_debug.bin;\
	$(OBJDUMP) -d kernal_debug.bin

$(user_bin):%.bin:%.o
	$(LD) $(LINKFLAGS) $(USERFLAGS) $< -o $@

# Dependency
driver.o: driver.c 1.h
main.o: main.S 1.h
boot.o: boot.S asm.h


# ASM program compile rule
%.o: %.S
	$(CC) -c $(CFLAGS) $< -o $@

# C program compile rule
%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

# Clean all the obj file
.PHONY:clean
clean:
	-rm -f */*.o
	-rm -f *.o
	-rm -f *.bin
	-rm -f */*.out