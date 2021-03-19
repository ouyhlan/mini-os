#include "1.h"
#define SECT_SIZE 512
#define NO 0
#define KEYBOARD_IRQ 0x21

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

/* 输入设置的中断向量号及对应的中断向量例程 */
void SetInterupt(unsigned short int_num, void *func) {
    __asm__("cli\n\t");                         /* 关闭中断 */
    unsigned long long *idt_addr = 0x100000;
    unsigned long long func_addr = (unsigned long long)func;
    idt_addr[int_num * 2] = (func_addr & 0xffff) | (((func_addr >> 16) & 0xffff) << 48) | 0x8e0000080000;
    idt_addr[int_num * 2 + 1] = ((func_addr >> 32) & 0xffffffff);
    //__asm__("sti\n\t");
}

static char normalmap[256] = {
    NO,   0x1B, '1',  '2',  '3',  '4',  '5',  '6',  // 0x00
    '7',  '8',  '9',  '0',  '-',  '=',  '\b', '\t',
    'q',  'w',  'e',  'r',  't',  'y',  'u',  'i',  // 0x10
    'o',  'p',  '[',  ']',  '\n', NO,   'a',  's',
    'd',  'f',  'g',  'h',  'j',  'k',  'l',  ';',  // 0x20
    '\'', '`',  NO,   '\\', 'z',  'x',  'c',  'v',
    'b',  'n',  'm',  ',',  '.',  '/',  NO,   '*',  // 0x30
    NO,   ' ',  NO,   NO,   NO,   NO,   NO,   NO,
    NO,   NO,   NO,   NO,   NO,   NO,   NO,   '7',  // 0x40
    '8',  '9',  '-',  '4',  '5',  '6',  '+',  '1',
    '2',  '3',  '0',  '.',  NO,   NO,   NO,   NO   // 0x50
};

static char shiftmap[256] = {
    NO,   033,  '!',  '@',  '#',  '$',  '%',  '^',  // 0x00
    '&',  '*',  '(',  ')',  '_',  '+',  '\b', '\t',
    'Q',  'W',  'E',  'R',  'T',  'Y',  'U',  'I',  // 0x10
    'O',  'P',  '{',  '}',  '\n', NO,   'A',  'S',
    'D',  'F',  'G',  'H',  'J',  'K',  'L',  ':',  // 0x20
    '"',  '~',  NO,   '|',  'Z',  'X',  'C',  'V',
    'B',  'N',  'M',  '<',  '>',  '?',  NO,   '*',  // 0x30
    NO,   ' ',  NO,   NO,   NO,   NO,   NO,   NO,
    NO,   NO,   NO,   NO,   NO,   NO,   NO,   '7',  // 0x40
    '8',  '9',  '-',  '4',  '5',  '6',  '+',  '1',
    '2',  '3',  '0',  '.',  NO,   NO,   NO,   NO   // 0x50
};

/* 设置键盘输入缓冲区 */
char inputbuf[32] = {0};
char output = 0;

void KbHandler() {
    unsigned char scan_code = inp(0x60);
    /* 暂时不支持大写输入 */
    if (scan_code < 0x80) {
        char ch = normalmap[scan_code];
        output = ch;
    }
    __asm__("movb $0x20, %al\n\t");
    __asm__("out %al, $0x20\n\t");
    __asm__("nop\n\tleaveq\n\tiretq\n\t");
}

void InitKeyboard() {
    SetInterupt(KEYBOARD_IRQ, KbHandler);
}

char getchar() {
    output = 0;
    __asm__("sti\n\t");
    while (output == 0) {
        int a;
        for (int i = 0; i < 1000000; ++i) {
            a++;
        }
        /* do nothing */;
    }
    __asm__("cli\n\t");
    return output;
}

void gets(char *buf) {
    int buf_index = 0;
    for (char ch = getchar(); ch != '\n'; ch = getchar()) {
        buf[buf_index++] = ch;
        putc(ch);
    }
    putc('\n');
    buf[buf_index] = '\0';
}

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

void ScrollUp() {
    CurPosition cur_pos = GetCurPos();
    unsigned short *vga_addr = 0xb8000;     /* 两个字节为基本单位 */
    for (int i = 0; i < 24 * 80; ++i) {
        vga_addr[i] = vga_addr[i + 80];
    }
    for (int i = 24 * 80; i < 25 * 80; ++i) {
        vga_addr[i] = 0x3020;
    }
    cur_pos.y--;                            /* 光标随之上移一行 */                        
    SetCurPos(cur_pos);
}

/* 显示一个字符 */
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
        vga_addr[ch_pos + 1] = 0x31;
        ++cur_pos.x;
    }
    SetCurPos(cur_pos);
    
    /* 当当前显示超出25 * 80这个范围时,整体滚屏上移 */
    if (cur_pos.y * 80 + cur_pos.x >= 25 * 80) {
        ScrollUp();
    }
}

/* 显示一段字符串 */
void puts(char *str) {
    int index = 0;
    while (str[index] != '\0') {
        putc(str[index++]);
    }
}


/* 因为不采取中断提示方式，这里采用了轮询方式查看硬盘是否空闲 */
void WaitDisk() {
    while ((inp(0x1f7) & 0xC0) != 0x40)
        /* 等待硬盘空闲 */;
}

/* 入口参数: dst:目的内存地址（线性地址） sec_no:在硬盘的扇区号 num_of_sec:要连续读取的扇区数 */
void readsect(void *dst, int sec_no, short num_of_sec) {
    // wait for disk to be ready
    WaitDisk();

    outp(0x1f2, num_of_sec);                    /* 设置读取扇区数 */
    outp(0x1f3, sec_no & 0xff);
    outp(0x1f4, (sec_no >> 8) & 0xff);
    outp(0x1f5, (sec_no >> 16) & 0xff);
    outp(0x1f6, ((sec_no >> 24) & 0xf) | 0xe0);
    outp(0x1f7, 0x20);                          /* 设置LBA模式 */

    /* 等待硬盘空闲 */
    WaitDisk();

    /* 一次读完全部到指定地址 */
    insl(0x1f0, dst, SECT_SIZE * num_of_sec / 4);
}
