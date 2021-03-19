#define SECTSIZE 512

int inp(int port) {
    int res;
    asm(   "mov %1, %%edx\n\t"
                "in %%dx, %%al\n\t"
                "movl %%eax, %0\n\t"
                :"=r"(res)
                :"r"(port)
                :"%rdx", "%rax"
    );
    return res;
}
void outp(int port, int info) {
    asm(    "movl %0, %%edx\n\t"
            "movl %1, %%eax\n\t"
            "out %%al, %%dx\n\n"
            :
            :"r"(port), "r"(info)
            :"%rax", "%rdx"
            );
}

void insl(short port, void *des, unsigned long long len) {
    asm(    "cld\n\t"
            "movq %2, %%rcx\n\t"
            "movq %1, %%rdi\n\t"
            "movw %0, %%dx\n\t"
            "rep insl\n\t"
            :
            :"r"(port), "r"(des), "r"(len)
            :
    );
}

typedef struct CurPosition {
    int x, y;
} CurPosition;

CurPosition GetCurPos() {
    unsigned short temp = 0;
    CurPosition res;
    outp(0x3d4, 14);
    temp = (inp(0x3d5) & 0xff) << 8;     /* 光标位置高八位 */
    outp(0x3d4, 15);
    temp += inp(0x3d5);     /* 光标位置低八位 */
    res.x = temp % 80; 
    res.y = temp / 80;
    return res;
}

void SetCurPos(CurPosition point_pos) {
    unsigned short pos = point_pos.y * 80 + point_pos.x;
    outp(0x3d4, 14);
    outp(0x3d5, (pos >> 8) & 0xff);     /* 设置光标高八位 */
    
    outp(0x3d4, 15);
    outp(0x3d5, pos & 0xff);            /* 设置光标低八位 */

}

void putc(char c) {
    unsigned char *vga_addr = 0xb8000;
    CurPosition cur_pos = GetCurPos();
    if (c == '\n') {
        cur_pos.x = 0;                  /* 回车 */
        ++cur_pos.y;                    /* 换行 */
    }
    else {
        unsigned int ch_pos = (cur_pos.y * 80 + cur_pos.x) << 1;
        vga_addr[ch_pos] = c;
        vga_addr[ch_pos + 1] = 0x07;
        ++cur_pos.x;
    }
    SetCurPos(cur_pos);
}

void puts(char *str) {
    int index = 0;
    while (str[index] != '\0') {
        putc(str[index++]);
    }
}

void WaitDisk() {
    while ((inp(0x1f7) & 0xC0) != 0x40)
        /* 等待硬盘空闲 */;
}

void readsect(void *dst, int secno, short num_of_sec) {
    // wait for disk to be ready
    WaitDisk();

    outp(0x1f2, num_of_sec);                    /* 设置读取扇区数 */
    outp(0x1f3, secno & 0xff);
    outp(0x1f4, (secno >> 8) & 0xff);
    outp(0x1f5, (secno >> 16) & 0xff);
    outp(0x1f6, ((secno >> 24) & 0xf) | 0xe0);
    outp(0x1f7, 0x20);                          /* 设置LBA模式 */

    /* 等待硬盘空闲 */
    WaitDisk();

    /* 一次读完全部到指定地址 */
    insl(0x1f0, dst, SECTSIZE * num_of_sec / 4);
}
