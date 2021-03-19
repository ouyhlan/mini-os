#ifndef __ONE_H__
#define __ONE_H__
#define SECTSIZE 512

int inb(int port);
void outb(int port, int info);
void insl(short port, void *des, unsigned long long len);
typedef struct CurPosition {
    int x, y;
} CurPosition;
CurPosition GetCurPos();
void SetCurPos(CurPosition point_pos);
void putc(char c);
void puts(char *str);
void WaitDisk();
void readsect(void *dst, int secno, short num_of_sec);
char getchar();
void gets(char *buf);
#endif